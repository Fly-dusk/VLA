# Piper 机械臂多视角示教采集与视觉模仿学习

基于 Isaac Sim / Isaac Lab，在 Piper 方块堆叠示教采集项目上扩展多视角 RGB 数据生成、语言标注、LeRobot-style 数据组织、BC 与 ACT-style Transformer 训练及仿真闭环评估。

本项目的重点是贯通“自动示教 → 视觉数据构建 → 模仿学习 → 闭环验证”的工程流程。已有训练与评估记录，但当前保存的闭环结果尚未达到完整堆叠成功；真实 Piper 部署属于后续工作，当前材料不包含可验证的真机迁移结果。

## 1. 项目来源与工作范围

直接源项目为 [szyzp/IsaacLab_Data_Collection](https://github.com/szyzp/IsaacLab_Data_Collection)。上游提供 Piper / Nero 方块堆叠环境、遥操作、自动示教采集与回放能力。本地 Git remote 和服务器克隆记录均指向该仓库。

本地扩展流程包括：

- 回放低维轨迹，生成固定视角和末端跟随视角的 RGB 图像。
- 将图像与机器人状态、动作按时间步组织，并支持动作执行前渲染。
- 添加语言指令，导出 HDF5-backed VLA manifest 和 LeRobot-style 元数据。
- 训练单步 RGB BC、语言条件 BC 与 Transformer 动作分块策略。
- 比较普通状态、方块位姿特权状态、任务进度条件等设置。
- 保存闭环 rollout 结果与视频，分析抓取、释放、阶段切换和动作执行长度问题。

这里的 ACT-style 指借鉴动作分块思想的 Transformer 策略，未完整复现原版 ACT。LeRobot-style 指字段组织与元数据映射，未完成标准 Parquet/MP4 数据集转换；语言条件接口也不代表预训练 VLA 基础模型。

## 2. 环境与目录

历史实验记录使用 Isaac Sim 4.5、Isaac Lab 2.3.0，Conda 环境名称为 `isaaclab23`。本地 `code/IsaacLab/VERSION` 为 `2.3.0`。这是已有实验环境记录，不代表任意全新安装均可直接兼容；上游当前安装说明可能已使用其他版本。

Isaac Sim 负责物理仿真、碰撞、接触与图像渲染；Isaac Lab 负责环境组织、动作和观测接口、任务重置、成功判定及记录器。策略训练由项目中的 PyTorch 脚本完成。

```text
.
├── readme.md
├── code/
│   ├── IsaacLab/                       # 仿真任务框架
│   ├── IsaacLab_v2.1_backup/           # 旧版本备份，非主要实验入口
│   └── IsaacLab_Data_Collection/
│       ├── source/agx_teleop/          # 任务扩展及机器人资产
│       ├── scripts/tools/             # 采集、回放、渲染与格式导出
│       ├── scripts/train/             # BC / ACT-style 训练
│       ├── scripts/eval/              # 闭环评估
│       ├── docs/                      # 阶段性说明
│       └── interview_qa.md            # 项目复盘笔记
├── data/IsaacLab_Data_Collection/
│   ├── datasets/                      # HDF5 示教
│   ├── lerobot_exports/               # LeRobot-style 元数据
│   ├── vla_exports/                   # ACT-style 数据索引、统计信息
│   ├── runs/                          # 配置、训练指标和模型文件
│   ├── eval/                          # 闭环评估汇总
│   ├── previews/                      # 图像预览
│   └── videos/                        # 回放与评估视频
└── isaacsim/                          # 历史仿真器安装目录
```

仿真器和框架目录属于外部依赖，不属于项目原创代码。安装目录的复制也不能替代依赖安装与环境配置。

## 3. 自动示教如何实现

入口：[record_ik_stack.py](code/IsaacLab_Data_Collection/scripts/tools/record_ik_stack.py)，控制器为 `IKStackController`。主要任务名为 `Isaac-Stack-Cube-Piper-IK-Rel-v0`。

控制器直接读取仿真中的三个方块位置，以第一个方块为底座，依次搬运另外两个方块。每次搬运分为：

1. 移到待抓方块上方。
2. 下探到抓取位置。
3. 闭合夹爪并停留。
4. 抬升方块。
5. 移到目标堆叠位置上方。
6. 下降至放置位置。
7. 松开夹爪。
8. 向上撤离。

程序将这些阶段转成位置关键点，采用三次 Hermite 形式插值生成中间轨迹。虽然代码注释使用 “PCHIP-style” 描述，这里不是调用标准 PCHIP 库函数。

每步根据目标末端位置与当前末端位置之差，生成七维动作：

```text
action = [Δx, Δy, Δz, Δrx, Δry, Δrz, gripper]
```

示教器的旋转增量设为零；夹爪 `+1` 表示打开，`-1` 表示闭合。环境中的相对 IK 动作接口负责把末端控制指令转换为关节目标。

控制器使用仿真真值规划轨迹，并读取当前末端位置进行误差反馈，不依赖图像识别方块。它是生成训练数据的程序化专家，与后续学习得到的视觉策略应分开理解。

通过 `ActionStateRecorderManagerCfg` 记录动作和状态，导出模式为 `EXPORT_SUCCEEDED_ONLY`。默认连续 10 步满足环境成功条件后保存示教；轨迹结束并等待一段时间仍未成功，则重置并重新规划。

## 4. 多视角 RGB 数据生成与对齐

入口：[render_camera_dataset.py](code/IsaacLab_Data_Collection/scripts/tools/render_camera_dataset.py)。

主要流程是先保存低维示教，再恢复每条轨迹的初始状态并重放动作，渲染对应图像。后期流水线先生成固定视角数据，再单独回放生成末端跟随视角，并合并到同一 HDF5 文件。

| 视角 | 实现 | 作用 |
|---|---|---|
| `static_rgb` | 使用固定 `eye` 和 `target` 设置 viewport 相机 | 提供整体布局与堆叠关系 |
| `wrist_rgb` | 根据记录的 `eef_pos` 加上偏移，动态更新 `eye` 和 `target` | 提供夹爪附近的局部视野 |

`wrist_rgb` 的偏移定义在世界坐标系中，没有随末端姿态旋转。因此它是末端位置跟随视角，与真实刚性安装的 eye-in-hand 相机存在差异。

后期 close-256 设置采用：

```text
static_eye    = [0.78, -0.38, 0.48]
static_target = [0.45,  0.00, 0.04]
图像尺寸       = 256 × 256
```

训练需要 `observation[t] → action[t]`，因此后期流水线明确指定 `--render_timing before_step`，先渲染，再执行同索引动作。渲染脚本默认是 `after_step`，复现实验时不能遗漏这个区别。

渲染过程包含预热、空白/黑帧重试与图像缩放；流水线还检查图像是否长期不变。回放通过“恢复初始状态＋重放动作”进行，并非逐帧强制恢复录制状态，因此仍需检查物理回放偏差以及图像、状态、动作的一致性。

## 5. 数据版本与规模

以下数字来自保存的 manifest 和实验配置：

| 版本 | 示教数 | 时间步总数 | 每路图像尺寸 | 用途 |
|---|---:|---:|---|---|
| 早期双视角数据 | 20 | 9,040 | 84×84 | 流程验证及 BC 基线 |
| 扩展对齐版本 | 100 | 45,200 | 84×84 | 扩大数据规模及对齐实验 |
| close-256 版本 | 50 | 22,600 | 256×256 | 后期重点实验 |

每条示教约 452 个时间步，每个时间步包含两路 RGB。22,600 是时间步数量，对应两路共 45,200 张图像。

50 条 close-256 使用已有 100 条低维数据中的前 50 条重新渲染，并非新增的 50 条独立示教。语言标注、视角变化和 privileged 导出也不增加独立轨迹数量，不能把这些版本直接相加。

来源：[50 条流水线](code/IsaacLab_Data_Collection/scripts/tools/run_50demos_close256_pipeline.sh)、[50 条 manifest](data/IsaacLab_Data_Collection/vla_exports/piper_stack_vla_50_close_256/manifest.json)、[100 条 manifest](data/IsaacLab_Data_Collection/vla_exports/piper_stack_vla_100_aligned/manifest.json)。

## 6. 数据字段与 LeRobot-style 导出

### 6.1 原始 HDF5

```text
data/demo_0/
├── initial_state
├── actions                         [T, 7]
└── obs/
    ├── static_rgb                  [T, H, W, 3], uint8
    ├── wrist_rgb                   [T, H, W, 3], uint8
    ├── eef_pos
    ├── eef_quat
    ├── gripper_pos
    ├── joint_pos
    ├── joint_vel
    └── language_instruction        标量字符串
```

普通状态为 25 维：末端位置 3 维、末端四元数 4 维、夹爪位置 2 维、关节位置 8 维、关节速度 8 维。privileged 配置额外引入 `cube_positions` 和 `cube_orientations`，得到 46 维状态，用于诊断视觉定位是否限制策略表现。这些仿真真值不能直接视作真实部署时可获得的观测。

语言指令为 `stack the cube with the Piper robot arm`。当前只有单任务、单指令，主要验证语言接口，不足以证明语言理解或多任务泛化。

### 6.2 LeRobot-style 元数据

入口：[export_lerobot_style_dataset.py](code/IsaacLab_Data_Collection/scripts/tools/export_lerobot_style_dataset.py)。

| 逻辑字段 | 内容 | close-256 单步形状 |
|---|---|---|
| `observation.images.static_rgb` | 固定视角图像 | `[3, 256, 256]` |
| `observation.images.wrist_rgb` | 末端跟随图像 | `[3, 256, 256]` |
| `observation.state` | 按 `state_keys` 拼接的状态 | `[25]` |
| `action` | 末端相对位姿与夹爪动作 | `[7]` |
| `language_instruction` | 任务文本 | 字符串 |

元数据声明图像为 CHW，原始 HDF5 保存为 HWC，数据加载时需转换。

导出文件包括：

- `meta/info.json`：源 HDF5 路径、数据集标识、机器人与任务名称、总轨迹数、总帧数、特征类型和形状。
- `meta/tasks.jsonl`：`task_index` 与任务文字描述。
- `meta/episodes.jsonl`：`episode_index`、`episode_key`、`task_index`、`length`、`success`、`hdf5_paths`。
- `README.md`：字段映射说明。

`fps=60` 是导出参数写入的名义帧率，不能据此认定采集循环实际以 60 Hz 运行；需要结合仿真时间步和控制配置核对。`success` 表示示教成功，与策略闭环成功率无关。

这套导出不会复制图像，不包含完整 Parquet/MP4 数据。使用时必须保留源 HDF5，并修改其中已失效的服务器绝对路径。

### 6.3 ACT-style 训练索引

[export_vla_manifest.py](code/IsaacLab_Data_Collection/scripts/tools/export_vla_manifest.py) 另外生成 `manifest.json`、`episodes.jsonl`、`stats.json` 和 `sample_shapes.json`。

训练加载器从单步动作中动态切片生成：

```text
action_chunk = actions[t:t+20]      # [20, 7]
action_is_pad                      # [20]，标记轨迹末尾的补齐位置
```

动作块与 padding mask 属于配套训练数据处理，不是上述 LeRobot-style 导出脚本中额外保存的逐帧列。

## 7. 模型与训练

### 7.1 RGB BC

入口：[train_rgb_bc.py](code/IsaacLab_Data_Collection/scripts/train/train_rgb_bc.py)。

用视觉特征和机器人状态监督预测专家动作，支持单视角、双视角、可选语言条件和动作分块。语言使用轻量 bag-of-words 编码，而非预训练语言大模型。

### 7.2 ACT-style Transformer

入口：[train_act_style.py](code/IsaacLab_Data_Collection/scripts/train/train_act_style.py)。

```text
双视角图像 → CNN → 图像 token
机器人状态 → MLP → 状态 token
语言词袋   → MLP → 语言 token
                     ↓
可学习动作 queries + Transformer decoder
                     ↓
               未来 20 × 7 维动作
```

可选 progress 分支引入归一化轨迹进度条件。训练使用带 padding mask 的归一化动作 MSE，同时报告原动作尺度上的 MAE。混合动作维度的 MAE 均值不是末端位置误差的米制测量，也不是成功率。

实现未包含完整原版 ACT 的 CVAE / KL 训练路径，不应称为原版 ACT 的完整复现。

### 7.3 close-256 主要配置

| 参数 | 值 |
|---|---|
| 训练 / 验证 | 按 episode 划分，40 / 10 条 |
| Epochs / batch size | 100 / 64 |
| Learning rate / weight decay | `1e-4` / `1e-6` |
| Seed / validation ratio | 42 / 0.2 |
| Chunk size | 20 |
| Hidden / image feature dimension | 256 / 256 |
| Transformer layers / heads | 3 / 8 |
| Dropout | 0.1 |
| 数据读取 | `cache_in_memory` |

按轨迹划分可减少同一轨迹相邻帧跨训练集和验证集带来的泄漏。

## 8. 已有实验结果

### 8.1 离线验证

以下数值取自各训练目录的 `eval_summary.json`，对应按验证损失选择的最佳 epoch：

| close-256 模型 | Best epoch | Best validation loss | Action MAE mean |
|---|---:|---:|---:|
| 图像 + 普通状态 + 语言 | 91 | 0.018502 | 0.005514 |
| 加入方块位姿的 privileged 版本 | 70 | 0.013711 | 0.006736 |
| privileged + progress | 35 | 0.013869 | 0.008089 |

原始记录：[普通版本](data/IsaacLab_Data_Collection/runs/act_style_piper_stack_50_close_256_h256/eval_summary.json)、[privileged](data/IsaacLab_Data_Collection/runs/act_style_piper_stack_50_close_256_privileged_h256/eval_summary.json)、[privileged + progress](data/IsaacLab_Data_Collection/runs/act_style_piper_stack_50_close_256_privileged_h256_progress/eval_summary.json)。

privileged 版本的归一化 MSE 更低，但其 MAE 均值并非最低。两者度量尺度不同，不能仅凭单个离线指标判断控制策略优劣。

### 8.2 闭环 rollout

入口为 [eval_rgb_bc_rollout.py](code/IsaacLab_Data_Collection/scripts/eval/eval_rgb_bc_rollout.py) 和 [eval_act_style_rollout.py](code/IsaacLab_Data_Collection/scripts/eval/eval_act_style_rollout.py)。

动作块策略每次预测一段动作，执行 `exec_horizon` 步后重新观察、预测。预测长度 20 与实际执行长度是两个不同参数。

当前本地保存的 12 份闭环 `summary.json` 均记录 `success_rate=0.0`。其中 50 条 close-256 privileged 模型的执行长度实验为：

| exec_horizon | Rollout 数 | 完整任务成功率 |
|---|---:|---:|
| 3 | 5 | 0% |
| 5 | 3 | 0% |
| 8 | 5 | 0% |

记录见 [eval 目录](data/IsaacLab_Data_Collection/eval/)。已有笔记描述了接近、抓取和部分堆叠行为，但这些局部行为不能替代完整成功条件，也不能据此声称策略已完成稳定堆叠。

## 9. 复现入口

下面是 Linux/Bash 下的流程示例，需要先具备可用的 Isaac Sim / Isaac Lab 环境、完整任务源码和资产。当前 Windows 文件副本未重新运行仿真验证。

```bash
conda activate isaaclab23
export PROJECT_DIR="$HOME/code/IsaacLab_Data_Collection"
export ISAACLAB_DIR="$HOME/code/IsaacLab"
export DATA="$HOME/data/IsaacLab_Data_Collection"
cd "$PROJECT_DIR"
python -m pip install -e source/agx_teleop
```

生成低维示教（执行前确保输出位置没有需要保留的同名数据）：

```bash
"$ISAACLAB_DIR/isaaclab.sh" -p scripts/tools/record_ik_stack.py \
  --task Isaac-Stack-Cube-Piper-IK-Rel-v0 \
  --dataset_file "$DATA/datasets/ik_lowdim_100.hdf5" \
  --num_demos 100 --headless
```

在已有完整 100 条低维示教的前提下，后期流水线可生成 50 条 close-256 图像、添加语言、导出元数据并训练三组模型：

```bash
bash scripts/tools/run_50demos_close256_pipeline.sh
```

该脚本默认将三组训练分配到 GPU 0、1、2，并包含部分覆盖输出参数；运行前应检查路径、已有输出和显卡资源。只有一张 GPU 时，可依次运行脚本内各条训练命令。

已有完整 manifest 时，单独训练普通状态版本：

```bash
python scripts/train/train_act_style.py \
  --manifest_dir "$DATA/vla_exports/piper_stack_vla_50_close_256" \
  --run_dir "$DATA/runs/act_style_piper_stack_50_close_256_h256" \
  --epochs 100 --batch_size 64 --chunk_size 20 \
  --hidden_dim 256 --image_feature_dim 256 \
  --num_layers 3 --num_heads 8 --device auto --cache_in_memory
```

与已有记录对应的 privileged 闭环评估示例：

```bash
"$ISAACLAB_DIR/isaaclab.sh" -p scripts/eval/eval_act_style_rollout.py \
  --headless --enable_cameras \
  --checkpoint "$DATA/runs/act_style_piper_stack_50_close_256_privileged_h256/best.pt" \
  --task Isaac-Stack-Cube-Piper-IK-Rel-v0 \
  --num_rollouts 5 --max_steps 700 --exec_horizon 8 \
  --image_height 256 --image_width 256 \
  --static_eye 0.78 -0.38 0.48 --static_target 0.45 0.00 0.04 \
  --warmup_steps 2 --render_retries 1 \
  --output_dir "$DATA/eval/act_50_close256_privileged_best_h8" \
  --save_video_dir "$DATA/videos/eval_act_50_close256_privileged_best_h8"
```

训练与评估应保持相机配置、图像预处理、状态顺序、动作尺度和归一化统计一致。元数据中的历史绝对路径也需按实际机器修改。

## 10. 当前文件完整性与限制

2026-10-20 对当前本地副本的读取检查发现：

- `ik_lowdim_100.hdf5` 实际为 2,883,584 字节，文件头记录的预期大小为 31,299,066 字节。
- `ik_static_wrist_rgb_lang_50_close_256.hdf5` 实际为 2,883,584 字节，文件头记录的预期大小为 4,064,258,621 字节。
- 两个文件均被 h5py 判定为 `truncated file`，不能当作完整训练数据使用。

上述数据规模、离线指标和闭环结果来自保留的元数据及日志，不代表本地已完整复跑。复现前需从原服务器恢复数据，核对文件大小与校验和，再验证 HDF5 可读性。其他权重和资产也应检查完整性。

当前主要限制包括示教数量与扰动覆盖有限、单指令、仿真回放可能漂移、末端跟随相机与真实相机模型不同，以及离线误差较低但闭环任务仍失败。

后续方向包括扩大示教覆盖、定位动作对齐和阶段切换误差、完善标准数据导出、与完整 ACT 等方法对比，以及开展真实相机标定、动作/夹爪尺度校准和视觉域随机化。目前尚无本地材料证明真机迁移已完成。

## 11. 引用、依赖与致谢

| 来源 | 项目中的关系 |
|---|---|
| [szyzp/IsaacLab_Data_Collection](https://github.com/szyzp/IsaacLab_Data_Collection) | 直接源仓库：Piper/Nero 堆叠环境、示教采集与回放基础 |
| [isaac-sim/IsaacLab](https://github.com/isaac-sim/IsaacLab) | 机器人任务、控制与仿真学习框架；本地主要版本 2.3.0 |
| [NVIDIA Isaac Sim 文档](https://docs.isaacsim.omniverse.nvidia.com/) | 底层仿真与渲染平台；历史实验记录使用 4.5 |
| [agilexrobotics/agx_arm_urdf](https://github.com/agilexrobotics/agx_arm_urdf) | 机器人描述与模型资产来源 |
| [tonyzhaozh/act](https://github.com/tonyzhaozh/act) | 动作分块方法参考；本项目未完整复现其训练架构 |
| [huggingface/lerobot](https://github.com/huggingface/lerobot) | 数据组织及机器人学习生态参考；本项目使用自定义 HDF5 桥接导出 |

上游示教项目的本地 [LICENSE](code/IsaacLab_Data_Collection/LICENSE) 为 BSD 3-Clause，保留其版权声明。其他框架、机器人资产和仿真器遵循各自许可证；不能用上游单一许可证概括整个目录。引用方法或格式不等于直接使用了对应官方训练实现。

补充阅读：[阶段性结果](code/IsaacLab_Data_Collection/docs/results_summary.md)、[LeRobot-style 说明](code/IsaacLab_Data_Collection/docs/lerobot_stage.md)、[项目问答](code/IsaacLab_Data_Collection/interview_qa.md)。阶段性笔记可能早于最终实验，具体数值以对应配置和结果文件为准。

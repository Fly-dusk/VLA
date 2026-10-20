━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
实验室服务器使用说明
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

用户名: niunj
类型: 正式成员 
权限: GPU访问

【目录结构】
/home/niunj/           系统盘（固态，约440GB共享）
├── miniconda3/            Conda环境（推荐安装位置）
├── code/                  代码项目
└── data/ -> /data/niunj   软链接到数据盘

/data/niunj/           数据盘（机械，约18TB共享）
├── datasets/              数据集
├── models/                模型权重文件
├── outputs/               训练输出
└── temp/                  临时文件

【存储使用原则】⚠️ 重要
系统盘空间有限（约440GB由所有用户共享），请务必合理使用：

✓ 推荐放在系统盘（~/）:
  - Conda/Python环境（~20-30GB）
  - 代码项目（通常<1GB）
  - 配置文件

✓ 必须放在数据盘（~/data/）:
  - 数据集（>1GB）
  - 模型权重文件（通常几GB到几十GB）
  - 训练输出和日志
  - 大型临时文件

【空间自查】
每周执行以下命令检查空间使用：
  du -sh ~              # 查看home总占用
  du -sh ~/data         # 查看data总占用
  du -sh ~/* | sort -h  # 查看home各目录占用
  du -sh ~/data/* | sort -h  # 查看data各目录占用

【建议配额】（自我管理）
  系统盘: 建议控制在30-50GB以内
  数据盘: 根据项目需求使用，但请及时清理无用数据

【快速开始】
1. 首次登录修改密码:
   passwd

2. 安装Miniconda（推荐，约500MB）:
   cd ~
   wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
   bash Miniconda3-latest-Linux-x86_64.sh
   source ~/.bashrc

3. 创建Conda环境:
   conda create -n pytorch python=3.10
   conda activate pytorch
   conda install pytorch torchvision pytorch-cuda=11.8 -c pytorch -c nvidia

4. 验证GPU:
   python -c "import torch; print(torch.cuda.is_available())"

【常用命令】
# GPU监控
nvidia-smi            # 查看GPU状态
watch -n 1 nvidia-smi # 实时监控GPU

# Conda管理（快捷别名）
ca ENV                # 激活环境（conda activate的简写）
cda                   # 退出环境（conda deactivate的简写）
cenv                  # 列出所有环境
cclean                # 清理缓存（释放空间）

【定期维护】⚠️ 重要
每周执行以下操作，避免占用过多空间：

1. 清理Conda缓存:
   cclean              # 使用别名
   # 或完整命令
   conda clean --all
   pip cache purge

2. 删除不用的环境:
   conda env remove -n 旧环境名

3. 清理系统缓存:
   rm -rf ~/.cache/pip
   rm -rf ~/.cache/torch
   rm -rf ~/.cache/huggingface

4. 删除临时文件:
   rm -rf ~/data/temp/*

【使用示例】
# 典型的项目工作流
cd ~
git clone https://github.com/xxx/project.git  # 代码放系统盘
cd project

# 数据集放数据盘
ln -s ~/data/datasets/imagenet data

# 创建环境
conda create -n myproject python=3.10
ca myproject          # 使用别名激活
pip install -r requirements.txt

# 训练（输出到数据盘）
python train.py --data data/ --output ~/data/outputs/exp1

【注意事项】
❌ 不要在系统盘存储数据集
❌ 不要在系统盘存储模型权重
❌ 不要安装Anaconda（太大，约3-5GB，用Miniconda）
❌ 不要长期保留临时文件
✓  定期清理缓存
✓  及时删除旧环境
✓  项目完成后清理无用输出

【GPU使用礼仪】
- 训练前查看GPU状态: nvidia-smi
- 使用指定GPU: CUDA_VISIBLE_DEVICES=0 python train.py
- 后台长时间训练: nohup python train.py > train.log 2>&1 &

【获取帮助】
- 详细文档: /data/shared/用户指南.md
- 管理员: [管理员信息]
- 服务器IP: 校园网（172.25.76.201），内网（192.168.1.132），SSH端口7777

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

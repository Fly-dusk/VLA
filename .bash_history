python -c "import torch; print(torch.cuda.is_available())
nvidia-smi
conda --version
ldd --version
cd ~
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
source ~/.bashrc
conda create -n py310_1 python=3.10
conda activate py310_1
conda install pytorch torchvision pytorch-cuda=11.8 -c pytorch -c nvidia
ping -c 4 download.isaacsim.omniverse.nvidia.com
mkdir -p ~/code
cd ~/home/niunj 
mkdir -p ~/data/tools
mkdir -p ~/data/datasets/isaaclab_data_collection
mkdir -p ~/data/temp/pip_cache
mkdir -p ~/data/temp/conda_pkgs
mkdir -p ~/data/temp/xdg_cache
cmake --version
gcc --version
g++ --version
readlink -f ~/data
df -h ~
df -h ~/data
cat >> ~/.bashrc <<'EOF'# ================= IsaacLab project paths =================export PROJECT_ROOT=$HOME/codeexport DATA_ROOT=$HOME/data# Put large caches on data diskexport PIP_CACHE_DIR=$HOME/data/temp/pip_cacheexport CONDA_PKGS_DIRS=$HOME/data/temp/conda_pkgsexport XDG_CACHE_HOME=$HOME/data/temp/xdg_cache# HuggingFace / model cache, for later imitation learning or VLA modelsexport HF_HOME=$HOME/data/models/huggingfaceEOFsource ~/.bashrc


cat >> ~/.bashrc <<'EOF'

# ================= IsaacLab project paths =================

export PROJECT_ROOT=$HOME/code
export DATA_ROOT=$HOME/data

# Put large caches on data disk

export PIP_CACHE_DIR=$HOME/data/temp/pip_cache
export CONDA_PKGS_DIRS=$HOME/data/temp/conda_pkgs
export XDG_CACHE_HOME=$HOME/data/temp/xdg_cache

# HuggingFace / model cache, for later imitation learning or VLA models

export HF_HOME=$HOME/data/models/huggingface

EOF

source ~/.bashrc
echo $PIP_CACHE_DIR
echo $CONDA_PKGS_DIRS
echo $XDG_CACHE_HOME
echo $HF_HOME
conda config --add pkgs_dirs ~/data/temp/conda_pkgs
conda config --set auto_activate_base false
conda config --show pkgs_dirs
cd ~/data/tools
wget -c "https://download.isaacsim.omniverse.nvidia.com/isaac-sim-standalone-4.5.0-linux-x86_64.zip" \  -O isaac-sim-standalone-4.5.0-linux-x86_64.zip
ca py310_1
wget -c -O isaac-sim-standalone-4.5.0-linux-x86_64.zip "https://download.isaacsim.omniverse.nvidia.com/isaac-sim-standalone-4.5.0-linux-x86_64.zip"
cd ~/data/tools
ls -lh isaac-sim-standalone-4.5.0-linux-x86_64.zip
mkdir -p ~/data/tools/isaacsim
unzip isaac-sim-standalone-4.5.0-linux-x86_64.zip -d ~/data/tools/isaacsim
ln -sfn ~/data/tools/isaacsim ~/isaacsim
ls -ld ~/isaacsim
readlink -f ~/isaacsim
cd ~/isaacsim
./post_install.sh
conda deactivate
cd ~/isaacsim
./post_install.sh
./python.sh -c "print('Isaac Sim Python OK')"
cat >> ~/.bashrc <<'EOF'

# Isaac Sim 4.5 binary installation

export ISAACSIM_PATH=$HOME/isaacsim
export ISAACSIM_PYTHON_EXE=$ISAACSIM_PATH/python.sh

EOF

source ~/.bashrc
echo $ISAACSIM_PATH
echo $ISAACSIM_PYTHON_EXE
readlink -f $ISAACSIM_PATH
cd ~/code
git clone --branch v2.1.0 --depth 1 https://github.com/isaac-sim/IsaacLab.git
cd ~/code/IsaacLab
ln -sfn $ISAACSIM_PATH _isaac_sim
ls -ld _isaac_sim
readlink -f _isaac_sim
./isaaclab.sh --conda isaaclab
conda activate isaaclab
./isaaclab.sh --install
conda install pip -y
python -m pip --version
python -m pip install --upgrade pip
cd ~/code/IsaacLab
./isaaclab.sh --install
python -m pip install "setuptools==70.3.0" wheel
python -m pip install --no-build-isolation "flatdict==4.0.1"
python -m pip install "numpy==1.26.0"
python -m pip install --no-build-isolation --no-deps -e source/isaaclab
python -m pip install --no-deps -e source/isaaclab_assets
python -m pip install --no-deps -e source/isaaclab_tasks
python -m pip install --no-deps -e source/isaaclab_mimic
python -m pip install --no-deps -e source/isaaclab_rl
python - <<'PY'
import numpy as np
print("numpy:", np.__version__)

import flatdict
print("flatdict OK")

import isaaclab
print("isaaclab OK")

import isaaclab_assets
print("isaaclab_assets OK")

import isaaclab_tasks
print("isaaclab_tasks OK")

import isaaclab_mimic
print("isaaclab_mimic OK")

import isaaclab_rl
print("isaaclab_rl OK")
PY

python -m pip install "warp-lang"
python -m pip install -c /tmp/isaaclab_constraints.txt   "dex-retargeting==0.4.6"   "einops"   "hidapi==0.14.0.post2"   "pin-pink==3.1.0"   "prettytable==3.3.0"   "pyglet<2"   "trimesh"   "onnx==1.16.1"   "starlette==0.46.0"
cat > ~/code/IsaacLab/isaaclab_constraints.txt <<'EOF'
numpy==1.26.0
EOF

python -m pip install -c ~/code/IsaacLab/isaaclab_constraints.txt   "dex-retargeting==0.4.6"   "einops"   "hidapi==0.14.0.post2"   "pin-pink==3.1.0"   "prettytable==3.3.0"   "pyglet<2"   "trimesh"   "onnx==1.16.1"   "starlette==0.46.0"
python - <<'PY'
import numpy as np
print("numpy:", np.__version__)

import warp as wp
print("warp OK:", wp.__version__)

import onnx
print("onnx:", onnx.__version__)

import starlette
print("starlette:", starlette.__version__)
PY

python - <<'PY'
import numpy as np
print("numpy:", np.__version__)

import flatdict
print("flatdict OK")

import warp as wp
print("warp OK:", wp.__version__)

import isaaclab
print("isaaclab OK")

import isaaclab_assets
print("isaaclab_assets OK")

import isaaclab_tasks
print("isaaclab_tasks OK")

import isaaclab_mimic
print("isaaclab_mimic OK")

import isaaclab_rl
print("isaaclab_rl OK")
PY

source ~/isaacsim/setup_conda_env.sh
python - <<'PY'
import omni.client
print("omni.client OK")
PY

ls -ld _isaac_sim
readlink -f _isaac_sim
readlink -f ~/isaacsim
./isaaclab.sh -p scripts/tutorials/00_sim/create_empty.py --headless
ldconfig -p | grep libGLX_nvidia
find /usr /lib /opt -name "libGLX_nvidia.so*" 2>/dev/null
find /usr /lib /opt -name "libvulkan_nvidia.so*" 2>/dev/null
nvidia-smi
which vulkaninfo
vulkaninfo --summary
ls -l /usr/share/vulkan/icd.d/
find /usr/share/vulkan /etc/vulkan -name "*nvidia*icd*.json" 2>/dev/null
ls -l /dev/nvidia*
nvidia-smi
cat /etc/vulkan/icd.d/nvidia_icd.json
ldconfig -p | grep libGLX_nvidia
find /run /usr /lib /opt -name "libGLX_nvidia.so*" 2>/dev/null
find /run /usr /lib /opt -name "libvulkan_nvidia.so*" 2>/dev/null
vulkaninfo --summary
ldconfig -p | grep libGLX_nvidia
ldconfig -p | grep libvulkan_nvidia
vulkaninfo --summary
ldconfig -p | grep libGLX_nvidia
ldconfig -p | grep libvulkan_nvidia
VK_ICD_FILENAMES=/etc/vulkan/icd.d/nvidia_icd.json vulkaninfo | grep -E "GPU id|deviceName|driverName|driverInfo|NVIDIA|L20" -A3 -B2 | head -100
VK_ICD_FILENAMES=/etc/vulkan/icd.d/nvidia_icd.json vulkaninfo | head -80
vulkaninfo | head -80
nvidia-smi
cd ~/code
mv IsaacLab IsaacLab_v2.1_backup
git clone --branch v2.3.0 --depth 1 https://github.com/isaac-sim/IsaacLab.git IsaacLab
cd ~/code/IsaacLab
ln -sfn ~/isaacsim _isaac_sim
conda create -n isaaclab23 python=3.10 -y
conda activate isaaclab23
conda install pip -y
cd ~/code/IsaacLab
./isaaclab.sh --install
./isaaclab.sh -p scripts/tutorials/00_sim/create_empty.py --headless
cd ~/code/IsaacLab
ls -ld _isaac_sim
readlink -f _isaac_sim
readlink -f ~/isaacsim
./isaaclab.sh -p -c "import isaacsim; print('isaacsim OK')"
./isaaclab.sh --install
~/isaacsim/python.sh -c "import isaacsim; print('isaacsim OK from isaacsim/python.sh')"
ls -lh ~/code/IsaacLab_Data_Collection/source/agx_teleop/agx_description/agx_arm_urdf/piper/usd/piper.usd
cd ~/code/IsaacLab_Data_Collection/source/agx_teleop/agx_description/agx_arm_urdf
find piper/usd -maxdepth 3 -type f -printf "%p  %s bytes\n" | sort
nvidia-smi
conda activate isaaclab23
cd ~/code/IsaacLab_Data_Collection
~/code/IsaacLab/isaaclab.sh -p scripts/tools/record_ik_stack.py   --headless   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --dataset_file ~/data/datasets/isaaclab_data_collection/ik_dataset_10_v23.hdf5   --num_demos 10
ls -lh ~/data/datasets/isaaclab_data_collection
du -sh ~/data/datasets/isaaclab_data_collection/ik_dataset_10_v23.hdf5
python - <<'PY'
import h5py

path = "/home/niunj/data/datasets/isaaclab_data_collection/ik_dataset_10_v23.hdf5"

with h5py.File(path, "r") as f:
    print("HDF5 file:", path)
    print("Top-level keys:", list(f.keys()))

    def show(name, obj):
        if hasattr(obj, "shape"):
            print(name, obj.shape, obj.dtype)
        else:
            print(name)

    f.visititems(show)
PY

exit
cd ~/code/IsaacLab
conda activate isaaclab
unset VK_ICD_FILENAMES
export CUDA_VISIBLE_DEVICES=0
export __NV_PRIME_RENDER_OFFLOAD=1
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export __VK_LAYER_NV_optimus=NVIDIA_only
./isaaclab.sh -p scripts/tutorials/00_sim/create_empty.py --headless
unset CUDA_VISIBLE_DEVICES
unset VK_ICD_FILENAMES
unset __NV_PRIME_RENDER_OFFLOAD
unset __VK_LAYER_NV_optimus
./isaaclab.sh -p scripts/tutorials/00_sim/create_empty.py --headless
cd ~/code
pwd
cd ~/code/IsaacLab
pwd
cd ~/code
git clone https://github.com/szyzp/IsaacLab_Data_Collection.git
cd ~/code/IsaacLab_Data_Collection
conda activate isaaclab
python -m pip install -e source/agx_teleop
python - <<'PY'
import agx_teleop
import agx_teleop.tasks
print("agx_teleop import OK")
PY

python -m pip show agx_teleop
~/code/IsaacLab/isaaclab.sh -p scripts/tools/record_ik_stack.py --help
~/code/IsaacLab/isaaclab.sh -p scripts/list_envs.py | grep -E "Piper|Stack|Cube"
~/code/IsaacLab/isaaclab.sh -p scripts/list_envs.py | grep Piper
cat > /tmp/check_agx_envs.py <<'PY'
from isaaclab.app import AppLauncher

app_launcher = AppLauncher(headless=True)
simulation_app = app_launcher.app

import gymnasium as gym
import agx_teleop.tasks  # noqa: F401


print("\n===== AGX / Piper / Nero / Stack envs =====")
for spec in sorted(gym.registry.values(), key=lambda x: x.id):
    if any(k in spec.id for k in ["Piper", "Nero", "Stack", "Cube", "agx"]):
        print(spec.id)

simulation_app.close()
PY

unset CUDA_VISIBLE_DEVICES
unset VK_ICD_FILENAMES
unset __NV_PRIME_RENDER_OFFLOAD
unset __VK_LAYER_NV_optimus
~/code/IsaacLab/isaaclab.sh -p /tmp/check_agx_envs.py
mkdir -p ~/data/datasets/isaaclab_data_collection
~/code/IsaacLab/isaaclab.sh -p scripts/tools/record_ik_stack.py   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --dataset_file ~/data/datasets/isaaclab_data_collection/ik_dataset_test.hdf5   --num_demos 2
cd ~/code/IsaacLab
python - <<'PY'
from pathlib import Path

p = Path("/home/niunj/code/IsaacLab/source/isaaclab/isaaclab/devices/device_base.py")
txt = p.read_text()

if "class DevicesCfg" not in txt:
    backup = p.with_suffix(".py.bak_before_devicescfg")
    backup.write_text(txt)
    txt += r'''

# ----------------------------------------------------------------------

# Compatibility shim for newer task configs that import DeviceCfg/DevicesCfg.

# Added for IsaacLab_Data_Collection compatibility with IsaacLab v2.1.x.

# ----------------------------------------------------------------------

from dataclasses import dataclass as _dataclass, field as _field

@_dataclass
class DeviceCfg:
    """Configuration for teleoperation devices."""
    teleoperation_active_default: bool = True
    sim_device: str = "cpu"
    retargeters: list = _field(default_factory=list)
    class_type: type | None = None

@_dataclass
class DevicesCfg:
    """Configuration for all supported teleoperation devices."""
    devices: dict[str, DeviceCfg] = _field(default_factory=dict)
'''
    p.write_text(txt)
    print(f"Added DevicesCfg compatibility shim. Backup: {backup}")
else:
    print("DevicesCfg already exists, no change.")
PY

python - <<'PY'
from isaaclab.devices.device_base import DeviceCfg, DevicesCfg
print("DeviceCfg OK:", DeviceCfg)
print("DevicesCfg OK:", DevicesCfg)
PY

grep -n "class DeviceCfg" ~/code/IsaacLab/source/isaaclab/isaaclab/devices/device_base.py
grep -n "class DevicesCfg" ~/code/IsaacLab/source/isaaclab/isaaclab/devices/device_base.py
cd ~/code/IsaacLab_Data_Collection
unset CUDA_VISIBLE_DEVICES
unset VK_ICD_FILENAMES
unset __NV_PRIME_RENDER_OFFLOAD
unset __VK_LAYER_NV_optimus
~/code/IsaacLab/isaaclab.sh -p scripts/tools/record_ik_stack.py   --headless   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --dataset_file ~/data/datasets/isaaclab_data_collection/ik_dataset_test.hdf5   --num_demos 2
cd ~/code/IsaacLab
ca issaclab23
ca isaaclab23
cat > /tmp/test_isaacsim_import.py <<'PY'
import sys
print("python:", sys.executable)

import isaacsim
print("isaacsim OK")
PY

~/isaacsim/python.sh -c "import isaacsim; print('isaacsim OK from isaacsim/python.sh')"
python -c "import isaacsim; print('isaacsim OK after setup_conda_env')"
ls -ld _isaac_sim
readlink -f _isaac_sim
cd ~/code/IsaacLab
conda activate isaaclab23
source ~/isaacsim/setup_conda_env.sh
python -c "import isaacsim; print('isaacsim OK after setup_conda_env')"
unset CUDA_VISIBLE_DEVICES
unset VK_ICD_FILENAMES
unset __NV_PRIME_RENDER_OFFLOAD
unset __VK_LAYER_NV_optimus
./isaaclab.sh -p scripts/tutorials/00_sim/create_empty.py --headless
cd ~/code/IsaacLab_Data_Collection
python -m pip install -e source/agx_teleop
unset CUDA_VISIBLE_DEVICES
unset VK_ICD_FILENAMES
unset __NV_PRIME_RENDER_OFFLOAD
unset __VK_LAYER_NV_optimus
~/code/IsaacLab/isaaclab.sh -p /tmp/check_agx_envs.py
unset CUDA_VISIBLE_DEVICES
unset VK_ICD_FILENAMES
unset __NV_PRIME_RENDER_OFFLOAD
unset __VK_LAYER_NV_optimus
~/code/IsaacLab/isaaclab.sh -p scripts/tools/record_ik_stack.py   --headless   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --dataset_file ~/data/datasets/isaaclab_data_collection/ik_dataset_test_v23.hdf5   --num_demos 2
python - <<'PY'
from pathlib import Path

p = Path("/home/niunj/code/IsaacLab/source/isaaclab/isaaclab/devices/device_base.py")
txt = p.read_text()

if "class TrackingTarget" not in txt:
    backup = p.with_suffix(".py.bak_before_trackingtarget")
    backup.write_text(txt)

    # add Enum import

    if "from enum import Enum" not in txt:
        txt = txt.replace(
            "from dataclasses import dataclass, field",
            "from dataclasses import dataclass, field\nfrom enum import Enum"
        )

    # insert nested classes inside DeviceBase, before __init__

    marker = "    def __init__(self, retargeters:"
    insert = r'''
    # ----------------------------------------------------------------------

    # Compatibility shim for newer task configs that use DeviceBase.TrackingTarget.

    # Added for IsaacLab_Data_Collection compatibility with IsaacLab v2.3.x.

    # ----------------------------------------------------------------------

    class TrackingTarget(Enum):
        """Standard tracking targets shared across devices."""
        HAND_LEFT = 0
        HAND_RIGHT = 1
        HEAD = 2
        CONTROLLER_LEFT = 3
        CONTROLLER_RIGHT = 4

    class MotionControllerDataRowIndex(Enum):
        """Rows in the motion-controller 2x7 array."""
        POSE = 0
        INPUTS = 1

    class MotionControllerInputIndex(Enum):
        """Indices in the motion-controller input row."""
        THUMBSTICK_X = 0
        THUMBSTICK_Y = 1
        TRIGGER = 2
        SQUEEZE = 3
        BUTTON_0 = 4
        BUTTON_1 = 5
        PADDING = 6

'''
    if marker not in txt:
        raise RuntimeError("Could not find DeviceBase.__init__ marker. Please inspect device_base.py manually.")

    txt = txt.replace(marker, insert + marker)
    p.write_text(txt)
    print(f"Added DeviceBase.TrackingTarget compatibility shim. Backup: {backup}")
else:
    print("TrackingTarget already exists, no change.")
PY

grep -n "class TrackingTarget" ~/code/IsaacLab/source/isaaclab/isaaclab/devices/device_base.py
grep -n "MotionControllerDataRowIndex" ~/code/IsaacLab/source/isaaclab/isaaclab/devices/device_base.py
grep -n "MotionControllerInputIndex" ~/code/IsaacLab/source/isaaclab/isaaclab/devices/device_base.py
unset CUDA_VISIBLE_DEVICES
unset VK_ICD_FILENAMES
unset __NV_PRIME_RENDER_OFFLOAD
unset __VK_LAYER_NV_optimus
~/code/IsaacLab/isaaclab.sh -p scripts/tools/record_ik_stack.py   --headless   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --dataset_file ~/data/datasets/isaaclab_data_collection/ik_dataset_test_v23.hdf5   --num_demos 2
cd ~/code/IsaacLab_Data_Collection
grep -R "root_joint\|base_link\|Piper\|PIPER\|ArticulationCfg" -n source/agx_teleop/agx_teleop | head -100
find source/agx_teleop/agx_teleop/assets -iname "*piper*.usd" -o -iname "*piper*.usda" -o -iname "*piper*.urdf"
cat > /tmp/inspect_piper_usd.py <<'PY'
from pxr import Usd, UsdPhysics

usd_path = "/home/niunj/code/IsaacLab_Data_Collection/source/agx_teleop/agx_teleop/assets/agx_arm_urdf/piper/usd/piper.usd"

stage = Usd.Stage.Open(usd_path)
print("USD:", usd_path)
print("defaultPrim:", stage.GetDefaultPrim().GetPath() if stage.GetDefaultPrim() else None)

print("\n=== Important prims ===")
keys = ["root_joint", "base_link", "gripper_base", "gripper_link1", "gripper_link2", "joint1", "joint2"]
for prim in stage.Traverse():
    path = str(prim.GetPath())
    if any(k in path for k in keys):
        schemas = prim.GetAppliedSchemas()
        is_rigid = prim.HasAPI(UsdPhysics.RigidBodyAPI)
        is_art_root = prim.HasAPI(UsdPhysics.ArticulationRootAPI)
        print(path, "| type:", prim.GetTypeName(), "| rigid:", is_rigid, "| articulationRoot:", is_art_root, "| schemas:", schemas)

print("\n=== Physics joints body targets ===")
for prim in stage.Traverse():
    type_name = prim.GetTypeName()
    path = str(prim.GetPath())
    if "Joint" in type_name or "joint" in path.lower():
        joint = UsdPhysics.Joint(prim)
        body0 = joint.GetBody0Rel().GetTargets() if joint else []
        body1 = joint.GetBody1Rel().GetTargets() if joint else []
        print(path, "| type:", type_name, "| body0:", body0, "| body1:", body1)
PY

~/isaacsim/python.sh /tmp/inspect_piper_usd.py
ls -lh source/agx_teleop/agx_teleop/assets
find source/agx_teleop/agx_teleop/assets -maxdepth 5 -type f | head -80
find source/agx_teleop/agx_teleop/assets -maxdepth 8 -type d | grep -E "piper|agx_arm|urdf|usd"
git lfs version
find source/agx_teleop/agx_teleop/assets -iname "*piper*.usd" -o -iname "*piper*.urdf"
mkdir -p source/agx_teleop/agx_description
cd source/agx_teleop/agx_description
git clone https://github.com/agilexrobotics/agx_arm_urdf.git
ls -lh
ls -lh agx_arm_urdf
cd agx_arm_urdf
git status
find . \( -iname "*.urdf" -o -iname "*.xacro" \) -print | grep -i piper
find . -maxdepth 4 -type d | grep -i piper
find . \( -iname "*.dae" -o -iname "*.stl" -o -iname "*.obj" \) -print | grep -i piper | head -80
ls -lh piper/usd
ls -lh piper/usd/piper.usd
cd ~/code/IsaacLab
./isaaclab.sh -p scripts/tools/convert_urdf.py --help
cd ~/code/IsaacLab_Data_Collection/source/agx_teleop/agx_description/agx_arm_urdf
cp piper/usd/piper.usd piper/usd/piper.usd.bak_1p5k
grep -n "mesh filename" piper/urdf/piper_gripper.urdf | head -80
cd ~/code/IsaacLab
./isaaclab.sh -p scripts/tools/convert_urdf.py   ~/code/IsaacLab_Data_Collection/source/agx_teleop/agx_description/agx_arm_urdf/piper/urdf/piper_gripper.urdf   ~/code/IsaacLab_Data_Collection/source/agx_teleop/agx_description/agx_arm_urdf/piper/usd/piper.usd   --fix-base
cd ~/code/IsaacLab_Data_Collection/source/agx_teleop/agx_description/agx_arm_urdf/piper/urdf
grep -n "mesh filename" piper_gripper.urdf | head -80
grep -n "package://" piper_gripper.urdf | head -40
cd ~/code/IsaacLab_Data_Collection/source/agx_teleop/agx_description/agx_arm_urdf
mv piper/usd piper/usd_old_$(date +%Y%m%d_%H%M%S)
mkdir -p piper/usd
ls -lh piper/usd
cd ~/code/IsaacLab
./isaaclab.sh -p scripts/tools/convert_urdf.py   ~/code/IsaacLab_Data_Collection/source/agx_teleop/agx_description/agx_arm_urdf/piper/urdf/piper_gripper.urdf   ~/code/IsaacLab_Data_Collection/source/agx_teleop/agx_description/agx_arm_urdf/piper/usd/piper.usd   --fix-base
cd ~/code/IsaacLab_Data_Collection
unset CUDA_VISIBLE_DEVICES
unset VK_ICD_FILENAMES
unset __NV_PRIME_RENDER_OFFLOAD
unset __VK_LAYER_NV_optimus
~/code/IsaacLab/isaaclab.sh -p scripts/tools/record_ik_stack.py   --headless   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --dataset_file ~/data/datasets/isaaclab_data_collection/ik_dataset_test_v23.hdf5   --num_demos 2
ls -lh ~/data/datasets/isaaclab_data_collection
du -sh ~/data/datasets/isaaclab_data_collection/ik_dataset_test_v23.hdf5
tmux new -s piper_demo
~/code/IsaacLab/isaaclab.sh -p scripts/tools/replay_demos.py --help
echo $DISPLAY
~/code/IsaacLab/isaaclab.sh -p ~/code/IsaacLab/scripts/tools/replay_demos.py --help
unset CUDA_VISIBLE_DEVICES
unset VK_ICD_FILENAMES
unset __NV_PRIME_RENDER_OFFLOAD
unset __VK_LAYER_NV_optimus
~/code/IsaacLab/isaaclab.sh -p ~/code/IsaacLab/scripts/tools/replay_demos.py   --headless   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --dataset_file ~/data/datasets/isaaclab_data_collection/ik_dataset_10_v23.hdf5
mkdir -p scripts/tools
cp ~/code/IsaacLab/scripts/tools/replay_demos.py scripts/tools/replay_demos_agx.py
python - <<'PY'
from pathlib import Path

p = Path("scripts/tools/replay_demos_agx.py")
s = p.read_text()

if "import agx_teleop.tasks" not in s:
    # 尽量放在 isaaclab_tasks 导入后面

    if "import isaaclab_tasks" in s:
        s = s.replace(
            "import isaaclab_tasks",
            "import isaaclab_tasks\nimport agx_teleop.tasks  # noqa: F401"
        )
    else:
        # 兜底：放到 parse_env_cfg 前

        s = s.replace(
            "from isaaclab_tasks.utils.parse_cfg import parse_env_cfg",
            "import agx_teleop.tasks  # noqa: F401\nfrom isaaclab_tasks.utils.parse_cfg import parse_env_cfg"
        )

p.write_text(s)
print("Added agx_teleop.tasks import to scripts/tools/replay_demos_agx.py")
PY

grep -n "agx_teleop.tasks" scripts/tools/replay_demos_agx.py
unset CUDA_VISIBLE_DEVICES
unset VK_ICD_FILENAMES
unset __NV_PRIME_RENDER_OFFLOAD
unset __VK_LAYER_NV_optimus
~/code/IsaacLab/isaaclab.sh -p scripts/tools/replay_demos_agx.py   --headless   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --dataset_file ~/data/datasets/isaaclab_data_collection/ik_dataset_10_v23.hdf5
unset CUDA_VISIBLE_DEVICES
unset VK_ICD_FILENAMES
unset __NV_PRIME_RENDER_OFFLOAD
unset __VK_LAYER_NV_optimus
~/code/IsaacLab/isaaclab.sh -p scripts/tools/replay_demos_agx.py   --headless   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --dataset_file ~/data/datasets/isaaclab_data_collection/ik_dataset_10_v23.hdf5
cd ~/code/IsaacLab_Data_Collection
conda activate isaaclab23
# 重新复制干净的官方 replay 脚本，覆盖之前弄坏的文件
cp ~/code/IsaacLab/scripts/tools/replay_demos.py scripts/tools/replay_demos_agx.py
# 自动在 import isaaclab_tasks 后面插入 agx_teleop.tasks
python - <<'PY'
from pathlib import Path

p = Path("scripts/tools/replay_demos_agx.py")
lines = p.read_text().splitlines()

new_lines = []
inserted = False

for line in lines:
    new_lines.append(line)
    if (not inserted) and line.strip().startswith("import isaaclab_tasks"):
        indent = line[:len(line) - len(line.lstrip())]
        new_lines.append(indent + "import agx_teleop.tasks  # noqa: F401")
        inserted = True

if not inserted:
    raise RuntimeError("没有找到 import isaaclab_tasks，先用 grep 检查 replay_demos.py 的导入位置。")

p.write_text("\n".join(new_lines) + "\n")
print("replay_demos_agx.py 已重新生成，并插入 agx_teleop.tasks")
PY

# 检查插入位置
grep -n "isaaclab_tasks\|agx_teleop.tasks" scripts/tools/replay_demos_agx.py
# 检查语法
python -m py_compile scripts/tools/replay_demos_agx.py
unset CUDA_VISIBLE_DEVICES
unset VK_ICD_FILENAMES
unset __NV_PRIME_RENDER_OFFLOAD
unset __VK_LAYER_NV_optimus
~/code/IsaacLab/isaaclab.sh -p scripts/tools/replay_demos_agx.py   --headless   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --dataset_file ~/data/datasets/isaaclab_data_collection/ik_dataset_10_v23.hdf5
cd ~/code/IsaacLab_Data_Collection
conda activate isaaclab23
python - <<'PY'
from pathlib import Path

p = Path("scripts/tools/replay_demos_agx.py")
s = p.read_text()

target = "    env_cfg = parse_env_cfg(env_name, device=args_cli.device, num_envs=num_envs)"

patch = '''    # Register AGX/Piper custom Gym environments before parsing env config.
    import agx_teleop.tasks  # noqa: F401


    # Some recorded HDF5 files store the task name without the Gym version suffix.

    # The registered Gym environment is Isaac-Stack-Cube-Piper-IK-Rel-v0.

    if env_name == "Isaac-Stack-Cube-Piper-IK-Rel":
        env_name = "Isaac-Stack-Cube-Piper-IK-Rel-v0"
    if env_name == "Isaac-Stack-Cube-Nero-IK-Rel":
        env_name = "Isaac-Stack-Cube-Nero-IK-Rel-v0"

    # Prefer the task explicitly provided from command line.

    if getattr(args_cli, "task", None) is not None and "Piper" in args_cli.task:
        env_name = args_cli.task

'''

if target not in s:
    raise RuntimeError("没有找到 parse_env_cfg 那一行，先用 sed 看一下 replay_demos_agx.py 的 130-160 行。")

if "Some recorded HDF5 files store the task name without the Gym version suffix." not in s:
    s = s.replace(target, patch + target)

p.write_text(s)
print("Patched replay_demos_agx.py")
PY

python -m py_compile scripts/tools/replay_demos_agx.py
unset CUDA_VISIBLE_DEVICES
unset VK_ICD_FILENAMES
unset __NV_PRIME_RENDER_OFFLOAD
unset __VK_LAYER_NV_optimus
~/code/IsaacLab/isaaclab.sh -p scripts/tools/replay_demos_agx.py   --headless   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --dataset_file ~/data/datasets/isaaclab_data_collection/ik_dataset_10_v23.hdf5
python - <<'PY'
from pathlib import Path

p = Path("scripts/tools/replay_demos_agx.py")
s = p.read_text()

old = '''    teleop_interface = Se3Keyboard(Se3KeyboardCfg(pos_sensitivity=0.1, rot_sensitivity=0.1))
    teleop_interface.add_callback("N", play_cb)
    teleop_interface.add_callback("B", pause_cb)
    print('Press "B" to pause and "N" to resume the replayed actions.')'''

new = '''    if args_cli.headless:
        teleop_interface = None
        print("Headless replay: keyboard pause/resume disabled.")
    else:
        teleop_interface = Se3Keyboard(Se3KeyboardCfg(pos_sensitivity=0.1, rot_sensitivity=0.1))
        teleop_interface.add_callback("N", play_cb)
        teleop_interface.add_callback("B", pause_cb)
        print('Press "B" to pause and "N" to resume the replayed actions.')'''

if old not in s:
    raise RuntimeError("没有找到 Se3Keyboard 创建代码，请先 sed -n '150,180p' scripts/tools/replay_demos_agx.py 查看。")

s = s.replace(old, new)

old_reset = "    teleop_interface.reset()"
new_reset = '''    if teleop_interface is not None:
        teleop_interface.reset()'''

s = s.replace(old_reset, new_reset)

p.write_text(s)
print("Patched headless keyboard handling.")
PY

python -m py_compile scripts/tools/replay_demos_agx.py
unset CUDA_VISIBLE_DEVICES
unset VK_ICD_FILENAMES
unset __NV_PRIME_RENDER_OFFLOAD
unset __VK_LAYER_NV_optimus
~/code/IsaacLab/isaaclab.sh -p scripts/tools/replay_demos_agx.py   --headless   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --dataset_file ~/data/datasets/isaaclab_data_collection/ik_dataset_10_v23.hdf5
cp scripts/tools/replay_demos_agx.py scripts/tools/replay_demos_agx_video.py
grep -n "gym.make\|parse_env_cfg\|Se3Keyboard\|RecordVideo\|dataset_file" scripts/tools/replay_demos_agx_video.py
python - <<'PY'
from pathlib import Path

p = Path("scripts/tools/replay_demos_agx_video.py")
s = p.read_text()

# 1. 添加视频参数

dataset_line = 'parser.add_argument("--dataset_file", type=str, default="datasets/dataset.hdf5", help="Dataset file to be replayed.")'

video_args = '''parser.add_argument("--video", action="store_true", default=False, help="Record replay video.")
parser.add_argument("--video_length", type=int, default=6000, help="Maximum video length in simulation steps.")
parser.add_argument("--video_dir", type=str, default="/home/niunj/data/outputs/replay_video", help="Directory to save replay videos.")
'''

if "--video_dir" not in s:
    if dataset_line not in s:
        raise RuntimeError("没有找到 dataset_file 参数行。")
    s = s.replace(dataset_line, video_args + dataset_line)

# 2. 确保 import os 存在

if "import os" not in s:
    s = s.replace("import argparse", "import argparse\nimport os")

# 3. 替换 env 创建方式

old_env = "    env = gym.make(args_cli.task, cfg=env_cfg).unwrapped"

new_env = '''    render_mode = "rgb_array" if args_cli.video else None
    env = gym.make(args_cli.task, cfg=env_cfg, render_mode=render_mode)

    if args_cli.video:
        os.makedirs(args_cli.video_dir, exist_ok=True)
        env = gym.wrappers.RecordVideo(
            env,
            video_folder=args_cli.video_dir,
            step_trigger=lambda step: step == 0,
            video_length=args_cli.video_length,
            name_prefix="piper_replay",
            disable_logger=True,
        )
        print(f"Recording replay video to: {args_cli.video_dir}")
    else:
        env = env.unwrapped'''

if old_env not in s:
    raise RuntimeError("没有找到 env = gym.make(args_cli.task, cfg=env_cfg).unwrapped 这一行。")

if "Recording replay video to:" not in s:
    s = s.replace(old_env, new_env)

p.write_text(s)
print("video patch done:", p)
PY

python -m py_compile scripts/tools/replay_demos_agx_video.py
grep -n "video\|RecordVideo\|gym.make" scripts/tools/replay_demos_agx_video.py | head -40
mkdir -p ~/data/outputs/replay_video
unset CUDA_VISIBLE_DEVICES
unset VK_ICD_FILENAMES
unset __NV_PRIME_RENDER_OFFLOAD
unset __VK_LAYER_NV_optimus
~/code/IsaacLab/isaaclab.sh -p scripts/tools/replay_demos_agx_video.py   --headless   --enable_cameras   --video   --video_length 6000   --video_dir ~/data/outputs/replay_video   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --dataset_file ~/data/datasets/isaaclab_data_collection/ik_dataset_10_v23.hdf5
find ~/data/outputs/replay_video -type f -printf "%p  %s bytes\n" | sort
scp -P 7777 niunj@172.25.76.201:/home/niunj/data/outputs/replay_video/piper_replay-step-0.mp4 C:\Users\30774\Desktop\
nvidia -smi
nvidia-smi
cd /home/niunj/code/IsaacLab_Data_Collection
ca isaaclab23
cd /home/niunj/code/IsaacLab_Data_Collection
python scripts/tools/record_ik_stack.py   --task Isaac-Stack-Cube-Piper-IK-Rel-Visuomotor-v0   --num_demos 5   --headless
head -n 30 /home/niunj/data/IsaacLab_Data_Collection/logs/run_100demos_pipeline.out
nvidia-smi
cd ~/code/IsaacLab_Data_Collection
ca isaaclab23
tail -f /home/niunj/data/IsaacLab_Data_Collection/logs/run_100demos_pipeline.out
tail -f /home/niunj/data/IsaacLab_Data_Collection/logs/01_record_lowdim_100.log
nvidia-smi
tail -f /home/niunj/data/IsaacLab_Data_Collection/logs/01_record_lowdim_100.log
tail -f /home/niunj/data/IsaacLab_Data_Collection/logs/run_100demos_pipeline.out
watch -n 10 "ls -lh /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_lowdim_100.hdf5"
tail -f /home/niunj/data/IsaacLab_Data_Collection/logs/01_record_lowdim_100.log
watch -n 10 "ls -lh /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_lowdim_100.hdf5"
nvidia-smi
conda activate isaaclab23
source /home/niunj/isaacsim/setup_conda_env.sh
python -c "import isaacsim; print('isaacsim ok')"
python scripts/tools/record_ik_stack.py   --task Isaac-Stack-Cube-Piper-IK-Rel-Visuomotor-v0   --num_demos 5   --headless
source /home/niunj/isaacsim/setup_conda_env.sh
python scripts/tools/record_ik_stack.py   --task Isaac-Stack-Cube-Piper-IK-Rel-Visuomotor-RGB-v0   --dataset_file /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_visuomotor_rgb_test.hdf5   --num_demos 1   --headless
source /home/niunj/isaacsim/setup_conda_env.sh
python scripts/tools/record_ik_stack.py   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --dataset_file /home/niunj/data/IsaacLab_Data_Collection/datasets/test_lowdim.hdf5   --num_demos 1   --headless
~/code/IsaacLab/isaaclab.sh -p scripts/tutorials/04_sensors/run_usd_camera.py   --headless   --enable_cameras
cd /home/niunj/code/IsaacLab
./isaaclab.sh -p scripts/tutorials/04_sensors/run_usd_camera.py   --headless   --enable_cameras
cd /home/niunj/code/IsaacLab_Data_Collection
source /home/niunj/isaacsim/setup_conda_env.sh
python scripts/tools/record_ik_stack.py   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --dataset_file /home/niunj/data/IsaacLab_Data_Collection/datasets/test_lowdim_enable_cameras.hdf5   --num_demos 1   --headless   --enable_cameras
python scripts/tools/record_ik_stack.py   --task Isaac-Stack-Cube-Piper-IK-Rel-Visuomotor-RGB-v0   --dataset_file /home/niunj/data/IsaacLab_Data_Collection/datasets/test_rgb_two_cams.hdf5   --num_demos 1   --headless
cd /home/niunj/code/IsaacLab
./isaaclab.sh -p scripts/tutorials/04_sensors/run_usd_camera.py   --save   --headless   --enable_cameras
find /home/niunj/code/IsaacLab/scripts/tutorials/04_sensors/output/camera -type f | head
cd /home/niunj/code/IsaacLab_Data_Collection
source /home/niunj/isaacsim/setup_conda_env.sh
python scripts/tools/record_ik_stack.py   --task Isaac-Stack-Cube-Piper-IK-Rel-Visuomotor-StaticRGB-v0   --dataset_file /home/niunj/data/IsaacLab_Data_Collection/datasets/test_static_rgb.hdf5   --num_demos 1   --headless
python scripts/tools/record_ik_stack.py   --task Isaac-Stack-Cube-Piper-IK-Rel-Visuomotor-WristRGB-v0   --dataset_file /home/niunj/data/IsaacLab_Data_Collection/datasets/test_wrist_rgb.hdf5   --num_demos 1   --headless
python scripts/tools/record_ik_stack.py   --task Isaac-Stack-Cube-Piper-IK-Rel-Visuomotor-StaticTiledRGB-v0   --dataset_file /home/niunj/data/IsaacLab_Data_Collection/datasets/test_static_tiled_rgb.hdf5   --num_demos 1   --headless
source /home/niunj/isaacsim/setup_conda_env.sh
python scripts/tools/record_ik_stack.py   --task Isaac-Stack-Cube-Piper-IK-Rel-Visuomotor-StaticTiledScene-v0   --dataset_file /home/niunj/data/IsaacLab_Data_Collection/datasets/test_static_tiled_scene.hdf5   --num_demos 1   --headless
source /home/niunj/isaacsim/setup_conda_env.sh
python scripts/tools/record_ik_stack.py   --task Isaac-Stack-Cube-Piper-IK-Rel-Visuomotor-StaticTiledScene-v0   --dataset_file /home/niunj/data/IsaacLab_Data_Collection/datasets/test_static_tiled_scene_norerender.hdf5   --num_demos 1   --headless
source /home/niunj/isaacsim/setup_conda_env.sh
unset PYTHONPATH
unset LD_LIBRARY_PATH
unset CARB_APP_PATH
unset EXP_PATH
unset ISAAC_PATH
conda deactivate
conda activate isaaclab23
python -c "import isaacsim; print('isaacsim ok')"
unset PYTHONPATH
unset LD_LIBRARY_PATH
unset CARB_APP_PATH
unset EXP_PATH
unset ISAAC_PATH
python -c "import isaacsim; print('isaacsim ok')"
conda activate isaaclab23
python -c "import isaacsim; print('isaacsim ok')"
source /home/niunj/isaacsim/setup_conda_env.sh
python -c "import isaacsim; print('isaacsim ok')"
python scripts/tools/render_camera_dataset.py   --input_dataset /home/niunj/data/IsaacLab_Data_Collection/datasets/test_lowdim.hdf5   --output_dataset /home/niunj/data/IsaacLab_Data_Collection/datasets/test_lowdim_static_rgb_viewport.hdf5   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --max_episodes 1   --headless   --save_preview_dir /home/niunj/data/IsaacLab_Data_Collection/previews
python scripts/tools/render_camera_dataset.py   --input_dataset /home/niunj/data/IsaacLab_Data_Collection/datasets/test_lowdim.hdf5   --output_dataset /home/niunj/data/IsaacLab_Data_Collection/datasets/test_lowdim_static_rgb_viewport_v2.hdf5   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --max_episodes 1   --headless   --warmup_steps 30   --render_retries 10   --save_preview_dir /home/niunj/data/IsaacLab_Data_Collection/previews
python scripts/tools/record_ik_stack.py   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --dataset_file /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_lowdim_20.hdf5   --num_demos 20   --headless
python scripts/tools/render_camera_dataset.py   --input_dataset /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_lowdim_20.hdf5   --output_dataset /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_static_rgb_20.hdf5   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --headless   --warmup_steps 30   --render_retries 10   --save_preview_dir /home/niunj/data/IsaacLab_Data_Collection/previews
python scripts/tools/render_camera_dataset.py   --input_dataset /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_lowdim_20.hdf5   --output_dataset /home/niunj/data/IsaacLab_Data_Collection/datasets/test_static_wrist_rgb_1.hdf5   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --camera_names static_rgb wrist_rgb   --max_episodes 1   --headless   --warmup_steps 30   --render_retries 10   --save_preview_dir /home/niunj/data/IsaacLab_Data_Collection/previews
~/code/IsaacLab/isaaclab.sh -p scripts/tools/render_camera_dataset.py   --headless   --enable_cameras   --input_dataset /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_lowdim_20.hdf5   --base_dataset /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_static_rgb_20.hdf5   --output_dataset /home/niunj/data/IsaacLab_Data_Collection/datasets/test_static_wrist_merged_1.hdf5   --camera_names wrist_rgb   --max_episodes 1   --save_preview_dir /home/niunj/data/IsaacLab_Data_Collection/previews/test_wrist_merged_1
~/code/IsaacLab/isaaclab.sh -p scripts/tools/render_camera_dataset.py   --headless   --enable_cameras   --input_dataset /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_lowdim_20.hdf5   --base_dataset /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_static_rgb_20.hdf5   --output_dataset /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_static_wrist_rgb_20.hdf5   --camera_names wrist_rgb   --save_preview_dir /home/niunj/data/IsaacLab_Data_Collection/previews/wrist_rgb_20
~/code/IsaacLab/isaaclab.sh -p scripts/tools/render_camera_dataset.py   --headless   --enable_cameras   --input_dataset /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_lowdim_20.hdf5   --base_dataset /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_static_rgb_20.hdf5   --output_dataset /home/niunj/data/IsaacLab_Data_Collection/datasets/test_static_wrist_merged_refresh_1.hdf5   --camera_names wrist_rgb   --max_episodes 1   --save_preview_dir /home/niunj/data/IsaacLab_Data_Collection/previews/test_wrist_refresh_1
~/code/IsaacLab/isaaclab.sh -p scripts/tools/render_camera_dataset.py   --headless   --enable_cameras   --input_dataset /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_lowdim_20.hdf5   --output_dataset /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_static_rgb_20_refresh.hdf5   --camera_names static_rgb   --save_preview_dir /home/niunj/data/IsaacLab_Data_Collection/previews/static_rgb_20_refresh
~/code/IsaacLab/isaaclab.sh -p scripts/tools/render_camera_dataset.py   --headless   --enable_cameras   --input_dataset /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_lowdim_20.hdf5   --base_dataset /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_static_rgb_20_refresh.hdf5   --output_dataset /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_static_wrist_rgb_20_refresh.hdf5   --camera_names wrist_rgb   --save_preview_dir /home/niunj/data/IsaacLab_Data_Collection/previews/wrist_rgb_20_refresh
python scripts/train/train_rgb_bc.py   --dataset /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_static_wrist_rgb_20_refresh.hdf5   --run_dir /home/niunj/data/IsaacLab_Data_Collection/runs/bc_static_rgb_20   --camera_mode static   --epochs 50   --batch_size 128   --device auto
python scripts/train/train_rgb_bc.py   --dataset /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_static_wrist_rgb_20_refresh.hdf5   --run_dir /home/niunj/data/IsaacLab_Data_Collection/runs/bc_static_wrist_rgb_20   --camera_mode static_wrist   --epochs 50   --batch_size 128   --device auto
python scripts/train/train_rgb_bc.py   --dataset /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_static_wrist_rgb_20_refresh.hdf5   --run_dir /home/niunj/data/IsaacLab_Data_Collection/runs/bc_static_wrist_rgb_20_cache   --camera_mode static_wrist   --epochs 30   --batch_size 256   --device auto   --cache_in_memory   --save_every 0
python scripts/train/train_rgb_bc.py   --dataset /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_static_wrist_rgb_20_refresh.hdf5   --run_dir /home/niunj/data/IsaacLab_Data_Collection/runs/bc_static_wrist_rgb_20_cache   --camera_mode static_wrist   --epochs 60   --batch_size 256   --device auto   --cache_in_memory   --save_every 0   --resume_checkpoint /home/niunj/data/IsaacLab_Data_Collection/runs/bc_static_wrist_rgb_20_cache/last.pt
python scripts/train/train_rgb_bc.py   --dataset /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_static_wrist_rgb_20_refresh.hdf5   --run_dir /home/niunj/data/IsaacLab_Data_Collection/runs/bc_static_wrist_rgb_20_cache   --camera_mode static_wrist   --epochs 80   --batch_size 256   --device auto   --cache_in_memory   --save_every 0   --lr 3e-5   --resume_checkpoint /home/niunj/data/IsaacLab_Data_Collection/runs/bc_static_wrist_rgb_20_cache/best.pt
python scripts/train/train_rgb_bc.py   --dataset /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_static_wrist_rgb_20_refresh.hdf5   --run_dir /home/niunj/data/IsaacLab_Data_Collection/runs/bc_static_wrist_chunk20_cache   --camera_mode static_wrist   --chunk_size 20   --epochs 60   --batch_size 128   --device auto   --cache_in_memory   --save_every 0
python scripts/train/train_rgb_bc.py   --dataset /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_static_wrist_rgb_lang_20.hdf5   --run_dir /home/niunj/data/IsaacLab_Data_Collection/runs/lang_bc_static_wrist_rgb_20   --camera_mode static_wrist   --use_language   --epochs 60   --batch_size 256   --device auto   --cache_in_memory   --save_every 0
python scripts/train/train_act_style.py   --manifest_dir /home/niunj/data/IsaacLab_Data_Collection/vla_exports/piper_stack_vla_20   --run_dir /home/niunj/data/IsaacLab_Data_Collection/runs/act_style_piper_stack_20   --epochs 80   --batch_size 128   --chunk_size 20   --device auto   --cache_in_memory   --hidden_dim 128   --image_feature_dim 128   --num_layers 2   --num_heads 4   --save_every 0
python scripts/train/train_act_style.py   --manifest_dir /home/niunj/data/IsaacLab_Data_Collection/vla_exports/piper_stack_vla_20   --run_dir /home/niunj/data/IsaacLab_Data_Collection/runs/act_style_piper_stack_20_h256   --epochs 80   --batch_size 128   --chunk_size 20   --device auto   --cache_in_memory   --hidden_dim 256   --image_feature_dim 256   --num_layers 3   --num_heads 8   --save_every 0
nohup bash scripts/tools/run_100demos_pipeline.sh   > /home/niunj/data/IsaacLab_Data_Collection/logs/run_100demos_pipeline.out 2>&1 &
mkdir -p /home/niunj/data/IsaacLab_Data_Collection/logs
nohup bash scripts/tools/run_100demos_pipeline.sh   > /home/niunj/data/IsaacLab_Data_Collection/logs/run_100demos_pipeline.out 2>&1 &
nvidia-smi
tail -f /home/niunj/data/IsaacLab_Data_Collection/logs/01_record_lowdim_100.log
nvidia-smi
watch -n 10 "ls -lh /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_lowdim_100.hdf5"
nvidia-smi
tail -f /home/niunj/data/IsaacLab_Data_Collection/logs/01_record_lowdim_100.log
cd /home/niunj/code/IsaacLab_Data_Collection
source /home/niunj/miniconda3/etc/profile.d/conda.sh
conda activate isaaclab23
unset PYTHONPATH LD_LIBRARY_PATH CARB_APP_PATH EXP_PATH ISAAC_PATH
export ISAACSIM_PATH=/home/niunj/isaacsim
source /home/niunj/isaacsim/setup_conda_env.sh
python -c "import torch, h5py; print('env ok', torch.cuda.device_count())"
CUDA_VISIBLE_DEVICES=2 python scripts/train/train_act_style.py   --manifest_dir /home/niunj/data/IsaacLab_Data_Collection/vla_exports/piper_stack_vla_100_aligned   --run_dir /home/niunj/data/IsaacLab_Data_Collection/runs/act_style_piper_stack_100_aligned_h256   --epochs 100 --batch_size 128 --chunk_size 20 --device auto --cache_in_memory   --hidden_dim 256 --image_feature_dim 256 --num_layers 3 --num_heads 8 --save_every 0
CUDA_VISIBLE_DEVICES=2 python scripts/train/train_act_style.py   --manifest_dir /home/niunj/data/IsaacLab_Data_Collection/vla_exports/piper_stack_vla_100_aligned   --run_dir /home/niunj/data/IsaacLab_Data_Collection/runs/act_style_piper_stack_100_aligned_h256   --epochs 150   --batch_size 128   --chunk_size 20   --device auto   --cache_in_memory   --hidden_dim 256   --image_feature_dim 256   --num_layers 3   --num_heads 8   --resume_checkpoint /home/niunj/data/IsaacLab_Data_Collection/runs/act_style_piper_stack_100_aligned_h256/last.pt   --save_every 0
CUDA_VISIBLE_DEVICES=2 python scripts/train/train_act_style.py   --manifest_dir /home/niunj/data/IsaacLab_Data_Collection/vla_exports/piper_stack_vla_100_aligned   --run_dir /home/niunj/data/IsaacLab_Data_Collection/runs/act_style_piper_stack_100_aligned_h256   --epochs 200   --batch_size 128   --chunk_size 20   --device auto   --cache_in_memory   --hidden_dim 256   --image_feature_dim 256   --num_layers 3   --num_heads 8   --resume_checkpoint /home/niunj/data/IsaacLab_Data_Collection/runs/act_style_piper_stack_100_aligned_h256/last.pt \
cd /home/niunj/code/IsaacLab_Data_Collection
source /home/niunj/miniconda3/etc/profile.d/conda.sh
conda activate isaaclab23
unset PYTHONPATH LD_LIBRARY_PATH CARB_APP_PATH EXP_PATH ISAAC_PATH
export ISAACSIM_PATH=/home/niunj/isaacsim
source /home/niunj/isaacsim/setup_conda_env.sh
mkdir -p /home/niunj/data/IsaacLab_Data_Collection/logs
python -c "import torch, h5py; print('env ok', torch.cuda.device_count())"
CUDA_VISIBLE_DEVICES=1 python scripts/train/train_act_style.py   --manifest_dir /home/niunj/data/IsaacLab_Data_Collection/vla_exports/piper_stack_vla_100_aligned   --run_dir /home/niunj/data/IsaacLab_Data_Collection/runs/act_style_piper_stack_100_aligned_chunk20   --epochs 100 --batch_size 128 --chunk_size 20 --device auto --cache_in_memory   --hidden_dim 128 --image_feature_dim 128 --num_layers 2 --num_heads 4 --save_every 0
nvidia-smi
cd ~/code/IsaacLab_Data_Collection
source /home/niunj/miniconda3/etc/profile.d/conda.sh
conda activate isaaclab23
~/code/IsaacLab/isaaclab.sh -p scripts/eval/eval_rgb_bc_rollout.py   --headless   --enable_cameras   --checkpoint /home/niunj/data/IsaacLab_Data_Collection/runs/bc_static_wrist_rgb_100/best.pt   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --num_rollouts 10   --max_steps 700   --output_dir /home/niunj/data/IsaacLab_Data_Collection/eval/bc_static_wrist_rgb_100   --save_video_dir /home/niunj/data/IsaacLab_Data_Collection/videos/bc_static_wrist_rgb_100
source /home/niunj/miniconda3/etc/profile.d/conda.sh
~/code/IsaacLab/isaaclab.sh -p scripts/eval/eval_rgb_bc_rollout.py   --headless   --enable_cameras   --checkpoint /home/niunj/data/IsaacLab_Data_Collection/runs/bc_static_wrist_rgb_100/best.pt   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --num_rollouts 10   --max_steps 700   --output_dir /home/niunj/data/IsaacLab_Data_Collection/eval/bc_static_wrist_rgb_100   --save_video_dir /home/niunj/data/IsaacLab_Data_Collection/videos/bc_static_wrist_rgb_100
nvidia-smi
cd /home/niunj/code/IsaacLab_Data_Collection
source /home/niunj/miniconda3/etc/profile.d/conda.sh
conda activate isaaclab23
unset PYTHONPATH LD_LIBRARY_PATH CARB_APP_PATH EXP_PATH ISAAC_PATH
export ISAACSIM_PATH=/home/niunj/isaacsim
source /home/niunj/isaacsim/setup_conda_env.sh
python -c "import isaacsim; import isaaclab; print('isaacsim/isaaclab ok')"
~/code/IsaacLab/isaaclab.sh -p scripts/eval/eval_rgb_bc_rollout.py   --headless   --enable_cameras   --checkpoint /home/niunj/data/IsaacLab_Data_Collection/runs/bc_static_wrist_rgb_100/best.pt   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --num_rollouts 10   --max_steps 700   --output_dir /home/niunj/data/IsaacLab_Data_Collection/eval/bc_static_wrist_rgb_100   --save_video_dir /home/niunj/data/IsaacLab_Data_Collection/videos/bc_static_wrist_rgb_100
~/code/IsaacLab/isaaclab.sh -p scripts/eval/eval_rgb_bc_rollout.py   --headless   --enable_cameras   --checkpoint /home/niunj/data/IsaacLab_Data_Collection/runs/lang_bc_static_wrist_rgb_100/best.pt   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --instruction "stack the cube with the Piper robot arm"   --num_rollouts 10   --max_steps 700   --output_dir /home/niunj/data/IsaacLab_Data_Collection/eval/lang_bc_static_wrist_rgb_100   --save_video_dir /home/niunj/data/IsaacLab_Data_Collection/videos/lang_bc_static_wrist_rgb_100
~/code/IsaacLab/isaaclab.sh -p scripts/tools/render_camera_dataset.py   --headless   --enable_cameras   --input_dataset /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_lowdim_100.hdf5   --output_dataset /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_static_rgb_100_aligned.hdf5   --camera_names static_rgb   --render_timing before_step   --overwrite_output   --save_preview_dir /home/niunj/data/IsaacLab_Data_Collection/previews/static_rgb_100_aligned
CUDA_VISIBLE_DEVICES=1 ~/code/IsaacLab/isaaclab.sh -p scripts/tools/render_camera_dataset.py   --headless   --enable_cameras   --input_dataset /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_lowdim_100.hdf5   --base_dataset /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_static_rgb_100_aligned.hdf5   --output_dataset /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_static_wrist_rgb_100_aligned_fast.hdf5   --camera_names wrist_rgb   --render_timing before_step   --warmup_steps 2   --render_retries 1   --overwrite_output
~/code/IsaacLab/isaaclab.sh -p scripts/eval/eval_rgb_bc_rollout.py   --headless   --enable_cameras   --checkpoint /home/niunj/data/IsaacLab_Data_Collection/runs/bc_static_wrist_rgb_100_aligned/best.pt   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --num_rollouts 10   --max_steps 700   --binary_gripper   --output_dir /home/niunj/data/IsaacLab_Data_Collection/eval/bc_static_wrist_rgb_100_aligned   --save_video_dir /home/niunj/data/IsaacLab_Data_Collection/videos/bc_static_wrist_rgb_100_aligned
python scripts/train/train_rgb_bc.py   --dataset /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_static_wrist_rgb_100_aligned_fast.hdf5   --run_dir /home/niunj/data/IsaacLab_Data_Collection/runs/bc_static_wrist_rgb_100_aligned   --camera_mode static_wrist   --epochs 80   --batch_size 256   --device auto   --cache_in_memory   --save_every 0
~/code/IsaacLab/isaaclab.sh -p scripts/eval/eval_rgb_bc_rollout.py   --headless   --enable_cameras   --checkpoint /home/niunj/data/IsaacLab_Data_Collection/runs/bc_static_wrist_rgb_100_aligned/best.pt   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --num_rollouts 10   --max_steps 700   --binary_gripper   --output_dir /home/niunj/data/IsaacLab_Data_Collection/eval/bc_static_wrist_rgb_100_aligned   --save_video_dir /home/niunj/data/IsaacLab_Data_Collection/videos/bc_static_wrist_rgb_100_aligned
~/code/IsaacLab/isaaclab.sh -p scripts/tools/replay_demos_agx_video.py   --headless   --enable_cameras   --input_file /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_lowdim_100.hdf5   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --video   --video_length 700   --video_dir /home/niunj/data/IsaacLab_Data_Collection/videos/expert_replay_lowdim_100
find /home/niunj/data/IsaacLab_Data_Collection/videos/expert_replay_lowdim_100   -type f
~/code/IsaacLab/isaaclab.sh -p scripts/tools/replay_demos_agx_video.py   --headless   --enable_cameras   --dataset_file /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_lowdim_100.hdf5   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --select_episodes 0   --video   --video_length 700   --video_dir /home/niunj/data/IsaacLab_Data_Collection/videos/expert_replay_lowdim_100
~/code/IsaacLab/isaaclab.sh -p scripts/tools/replay_demos_viewport_video.py   --headless   --enable_cameras   --dataset_file /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_lowdim_100.hdf5   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --select_episodes 0   --video_length 700   --video_dir /home/niunj/data/IsaacLab_Data_Collection/videos/expert_viewport_static_wrist_100
~/code/IsaacLab/isaaclab.sh -p scripts/tools/replay_demos_viewport_video.py   --headless   --enable_cameras   --dataset_file /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_lowdim_100.hdf5   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --select_episodes 0   --video_length 700   --video_dir /home/niunj/data/IsaacLab_Data_Collection/videos/expert_viewport_static_wrist_100
python scripts/tools/add_language_instruction.py   --input_dataset /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_static_wrist_rgb_100_aligned_fast.hdf5   --output_dataset /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_static_wrist_rgb_lang_100_aligned.hdf5   --instruction "stack the cube with the Piper robot arm"   --overwrite_output
python scripts/tools/export_vla_manifest.py   --dataset /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_static_wrist_rgb_lang_100_aligned.hdf5   --output_dir /home/niunj/data/IsaacLab_Data_Collection/vla_exports/piper_stack_vla_100_aligned   --chunk_size 20   --overwrite
CUDA_VISIBLE_DEVICES=0 python scripts/train/train_act_style.py   --manifest_dir /home/niunj/data/IsaacLab_Data_Collection/vla_exports/piper_stack_vla_100_aligned   --run_dir /home/niunj/data/IsaacLab_Data_Collection/runs/act_style_piper_stack_100_aligned_chunk10   --epochs 100 --batch_size 128 --chunk_size 10 --device auto --cache_in_memory   --hidden_dim 128 --image_feature_dim 128 --num_layers 2 --num_heads 4 --save_every 0
CUDA_VISIBLE_DEVICES=0 python scripts/train/train_act_style.py   --manifest_dir /home/niunj/data/IsaacLab_Data_Collection/vla_exports/piper_stack_vla_100_aligned   --run_dir /home/niunj/data/IsaacLab_Data_Collection/runs/act_style_piper_stack_100_aligned_chunk10   --epochs 150   --batch_size 128   --chunk_size 10   --device auto   --cache_in_memory   --hidden_dim 128   --image_feature_dim 128   --num_layers 2   --num_heads 4   --resume_checkpoint /home/niunj/data/IsaacLab_Data_Collection/runs/act_style_piper_stack_100_aligned_chunk10/last.pt   --save_every 0
CUDA_VISIBLE_DEVICES=2 python scripts/train/train_act_style.py   --manifest_dir /home/niunj/data/IsaacLab_Data_Collection/vla_exports/piper_stack_vla_100_aligned   --run_dir /home/niunj/data/IsaacLab_Data_Collection/runs/act_style_piper_stack_100_aligned_h256   --epochs 180   --batch_size 128   --chunk_size 20   --device auto   --cache_in_memory   --hidden_dim 256   --image_feature_dim 256   --num_layers 3   --num_heads 8   --resume_checkpoint /home/niunj/data/IsaacLab_Data_Collection/runs/act_style_piper_stack_100_aligned_h256/last.pt   --save_every 0
~/code/IsaacLab/isaaclab.sh -p scripts/eval/eval_act_style_rollout.py   --headless   --enable_cameras   --checkpoint /home/niunj/data/IsaacLab_Data_Collection/runs/act_style_piper_stack_100_aligned_h256/best.pt   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --instruction "stack the cube with the Piper robot arm"   --num_rollouts 5   --max_steps 700   --exec_horizon 5   --binary_gripper   --output_dir /home/niunj/data/IsaacLab_Data_Collection/eval/act_style_piper_stack_100_aligned_h256   --save_video_dir /home/niunj/data/IsaacLab_Data_Collection/videos/act_style_piper_stack_100_aligned_h256
~/code/IsaacLab/isaaclab.sh -p scripts/eval/eval_act_style_rollout.py   --headless   --enable_cameras   --checkpoint /home/niunj/data/IsaacLab_Data_Collection/runs/act_style_piper_stack_100_aligned_h256/best.pt   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --instruction "stack the cube with the Piper robot arm"   --num_rollouts 3   --max_steps 700   --exec_horizon 1   --binary_gripper   --output_dir /home/niunj/data/IsaacLab_Data_Collection/eval/act_h256_exec1   --save_video_dir /home/niunj/data/IsaacLab_Data_Collection/videos/act_h256_exec1
~/code/IsaacLab/isaaclab.sh -p scripts/eval/eval_act_style_rollout.py   --headless   --enable_cameras   --checkpoint /home/niunj/data/IsaacLab_Data_Collection/runs/act_style_piper_stack_100_aligned_h256/best.pt   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --instruction "stack the cube with the Piper robot arm"   --num_rollouts 3   --max_steps 700   --exec_horizon 5   --output_dir /home/niunj/data/IsaacLab_Data_Collection/eval/act_h256_no_binary_gripper   --save_video_dir /home/niunj/data/IsaacLab_Data_Collection/videos/act_h256_no_binary_gripper
python scripts/tools/export_vla_manifest.py   --dataset /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_static_wrist_rgb_lang_100_aligned.hdf5   --output_dir /home/niunj/data/IsaacLab_Data_Collection/vla_exports/piper_stack_vla_100_aligned_privileged   --state_keys eef_pos eef_quat gripper_pos joint_pos joint_vel cube_positions cube_orientations   --chunk_size 20   --overwrite
CUDA_VISIBLE_DEVICES=2 python scripts/train/train_act_style.py   --manifest_dir /home/niunj/data/IsaacLab_Data_Collection/vla_exports/piper_stack_vla_100_aligned_privileged   --run_dir /home/niunj/data/IsaacLab_Data_Collection/runs/act_style_piper_stack_100_aligned_privileged_h256   --epochs 120   --batch_size 128   --chunk_size 20   --device auto   --cache_in_memory   --hidden_dim 256   --image_feature_dim 256   --num_layers 3   --num_heads 8   --save_every 0
~/code/IsaacLab/isaaclab.sh -p scripts/eval/eval_act_style_rollout.py   --headless   --enable_cameras   --checkpoint /home/niunj/data/IsaacLab_Data_Collection/runs/act_style_piper_stack_100_aligned_privileged_h256/best.pt   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --instruction "stack the cube with the Piper robot arm"   --num_rollouts 5   --max_steps 700   --exec_horizon 5   --binary_gripper   --output_dir /home/niunj/data/IsaacLab_Data_Collection/eval/act_style_piper_stack_100_aligned_privileged_h256   --save_video_dir /home/niunj/data/IsaacLab_Data_Collection/videos/act_style_piper_stack_100_aligned_privileged_h256
~/code/IsaacLab/isaaclab.sh -p scripts/eval/eval_act_style_rollout.py   --headless   --enable_cameras   --checkpoint /home/niunj/data/IsaacLab_Data_Collection/runs/act_style_piper_stack_100_aligned_privileged_h256/best.pt   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --instruction "stack the cube with the Piper robot arm"   --num_rollouts 3   --max_steps 700   --exec_horizon 5   --output_dir /home/niunj/data/IsaacLab_Data_Collection/eval/act_privileged_no_binary   --save_video_dir /home/niunj/data/IsaacLab_Data_Collection/videos/act_privileged_no_binary
~/code/IsaacLab/isaaclab.sh -p scripts/eval/eval_act_style_rollout.py   --headless   --enable_cameras   --checkpoint /home/niunj/data/IsaacLab_Data_Collection/runs/act_style_piper_stack_100_aligned_privileged_h256/best.pt   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --instruction "stack the cube with the Piper robot arm"   --num_rollouts 3   --max_steps 700   --exec_horizon 1   --output_dir /home/niunj/data/IsaacLab_Data_Collection/eval/act_privileged_exec1_no_binary   --save_video_dir /home/niunj/data/IsaacLab_Data_Collection/videos/act_privileged_exec1_no_binary
CUDA_VISIBLE_DEVICES=2 python scripts/train/train_act_style.py   --manifest_dir /home/niunj/data/IsaacLab_Data_Collection/vla_exports/piper_stack_vla_100_aligned_privileged   --run_dir /home/niunj/data/IsaacLab_Data_Collection/runs/act_style_piper_stack_100_aligned_privileged_h256_progress   --epochs 120   --batch_size 256   --chunk_size 20   --device auto   --cache_in_memory   --hidden_dim 256   --image_feature_dim 256   --num_layers 3   --num_heads 8   --use_progress   --save_every 0
~/code/IsaacLab/isaaclab.sh -p scripts/eval/eval_act_style_rollout.py   --headless   --enable_cameras   --checkpoint /home/niunj/data/IsaacLab_Data_Collection/runs/act_style_piper_stack_100_aligned_privileged_h256_progress/best.pt   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --instruction "stack the cube with the Piper robot arm"   --num_rollouts 5   --max_steps 700   --exec_horizon 5   --output_dir /home/niunj/data/IsaacLab_Data_Collection/eval/act_privileged_h256_progress   --save_video_dir /home/niunj/data/IsaacLab_Data_Collection/videos/act_privileged_h256_progress
~/code/IsaacLab/isaaclab.sh -p scripts/tools/replay_demos_viewport_video.py   --headless   --enable_cameras   --dataset_file /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_lowdim_100.hdf5   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --select_episodes 0   --video_length 260   --policy_height 256   --policy_width 256   --display_height 256   --display_width 256   --static_eye 0.78 -0.38 0.48   --static_target 0.45 0.00 0.04   --video_dir /home/niunj/data/IsaacLab_Data_Collection/videos/camera_preview_static_close_256
~/code/IsaacLab/isaaclab.sh -p scripts/tools/replay_demos_viewport_video.py   --headless   --enable_cameras   --dataset_file /home/niunj/data/IsaacLab_Data_Collection/datasets/ik_lowdim_100.hdf5   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --select_episodes 0   --video_length 260   --policy_height 256   --policy_width 256   --display_height 256   --display_width 256   --static_eye 0.78 -0.38 0.48   --static_target 0.45 0.00 0.04   --video_dir /home/niunj/data/IsaacLab_Data_Collection/videos/camera_preview_static_close_256
nohup bash scripts/tools/run_50demos_close256_pipeline.sh   > /home/niunj/data/IsaacLab_Data_Collection/logs/run_50demos_close256_pipeline.out 2>&1 &
nvidia-smi
cd /home/niunj/code/IsaacLab_Data_Collection
source /home/niunj/miniconda3/etc/profile.d/conda.sh
conda activate isaaclab23
unset PYTHONPATH LD_LIBRARY_PATH CARB_APP_PATH EXP_PATH ISAAC_PATH
export TERM=xterm
export ISAACSIM_PATH=/home/niunj/isaacsim
source /home/niunj/isaacsim/setup_conda_env.sh
mkdir -p /home/niunj/data/IsaacLab_Data_Collection/logs
python -c "import isaacsim, isaaclab, torch, h5py; print('env ok', torch.cuda.device_count())"
nohup bash scripts/tools/run_50demos_close256_pipeline.sh   > /home/niunj/data/IsaacLab_Data_Collection/logs/run_50demos_close256_pipeline.out 2>&1 &
kill 2009000
nohup bash scripts/tools/run_50demos_close256_pipeline.sh   > /home/niunj/data/IsaacLab_Data_Collection/logs/run_50demos_close256_pipeline.out 2>&1 &
tail -f /home/niunj/data/IsaacLab_Data_Collection/logs/run_50demos_close256_pipeline.out
cd ~/code/IsaacLab_Data_Collection
source ~/miniconda3/etc/profile.d/conda.sh
conda activate isaaclab23
unset PYTHONPATH LD_LIBRARY_PATH CARB_APP_PATH EXP_PATH ISAAC_PATH
export TERM=xterm
export ISAACSIM_PATH=~/isaacsim
source ~/isaacsim/setup_conda_env.sh
cd ~/code/IsaacLab_Data_Collection
~/code/IsaacLab/isaaclab.sh -p scripts/eval/eval_act_style_rollout.py   --headless   --enable_cameras   --checkpoint /home/niunj/data/IsaacLab_Data_Collection/runs/act_style_piper_stack_50_close_256_privileged_h256/best.pt   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --num_rollouts 3   --max_steps 700   --exec_horizon 5   --image_height 256   --image_width 256   --static_eye 0.78 -0.38 0.48   --static_target 0.45 0.00 0.04   --warmup_steps 2   --render_retries 1   --save_video_dir /home/niunj/data/IsaacLab_Data_Collection/videos/eval_act_50_close256_privileged_best   --output_dir /home/niunj/data/IsaacLab_Data_Collection/eval/act_50_close256_privileged_best
~/code/IsaacLab/isaaclab.sh -p scripts/eval/eval_act_style_rollout.py   --headless --enable_cameras   --checkpoint /home/niunj/data/IsaacLab_Data_Collection/runs/act_style_piper_stack_50_close_256_privileged_h256/best.pt   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --num_rollouts 5   --max_steps 700   --exec_horizon 3   --image_height 256 --image_width 256   --static_eye 0.78 -0.38 0.48   --static_target 0.45 0.00 0.04   --warmup_steps 2   --render_retries 1   --save_video_dir /home/niunj/data/IsaacLab_Data_Collection/videos/eval_act_50_close256_privileged_best_h3   --output_dir /home/niunj/data/IsaacLab_Data_Collection/eval/act_50_close256_privileged_best_h3
~/code/IsaacLab/isaaclab.sh -p scripts/eval/eval_act_style_rollout.py   --headless --enable_cameras   --checkpoint /home/niunj/data/IsaacLab_Data_Collection/runs/act_style_piper_stack_50_close_256_privileged_h256/best.pt   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --num_rollouts 5   --max_steps 700   --exec_horizon 8   --image_height 256 --image_width 256   --static_eye 0.78 -0.38 0.48   --static_target 0.45 0.00 0.04   --warmup_steps 2   --render_retries 1   --save_video_dir /home/niunj/data/IsaacLab_Data_Collection/videos/eval_act_50_close256_privileged_best_h8   --output_dir /home/niunj/data/IsaacLab_Data_Collection/eval/act_50_close256_privileged_best_h8
cd ~/code/IsaacLab_Data_Collection
source ~/miniconda3/etc/profile.d/conda.sh
conda activate isaaclab23
unset PYTHONPATH LD_LIBRARY_PATH CARB_APP_PATH EXP_PATH ISAAC_PATH
export TERM=xterm
export ISAACSIM_PATH=~/isaacsim
source ~/isaacsim/setup_conda_env.sh
~/code/IsaacLab/isaaclab.sh -p scripts/eval/eval_act_style_rollout.py   --headless --enable_cameras   --checkpoint /home/niunj/data/IsaacLab_Data_Collection/runs/act_style_piper_stack_50_close_256_privileged_h256/best.pt   --task Isaac-Stack-Cube-Piper-IK-Rel-v0   --num_rollouts 5   --max_steps 700   --exec_horizon 8   --image_height 256 --image_width 256   --static_eye 0.78 -0.38 0.48   --static_target 0.45 0.00 0.04   --warmup_steps 2   --render_retries 1   --save_video_dir /home/niunj/data/IsaacLab_Data_Collection/videos/eval_act_50_close256_privileged_best_h8   --output_dir /home/niunj/data/IsaacLab_Data_Collection/eval/act_50_close256_privileged_best_h8
nvidia -smi
nvidia -sim

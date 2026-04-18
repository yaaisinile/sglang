# ===== Base Image（已包含 PyTorch + vLLM + Triton）=====
FROM rocm/vllm-dev:rocm7.2.1_navi_ubuntu24.04_py3.12_pytorch_2.9_vllm_0.16.0

# ===== 环境变量：强制支持 gfx1201 =====
ENV HSA_OVERRIDE_GFX_VERSION=12.0.1
ENV ROCM_TARGETS="gfx1201"
ENV AMDGPU_TARGETS="gfx1201"
ENV PYTORCH_ROCM_ARCH="gfx1201"
ENV TRITON_CODEGEN_ARCH="gfx1201"
ENV TORCH_CUDA_ARCH_LIST="gfx1201"

# ===== 基础工具 =====
RUN apt-get update && apt-get install -y \
    git \
    wget \
    vim \
    build-essential \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# ===== 工作目录 =====
WORKDIR /workspace

# ===== 拉取你的 fork 代码 =====
RUN git clone https://github.com/yaaisinile/sglang.git
WORKDIR /workspace/sglang
RUN git checkout rocm-gfx1201

# ===== 安装 Python 依赖（关键修复）=====
RUN pip install --upgrade pip setuptools wheel
RUN pip install -e ".[all]" --no-build-isolation

# ===== 编译 sglang kernel =====
RUN python setup.py build_ext --inplace

# ===== 启动命令 =====
CMD ["bash"]

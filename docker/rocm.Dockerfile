# ===== Base Image =====
FROM rocm/vllm-dev:rocm7.2.1_navi_ubuntu24.04_py3.12_pytorch_2.9_vllm_0.16.0

# ===== ROCm gfx1201 环境 =====
ENV HSA_OVERRIDE_GFX_VERSION=12.0.1
ENV ROCM_TARGETS="gfx1201"
ENV AMDGPU_TARGETS="gfx1201"
ENV PYTORCH_ROCM_ARCH="gfx1201"

# ===== 工具安装 =====
RUN apt-get update && apt-get install -y git build-essential && rm -rf /var/lib/apt/lists/*

# ===== 关键：先克隆你的代码 =====
WORKDIR /workspace
RUN git clone https://github.com/yaaisinile/sglang.git sglang

# ===== 进入代码目录，切换分支 =====
WORKDIR /workspace/sglang
RUN git checkout rocm-gfx1201

# ===== 现在再安装！=====
RUN pip install --upgrade pip setuptools wheel
RUN pip install -e ".[all]" --no-build-isolation

# ===== 编译 kernel =====
RUN python setup.py build_ext --inplace

CMD ["bash"]

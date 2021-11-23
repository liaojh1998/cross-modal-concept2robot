FROM nvidia/cuda@sha256:2306f0ee302b90bf16fa43f700fef074cee20f6e46f4b6ab462cd8d6c8eb5eef

RUN apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    curl \
    git \
    libgl1-mesa-dev \
    libgl1-mesa-glx \
    libglew-dev \
    libosmesa6-dev \
    software-properties-common \
    net-tools \
    vim \
    virtualenv \
    wget \
    xpra \
    xserver-xorg-dev \
    libglfw3-dev \
    patchelf \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN DEBIAN_FRONTEND=noninteractive add-apt-repository --yes ppa:deadsnakes/ppa && apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install --yes python3.7-dev python3.7 python3-pip

ENV LANG C.UTF-8

RUN mkdir -p /root/.mujoco \
    && wget https://mujoco.org/download/mujoco210-linux-x86_64.tar.gz -O mujoco.tar.gz \
    && tar -xf mujoco.tar.gz -C /root/.mujoco \
    && rm mujoco.tar.gz

ENV LD_LIBRARY_PATH /root/.mujoco/mujoco210/bin:${LD_LIBRARY_PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib64:${LD_LIBRARY_PATH}

RUN rm /usr/bin/python
RUN rm /usr/bin/python3
RUN ln -s /usr/bin/python3.7 /usr/bin/python
RUN ln -s /usr/bin/python3.7 /usr/bin/python3
RUN python -m pip install --upgrade pip

RUN pip install --no-cache-dir free-mujoco-py==2.1.6
RUN pip install --no-cache-dir robosuite==1.3.1

ENV LD_PRELOAD /usr/lib/x86_64-linux-gnu/libGLEW.so 
RUN python -m robosuite.__init__
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y xvfb x11vnc fluxbox tmux

RUN DEBIAN_FRONTEND=noninteractive apt-get install --yes autoconf \
    automake \
    build-essential \
    cmake \
    libass-dev \
    libfreetype6-dev \
    libjpeg-dev \
    libtheora-dev \
    libtool \
    libvorbis-dev \
    libx264-dev \
    pkg-config \
    yasm \
    zlib1g-dev \
    ffmpeg \
    libedit-dev \
    libc6-dev

RUN pip install --no-cache-dir av==8.0.3 \
    backcall==0.2.0 \
    bleach==4.0.0 \
    decorator==5.1.0 \
    entrypoints==0.3 \
    ipywidgets==7.6.5 \
    jedi==0.18.0 \
    jupyterlab==3.2.0 \
    matplotlib==3.3.4 \
    mkl==2021.4.0 \
    mkl-fft==1.3.1 \
    ninja==1.10.2 \
    notebook==6.3.0 \
    pandoc==1.1.0 \
    qtconsole==5.1.1 \
    scikit-learn==0.24.2 \
    scikit-video==1.1.11 \
    opencv-python==4.5.3.56 \
    tensorboardx==2.4 \
    pybullet==3.0.6 \
    sh==1.14.2

RUN pip install torch==1.10.0+cu113 \
    torchvision==0.11.1+cu113 \
    torchaudio==0.10.0+cu113 \
    torchtext \
    -f https://download.pytorch.org/whl/cu113/torch_stable.html

WORKDIR /cross_modal_concept2robot
COPY . /cross_modal_concept2robot

#!/bin/bash

sudo apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive sudo apt-get install -y \
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
    patchelf

DEBIAN_FRONTEND=noninteractive sudo add-apt-repository --yes ppa:deadsnakes/ppa && apt-get update
#DEBIAN_FRONTEND=noninteractive sudo apt-get install --yes python3.7-dev python3.7 python3-pip
#DEBIAN_FRONTEND=noninteractive sudo apt-get install -y xvfb x11vnc fluxbox tmux
DEBIAN_FRONTEND=noninteractive sudo apt-get install -y x11vnc

DEBIAN_FRONTEND=noninteractive sudo apt-get install --yes autoconf \
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
    libc6-dev \
    mesa-utils

sudo apt-get clean

mkdir -p ${HOME}/.mujoco \
    && wget https://mujoco.org/download/mujoco210-linux-x86_64.tar.gz -O mujoco.tar.gz \
    && tar -xf mujoco.tar.gz -C ${HOME}/.mujoco \
    && rm mujoco.tar.gz

pip install --no-cache-dir free-mujoco-py==2.1.6
pip install --no-cache-dir robosuite==1.3.1 --ignore-installed
pip install --no-cache-dir av==8.0.3 \
    backcall==0.2.0 \
    bleach==4.1.0 \
    decorator==5.1.0 \
    entrypoints==0.3 \
    ipywidgets==7.6.5 \
    jedi==0.18.0 \
    jupyterlab==3.2.2 \
    matplotlib==3.4.3 \
    mkl==2021.4.0 \
    mkl-fft==1.3.1 \
    ninja==1.10.2 \
    notebook==6.4.5 \
    pandoc==1.1.0 \
    qtconsole==5.1.1 \
    scikit-learn==1.0.1 \
    scikit-video==1.1.11 \
    opencv-python==4.5.3.56 \
    tensorboardx==2.4 \
    pybullet==3.0.6 \
    sh==1.14.2 \
    imageio-ffmpeg==0.4.5

#pip install torch==1.10.0+cu113 \
#    torchvision==0.11.1+cu113 \
#    torchaudio==0.10.0+cu113 \
#    torchtext \
#    -f https://download.pytorch.org/whl/cu113/torch_stable.html

FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04

# add new sudo user
ENV USERNAME isaac
ENV HOME /home/$USERNAME
RUN useradd -m $USERNAME && \
        echo "$USERNAME:$USERNAME" | chpasswd && \
        usermod --shell /bin/bash $USERNAME && \
        usermod -aG sudo $USERNAME && \
        mkdir /etc/sudoers.d && \
        echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$USERNAME && \
        chmod 0440 /etc/sudoers.d/$USERNAME && \
        # Replace 1000 with your user/group id
        usermod  --uid 1000 $USERNAME && \
        groupmod --gid 1000 $USERNAME

# install package
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        curl \
        sudo \
        apt-utils \
        tzdata \
        git \
        bash-completion \
        command-not-found \
        libgtk2.0-0 \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# install Isaac SDK
USER isaac
COPY isaac-sdk-2019.2-30e21124.tar.xz /home/$USERNAME/
COPY isaac_navsim-2019-07-23.tar.xz /home/$USERNAME/
WORKDIR /home/$USERNAME
RUN mkdir isaac_sdk && \
    tar -xf isaac-sdk-2019.2-30e21124.tar.xz -C isaac_sdk && \
    cd isaac_sdk && \
    bash engine/build/scripts/install_dependencies.sh && \
    mkdir -p isaac_sdk/packages/navsim/unity && \
    tar -xf isaac_navsim-2019-07-23.tar.xz -C isaac_sdk/packages/navsim/unity

ENV NVIDIA_VISIBLE_DEVICES ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

USER root
RUN rm /home/$USERNAME/isaac-sdk-2019.2-30e21124.tar.xz && \
    rm /home/$USERNAME/isaac_navsim-2019-07-23.tar.xz

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
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# install Isaac SDK
USER isaac
COPY isaac_sdk-2019.1-17919.tar.xz /home/$USERNAME/
WORKDIR /home/$USERNAME
RUN mkdir isaac_sdk && \
    tar Jxfv isaac_sdk-2019.1-17919.tar.xz -C isaac_sdk && \
    cd isaac_sdk && \
    bash engine/build/scripts/install_dependencies.sh

ENV NVIDIA_VISIBLE_DEVICES ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

USER root
RUN rm /home/$USERNAME/isaac_sdk-2019.1-17919.tar.xz

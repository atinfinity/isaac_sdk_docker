FROM nvidia/cuda:10.0-cudnn7-devel-ubuntu18.04

ENV NVIDIA_VISIBLE_DEVICES ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

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
        tmux \
        bash-completion \
        command-not-found \
        libglib2.0-0 \
        gstreamer1.0-plugins-* \
        libgstreamer1.0-* \
        libgstreamer-plugins-*1.0-* \
        && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# install Isaac SDK
USER isaac
COPY isaac-sdk-20191213-65ec14db.tar.xz /home/$USERNAME/
COPY isaac_sim_unity3d-20191213-a61b74b7.tar.gz /home/$USERNAME/
WORKDIR /home/$USERNAME
RUN mkdir isaac_sdk && \
    tar -xf isaac-sdk-20191213-65ec14db.tar.xz -C isaac_sdk && \
    cd isaac_sdk && \
    bash engine/build/scripts/install_dependencies.sh && \
    mkdir -p /home/$USERNAME/isaac_sim_unity3d && \
    tar -xf /home/$USERNAME/isaac_sim_unity3d-20191213-a61b74b7.tar.gz -C /home/$USERNAME/isaac_sim_unity3d

USER root
RUN rm /home/$USERNAME/isaac-sdk-20191213-65ec14db.tar.xz && \
    rm /home/$USERNAME/isaac_sim_unity3d-20191213-a61b74b7.tar.gz

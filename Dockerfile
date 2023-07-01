#!/usr/bin/env docker

# This is a template for a Dockerfile to build a docker image for your ROS package. 
# The main purpose of this file is to install dependencies for your package.

FROM dustynv/ros:melodic-ros-base-l4t-r32.4.4       

ENV ROS_ROOT=/opt/ros/melodic     

# Set up workspace
RUN mkdir -p /ws/src   

# Set noninteractive installation
ENV DEBIAN_FRONTEND=noninteractive

# Package apt dependencies
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    git \
    nano \
    usbutils \
    python-pip \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Args needed to substitute in the install step
ARG L4T_MINOR_VERSION=4.4
ARG ZED_SDK_MAJOR=3
ARG ZED_SDK_MINOR=6
ARG JETPACK_MAJOR=4
ARG JETPACK_MINOR=4

# Check if all ROS-related deps are installed (so rosdep doesn't has to do it during runtime)
RUN apt-get update && \
    apt-get install -y \
        ros-melodic-nav-msgs \
        ros-melodic-tf2-geometry-msgs \
        ros-melodic-message-runtime \
        ros-melodic-catkin \
        ros-melodic-roscpp \
        ros-melodic-stereo-msgs \
        ros-melodic-robot-state-publisher \
        ros-melodic-rosconsole \
        ros-melodic-urdf \
        ros-melodic-sensor-msgs \
        ros-melodic-image-transport \
        ros-melodic-roslint \
        ros-melodic-diagnostic-updater \
        ros-melodic-dynamic-reconfigure \
        ros-melodic-tf2-ros \
        ros-melodic-message-generation \
        ros-melodic-nodelet\
        ros-melodic-image-transport-plugins \
        ros-melodic-xacro \
        libusb-1.0-0-dev \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Download and install the ZED SDK
RUN apt-get update -y && apt-get install --no-install-recommends lsb-release wget less udev sudo apt-transport-https build-essential cmake -y&& \
    echo "# R32 (release), REVISION: ${L4T_MINOR_VERSION}" > /etc/nv_tegra_release ; \
    wget -q --no-check-certificate -O ZED_SDK_Linux_JP.run https://download.stereolabs.com/zedsdk/${ZED_SDK_MAJOR}.${ZED_SDK_MINOR}/jp${JETPACK_MAJOR}${JETPACK_MINOR}/jetsons && \
    chmod +x ZED_SDK_Linux_JP.run ; ./ZED_SDK_Linux_JP.run silent skip_tools && \
    rm -rf /usr/local/zed/resources/* \
    rm -rf ZED_SDK_Linux_JP.run && \
    rm -rf /var/lib/apt/lists/*

# this symbolic link is needed to use the streaming features on Jetson inside a container
RUN ln -sf /usr/lib/aarch64-linux-gnu/tegra/libv4l2.so.0 /usr/lib/aarch64-linux-gnu/libv4l2.so

# Install catkin command line tools
RUN pip install --upgrade pip \
    && pip install \
        catkin_tools

WORKDIR /ws

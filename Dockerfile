FROM osrf/ros:humble-desktop

# Setup environment variables & install essentials
ENV TZ=Asia/Dubai
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8
SHELL ["/bin/bash", "-c"]


RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    tzdata \
    wget \
    gnupg2 \
    lsb-release \
    git \
    tmux \
    tmuxinator \
    nano \
    && rm -rf /var/lib/apt/lists/* && apt-get clean -qq


RUN apt-get update \
    && apt-get install --no-install-recommends -y \
    python3-rosdep \
    python3-rosinstall \
    python3-rosinstall-generator \
    python3-wstool \
    python-is-python3 \
    python3-tk \
    ros-humble-image-transport-plugins \
    pip \
    build-essential \
    && rm -rf /var/lib/apt/lists/* && apt-get -qq clean


RUN pip install protobuf==3.20.0
RUN pip install numpy==1.21.6


# Set up workspace from local data
RUN mkdir -p /spot_ws/src
RUN mkdir -p /spot_ws/src/spot_ros2
WORKDIR /spot_ws
COPY . src/spot_ros2
RUN mv /spot_ws/src/spot_ros2/start.sh /spot_ws
RUN sudo chmod +x start.sh

RUN cd /spot_ws/src/spot_ros2 && \
    ./install_spot_ros2.sh 


# Source ROS & workspace automatically
RUN echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc 
#    && echo "source /spot_ws/install/local_setup.bash" >> /root/.bashrc

FROM tiryoh/ros2-desktop-vnc:humble-amd64-20230115T1406
ENV GAZEBO_MODEL_PATH /home/ubuntu/Desktop/gazebo_models
WORKDIR /home/ubuntu/Desktop
ADD https://api.github.com/repos/osrf/gazebo_models/git/refs/heads/master model_version.json
RUN git clone https://github.com/osrf/gazebo_models.git
WORKDIR /home/ubuntu/Desktop
RUN apt-get update && apt-get install -y \
    ros-humble-turtlebot3* \
    ros-humble-navigation* \
    ros-humble-rosbag2-storage-mcap \
    htop \
    && rm -rf /var/lib/apt/lists/*
RUN wget https://github.com/foxglove/studio/releases/download/v1.40.0/foxglove-studio-1.40.0-linux-amd64.deb && \
    sudo dpkg -i foxglove-studio-*.deb && \
    rm foxglove-studio-*.deb
ENV TURTLEBOT3_MODEL burger
COPY asound.conf /etc/asound.conf
ENV LIBGL_ALWAYS_SOFTWARE 1
RUN mkdir -p /home/ubuntu/Desktop/colcon_ws/src
WORKDIR /home/ubuntu/Desktop/colcon_ws/src
COPY rviz/rosbag_play.rviz /home/ubuntu/.rviz2/rosbag_play.rviz
COPY config/turtlebot3_navigation.json /home/ubuntu/Desktop/turtlebot3_navigation.json
COPY workspace.repos /home/ubuntu/Desktop/colcon_ws/src/workspace.repos
RUN curl -s https://raw.githubusercontent.com/karaage0703/ubuntu-setup/master/install-vscode.sh | /bin/bash
ENV RUST_VERSION stable
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain ${RUST_VERSION}
ENV PATH $PATH:$HOME/.cargo/bin
RUN apt install -y python3-pip && python3 -m pip install -U pip
RUN python3 -m pip install git+https://github.com/tier4/colcon-cargo.git git+https://github.com/colcon/colcon-ros-cargo.git
WORKDIR /home/ubuntu
RUN git clone https://github.com/tier4/cargo-ament-build && \
    cd cargo-ament-build && \
    cargo install --path .

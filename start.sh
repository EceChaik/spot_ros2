#!/bin/sh

set -e

SESSION_NAME=Spot_Docker

cd /spot_ws
apt update
rosdep install --from-paths src --ignore-src -r -y

cd /spot_ws/src/spot_ros2
./install_spot_ros2.sh 
cd ../..
colcon build --symlink-install

#source /opt/ros/humble/setup.bash
#source install/local_setup.bash
echo "source /opt/ros/humble/setup.bash" >> /root/.bashrc
echo "source /spot_ws/install/setup.bash" >> /root/.bashrc
echo "export BOSDYN_CLIENT_USERNAME=Nikolaos" >> /root/.bashrc
echo "export BOSDYN_CLIENT_PASSWORD=kinesis@2021" >> /root/.bashrc
echo "export SPOT_IP=192.168.80.3" >> /root/.bashrc

tmux new-session -s $SESSION_NAME
tmux split-window -v -p 50
tmux select-pane -t $SESSION_NAME:0.1

tmux attach-session -t $SESSION_NAME

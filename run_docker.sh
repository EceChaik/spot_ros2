#!/bin/bash

## Catch failure
set -e

docker build --rm . -t spot_dock

XAUTH=/tmp/.docker.xauth
if [ ! -f $XAUTH ]
then
    xauth_list=$(xauth nlist $DISPLAY)
    xauth_list=$(sed -e 's/^..../ffff/' <<< "$xauth_list")
    if [ ! -z "$xauth_list" ]
    then
        echo "$xauth_list" | xauth -f $XAUTH nmerge -
    else
        touch $XAUTH
    fi
    chmod a+r $XAUTH
fi

xhost local:root

docker run \
       -it \
       --name spot_ros2_work \
       --rm \
       --network host \
       --volume $XAUTH:$XAUTH \
       --volume /etc/localtime:/etc/localtime:ro \
       --env DISPLAY \
       --privileged \
       --userns=host \
       spot_dock:latest \
       /spot_ws/start.sh

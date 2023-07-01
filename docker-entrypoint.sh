#!/bin/bash
set -e
source /root/.bashrc
source "/opt/ros/melodic/setup.bash"             #<--- TODO: change to your ROS version

CONTAINER_INITIALIZED="CONTAINER_INITIALIZED_PLACEHOLDER"
if [ ! -e $CONTAINER_INITIALIZED ]; then
    touch $CONTAINER_INITIALIZED
    echo "-- First container startup --"
    catkin init
    #catkin config
    rosdep install --from-paths src --ignore-src -r -y
    catkin build
else
    echo "-- Not first container startup --"
    source "/ws/devel/setup.bash"
fi


exec "$@"
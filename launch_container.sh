#!/bin/sh

XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
touch $XAUTH
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

docker run --runtime=nvidia --rm -it \
           --volume=$XSOCK:$XSOCK:rw \
           --volume=$XAUTH:$XAUTH:rw \
           --env="XAUTHORITY=${XAUTH}" \
           --env="DISPLAY" \
           --net=host \
           -u "isaac"  \
           isaac_sdk:latest \
           bash

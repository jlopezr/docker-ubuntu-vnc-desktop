#!/bin/bash
docker run -it --rm -p 6080:6080 -p 5900:5900 -v $PWD/data:/data --privileged -e RESOLUTION=$RESOLUTION hub.aaaida.com:5000/flowit/desktop

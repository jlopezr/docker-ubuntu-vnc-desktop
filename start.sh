#!/bin/bash
docker run -it --rm -p 6080:80 -p 5900:5900 -v $PWD/data:/data --privileged djdevel

#!/bin/bash

export DOCKER_BUILDKIT=1
DIST=ubuntu
VER=20.04

docker build --tag=ffmpeg:fully-static --output type=local,dest=build .

sudo chown $USER:$USER build/*

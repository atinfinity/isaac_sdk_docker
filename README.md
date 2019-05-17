# isaac_sdk_docker

## Introduction
This is Dockerfile to use [NVIDIA Isaac SDK](https://developer.nvidia.com/isaac-sdk) on Docker container.

## Requirements
* NVIDIA graphics driver >= 418.0
* Docker
* nvidia-docker2

## Preparation
### Download NVIDIA Isaac SDK
Please download NVIDIA Isaac SDK from <https://developer.nvidia.com/isaac-sdk>.  
And, please put NVIDIA Isaac SDK in the same directory as the Dockerfile.  
This time, I used `isaac_sdk-2019.1-17919.tar.xz`.

### Build Docker image
```
$ docker build -t isaac .
```

### Create Docker container
```
$ ./launch_container.sh
```

## Running sample application
### Build sample application
```
$ cd isaac_sdk
$ bazel build //apps/samples/stereo_dummy
```

### Running sample application
```
$ bazel run //apps/samples/stereo_dummy
```

### Open the visualization
Please open the visualization frontend by opening `http://localhost:3000` in a browser.

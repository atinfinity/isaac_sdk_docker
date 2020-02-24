# isaac_sdk_docker

## Introduction
This is Dockerfile to use [NVIDIA Isaac SDK](https://developer.nvidia.com/isaac-sdk) on Docker container.

## Requirements
- NVIDIA graphics driver >= 418.0
- Docker
- nvidia-docker2

## Preparation
### Download NVIDIA Isaac SDK
Please download NVIDIA Isaac SDK from <https://developer.nvidia.com/isaac-sdk>.  
And, please put NVIDIA Isaac SDK in the same directory as the Dockerfile.  
This time, I used the following package.

- `isaac-sdk-20191213-65ec14db.tar.xz`
- `isaac_sim_unity3d-20191213-a61b74b7.tar.gz`

### Build Docker image
```
$ docker build -t isaac_sdk .
```

### Create Docker container
```
$ ./launch_container.sh
```

## Running sample application
### Build sample application
```
$ cd ~/isaac_sdk
$ bazel build //apps/samples/stereo_dummy
```

### Running sample application
```
$ bazel run //apps/samples/stereo_dummy
```

### Open the visualization
Please open the visualization frontend by opening <http://localhost:3000>. in a browser.

## Running IsaacSim and Carter navigation stack
### Running IsaacSim
```
$ cd ~/isaac_sim_unity3d/builds
$ ./isaac_sim_unity3d.x86_64 --scene small_warehouse
```

### Running Carter navigation stack
```
$ cd ~/isaac_sdk
$ bazel run //apps/navsim:navsim_navigate
```

### Open the visualization
Please open the visualization frontend by opening <http://localhost:3000> in a browser.

## Reference
- https://developer.nvidia.com/isaac-sdk
- https://docs.nvidia.com/isaac/isaac/doc/index.html
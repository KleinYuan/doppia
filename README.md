# Intro

Doppia is a collection of several research publications and original [repo](https://bitbucket.org/rodrigob/doppia) is hosted on bitbucket. 


# Machine Setup

- [X] Ubuntu (preferred)

- [X] GPU hardware

- [X] CUDA with capacity to be higher than 2.0

- [X] All boost libraries

- [X] Google protocol buffer

- [X] OpenCV 2.4 (3.0 is not supported yet)

- [X] libjpeg, libpng

- [X] libSDL

- [X] CMAKE >= 2.4.3


Dependencies | Version | Installation |
--- | --- | --- 
CUDA | 8.0 | Follow this [procedures](https://github.com/KleinYuan/easy-yolo#b-environment-gpu) |
OpenCV | 2.4.13 | Run this [script](https://github.com/KleinYuan/doppia/blob/master/dependencies/opencv_install.sh)
Protobuf | latest | Run this [script](https://github.com/KleinYuan/doppia/blob/master/dependencies/protobuf_install.sh)
All boost libraries | latest | `sudo apt-get install libboost-dev`  
libjpeg | latest | `sudo apt-get install libjpeg-dev`
libpng | latest | `sudo apt-get install libpng-dev`
libSDL | latest | `sudo apt-get install libSDL-dev`



# Compile and Run Demo


The code includes many applications and they all locate under `src/applications`.

Before doing everything, you need to modify this [line](https://github.com/KleinYuan/doppia/blob/master/common_settings.cmake#L342) in `common_settings.cmake` to replace the placeholder with your machine name.

Then run following script to ensure the protocol buffer files match the version installed in your system.

```
generate_protocol_buffer_files.sh
```

### 0. Summary


Basically, this is a project based on C++, meaning, how it works is that you need to 1) compile the code and obtain an executable, 2) config parameters and run executable against input.

Therefore, we describe compile (ground_estimation/stixel_world as CPU only example and object_detection as GPU example) first then how to run the demo.


### 1. Compile


#### 1.1 CPU Only Compile


Example for ground_estimation app

```
# Navigate to the path
cd doppia/src/applications/ground_estimation

# Compile
cmake -D CMAKE_BUILD_TYPE=RelWithDebInfo . && make -j2
```

Example for stixel_world

```
cd doppia/src/applications/stixel_world
cmake . && make -j2 
```

#### 1.2 GPU Compile


object_detection is build in a way to work with GPU

```
cd doppia/src/applications/objects_detection
cmake -D CMAKE_BUILD_TYPE=RelWithDebInfo -D USE_GPU=ON . && make -j2
```


### 2. Run Demo



#### 2.1 Run Ground Estimation Demos


```
./ground_estimation -c test.config.ini
```


#### 2.2 Run Stixel World Demos


```
# Demo 1
OMP_NUM_THREADS=4 ./stixel_world -c fast.config.ini --gui.disable false
```

```
# Demo 2
OMP_NUM_THREADS=4 ./stixel_world -c fast_uv.config.ini --gui.disable false
```


#### 2.3 Run Object Detection Demos


```
# Demo 1
OMP_NUM_THREADS=4 ./objects_detection -c cvpr2012_very_fast_over_bahnhof.config.ini --gui.disable false
```

```
# Demo 2
OMP_NUM_THREADS=4 ./objects_detection -c cvpr2012_inria_pedestrians.config.ini --gui.disable false
```

```
# Demo 3
OMP_NUM_THREADS=4 ./objects_detection -c cvpr2012_chnftrs_over_bahnhof.config.ini --gui.disable false
```

```
# Demo 4
./objects_detection -c eccv2014_face_detection_pascal.config.ini --gui.disable false
```


#### 2.4 Summary


So basically, after compile an app, you just need to define a config file with format like `*.config.ini` and use `object_detection` executable to run against it.

For example, `pedestrians detection` has an example config [file](https://github.com/KleinYuan/doppia/blob/master/src/applications/objects_detection/cvpr2012_inria_pedestrians.config.ini) and in this file, you can define whether you wanna input from directory or camera, scales, stride, mask, ...etc. For the example config of pedestrians detection, the input is sourced from [directory](https://github.com/KleinYuan/doppia/tree/master/data/sample_test_images/inria), which you can also easily define your own ones.

For more details, you can run `./object_detection --help` to see all the options.




### 3. Modifications



#### 3.1 OpenCV issues

Due to some OpenCV linking issues originally potentially from wrong order of linking lib, we have a fix for compiling apps by commenting out following in all `CMakeLists.txt`. (Original issue discussion can be found [here](https://bitbucket.org/rodrigob/doppia/issues/135/ground_estimation-linking-problems)).

```
#set(opencv_LIBRARIES
#    opencv_core opencv_imgproc opencv_highgui opencv_ml
#    opencv_video opencv_features2d
#    opencv_calib3d
#    opencv_objdetect opencv_contrib
#    opencv_legacy opencv_flann
#    opencv_gpu
#   ) # quick hack for opencv2.4 support
```

Example changes:

Name | Line | 
--- | --- 
ground_estimation | [line_40](https://github.com/KleinYuan/doppia/blob/master/src/applications/ground_estimation/CMakeLists.txt#L40)
stixel_world | [line_40](https://github.com/KleinYuan/doppia/blob/master/src/applications/stixel_world/CMakeLists.txt#L40)
object_detection | [line_42](https://github.com/KleinYuan/doppia/blob/master/src/applications/objects_detection/CMakeLists.txt#L42)



#### 3.2 CUDA modifications

You need to modify the cuda path with correct version on your machine and in here, the changes are below and original discussions can be found [here](https://bitbucket.org/rodrigob/doppia/issues/80/gpuveryfastintegralchannelsdetector):

- [X] Replacing all `cuda-5.5` with `cuda-8.0` since that's what I tested (you may have a different version and check by `ls /usr/local | grep cuda`)

- [X] Replacing all `cuda-5.5` in all related CMakeList.txt, for example in [object_detection](https://github.com/KleinYuan/doppia/blob/master/src/applications/objects_detection/CMakeLists.txt#L78)

- [X] Adding `USE_GPU` flag in object_detection [CMakeList.txt](https://github.com/KleinYuan/doppia/blob/master/src/applications/objects_detection/CMakeLists.txt#L32)

- [X] Indexing CUDA arch specifically in object_detection [CMakeList.txt](https://github.com/KleinYuan/doppia/blob/master/src/applications/objects_detection/CMakeLists.txt#L59) and make sure that the arch is the one your host machine is compatible, otherwise you may still be able to compile but throw errors

- [X] Enforce object_detection to be build with GPU ON by adding flag in cmake [command](https://github.com/KleinYuan/doppia#gpu-code)


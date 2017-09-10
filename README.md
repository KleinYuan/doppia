# Intro

Doppia is a collection of several research publications and original [repo](https://bitbucket.org/rodrigob/doppia) is hosted on bitbucket. 


# Machine Setup

-[X] Ubuntu (preferred)
-[X] GPU hardware
-[X] CUDA with capacity to be higher than 2.0
-[X] All boost libraries
-[X] Google protocol buffer
-[X] OpenCV 2.4 (3.0 is not supported yet)
-[X] libjpeg, libpng
-[X] libSDL
-[X] CMAKE >= 2.4.3

### Dependencies Installation

Dependencies | Version | Installation |
--- | --- | --- 
CUDA | 8.0 | Follow this [procedures](https://github.com/KleinYuan/easy-yolo#b-environment-gpu) |
OpenCV | 2.4.13 | Run this [script](https://github.com/KleinYuan/doppia/blob/master/dependencies/opencv_install.sh)
Protobuf | latest | Run this [script](https://github.com/KleinYuan/doppia/blob/master/dependencies/protobuf_install.sh.sh)
All boost libraries | latest | `sudo apt-get install libboost-dev`  
libjpeg | latest | `sudo apt-get install libjpeg-dev`
libpng | latest | `sudo apt-get install libpng-dev`
libSDL | latest | `sudo apt-get install libSDL-dev`

# Compile

The code includes many applications and they all locate under `src/applications`.

### CPU Only code

Example for ground_estimation app

```
# Navigate to the path
cd doppia/src/applications/ground_estimation

# Compile
cmake -D CMAKE_BUILD_TYPE=RelWithDebInfo . && make -j2

# Run Demo
cmake . && make -j2 && ./ground_estimation -c test.config.ini
```

Example for stixel_world

```
cd doppia/src/applications/stixel_world
cmake . && make -j2 && OMP_NUM_THREADS=4 ./stixel_world -c fast.config.ini --gui.disable false
cmake . && make -j2 && OMP_NUM_THREADS=4 ./stixel_world -c fast_uv.config.ini --gui.disable false
```

### GPU code

object_detection is build in a way to work with GPU

```
cd doppia/src/applications/objects_detection
cmake -D CMAKE_BUILD_TYPE=RelWithDebInfo . && make -j2
cmake . && make -j2 && OMP_NUM_THREADS=4 ./objects_detection -c cvpr2012_very_fast_over_bahnhof.config.ini --gui.disable false

# Demo1
cmake . && make -j2 && OMP_NUM_THREADS=4 ./objects_detection -c cvpr2012_inria_pedestrians.config.ini --gui.disable false

# Demo2
cmake . && make -j2 && OMP_NUM_THREADS=4 ./objects_detection -c cvpr2012_chnftrs_over_bahnhof.config.ini --gui.disable false

# Demo3
cmake . && make -j2 && ./objects_detection -c eccv2014_face_detection_pascal.config.ini --gui.disable false
```












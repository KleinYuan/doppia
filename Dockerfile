From ubuntu:14.04

RUN sudo apt-get update

# Dependencies for doppia
RUN sudo apt-get install -y git libboost-all-dev libpng-dev libjpeg-dev libSDL-dev python-opencv


COPY ./ app/

WORKDIR "/app/dependencies"

RUN sudo apt-get install -y curl wget unzip

# Install protobuf
RUN sudo apt-get install -y autoconf automake libtool curl make g++ unzip

# Install protobuf from src
RUN git clone https://github.com/google/protobuf.git
WORKDIR "/app/dependencies/protobuf"
RUN bash ./autogen.sh
RUN ./configure
RUN make
RUN make check
RUN sudo make install
RUN sudo ldconfig


# Install opencv-gpu-2.4.13
WORKDIR "/app/dependencies"
RUN sudo bash opencv_install.sh

# Compile
WORKDIR "/app/"
RUN bash generate_protocol_buffer_files.sh

WORKDIR "/app/src/applications/ground_estimation/"
RUN cmake -D CMAKE_BUILD_TYPE=RelWithDebInfo . && make -j2


#WORKDIR "/app/src/applications/stixel_world/"
#RUN cmake . && make -j2 



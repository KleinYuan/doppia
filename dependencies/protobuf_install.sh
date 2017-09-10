# Install dependencies first
sudo apt-get install autoconf automake libtool curl make g++ unzip

# Install protobuf from src
git clone https://github.com/google/protobuf.git
cd protobuf
./autogen.sh
./configure
make
make check
sudo make install
sudo ldconfig
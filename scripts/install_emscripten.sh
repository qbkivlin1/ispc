WD=`pwd`
git clone https://github.com/emscripten-core/emsdk.git && \
cd emsdk
git pull && \
./emsdk install sdk-1.39.11-64bit && \
./emsdk activate sdk-1.39.11-64bit  && \
source ./emsdk_env.sh
cd $WD
#!/bin/bash
set -e -o -x

SCRIPT_DIR="$( dirname "${BASH_SOURCE[0]}" )"
SOURCE_ROOT=$(realpath $SCRIPT_DIR/../../../../)

while getopts c:o:d:r:p:x: parameter_Option
do case "${parameter_Option}"
in
#ubuntu16.04
o) BUILD_OS=${OPTARG};;
#cpu, gpu
d) BUILD_DEVICE=${OPTARG};;
r) BUILD_DIR=${OPTARG};;
#python version: 3.6 3.7 (absence means default 3.5)
p) PYTHON_VER=${OPTARG};;
# "--build_wheel --use_openblas"
x) BUILD_EXTR_PAR=${OPTARG};;
esac
done

EXIT_CODE=1

echo "bo=$BUILD_OS bd=$BUILD_DEVICE bdir=$BUILD_DIR pv=$PYTHON_VER bex=$BUILD_EXTR_PAR"

cd $SCRIPT_DIR/docker
if [ $BUILD_DEVICE = "gpu" ]; then
    IMAGE="ubuntu16.04-cuda9.0-cudnn7.0"
    docker build -t "lotus-$IMAGE" --build-arg PYTHON_VERSION=${PYTHON_VER} -f Dockerfile.ubuntu_gpu .
else
    IMAGE="ubuntu16.04"
    docker build -t "lotus-$IMAGE" --build-arg OS_VERSION=16.04 --build-arg PYTHON_VERSION=${PYTHON_VER} -f Dockerfile.ubuntu .
fi

set +e

if [ $BUILD_DEVICE = "cpu" ]; then
    docker run -h $HOSTNAME \
        --rm -e AZURE_BLOB_KEY \
        --name "lotus-$BUILD_DEVICE" \
        --volume "$SOURCE_ROOT:/lotus_src" \
        --volume "$BUILD_DIR:/home/lotusdev" \
        "lotus-$IMAGE" \
        /bin/bash /lotus_src/tools/ci_build/vsts/linux/run_build.sh \
         -d $BUILD_DEVICE -x "$BUILD_EXTR_PAR" &
else
    nvidia-docker run -h $HOSTNAME \
        --rm -e AZURE_BLOB_KEY \
        --name "lotus-$BUILD_DEVICE" \
        --volume "$SOURCE_ROOT:/lotus_src" \
        --volume "$BUILD_DIR:/home/lotusdev" \
        "lotus-$IMAGE" \
        /bin/bash /lotus_src/tools/ci_build/vsts/linux/run_build.sh \
        -d $BUILD_DEVICE -x "$BUILD_EXTR_PAR" &
fi
wait -n

EXIT_CODE=$?

set -e
exit $EXIT_CODE

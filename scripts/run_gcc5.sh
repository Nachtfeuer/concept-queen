#!/bin/bash
SOURCE=${SOURCE:=Queen.cxx}
UPPER_LIMIT=${UPPER_LIMIT:=16}

if [ -$# -eq 0 ]; then
    docker run --rm=true -v $PWD:/docker \
           -e "SOURCE=$SOURCE" -e "UPPER_LIMIT=$UPPER_LIMIT" \
           -i centos:7.2.1511 /docker/scripts/run_gcc5.sh INIT
else
    case $1 in
        INIT)
            # https://www.softwarecollections.org/en/scls/rhscl/devtoolset-4/
            yum install -y centos-release-scl yum-utils
            yum-config-manager --enable rhel-server-rhscl-7-rpms
            yum install -y devtoolset-4-gcc-c++
            scl enable devtoolset-4 "/docker/scripts/run_gcc5.sh RUN"
            ;;
        RUN)
            OUT=/docker/reports/${SOURCE}.log

            rm -f "${OUT}"
            gcc -v | tee --append "${OUT}"

            echo "SOURCE=${SOURCE}" >> ${OUT}
            echo "VERSION=gcc 5.x" >> ${OUT}
            echo "TIMESTAMP=$(date +%s)" >> ${OUT}

            cp /docker/src/${SOURCE} .
            g++ -O3 -o queen -fopenmp --std=c++1y ${SOURCE} -lstdc++

            for n in $(seq 8 ${UPPER_LIMIT}); do
                ./queen "${n}" | tee --append "${OUT}"
            done
            ;;
        BASH)
            docker run --rm=true -v $PWD:/docker -it centos:7.2.1511 bash
            ;;
    esac
fi

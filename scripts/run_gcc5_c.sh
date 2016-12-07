#!/bin/bash
if [ -$# -eq 0 ]; then
    docker run --rm=true -v $PWD:/docker centos:7.2.1511 /docker/scripts/run_gcc5_c.sh INIT
else
    case $1 in
        INIT)
            # https://www.softwarecollections.org/en/scls/rhscl/devtoolset-4/
            yum install -y centos-release-scl yum-utils
            yum-config-manager --enable rhel-server-rhscl-7-rpms
            yum install -y devtoolset-4-gcc-c++
            scl enable devtoolset-4 "/docker/scripts/run_gcc5_c.sh RUN"
        ;;
        RUN)
            SOURCE=Queen.c
            OUT=/docker/reports/${SOURCE}.log
            rm -f "${OUT}"

            gcc -v | tee --append "${OUT}"

            echo "SOURCE=${SOURCE}" >> ${OUT}
            echo "VERSION=gcc 5.x" >> ${OUT}
            echo "TIMESTAMP=$(date +%s)" >> ${OUT}

            cp /docker/src/${SOURCE} .
            gcc -O3 -o queen ${SOURCE}

            for n in $(seq 8 16); do
                ./queen "${n}" | tee --append "${OUT}"
            done
        ;;
    esac
fi

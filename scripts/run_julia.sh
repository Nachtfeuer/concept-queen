#!/bin/bash
if [ -$# -eq 0 ]; then
    docker run --rm=true -v $PWD:/docker centos:7.2.1511 /docker/scripts/run_julia.sh INIT
else
    case $1 in
        INIT)
            yum install -y wget
            echo "downloading of Julia ..."
            wget -q https://julialang.s3.amazonaws.com/bin/linux/x64/0.5/julia-0.5.0-linux-x86_64.tar.gz
            PACKAGE=$(find . -type f -name "julia*.tar.gz")
            tar -xvzf ${PACKAGE} > /dev/null

            JULIA_PATH=$(find . -maxdepth 1 -type d -name "julia*")
            export PATH=$PATH:${JULIA_PATH}/bin
            $0 RUN
        ;;
        RUN)
            SOURCE=Queen.jl
            OUT=/docker/reports/${SOURCE}.log
            rm -f "${OUT}"

            echo "SOURCE=${SOURCE}" >> ${OUT}
            echo "VERSION=Julia 0.5" >> ${OUT}
            echo "TIMESTAMP=$(date +%s)" >> ${OUT}

            for n in $(seq 8 15); do
                julia /docker/src/${SOURCE} "${n}" | tee --append "${OUT}"
            done
        ;;
        BASH)
            docker run --rm=true -v $PWD:/docker -it centos:7.2.1511 bash
        ;;
    esac
fi

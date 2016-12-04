#!/bin/bash
if [ -$# -eq 0 ]; then
    docker run --rm=true -v $PWD:/docker centos:7.2.1511 /docker/scripts/run_pypy5.sh INIT
else
    case $1 in
        INIT)
            yum install -y epel-release
            yum install -y pypy
            pypy -V
            $0 RUN
        ;;
        RUN)
            SOURCE=Queen.py
            OUT=/docker/reports/${SOURCE}py.log

            echo "SOURCE=${SOURCE}" >> ${OUT}
            echo "VERSION=pypy 5.x" >> ${OUT}

            rm -f "${OUT}"
            for n in $(seq 8 15); do
                pypy /docker/src/${SOURCE} "${n}" | tee --append "${OUT}"
            done
        ;;
    esac
fi

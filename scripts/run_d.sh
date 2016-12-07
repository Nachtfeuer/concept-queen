#!/bin/bash
if [ -$# -eq 0 ]; then
    docker run --rm=true -v $PWD:/docker centos:7.2.1511 /docker/scripts/run_d.sh INIT
else
    case $1 in
        INIT)
            yum install -y wget
            echo "downloading of dmd RPM ..."
            wget -q http://downloads.dlang.org/releases/2.x/2.072.0/dmd-2.072.0-0.fedora.x86_64.rpm
            yum localinstall -y dmd-2.072.0-0.fedora.x86_64.rpm
            dmd --version
            $0 RUN
        ;;
        RUN)
            SOURCE=Queen.d
            OUT=/docker/reports/${SOURCE}.log
            rm -f "${OUT}"

            echo "SOURCE=${SOURCE}" >> ${OUT}
            echo "VERSION=dmd-2.072" >> ${OUT}
            echo "TIMESTAMP=$(date +%s)" >> ${OUT}

            cp /docker/src/${SOURCE} .
            dmd -O -release -inline -boundscheck=off ${SOURCE}

            for n in $(seq 8 16); do
                ./Queen "${n}" | tee --append "${OUT}"
            done
        ;;
    esac
fi

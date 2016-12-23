#!/bin/bash
SOURCE=${SOURCE:=Queen.py}
UPPER_LIMIT=${UPPER_LIMIT:=15}

if [ -$# -eq 0 ]; then
    docker run --rm=true -v $PWD:/docker \
           -e "SOURCE=$SOURCE" -e "UPPER_LIMIT=$UPPER_LIMIT" \
           centos:7.2.1511 /docker/scripts/run_pypy5.sh INIT
else
    case $1 in
        INIT)
            yum install -y epel-release
            yum install -y pypy
            pypy -V
            $0 RUN
        ;;
        RUN)
            OUT=/docker/reports/${SOURCE}py.log
            rm -f "${OUT}"

            echo "SOURCE=${SOURCE}" >> ${OUT}
            echo "VERSION=pypy 5.x" >> ${OUT}
            echo "TIMESTAMP=$(date +%s)" >> ${OUT}

            for n in $(seq 8 ${UPPER_LIMIT}); do
                pypy /docker/src/${SOURCE} "${n}" | tee --append "${OUT}"
            done
        ;;
    esac
fi

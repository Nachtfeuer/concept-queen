#!/bin/bash
SOURCE=${SOURCE:=Queen.py}
UPPER_LIMIT=${UPPER_LIMIT:=14}

if [ -$# -eq 0 ]; then
    docker run --rm=true -v $PWD:/docker \
           -e "SOURCE=$SOURCE" -e "UPPER_LIMIT=$UPPER_LIMIT" \
           -i centos:7.2.1511 /docker/scripts/run_python35.sh INIT
else
    case $1 in
        INIT)
            # https://www.softwarecollections.org/en/scls/rhscl/rh-python35/
            yum install -y centos-release-scl yum-utils
            yum-config-manager --enable rhel-server-rhscl-7-rpms
            yum install -y rh-python35
            scl enable rh-python35 "/docker/scripts/run_python35.sh RUN"
        ;;
        RUN)
            OUT=/docker/reports/${SOURCE}.log
            rm -f "${OUT}"

            echo "SOURCE=${SOURCE}" >> ${OUT}
            echo "VERSION=Python 3.5" >> ${OUT}
            echo "TIMESTAMP=$(date +%s)" >> ${OUT}

            for n in $(seq 8 ${UPPER_LIMIT}); do
                python /docker/src/${SOURCE} "${n}" | tee --append "${OUT}"
            done
        ;;
    esac
fi

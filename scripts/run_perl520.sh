#!/bin/bash
if [ -$# -eq 0 ]; then
    docker run --rm=true -v $PWD:/docker centos:7.2.1511 /docker/scripts/run_perl520.sh INIT
else
    case $1 in
        INIT)
            # https://www.softwarecollections.org/en/scls/rhscl/rh-python35/
            yum install -y centos-release-scl yum-utils
            yum-config-manager --enable rhel-server-rhscl-7-rpms
            yum install -y rh-perl520
            scl enable rh-perl520 "/docker/scripts/run_perl520.sh RUN"
        ;;
        RUN)
            OUT=/docker/reports/Queen.pl.log
            rm -f "${OUT}"
            for n in $(seq 8 14); do
                perl /docker/src/Queen.pl "${n}" | tee --append "${OUT}"
            done
        ;;
    esac
fi

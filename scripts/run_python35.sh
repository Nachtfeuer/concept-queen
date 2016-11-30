#!/bin/bash
if [ -$# -eq 0 ]; then
    docker run --rm=true -v $PWD:/docker centos:7.2.1511 /docker/scripts/run_python35.sh INIT
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
            rm -f /docker/reports/Queen.py.log
            for n in $(seq 8 14); do
                python /docker/src/Queen.py "${n}" | tee >> /docker/reports/Queen.py.log
            done
        ;;
    esac
fi

#!/bin/bash
if [ -$# -eq 0 ]; then
    docker run --rm=true -v $PWD:/docker centos:7.2.1511 /docker/scripts/run_php56.sh INIT
else
    case $1 in
        INIT)
            # https://www.softwarecollections.org/en/scls/rhscl/rh-php56/
            yum install -y centos-release-scl yum-utils
            yum-config-manager --enable rhel-server-rhscl-7-rpms
            yum install -y rh-php56
            scl enable rh-php56 "/docker/scripts/run_php56.sh RUN"
        ;;
        RUN)
            OUT=/docker/reports/Queen.php.log
            rm -f "${OUT}"
            for n in $(seq 8 14); do
                php /docker/src/Queen.php "${n}" | tee --append "${OUT}"
            done
        ;;
    esac
fi

#!/bin/bash
if [ -$# -eq 0 ]; then
    docker run --rm=true -v $PWD:/docker centos:7.2.1511 /docker/scripts/run_freebasic.sh INIT
else
    case $1 in
        INIT)
            yum install -y wget gcc-c++ ncurses-devel
            name=FreeBASIC-1.05.0-linux-x86_64
            echo "downloading of FreeBASIC ..."
            wget -q https://www.freebasic-portal.de/dlfiles/674/${name}.tar.gz
            tar -xvzf ${name}.tar.gz > /dev/null
            pushd ${name}
                ./install.sh -i /usr
            popd
            fbc -version
            $0 RUN
        ;;
        RUN)
            SOURCE=Queen.bas
            OUT=/docker/reports/${SOURCE}.log
            rm -f "${OUT}"

            echo "SOURCE=${SOURCE}" >> ${OUT}
            echo "VERSION=fbc-1.05.0" >> ${OUT}

            cp /docker/src/${SOURCE} .
            fbc -O 3 ${SOURCE}

            for n in $(seq 8 16); do
                ./Queen "${n}" | tee --append "${OUT}"
            done
        ;;
    esac
fi

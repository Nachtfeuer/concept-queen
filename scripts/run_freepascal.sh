#!/bin/bash
if [ -$# -eq 0 ]; then
    docker run --rm=true -v $PWD:/docker centos:7.2.1511 /docker/scripts/run_freepascal.sh INIT
else
    case $1 in
        INIT)
            yum install -y wget gcc-c++ ncurses-devel
            name=fpc-3.0.0.x86_64-linux
            echo "downloading of freepascal ..."
            wget -q ftp://freepascal.stack.nl/pub/fpc/dist/3.0.0/x86_64-linux/${name}.tar
            tar -xf ${name}.tar > /dev/null
            pushd ${name}
                echo -ne "\n"|./install.sh
            popd
            fbc -version
            $0 RUN
        ;;
        RUN)
            SOURCE=Queen.pas
            OUT=/docker/reports/${SOURCE}.log
            rm -f "${OUT}"

            echo "SOURCE=${SOURCE}" >> ${OUT}
            echo "VERSION=fpc-3.0.0" >> ${OUT}
            echo "TIMESTAMP=$(date +%s)" >> ${OUT}

            cp /docker/src/${SOURCE} .
            fpc -O 3 ${SOURCE}

            for n in $(seq 8 15); do
                ./Queen "${n}" | tee --append "${OUT}"
            done
        ;;
        BASH)
            docker run --rm=true -v $PWD:/docker -it centos:7.2.1511 bash
        ;;
    esac
fi

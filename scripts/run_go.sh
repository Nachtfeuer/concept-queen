#!/bin/bash
if [ -$# -eq 0 ]; then
    docker run --rm=true -v $PWD:/docker centos:7.2.1511 /docker/scripts/run_go.sh INIT
else
    case $1 in
        INIT)
            yum install -y wget
            name=FreeBASIC-1.05.0-linux-x86_64
            echo "downloading of Go..."
            name=go1.7.4.linux-amd64
            wget -q https://storage.googleapis.com/golang/${name}.tar.gz
            tar -C /usr/local -xvzf ${name}.tar.gz > /dev/null
            export PATH=$PATH:/usr/local/go/bin
            go version
            $0 RUN
            ;;
        RUN)
            SOURCE=Queen.go
            OUT=/docker/reports/${SOURCE}.log
            rm -f "${OUT}"

            echo "SOURCE=${SOURCE}" >> ${OUT}
            echo "VERSION=Go 1.7.4" >> ${OUT}

            cp /docker/src/${SOURCE} .
            go build ${SOURCE}

            for n in $(seq 8 16); do
                ./Queen "${n}" | tee --append "${OUT}"
            done
            ;;
        BASH)
            docker run --rm=true -v $PWD:/docker -it centos:7.2.1511 bash
            ;;
    esac
fi

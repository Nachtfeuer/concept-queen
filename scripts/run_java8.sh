#!/bin/bash
if [ -$# -eq 0 ]; then
    docker run --rm=true -v $PWD:/docker centos:7.2.1511 /docker/scripts/run_java8.sh INIT
else
    case $1 in
        INIT)
            yum install -y java-1.8.0-openjdk-devel
            java -version
            $0 RUN
        ;;
        RUN)
            OUT=/docker/reports/Queen.java.log
            rm -f "${OUT}"

            cp /docker/src/Queen.java .
            javac Queen.java

            for n in $(seq 8 15); do
            java Queen "${n}" | tee --append "${OUT}"
            done
        ;;
    esac
fi

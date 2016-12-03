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
            SOURCE=Queen.java
            OUT=/docker/reports/${SOURCE}.log
            rm -f "${OUT}"

            echo "SOURCE=${SOURCE}" >> ${OUT}
            echo "VERSION=Java 1.8.0" >> ${OUT}

            cp /docker/src/${SOURCE} .
            javac ${SOURCE}

            for n in $(seq 8 15); do
            java Queen "${n}" | tee --append "${OUT}"
            done
        ;;
    esac
fi

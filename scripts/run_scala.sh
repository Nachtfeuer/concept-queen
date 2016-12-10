#!/bin/bash
if [ -$# -eq 0 ]; then
    docker run --rm=true -v $PWD:/docker centos:7.2.1511 /docker/scripts/run_scala.sh INIT
else
    case $1 in
        INIT)
            yum install -y wget java-1.8.0-openjdk-devel
            name=scala-2.12.0
            echo "downloading of Scala ..."
            wget -q http://downloads.lightbend.com/scala/2.12.0/${name}.tgz
            tar -xvzf ${name}.tgz > /dev/null
            export SCALA_HOME=$PWD/${name}
            export PATH=$PATH:${SCALA_HOME}/bin
            java -version
            scala -version
            $0 RUN
        ;;
        RUN)
            SOURCE=Queen.scala
            OUT=/docker/reports/${SOURCE}.log
            rm -f "${OUT}"

            echo "SOURCE=${SOURCE}" >> ${OUT}
            echo "VERSION=Scala 2.12.0" >> ${OUT}
            echo "TIMESTAMP=$(date +%s)" >> ${OUT}

            cp /docker/src/${SOURCE} .
            scalac -opt:_ ${SOURCE}

            for n in $(seq 8 15); do
                scala Queen "${n}" | tee --append "${OUT}"
            done
        ;;
    esac
fi

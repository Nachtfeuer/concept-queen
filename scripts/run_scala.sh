#!/bin/bash
if [ -$# -eq 0 ]; then
    docker run --rm=true -v $PWD:/docker centos:7.2.1511 /docker/scripts/run_scala.sh INIT
else
    case $1 in
        INIT)
            yum install -y wget java-1.8.0-openjdk-devel
            name=scala-2.12.0
            wget http://downloads.lightbend.com/scala/2.12.0/${name}.tgz
            tar -xvzf ${name}.tgz
            export SCALA_HOME=$PWD/${name}
            export PATH=$PATH:${SCALA_HOME}/bin
            java -version
            scala -version
            $0 RUN
        ;;
        RUN)
            OUT=/docker/reports/Queen.scala.log
            rm -f "${OUT}"

            cp /docker/src/Queen.scala .
            scalac -opt:_ Queen.scala

            for n in $(seq 8 13); do
                scala Queen "${n}" | tee --append "${OUT}"
            done
        ;;
    esac
fi

#!/bin/bash
if [ -$# -eq 0 ]; then
    docker run --rm=true -v $PWD:/docker centos:7.2.1511 /docker/scripts/run_kotlin.sh INIT
else
    case $1 in
        INIT)
            yum install -y wget unzip java-1.8.0-openjdk-devel
            echo "downloading of Kotlin"
            wget -q https://github.com/JetBrains/kotlin/releases/download/v1.0.5-2/kotlin-compiler-1.0.5-2.zip
            unzip kotlin-compiler-1.0.5-2.zip
            export PATH=$PATH:$PWD/kotlinc/bin
            java -version
            kotlin -version
            $0 RUN
        ;;
        RUN)
            SOURCE=Queen.kt
            OUT=/docker/reports/${SOURCE}.log
            rm -f "${OUT}"

            echo "SOURCE=${SOURCE}" >> ${OUT}
            echo "VERSION=Kotlin 1.0.5-2" >> ${OUT}
            echo "TIMESTAMP=$(date +%s)" >> ${OUT}

            cp /docker/src/${SOURCE} .
            kotlinc ${SOURCE} -include-runtime -d Queen.jar

            for n in $(seq 8 15); do
                java -jar Queen.jar "${n}" | tee --append "${OUT}"
            done
        ;;
    esac
fi

#!/bin/bash
if [ -$# -eq 0 ]; then
    docker run --rm=true -v $PWD:/docker centos:7.2.1511 /docker/scripts/run_groovy.sh INIT
else
    case $1 in
       INIT)
            yum install -y wget unzip java-1.8.0-openjdk-devel
            echo "downloading of Groovy ..."
            wget -q https://dl.bintray.com/groovy/maven/apache-groovy-binary-2.4.7.zip
            unzip apache-groovy-binary-2.4.7.zip > /dev/null
            export JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk
            export GROOVY_HOME=/groovy-2.4.7
            export PATH=$PATH:${GROOVY_HOME}/bin
            java -version
            groovyc -version
            $0 RUN
        ;;
        RUN)
            SOURCE=Queen.groovy
            OUT=/docker/reports/${SOURCE}.log
            rm -f "${OUT}"

            echo "SOURCE=${SOURCE}" >> ${OUT}
            echo "VERSION=Groovy 2.4.7" >> ${OUT}
            echo "TIMESTAMP=$(date +%s)" >> ${OUT}

            cp /docker/src/${SOURCE} .
            groovyc ${SOURCE}

            for n in $(seq 8 14); do
                java -cp .:${GROOVY_HOME}/embeddable/groovy-all-2.4.7.jar Queen "${n}" | tee --append "${OUT}"
            done
            ;;
        BASH)
            docker run --rm=true -v $PWD:/docker -it centos:7.2.1511 bash
            ;;
    esac
fi

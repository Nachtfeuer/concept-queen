#!/bin/bash
if [ -$# -eq 0 ]; then
    docker run --rm=true -v $PWD:/docker debian:latest /docker/scripts/run_dart.sh INIT
else
    case $1 in
        INIT)
            # Enable HTTPS for apt.
            apt-get update > /dev/null
            apt-get install -y curl apt-transport-https
            # Get the Google Linux package signing key.
            sh -c 'curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -'
            # Set up the location of the stable repository.
            sh -c 'curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list'
            apt-get update > /dev/null
            apt-get install -y dart
            /docker/scripts/run_dart.sh RUN
            ;;
        RUN)
            SOURCE=Queen.dart
            OUT=/docker/reports/${SOURCE}.log
            rm -f "${OUT}"

            echo "SOURCE=${SOURCE}" >> ${OUT}
            echo "VERSION=Dart 1.21.0" >> ${OUT}
            echo "TIMESTAMP=$(date +%s)" >> ${OUT}

            for n in $(seq 8 16); do
                dart /docker/src/${SOURCE} "${n}" | tee --append "${OUT}"
            done
            ;;
        BASH)
            docker run --rm=true -v $PWD:/docker -it debian:latest bash
            ;;
    esac
fi

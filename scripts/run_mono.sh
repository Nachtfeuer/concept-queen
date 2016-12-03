#!/bin/bash
if [ -$# -eq 0 ]; then
    docker run --rm=true -v $PWD:/docker centos:7.2.1511 /docker/scripts/run_mono.sh INIT
else
    case $1 in
        INIT)
            yum install -y yum-utils
            rpm --import "http://keyserver.ubuntu.com/pks/lookup?op=get&search=0x3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF"
            yum-config-manager --add-repo http://download.mono-project.com/repo/centos/
            yum install -y mono
            mcs --version
            $0 RUN
        ;;
        RUN)
            SOURCE=Queen.cs
            OUT=/docker/reports/${SOURCE}.log
            rm -f "${OUT}"

            echo "SOURCE=${SOURCE}" >> ${OUT}
            echo "VERSION=Mono 4.6" >> ${OUT}

            cp /docker/src/${SOURCE} .
            mcs -optimize ${SOURCE}

            for n in $(seq 8 15); do
                mono ./Queen.exe "${n}" | tee --append "${OUT}"
            done
        ;;
    esac
fi

#!/bin/bash
if [ -$# -eq 0 ]; then
    docker run --rm=true -v $PWD:/docker centos:7.2.1511 /docker/scripts/run_nodejs6.sh INIT
else
    case $1 in
        INIT)
            yum install -y epel-release
            yum install -y nodejs
            echo "nodejs version $(node -v)"
            $0 RUN
        ;;
        RUN)
            OUT=/docker/reports/Queen_node.js.log
            rm -f "${OUT}"
            for n in $(seq 8 15); do
                node /docker/src/Queen_node.js "${n}" | tee --append "${OUT}"
            done
        ;;
    esac
fi

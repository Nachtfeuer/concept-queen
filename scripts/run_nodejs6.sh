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
            SOURCE=Queen_node.js
            OUT=/docker/reports/${SOURCE}.log
            rm -f "${OUT}"

            echo "SOURCE=${SOURCE}" >> ${OUT}
            echo "VERSION=Node.js 6.9.x" >> ${OUT}
            echo "TIMESTAMP=$(date +%s)" >> ${OUT}

            # please read here: http://prestonparry.com/articles/IncreaseNodeJSMemorySize/
            for n in $(seq 8 15); do
                node --max_old_space_size=4096 /docker/src/${SOURCE} "${n}" | tee --append "${OUT}"
            done
        ;;
    esac
fi

#!/bin/bash
if [ -$# -eq 0 ]; then
    docker run --rm=true -v $PWD:/docker centos:7.2.1511 /docker/scripts/run_lua.sh INIT
else
    case $1 in
        INIT)
            yum install -y lua
            lua -v
            $0 RUN
        ;;
        RUN)
            SOURCE=Queen.lua
            OUT=/docker/reports/${SOURCE}.log
            rm -f "${OUT}"

            echo "SOURCE=${SOURCE}" >> ${OUT}
            echo "VERSION=Lua 5.1.x" >> ${OUT}
            echo "TIMESTAMP=$(date +%s)" >> ${OUT}

            for n in $(seq 8 14); do
                lua /docker/src/${SOURCE} "${n}" | tee --append "${OUT}"
            done
        ;;
    esac
fi

#!/bin/bash
if [ -$# -eq 0 ]; then
    docker run --rm=true -v $PWD:/docker centos:7.2.1511 /docker/scripts/run_luajit.sh INIT
else
    case $1 in
        INIT)
            yum install -y wget gcc-c++ make
            wget -q http://luajit.org/download/LuaJIT-2.0.4.tar.gz -O lua.tar.gz
            tar -xvzf lua.tar.gz
            luasrc=$(find -type d -name "Lua*")
            pushd $luasrc
            make > /dev/null
            make install
            popd
            $0 RUN
        ;;
        RUN)
            SOURCE=Queen.lua
            OUT=/docker/reports/${SOURCE//lua/luajit}.log
            rm -f "${OUT}"

            echo "SOURCE=${SOURCE}" >> ${OUT}
            echo "VERSION=Luajit 2.0.4" >> ${OUT}
            echo "TIMESTAMP=$(date +%s)" >> ${OUT}

            for n in $(seq 8 15); do
                luajit /docker/src/${SOURCE} "${n}" | tee --append "${OUT}"
            done
        ;;
    esac
fi

#!/bin/bash
SOURCE=${SOURCE:=Queen.rs}
UPPER_LIMIT=${UPPER_LIMIT:=16}

if [ -$# -eq 0 ]; then
    docker run --rm=true -v $PWD:/docker \
           -e "SOURCE=$SOURCE" -e "UPPER_LIMIT=$UPPER_LIMIT" \
           -i centos:7.2.1511 /docker/scripts/run_rust.sh INIT
else
    case $1 in
        INIT)
            yum install -y wget
            echo "downloading of Rust..."
            name=rust-1.34.0-x86_64-unknown-linux-gnu
            wget -q --no-check-certificate https://static.rust-lang.org/dist/${name}.tar.gz
            tar -xvzf ${name}.tar.gz > /dev/null
            ${name}/install.sh
            cargo --version
            rustc --version
            $0 RUN
            ;;
        RUN)
            OUT=/docker/reports/${SOURCE}.log
            rm -f "${OUT}"

            echo "SOURCE=${SOURCE}" >> ${OUT}
            echo "VERSION=Rust 1.34.0" >> ${OUT}
            echo "TIMESTAMP=$(date +%s)" >> ${OUT}

            cp /docker/src/${SOURCE} .
            cargo build --release --bin queen

            for n in $(seq 8 ${UPPER_LIMIT}); do
                ./queen "${n}" | tee --append "${OUT}"
            done
            ;;
        BASH)
            docker run --rm=true -v $PWD:/docker -it centos:7.2.1511 bash
            ;;
    esac
fi

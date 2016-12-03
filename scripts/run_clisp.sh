#!/bin/bash
if [ -$# -eq 0 ]; then
    docker run --rm=true -v $PWD:/docker centos:7.2.1511 /docker/scripts/run_clisp.sh INIT
else
    case $1 in
        INIT)
            yum install -y wget bzip2
            name=fpc-3.0.0.x86_64-linux
            echo "downloading of clisp (Steel Bank) ..."
            name=sbcl-1.3.12-x86-64-linux-binary
            wget -q http://prdownloads.sourceforge.net/sbcl/${name}.tar.bz2
            tar -xjf ${name}.tar.bz2 > /dev/null
            pushd ${name//-binary/}
                ./install.sh
            popd
            sbcl -version
            $0 RUN
        ;;
        RUN)
            OUT=/docker/reports/Queen.lisp.log
            rm -f "${OUT}"


            for n in $(seq 8 14); do
                sbcl --script /docker/src/Queen.lisp "${n}" | tee --append "${OUT}"
            done
        ;;
        BASH)
            docker run --rm=true -v $PWD:/docker -it centos:7.2.1511 bash
        ;;
    esac
fi

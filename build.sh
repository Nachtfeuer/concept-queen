#!/bin/bash
BUILD=/tmp/concept-queen.build
case $1 in
    Queen.d|Queen_parallel.d)
         rm -rf "${BUILD}"                                     > /dev/null
         mkdir -p "${BUILD}"                                   > /dev/null
         cp src/$1 ${BUILD}                                    > /dev/null
         pushd ${BUILD}                                        > /dev/null
         dmd -O -of=Queen -release -inline -boundscheck=off $1 > /dev/null
         popd                                                  > /dev/null
         echo ${BUILD}/Queen
         ;;
esac

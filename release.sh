#!/bin/bash
VERSION=$(expr "$(cat version.def)" + 1)
echo $VERSION >version.def

TARGETS=("mb03" "mb03-80" "zxuno" "zxuno-80" "zxuno-zxscreen" "esxdos-ay")
rm -rf release
mkdir release

prepare() {
    target=$1
    mkdir release/moonr
    make clean
    make $target

    cp MOONR.BAS release/moonr
    cp moon.bin release/moonr/
    cp -r data/ release/moonr/data
    (cd release && zip -r $target.zip moonr && rm -rf moonr)
}

for t in ${TARGETS[*]}
do
    echo "Building $t"
    prepare $t
done

#!/bin/bash
rm -rf mod
mkdir -p mod
cp -a `find . -name *.ko` mod

function mcount() {
	pcc=$2
	cc=$2
	for dep in `cat $1.ko | strings | grep depends= | cut -d = -f 2 | tr , ' '`; do
		nn=`mcount $dep $((pcc+1))`
		if [ $nn -gt $cc ]; then
			cc=$nn
		fi
	done
	echo $cc
}

cd mod
for n in *.ko; do
	nc=$(mcount `basename $n .ko` 1)
	mkdir -p $nc
	ln $n $nc/$n
done
rm -f *.ko
for n in */*.ko; do gzip -9 $n; done

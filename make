#!/bin/sh
for file in ./txt/*.txt; do
	rm "${file%.txt}.bin"
	touch "${file%.txt}.bin"
	perl ../abcde/abcde.pl -cm abcde::Atlas "${file%.txt}.bin" $file
done
bass	asm/main.asm

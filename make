#!/bin/sh
wla-z80 -v -s -o main.o asm/main.asm > log &&
echo \[objects]\ > linkfile &&
echo main.o >> linkfile &&
wlalink -D -A -v -S linkfile rom/hnk_br.sms &&
rm linkfile &&
rm *.o

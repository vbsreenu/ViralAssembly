#!/bin/bash

        fq1=$1
        fq2=$2
	ref=$3

	snap-aligner paired $ref $fq1 $fq2 -o snap-$$.sam

	awk -F '\t' '$1!~/^@/ && and($2,0x4) {if($1 in array) {split(array[$1],entry1,"\t"); split($0,entry2,"\t"); print "@"entry1[1]"\n"entry1[10]"\n+\n"entry1[11] > 1; print "@"entry2[1]"\n"entry2[10]"\n+\n"entry2[11] > 2;  delete array[$1];} else array[$1]=$0;};END{for(var in array){split(array[i],unpaired,"\t"); print "@"unpaired[1]"\n"unpaired[10]"\n+\n"unpaired[11] > 3;}}' snap-$$.sam

	rm snap-$$.sam 3

	mv 1 hostFiltered-1.fq
	mv 2 hostFiltered-2.fq

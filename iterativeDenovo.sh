#!/bin/bash

# Script for runnong Spades and IDBA_UD iteratively with different k-mers and random subsampled reads.
#
# Usage: iterativeDeNovo.sh (enrichedForDenovo-1.fa and enrichedForDenovo-2.fa should be in the same directory)

# Developed by Sreenu Vattipally
# 13/Nov/2015

# Seed random generator
RANDOM=$$$(date +%s)
contigLenSp=0;
contigLenIDBA=0;

	for (( i=1; i<=25; i++ ))
	do
        	numReads=("30000" "35000" "45000" "47500" "43000" "37500" "50000")
        	kmerSet=("43,53,91,121" "47,61,73,119" "57,69,75,125" "63,71,89,115" "57,79,97,127")
        	randomReads=${numReads[$RANDOM % ${#numReads[@]} ]}
        	randomKmers=${kmerSet[$RANDOM % ${#kmerSet[@]} ]}


        	getRandomPE enrichedForDenovo-1.fq enrichedForDenovo-2.fq $randomReads

        	spades.py -k $randomKmers --careful -1  subset-1.fq -2  subset-2.fq -o spades_out-$i --phred-offset 33  > spades-$$.log 2>&1 
        	len=$(head -1 spades_out-$i/contigs.fasta |cut -d_ -f4)


        	if [ $len -gt $contigLenSp ]; then
                	contigLenSp=$len;
                	rm -f *maxLenContigs.fasta
                	cp spades_out-$i/contigs.fasta $i-$len-maxLenContigs.fasta
        	fi

		awk 'NR%4==1{a=substr($0,2);}NR%4==2{print ">"NR"-"a"\n"$0}' subset-1.fq subset-2.fq > reads.fa
		idba_ud mink=21 maxk=121 step=5 -r reads.fa -o idba_out-$i

		len=$(head -1 idba_out-$i/contig.fa |cut -d\_ -f3 |awk '{print $1}');
        	if [ $len -gt $contigLenIDBA ]; then
                	contigLenIDBA=$len;
                	rm -f *maxLenContigs-IDBA.fasta
                	cp idba_out-$i/contig.fa $i-$len-maxLenContigs-IDBA.fasta
        	fi
	done
	rm -rf spades-$$.log subset-1.fq subset-2.fq spades_out-* idba_out-* reads.fa

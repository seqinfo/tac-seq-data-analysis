#!/bin/bash

# read arguments
input=$1  # prep.sh output
umi=$2  # UMI threshold

# write column headers to stdout
echo -e "sample\tlocus\tread_count\tmolecule_count"

# count by sample and locus
for fasta in $input/*/merged/*.merged.fasta
do
	sample=$(basename $(dirname $(dirname $fasta)))
	locus=$(basename $fasta .merged.fasta)
	
	# count reads and molecules
	counts=$(grep '^>' $fasta | cut -d '-' -f 2)
	read_count=0
	molecule_count=0
	for count in $counts
	do
		read_count=$(($read_count + $count))  # total reads
		if (($count >= $umi))
		then
			((molecule_count++))  # UMI corrected
		fi
	done
	
	# write to stdout
	echo -e "$sample\t$locus\t$read_count\t$molecule_count"
done

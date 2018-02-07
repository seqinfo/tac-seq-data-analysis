#!/bin/bash

#SBATCH --job-name=count
#SBATCH --time=00:30:00

# arguments with default values
INPUT=  # sample.sh OUTPUT
UMI=2  # UMI threshold

# create output
output=counts_UMI$UMI.tsv
echo -e 'sample\tlocus\tread_count\tmolecule_count' > $output

# count by sample and locus
for fasta in $INPUT/*/merged/*.merged.fasta
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
		if (($count >= $UMI))
		then
			((molecule_count++))  # UMI corrected
		fi
	done
	
	# write to output
	echo -e "$sample\t$locus\t$read_count\t$molecule_count" >> $output
done

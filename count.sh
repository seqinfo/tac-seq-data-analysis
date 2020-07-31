#!/bin/bash

# read arguments
INPUT="$1"  # prep.sh output
UMI="$2"  # UMI threshold

printf "sample\tlocus\tread_count\tmolecule_count\n"  # write column headers to stdout

# count by locus
for fasta in "$INPUT"/merged/*.merged.fasta; do
    sample="$(basename "$INPUT")"
    locus="$(basename "$fasta" ".merged.fasta")"

    # count reads and molecules
    counts=$(grep '^>' "$fasta" | cut -d '-' -f 2)
    read_count=0
    molecule_count=0
    for count in $counts; do
        read_count=$(($read_count + $count))  # total reads
        if (($count >= $UMI))
        then
            ((molecule_count++))  # UMI corrected
        fi
    done

    printf "$sample\t$locus\t$read_count\t$molecule_count\n"  # write to stdout
done

#!/bin/bash

#SBATCH --job-name=bcl2fastq
#SBATCH --partition=main
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=32000
#SBATCH --time=02:00:00

module load bcl2fastq2-2.20

# arguments with default values
RUNFOLDER=
OUTPUT=
MISMATCHES=0

# convert BLCs to FASTQs, merge lanes
bcl2fastq -R $RUNFOLDER -o $OUTPUT --barcode-mismatches $MISMATCHES --no-lane-splitting

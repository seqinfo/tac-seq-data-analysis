# arguments with default values
RUNFOLDER=
OUTPUT=
MISMATCHES=0

# convert BLCs to FASTQs, merge lanes
bcl2fastq -R $RUNFOLDER -o $OUTPUT --barcode-mismatches $MISMATCHES --no-lane-splitting

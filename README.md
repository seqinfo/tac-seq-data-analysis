# TAC-seq data analysis
This repository contains the sequencing data analysis software for TAC-seq.

### There are 2 options to use TAC-seq data analysis software:

### Option 1: Virtual machine
We have created TAC-seq-data-analysis virtual machine that can be executed on all common operating systems through virtualization programs such as VirtualBox, providing the user with preinstalled TAC-seq data analysis software.

1. To start using the virtual machine, you need to download and install a hypervisor, a computer software that creates and runs virtual machines. You can use [VirtualBox](https://www.virtualbox.org/wiki/Downloads).
2. Download [TAC-seq-data-analysis virtual machine](https://www.dropbox.com/s/867beq9m2q9v6eq/TAC-seq-data-analysis.ova?dl=0).
3. Open VirtualBox and go to "File -> Import Appliance -> choose TAC-seq-data-analysis.ova (leave the default options).
4. To start the virtual machine, right click on the "TAC-seq-data-analysis" -> Start.
5. Once started, on the desktop of the virtual machine, follow `protocol.txt` to run analysis.

Please note, by default the maximum space, the TAC-seq-data-analysis virtual machine can use, is limited to 10 GB. For larger sequencing data analysis than provided example files, it is recommended to use [shared folder](https://www.howtogeek.com/189974/how-to-share-your-computers-files-with-a-virtual-machine/) that allows to share your files from your host operating system with virtual machine. 

### Option 2: Standalone version

#### Requirements
* Linux-based OS (preferably [Ubuntu](https://www.ubuntu.com/desktop) 16.04). If you are running 64-bit version of Windows 10 you can use [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10). 
* [FASTX-Toolkit](https://github.com/agordon/fastx_toolkit)

#### Setup
Use the following commands to setup TAC-seq data analysis software on Ubuntu 16.04 terminal:
1. Prepare Ubuntu for software installation: `sudo apt update`
2. Install [FASTX-Toolkit](http://hannonlab.cshl.edu/fastx_toolkit/index.html): `sudo apt install fastx-toolkit`
3. Install [git](https://git-scm.com/): `sudo apt install git`
4. Download the analysis software: `git clone https://github.com/cchtEE/TAC-seq-data-analysis.git`
5. Navigate to analysis location: `cd TAC-seq-data-analysis`
6. Make `tacseq` executable: `chmod +x tacseq`

### Required input files and formats
`tacseq` options:
	* -h	help
	
`tacseq` commands:
1. `tacseq prep` options:
	* -h	help
	* -i	input
	* -t	target
	* -o	output
	* -m	mismatches
2. `tacseq count` options:
	* -h	help
	* -i	input
	* -u	UMI threshold

Execute `tacseq` with following arguments:
1. Input FASTQ files (also supports gzip compressed FASTQ files)
2. Target file
3. Output folder
4. Number of allowed mismatches per target sequence
5. UMI threshold

#### Target file format
Target file is a text file which contains a list of targets. Each line has to contain a target ID (must be alphanumeric) which is followed by the target sequence (only A, C, G and T characters are allowed). Target ID and sequence are separated by a TAB character.

Target file example:

    TARGET1 TAGGATAGGTGGATTCGGGAACTCCCCGATAGTTTTGTCACATCGACATACTAA
    TARGET2 CCAAAGCTTCAACGGACATAGTGTACATACCTACCGTGTTTCCCAGCACCTTCC
    TARGET3 CTGCTGTTGCCGCCTGGGGTTTACGCGTGTTGGAGATTGAGTAGCCTCCTCGGC

### Run example analysis
`./tacseq prep -i "example/*.fastq" -t example/targets.txt -o output/ -m 5  # prepare samples`
`./tacseq count -i output/ -u 2 > counts.tsv  # count molecules and write results to counts.tsv`

### Output
Output folder includes intermediate files and results:
* Sample folders with intermediate files
* `counts_UMI#.tsv` file with read and molecule counts per sample and locus. # symbolizes UMI threshold.

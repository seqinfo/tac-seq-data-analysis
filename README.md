# TAC-seq data analysis

This repository contains the sequencing data analysis software for TAC-seq.

## Requirements
* Linux-based OS (preferably [Ubuntu](https://www.ubuntu.com/desktop) 16.04). If you are running 64-bit version of Windows 10 you can use [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10).
* [FASTX-Toolkit](https://github.com/agordon/fastx_toolkit).
* [Git](https://git-scm.com/).
## Quick start guide
Use the following commands to setup and run sequencing data analysis software for TAC-seq on Ubuntu 16.04:
* Prepare Ubuntu for software installation: `sudo apt-get update`
* Install FASTX-Toolkit: `sudo apt-get install fastx-toolkit`
* Install git: `sudo apt-get install git`
* Download the analysis software: `git clone https://github.com/cchtEE/TAC-seq-data-analysis.git`
* Navigate to analysis location: `cd TAC-seq-data-analysis`
* Run analysis: `./run.sh`

## Target file format
Target file is a text file which contains a list of targets. Each line has to contain a target ID (must be alphanumeric) which is followed by the target sequence (only A, C, G and T characters). Target ID and sequence are separated by a TAB character.

Target file example:

    TARGET1 GATCT
    TARGET2 ATCGT
    TARGET3 GTGAT
    

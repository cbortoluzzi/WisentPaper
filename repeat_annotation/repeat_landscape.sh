#!/bin/bash


# Author : cbortoluzzi@ethz.ch


#SBATCH -n 8
#SBATCH --time=3:00:00
#SBATCH --mem-per-cpu=4000
#SBATCH --job-name=RepeatMasker
#SBATCH --output=output_%J
#SBATCH --error=error_%J


export PATH=/cluster/work/pausch/cbortoluzzi/softwares/RepeatMasker/util:$PATH

aln=$1
lib=$2

name=$(basename $aln | sed 's/.fasta.align//g' | sed 's/.fa.align//g')

mkdir -p repeat_annotation

# Calculate Kimura divergence corrected for GC content
calcDivergenceFromAlign.pl -s repeat_annotation/$name.divsum -a repeat_annotation/$name.new.align $aln

# Create a repeat landscape graph using the divergence summary data generated with the calcDivergenceFromAlign.pl script; 2564834688 is the genome size of the B. bonasus
createRepeatLandscape.pl -div repeat_annotation/$name.divsum -g 2564834688 > repeat_annotation/$name.html


#!/bin/bash


# Author : cbortoluzzi@ethz.ch


#SBATCH -n 8
#SBATCH --time=4:00:00
#SBATCH --mem-per-cpu=4000
#SBATCH --job-name=PCA
#SBATCH --output=output_%J
#SBATCH --error=error_%J

if [ $# -ne 1 ]
then
    	echo -e "\nusage: `basename $0` <VCF>\n"
        echo -e "DESCRIPTION: This script generates an aligned and sorted BAM file for each set of paired reads. This script also runs QualiMap on the final BAM file to evalute its quality\n\n"

        echo -e "INPUT:           <VCF>        A VCF input file (all chromosomes)\n\n"

        echo -e "OUTPUT:          <A VCF file without the water buffalo sample>        "
        echo -e "                 <a PCA output file with eigenval and eigenvec>   \n\n"

        echo -e "REQUIRES:       Requires VCFTools (v0.1.16) and Plink (v1.90b6.18) available from PATH\n\n"

        exit
fi



# Load modules
module load plink
module load vcftools

vcf=$1

# Generate a principal componenet analysis in PLINK
# We need to add --double-id because PLINK has some difficulties in parsing samples ID that contain '_'
# We also need to add --allow-extra-chr to allow all the chromosomes to be included in the PCA analysis (PLINK is set to work on human data)
mkdir -p pca
vcftools --gzvcf $vcf --remove-indv Water_buffalo --recode --recode-INFO-all --stdout | bgzip -c > $name.noWaterBuffalo.vcf.gz
plink --vcf $name.noWaterBuffalo.vcf.gz --pca --double-id --chr-set 29 --allow-extra-chr --threads 10 --indep-pairwise 50 10 0.2 --maf 0.05 --geno 0 --out pca/PCA.noWaterBuffalo
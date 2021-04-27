#!/bin/bash
#
#SBATCH --time=4-0  # days-hours
#SBATCH --job-name=bcffix  # Job name
#SBATCH --array=1-24 # all chroms plus x and y
#SBATCH --nodes=1
#SBATCH --ntasks=24 # Number of cores
#SBATCH --mem=50000 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --partition=production # Partition to submit to
#SBATCH --output=stdout/counts-ArrayJob_%A_%a.out # File to which STDOUT will be written
#SBATCH --error=stderr/counts-ArrayJob_%A_%a.err # File to which STDERR will be written
#SBATCH --mail-type=END # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=kgmitchell@ucdavis.edu # Email to which notifications will be sent


# Fixes the labels for some of them and then subsets in next script


start=`date +%s`

hostname

module load bcftools

sample=`sed "${SLURM_ARRAY_TASK_ID}q;d" chrom.txt`

outpath='00-Fixed'
[[ -d ${outpath} ]] || mkdir ${outpath}

file_source_path='vcf-chr'
infile="${file_source_path}/chr${sample}.vqsr.vcf.gz"
outfile="00-Fixed/chr${sample}.fixnames.vqsr.vcf.gz"


call="bcftools reheader -s file_anthony_ready.txt ${infile} > ${outfile}"

eval $call

end=`date +%s`

runtime=$((end-start))

echo $runtime



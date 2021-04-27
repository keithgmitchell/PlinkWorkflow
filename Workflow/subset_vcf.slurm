#!/bin/bash
#
#SBATCH --time=4-0  # days-hours
#SBATCH --job-name=bcfsubset  # Job name
#SBATCH --array=1-24 # all chroms plus x and y
#SBATCH --nodes=1
#SBATCH --ntasks=24 # Number of cores
#SBATCH --mem=50000 # Memory pool for all cores (see also --mem-per-cpu)
#SBATCH --partition=production # Partition to submit to
#SBATCH --output=stdout/counts-subset_%A_%a.out # File to which STDOUT will be written
#SBATCH --error=stderr/counts-subset_%A_%a.err # File to which STDERR will be written
#SBATCH --mail-type=END # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mail-user=kgmitchell@ucdavis.edu # Email to which notifications will be sent


# This will iterate through the chromosomes and will generate some fixed files that subset and get rid of 0689 as well as fix th e labels for some


start=`date +%s`

hostname

module load bcftools

sample=`sed "${SLURM_ARRAY_TASK_ID}q;d" chrom.txt`

outpath='00-Fixed'
[[ -d ${outpath} ]] || mkdir ${outpath}

file_source_path='vcf-chr'
infile="00-Fixed/chr${sample}.fixnames.vqsr.vcf.gz"
outfile="00-Fixed/chr${sample}.subset.vqsr.vcf"


call="bcftools view -S samples.txt ${infile} --force-samples > ${outfile}"

eval $call

end=`date +%s`

runtime=$((end-start))

echo $runtime



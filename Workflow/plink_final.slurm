#!/bin/bash
#
#SBATCH --time=4-0  # days-hours
#SBATCH --job-name=plinkrun  # Job name
#SBATCH --array=1-2 # all chroms plus x and y
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

module load plink/1.90p

sample=`sed "${SLURM_ARRAY_TASK_ID}q;d" testing_samples.txt`

outpath='01-Plink'
[[ -d ${outpath} ]] || mkdir ${outpath}

file_source_path='00-Fixed'
infile="${file_source_path}/chr${sample}.subset.vqsr.vcf"
#outfile="00-Fixed/chr${sample}.subset.vqsr.vcf.gz"

#Generate the b file
call0="plink --vcf ${infile} --make-bed --out ${outpath}/all_${sample}"
echo $call0
eval $call0

#Update the fam file
call0="plink --bfile ${outpath}/all_${sample} --make-bed --fam fourth_fam.txt --out ${outpath}/all_${sample}_fam"
echo $call0
eval $call0

#Remove all variants not genotyped to 95%
call1="plink --bfile ${outpath}/all_${sample}_fam --geno 0.05 --make-bed --out ${outpath}/clean-missing_${sample}"
echo $call1
eval $call1

#Remove monomorphic SNPs
call2="plink --bfile ${outpath}/clean-missing_${sample} --maf 0.000000001 --make-bed --out ${outpath}/clean-missing-monos_${sample}"
echo $call2
eval $call2



#Remove all SNPs with "*" as an alt allele (hemizygous snps)
grep "*" ${outpath}/clean-missing-monos.bim_${sample} > ${outpath}/allHemizgyous_${sample}.txt
call3="plink --bfile ${outpath}/clean-missing-monos_${sample} --exclude ${outpath}/allHemizgyous_${sample}.txt --make-bed --out ${outpath}/clean-basic-QC_${sample}"
echo $call3
eval $call3



#Get Mendelian Errors
call4="plink --bfile ${outpath}/clean-basic-QC_${sample} --mendel --out ${outpath}/Mendelian_${sample}"
echo $call4
eval $call4



#Remove Mendelian Errors
#call5="plink --bfile ${outpath}/clean-basic-QC_${sample} --exclude ${outpath}/Mendelian_${sample}.mendel --make-bed --out ${outpath}/cleanedME_${sample}"
#echo $call5
#eval $call5


#Filter on common variants for IBD
#call6="plink --bfile ${outpath}/cleanedME_${sample} --maf 0.4 --make-bed --out ${outpath}/common_${sample}"
call6="plink --bfile ${outpath}/clean-basic-QC_${sample} --maf 0.4 --make-bed --out ${outpath}/common_${sample}"

echo $call6
eval $call6


#Remove variants in LD
call7="plink --bfile ${outpath}/common_${sample} --indep 50 5 2 --out ${outpath}/common_${sample}"
echo $call7
eval $call7

#Calculate IBD
call8="plink --bfile ${outpath}/common_${sample} --extract ${outpath}/common_${sample}.prune.in --make-bed --out ${outpath}/idb_${sample}"
echo $call8
eval $call8


#Calculate IBD within families
call9="plink --bfile ${outpath}/idb_${sample} --genome --rel-check --out ${outpath}/ibd-within_${sample}"
echo $call9
eval $call9


#Calculate IBD across families
call10="plink --bfile ${outpath}/idb_${sample} --genome --rel-check --out ${outpath}/ibd-across_${sample}"
echo $call10
eval $call10


#Calculate TDT across families
call11="plink --bfile ${outpath}/common_${sample} --tdt --out ${outpath}/tdt_${sample}"
echo $call11
eval $call11



end=`date +%s`

runtime=$((end-start))

echo $runtime



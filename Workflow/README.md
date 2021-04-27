# Main PlinkWorkflow
- `sbatch fixnames_vcf.slurm`
- `sbatch subset_vcf.slurm`
- `sbatch plink_final.slurm`

For these three commands you can change the `sed` command link and the array count to do a subset (using testing_samples.txt and array of 2). Otherwise to run all chromosomes use the chrom.txt file with an array of 4.

PlinkWorkflow


# General Notes
- https://www.biostars.org/p/114352/#114373
- Lipton and timberlake: https://pubmed.ncbi.nlm.nih.gov/27606499/
    - also see the files that are in the github
- small vcf for all 11004 family with osteo


# Talk to Anthony About
- --exclude not returning anythin
- need to create an option in the scripts to use indel files
- need to generalize workflow to work with Anthony's data
- make a github to collaborate on? How to handle slightly different slurm commands at the top like email (mostly just email)
- need to fix the sex for some of the multi vcf

## Want to filter for exome:
- https://www.biostars.org/p/281334/#281374




# Notes from anthony
We may slightly have to change our workflow to suit our data set, but in general the plink workflow will look like this:

1. Remove any SNP with less than 95% sequencing rate
	- Use command --geno 0.05
2. Remove any monomorphic SNPs with command --maf
3. Get mendelian errors with command --mendel
4. Calculate IBD on all trios to make sure relationships are correct
	- Use command --genome
	- I usually use a max-maf filter of 0.4.  For WGS, we may also have to do some pruning
5. Run TDT with plink command --tdt

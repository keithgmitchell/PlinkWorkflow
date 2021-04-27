
# General Notes
- https://www.biostars.org/p/114352/#114373
- plink --vcf myvcf.vcf --maf 0.05 --recode --out myplink=
- Lipton and timberlake: https://pubmed.ncbi.nlm.nih.gov/27606499/
    - also see the files that are in the github

- small vcf for all 11004 family with osteo
- discuss inclusion of 45 samples into master vcf file (m.vcf)
- plink scripts?
- remove osteo from the metopic samples...
- agree on one master file


# Talk to Anthony About
- --exclude not returning anythin
- need to create an option in the scripts to use indel files 
- need to generalize workflow to work with Anthony's data
- make a github to collaborate on? How to handle slightly different slurm commands at the top like email (mostly just email)
- need to add the TDT analysisk





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

If youd like, I can give you a script that will run through all these commands.  Let me know if you have any other questions.

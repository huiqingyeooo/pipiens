#!/bin/bash
####### Reserve computing resources #############
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=48
#SBATCH --time=72:00:00
#SBATCH --mem=500G
#SBATCH --partition=cpu2023

####### Set environment variables ###############
#module load perl/5.38.2

angsdOutput=/work/soghigian_lab/huiqing.yeo/pipiens/3_angsd/b3_nominmaf_minInd104
NGSLD=/work/soghigian_lab/apps/ngsLD

batchName=b3
#SCRATCH=/scratch/$SLURM_JOBID
SCRATCH=/scratch/33644184

echo "starting run at: `date`"

####### Script ##################################
# https://github.com/nt246/lcwgs-guide-tutorial/blob/main/tutorial3_ld_popstructure/markdowns/ld.md#ld-pruning
# Use beagle file from angsd generated with -doGlf 2
#cd ${angsdOutput}

## Prepare geno file
# first three columns (i.e. positions, major allele, minor allele)
#zcat ${batchName}.beagle.gz | cut -f 4- | gzip  > ${batchName}.format0.beagle.gz

# Remove header row
#zcat ${batchName}.format0.beagle.gz | sed '1d' | gzip > temp.txt.gz
#mv temp.txt.gz ${batchName}.format.beagle.gz
#rm ${batchName}.format0.beagle.gz

## Prepare pos file
# input file with site coordinates (one per line)
# 1st column stands for the chromosome/contig, 2nd for the position (bp)
#zcat ${batchName}.mafs.gz | cut -f 1,2 | sed 's/:/_/g'| gzip > ${batchName}.format0.pos.gz

# Remove header row
#zcat ${batchName}.format0.pos.gz | sed '1d' > temp2.txt.gz
#mv temp2.txt.gz ${batchName}.format.pos.gz
#rm ${batchName}.format0.pos.gz

#echo "file formatting done"

#cd ${SCRATCH}
#cp ${angsdOutput}/${batchName}.format.beagle.gz .
#cp ${angsdOutput}/${batchName}.format.pos.gz .

#echo "copying file to scratch folder done"

# ngsLD
# NOTE: filtered sites due to low maf are automatically skipped
# https://github.com/fgvieira/ngsLD
##### refer to angsd .arg file to fill in n_sites
##### using min_maf 0.05 as a way to reduce number of sites and file sizes

echo "starting ngsLD to generate ld file"

$NGSLD/ngsLD \
--geno ${SCRATCH}/${batchName}.format.beagle.gz \
--pos ${SCRATCH}/${batchName}.format.pos.gz \
--probs \
--n_ind 129 \
--n_sites 26002480 \
--max_kb_dist 50 \
--min_maf 0.05 \
--n_threads 24 \
--out ${SCRATCH}/${batchName}.minmaf005.ld

#echo "starting prune_graph.pl"
# prune ld file to get a list of unlinked sites
#PATH=/work/soghigian_lab/apps/ngsLD/prune_graph/src:$PATH
#PATH=/work/soghigian_lab/apps/ngsLD:$PATH

#perl $NGSLD/scripts/prune_graph.pl \
#--in_file ${SCRATCH}/${batchName}.minmaf005.ld \
#--max_kb_dist 2000 \
#--min_weight 0.5 \
#--out ${SCRATCH}/${batchName}.minmaf005_ngsLDpruned.id

#got an error message using prune_graph.pl:
#Can't locate Graph/Easy.pm in @INC (you may need to install the Graph::Easy module) (@INC contains: 
#/usr/local/lib64/perl5 /usr/local/share/perl5 /usr/lib64/perl5/vendor_perl 
#/usr/share/perl5/vendor_perl /usr/lib64/perl5 /usr/share/perl5) at 
#/work/soghigian_lab/apps/ngsLD/scripts/prune_graph.pl line 60.
#BEGIN failed--compilation aborted at /work/soghigian_lab/apps/ngsLD/scripts/prune_graph.pl line 60.

#cd /scratch/32972484
#$NGSLD/prune_graph/target/release/prune_graph --header --in b3.ld --weight-field "r2" 
#--weight-filter "dist <= 50000 && r2 >= 0.5" --out b3_ngsLDpruned.pos -n 8

#$NGSLD/prune_graph/target/release/prune_graph --help

echo "Job finised with exit code $? at: `date`"


#!/bin/bash
####### Reserve computing resources #############
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --time=24:00:00
#SBATCH --mem=500G
#SBATCH --partition=bigmem

####### Set environment variables ###############
export PATH=/work/soghigian_lab/apps/iqtree-latest/bin:$PATH
module load perl/5.32.0
source ~/software/init-conda

directory=/work/soghigian_lab/huiqing.yeo/pipiens/8_iqtree
inputFasta=/work/soghigian_lab/huiqing.yeo/pipiens/3_angsd/b3_nominmaf_minInd104/plink/b3_plinkPruned_geno10.snps.tab.fasta

#constraintTree=S2017.S2023.genbank.monophyly.treefile
#paritionFile=partitions.txt

prefixName=b3_plinkPruned_geno10

#pers=0.2
#nstop=500

echo "starting run at: `date`"

####### Script ##################################

cd ${directory}

# Running iqtree
iqtree2 -s ${inputFasta} -st DNA -m GTR -T 12 --prefix ${prefixName} -B 1000 --redo-tree

#-safe -pers ${pers} -nstop ${nstop} -bnni --alrt 1000 -p ${paritionFile} -g ${constraintTree} -keep_empty_seq -bb 1000 

echo "Job finised with exit code $? at: `date`"

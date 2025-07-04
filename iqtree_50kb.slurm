#!/bin/bash
####### Reserve computing resources #############
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=24:00:00
#SBATCH --mem=100G
#SBATCH --output=slurm--%j.out # this is helpful

####### Set environment variables ###############
export PATH=/work/soghigian_lab/apps/iqtree-latest/bin:$PATH
module load perl/5.32.0
source ~/software/init-conda

directory=/work/soghigian_lab/huiqing.yeo/pipiens/8_iqtree
inputFasta=/work/soghigian_lab/huiqing.yeo/pipiens/8_iqtree/b2_50kb/fasta

prefixName=b2_plinkPruned_50kb

#env PERL5LIB= PERL_LOCAL_LIB_ROOT= parallel sbatch iqtree_50kb.slurm ::: $(seq 45); sleep 1

echo "starting run at: `date`"

####### Script ##################################

cd ${directory}

# Running iqtree
iqtree2 -s ${inputFasta}/fasta_output_${1}.fasta -st DNA -m GTR -T 8 --prefix ${directory}/${prefixName}_${1} -B 1000 

#--redo-tree -safe -pers ${pers} -nstop ${nstop} -bnni --alrt 1000 -p ${paritionFile} -g ${constraintTree} -keep_empty_seq -bb 1000 

echo "Job finised with exit code $? at: `date`"

#!/bin/bash
####### Reserve computing resources #############
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --time=48:00:00
#SBATCH --mem=100G

echo "starting run at: `date`"

####### Set environment variables ###############
module load mpich/3.2.1-gnu
PATH=/work/soghigian_lab/apps/PopCluster/Bin/:$PATH

# define variables
work_dir=/work/soghigian_lab/huiqing.yeo/pipiens/11_popCluster
popCluster=/work/soghigian_lab/apps/PopCluster/Bin
file=b3_plinkPruned

#env PERL5LIB= PERL_LOCAL_LIB_ROOT= parallel sbatch popCluster.slurm ::: scale1 scale2 scale3

####### Script ##################################
cd ${work_dir}

#${popCluster}/PopClusterLnx INP:${work_dir}/${file}.PcPjt

# running with parallelization
mpirun -n 5 ${popCluster}/PopClusterLnx_impi INP:${work_dir}/${file}_${1}.PcPjt MPI:1

echo "Job finised with exit code $? at: `date`"


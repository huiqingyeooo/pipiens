#!/bin/bash
####### Reserve computing resources #############
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --time=24:00:00
#SBATCH --mem=100G

echo "starting run at: `date`"

####### Set environment variables ###############
SCRATCH=/scratch/$SLURM_JOBID

cd ${SCRATCH}
mkdir placeholder

echo "Job finised with exit code $? at: `date`"


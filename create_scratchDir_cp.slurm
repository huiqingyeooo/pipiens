#!/bin/bash
####### Reserve computing resources #############
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=4:00:00
#SBATCH --mem=50G

echo "starting run at: `date`"
####### Set environment variables ###############
OLD_SCRATCH=/scratch/44823692 #15 june
NEW_SCRATCH=/scratch/$SLURM_JOBID

# 15 Jul /scratch/44823692
# 20 Jul /scratch/45010328

echo $NEW_SCRATCH

cp -r ${OLD_SCRATCH}/* ${NEW_SCRATCH}

echo "Job finised with exit code $? at: `date`"
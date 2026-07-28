#!/bin/bash
####### Reserve computing resources #############
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=24:00:00
#SBATCH --mem=80G

echo "starting run at: `date`"

####### Set environment variables ###############

cp -r OLD_SCRATCH_FOLDER NEW_SCRATCH_FOLDER

echo "Job finised with exit code $? at: `date`"
#!/bin/bash
####### Reserve computing resources #############
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=4:00:00
#SBATCH --mem=50G

echo "starting run at: `date`"

cp -r /scratch/33430647/0_trimmedReads_AGS /scratch/33462325/
#cd /work/soghigian_lab/huiqing.yeo/pipiens/0_trimmedReads_AGS
#rm *fq.gz

echo "Job finised with exit code $? at: `date`"


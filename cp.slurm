#!/bin/bash
####### Reserve computing resources #############
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=4:00:00
#SBATCH --mem=50G

echo "starting run at: `date`"

#old_scratch=/work/soghigian_lab/data/illumina/chgi/mosquitoes/
new_scratch=/scratch/44823692

#cp -r ${old_scratch}/* ${new_scratch}

cp -r /work/soghigian_lab/data/illumina/Culex_molestus_NY  ${new_scratch}
cp -r /work/soghigian_lab/data/illumina/Culex_pip_quinq  ${new_scratch}
cp -r /work/soghigian_lab/data/illumina/restuans  ${new_scratch}

echo "Job finised with exit code $? at: `date`"
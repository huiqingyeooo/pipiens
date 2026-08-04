#!/bin/bash
####### Reserve computing resources #############
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --time=72:00:00
#SBATCH --mem=100G

echo "starting run at: `date`"
####### Set environment variables ###############
OLD_SCRATCH=45152027 #24 jul
NEW_SCRATCH=/scratch/$SLURM_JOBID

# 15 Jul /scratch/44823692
# 20 Jul /scratch/45010328
# 24 Jul /scratch/45152027
# 31 Jul /scratch/45624817

echo "New scratch directory: $NEW_SCRATCH"

# List all final end paths of subfolders without parent directories
list=`{ find /scratch/$OLD_SCRATCH -type d; echo; } | awk 'index($0,prev"/")!=1 && NR!=1 {print prev} 1 {sub(/\/$/,""); prev=$0}'`

# Create new scratch directories and copy files from old new scratch directories, keeping the same structure as the old scratch directories
for i in $list
do
echo "Old directory path: $i"
padded_counter=$(printf '%02d' $counter)
j=`sed "s/$OLD_SCRATCH/$SLURM_JOBID/g" <<< "$i"`
echo "New directory path: $j"
mkdir -p $j
sed "s#OLD_SCRATCH_FOLDER#${i}#g;s#NEW_SCRATCH_FOLDER#${j}#g" cp_TEMPLATE.slurm > cp_num$padded_counter.slurm
sbatch cp_num$padded_counter.slurm
((counter++))
sleep 1
done

echo "Job finised with exit code $? at: `date`"
#!/bin/bash
####### Reserve computing resources #############
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --time=24:00:00
#SBATCH --mem=80G

####### Set environment variables ###############
SCRATCH=/scratch/45010328
export PATH=$PATH:/work/soghigian_lab/apps/sratoolkit.3.1.1-ubuntu64/bin/

# change config path to output directory
#vdb-config -i #set manually
#vdb-config --set /repository/user/main/public/root=/home/your_username/sra_cache

#for taxa in $(cat srrlist_1.txt)
#do
#echo ${taxa}
#sed "s/TEMPLATE/${taxa}/g" sratoolkit_TEMPLATE.slurm > ${SCRATCH}/sratoolkit/sratoolkit_${taxa}.slurm
#sleep 1
#sbatch --output ${SCRATCH}/sratoolkit/slurm-%j.out ${SCRATCH}/sratoolkit/sratoolkit_${taxa}.slurm
#done

####### Script ###############
echo "starting run at: `date`"

# prefetch sra sample first, then split fastq files into two paired end reads

cd /${SCRATCH}/sratoolkit/sra

echo "Processing sample: TEMPLATE"
prefetch TEMPLATE --max-size 500000000000 -O ${SCRATCH}/sratoolkit/sra --force all
echo prefetch finished at: `date`

fasterq-dump TEMPLATE
echo fasterq-dump finished at: `date`

pigz TEMPLATE_1.fastq
echo pigz finished at: `date`

pigz TEMPLATE_2.fastq
echo pigz finished at: `date`

rm -r TEMPLATE

echo "Job finished with exit code $? at: `date`"

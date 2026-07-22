#!/bin/bash
####### Reserve computing resources #############
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --time=24:00:00
#SBATCH --mem=100G

####### Set environment variables ###############
SCRATCH=/scratch/45010328
export PATH=$PATH:/work/soghigian_lab/apps/sratoolkit.3.1.1-ubuntu64/bin/

#for taxa in $(cat srrlist.txt)
#do
#echo ${taxa}
#sed "s/TEMPLATE/${taxa}/g" sratoolkit_TEMPLATE.slurm > ${SCRATCH}/sratoolkit_${taxa}.slurm
#sleep 1
#sbatch --output ${SCRATCH}/pippop/slurm-%j.out ${SCRATCH}sratoolkit_${taxa}.slurm
#done

####### Script ###############
echo "starting run at: `date`"

# prefetch sra sample first, then split fastq files into two paired end reads
cd /work/soghigian_lab/huiqing.yeo/pipiens/sratoolkit/sra
echo TEMPLATE
prefetch TEMPLATE --max-size 500000000000

fasterq-dump TEMPLATE
gzip TEMPLATE_1.fastq
gzip TEMPLATE_2.fastq
rm TEMPLATE.sra
mv TEMPLATE*.fastq.gz ${SCRATCH}/pippop/

echo "Job finished with exit code $? at: `date`"

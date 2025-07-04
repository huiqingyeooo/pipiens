#!/bin/bash
####### Reserve computing resources #############
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=24:00:00
#SBATCH --mem=50G

echo "starting run at: `date`"

####### Set environment variables ###############
PATH=/work/soghigian_lab/apps/qualimap_v2.2.1/:$PATH

# define variables
bamFiles=/work/soghigian_lab/huiqing.yeo/pipiens/1_alignedReads/ags/bam

#Loop code 
#cd ${bamFiles}
#for sample in $(ls *_sorted.bam);
#do
#file=`echo $sample | awk -F"_" '{print $1"_"$2"_"$3}'`
#echo ${file}
#cd /work/soghigian_lab/huiqing.yeo/pipiens/1_alignedReads/ags/
#sed "s/TEMPLATE/${file}/g" qualimap_TEMPLATE.slurm > qualimap_${file}.slurm 
#sbatch qualimap_${file}.slurm
#sleep 1
#done

####### Script ##################################
echo sample_TEMPLATE

cd /work/soghigian_lab/huiqing.yeo/pipiens/1_alignedReads/ags/bam
mkdir /work/soghigian_lab/huiqing.yeo/pipiens/1_alignedReads/ags/bam/qualimap

qualimap bamqc -bam TEMPLATE_sorted.bam -nt 8 -ip \
--java-mem-size=50G -outfile TEMPLATE_sorted.pdf \
-outdir ./qualimap/TEMPLATE_sorted

echo "Job finised with exit code $? at: `date`"


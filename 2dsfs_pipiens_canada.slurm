#!/bin/bash
####### Reserve computing resources #############
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --time=18:00:00
#SBATCH --mem=200G

####### Set environment variables ###############
PATH=/home/huiqing.yeo/.cargo/bin/winsfs:$PATH
PATH=/work/soghigian_lab/apps/angsd:$PATH
angsd_program=/work/soghigian_lab/apps/angsd

folder=/work/soghigian_lab/huiqing.yeo/pipiens/6_fst/b3

echo "starting run at: `date`"

####### Script ##################################
cd ${folder}

#winsfs -v pip.can.cal.saf.idx pip.can.edm.saf.idx > pip.can.cal_pip.can.edm.sfs
#winsfs -v pip.can.cal.saf.idx pip.can.red.saf.idx > pip.can.cal_pip.can.red.sfs
#winsfs -v pip.can.edm.saf.idx pip.can.red.saf.idx > pip.can.edm_pip.can.red.sfs

# remove header from sfs file (#SHAPE=<19/11>) before using angsd
#sed '1d' pip.can.cal_pip.can.edm.sfs > pip.can.cal_pip.can.edm_format.sfs
#sed '1d' pip.can.cal_pip.can.red.sfs > pip.can.cal_pip.can.red_format.sfs
#sed '1d' pip.can.edm_pip.can.red.sfs > pip.can.edm_pip.can.red_format.sfs

#${angsd_program}/misc/realSFS fst index pip.can.cal.saf.idx pip.can.edm.saf.idx -sfs pip.can.cal_pip.can.edm_format.sfs -fstout 2dsfs.cal.edm
${angsd_program}/misc/realSFS fst index pip.can.cal.saf.idx pip.can.red.saf.idx -sfs pip.can.cal_pip.can.red_format.sfs -fstout 2dsfs.cal.red
${angsd_program}/misc/realSFS fst index pip.can.edm.saf.idx pip.can.red.saf.idx -sfs pip.can.edm_pip.can.red_format.sfs -fstout 2dsfs.edm.red

${angsd_program}/misc/realSFS fst stats  2dsfs.cal.edm.fst.idx
${angsd_program}/misc/realSFS fst stats  2dsfs.cal.red.fst.idx
${angsd_program}/misc/realSFS fst stats  2dsfs.edm.red.fst.idx

#rm pip.can.cal_pip.can.edm.sfs pip.can.cal_pip.can.red.sfs pip.can.edm_pip.can.red.sfs
#rm pip.can.cal_pip.can.edm_format.sfs pip.can.cal_pip.can.red_format.sfs pip.can.edm_pip.can.red_format.sfs
#rm 2dsfs.cal.edm.fst.idx 2dsfs.cal.red.fst.idx 2dsfs.edm.red.fst.idx
#rm 2dsfs.cal.edm.fst.gz 2dsfs.cal.red.fst.gz 2dsfs.edm.red.fst.gz

echo "Job finised with exit code $? at: `date`"

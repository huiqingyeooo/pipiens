#chmod +x qualimap.summary.code.sh
qualimapDir=/work/soghigian_lab/huiqing.yeo/pipiens/1_alignedReads/ags/qualimap

cd ${qualimapDir}
for file in $(ls -d *_sorted);
do
taxname=`echo $file | awk -F"_" '{print $1"_"$2"_"$3}'`
echo ${taxname}
cd ${file}
totalReads="$( grep "number of reads" genome_results.txt | awk '{ print $5 }' )"
mappedReads="$( grep "number of mapped reads" genome_results.txt | awk '{ print $6 $7}' )"
meanInsert="$( grep "mean insert size" genome_results.txt | awk '{ print $5}' )"
stdInsert="$( grep "std insert size" genome_results.txt | awk '{ print $5}' )"
medianInsert="$( grep "median insert size" genome_results.txt | awk '{ print $5}' )"
mapQ="$( grep "mean mapping quality" genome_results.txt | awk '{ print $5}' )"
meanCov="$( grep "mean coverageData" genome_results.txt | awk '{ print $4}' )"
stdCov="$( grep "std coverageData" genome_results.txt | awk '{ print $4}' )"
echo -e $taxname'\t'$totalReads'\t'$mappedReads'\t'$meanInsert'\t'$stdInsert'\t'$medianInsert'\t'$mapQ'\t'$meanCov'\t'$stdCov \
>> ${qualimapDir}/qualimap_results.tmp.txt 
cd ${qualimapDir}
done

echo -e "taxname\ttotalReads\tmappedReads\tmeanInsert\tstdInsert\tmedianInsert\tmapQ\tmeanCov\tstdCov" | cat - qualimap_results.tmp.txt > qualimap_results.txt

rm qualimap_results.tmp.txt


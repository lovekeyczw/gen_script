#########################################################################
# File Name: run.sh
# Description: 
# Author: libo
# mail: liaolb@ihep.ac.cn
# Created Time: Tue 01 Mar 2016 04:52:33 PM CST
#########################################################################
#!/bin/bash
path=`pwd`
mode="bhabha e2e2 e3e3 nn qq"
for fmode in $mode
do
j=1
if [[ $fmode == qq ]]; then
	Work=/cefs/data/stdhep/background/2fermions/E250.$fmode.e0.p0.whizard195
else 
	Work=/cefs/data/stdhep/background/2fermions/E250.P$fmode.e0.p0.whizard195
fi
echo $Work
cd $Work
i=`ls * | wc -l`
echo "File No. $i"
cd $path
	echo 
	echo $i
	while [ "$j" -le "$i" ]
	do
		export SimuWork=$path
		cp -rf $SimuWork/skim_stdhep_lcio.xml $SimuWork/P"$fmode"_$j.xml > /dev/null
		h=0
		k=9
		while [ "$h" -le "$k" ]
		do
			let x="$h+$j"
			prem=/cefs/higgs/cuizw/flass/zexhuu
			temp=`printf "%05d" "$x"`
			InputFile=$Work/"$fmode".e0.p0."$temp".stdhep
			if [ -f $InputFile ]
			then
				sed -i "s#"InputStdHep_$h"#"$InputFile"#g" $SimuWork/P"$fmode"_$j.xml
			else
				sed -i '/InputStdHep_'$h'/d' $SimuWork/P"$fmode"_$j.xml
			fi
			let "h+=1"
		done
		LcioFile=$prem/out/P$fmode/P"$fmode".e0.p0_"$temp".slcio
		rjLcioFile=$prem/rej/P$fmode/P"$fmode".e0.p0_"$temp".slcio
		#echo $LcioFile
		#echo $rjLcioFile
		sed -i "s#"output_1"#"$LcioFile"#g" $SimuWork/P"$fmode"_$j.xml
		sed -i "s#"reject_1"#"$rjLcioFile"#g" $SimuWork/P"$fmode"_$j.xml
	echo \
"#!/bin/bash
#PBS -N "$fmode"."$temp"
#PBS -o init.log
#PBS -q hsimq
#PBS -j oe

unset MARLIN_DLL
source /afs/ihep.ac.cn/soft/common/gcc/v01-17-05/init_ilcsoft_150612.sh
export PATH=/afs/ihep.ac.cn/soft/common/sysgroup/hep_job/bin:$PATH
export MARLIN_DLL=\$MARLIN_DLL:/cefs/higgs/cuizw/flass/lib/libFSClasser.so
cd $SimuWork/
( time Marlin P"$fmode"_$j.xml) | cat > nnh_$fmode."$temp".log
		" > $SimuWork/job_"$fmode"_"$temp".sh
		cd $SimuWork/
		chmod +x job_"$fmode"_"$temp".sh
		hep_sub -g higgs job_"$fmode"_"$temp".sh

		let "j+=10"
	done
done


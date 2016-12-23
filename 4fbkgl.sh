#########################################################################
# File Name: run.sh
# Description: 
# Author: libo
# mail: liaolb@ihep.ac.cn
# Created Time: Tue 01 Mar 2016 04:52:33 PM CST
#########################################################################
#!/bin/bash
path=`pwd`
mode="zz_l zz_sl zz_h zzorww_l zzorww_h ww_l ww_sl ww_h sw_l sw_sl sze_l sze_sl szeorsw_l sznu_l sznu_sl"
#mode="ww_h"
for decay in $mode
do
	if [ $decay == zz_l ];then
		ss="0taumu 0tautau 0mumu 04tau 04mu"
	elif [ $decay == zz_sl ];then
		ss="0nu_up 0nu_down 0tau_down 0tau_up 0mu_up 0mu_down"
	elif [ $decay == zz_h ];then
		ss="0dtdt 0utut 0uu_notd 0cc_nots"
	elif [ $decay == zzorww_l ];then
		ss="0tautau 0mumu"
	elif [ $decay == zzorww_h ];then
		ss="0cscs 0udud"
	elif [ $decay == ww_l ];then
		ss="0ll"
	elif [ $decay == ww_sl ];then
		ss="0muq 0tauq"
	elif [ $decay == ww_h ];then
		ss="0ccbs 0ccds 0uubd 0uusd 0cuxx"
	elif [ $decay == sw_l ];then
		ss="0mu 0tau"
	elif [ $decay == sw_sl ];then
		ss="0qq"
	elif [ $decay == sze_l ];then
		ss="0tau 0nunu 0mu 0e"
	elif [ $decay == sze_sl ];then
		ss="0uu 0dd"
	elif [ $decay == szeorsw_l ];then
		ss="0l"
	elif [ $decay == sznu_l ];then
		ss="0tautau 0mumu"
	else
		ss="0nu_up 0nu_down"
	fi
for fss in $ss
do
j=1
if [[ $decay == ww_sl || $decay == sw_l || $decay == sw_sl || $decay == zzorww_h ]];then
Work=/cefs/data/stdhep/background/4fermions/E250.P"$decay".e0.p0.whizard195
else
Work=/cefs/data/stdhep/background/4fermions/E250.P"$decay".whizard195/E250.P"$decay".e0.p0.whizard195
fi
echo $Work
cd $Work
i=`ls *"$fss".* | grep -c $fss`
echo "File No. $i"
cd $path
	echo $fss
	echo $i
	while [ "$j" -le "$i" ]
	do
		export SimuWork=$path
		cp -rf $SimuWork/skim_stdhep_lcio.xml $SimuWork/P"$decay""$fss"__$j.xml
		h=0
		k=9
		while [ "$h" -le "$k" ]
		do
			let x="$h+$j"
			temp=`printf "%05d" "$x"`
			prem=/cefs/higgs/cuizw/flass/zexhuu
			if [[ $decay == ww_sl || $decay == sw_l || $decay == sw_sl || $decay == zzorww_h ]];then
				InputFile=/cefs/data/stdhep/background/4fermions/E250.P"$decay".e0.p0.whizard195/"$decay""$fss".e0.p0."$temp".stdhep
			elif [[ $decay$fss == ww_h0cuxx || $decay$fss == sze_l0mu || $decay$fss == sze_l0e ]];then
				InputFile=/cefs/data/stdhep/background/4fermions/E250.P"$decay".whizard195/E250.P"$decay".e0.p0.whizard195/"$decay""$fss".e0.p0."$temp".stdhep
			else
				InputFile=/cefs/data/stdhep/background/4fermions/E250.P"$decay".whizard195/E250.P"$decay".e0.p0.whizard195/P"$decay""$fss".e0.p0."$temp".stdhep
			fi
			if [ -f $InputFile ]
			then
				sed -i "s#"InputStdHep_$h"#"$InputFile"#g" $SimuWork/P"$decay""$fss"__$j.xml
			else
				sed -i '/InputStdHep_'$h'/d' $SimuWork/P"$decay""$fss"__$j.xml
			fi
			let "h+=1"
		done
		LcioFile=$prem/out/P$decay/P"$decay""$fss".e0.p0_"$temp".slcio
		rjLcioFile=$prem/rej/P$decay/P"$decay""$fss".e0.p0_"$temp".slcio
		sed -i "s#"output_1"#"$LcioFile"#g" $SimuWork/P"$decay""$fss"__$j.xml
		sed -i "s#"reject_1"#"$rjLcioFile"#g" $SimuWork/P"$decay""$fss"__$j.xml
		echo \
"#!/bin/bash
#PBS -N P"$decay""$fss"."$temp"
#PBS -o init_"$temp".log
#PBS -e error_"$temp".log
#PBS -q hsimq
#PBS -j oe

unset MARLIN_DLL
source /afs/ihep.ac.cn/soft/common/gcc/v01-17-05/init_ilcsoft_150612.sh
export PATH=/afs/ihep.ac.cn/soft/common/sysgroup/hep_job/bin:$PATH
export MARLIN_DLL=\$MARLIN_DLL:/cefs/higgs/cuizw/flass/lib/libFSClasser.so
cd $SimuWork/
( time Marlin P"$decay""$fss"__"$j".xml) | cat > P"$decay""$fss"__"$temp".log
		" > $SimuWork/P"$decay""$fss"_"$temp".sh
		cd $SimuWork/
		chmod +x P"$decay""$fss"_"$temp".sh
		hep_sub -g higgs P"$decay""$fss"_"$temp".sh
#		qsub -q hsimq $SimuWork/P"$decay""$fss"_"$temp".sh
#		qsub -q cepcq@pbssrv02.ihep.ac.cn $SimuWork/P"$decay""$fss"_"$temp".sh
		let "j+=10"
	done
done
done


#########################################################################
# File Name: reconstruction.sh
# Description: 
# Author: libo
# mail: liaolb@ihep.ac.cn
# Created Time: Thu 18 Aug 2016 04:01:01 AM CST
#########################################################################
#!/bin/bash
mode="sw_l  sw_sl  sze_l  szeorsw_l  sze_sl  sznu_l  sznu_sl  ww_h  ww_l  ww_sl  zzorww_h  zzorww_l zz_l zz_sl zz_h"
for fmode in $mode
do
	if [ $fmode = zz_l ]
	then
		ss="0taumu 0tautau 0mumu 04tau 04mu"
	elif [ $fmode = zz_sl ]
	then
		ss="0nu_up 0nu_down 0tau_down 0tau_up 0mu_up 0mu_down"
	elif [ $fmode = zz_h ]
	then
		ss="0dtdt 0utut 0uu_notd 0cc_nots"
	elif [ $fmode = sw_l ]
	then
		ss="0mu 0tau"
	elif [ $fmode = sw_sl ]
	then
		ss="0qq"
	elif [ $fmode = sze_l ]
	then
		ss="0tau 0nunu 0mu 0e"
	elif [ $fmode = sze_sl ]
	then
		ss="0uu 0dd"
	elif [ $fmode = szeorsw_l ]
	then
		ss="0l"
	elif [ $fmode = sznu_l ]
	then
		ss="0tautau 0mumu"
	elif [ $fmode = sznu_sl ] 
	then
		ss="0nu_up 0nu_down"
	elif [ $fmode = ww_l ]
	then 
		ss="0ll"
	elif [ $fmode = ww_sl ]
	then
		ss="0muq 0tauq"
	elif [ $fmode = ww_h ]
	then
		ss="0ccbs 0ccds 0uubd 0uusd 0cuxx"
	elif [ $fmode = zzorww_l ]
	then
		ss="0tautau 0mumu"
	else
		ss="0cscs 0udud"
	fi

cd out/P$fmode
for fss in $ss
do
	lcio_merge_files P$fmode$fss.e0.p0.slcio P$fmode$fss.e0.p0_* > $fmode$fss.log
	echo "Merged P$fmode$fss.e0.p0.0*.slcio!!!"
	echo -------------------------------------------
	rm -f P$fmode$fss.e0.p0_*.slcio > /dev/null
	echo "Removed P$fmode$fss.e0.p0.0*.slcio!!!"
	echo -------------------------------------------
	EventNr=`less $fmode$fss.log | awk -F' ' '{print($2)}'`
	if [ $EventNr -eq 0 ]
	then
		rm -f P$fmode$fss.e0.p0* > /dev/null
		echo "No Event, so delete all slcios"
		echo -------------------------------------------
		continue
	else
		X1=`echo "$EventNr 500 1" | awk '{printf("%g",$1/$2+$3)}' | awk -F '.' '{printf($1)}'`
		let FN=$X1-1
		echo "Files Number = "$FN
		Size=`ls -trl P$fmode$fss.e0.p0.slcio | awk -F ' ' '{print($5)}'`
		echo $Size
		let X2=$Size/$X1/1000*1000
		echo $X2
		lcio_split_file P$fmode$fss.e0.p0.slcio P$fmode$fss.e0.p0.slcio $X2 > /dev/null
		echo "Splited P$fmode$fss.e0.p0.slcio!!!"
		echo -------------------------------------------
		rm -f P$fmode$fss.e0.p0.slcio > /dev/null
		echo "Removed P$fmode$fss.e0.p0.slcio!!!"
		echo -------------------------------------------
	fi

	No=`ls P$fmode$fss* | wc -l`
	i=0
	let j=$No
	while [ $i -lt $j ]
	do
		if [ $i -eq 0 ]
		then
			n1=`printf "%03d" "$i"`
			n2=`printf "%05d" "$j"`
			mv P$fmode$fss.e0.p0.$n1.slcio P$fmode$fss.e0.p0.$n2.slcio > /dev/null
		elif [[ $i -ge 1 && $i -lt 1000 ]]
		then
			n1=`printf "%03d" "$i"`
			n3=`printf "%05d" "$i"`
			mv P$fmode$fss.e0.p0.$n1.slcio P$fmode$fss.e0.p0.$n3.slcio > /dev/null
		elif [[ $i -ge 1000 && $i -lt 10000 ]]
		then
			n1=`printf "%04d" "$i"`
			n3=`printf "%05d" "$i"`
			mv P$fmode$fss.e0.p0.$n1.slcio P$fmode$fss.e0.p0.$n3.slcio > /dev/null
		else
			continue
		fi
		let "i+=1"
	done
	echo "$No Modified!!!"
	echo =1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=
done
cd /cefs/higgs/cuizw/flass/zexhuu
done

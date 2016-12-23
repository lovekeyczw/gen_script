#########################################################################
# File Name: reconstruction.sh
# Description: 
# Author: libo
# mail: liaolb@ihep.ac.cn
# Created Time: Thu 18 Aug 2016 04:01:01 AM CST
#########################################################################
#!/bin/bash
mode="qq  nn  e2e2  e3e3  bhabha"
for fmode in $mode
do
cd /cefs/higgs/cuizw/flass/zexhuu
cd out/P$fmode
	lcio_merge_files P$fmode.e0.p0.slcio P$fmode.e0.p0_* > $fmode.log
	echo "Merged P$fmode.e0.p0.0*.slcio!!!"
	echo -------------------------------------------
	rm -f P$fmode.e0.p0_*.slcio > /dev/null
	echo "Removed P$fmode.e0.p0.0*.slcio!!!"
	echo -------------------------------------------
	EventNr=`less $fmode.log | awk -F' ' '{print($2)}'`
	if [ $EventNr -eq 0 ]
	then
		rm -f P$fmode.e0.p0* > /dev/null
		echo "No Event, so delete all slcios"
		echo -------------------------------------------
		continue
	else
		X1=`echo "$EventNr 500 1" | awk '{printf("%g",$1/$2+$3)}' | awk -F '.' '{printf($1)}'`
		let FN=$X1-1
		echo "Files Number = "$FN
		Size=`ls -trl P$fmode.e0.p0.slcio | awk -F ' ' '{print($5)}'`
		echo $Size
		let X2=$Size/$X1/1000*1000
		echo $X2
		lcio_split_file P$fmode.e0.p0.slcio P$fmode.e0.p0.slcio $X2 > /dev/null
		echo "Splited P$fmode.e0.p0.slcio!!!"
		echo -------------------------------------------
		rm -f P$fmode.e0.p0.slcio > /dev/null
		echo "Removed P$fmode.e0.p0.slcio!!!"
		echo -------------------------------------------
	fi

	No=`ls P$fmode* | wc -l`
	i=0
	let j=$No
	while [ $i -lt $j ]
	do
		if [ $i -eq 0 ]
		then
			n1=`printf "%03d" "$i"`
			n2=`printf "%05d" "$j"`
			mv P$fmode.e0.p0.$n1.slcio P$fmode.e0.p0.$n2.slcio > /dev/null
		elif [[ $i -ge 1 && $i -lt 1000 ]]
		then
			n1=`printf "%03d" "$i"`
			n3=`printf "%05d" "$i"`
			mv P$fmode.e0.p0.$n1.slcio P$fmode.e0.p0.$n3.slcio > /dev/null
		elif [[ $i -ge 1000 && $i -lt 10000 ]]
		then
			n1=`printf "%04d" "$i"`
			n3=`printf "%05d" "$i"`
			mv P$fmode.e0.p0.$n1.slcio P$fmode.e0.p0.$n3.slcio > /dev/null
		else
			continue
		fi
		let "i+=1"
	done
	echo "$No Modified!!!"
	echo =1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=1=
done
cd /cefs/higgs/cuizw/flass/zexhuu

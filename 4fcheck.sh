#########################################################################
# File Name: run.sh
# Description: 
# Author: libo
# mail: liaolb@ihep.ac.cn
# Created Time: Mon 07 Mar 2016 09:30:06 PM CST
#########################################################################
#!/bin/bash
#mode="sw_l  sw_sl  sze_l  szeorsw_l  sze_sl  sznu_l  sznu_sl  ww_h  ww_l  ww_sl  zzorww_h  zzorww_l zz_l zz_sl zz_h"
mode="zz_sl"
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
for decaymode in $ss
do
	echo "P"$fmode"_"$decaymode
	echo ======================================================
	basement=/cefs/higgs/cuizw/flass/zexhuu
	workFile=$basement
	stdhepfile=$basement/out/P"$fmode"
	simfolder=$basement/sim/P"$fmode"
	recfolder=$basement/rec/P"$fmode"
	if [ ! -d $stdhepfile ]
	then
		continue;
	fi
	workarea=$workFile/
	cd $stdhepfile
	i=1
	j=`ls P"$fmode$decaymode"* | wc -l`
	echo "Total Number of File = $j ;"
	echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	while [ "$i" -le "$j" ]
	do
		rad=`echo $RANDOM | awk '{print($1)}'`
		n0=$i
		num=`printf "%05d" $n0`
		echo $num
		cd $stdhepfile
		gennum=`anajob P"$fmode"$decaymode.e0.p0."$num".slcio | tail -2 | head -1 | awk -F ' ' '{print($1)}'`
		cd $recfolder
		if [ -f P"$fmode"$decaymode.e0.p0."$num"_rec.slcio ]
		then
			numrec=1
			TorF=`lcio_event_counter P"$fmode"$decaymode.e0.p0."$num"_rec.slcio | tail -1 | wc -w`
			if [ "$TorF" -eq "1" ]
			then
				recnum=`lcio_event_counter P"$fmode"$decaymode.e0.p0."$num"_rec.slcio | tail -1`
			else
				recnum=-1
			fi
		else
			numrec=0
			recnum=-1
		fi
		if [ "$recnum" -ne "$gennum" ]
		then
			echo "============================================================================="
			echo "RecNr = $recnum ; GenNr = $gennum"
			cd $simfolder
			rm -f P"$fmode"$decaymode.e0.p0."$num"_sim.slcio > /dev/null && echo "$_ not Exist Or Removed"
			cd $recfolder
			rm -f P"$fmode"$decaymode.e0.p0."$num"_rec.slcio > /dev/null && echo "$_ not Exist Or Removed"
			echo "Resubmit the Simulation and Reconstructed Job"
			echo "============================================================================="
			cd $workFile
			rm -rf P"$fmode""$decaymode"_"$num"/ > /dev/null
			cp -r /cefs/higgs/cuizw/work $workarea/P"$fmode""$decaymode"_"$num"/ > /dev/null
			errorlog=error_"$decaymode"_"$num"
			file=$stdhepfile/P"$fmode"$decaymode.e0.p0."$num".slcio
			file2=/$simfolder/P"$fmode"$decaymode.e0.p0."$num"_sim.slcio
			file3=/$recfolder/P"$fmode"$decaymode.e0.p0."$num"_rec.slcio
			file4=/$workarea/P"$fmode""$decaymode"_"$num"/
			file5="$decaymode"."$num"
			MacroFile=/$workarea/P"$fmode""$decaymode"_"$num"/event.macro
			sed -i "s#"Input_stdhep"#"$file"#g" $workarea/P"$fmode""$decaymode"_"$num"/event.macro 
			sed -i "s#"NUMBER"#"5000"#g" $workarea/P"$fmode""$decaymode"_"$num"/event.macro
			sed -i "s#"Output_simfile"#"$file2"#g" $workarea/P"$fmode""$decaymode"_"$num"/simu.macro
			sed -i "s#"Input_MacroFile"#"$MacroFile"#g" $workarea/P"$fmode""$decaymode"_"$num"/simu.macro 
			sed -i "s#"S_N"#"0"#g" $workarea/P"$fmode""$decaymode"_"$num"/simu.macro  
			sed -i "s#"Input_simu"#"$file2"#g" $workarea/P"$fmode""$decaymode"_"$num"/ArborReco.xml 
			sed -i "s#"Output_rec"#"$file3"#g" $workarea/P"$fmode""$decaymode"_"$num"/ArborReco.xml 
			sed -i "s#"error"#"$errorlog"#g" $workarea/P"$fmode""$decaymode"_"$num"/pbscondor
			sed -i "s#"workfile"#"$file4"#g" $workarea/P"$fmode""$decaymode"_"$num"/pbscondor
			sed -i "s#"JobName"#""$de"_"$ch$file5""#g" $workarea/P"$fmode""$decaymode"_"$num"/pbscondor 
			sed -i "s#"5676563"#"$rad"#g" $workarea/P"$fmode""$decaymode"_"$num"/simu.macro
			cd  $workarea/P"$fmode""$decaymode"_"$num"/
			chmod +x pbscondor
			mv pbscondor P"$fmode""$decaymode"_"$num"
			#qsub -q hsimq P"$fmode""$decaymode"_"$num".sh
			hep_sub -g higgs P"$fmode""$decaymode"_"$num"
		fi
		echo ----------------------------------
		let "i++"
	done
done
cd $basement
done

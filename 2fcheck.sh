#########################################################################
# File Name: run.sh
# Description: 
# Author: libo
# mail: liaolb@ihep.ac.cn
# Created Time: Mon 07 Mar 2016 09:30:06 PM CST
#########################################################################
#!/bin/bash
mode="e2e2 e3e3 nn qq"
#mode="e2e2"
for fmode in $mode
do
	echo "P"$fmode"_"
	echo ======================================================
	basement=/cefs/higgs/cuizw/flass/zexhuu
	workFile=$basement
	stdhepfile=$basement/out/P"$fmode"
	simfolder=$basement/sim/P"$fmode"
	recfolder=$basement/rec/P"$fmode"
	if [ ! -d $stdhepfile ]
	then
		echo "No file"
		continue;
	fi
	workarea=$workFile/
	cd $stdhepfile
	i=1
	j=`ls P"$fmode"* | wc -l`
	echo "Total Number of File = $j ;"
	echo ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	while [ "$i" -le "$j" ]
	do
		rad=`echo $RANDOM | awk '{print($1)}'`
		n0=$i
		num=`printf "%05d" $n0`
		echo $num
			Nhsimq=`myhsimq`
			if [ $Nhsimq -ge 600 ]
			then
				break
			fi
		cd $stdhepfile
		gennum=`anajob P"$fmode".e0.p0."$num".slcio | tail -2 | head -1 | awk -F ' ' '{print($1)}'`
		cd $recfolder
		if [ -f P"$fmode".e0.p0."$num"_rec.slcio ]
		then
			numrec=1
			TorF=`lcio_event_counter P"$fmode".e0.p0."$num"_rec.slcio | tail -1 | wc -w`
			if [ "$TorF" -eq "1" ]
			then
				recnum=`lcio_event_counter P"$fmode".e0.p0."$num"_rec.slcio | tail -1`
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
			rm -f P"$fmode".e0.p0."$num"_sim.slcio > /dev/null && echo "$_ not Exist Or Removed"
			cd $recfolder
			rm -f P"$fmode".e0.p0."$num"_rec.slcio > /dev/null && echo "$_ not Exist Or Removed"
			echo "Resubmit the Simulation and Reconstructed Job"
			echo "============================================================================="
			cd $workFile
			rm -rf P"$fmode"_"$num"/ > /dev/null
			cp -r /cefs/higgs/cuizw/work $workarea/P"$fmode"_"$num"/ > /dev/null
			errorlog=error__"$num"
			file=$stdhepfile/P"$fmode".e0.p0."$num".slcio
			file2=/$simfolder/P"$fmode".e0.p0."$num"_sim.slcio
			file3=/$recfolder/P"$fmode".e0.p0."$num"_rec.slcio
			file4=/$workarea/P"$fmode"_"$num"/
			file5=."$num"
			MacroFile=/$workarea/P"$fmode"_"$num"/event.macro
			sed -i "s#"Input_stdhep"#"$file"#g" $workarea/P"$fmode"_"$num"/event.macro 
			sed -i "s#"NUMBER"#"5000"#g" $workarea/P"$fmode"_"$num"/event.macro
			sed -i "s#"Output_simfile"#"$file2"#g" $workarea/P"$fmode"_"$num"/simu.macro
			sed -i "s#"Input_MacroFile"#"$MacroFile"#g" $workarea/P"$fmode"_"$num"/simu.macro 
			sed -i "s#"S_N"#"0"#g" $workarea/P"$fmode"_"$num"/simu.macro  
			sed -i "s#"Input_simu"#"$file2"#g" $workarea/P"$fmode"_"$num"/ArborReco.xml 
			sed -i "s#"Output_rec"#"$file3"#g" $workarea/P"$fmode"_"$num"/ArborReco.xml 
			sed -i "s#"error"#"$errorlog"#g" $workarea/P"$fmode"_"$num"/pbscondor
			sed -i "s#"workfile"#"$file4"#g" $workarea/P"$fmode"_"$num"/pbscondor
			sed -i "s#"JobName"#$fmode.$file5#g" $workarea/P"$fmode"_"$num"/pbscondor 
			sed -i "s#"5676563"#"$rad"#g" $workarea/P"$fmode"_"$num"/simu.macro
			cd  $workarea/P"$fmode"_"$num"/
			chmod +x pbscondor
			mv pbscondor P"$fmode"_"$num".sh
			#qsub -q hsimq P"$fmode"_"$num".sh
				hep_sub -g higgs P"$fmode"_"$num".sh
			#	subhsimq P"$fmode"_"$num".sh
		fi
		echo ----------------------------------
		let "i++"
	done
cd $basement
done

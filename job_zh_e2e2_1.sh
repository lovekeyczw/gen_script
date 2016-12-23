#!/bin/bash
#PBS -N zh_e2e2.1
#PBS -o init.log
#PBS -q hsimq
#PBS -j oe

unset MARLIN_DLL
source /afs/ihep.ac.cn/soft/common/gcc/v01-17-05/init_ilcsoft_150612.sh
export PATH=/afs/ihep.ac.cn/soft/common/sysgroup/hep_job/bin:/afs/ihep.ac.cn/soft/common/sysgroup/hep_job/bin:/afs/ihep.ac.cn/soft/common/gcc/v01-17-05/geant4/9.6.p02/bin:/afs/ihep.ac.cn/soft/common/gcc/v01-17-05/CMake/2.8.5/bin:/afs/ihep.ac.cn/soft/common/gcc/v01-17-05/DD4hep/v00-06/bin:/afs/ihep.ac.cn/soft/common/gcc/v01-17-05/slic/v03-01-03/build/bin:/afs/ihep.ac.cn/soft/common/gcc/v01-17-05/heppdt/3.04.01/bin:/afs/ihep.ac.cn/soft/common/gcc/v01-17-05/Druid/2.4/bin:/afs/ihep.ac.cn/soft/common/gcc/v01-17-05/MarlinTPC/v00-16/bin:/afs/ihep.ac.cn/soft/common/gcc/v01-17-05/FastJet/2.4.2/bin:/afs/ihep.ac.cn/soft/common/gcc/v01-17-05/CEDViewer/v01-07-02/bin:/afs/ihep.ac.cn/soft/common/gcc/v01-17-05/Mokka/mokka-08-03_150612/bin:/afs/ihep.ac.cn/soft/common/gcc/v01-17-05/CED/v01-09-01/bin:/afs/ihep.ac.cn/soft/common/gcc/v01-17-05/gsl/1.14/bin:/afs/ihep.ac.cn/soft/common/gcc/v01-17-05/RAIDA/v01-06-02/bin:/afs/ihep.ac.cn/soft/common/gcc/v01-17-05/Marlin/v01-05/bin:/afs/ihep.ac.cn/soft/common/gcc/v01-17-05/gear/v01-04/tools:/afs/ihep.ac.cn/soft/common/gcc/v01-17-05/gear/v01-04/bin:/afs/ihep.ac.cn/soft/common/gcc/v01-17-05/root/5.34.07/bin:/afs/ihep.ac.cn/soft/common/gcc/v01-17-05/lcio/v02-04-03/tools:/afs/ihep.ac.cn/soft/common/gcc/v01-17-05/lcio/v02-04-03/bin:/afs/ihep.ac.cn/soft/common/gcc/v01-17-05/CLHEP/2.1.3.1/bin:/afs/ihep.ac.cn/soft/common/gcc/v01-17-05/QT/4.7.4/bin:/afs/ihep.ac.cn/soft/common/gcc/v01-17-05/xercesc/3.1.1/bin:/afs/ihep.ac.cn/soft/common/gcc/v01-17-05/cernlib/pro/bin:/afs/ihep.ac.cn/soft/common/gcc/v01-17-05/mysql/usr/bin:/afs/ihep.ac.cn/soft/common/sysgroup/hep_job/bin:/usr/lib64/qt-3.3/bin:/usr/kerberos/sbin:/usr/kerberos/bin:/bin:/usr/bin:/usr/externals/bin:/usr/sbin:/usr/local/bin:/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/java/latest/bin
export MARLIN_DLL=$MARLIN_DLL:/cefs/higgs/cuizw/flass/lib/libFSClasser.so
cd /cefs/higgs/cuizw/flass/ZHuu/
( time Marlin Pzh_e2e2_1.xml) | cat > nnh_zh_e2e2.1.log
		

#!/bin/sh
#
# used for CI services like Jenkins, Shippable, Travis-CI
#
# variables must be set by CI service
#export ANDROID_HOME=/work/adt/sdk
#export PATH=${PATH}:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

echo "Make sure you set AndroidManifest.xml android:debuggable to false!"

echo "Make sure the environment is loaded!"

#
# set current version info
#
export YAFRAVER="1"
export YAFRAREL="0"
export YAFRAPATCH=$YAFRABUILD

#
# setup general paths
#
export BASENODE=/home/shippable/workspace/src/github.com/yafraorg/yafra-tdb-c
export WORKNODE=/work/yafra-runtime
export SYSADM=/work/repos/yafra/org.yafra.sysadm
export YAFRATOOLS=$SYSADM/defaults
export YAFRABIN=$SYSADM/defaults/scripts
export YAFRADOC=$WORKNODE/doc
export YAFRAMAN=$WORKNODE/man
export YAFRAEXE=$WORKNODE/bin
    
export PATH=$PATH:$YAFRABIN:$YAFRAEXE


#
# setup system
#
export PS_TARGET=`$YAFRABIN/gettarget`
export PS_OSTYPE=`$YAFRABIN/getostype`
export PS_OS=`$YAFRABIN/getos`
export PS_OSVER=`$YAFRABIN/getosver`
export PS_COMPTYPE=$PS_OSTYPE
export PS_HW=`$YAFRABIN/gethardware`
export PS_HOSTNAME=`$YAFRABIN/getserver`
export HARDWARE=$PS_HW

#
# setup include/lib path
#
export YAFRAINC=$BASENODE/org.yafra.clibs/include
export YAFRALIBS=$BASENODE/org.yafra.clibs/libs
export YAFRALIBPATH=$WORKNODE/libs
export INCX11=`$YAFRABIN/getx11inc`
export INCMOTIF=`$YAFRABIN/getmotifinc`
export LIBX11=`$YAFRABIN/getx11lib`
export LIBMOTIF=`$YAFRABIN/getmotiflib`

#
# setup control flags
#
export OMANUAL=
export OSHARED=1
export ODEBUG=1

#
# setup foundation LIBS
#
export PSSYSLIB=$YAFRALIBS/pssys
export PSMUMELIB=$YAFRALIBS/psmume
export PSIPCLIB=$YAFRALIBS/psipc
export PSSERCOMLIB=$YAFRALIBS/pssercom
export PSGUILIB=$YAFRALIBS/psgui
export PSMATRIXLIB=$YAFRALIBS/matrix
export PSMODULLIB=$YAFRALIBS/psmodul

export YAFRALIBSO=$WORKNODE/obj/libs
export PSSYSLIBO=$YAFRALIBSO
export PSIPCLIBO=$YAFRALIBSO
export PSMUMELIBO=$YAFRALIBSO
export PSSERCOMLIBO=$YAFRALIBSO
export PSMODULLIBO=$YAFRALIBSO
export PSGUILIBO=$YAFRALIBSO
export PSMATRIXLIBO=$YAFRALIBSO

#
# section: travelDB
#
#travelDB
export TDB=$BASENODE/org.yafra.tdb.classic
export TDBCS=$TDB/csharp
export TDBS=$TDB
export TDBI=$MAPOS/include
export TDBSETUP=$BASENODE/org.yafra.tdb.setup
export TDBDB=$TDBSETUP/db
export TDBO=$WORKNODE/obj/tdb

#set which database to use
export TDBMYSQL=1
#export TDBMSSQL=1
#export TDBORACLE=1
#export TDBORACLECLASSIC=1
#export TDBODBC=1

#
# add on's
#
export YAFRAADDONS=$BASENODE
export CMDSRV=$BASENODE/org.yafra.tdb.addons.cmdsrv
export PSWHAT=$BASENODE/org.yafra.tdb.addons.pswhat
export PSEDIT=$BASENODE/org.yafra.tdb.addons.psedit
export CMDSRVO=$WORKNODE/obj/addons
export PSWHATO=$WORKNODE/obj/addons
export PSEDITO=$WORKNODE/obj/addons
export TESTSUITEO=$WORKNODE/obj/testsuite

#
# depreciated
#
export MPDBMYSQL=$TDBMYSQL


#
# make sure the generic profile is loaded and you have enough permissions!!
#
if [ ! -d $SYSADM/defaults ]
then
	echo "Environment not loaded - install first !"
	exit
fi

#
# create dirs
#
mkdir -p $WORKNODE
mkdir -p $YAFRADOC
mkdir -p $YAFRAMAN
mkdir -p $YAFRAEXE
mkdir -p $YAFRALIBPATH
mkdir -p $YAFRALIBSO
test -d $TDBO || mkdir $TDBO
test -d $CMDSRVO || mkdir $CMDSRVO
test -d $PSWHATO || mkdir $PSWHATO
test -d $PSEDITO || mkdir $PSEDITO
test -d $TESTSUITEO || mkdir $TESTSUITEO
test -d $WORKNODE/apps || mkdir $WORKNODE/apps
test -d $WORKNODE/yafra-dist || mkdir $WORKNODE/yafra-dist

#
# setup some variables
#
TIMESTAMP="$(date +%y%m%d)"
VERREL="$YAFRAVER.$YAFRAREL-$YAFRABUILD"
echo "-> settings for release $VERREL with basenode $BASENODE on $TIMESTAMP"
echo "-> build number $YAFRABUILD"
#

#MONO/.NET / TDB
cd $BASENODE/org.yafra.tdb.csharp/common
make all
cd $BASENODE/org.yafra.tdb.csharp/tdbadmin
make all

# run some tests
echo "\nRun some tests\n\n"
echo "============================================================"
echo " TEST CASE TDB 3: tdb .net/mono csharp test - reading db"
echo "============================================================"
mono $WORKNODE/apps/tdbmono/tdbtest.exe tdbadmin $DBSERVER MySQL


echo "done - save in /work"

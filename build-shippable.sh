#!/bin/sh
#
# used for CI services like Jenkins, Shippable, Travis-CI
#
# variables must be set by CI service
#export ANDROID_HOME=/work/adt/sdk
#export PATH=${PATH}:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

echo "Build mono project"

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
export BASENODE=/home/shippable/workspace/src/github.com/yafraorg/yafra-tdb-csharp
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
# setup control flags
#
export OMANUAL=
export OSHARED=1
export ODEBUG=1

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
echo "Creating directories now\n"
mkdir -p $WORKNODE
mkdir -p $YAFRADOC
mkdir -p $YAFRAMAN
mkdir -p $YAFRAEXE
test -d $TDBO || mkdir -p $TDBO
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
echo "Start build mono now\n"
cd $BASENODE/common
make all
if [ $? -eq 0 ]
then
  echo "Successfully build library"
else
 echo "Error during build of library" >&2
 exit 1
fi
cd $BASENODE/tdbadmin
make all
if [ $? -eq 0 ]
then
 echo "Successfully build GUI"
else
 echo "Error during build of GUI" >&2
 exit 1
fi
# run some tests
echo "\nRun some tests\n\n"
echo "============================================================"
echo " TEST CASE TDB 3: tdb .net/mono csharp test - reading db"
echo "============================================================"
mono $WORKNODE/apps/tdbmono/tdbtest.exe tdbadmin localhost MySQL


echo "done - save in /work"

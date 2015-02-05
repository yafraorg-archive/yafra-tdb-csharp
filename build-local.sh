#!/bin/sh
#
# used for CI services like Jenkins, Shippable, Travis-CI
#
# variables must be set by CI service
#export ANDROID_HOME=/work/adt/sdk
#export PATH=${PATH}:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

echo "JAVA / Maven build starting"

# maven build - build all and run some extras afterwards
mvn install
# yafra java core
#cd org.yafra.server.core/target
#cp *.jar $WORKNODE/apps
# yafra java J2EE wicket and cxf
#cd ../../org.yafra.server.jee/target
#cp *.war $WORKNODE/apps
#cp *.jar $WORKNODE/bin
# yafra java EJB3
#cd $BASENODE/org.yafra.server.ejb/target
#cp *client.jar $WORKNODE/apps
#cd $BASENODE/org.yafra.server.ejb-war/target
#cp *.war $WORKNODE/apps

#rcp
cd org.yafra.rcpbuild
./build-rcp.sh


echo "done - save in /work"

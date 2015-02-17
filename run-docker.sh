#!/bin/sh
#
# docker run script
#
# variables must be set by CI service
# setup local environment first https://github.com/yafraorg/yafra/wiki/Development-Environment
export WORKNODE=/work/yafra-runtime
test -d $WORKNODE/apps || mkdir -p $WORKNODE/apps

echo "download latest build and make it available as tomcat webapp"
# issues, tomcat users, ports and database type and config of cayenne
cd $WORKNODE
#curl -O -u yafrarel@yafra.org:eoCvvg9J ftp://ftp.yafra.org/yafra-java-build.tar.gz
#tar xvfz yafra-java-build.tar.gz
# copy to tomcat

echo "done - running now under tomcat"

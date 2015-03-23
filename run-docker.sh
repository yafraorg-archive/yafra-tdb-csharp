#!/bin/sh
#
# docker run script
#
# variables must be set by CI service
# setup local environment first https://github.com/yafraorg/yafra/wiki/Development-Environment
export WORKNODE=/work/yafra-runtime

echo "download latest build and make it available"
cd /
curl -O http://www.yafra.org/build/yafra-tdb-csharp-build.tar.gz
tar xvfz yafra-tdb-csharp-build.tar.gz
cd $WORKNODE

cd apps/tdbmono
mono tdbtest.exe tdbadmin $DB_PORT_3306_TCP_ADDR MySQL

echo "done - running now under tomcat"

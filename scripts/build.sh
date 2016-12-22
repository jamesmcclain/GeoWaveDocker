#!/usr/bin/env bash

echo "$(find /root/.m2 | grep jar$ | wc -l) jars found"

cd /geowave

set -x
mvn clean > /dev/null 2>&1
mvn install -T 1.618C $EXTRA_ARGS $BUILD_ARGS > /dev/null 2>&1
mvn package -T 1.618C -P accumulo-container-singlejar $EXTRA_ARGS $BUILD_ARGS > /dev/null 2>&1
mvn package -T 1.618C -P geowave-analytic-mapreduce $EXTRA_ARGS $BUILD_ARGS > /dev/null 2>&1
mvn package -T 1.618C -P geowave-tools-singlejar $EXTRA_ARGS $BUILD_ARGS > /dev/null 2>&1
mvn package -T 1.618C -P geotools-container-singlejar $EXTRA_ARGS $BUILD_ARGS > /dev/null 2>&1
set +x

chown -R $1:$2 /root/.m2
chown -R $1:$2 /geowave

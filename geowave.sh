#!/bin/sh

CLASSPATH=$GEOWAVE/tools/geowave-deploy-0.9.1-SNAPSHOT-tools.jar
CLASSPATH=$CLASSPATH:$GEOWAVE/tools/geowave-format-vector-0.9.1-SNAPSHOT-tools.jar
CLASSPATH=$CLASSPATH:$GEOWAVE/tools/geowave-format-gdelt-0.9.1-SNAPSHOT-tools.jar
CLASSPATH=$CLASSPATH:$GEOWAVE/tools/geowave-format-geolife-0.9.1-SNAPSHOT-tools.jar
CLASSPATH=$CLASSPATH:$GEOWAVE/tools/geowave-format-4676-0.9.1-SNAPSHOT-tools.jar
CLASSPATH=$CLASSPATH:$GEOWAVE/tools/geowave-format-gpx-0.9.1-SNAPSHOT-tools.jar
CLASSPATH=$CLASSPATH:$GEOWAVE/tools/geowave-format-raster-0.9.1-SNAPSHOT-tools.jar
CLASSPATH=$CLASSPATH:$GEOWAVE/tools/geowave-format-tdrive-0.9.1-SNAPSHOT-tools.jar

java -cp $CLASSPATH mil.nga.giat.geowave.core.cli.GeoWaveMain $*

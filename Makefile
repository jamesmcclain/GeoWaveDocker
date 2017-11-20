GEOWAVE_VERSION := 0.9.6-SNAPSHOT
GEOWAVE_SHA := 17ac77747ecc659ef2b204ee92899a892e70378b
SHA := $(shell echo ${GEOWAVE_SHA} | sed 's,\(.......\).*,\1,')
BUILD_ARGS := "-Daccumulo.version=1.7.2 -Daccumulo.api=1.7 -Dhadoop.version=2.7.3 -Dgeotools.version=16.0 -Dgeoserver.version=2.10.0"
EXTRA_ARGS := "-Dfindbugs.skip=true -DskipFormat=true -DskipITs=true -DskipTests=true"

GEOSERVER_VERSION := 2.10.1
GEOSERVER_DIST := archives/geoserver-${GEOSERVER_VERSION}-war.zip
GEOSERVER_WAR := geoserver/geoserver.war
GEOSERVER_JAR := geowave-${GEOWAVE_SHA}/deploy/target/geowave-deploy-${GEOWAVE_VERSION}-geoserver.jar

DIST_ARCHIVE := archives/${GEOWAVE_SHA}.zip
SCRIPT := geowave-${GEOWAVE_SHA}/deploy/packaging/rpm/centos/6/SOURCES/geowave-tools.sh
TOOLS := geowave-${GEOWAVE_SHA}/deploy/target/geowave-deploy-${GEOWAVE_VERSION}-tools.jar
PLUGINS := geowave-${GEOWAVE_SHA}/extensions/formats/geolife/target/geowave-format-geolife-${GEOWAVE_VERSION}.jar \
 geowave-${GEOWAVE_SHA}/extensions/formats/stanag4676/format/target/geowave-format-4676-${GEOWAVE_VERSION}.jar \
 geowave-${GEOWAVE_SHA}/extensions/formats/avro/target/geowave-format-avro-${GEOWAVE_VERSION}.jar \
 geowave-${GEOWAVE_SHA}/extensions/formats/geotools-raster/target/geowave-format-raster-${GEOWAVE_VERSION}.jar \
 geowave-${GEOWAVE_SHA}/extensions/formats/gpx/target/geowave-format-gpx-${GEOWAVE_VERSION}.jar \
 geowave-${GEOWAVE_SHA}/extensions/formats/tdrive/target/geowave-format-tdrive-${GEOWAVE_VERSION}.jar \
 geowave-${GEOWAVE_SHA}/extensions/formats/geotools-vector/target/geowave-format-vector-${GEOWAVE_VERSION}.jar \
 geowave-${GEOWAVE_SHA}/extensions/formats/gdelt/target/geowave-format-gdelt-${GEOWAVE_VERSION}.jar
ANALYTIC := geowave-${GEOWAVE_SHA}/analytics/mapreduce/target/munged/geowave-analytic-mapreduce-${GEOWAVE_VERSION}.jar
ITERATORS := geowave-${GEOWAVE_SHA}/deploy/target/geowave-deploy-${GEOWAVE_VERSION}-accumulo.jar


all: geoserver-image geowave-image

geowave-image: ${SCRIPT} ${TOOLS} ${PLUGINS} ${ANALYTIC} ${ITERATORS}
	mkdir -p plugins/
	cp -f ${SCRIPT} geowave-tools.sh; chmod ugo+x geowave-tools.sh
	cp -f ${TOOLS} geowave-tools.jar
	cp -f ${PLUGINS} plugins/
	cp -f ${ANALYTIC} geowave-analytic-mapreduce.jar
	cp -f ${ITERATORS} geowave-accumulo.jar
	docker build -f Dockerfile.geowave -t jamesmcclain/geowave:${SHA} .

${SCRIPT} ${TOOLS} ${PLUGINS} ${ANALYTIC} ${ITERATORS} ${GEOSERVER_JAR}:
	make world

.PHONY world: geowave-${GEOWAVE_SHA}/
	 docker run -it --rm \
	    --env BUILD_ARGS=${BUILD_ARGS} \
	    --env EXTRA_ARGS=${EXTRA_ARGS} \
	    --volume $(PWD)/geowave-${GEOWAVE_SHA}:/geowave:rw \
	    --volume $(HOME)/.m2:/root/.m2:rw \
	    --volume $(PWD)/scripts:/scripts:ro \
	    maven:3-jdk-8 /scripts/build.sh $(shell id -u) $(shell id -g)

${DIST_ARCHIVE}:
	(cd archives ; curl -L -C - -O "https://github.com/locationtech/geowave/archive/${GEOWAVE_SHA}.zip")

geowave-${GEOWAVE_SHA}/: ${DIST_ARCHIVE}
	unzip -u $<

geoserver-image: ${GEOSERVER_JAR} ${GEOSERVER_WAR}
	rm -rf webapps/
	unzip -u ${GEOSERVER_WAR} -d webapps/
	cp -f ${GEOSERVER_JAR} geowave-geoserver.jar
	docker build -f Dockerfile.geoserver -t jamesmcclain/geoserver:${SHA} .

${GEOSERVER_WAR}: ${GEOSERVER_DIST}
	unzip -u $< -d geoserver/

${GEOSERVER_DIST}:
	(cd archives ; curl -L -C - -O "http://sourceforge.net/projects/geoserver/files/GeoServer/${GEOSERVER_VERSION}/geoserver-${GEOSERVER_VERSION}-war.zip")

clean:
	rm -f *.jar geoserver.zip geowave-tools.sh
	rm -rf plugins/

cleaner: clean
	rm -rf geowave-${GEOWAVE_SHA}/
	rm -rf geoserver/

cleanest: cleaner
	rm -f ${DIST_ARCHIVE}
	rm -f ${GEOSERVER_DIST}

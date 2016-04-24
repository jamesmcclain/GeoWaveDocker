# Building The Container #

## Build GeoWave ##

Either on your host or in a sizable virtual machine, build GeoWave from source:

```bash
export BUILD_ARGS="-Daccumulo.version=1.7.1 -Daccumulo.api=1.7 -Dhadoop.version=2.7.2 -Dgeotools.version=14.2 -Dgeoserver.version=2.8.2"
git clone https://github.com/ngageoint/geowave.git
cd geowave
mvn install -Dfindbugs.skip=true -DskipFormat=true -DskipITs=true -DskipTests=true $BUILD_ARGS
mvn package -P geowave-tools-singlejar $BUILD_ARGS
mvn package -P geotools-container-singlejar $BUILD_ARGS
```

The Accumulo and Hadoop versions referenced in the `BUILD_ARGS` variable above were chosen to match those found in the `jamesmcclain/accumulo:0` docker image.

## Copy the GeoWave Jars ##

After the build is complete, either `cp` or `scp` the following files into a directory call `tools` on your host:
   * ./deploy/target/geowave-deploy-0.9.1-SNAPSHOT-tools.jar
   * ./extensions/formats/geotools-vector/target/geowave-format-vector-0.9.1-SNAPSHOT-tools.jar
   * ./extensions/formats/gdelt/target/geowave-format-gdelt-0.9.1-SNAPSHOT-tools.jar
   * ./extensions/formats/geolife/target/geowave-format-geolife-0.9.1-SNAPSHOT-tools.jar
   * ./extensions/formats/stanag4676/format/target/geowave-format-4676-0.9.1-SNAPSHOT-tools.jar
   * ./extensions/formats/gpx/target/geowave-format-gpx-0.9.1-SNAPSHOT-tools.jar
   * ./extensions/formats/geotools-raster/target/geowave-format-raster-0.9.1-SNAPSHOT-tools.jar
   * ./extensions/formats/tdrive/target/geowave-format-tdrive-0.9.1-SNAPSHOT-tools.jar

(Of course it is assumed that 0.9.1-SNAPSHOT is the GeoWave version that you built.)

## Build the Container

Type `make`.  There should now be a docker image called `geowaveclient:0`.

# Run the GeoWave Ingest Demo #

## Start The Accumulo Container ##

Start a local Accumulo cluster by typing:
```bash
docker run -it --rm -p 50095:50095 -h leader --name leader --entrypoint /scripts/leader.sh jamesmcclain/accumulo:0
```

At the command prompt wihin the container just created, add the `geowave` namespace to Accumulo by typing:
```bash
echo 'createnamespace geowave' | $ACCUMULO_HOME/bin/accumulo shell -u root -p password
```

## Start the GeoWave Container ##

We will now run the (ingest test)[https://ngageoint.github.io/geowave/documentation.html#ingest-example] found in the GeoWave documentation.
The instructions given in the documentation require a few modifications.

On the host machine, put the ingest data into a directory called `/tmp/ingest` instead of `./ingest`.

Then, start the GeoWave container by typing:
```bash
docker run -it --rm --link leader -v $/tmp/ingest geowaveclient:0
```

Once inside of the container, use the following command to perform the ingest:
```bash
/opt/geowave/bin/geowave.sh -localingest \
			    -b /tmp/ingest \
			    -gwNamespace geowave.50m_admin_0_countries \
			    -f geotools-vector \
			    -datastore accumulo \
			    -user root -password password \
			    -instance instance \
			    -zookeeper leader:2181
```

## Obtaining  ##

### Pulling ###

To pull the image from Docker Hub, type:

```bash
docker pull jamesmcclain/geowave:0
```

### Building ###

#### Build GeoWave ####

Either on your host or in a sizable virtual machine, build GeoWave from source:

```bash
export BUILD_ARGS="-Daccumulo.version=1.7.1 -Daccumulo.api=1.7 -Dhadoop.version=2.7.2 -Dgeotools.version=14.2 -Dgeoserver.version=2.8.2"
git clone https://github.com/ngageoint/geowave.git
cd geowave
git fetch origin 0.9.1:0.9.1
git checkout 0.9.1
mvn install -Dfindbugs.skip=true -DskipFormat=true -DskipITs=true -DskipTests=true $BUILD_ARGS
mvn package -P geotools-container-singlejar $BUILD_ARGS
mvn package -P accumulo-container-singlejar $BUILD_ARGS
```

The Accumulo and Hadoop versions referenced in the `BUILD_ARGS` variable above were chosen to match those found in the `jamesmcclain/geowave:0`
docker image and the `jamesmcclain/accumulo:1` and `jamesmcclain/hadoop:1` images on which it is based.

#### Copy the GeoWave Jars ####

After the build is complete, either `cp` or `scp` the following files into the root of this repository:
   * ./deploy/target/geowave-deploy-0.9.1-SNAPSHOT-accumulo-singlejar.jar
   * ./deploy/target/geowave-deploy-0.9.1-SNAPSHOT-geoserver-singlejar.jar

(It is assumed that `0.9.1-SNAPSHOT` is the GeoWave version that you built.)

#### Build the Container ####

Type `make`.  You should now have a docker image called `geowave:0`.


## Run the Raster Ingest Example ##

### Start The Accumulo Container ###

Start a local Accumulo cluster by typing:

```bash
docker run -it --rm -p 50095:50095 \
       -h leader --name leader \
       --entrypoint /scripts/leader.sh \
       jamesmcclain/geowave:0
```

### Start the Client Container ###

Build the [raster ingest code](https://github.com/jamesmcclain/GeoWaveIngest).
Start the client container by typing:

```bash
docker run -it --rm --link leader \
       -v $(JAR_LOCATION):/moo:ro \
       -v $(GEOTIFF_LOCATION):/woof:ro \
       java:openjdk-8u72-jdk
```

Perform the ingest by typing:

```bash
java -cp /moo/ingest-raster-assembly-0.jar \
     com.example.ingest.raster.RasterIngest \
     leader instance root password gwRaster /woof/TC_NG_Baghdad_IQ_Geo.tif
```

## Obtaining  ##

### Pulling ###

To pull the image from Docker Hub, type:

```bash
docker pull jamesmcclain/geowave:1
```

### Building ###

#### Build GeoWave ####

Either on your host or in a sizable virtual machine, build GeoWave from source:

Pull the GeoWave source code:
```bash
export BUILD_ARGS="-Daccumulo.version=1.7.1 -Daccumulo.api=1.7 -Dhadoop.version=2.7.2 -Dgeotools.version=14.2 -Dgeoserver.version=2.8.3"
git clone https://github.com/ngageoint/geowave.git
cd geowave
```

Then create a new branch from commit `c7429a97` or nearby and apply the following patch:
```patch
diff --git a/extensions/adapters/raster/src/main/java/mil/nga/giat/geowave/adapter/raster/adapter/merge/nodata/NoDataMergeStrategy.java b/extensions/adapters/raster/src/main/java/mil/nga/giat/geowave/adapter/raster/adapter/merge/nodata/NoDataMergeStrategy.java
index c194594..806c183 100644
--- a/extensions/adapters/raster/src/main/java/mil/nga/giat/geowave/adapter/raster/adapter/merge/nodata/NoDataMergeStrategy.java
+++ b/extensions/adapters/raster/src/main/java/mil/nga/giat/geowave/adapter/raster/adapter/merge/nodata/NoDataMergeStrategy.java
@@ -34,7 +34,7 @@ public class NoDataMergeStrategy implements
 
                // if next tile is null or if this tile does not have metadata, just
                // keep this tile as is
-               if ((nextTile != null) && (thisTile.getMetadata() != null)) {
+               if (false && (nextTile != null) && (thisTile.getMetadata() != null)) {
                        if (nextTile instanceof MergeableRasterTile) {
                                final NoDataMetadata thisTileMetadata = thisTile.getMetadata();
                                final NoDataMetadata nextTileMetadata = nextTile.getMetadata();
```

Then build GeoWave:
```
mvn install -Dfindbugs.skip=true -DskipFormat=true -DskipITs=true -DskipTests=true $BUILD_ARGS
mvn package -P geotools-container-singlejar $BUILD_ARGS
mvn package -P accumulo-container-singlejar $BUILD_ARGS
```

The Accumulo and Hadoop versions referenced in the `BUILD_ARGS` variable above were chosen to match those found in the `jamesmcclain/geowave:1`
docker image (and the `jamesmcclain/accumulo:1` and `jamesmcclain/hadoop:1` images on which it is based).

#### Copy the GeoWave Jars ####

After the build is complete, either `cp` or `scp` the following files into the root of this repository:
   * ./deploy/target/geowave-deploy-0.9.1-SNAPSHOT-accumulo-singlejar.jar
   * ./deploy/target/geowave-deploy-0.9.1-SNAPSHOT-geoserver-singlejar.jar

(It is assumed that `0.9.1-SNAPSHOT` is the GeoWave version that you built.)

#### Build the Container ####

Type `make`.  You should now have a docker image called `geowave:1`.

## Run the Raster Ingest Example ##

### Start The GeoWave Container ###

Start a local GeoWave-enabled Accumulo instance by typing:

```bash
docker network create --driver bridge geowave
docker run -it --rm -p 50095:50095 \
       --net=geowave --hostname leader --name leader \
       --entrypoint /scripts/leader.sh \
       jamesmcclain/geowave:1
```

Optional additional followers can be started by typing:

```bash
docker run -it --rm \
       --net=geowave --hostname follower1 --name follower1 \
       --entrypoint /scripts/follower.sh \
       jamesmcclain/geowave:1
```

### Start the Client Container ###

Build the [raster ingest code](https://github.com/jamesmcclain/GeoWaveIngest).
Start the client container by typing:

```bash
docker run -it --rm \
       --net=geowave
       -v $(JAR_LOCATION):/jars:ro \
       -v $(GEOTIFF_LOCATION):/rasters:ro \
       java:openjdk-8u72-jdk
```

Perform the ingest by typing the following inside the container:

```bash
java -cp /jars/ingest-raster-assembly-0.jar \
     com.example.ingest.raster.RasterIngest \
     leader instance root password gwRaster /rasters/TC_NG_Baghdad_IQ_Geo.tif
```

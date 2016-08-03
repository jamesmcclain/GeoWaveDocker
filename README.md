## Obtaining  ##

### Pulling ###

To pull the image from [DockerHub](https://hub.docker.com/r/jamesmcclain/geowave/), type:

```bash
docker pull jamesmcclain/geowave:7
```

### Building ###

#### Build GeoWave ####

Either on your host or in a sizable virtual machine, build GeoWave from source:

Pull the GeoWave source code:
```bash
export BUILD_ARGS="-Daccumulo.version=1.7.1 -Daccumulo.api=1.7 -Dhadoop.version=2.7.2 -Dgeotools.version=14.2 -Dgeoserver.version=2.8.3"
git clone https://github.com/ngageoint/geowave.git
cd geowave
mvn install -Dfindbugs.skip=true -DskipFormat=true -DskipITs=true -DskipTests=true $BUILD_ARGS
mvn package -P geotools-container-singlejar $BUILD_ARGS
mvn package -P accumulo-container-singlejar $BUILD_ARGS
```

GeoWave master commit `19a5abc` is believed to work.

The Accumulo and Hadoop versions referenced in the `BUILD_ARGS` variable above were chosen to match those found in the
`jamesmcclain/geowave:7` docker image
(and the `jamesmcclain/accumulo:7` and `jamesmcclain/hadoop:1` images on which it is based).

#### Copy the GeoWave Jars ####

After the build is complete, either `cp` or `scp` the following files into the root of this repository:
   * ./deploy/target/geowave-deploy-0.9.3-SNAPSHOT-accumulo-singlejar.jar
   * ./deploy/target/geowave-deploy-0.9.3-SNAPSHOT-geoserver-singlejar.jar

Only the first one is strictly required for this image,
but you will also need the geoserver jar if you plan to build the [jamesmcclain/geoserver](https://github.com/jamesmcclain/GeoServerDocker) image.
It is assumed that `0.9.3-SNAPSHOT` is the GeoWave version that you built.

#### Build the Container ####

Type `make`.  You should now have a docker image called `jamesmcclain/geowave:7`.

### Start The GeoWave Container ###

Start a local GeoWave-enabled Accumulo instance by typing:

```bash
docker network create --driver bridge geowave
docker run -it --rm -p 9995:50095 --net=geowave --hostname leader --name leader jamesmcclain/geowave:7
```

Optional additional followers can be started by typing:

```bash
docker run -it --rm --net=geowave --hostname follower1 --name follower1 --entrypoint /scripts/follower.sh jamesmcclain/geowave:7
```

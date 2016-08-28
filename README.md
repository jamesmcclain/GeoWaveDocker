# Build #

The images `jamesmcclain/geowave:latest` and `jamesmcclain:geoserver:latest` can be built by typing:
```bash
make
```

# Start The GeoWave Container #

Start a GeoWave-enabled Accumulo container by typing:
```bash
docker network create --driver bridge geowave
docker run -it --rm -p 9995:50095 --net=geowave --hostname leader --name leader jamesmcclain/geowave:8760ce2
```

Optional additional followers can be started by typing:
```bash
docker run -it --rm --net=geowave --entrypoint /scripts/follower.sh jamesmcclain/geowave:8760ce2
```

# Use the Command Line Tools #
The GeoWave command line tools can be accessed by starting the container
```bash
docker run -it --rm --net=geowave jamesmcclain/geowave:8760ce2 bash
```
and navigating to the `/usr/local/geowave/tools` directory.

# Start the GeoServer Container #

Start a GeoWave-enabled GeoServer container by typing:
```bash
docker run -it --rm --net=geowave -p 8080:8080 jamesmcclain/geoserver:8760ce2
```

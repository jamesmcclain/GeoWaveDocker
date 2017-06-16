This image is intended for local development.
If you are interested in using Docker to run GeoWave on EMR (for development or deployment),
please consider using [GeoDocker](https://github.com/geodocker/geodocker).

# Build #

The images `jamesmcclain/geowave:f04ca1d` and `jamesmcclain:geoserver:f04ca1d` can be built by typing:
```bash
make
```

# Start The GeoWave Container #

Start a GeoWave-enabled Accumulo container by typing:
```bash
docker network create --driver bridge geowave
docker run -it --rm -p 50095:50095 --net=geowave --hostname leader --name leader jamesmcclain/geowave:f04ca1d
```

Optional additional followers can be started by typing:
```bash
docker run -it --rm --net=geowave --entrypoint /scripts/follower.sh jamesmcclain/geowave:f04ca1d
```

# Use the Command Line Tools #
The GeoWave command line tools can be accessed by starting the container
```bash
docker run -it --rm --net=geowave jamesmcclain/geowave:f04ca1d bash
```
and navigating to the `/usr/local/geowave/tools` directory.

# Start the GeoServer Container #

Start a GeoWave-enabled GeoServer container by typing:
```bash
docker run -it --rm --net=geowave -p 8080:8080 jamesmcclain/geoserver:f04ca1d
```

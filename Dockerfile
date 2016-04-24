FROM java:openjdk-8u72-jdk
MAINTAINER James McClain <james.mcclain@gmail.com>

ADD tools /opt/geowave/tools
ADD geowave.sh /opt/geowave/bin/

ENV GEOWAVE /opt/geowave

FROM jamesmcclain/accumulo:2
MAINTAINER James McClain <james.mcclain@gmail.com>

ADD geowave-deploy-0.9.1-SNAPSHOT-accumulo-singlejar.jar /opt/accumulo-1.7.1/lib/ext/
ADD leader.sh /scripts/

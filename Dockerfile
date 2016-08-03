FROM jamesmcclain/accumulo:7
MAINTAINER James McClain <james.mcclain@gmail.com>

ADD geowave-deploy-0.9.3-SNAPSHOT-accumulo-singlejar.jar /opt/accumulo-1.7.2/lib/ext/
ADD leader.sh /scripts/
ADD VERSION.txt /

CMD ["/scripts/leader.sh"]

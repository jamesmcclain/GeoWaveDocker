FROM jamesmcclain/accumulo:3
MAINTAINER James McClain <james.mcclain@gmail.com>

ADD geowave-deploy-0.9.3-SNAPSHOT-accumulo-singlejar.jar /opt/accumulo-2.0.0-SNAPSHOT/lib/ext/
ADD leader.sh /scripts/

CMD ["/scripts/leader.sh"]

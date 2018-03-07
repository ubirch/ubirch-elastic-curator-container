FROM debian:jessie
MAINTAINER Falko Zurell <falko.zurell@ubirch.com>

# https://www.elastic.co/guide/en/elasticsearch/client/curator/current/pip.html

# Build-time metadata as defined at http://label-schema.org
  ARG BUILD_DATE
  ARG VCS_REF
  LABEL org.label-schema.build-date=$BUILD_DATE \
        org.label-schema.docker.dockerfile="/Dockerfile" \
        org.label-schema.license="MIT" \
        org.label-schema.name="ubirch ElasticSearch Curator container" \
        org.label-schema.url="https://ubirch.com" \
        org.label-schema.vcs-ref=$VCS_REF \
        org.label-schema.vcs-type="Git"

LABEL description="ubirch ElasticSearch Curator container"
RUN apt-get update && apt-get dist-upgrade -y
RUN apt-get install python-pip -y
RUN pip install elasticsearch-curator
RUN mkdir -p /opt
ADD config.yml /opt/config.yml
# ENTRYPOINT ["/usr/local/bin/curator"]
CMD /usr/local/bin/curator --dry-run --config /opt/config.yml /opt/action_file.yml

FROM jenkins/jenkins:latest
#ENV JAVA_OPTS -Djava.net.useSystemProxies=true
#ENV JAVA_OPTS -Dhudson.security.csrf.DefaultCrumbIssuer.EXCLUDE_SESSION_ID=true
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
ENV JENKINS_CONFIG /var/jenkins_home/auth.yaml
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
COPY auth.yaml /var/jenkins_home/auth.yaml

USER root
#
#RUN curl -o /tmp/filebeat-7.8.0-amd64.deb https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.8.0-amd64.deb && #\
#  dpkg -i /tmp/filebeat-7.8.0-amd64.deb &&  apt-get install
#COPY filebeat.yml /etc/filebeat/filebeat.yml
#
#COPY ["entrypoint.sh", "/"]
#
#RUN chmod +x /entrypoint.sh
#
#ENTRYPOINT ["/bin/bash","-c","./entrypoint.sh"]



ENV FILEBEAT_VERSION=7.8.0 \
    JENKINS_INSTANCE=jenkins \
    ELASTICSEARCH_HOST=localhost \
    ELASTICSEARCH_PORT=9200 \
    ELASTICSEARCH_INDEX=jenkins-filebeat-%{+yyyy.MM.dd}

RUN set -x && \
  apt-get update && \
  apt-get install -y wget && \
  wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.8.0-amd64.deb -O /opt/filebeat-7.8.0-amd64.deb && \
  cd /opt && \
  dpkg -i /opt/filebeat-7.8.0-amd64.deb &&  apt-get install

COPY ["entrypoint.sh", "/"]
RUN chmod +x /entrypoint.sh
RUN chmod go-w /etc/filebeat/filebeat.yml

ENTRYPOINT ["/bin/bash","-c","./entrypoint.sh"]
CMD [ "filebeat", "-e" ]

FROM registry.qraftec.cloud/apache-zeppelin:0.7.2

COPY dist/webapps /tmp/webapps/
COPY dist/shl/* /usr/bin/

RUN  sh /usr/bin/page-init.sh
EXPOSE 8080




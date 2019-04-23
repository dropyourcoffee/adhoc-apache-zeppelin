FROM registry.qraftec.cloud/apache-zeppelin:0.7.2

COPY dist/webapps/* /tmp/webapps/
COPY dist/shl/* /tmp/shl/

RUN sh /tmp/shl/cp-webapp.sh&

EXPOSE 8080
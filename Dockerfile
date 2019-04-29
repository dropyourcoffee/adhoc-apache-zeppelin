FROM registry.qraftec.cloud/apache-zeppelin:0.7.2

COPY dist/webapps /tmp/webapps/
COPY dist/shl/* /usr/bin/


# Add mariadb-client connector.
RUN wget https://downloads.mariadb.com/Connectors/java/connector-java-1.5.9/mariadb-java-client-1.5.9.jar -P /zeppelin/interpreter/jdbc

# Debian Package Manager Setup
RUN apt-get update
RUN apt-get -y install python3-pip python3.5-dev

RUN mkdir -p /opt/pyenvs /opt/pymodules/qrobo # && pip3 install virtualenv


# # Just for Test
# COPY dist/py /opt/pymodules/qrobo/

# Set up custom python interpreter environments

## robo-admin
### Create Directory
# RUN virtualenv /opt/pyenvs/roboadmin
# ### Install Modules
# RUN /opt/pyenvs/roboadmin/bin/pip3 install pip==9.0.3
# RUN /opt/pyenvs/roboadmin/bin/pip3 install cffi
# RUN /opt/pyenvs/roboadmin/bin/pip3 install pymysql sqlalchemy pandas pynacl # Not needed
# RUN /opt/pyenvs/roboadmin/bin/pip3 install /opt/pymodules/qrobo/

EXPOSE 8080

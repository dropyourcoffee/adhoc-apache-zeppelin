FROM registry.qraftec.cloud/apache-zeppelin:0.7.2

COPY dist/webapps /tmp/webapps/
COPY dist/shl/* /usr/bin/


# Add mariadb-client connector.
RUN wget https://downloads.mariadb.com/Connectors/java/connector-java-1.5.9/mariadb-java-client-1.5.9.jar -P /zeppelin/interpreter/jdbc

# Debian Package Manager Setup
RUN apt-get update
RUN apt-get -y install python3-pip python3.5-dev

# Python Interpreter Setup
RUN pip3 install cffi tensorflow pymysql sqlalchemy pandas pynacl

# # optional
# #RUN apt-get install -y build-essential autoconf libtool pkg-config python-opengl python-imaging python-pyrex python-pyside.qtopengl idle-python2.7 qt4-dev-tools qt4-designer libqtgui4 libqtcore4 libqt4-xml libqt4-test libqt4-script libqt4-network libqt4-dbus python-qt4 python-qt4-gl libgle3 python-dev libssl-dev
# #RUN easy_install greenlet
# #RUN easy_install gevent
# # end optional





EXPOSE 8080




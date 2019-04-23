#!bin/bash

while [ ! -f /tmp/homes.html ]; do
  sleep 1;
done

cp /tmp/webapps/webapp/app/home/homes.html /zeppelin/webapps/webapp/app/home/home.html
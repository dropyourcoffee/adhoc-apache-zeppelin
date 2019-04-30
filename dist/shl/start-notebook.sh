#!/bin/bash

JPTY_PROC="netstat -ntlp | grep \":8888\" | wc -l"
JPTY_PID=$(netstat -ntlp | grep ":8888" | awk '{print $NF}' | awk -F '/' '{print $1}')

if ! [ -d __PYENV_DIR__ ]; then
    echo "setup new virtualenv __PYENV_DIR__"
    virtualenv __PYENV_DIR__
    __PYENV_DIR__/bin/pip3 install pip==9.0.3 cffi
fi

if ! [ -d __PYMODULE_DIR__ ]; then
    echo "copy pymodule __PYMODULE_DIR__"
    mkdir -p __PYMODULE_DIR__
    cp -r /tmp/qrobo/* __PYMODULE_DIR__
fi



NO_PROC=$(eval ${JPTY_PROC})
if [ "${NO_PROC}" -gt 0 ]; then
  echo "killing existing Jupyter.. $JPTY_PID"
  kill -9 $JPTY_PID
fi

while [ true ];
do
    NO_PROC=$(eval $JPTY_PROC)
  if [ "${NO_PROC}" -le 0 ]; then
    echo "Restarting Jupyter
    /bin/su -c "jupyter notebook --config /etc/jupyter/jupyter_notebook_config.py&" __NB_USER__
  fi
  sleep 5
done

exit 1

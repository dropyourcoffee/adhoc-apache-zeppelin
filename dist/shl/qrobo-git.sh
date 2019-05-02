#!/bin/bash

GIT_URL=git@gitlab.com:qraftec/qraftec-dev3/qrobo.git
SVC_BRNCH=zeppelinq/release

source /usr/local/lib/util.sh

e_header "QROBO SYNC"

# 모듈 디렉토리가 없거나, git이 아닌 경우.
if ! [ -d __PYMODULE_DIR__/.git ]; then
  e_warning "Module does not exist."
  cd /root
  rm -rf __PYMODULE_DIR__
  CMD="git clone $GIT_URL __PYMODULE_DIR__"
  echo $CMD
  eval $CMD
  e_success "Cloned new repository"
  git fetch --all
else
  cd __PYMODULE_DIR__
  git reset --hard && git fetch --all
fi

# Branch Check-out
cd /opt/pymodules/qrobo
CMD="git checkout origin/$SVC_BRNCH"
echo $CMD
eval $CMD
if [ -f __PYENV_DIR__/bin/pip3 ]; then
  CMD="__PYENV_DIR__/bin/pip3 install -e __PYMODULE_DIR__/"
  echo $CMD
  eval $CMD
fi
e_success "Qrobo module sync has been Successful"

exit 0
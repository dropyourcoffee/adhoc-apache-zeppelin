FROM registry.qraftec.cloud/apache-zeppelin:0.7.2

ARG PYENV_DIR=/opt/pyenvs/roboadmin
ARG PYMODULE_DIR=/opt/pymodules/qrobo


COPY dist/webapps /tmp/webapps/
COPY dist/shl/* /etc/init.d/

# Add mariadb-client connector.
RUN wget https://downloads.mariadb.com/Connectors/java/connector-java-1.5.9/mariadb-java-client-1.5.9.jar -P /zeppelin/interpreter/jdbc

# Debian Package Manager Setup
RUN apt-get update
RUN apt-get -y install python3-pip python3.5-dev

RUN mkdir -p /opt/pyenvs $PYMODULE_DIR
RUN pip3 install virtualenv


##### Jupyter Environment starts

ARG NB_USER="dexter"
ARG NB_UID="1000"
ARG NB_GID="100"

# Dependency 및 Package manager 업데이트
RUN apt-get update && apt-get -yq dist-upgrade \
 && apt-get install -yq --no-install-recommends \
    wget \
    vim \
    net-tools \
    bzip2 \
    ca-certificates \
    sudo \
    locales \
    fonts-liberation \
 && rm -rf /var/lib/apt/lists/*

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

# 환경변수 (Conda, shell, user, encoding)
ENV CONDA_DIR=/opt/conda \
    SHELL=/bin/bash \
    NB_USER=$NB_USER \
    NB_UID=$NB_UID \
    NB_GID=$NB_GID \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

ENV PATH=$CONDA_DIR/bin:$PATH \
    HOME=/home/$NB_USER

# 바이너리 권한 수정
ADD dist/fix-permissions /usr/local/bin/fix-permissions

# prompt color 활성화
RUN sed -i 's/^#force_color_prompt=yes/force_color_prompt=yes/' /etc/skel/.bashrc

# 'users' 그룹에 $NB_USER 생성 (UID=1000).
# 하위 디렉토리들 `users` 그룹에 쓰기 권한 추가.
RUN echo "auth requisite pam_deny.so" >> /etc/pam.d/su && \
    sed -i.bak -e 's/^%admin/#%admin/' /etc/sudoers && \
    sed -i.bak -e 's/^%sudo/#%sudo/' /etc/sudoers && \
    useradd -m -s /bin/bash -N -u $NB_UID $NB_USER && \
    mkdir -p $CONDA_DIR && \
    chown $NB_USER:$NB_GID $CONDA_DIR && \
    chmod g+w /etc/passwd && \
    fix-permissions $HOME && \
    fix-permissions "$(dirname $CONDA_DIR)"

USER root

# 루트로 jupyter 설치
RUN pip3 install jupyter
COPY dist/jupyter_notebook_config.py /etc/jupyter/

# shell 스크립트
ARG SCRPT="start-notebook"
RUN ln -s /etc/init.d/$SCRPT.sh /usr/local/bin/$SCRPT && chmod a+x /usr/local/bin/$SCRPT
RUN sed -i -e "s#__PYENV_DIR__#$PYENV_DIR#g" /etc/init.d/$SCRPT.sh
RUN sed -i -e "s#__PYMODULE_DIR__#$PYMODULE_DIR#g" /etc/init.d/$SCRPT.sh
RUN sed -i -e "s#__NB_USER__#$NB_USER#g" /etc/init.d/$SCRPT.sh


ARG SCRPT="init-homepage"
RUN ln -s /etc/init.d/$SCRPT.sh /usr/local/bin/$SCRPT && chmod a+x /usr/local/bin/$SCRPT

RUN echo "cd /opt/pymodules/qrobo" >> $HOME/.bashrc
RUN echo "source $PYENV_DIR/bin/activate" >> $HOME/.bashrc




EXPOSE 8080
EXPOSE 8888

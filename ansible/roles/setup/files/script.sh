#!/bin/bash

USERNAME="pet-clinic"
JAVA="17"
JAVA_VERSION="jdk-17.0.12"
JAVA_TAR_NAME="jdk-17.0.12_linux-x64_bin.tar.gz"
JAVA_URL="https://download.oracle.com/java/${JAVA}/archive/${JAVA_TAR_NAME}"
JAVA_DIR="/home/${USERNAME}/java"

TOMCAT_VERSION="10.1.41"
TOMCAT_TAR_NAME="apache-tomcat-${TOMCAT_VERSION}.tar.gz"
TOMCAT_URL="https://dlcdn.apache.org/tomcat/tomcat-10/v${TOMCAT_VERSION}/bin/${TOMCAT_TAR_NAME}"
TOMCAT_DIR="/home/${USERNAME}/tomcat"

create_user() {
  if ! id "$USERNAME" &>/dev/null; then
    echo "Creating user: $USERNAME"
    useradd -m "$USERNAME"
  else
    echo "User $USERNAME already exists."
  fi
}

install_java() {
  su - "$USERNAME" -c "
    mkdir -p ${JAVA_DIR}
    cd ${JAVA_DIR}
    if [ ! -d ${JAVA_VERSION} ]; then
      if [ ! -f ${JAVA_TAR_NAME} ]; then
        echo 'Downloading Java...'
        wget ${JAVA_URL}
      fi
      echo 'Extracting Java...'
      tar -xzf ${JAVA_TAR_NAME}
    fi

    if ! grep -q JAVA_HOME ~/.bashrc; then
      echo 'Configuring JAVA_HOME...'
      echo 'export JAVA_HOME=${JAVA_DIR}/${JAVA_VERSION}' >> ~/.bashrc
      echo 'export PATH=\$JAVA_HOME/bin:\$PATH' >> ~/.bashrc
    fi
  "
}

install_tomcat() {
  su - "$USERNAME" -c "
    mkdir -p ${TOMCAT_DIR}
    cd ${TOMCAT_DIR}
    if [ ! -d apache-tomcat-${TOMCAT_VERSION} ]; then
      if [ ! -f ${TOMCAT_TAR_NAME} ]; then
        echo 'Downloading Tomcat...'
        wget ${TOMCAT_URL}
      fi
      echo 'Extracting Tomcat...'
      tar -xzf ${TOMCAT_TAR_NAME}
    fi
    chmod +x ${TOMCAT_DIR}/apache-tomcat-${TOMCAT_VERSION}/bin/*.sh
  "
}

create_user
install_java
install_tomcat

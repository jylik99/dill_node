#!/bin/bash

configure_environment() {
  echo "Setting up non-interactive mode..."
  export DEBIAN_FRONTEND=noninteractive
  export NEEDRESTART_MODE=a
  echo 'debconf debconf/frontend select Noninteractive' | sudo debconf-set-selections
}

# Removing needrestart (if not needed)
remove_needrestart() {
  if dpkg -l | grep -q needrestart; then
    echo "Removing needrestart..."
    sudo apt-get purge -y needrestart
  fi
}

# Cleaning old kernels and packages
cleanup_kernels() {
  echo "Cleaning old kernels and dependencies..."
  sudo apt-get autoremove --purge -y
}

echo "Updating system..."
sudo apt-get update -yq
sudo apt-get upgrade -yq

echo "Installing critical packages..."
sudo apt-get install -yq apt-utils dialog 2>/dev/null

remove_needrestart

# Installing necessary packages
echo "Installing necessary packages..."
PACKAGES=(
  curl
  git
  jq
  lz4
  build-essential
  unzip
  make
  gcc
  ncdu
  cmake
  clang
  pkg-config
  libssl-dev
  libzmq3-dev
  libczmq-dev
  python3-pip
  protobuf-compiler
  dos2unix
  screen
)

for PACKAGE in "${PACKAGES[@]}"; do
  echo "Installing $PACKAGE..."
  sudo apt install -y "$PACKAGE"
  if [ $? -eq 0 ]; then
    echo "$PACKAGE successfully installed."
  else
    echo "Error installing $PACKAGE. Skipping..."
  fi
done

echo "Initial server setup completed."

#! /bin/bash

# Usage: ./bootstrap.sh [host]

host="${1:-ubuntu@hostname}"
ssh-keygen -R "${host#*@}"

tar cj . | ssh -o "StrictHostKeyChecking no" "$host" '

sudo rm -rf ~/chef &&
mkdir ~/chef &&
cd ~/chef &&
tar xj &&
sudo bash install.sh
'

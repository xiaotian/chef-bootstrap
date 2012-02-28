#! /bin/bash

# Usage: ./bootstrap.sh [host]

host="${1:-ubuntu@hostname}"
ssh-keygen -R "${host#*@}"

tar cj . | ssh -o "StrictHostKeyChecking no" "$host" '
rm -rf ~/chef &&
mkdir ~/chef &&
cd ~/chef &&
tar xj
'
ssh -t -o "StrictHostKeyChecking no" "$host" '
cd ~/chef &&
sudo bash install.sh
'

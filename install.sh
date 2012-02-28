#!/bin/bash

# This runs as root on the server
ruby_version=ruby-1.9.3-p125
rvm_version=1.10.2
chef_binary=/usr/local/rvm/gems/$ruby_version/bin/chef-solo

# Are we on a vanilla system?
if ! test -f "$chef_binary"; then
    echo "Updating Ubuntu ..."
    export DEBIAN_FRONTEND=noninteractive
    # Upgrade headlessly (this is only safe-ish on vanilla systems)
    apt-get update -o Acquire::http::No-Cache=True
    apt-get -o Dpkg::Options::="--force-confnew" \
      --force-yes -fuy dist-upgrade

    echo "Installing base package dependencies..."
    # Install RVM as root (System-wide install)
    apt-get install -y curl git-core bzip2 build-essential zlib1g-dev libssl-dev libyaml-dev

    echo "Installing RVM..."
    bash -s stable < <(curl -s https://raw.github.com/wayneeseguin/rvm/master/binscripts/rvm-installer )

    # Install Ruby using RVM
    [[ -s "/etc/profile.d/rvm.sh" ]] && source "/etc/profile.d/rvm.sh"
    echo "Installing $ruby_version ..."
    rvm install $ruby_version
    rvm use $ruby_version --default

    # Install chef
    echo "Installing Chef ..."
    gem install --no-rdoc --no-ri chef
fi

# Run chef-solo on server
[[ -s "/etc/profile.d/rvm.sh" ]] && source "/etc/profile.d/rvm.sh"
"$chef_binary" -c solo.rb -j chef.json -r http://s3.amazonaws.com/chef-solo/bootstrap-latest.tar.gz


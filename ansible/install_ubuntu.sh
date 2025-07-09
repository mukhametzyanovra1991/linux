#!/bin/bash

#install pipx
sudo apt update -y
sudo apt install pipx -y
pipx ensurepath
sudo pipx ensurepath --global

#install ansible
pipx install --include-deps ansible
pipx inject --include-apps ansible argcomplete

#install kerberos ansible
sudo apt-get install krb5-user libkrb5-dev python3-dev -y
pipx inject ansible "pypsrp[kerberos]<=1.0.0"
pipx inject ansible "pywinrm[kerberos]>=0.4.0"
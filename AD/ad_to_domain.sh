#!/bin/bash

#install required packages
apt -y install realmd libnss-sss libpam-sss sssd sssd-tools adcli samba-common-bin oddjob oddjob-mkhomedir packagekit

#join to active directory domain b17.local
realm join -U $1 $2

#enable auto-create user homedir
bash -c "cat > /usr/share/pam-configs/mkhomedir" <<EOF
Name: activate mkhomedir
Default: yes
Priority: 900
Session-Type: Additional
Session:
        required                        pam_mkhomedir.so umask=0022 skel=/etc/skel
EOF

#enable mkhomedir
pam-auth-update

#restart sssd daemon
sudo systemctl restart sssd

#allow login to linux_adm AD group
realm permit -g linux_adm

#add linux_adm AD group to sudoers
bash -c "cat > /etc/sudoers.d/linux_adm" <<EOF
%linux_adm              ALL=(ALL)       ALL
%linux_adm@$2    ALL=(ALL)       ALL
EOF

#use_fully_qualified_names=False to login without domain name
sed -i.bak 's/use_fully_qualified_names = True/use_fully_qualified_names = False/g' /etc/sssd/sssd.conf

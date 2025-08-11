#!/bin/bash

#install required packages
apt-get update -y
apt-get install task-auth-ad-sssd -y

#set hostname
hostnamectl set-hostname $1.$2

#add to domain gkb5.local
system-auth write ad $2 $1 $3 $4

#roleadd 
roleadd 'adm_linux' localadmins

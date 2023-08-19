#!/usr/bin/env bash

echo Enter Root password
read $root_pswd

echo root:$root_pswd | chpasswd

echo Enter User Name to add into system
read usr_name

echo Enter a $user_name password
read password

useradd -m $usr_name
echo $usr_name:$password | chpasswd
usermod -aG wheel,power,storage $user_name

sed -i '/%wheel ALL=(ALL:ALL) ALL/s/^#//g' /etc/sudoers.d/$user_name
echo "Defaults timestamp_timeout=0" >> /etc/sudoers.d/$user_name

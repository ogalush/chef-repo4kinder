#!/bin/bash

#########################################################
##-- OSインストール後にインストールしたアプリ群
##-- Update 2013.4.16 T.OGASAWARA
#########################################################

##IPアドレス設定(192.168.0.200/24)
## crontabへ、ntpdate設定追加

#-- For vim
echo 'set number' > /root/.vimrc

#-- Update OS
### to chef apt-get install linux-headers-generic linux-image-generic
apt-get update
apt-get upgrade

#-- Development tools
### to chef apt-get install -y zsh  traceroute jfbterm automake make whois
apt-get install -y ruby1.9.3 git

#-- Install chef
/usr/bin/gem install chef

#-- get Chef template
cd /usr/local/src
/usr/bin/git clone git://github.com/opscode/chef-repo.git

#-- initialize knifa(デフォルト設定でOK)
/usr/local/bin/knife configure

#-- install KVM
#-- https://help.ubuntu.com/community/KVM/Installation
#-- http://www.kkaneko.com/rinkou/cloudcomputing/spicelibvirt.html
#-- http://docs.openstack.org/trunk/openstack-compute/install/apt/content/qemu.html

## to Chef
##apt-get -y install kvm kvm-ipxe \
##           qemu-common qemu-keymaps qemu-kvm-extras \
##           qemu-kvm qemu-system qemu-user \
##           qemu-utils qemu-launcher qemulator \
##           qemuctl qtemu qemu-kvm-spice \
##           libvirt-bin ubuntu-vm-builder bridge-utils virt-manager guestmount
## to Chefsudo adduser `id -un` libvirtd

virsh -c qemu:///system list
ls -la /var/run/libvirt/libvirt-sock
ls -l /dev/kvm
chown root:libvirtd /dev/kvm
usermod -a -G kvm libvirt-qemu
## to Chef rmmod kvm
## to Chef modprobe -a kvm
 

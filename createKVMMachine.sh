#!/bin/bash

#-- Def
ISO='/var/kvm/images/CentOS-6.4-x86_64-netinstall.iso'
HDDDIR='/var/kvm/images'
HDDDISK='/var/kvm/images/kvmmachine.img'
#-- Def(END)

#-- Setting vnc-config
#vi /root/.vnc/xstartup
#< x-window-manager &
#---
#> ##x-window-manager &
#> exec gnome-session &
#-- Setting vnc-config(END)


#-- Delete NAT interface(virbr0)
virsh net-list --all
virsh net-destroy default
virsh net-autostart default --disable
virsh net-list --all

#-- Create HDD File
mkdir -p $HDDDIR
chmod 777 $HDDDIR
##dd if=/dev/zero of=$HDDDISK bs=1M count=10240
chown libvirt-qemu:libvirtd $HDDDISK
chmod 770 $HDDDISK

# create & stop VM
virsh destroy VirtualMachine1
virsh undefine VirtualMachine1
virt-install --debug \
             --name VirtualMachine1 \
             --connect qemu:///system \
             --hvm \
             --virt-type kvm \
             --os-type linux \
             --os-variant virtio26 \
             --vcpus 1 \
             --ram 1024 \
             --graphics vnc,password=takehiko,port=5911,listen=0.0.0.0,keymap=ja \
             --noautoconsole \
             --accelerate \
             --network bridge=br0,model=virtio \
             --disk device=disk,path=$HDDDISK \
             --disk device=cdrom,path=$ISO
virsh destroy VirtualMachine1

## list
## virsh list --all 
## start
## virsh start VirtualMachine1
## stop
## virsh shutdown VirtualMachine1
## virsh destroy  VirtualMachine1
## connect
## virsh --connect qemu:///system
## console
## virsh console VirtualMachine1

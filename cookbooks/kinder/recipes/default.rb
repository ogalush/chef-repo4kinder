#
# Cookbook Name:: kinder
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


log "Start Kinder Chef"


#-- OSUser
user "ogalush" do
  home     "/home/ogalush"
  shell    "/usr/bin/zsh"
  password '$6$EPsrUxyq$tr05fH/y/9gac.kwkRiLmXMkI15W.JInt1uiinr8GeE6kMJ2iuqHBX0BF.fkHA3AE8KhSdzi9jlz36vivcsyS0'
  supports :manage_home => true
  supports :non_unique  => true
end

user "endo" do
  home     "/home/endo"
  shell    "/usr/bin/zsh"
  password '$6$01LXW4dN$TT6ukXRugRozWT5WO87kZ0nBSIHuG.QSQ52XhbK1fEMI95EI12tcvYcmOzwh84Jljwb/5cKn04nR.DXQKgXVw.'
  supports :manage_home => true
  supports :non_unique  => true
end


#-- OSGroup(初期ユーザの権限を開発ユーザ全てに付与
%w{adm cdrom sudo dip plugdev lpadmin sambashare}.each do |gname|
  group gname do 
    members ['ogalush', 'endo']
    action :create
    append true
  end
end


#-- Update OS
%w{linux-headers-generic linux-image-generic}.each do |pkg|
  package pkg do 
    action :install
  end
end


#-- Development tools
%w{zsh traceroute jfbterm automake make whois ruby1.9.3 git}.each do |pkg|
  package pkg do 
    action :install
  end
end


#-- Ruby gems
%w{chef ruby-shadow}.each do |pkg|
  gem_package pkg do 
    action :install
  end
end


#-- Install KVM
#-- https://help.ubuntu.com/community/KVM/Installation
#-- http://www.kkaneko.com/rinkou/cloudcomputing/spicelibvirt.html
#-- http://docs.openstack.org/trunk/openstack-compute/install/apt/content/qemu.html
#%w{kvm kvm-ipxe qemu-common qemu-keymaps qemu-kvm-extras qemu-kvm qemu-system 
#   qemu-user qemu-utils qemu-launcher qemulator qemuctl qtemu qemu-kvm-spice 
#   libvirt-bin ubuntu-vm-builder bridge-utils virt-manager guestmount}.each do |pkg|
%w{qemu-kvm libvirt-bin ubuntu-vm-builder bridge-utils vnc4server virt-viewer gnome xinit}.each do |pkg|
  package pkg do 
    action :install
  end
end


#-- KVMGroup(libvirtd)
group "libvirtd" do 
  gid 116
  members ['root']
  action :create
end

#-- Reload KVMModule
execute "kvmmodule" do
  command 'rmmod kvm; modprobe -a kvm; depmod -a;'
end

#-- Create Bridge Interface(br0)

log "End Kinder Chef"

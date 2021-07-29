# -*- mode: ruby -*-
# vi: set ft=ruby :
IMAGE_NAME = "centos/stream8"     # 指定镜像
IMAGE_URL = "https://mirrors.ustc.edu.cn/centos-cloud/centos/8-stream/x86_64/images/CentOS-Stream-Vagrant-8-20210210.0.x86_64.vagrant-virtualbox.box" # 镜像国内地址
IMAGE_VERSION =  "20210210.0"     # 镜像版本

Vagrant.configure("2") do |config|
  # configures the master IP
  masterIp = "192.168.0.200"
  # configures the group of node ip
  nodesIP =  [
    "192.168.0.201",
    "192.168.0.202"
  ]

  # master 节点配置
  config.vm.define "master" do |m|
    # 配置镜像
    m.vm.box = IMAGE_NAME
    m.vm.box_url = IMAGE_URL
    m.vm.network "public_network", ip: "#{masterIp}"
    hostname = "master"
    m.vm.provider "virtualbox" do |vb|
      vb.name = "#{hostname}"
    end
   m.vm.provision "shell", inline: <<-SHELL
    echo "127.0.0.1 #{hostname}" >> /etc/hosts
   SHELL
   m.vm.provision "shell", path: "master.sh" #  master节点的kuburnetes安装流程
   m.vm.provision "shell", path: "init-flannel.sh" #  生成flannel配置，用于网络布置
  end
  # node 节点群
 nodesIP.each do |i|
   nodeName = "node#{nodesIP.index(i)}"
   config.vm.define "#{nodeName}" do |node|
     # 配置镜像
     node.vm.box = IMAGE_NAME
     node.vm.box_url = IMAGE_URL
     node.vm.network "public_network", ip: "#{i}"
    node.vm.provider "virtualbox" do |vb|
      vb.name = "#{nodeName}"
    end
   node.vm.provision "shell", inline: <<-SHELL
    hostnamectl set-hostname #{nodeName}
    echo "127.0.0.1 #{nodeName}" >> /etc/hosts
    echo "#{masterIp} master" >> /etc/hosts
   SHELL
   node.vm.provider "virtualbox" do |vb|
     vb.name = "#{nodeName}"
   end
   node.vm.provision "shell", path: "node.sh" # node 节点的kuburnetes安装流程
   node.vm.provision "shell", path: "init-flannel.sh" #  生成flannel配置，用于网络布置
   end
 end

 # cpu 配置
 config.vm.provider "virtualbox" do |vb|
   vb.memory = "4096"
   vb.cpus = 2
 end
end


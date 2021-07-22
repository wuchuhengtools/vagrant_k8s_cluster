# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.

  # master 节点配置
  config.vm.define "master" do |m|
    # 配置镜像
    m.vm.box = "centos/stream8"     # 指定镜像
    m.vm.box_version = "20210210.0" # 指定版本
    m.vm.network "private_network", ip: "192.168.33.1"  # 内网ip
    m.vm.provider "virtualbox" do |vb|
      vb.name = "master"
    end
  end
  # node 节点群
 # (1..2).each do |i|
 #   config.vm.define "node#{i}" do |node|
 #     # 配置镜像
 #     node.vm.box = "centos/stream8"     # 指定镜像
 #     node.vm.box_version = "20210210.0" # 指定版本
 #     node.vm.network "private_network", ip: "192.168.33.#{i + 1}"  # 内网ip
 #   end
 # end

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
   config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
   config.vm.provider "virtualbox" do |vb|
     # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  
     # Customize the amount of memory on the VM:
     vb.memory = "4096"
   end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
   config.vm.provision "shell", inline: <<-SHELL
     #swapoff -a # 关闭swap交换区
     #sed -i 's/enforcing/disabled/g' /etc/sysconfig/selinux /etc/sysconfig/selinux #关闭swap交换区
     #禁用swap交换区
     # tmp='s/\([^\\n]*swap[^\\n]*\)/#\\1/g\' && sed -i $tmp /etc/fstab /etc/fstab 
     #setenforce 0  # 关闭setlinux
     #sed -i 's/enforcing/disabled/g' /etc/sysconfig/selinux /etc/sysconfig/selinux #禁用setlinux
     #yum -y install yum-utils # yum源配置管理工具 用于下面添加国内源用的
     #yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo # 添加国内镜像源
     #yum -y install docker-ce # 安装docker
     #systemctl enable docker # 开机启动
   SHELL
end

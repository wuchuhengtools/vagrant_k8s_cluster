#!/bin/sh
swapoff -a # 关闭swap交换区
sed -i 's/enforcing/disabled/g' /etc/sysconfig/selinux /etc/sysconfig/selinux #禁用 selinux
setenforce 0  #关闭swap交换区
sed -r -i 's/([^\n]*swap[^n]*)/#\1/g' /etc/fstab #禁用swap交换区
yum -y install yum-utils # yum源配置管理工具 用于下面添加国内源用的
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo # 添加国内镜像源
yum -y install docker-ce # 安装docker
systemctl enable docker # 开机启动
# 安装kuburenets 
cat << EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=http://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=0
repo_gpgcheck=0
gpgkey=http://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg http://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
yum install -y kubelet kubeadm kubectl # 安装kuburnetes
systemctl enable kubelet 
systemctl start kubelet
systemctl start docker
yum -y install vim wget


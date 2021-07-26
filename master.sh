#!/bin/sh
#################################
# 安装docker 和 kuburnetes前准备
#################################
swapoff -a # 关闭swap交换区
sed -i 's/enforcing/disabled/g' /etc/sysconfig/selinux /etc/sysconfig/selinux #禁用 selinux
setenforce 0  #关闭swap交换区
sed -r -i 's/([^\n]*swap[^n]*)/#\1/g' /etc/fstab #禁用swap交换区
yum -y install vim # 装个vim编辑方便
#################################
# 1 安装docker
#################################
yum -y install yum-utils # yum源配置管理工具 用于下面添加国内源用的
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo # 添加国内镜像源
yum -y install docker-ce # 安装docker
systemctl enable docker # 开机启动
systemctl start docker
#################################
# 2 安装kuburenets 
#################################
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
yum -y install vim wget
##############################
# 3 开放ssh 允许登录
##############################
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config /etc/ssh/sshd_config
sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config /etc/ssh/sshd_config
systemctl restart sshd


##############################
# 4 配置kuburnetes 并启动
##############################
hostnamectl set-hostname master
dir=/root/tools/kuburnetes
mkdir -p $dir
cat << EOF > $dir/init-kubeadm.yaml
apiVersion: kubeadm.k8s.io/v1beta2
bootstrapTokens:
- groups:
  - system:bootstrappers:kubeadm:default-node-token
  token: abcdef.0123456789abcdef
  ttl: 24h0m0s
  usages:
  - signing
  - authentication
kind: InitConfiguration
localAPIEndpoint:
  advertiseAddress: #{ip}
  bindPort: 6443
nodeRegistration:
  criSocket: /var/run/dockershim.sock
  name: master
  taints: null
---
apiServer:
  timeoutForControlPlane: 4m0s
apiVersion: kubeadm.k8s.io/v1beta2
certificatesDir: /etc/kubernetes/pki
clusterName: kubernetes
controllerManager: {}
dns:
  type: CoreDNS
  # coredns这个镜像国内不好下载，所以专门配置镜像源下载
  imageRepository: swr.cn-east-2.myhuaweicloud.com/coredns
  imageTag: 1.8.0
etcd:
  local:
    dataDir: /var/lib/etcd
imageRepository: registry.aliyuncs.com/k8sxio
kind: ClusterConfiguration
kubernetesVersion: 1.21.0
networking:
  dnsDomain: cluster.local
  serviceSubnet: 10.96.0.0/12
  # 这里子网
  podSubnet: 10.244.0.0/16
scheduler: {}
EOF
cd $dir
kubeadm config images pull --config init-kubeadm.yaml
kubeadm init --config init-kubeadm.yaml
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config
kubeadm token create --print-join-command >> joinMaster.sh # 把加入的maste的命令记录下来， 用于node节点过来获取这个文件并运行它就能加入了


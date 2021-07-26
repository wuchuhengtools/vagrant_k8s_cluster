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

################################################
# 5.1 把master 的配置传过来并把这边的节点加入master
################################################
#yum -y install expect
mkdir -p $HOME/.kube
tempfile="/tmp/sftpsync.$$"
echo "get -r .kube/config $HOME/.kube" >> $tempfile # 把kuburent的配置拉过来用于加入使用
echo "get -r /root/tools/kuburnetes/joinMaster.sh" >> $tempfile # 把加入的命令文件拉过来，运行这个文件就能加入了
echo "quit" >> $tempfile
ip=192.168.0.200
ssh-keyscan $ip >> $HOME/.ssh/known_hosts # 把要连接的ip的ssh指纹加入名单中，避免首次连接询问
expect -c "
    spawn sftp -o "BatchMode=no" -b "$tempfile" "root@$ip"
    expect -nocase \"*password:\" { send \"vagrant\r\"; interact }
"
sudo chown $(id -u):$(id -g) $HOME/.kube/config
bash  joinMaster.sh # 加入master节点

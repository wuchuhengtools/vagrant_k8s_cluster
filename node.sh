#!/bin/sh
#################################
# 安装docker 和 kuburnetes前准备
#################################
swapoff -a # 关闭swap交换区
sed -i 's/enforcing/disabled/g' /etc/sysconfig/selinux /etc/sysconfig/selinux #禁用 selinux
setenforce 0  #关闭swap交换区
sed -r -i 's/([^\n]*swap[^n]*)/#\1/g' /etc/fstab #禁用swap交换区
yum -y install vim & # 装个vim编辑方便
#################################
# 1 安装docker
#################################
yum -y install yum-utils # yum源配置管理工具 用于下面添加国内源用的
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo # 添加国内镜像源
yum -y install docker-ce # 安装docker
cat <<EOF> /etc/docker/daemon.json
 {
   "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF
dnf install -y iproute-tc
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
##############################
# 3 开放ssh 允许登录
##############################
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config /etc/ssh/sshd_config
sed -i 's/ChallengeResponseAuthentication no/ChallengeResponseAuthentication yes/g' /etc/ssh/sshd_config /etc/ssh/sshd_config
systemctl restart sshd

##################################################
### 5.1  把master 的配置传过来并把这边的节点加入master 这些写成一个启动配置
##################################################
sudo su
cd $HOME
mkdir -p ~/.kube
tempfile="/tmp/sftpsync.$$"
# 把要连接的ip的ssh指纹加入名单中，避免首次连接询问
ip=192.168.0.200
mkdir -p $HOME/.ssh
knowHosts=$HOME/.ssh/known_hosts
touch $knowHosts
while [[ $(stat -c%s "$knowHosts") == 0 ]]
do
    ssh-keyscan $ip >> $knowHosts
    sleep 1
done
echo $knowHosts
rsaFile=$HOME/.ssh/id_rsa
cat << EOF > $rsaFile
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAABFwAAAAdzc2gtcn
NhAAAAAwEAAQAAAQEAtoCnCmR40eM9PyCVj4Gc1vHAYgxtcAL+aOGO4MxV4NJgI+iKvwP5
+5JPC9gLvRVP6+0V2J5IbD79OOm4oP8sDZNgmHSRhGBofWTW63wPVWuMhLKhk+c4GYHizX
BXDw9JU2TwMtHEjLO8GgozYN6Qay6PcEwRwfDJO/87rlAqhUYky+mm2Ns6SE0+JgVsJfNY
Wnr7eIeV5Hn98/vhtd7wTktI+FnvluMDrIMKO55w49gt5olTWtaSi8oRlWzFoNFfVqN9F8
34kFZ7ZuPLUu2Vbkp2FZQCvppTl5yZvRju8x0YDgXI4bjFCM3saylDoKfvn5HLMrJ4yRD2
/mmZPFxyewAAA9AC3lb4At5W+AAAAAdzc2gtcnNhAAABAQC2gKcKZHjR4z0/IJWPgZzW8c
BiDG1wAv5o4Y7gzFXg0mAj6Iq/A/n7kk8L2Au9FU/r7RXYnkhsPv046big/ywNk2CYdJGE
YGh9ZNbrfA9Va4yEsqGT5zgZgeLNcFcPD0lTZPAy0cSMs7waCjNg3pBrLo9wTBHB8Mk7/z
uuUCqFRiTL6abY2zpITT4mBWwl81haevt4h5Xkef3z++G13vBOS0j4We+W4wOsgwo7nnDj
2C3miVNa1pKLyhGVbMWg0V9Wo30XzfiQVntm48tS7ZVuSnYVlAK+mlOXnJm9GO7zHRgOBc
jhuMUIzexrKUOgp++fkcsysnjJEPb+aZk8XHJ7AAAAAwEAAQAAAQBc1Zqi3bLbyUTpbLDH
e/4FFJpxBbNRjCRPw5UDYs24fCsteOfC/MnXn3gYJUDrYQDzmPlI5FMgxPXYUoN5WfPVwA
cd5gXzmXrtdjMhPE0sfXXQNnGco7xUtU5ihGe0oGkDQ9AveacKj476i//QocZCzz9ltzw9
NDeZDl8Ub3EBs22KjnUeAMhDsbzeuLKhF9Z46bEbLaIN5iWw7G0HZeegA+Xkg+U8kCZ870
a7ut/UxXxNAAspPh9xTjvZYbStLSXGh+bWT8blwjSVLMnI1x9kj0d41o0q+8Gd25ewWh7i
7j9r4LqELoEi5fwwIequKCnWtwRDdQYFMCBbVDGCWr5xAAAAgGkwzo2y1n2yYFWJTUOpzw
oAKSUA7d9N0FibCOBzP58JvgNvRVjZ0rmaqayZMWjHtaEHtLI2eBwrksoMlCuFGyL0Kvu2
EqvamteBP0ypTEO5r9rYa1QU6MbLpj78u4olLST/Y7GeMkH58500EnM9CzhH3iMm0HGoAY
ZZbN4qb3YjAAAAgQDghEl1twzVayIzl7yHIA4K3K/2VPz9F6gLuURGPV8XdUGLlcdyYYXn
8QHFvHid00mLP4p0LMWPyj2WiXbWfywEMJqBNfyVE0aEAGfmW0q4G5r2VLpxR83TuRsB6G
dNbijCloJROf3OlFTm5SOvX2F/kt+7Ds1ZIasbsWQ7rX0wOQAAAIEA0BgjSv/lVlbIa9L6
ZUYyhxJUZmdtWF4tYpMqMi7jNR0MXeQ+eyWcXHOjNkRjzmnwqrohIJTD6hpIrCphmG1PW4
j14BbwBt+xUXVi6CBWH/z5LDAXBkKI+tC+WqLVpurbFQPFrI6+AE/ZlB/ha17fLw3dKJwr
4iZhF2T5x2NUUFMAAAAXZGV2QG1hY2RlaU1hYy1Qcm8ubG9jYWwBAgME
-----END OPENSSH PRIVATE KEY-----
EOF
chmod 600 $rsaFile
sleep 1
mkdir -p /root/tools/kuburnetes
echo $HOME
sftp  root@$ip <<EOF
    ls -ahl
    get /root/.kube/config $HOME/.kube
    get /root/tools/kuburnetes/joinMaster.sh /root/tools/kuburnetes
    quit
EOF
ls -ahl /root/.kube
ls -ahl /root/tools/kuburnetes
sudo chown $(id -u):$(id -g) $HOME/.kube/config
bash /root/tools/kuburnetes/joinMaster.sh # 加入master节点

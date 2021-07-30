<h1 align="center"> vagrant_k8s_cluster </h1>

[简体中文](http://wuchuheng.com/relearnCICD/4%E6%9C%AC%E5%9C%B0vagrant%E5%AE%89%E8%A3%85k8s%E9%9B%86%E7%BE%A4%EF%BC%8C%E5%85%A8%E8%87%AA%E5%8A%A8)
## Introduction 
Kubernetes setup using vagrant

## Prerequisites
* Vagrant 
* virtualbox

## Usage
Step 1: to clone the repository
``` bash
$ git clone https://github.com/wuchuhengtools/vagrant_k8s_cluster.git
$ cd vagrant_k8s_cluster
```
Step 2:  start up the cluster 
``` bash 
$ vagrant up # <-- initialization cluster 
$ vagrant ssh master
$ sudo su
# kubectl get nodes # <-- show the k8s cluster
NAME     STATUS   ROLES                  AGE   VERSION
master   Ready    control-plane,master   19h   v1.21.3
node0    Ready    <none>                 18h   v1.21.3
node1    Ready    <none>                 18h   v1.21.3
```

## Contributing

You can contribute in one of three ways:

1. File bug reports using the [issue tracker](https://github.com/wuchuhengtools/vagrant_k8s_cluster/issues).
2. Answer questions or fix bugs on the [issue tracker](https://github.com/wuchuheng/vagrant_k8s_cluster/issues).
3. Contribute new features or update the wiki.

## License

MIT

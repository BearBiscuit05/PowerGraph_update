# 分布式pg运行

在本文件中，将指导如何运行一个分布式的PowerGraph

## 1.下载docker镜像

```bash
docker pull bearbiscuit/pgimage:latest
```



## 2.下载更新版本的PowerGraph

```bash
git clone https://github.com/BearBiscuit05/PowerGraph_update.git
```



## 3.构建集群环境

首先，docker集群必须在同一个子网下，因此我们需要先创建子网

```bash
docker network create --driver bridge --subnet 43.0.0.0/16 --gateway 43.0.0.0 pg_network
```

随后，我们修改`runDocker.sh`脚本中的内容，以调整至你所需要的内容(如映射PowerGraph，映射图数据)



## 4.运行PG

在docker集群搭建完成后，进入任意容器，并进入PG程序运行的目录下，随后运行

```bash
mpiexec --allow-run-as-root -n 2 -hostfile /root/data/machines ./pagerank --graph_opts="ingress=random" --graph /root/data/test.edges --format self_tsv
```

对于命令的解释在`README.md`文件中，可以进行指定的修改
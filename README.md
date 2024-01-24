PowerGraph是2012年发表在OSDI会议上的一篇有关于图计算系统的文章。由于其本身包含了多种传统图算法，并且支持分布式计算，因此直到今日依然会成为众多论文的基线对比，或者是通过PG来验证一些算法的效果。

但是由于PowerGraph年久失修，目前无法直接通过github的源码来进行编译，主要的原因还是第三方库的URL失效。由于最近我们的论文有使用到PG计算框架，也是踩了许多坑，再次进行记录，希望可以方便后面还需要使用PG来进行测试的人员。

github地址:[GitHub - BearBiscuit05/PowerGraph_update](https://link.zhihu.com/?target=https%3A//github.com/BearBiscuit05/PowerGraph_update)

源仓库地址:[https://github.com/jegonzal/PowerGraph](https://link.zhihu.com/?target=https%3A//github.com/jegonzal/PowerGraph)

## [环境配置需求](https://link.zhihu.com/?target=https%3A//github.com/BearBiscuit05/PowerGraph_update%23%E7%8E%AF%E5%A2%83%E9%85%8D%E7%BD%AE%E9%9C%80%E6%B1%82)

- Ubuntu16.04
- gcc 5.4
- g++5.4
- jdk1.8
- build-essential
- Zlib

## [配置流程](https://link.zhihu.com/?target=https%3A//github.com/BearBiscuit05/PowerGraph_update%23%E9%85%8D%E7%BD%AE%E6%B5%81%E7%A8%8B)

```text
sudo apt-get update

sudo apt-get install gcc g++ build-essential libopenmpi-dev openmpi-bin default-jdk cmake zlib1g-dev git

git clone https://github.com/BearBiscuit05/PowerGraph_update.git

cd PowerGraph_update

./configure

cd release/toolkits/graph_analytics

make -j2
```

## 或者直接从docker hub拉取镜像

```text
docker pull bearbiscuit/pgimage:latest
```

## [自定义分区结果导入](https://link.zhihu.com/?target=https%3A//github.com/BearBiscuit05/PowerGraph_update%23%E8%87%AA%E5%AE%9A%E4%B9%89%E5%88%86%E5%8C%BA%E7%BB%93%E6%9E%9C%E5%AF%BC%E5%85%A5)

PowerGraph可以很方便的进行一些传统图计算任务的运行，经常作为论文的基线测试程序，用于测试分区算法的健壮性，因此，为了方便在PG上测试分区算法在实际分布式场景下的表现，我们对PG的代码进行了一些调整，使得PG可以直接接受来自外部的分区结果，以供应用。

### [分区文件结构需求](https://link.zhihu.com/?target=https%3A//github.com/BearBiscuit05/PowerGraph_update%23%E5%88%86%E5%8C%BA%E6%96%87%E4%BB%B6%E7%BB%93%E6%9E%84%E9%9C%80%E6%B1%82)

以一个graph.txt文件为例，每一行包含三个参数，分别是src,dst,partid，其中partid表明对应的边(src，dst)最后被分配到哪一个分区中。三个参数之间需要用`\t`分隔。

```text
#SRC\tDST\tpartid
1	2	0
2	3	1
3	0	1
```

### [文件运行的参数设置](https://link.zhihu.com/?target=https%3A//github.com/BearBiscuit05/PowerGraph_update%23%E6%96%87%E4%BB%B6%E8%BF%90%E8%A1%8C%E7%9A%84%E5%8F%82%E6%95%B0%E8%AE%BE%E7%BD%AE)

由于我们的导入接口设置在random中，替代了原先的random方法，因此，运行的命令调整为

```text
./pagerank --graph_opts="ingress=random" --graph /data/in_S5P.txt --format self_tsv

# 其中pagerank通过之前的make命令完成编译，路径在release/toolkits/graph_analytics下
# --graph参数接着的是图的文件路径
# format本意是告诉PG你的图文件结构，self_tsv便是上面提到的三参数文件结构
```



## 分布式PG运行流程

## [1.下载docker镜像](https://link.zhihu.com/?target=https%3A//github.com/BearBiscuit05/PowerGraph_update/blob/master/cluster.md%231%E4%B8%8B%E8%BD%BDdocker%E9%95%9C%E5%83%8F)

前一节中已经提供了详细的信息

```text
docker pull bearbiscuit/pgimage:latest
```

## [2.下载更新版本的PowerGraph](https://link.zhihu.com/?target=https%3A//github.com/BearBiscuit05/PowerGraph_update/blob/master/cluster.md%232%E4%B8%8B%E8%BD%BD%E6%9B%B4%E6%96%B0%E7%89%88%E6%9C%AC%E7%9A%84powergraph)

```text
git clone https://github.com/BearBiscuit05/PowerGraph_update.git
```

## [3.构建集群环境](https://link.zhihu.com/?target=https%3A//github.com/BearBiscuit05/PowerGraph_update/blob/master/cluster.md%233%E6%9E%84%E5%BB%BA%E9%9B%86%E7%BE%A4%E7%8E%AF%E5%A2%83)

首先，docker集群必须在同一个子网下，因此我们需要先创建子网

```text
docker network create --driver bridge --subnet 43.0.0.0/16 --gateway 43.0.0.1 pg_network
```

随后，我们修改`runDocker.sh`脚本中的内容，以调整至你所需要的内容(如映射PowerGraph，映射图数据)

## [4.运行PG](https://link.zhihu.com/?target=https%3A//github.com/BearBiscuit05/PowerGraph_update/blob/master/cluster.md%234%E8%BF%90%E8%A1%8Cpg)

在docker集群搭建完成后，进入任意容器，并进入PG程序运行的目录下，随后运行

```text
mpiexec --allow-run-as-root -n 2 -hostfile /root/data/machines ./pagerank --graph_opts="ingress=ra
```

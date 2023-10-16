# Powergraph更新

源仓库地址:https://github.com/jegonzal/PowerGraph

该仓库更新的目的：

在原来仓库中，需要下载多个第三方库，但由于年久失修，很多URL已经失效，导致无法成功完成编译。现在将PG所需要的第三方库均整合到`external_lib`中，并且在Camkefile中进行修改，使得PG框架可以重新运行。具体操作如下：

## 环境配置需求

+ Ubuntu16.04
+ gcc 5.4
+ g++5.4
+ jdk1.8
+ build-essential
+ Zlib



## 配置流程

```bash
sudo apt-get update

sudo apt-get install gcc g++ build-essential libopenmpi-dev openmpi-bin default-jdk cmake zlib1g-dev git

cd graphlab

./configure

cd release/toolkits/graph_analytics

make -j2
```



## 自定义分区结果导入

PowerGraph可以很方便的进行一些传统图计算任务的运行，经常作为论文的基线测试程序，用于测试分区算法的健壮性，因此，为了方便在PG上测试分区算法在实际分布式场景下的表现，我们对PG的代码进行了一些调整，使得PG可以直接接受来自外部的分区结果，以供应用。



#### 分区文件结构需求

以一个graph.txt文件为例，每一行包含三个参数，分别是src,dst,partid，其中partid表明对应的边(src，dst)最后被分配到哪一个分区中。三个参数之间需要用`\t`分隔。

```txt
#SRC\tDST\tpartid
1	2	0
2	3	1
3	0	1
```



#### 文件运行的参数设置

由于我们的导入接口设置在random中，替代了原先的random方法，因此，运行的命令调整为

```bash
./pagerank --graph_opts="ingress=random" --graph /data/in_S5P.txt --format self_tsv

# 其中pagerank通过之前的make命令完成编译，路径在release/toolkits/graph_analytics下
# --graph参数接着的是图的文件路径
# format本意是告诉PG你的图文件结构，self_tsv便是上面提到的三参数文件结构
```





后面将会更新基于docker的分布式PG运行办法。
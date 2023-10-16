# Powergraph更新

源仓库地址:https://github.com/jegonzal/PowerGraph

该仓库更新的目的：

在原来仓库中，需要下载多个第三方库，但由于年久失修，很多URL已经失效，导致无法成功完成编译。现在将PG所需要的第三方库均整合到`external_lib`中，并且在Cmakefile中进行修改，使得PG框架可以重新运行。具体操作如下：

## 环境配置需求

+ Ubuntu16.04 (important)
+ gcc 5.4
+ g++5.4
+ jdk1.8
+ build-essential
+ Zlib



## 配置流程

```bash
sudo apt-get update

sudo apt-get install gcc g++ build-essential libopenmpi-dev openmpi-bin default-jdk cmake zlib1g-dev git

git clone https://github.com/BearBiscuit05/PowerGraph_update.git

cd graphlab

./configure

cd release/toolkits/graph_analytics

make -j2
```

后面将会更新基于docker的分布式PG运行办法。
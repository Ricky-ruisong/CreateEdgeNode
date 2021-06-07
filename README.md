## Deploy kubeedge's edge nodes using docker-compose
+ 配置certs & ca
  ```bash
  mkdir /etc/kubedge
  edgecore gets ca and certs from cloudcore automatically, 
  and save them in directory /etc/kubeedge/, so we need do nothing
  ```
  
+ 配置edgecore.yaml
  ```bash
  mkdir /etc/kubedge/config
  cp kubedge/config/edgecore.yaml /etc/kubedge/config
  vim /etc/kubedge/config/edgecore.yaml
  ```
   主要配置项说明如下：
  
  | name                                 | note                        |
  | ------------------------------------ | --------------------------- |
  | modules.edged.nodeip                 | 当前节点的IP                |
  | modules.edged.hostnameoverride       | 当前节点的在K8s展现的名字   |
  | modules.edged.interfacename          | ifconfig                    |
  | modules.edgehub.token                | cloudhub token             |
  | modules.edgehub.websocket.server     | cloudhub ws地址             |
  | modules.edged.podsandboximage        | kubeedge/pause-${arch}:3.1  |
  
+ 修改.env

   ```bash
   vim .env
   ```
   主要配置项说明如下：
  
  | name           | default                      | note                                                         |
  | -------------- | ---------------------------- | ------------------------------------------------------------ |
  | cloudhub       | 0.0.0.0:10000                | cloudhub ws 地址                                             |
  | edgename       | edge-node                    | 建议命名 edge-${co-processor}${id}                           |
  | edgecore_image | kubeedge/edgecore:latest     | harbor.eniot.io/eap/opensource/${arch}/edgecore:release-1.2-64d01dab    arch arm64\|x86 |
  | arch           | amd64                        | Optional: amd64 \| arm64v8 \| arm32v7 \| i386 \| s390x       |
  | qemu_arch      | x86_64                       | Optional: x86_64 \| aarch64 \| arm \| i386 \| s390x          |
  | certpath       | /etc/kubeedge/certs          |                                                              |
  | certfile       | /etc/kubeedge/certs/edge.crt |                                                              |
  | keyfile        | /etc/kubeedge/certs/edge.key |                                                              |


+ Start container
  ```
  docker-compose up -d
  ```

+ 检查状态
  ```
  docker-compose ps
  ```



 ## How to enable edgemesh

edgemesh 安装参考: https://docs.kubeedge.io/en/latest/contributing/edgemesh_guide.html

使能edgemesh 额外需要的操作:

+ 修改docker-compose.yaml 使 emqx 和 edgecore 使用 network_mode: "host" : 因为edgemesh 需要使用docker0

+ 修改docker-compose.yaml 给 edgecore添加如下volume:

  ```cassandraql
  1)  /var/lib/docker:/var/lib/docker  # 用于新创建的container挂载host resolv.conf
  2)  /var/lib/edged:/var/lib/edged    # 用于新创建的container挂载host etc-hosts
  3)  /var/run:/var/run                # 用于连接host docker
  ```

+ 修改edgecore.yaml

  ```cassandraql
   1) edgeMesh.enable = true
   2) 删除edgeMesh.dockerAaddress
   3) eventBus.mqttServerExternal = tcp://127.0.0.1:8888   eventBus.mqttServerInternal = tcp://127.0.0.1:8889
  ```

  另外注意：

+ 创建deployment时 需要指定container的hostPort，hostPort 在edgeMesh中会用于查找指定服务，不指定的话，edgeMesh 不可用

+ 执行curl 请求service 对应的地址时，要在kubeedge创建的docker container 中运行



## How to build edgecore

Go to a arm host and run the following command

```
git clone https://github.com/kubeedge/kubeedge.git
git checkout <tag-you-want>
cd kubeedge
make edgeimage ARCH=arm64v8
```


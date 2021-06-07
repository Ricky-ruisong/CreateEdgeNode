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
  
  | name            | default                           | note                                               |
  | --------------- | ----------------------------------| -------------------------------------------------- |
  | cloudhub        | 0.0.0.0:10000                     | cloudhub ws 地址, aks开发集群为20.44.194.240:10000 |
  | edgename        | edge-node                         | 建议命名 edge-${co-processor}${id} e.g. edge-gpu1  |
  | edgecore_image  | kubeedge/edgecore:latest          | harbor.eniot.io/eap/opensource/${arch}/edgecore:release-1.2-64d01dab    arch arm64\|x86         |
  | arch            | amd64                             | Optional: amd64 \| arm64v8 \| arm32v7 \| i386 \| s390x |
  | qemu_arch       | x86_64                            | Optional: x86_64 \| aarch64 \| arm \| i386 \| s390x  |
  | certpath        | /etc/kubeedge/certs               |                            |
  | certfile        | /etc/kubeedge/certs/edge.crt      |                            |
  | keyfile         | /etc/kubeedge/certs/edge.key      |                            |


+ Start container
  ```
  docker-compose up -d
  ```

+ 检查状态
  ```
  docker-compose ps
  ```


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
   3) eventBus.mqttServerExternal = tcp://127.0.0.1:1883   eventBus.mqttServerInternal = tcp://127.0.0.1:1884
  ```

  另外注意：

+ 创建deployment时 需要指定container的hostPort，hostPort 在edgeMesh中会用于查找指定服务，不指定的话，edgeMesh 不可用

+ 执行curl 请求service 对应的地址时，要在kubeedge创建的docker container 中运行
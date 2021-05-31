#!/bin/bash

#Name:CreateEdgeNode.sh
#Desc:用户输入基础信息完成配置
#Path:~/Desktop/eap-kubeedge-deployment-master/edge/CreateEdgenode.sh
#Usage:sh CreateEdgeNode.sh
#Update:2021.5.31

#文件路径
EdgFile=~/Desktop/eap-kubeedge-deployment-master/edge/kubeedge/config/edgecore.yaml
DocFile=~/Desktop/eap-kubeedge-deployment-master/edge/docker-compose.yaml
EnvFile=~/Desktop/eap-kubeedge-deployment-master/edge/.env
EdgDir=~/Desktop/eap-kubeedge-deployment-master/edge/kubeedge/config
DocDir=~/Desktop/eap-kubeedge-deployment-master/edge
TarDir=/etc/kubeedge/config

#创建对象
sudo mkdir -p /etc/kubeedge/config
cd ${EdgDir}
sudo cp edgecore.yaml ${TarDir}

#配置edgecore.yaml
echo "接下来配置edgecore.yaml"
read -p "请输入当前节点的在K8s展现的名字(eg:edge-gpu2):" hostname
sed -i 's/hostnameOverride.*/hostnameOverride: '$hostname'/' ${EdgFile}
read -p "请输入ifconfig(eg:eth0):" ifconfig
sed -i 's/interfaceName.*/interfaceName: '$ifconfig'/' ${EdgFile}
read -p "请输入cloudhub token(如果希望自动生成，直接Enter):" Token
if [ ! $Token ];then
    Token=`kubectl -n kubeedge get secret tokensecret -o yaml | grep tokendata | awk -F ': ' '{print $2}' | base64 -d`
fi
sed -i 's/token.*/token: '\"$Token\"'/' ${EdgFile}
read -p "请输入arch(Optional: amd64| arm64v8| arm32v7| i386| s390x):" edgearch
sed -i 's/pause-.*/pause-'$edgearch':3.1/' ${EdgFile}

#配置.env
echo “接下来配置.env”
read -p "请输入arch(Optional: amd64| arm64v8| arm32v7| i386| s390x):" arch
sed -i 's/^ARCH=.*/ARCH='$arch'/' ${EnvFile}

read -p "请输入qemu_arch(Optional: x86_64| aarch64| arm| i386| s390x):" qume_arch
sed -i 's/^QEMU_ARCH.*/QEMU_ARCH='$qume_arch'/' ${EnvFile}

cd ${DocDir}
sudo docker-compose up -d
sudo docker-compose ps

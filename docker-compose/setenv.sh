#!/bin/bash

arch=`uname -m`

case $arch in
"x86_64")
      export ARCH_TAG="x86_64-0.6.1-preview"
  ;;
"s390x")
      export ARCH_TAG="s390x-0.6.1-preview"
  ;;
"ppc64le")
      export ARCH_TAG="ppc64le-0.6.1-preview"       
  ;;
*)
  echo "No Architectural Images Available for Architecture: $arch - Please call ibm service"
  return 
  ;;
esac

docker pull hyperledger/fabric-peer:${ARCH_TAG} 
if [ $? -ne 0 ]; then
   echo "docker pull failed to peer image"
   return 
fi

docker tag hyperledger/fabric-peer:${ARCH_TAG} hyperledger/fabric-baseimage:latest
if [ $? -ne 0 ]; then
   echo "docker tag failed"
   return
fi


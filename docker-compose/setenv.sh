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

cat baseimage/Dockerfile.in | sed -e "s/_ARCH_TAG_/$ARCH_TAG/g" > baseimage/Dockerfile

#!/bin/bash
if [ $(uname -m) == "x86_64" ] || [ $(uname -m) == "x86_32" ]; then
    export ARCH_MEMSVC="fabric-membersrvc:x86_64-0.6.0-preview"
    export ARCH_PEER="fabric-peer:x86_64-0.6.0-preview"
elif [ $(uname -m) == "s390x" ]; then
    export ARCH_MEMSVC="fabric-membersrvc:s390x-0.6.0-preview"
    export ARCH_PEER="fabric-peer:s390x-0.6.0-preview"
elif [ $(uname -m) == "ppc64le" ]; then
    export ARCH_MEMSVC="fabric-membersrvc:ppc64le-0.6.0-preview"
    export ARCH_PEER="fabric-peer:ppc64le-0.6.0-preview"
else
    export ARCH_MEMSVC="unknownarch"
    export ARCH_PEER="unknownarch"
fi

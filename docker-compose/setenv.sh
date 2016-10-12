#!/bin/bash
if [ $(uname -m) == "x86_64" ] | [ $(uname -m) == "x86_64" ]; then
    export ARCH_MEMSVC="fabric-membersrvc:x86_64-0.6.0-preview"
    export ARCH_PEER="fabric-peer:x86_64-0.6.0-preview"
elif [ $(uname -m) == "s390x" ]; then
    export ARCH_MEMSVC="fabric-membersrvc:s390x-0.6.0-preview"
    export ARCH_PEER="fabric-peer:s390x-0.6.0-preview"
fi

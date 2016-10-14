#!/bin/bash
if [ $(uname -m) == "x86_64" ] || [ $(uname -m) == "x86_32" ]; then
    export ARCH_TAG="x86_64-0.6.1-preview"
elif [ $(uname -m) == "s390x" ]; then
    export ARCH_TAG="s390x-0.6.1-preview"
elif [ $(uname -m) == "ppc64le" ]; then
    export ARCH_TAG="ppc64le-0.6.1-preview"
else
    export ARCH_TAG="unknownarch"
fi

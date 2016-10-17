#!/bin/bash
if [ $(uname -m) == "x86_64" ]; then
    export ARCH_TAG="x86_64-0.6.1-preview"
    export BASE_TAG="x86_64-0.0.11"
elif [ $(uname -m) == "s390x" ]; then
    export ARCH_TAG="s390x-0.6.1-preview"
    export BASE_TAG="s390x-0.0.11"
elif [ $(uname -m) == "ppc64le" ]; then
    export ARCH_TAG="ppc64le-0.6.1-preview"
    export BASE_TAG="ppc64le-0.0.11"
else
    export ARCH_TAG="unknownarch"
    export BASE_TAG="unknownarch"
    echo "WARNING:" $(uname -m) "is an unsupported architecture"
fi

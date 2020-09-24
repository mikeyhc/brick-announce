#!/bin/sh

docker run --rm -ti -u $(grep $USER /etc/passwd | cut -f3 -d:) \
    -v $(pwd):/app announce-build:latest

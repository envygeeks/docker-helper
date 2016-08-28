[![Build Status](https://travis-ci.org/envygeeks/docker-helper.svg?branch=master)](https://travis-ci.org/envygeeks/docker-helper)

# Docker Helper

A set of bash functions (ran through a script) to aide your Docker Images. The
goal is to normalize common functions when creating Docker images.

# Installing

```bash
docker run --rm -it envygeeks/ubuntu bash
mkdir -p /usr/src && cd /usr/src

git clone https://github.com/envygeeks/docker-helpers.git
mkdir -p /usr/local/share/docker && cp docker-helper/src/* -R \
  /usr/local/share/docker

ln -s /usr/local/share/docker/docker-helper \
  /usr/local/bin/docker-helper
```

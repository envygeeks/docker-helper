[![Build Status](https://travis-ci.org/envygeeks/docker-helper.svg?branch=master)](https://travis-ci.org/envygeeks/docker-helper)

# Docker Helper

A few bash scripts to make working with Docker images easier.  If you are
looking for legacy Docker Helper that had dozens of more functions that were
suited for old Docker, please see the legacy branch.

# Installing

```bash
docker run --rm -it envygeeks/ubuntu bash
mkdir -p /usr/src && cd /usr/src

git clone https://github.com/envygeeks/docker-helper.git
cp docker-helper/src/* -R /
cleanup && reset-user && \
  test-sha
```

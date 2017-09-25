# ubuntu-s3fs ![alt text](https://github.com/dpizzuto/ubuntu-s3fs/raw/master/src/image\aws-s3-logo.png")

The Dockerfile provides a way to create a ubuntu-based docker container with a S3 endpoint mounted as a filesystem

## Prerequisites
- S3 bucket
- AWS role with read/write access to S3

## Description
The Dockerfile contains a series of commands ready-to-use. There are two configuration files for fuse and supervisord.

This is a **POC** project so there are a bunch of improvements that should be done to beautify scripts.

## Steps
1. Gets the ubuntu base image from Docker repo
```shell
FROM ubuntu
```
2. Install some required packages from package repo
```shell
RUN apt-get update && apt-get install -y \
  automake \
  autotools-dev \
  g++ \
  git \
  libcurl4-gnutls-dev \
  fuse \
  libfuse-dev \
  libssl-dev \
  libxml2-dev \
  make \
  pkg-config \
  supervisor \
  dos2unix
  ```
3. Sets working directory and create a dir where scripts are placed
```shell
WORKDIR /home/
RUN mkdir scripts
```
4. Copy **installS3fs.sh** (from AWS GitHub repo, but I suggest to make a fork) script on container and run it
```shell
COPY scripts/installS3fs.sh scripts/installS3fs.sh
RUN chmod +x scripts/installS3fs.sh
RUN . scripts/installS3fs.sh
```
5. Copy some configuration file in the right directory
```shell
COPY config/fuse.conf /etc/fuse.conf
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
```
6. Copy and run **runs3fs.sh** and finalize configuration.
**Pay attention here, you have to insert the AWS information in order to work properly with SDK**
```shell
COPY scripts/runS3fs.sh scripts/runS3fs.sh
RUN chmod +x scripts/*
RUN dos2unix scripts/runS3fs.sh
ENTRYPOINT /home/scripts/runS3fs.sh && /bin/bash
CMD ["/usr/bin/supervisord"]
```

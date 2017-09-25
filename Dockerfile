FROM ubuntu

# configure container with required software
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

# set work dir
WORKDIR /home/
RUN mkdir scripts

# install S3fs
COPY scripts/installS3fs.sh scripts/installS3fs.sh
RUN chmod +x scripts/installS3fs.sh
RUN . scripts/installS3fs.sh

# copy config file for S3fs and supervisord
COPY config/fuse.conf /etc/fuse.conf
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# run s3fs 
COPY scripts/runS3fs.sh scripts/runS3fs.sh
RUN chmod +x scripts/*
RUN dos2unix scripts/runS3fs.sh
ENTRYPOINT /home/scripts/runS3fs.sh && /bin/bash
CMD ["/usr/bin/supervisord"]
  
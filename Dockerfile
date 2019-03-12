FROM ubuntu:bionic

RUN apt-get update && \ 
    apt-get install -y \
	libopenmpi-dev \
	libopenimageio-dev \
	pkg-config \
	make \
	cmake \
	build-essential \
	libz-dev \
	libtbb-dev \
	libglu1-mesa-dev \
	freeglut3-dev \
	libnetcdf-c++4-dev \
	xorg-dev \
        x11-apps \
	xauth \
	x11-xserver-utils \
	vim \
	libjpeg-dev \
	imagemagick \
	python3.7 \
        python3-pip \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /opt/
ADD ispc-v1.9.1-linux.tar.gz /opt/
RUN mv ispc-v1.9.1-linux ispc
WORKDIR /opt/ispc/
RUN update-alternatives --install /usr/bin/ispc ispc /opt/ispc/ispc 1

WORKDIR /opt/
ADD embree-3.5.0.x86_64.linux.tar.gz /opt/
RUN mv embree-3.5.0.x86_64.linux embree
WORKDIR /opt/embree/

WORKDIR /app/
COPY moana-ospray-demo.tgz /tmp/
RUN tar xf /tmp/moana-ospray-demo.tgz --strip-components 2

WORKDIR /app/source
RUN bash ./README.sh

WORKDIR /src/
COPY 1 1
RUN cp -rv 1/* /app/ && chown root:root -R /app && rm -rf 1 && cd /app/source && bash ./README.sh

WORKDIR /src/
COPY 2 2
RUN cp -rv 2/* /app/ && chown root:root -R /app && rm -rf 2 && cd /app/source && bash ./README.sh

WORKDIR /app/
RUN ln -sf /mnt/seenas2/data/moana/island island
COPY server .
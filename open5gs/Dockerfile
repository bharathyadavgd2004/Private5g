# ---------- Stage 1: Build ----------
FROM ubuntu:24.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-setuptools \
    python3-wheel \
    ninja-build \
    build-essential \
    flex \
    bison \
    git \
    libsctp-dev \
    libgnutls28-dev \
    libgcrypt-dev \
    libssl-dev \
    libidn-dev \
    libmongoc-dev \
    libbson-dev \
    libyaml-dev \
    libnghttp2-dev \
    libmicrohttpd-dev \
    libcurl4-gnutls-dev \
    libtins-dev \
    libtalloc-dev \
    meson \
    cmake \
    pkg-config \
    wget && \
    rm -rf /var/lib/apt/lists/*

RUN pip3 install --upgrade meson --break-system-packages

WORKDIR /src

RUN git clone --recurse-submodules -b v2.8.0 https://github.com/open5gs/open5gs

WORKDIR /src/open5gs

RUN meson build --prefix=$(pwd)/install && \
    ninja -C build && \
    ninja -C build install

RUN mkdir -p /hnet-keys && cp -r /src/open5gs/configs/open5gs/hnet/* /hnet-keys/


# ---------- Stage 2: Runtime ----------
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    libsctp1 \
    libgnutls30 \
    libgcrypt20 \
    libssl3 \
    libidn12 \
    libmongoc-1.0-0 \
    libbson-1.0-0 \
    libyaml-0-2 \
    libnghttp2-14 \
    libmicrohttpd12 \
    libcurl3t64-gnutls \
    libtalloc2 \
    libtins4.5 \
    iproute2 \
    iptables \
    iproute2 \
    iputils-ping \
    tcpdump && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /src/open5gs/install /opt/open5gs

COPY --from=builder /hnet-keys /open5gs/hnet

ENV PATH="/opt/open5gs/bin:${PATH}"
ENV LD_LIBRARY_PATH=/opt/open5gs/lib:/opt/open5gs/lib/x86_64-linux-gnu

RUN mkdir -p /etc/open5gs /var/log/open5gs

WORKDIR /opt/open5gs

# Default entrypoint (can be overridden in Kubernetes Deployments)
ENTRYPOINT ["/bin/bash", "-c"]

CMD ["echo 'Specify a command, e.g.: open5gs-nrfd -c /etc/open5gs/nrf.yaml'"]

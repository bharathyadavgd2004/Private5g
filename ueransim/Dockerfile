# =====================================================================
# UERANSIM — 5G UE & gNB Simulator (multi-stage build)
# One shared image for BOTH roles — the Kubernetes Deployment picks
# nr-gnb vs nr-ue (and its config file) at runtime via `command`/`args`.
# =====================================================================

# ----------------------------
# Stage 1 : Build UERANSIM
# ----------------------------
FROM ubuntu:24.04 AS builder
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git \
    make \
    gcc \
    g++ \
    cmake \
    build-essential \
    libsctp-dev \
    lksctp-tools \
    iproute2 \
    iputils-ping \
    wget && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /src
RUN git clone --recursive -b v3.2.7 https://github.com/aligungr/UERANSIM.git

WORKDIR /src/UERANSIM
# UERANSIM's top-level Makefile wraps its own CMake configure+build,
# so a plain `make` here is correct — no separate `cmake ..` step needed.
RUN make -j$(nproc)


# ----------------------------
# Stage 2 : Runtime
# ----------------------------
FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    libsctp1 \
    lksctp-tools \
    iproute2 \
    iputils-ping \
    tcpdump \
    iptables \
    net-tools \
    libstdc++6 \
    ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Only the compiled binaries are carried over — not the source tree or
# build toolchain, keeping the runtime image small.
COPY --from=builder /src/UERANSIM/build/nr-gnb /usr/local/bin/
COPY --from=builder /src/UERANSIM/build/nr-ue  /usr/local/bin/
COPY --from=builder /src/UERANSIM/build/nr-cli /usr/local/bin/

RUN mkdir -p /etc/ueransim
WORKDIR /etc/ueransim

# No default command on purpose — this image plays both the gNB and UE
# roles. The Kubernetes Deployment for each selects the binary + config,
# e.g.:
#   gNB → command: ["/usr/local/bin/nr-gnb"], args: ["-c", "/etc/ueransim/gnb.yaml"]
#   UE  → command: ["/usr/local/bin/nr-ue"],  args: ["-c", "/etc/ueransim/ue.yaml"]
# Running the container with no override just drops you into a shell for
# manual testing/debugging.
CMD ["bash"]

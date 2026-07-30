# ---------- Stage 1 : Build ----------
FROM ubuntu:24.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git \
    curl \
    python3 \
    build-essential \
    npm

WORKDIR /src

RUN git clone -b v2.8.0 https://github.com/open5gs/open5gs

WORKDIR /src/open5gs/webui

RUN npm install

RUN npm run build

# ---------- Stage 2 : Runtime ----------
FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/open5gs-webui

COPY --from=builder /src/open5gs/webui .

ENV HOSTNAME=0.0.0.0
ENV PORT=9999
ENV DB_URI=mongodb://mongodb/open5gs
ENV NODE_ENV=production

EXPOSE 9999

CMD ["node","server/index.js"]

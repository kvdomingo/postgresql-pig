ARG PG_VERSION=18
ARG TARGETPLATFORM=linux/amd64

FROM --platform=${TARGETPLATFORM} postgres:${PG_VERSION}-bookworm

ARG PG_VERSION

USER root

WORKDIR /tmp

SHELL [ "/bin/bash", "-euxo", "pipefail", "-c" ]

# DL3009: apt lists are removed later
# hadolint ignore=DL3009
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl sudo ca-certificates

ADD https://repo.pigsty.io/pig install-pig.sh

RUN chmod +x install-pig.sh && \
    bash install-pig.sh && \
    pig repo add pigsty pgdg -u && \
    pig ext install \
      pg_idkit \
      pg_stat_monitor \
      pgaudit \
      pgvector \
      postgis \
      -y && \
    apt-get remove -y curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /

USER 999

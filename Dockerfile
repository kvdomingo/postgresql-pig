FROM debian:bookworm-slim

ARG PG_VERSION
ENV PATH="${PATH}:/usr/lib/postgresql/${PG_VERSION}/bin"

USER root

WORKDIR /tmp

SHELL [ "/bin/bash", "-euxo", "pipefail", "-c" ]
# DL3009: Lists are deleted later
# hadolint ignore=DL3009
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl sudo ca-certificates gnupg

ADD https://repo.pigsty.cc/pig install-pig.sh

RUN chmod +x install-pig.sh && \
    bash install-pig.sh && \
    pig repo add pigsty pgdg -u && \
    pig ext install \
      "postgresql-${PG_VERSION}" \
      pgvector \
      pg_idkit \
      pg_stat_monitor \
      pgaudit \
      pg_failover_slots \
      -y && \
    apt-get purge -y --auto-remove && \
    rm -rf /var/lib/apt/lists/* /var/cache/* /var/log/*

RUN usermod -u 26 postgres

USER 26

WORKDIR /

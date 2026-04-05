ARG PG_VERSION=18
ARG TARGETPLATFORM=linux/amd64
ARG TARGETARCH=amd64

FROM --platform=${TARGETPLATFORM} postgres:${PG_VERSION}-bookworm

ARG PG_VERSION
ARG TARGETARCH

USER root

WORKDIR /tmp

SHELL [ "/bin/bash", "-euxo", "pipefail", "-c" ]

# hadolint ignore=DL3009
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && \
    apt-get install -y --no-install-recommends curl sudo ca-certificates pgbackrest && \
    mkdir -p /var/log/pgbackrest /var/spool/pgbackrest /etc/pgbackrest && \
    chown -R 999:999 /var/log/pgbackrest /var/spool/pgbackrest /etc/pgbackrest

ADD https://repo.pigsty.io/pig install-pig.sh

# hadolint ignore=DL3009
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    chmod +x install-pig.sh && \
    bash install-pig.sh && \
    pig repo add pigsty pgdg -u && \
    pig ext install \
      anon \
      citus \
      hll \
      hstore \
      hypopg \
      logerrors \
      pg_auth_mon \
      pg_cron \
      pg_hint_plan \
      pg_idkit \
      pg_net \
      pg_qualstats \
      pg_repack \
      pg_show_plans \
      pg_stat_kcache \
      pg_stat_monitor \
      pg_stat_statements \
      pg_wait_sampling \
      pgaudit \
      pgcrypto \
      pgextwlist \
      pgvector \
      plpython3u \
      postgis \
      postgres_fdw \
      powa \
      rum \
      set_user \
      timescaledb \
      topn \
      wal2json \
      -y && \
    apt-get remove -y curl

WORKDIR /

USER 999

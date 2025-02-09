ARG PG_VERSION

FROM bitnami/postgresql-repmgr:${PG_VERSION}

ARG PG_VERSION
ENV SUDO_FORCE_REMOVE=yes
ENV POSTGRESQL_BASE_DIR=/opt/bitnami/postgresql

USER root

WORKDIR /tmp

SHELL [ "/bin/bash", "-euxo", "pipefail", "-c" ]

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl sudo

ADD https://repo.pigsty.cc/pig install-pig.sh

RUN chmod +x install-pig.sh && \
    bash install-pig.sh && \
    pig repo add pigsty pgdg -u && \
    pig ext install \
      pgvector \
      pg_idkit \
      pg_stat_monitor \
      pgaudit \
      -y && \
    # Pig CLI can detect the Postgres installation but does not install
    # extensions in the correct directory!
    cp -r "/usr/lib/postgresql/${PG_VERSION}/lib/" "${POSTGRESQL_BASE_DIR}" && \
    cp -r "/usr/share/postgresql/${PG_VERSION}/extension/" "${POSTGRESQL_BASE_DIR}/share" && \
    apt-get remove -y curl sudo && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER 1001

# PostgreSQL-Pig

Official Postgres Docker image with [Pig CLI](https://github.com/pgsty/pig)

Default installed extensions:

- pg_idkit
- pg_stat_monitor
- pgaudit
- pgvector
- postgis

## Usage

To use as-is, simply use the package repo name:

```yaml
# docker-compose.yml
volumes:
  db-data:

services:
  db:
    image: ghcr.io/kvdomingo/postgresql-pig:${PG_VERSION}
  environment:
    POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
  volumes:
    - db-data:/var/lib/postgresql
  ports:
    - '5432:5432'
  # optional block if extension is required to be in shared_preload_libraries
  command:
    - postgres
    - -c
    - shared_preload_libraries=pg_stat_statements,pg_duckdb
```

```shell
# CLI
docker run --rm -p 5432:5432 -e POSTGRES_PASSWORD=${POSTGRES_PASSWORD} ghcr.io/kvdomingo/postgresql-pig:${PG_VERSION}
```

To install additional extensions, extend with a custom Dockerfile:

```dockerfile
FROM ghcr.io/kvdomingo/postgresql-pig:${PG_VERSION}

# switch to root to install packages
USER root

# install all extensions you need
# ref: https://ext.pigsty.io
RUN apt-get update && \
    pig install pg_duckdb postgis timescaledb -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# switch back to non-root user
USER 999
```

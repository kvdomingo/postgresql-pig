# PostgreSQL-Pig

PostgreSQL Docker image (Debian Bookworm) with
[Pig CLI](https://github.com/pgsty/pig). Built for `linux/amd64` and
`linux/arm64`. Default PostgreSQL version: 18.

## Pre-installed extensions

- **Statistics / monitoring:** pg_stat_statements, pg_stat_monitor,
  pg_stat_kcache, pg_wait_sampling, pg_qualstats, pg_show_plans, powa
- **Audit / security:** pgaudit, pg_auth_mon, pgextwlist, set_user
- **Data types / search:** pgvector, postgis, hstore, rum, pg_idkit
- **Replication / ETL:** wal2json, postgres_fdw
- **Utilities:** pg_cron, pg_repack, pg_hint_plan, hypopg, logerrors, pg_net,
  anon, citus, hll, pgcrypto, plpython3u, timescaledb, topn

## Usage

Minimal `docker-compose.yml`:

```yaml
volumes:
  db-data:

services:
  db:
    image: ghcr.io/kvdomingo/postgresql-pig:${PG_VERSION:-18}
    environment:
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    volumes:
      - db-data:/var/lib/postgresql
    ports:
      - '5432:5432'
    # optional: load extensions that require shared_preload_libraries
    command:
      - postgres
      - -c
      - shared_preload_libraries=pg_stat_statements,pg_stat_monitor
```

CLI:

```shell
docker run --rm -p 5432:5432 -e POSTGRES_PASSWORD=${POSTGRES_PASSWORD} ghcr.io/kvdomingo/postgresql-pig:${PG_VERSION:-18}
```

## Adding more extensions

To install extensions not included in the image, extend with a custom Dockerfile
and [Pig ext](https://ext.pigsty.io):

```dockerfile
FROM ghcr.io/kvdomingo/postgresql-pig:${PG_VERSION:-18}

USER root

RUN apt-get update && \
    pig install pg_duckdb -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER 999
```

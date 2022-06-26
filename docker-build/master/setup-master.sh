#!/bin/bash

echo "host replication all 0.0.0.0/0 trust" >> "$PGDATA/pg_hba.conf"
set -e
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
CREATE USER $POSTGRES_REP_USER REPLICATION LOGIN CONNECTION LIMIT 100 ENCRYPTED PASSWORD '$POSTGRES_REP_PASSWORD';
GRANT EXECUTE ON FUNCTION pg_read_binary_file(text) TO $POSTGRES_REP_USER;
CREATE USER postgres;
EOSQL

mkdir -p $PGDATA/pg_log

echo "primary_conninfo = 'host=${POSTGRES_MASTER} port=5432 user=$POSTGRES_REP_USER password=$POSTGRES_REP_PASSWORD'" > ${PGDATA}/postgresql.conf

cat ./my_postgresql.conf >> ${PGDATA}/postgresql.conf

EOF
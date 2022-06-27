#!/bin/bash

if [ ! -s "$PGDATA/PG_VERSION" ]; then

	echo "*:*:*:$POSTGRES_REP_USER:$POSTGRES_REP_PASSWORD" > ~/.pgpass
	chmod 0600 ~/.pgpass

	until ping -c 1 -W 1 ${POSTGRES_MASTER}
	do
		sleep 1s
	done

	su postgres
	rm -rf ${PGDATA}/*

	until pg_basebackup -h ${POSTGRES_MASTER} -D ${PGDATA} -U ${POSTGRES_REP_USER} -X stream -P
	do
		sleep 1s
	done
	echo "host replication all 0.0.0.0/0 md5" >> "$PGDATA/pg_hba.conf"

	set -e
	mkdir -p $PGDATA/pg_log

	echo "primary_conninfo = 'host=${POSTGRES_MASTER} port=5432 user=$POSTGRES_REP_USER password=$POSTGRES_REP_PASSWORD'" > ${PGDATA}/postgresql.conf

	cat ./my_postgresql.conf >> ${PGDATA}/postgresql.conf

	chown postgres. ${PGDATA} -R
	chmod 700 ${PGDATA} -R
fi

if [ ! -z $PG_STANDBY ]; then
	su postgres -c "touch $PGDATA/standby.signal"
fi

if [ -s "$PGDATA/PG_VERSION" ] && [ ! -z $PG_REWIND ] && [ ! -z $PG_STANDBY ]; then
	su postgres -c "pg_rewind --target-pgdata=$PGDATA --source-server='host=${POSTGRES_MASTER} port=5432 dbname=$POSTGRES_DB user=$POSTGRES_USER password=$POSTGRES_PASSWORD'"
fi

sed -i 's/wal_level = hot_standby/wal_level = replica/g' ${PGDATA}/postgresql.conf
exec "$@"
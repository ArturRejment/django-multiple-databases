# django-multiple-databases
A project, where Django application uses three different PostgreSQL databases.
First database `master` is source database where data is written.
Second database `slave1` is replicated from master database. This database is read-only.
Thrid database `auth_db` is for authentication. It stores users and jwt.

# Run application

1. Create docker network
```
docker network create databases-network
```

2. Build and run
```
docker-compose up --build -d
```

## Problems

- CRLF End of Line sequence instead of LF
- Volume for master database named master-data: could not find config file
- Problems with postgres:13 image: unrecognized configuration parameter "wal_keep_segments" in file
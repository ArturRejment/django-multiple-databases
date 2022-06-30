# Django using multiple databases and Postgres database replication
A project, where Django application uses three different PostgreSQL databases. <br>
First database `auth_db` is for authentication. It stores users and jwt. <br>
Second database `master` is source database where data is written. It stores all other models. <br>
Third database `slave_1` is a real-time replica of master database. This database is read-only. <br>
For querying models related with authentication, Django will refer to auth_db database for both writing and reading records. <br>
For querying all others models, Django will refer to master or slave_1 database. If we are going to save some values to the database, Django will write them to the `master` database. Automatically, master database will be replicated to slave_1 database. If we are going to read from database, Django will refer to the slave_1 database.

This database replication approach provides higher availability, reliability and performance.

# Run application

### 1. Create docker network
```
docker network create databases-network
```

### 2. Create and fill .env files
Find two `env-template` files. First is in the main directory, second is in `project/env/` directory. <br>
In these directories create `.env` (First in main directory and second in /project/env/). <br>
Paste there variables from matching `env-template` and fill values for all variables. <br>
<b> Passwords for databases in both .env should match each other! </b>

### 3. EoL sequence encoding
Check, if all .sh files have EoL sequence set to LF.

### 3. Build and run
```
docker-compose up --build -d
```

### 4. Migrate database
Run bash in `django-app` container executing this command in terminal:
```bash
docker exec -it django-app /bin/bash
```
and migrate databases with
```bash
python manage.py migrate --database=auth_db
python manage.py migrate --database=master
```

## Problems

- CRLF End of Line sequence instead of LF
  - After cloning this repo, make sure that all .sh files in docker-build directory have EoL sequence set to LF. Different configuration (CRLF) may cause some problems while building the project.
- Volume for master database named master-data: could not find config file
- Problems with postgres:13 image: unrecognized configuration parameter "wal_keep_segments" in file
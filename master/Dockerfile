FROM postgres:12.5

RUN chmod 777 /tmp
RUN chmod 777 /var

RUN apt-get update \
    && apt-get --assume-yes install iputils-ping \
    && apt-get install --assume-yes ssh \
    && apt-get install --assume-yes gosu

COPY ./setup-master.sh /docker-entrypoint-initdb.d/setup-master.sh
RUN chmod 777 /docker-entrypoint-initdb.d/setup-master.sh

COPY ./setup-entry.sh /setup-entry.sh
RUN chmod 777 /setup-entry.sh

COPY ./my_postgresql.conf /my_postgresql.conf
RUN chmod 777 /my_postgresql.conf

CMD ["./setup-entry.sh"]
FROM postgres:12.5

RUN chmod 777 /tmp
RUN apt-get update \
    && apt-get --assume-yes install iputils-ping \
    && apt-get install --assume-yes ssh \
    && apt-get install --assume-yes gosu

COPY ./setup-slave.sh /setup-slave.sh
RUN chmod +x /setup-slave.sh

COPY ./my_postgresql.conf /my_postgresql.conf
RUN chmod 777 /tmp

ENTRYPOINT ["/setup-slave.sh"]

CMD ["gosu","postgres","postgres"]
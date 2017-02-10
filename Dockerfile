FROM amancevice/pandas:0.18.1-python3

RUN pip3 install -U pip

# Install
ENV SUPERSET_VERSION 0.15.4
RUN apk add --no-cache \
        curl \
        libffi-dev \
        cyrus-sasl-dev \
        mariadb-dev \
        postgresql-dev \
	unixodbc \
	unixodbc-dev \
	freetds-dev \
	git && \
    pip3 install \
        mysqlclient==1.3.7 \
        ldap3==2.1.1 \
        psycopg2==2.6.1 \
        redis==2.10.5 \
        sqlalchemy-redshift==0.5.0 \
	boto3==1.4.4 \
        celery==3.1.23 \
        cryptography==1.5.3 \
        flask-appbuilder==1.8.1 \
        flask-cache==0.13.1 \
        flask-migrate==1.5.1 \
        flask-script==2.0.5 \
        flask-testing==0.5.0 \
        flask-sqlalchemy==2.0 \
        humanize==0.5.1 \
        gunicorn==19.6.0 \
        markdown==2.6.6 \
        parsedatetime==2.0.0 \
        pydruid==0.3.1 \
        PyHive>=0.2.1 \
        python-dateutil==2.5.3 \
        requests==2.10.0 \
        simplejson==3.8.2 \
        six==1.10.0 \
        sqlalchemy==1.0.13 \
        sqlalchemy-utils==0.32.7  \
        sqlparse==0.1.19 \
        thrift>=0.9.3 \
        thrift-sasl>=0.2.1 \
        werkzeug==0.11.10

RUN git clone  https://github.com/davsklaus/superset.git tmp_superset && \
    cd tmp_superset && \
    python3 setup.py build && \
    python3 setup.py install && \
    cd ..  \
    rm -r tmp_superset

# Default config
ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    PATH=$PATH:/home/superset/.bin \
    PYTHONPATH=/home/superset/superset_config.py:$PYTHONPATH

# Run as superset user
WORKDIR /home/superset
COPY superset .
RUN addgroup superset && \
    adduser -h /home/superset -G superset -D superset && \
    chown -R superset:superset /home/superset
USER superset

# Deploy
EXPOSE 8088
HEALTHCHECK CMD ["curl", "-f", "http://localhost:8088/health"]
ENTRYPOINT ["superset"]
CMD ["runserver"]

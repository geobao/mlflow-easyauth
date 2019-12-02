FROM debian:buster-slim

# pandas installed from Debian repos to avoid building C extensions
RUN set -x \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y \
    python3 python3-pip python3-setuptools python3-pandas supervisor nginx apache2-utils \
    && pip3 install wheel \
    && pip3 install google-cloud-storage mlflow \
    && apt-get remove --purge --auto-remove -y ca-certificates && rm -rf /var/lib/apt/lists/*


# WWW (nginx)
RUN addgroup -gid 1000 www \
    && adduser -uid 1000 -H -D -s /bin/sh -G www www


COPY nginx.conf /etc/nginx/nginx.conf

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./entry-point.sh /app/entry-point.sh

COPY ./webserver.sh /app/webserver.sh
COPY ./mlflow.sh /app/mlflow.sh

CMD ["/bin/bash", "/app/entry-point.sh"]

EXPOSE 80
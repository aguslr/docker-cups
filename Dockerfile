FROM docker.io/debian:stable-slim

ARG BUILD_DATE
ARG BUILD_VERSION=unspecified
LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.build-date=${BUILD_DATE}
LABEL org.label-schema.version=${BUILD_VERSION}

RUN \
  apt-get update && \
  env DEBIAN_FRONTEND=noninteractive \
  apt-get install -y --no-install-recommends cups ipp-usb \
  -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
  && apt-get install -y printer-driver-all \
  -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /var/lib/apt/lists/*

RUN \
  sed -i '/Log /s/\/var\/log\/cups\/.*$/stderr/' /etc/cups/cups-files.conf

COPY entrypoint.sh /entrypoint.sh

ENV CUPS_USER=admin CUPS_PASS=admin

EXPOSE 631/tcp 631/udp

VOLUME /dev/bus/usb /run/dbus /opt/drivers

HEALTHCHECK --interval=1m --timeout=3s \
  CMD timeout 2 bash -c 'cat < /dev/null > /dev/tcp/127.0.0.1/631'

ENTRYPOINT ["/entrypoint.sh"]
CMD ["-f"]

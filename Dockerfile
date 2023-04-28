ARG BASE_IMAGE=library/debian:bullseye-slim

FROM docker.io/${BASE_IMAGE}

RUN \
  apt-get update && \
  env DEBIAN_FRONTEND=noninteractive \
  apt-get install -y --no-install-recommends cups ipp-usb \
  -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
  && apt-get install -y printer-driver-all \
  -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /var/lib/apt/lists/*

RUN \
  sed -i '/Log /s/\/var\/log\/cups\/.*$/stderr/' /etc/cups/cups-files.conf && \
  sed -i \
  -e 's/LogLevel .*/LogLevel debug/' \
  -e 's/Listen localhost:631/Listen 0.0.0.0:631/' \
  -e 's/Browsing Off/Browsing On/' \
  -e 's,</Location>,  Allow all\n</Location>,' /etc/cups/cupsd.conf; \
  printf '\nServerAlias *\nDefaultEncryption IfRequested\n' >> /etc/cups/cupsd.conf

COPY entrypoint.sh /entrypoint.sh

ENV CUPS_USER=admin CUPS_PASS=admin

EXPOSE 631/tcp 631/udp

VOLUME /dev/bus/usb /run/dbus /opt/drivers

HEALTHCHECK --interval=1m --timeout=3s \
  CMD timeout 2 bash -c 'cat < /dev/null > /dev/tcp/127.0.0.1/631'

ENTRYPOINT ["/entrypoint.sh"]
CMD ["-f"]

[aguslr/docker-cups][1]
=======================

[![docker-pulls](https://img.shields.io/docker/pulls/aguslr/cups)](https://hub.docker.com/r/aguslr/cups) [![image-size](https://img.shields.io/docker/image-size/aguslr/cups/latest)](https://hub.docker.com/r/aguslr/cups)


This *Docker* image sets up *CUPS* inside a docker container.

> **[CUPS][2]** is a modular printing system for Unix-like computer operating
> systems which allows a computer to act as a print server.


Installation
------------

To use *docker-cups*, follow these steps:

1. Download your printer drivers in *DEB* format into a directory named
   `./drivers`.

2. Clone and start the container:

       docker run --privileged -p 631:631 \
         -e CUPS_USER=admin \
         -e CUPS_PASS=admin \
         -v /dev/bus/usb:/dev/bus/usb \
         -v /run/dbus:/run/dbus \
         -v "${PWD}"/drivers:/opt/drivers \
         docker.io/aguslr/cups:latest

3. Open <http://127.0.0.1:631> with your web browser to access CUPS.


### Variables

The image is configured using environment variables passed at runtime. All these
variables are prefixed by `CUPS_`.

| Variable | Function              | Default       | Required |
| :------- | :-------------------- | :------------ | -------- |
| `USER`   | Username of CUPS user | `admin`       | N        |
| `PASS`   | Password of CUPS user | autogenerated | N        |

To see the default autogenerated password, check the log for the container:

    docker logs <container_name> | grep '^Password'


Build locally
-------------

Instead of pulling the image from a remote repository, you can build it locally:

1. Clone the repository:

       git clone https://github.com/aguslr/docker-cups.git

2. Change into the newly created directory and use `docker-compose` to build and
   launch the container:

       cd docker-cups && docker-compose up --build -d


[1]: https://github.com/aguslr/docker-cups
[2]: https://www.cups.org/

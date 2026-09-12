#!/bin/sh

# Install drivers
if find /opt/drivers -type f -name '*.deb' 2>/dev/null | grep -q . ; then
	dpkg -i /opt/drivers/*.deb || {
		apt-get update && \
		env DEBIAN_FRONTEND=noninteractive \
		apt-get install -y --fix-broken --no-install-recommends \
		-o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold"
		apt-get clean && rm -rf /var/lib/apt/lists/* /var/lib/apt/lists/*
	}
fi

# Create CUPS user
if [ "${CUPS_USER:=admin}" ] && ! grep -q -s "^${CUPS_USER}" /etc/passwd; then
	# Add user to system
	useradd -g lpadmin "${CUPS_USER}"
	# Generate random password
	if [ -z "${CUPS_PASS}" ]; then
		CUPS_PASS="$(date +%s | sha256sum | base64 | head -c 32)" && \
			printf 'Password for %s is %s\n' "${CUPS_USER}" "${CUPS_PASS}"
	fi
	# Set password
	printf '%s:%s\n' "${CUPS_USER}" "${CUPS_PASS}" | chpasswd
fi

# Launch UDEV
/lib/systemd/systemd-udevd --daemon

# Start CUPS
/usr/sbin/cupsd "$@"

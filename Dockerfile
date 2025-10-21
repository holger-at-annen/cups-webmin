FROM ubuntu:22.04

# Set non-interactive frontend to avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install basic dependencies and D-Bus
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y wget perl libnet-ssleay-perl libauthen-pam-perl libio-pty-perl apt-show-versions dbus && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Webmin with retry
RUN apt-get update && \
    wget --tries=3 --timeout=10 https://prdownloads.sourceforge.net/webmin/webmin_2.111_all.deb || \
    wget --tries=3 --timeout=10 https://sourceforge.net/projects/webadmin/files/webmin/2.111/webmin_2.111_all.deb && \
    dpkg -i webmin_2.111_all.deb || apt-get install -f -y && \
    rm webmin_2.111_all.deb && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install CUPS and dependencies
RUN apt-get update && \
    apt-get install -y cups cups-client cups-bsd cups-filters printer-driver-all && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Ensure D-Bus is running for CUPS
RUN mkdir -p /var/run/dbus && chown messagebus:messagebus /var/run/dbus

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose Webmin port
EXPOSE 10000

# Use entrypoint
ENTRYPOINT ["/entrypoint.sh"]

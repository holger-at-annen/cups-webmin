FROM ubuntu:22.04

# Set non-interactive frontend to avoid prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies, Webmin, and CUPS
RUN apt-get update && \
    apt-get install -y wget perl libnet-ssleay-perl libauthen-pam-perl libio-pty-perl apt-show-versions && \
    wget https://prdownloads.sourceforge.net/webmin/webmin_2.111_all.deb && \
    dpkg -i webmin_2.111_all.deb || apt-get install -f -y && \
    apt-get install -y cups cups-client cups-bsd cups-filters && \
    rm webmin_2.111_all.deb && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Expose Webmin port
EXPOSE 10000

# Start Webmin
CMD ["/usr/sbin/service", "webmin", "start"] && ["/usr/sbin/service", "cups", "start"] && tail -f /var/webmin/miniserv.log

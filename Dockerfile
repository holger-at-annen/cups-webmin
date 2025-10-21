FROM ubuntu:22.04

# Set non-interactive frontend to avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update and install basic dependencies
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y wget perl libnet-ssleay-perl libauthen-pam-perl libio-pty-perl apt-show-versions && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Download and install Webmin with retry
RUN wget --tries=3 --timeout=10 https://prdownloads.sourceforge.net/webmin/webmin_2.111_all.deb || \
    wget --tries=3 --timeout=10 https://sourceforge.net/projects/webadmin/files/webmin/2.111/webmin_2.111_all.deb && \
    dpkg -i webmin_2.111_all.deb || apt-get install -f -y && \
    rm webmin_2.111_all.deb && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Install CUPS and related packages
RUN apt-get update && \
    apt-get install -y cups cups-client cups-bsd cups-filters && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Expose Webmin port
EXPOSE 10000

# Start Webmin and CUPS
CMD ["/usr/sbin/service", "webmin", "start"] && ["/usr/sbin/service", "cups", "start"] && tail -f /var/webmin/miniserv.log

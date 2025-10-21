#!/bin/bash

# Set admin password if provided
if [ -n "$WEBMIN_ADMIN_PASSWORD" ]; then
  echo "Setting Webmin admin password..."
  /usr/libexec/webmin/changepass.pl /etc/webmin admin "$WEBMIN_ADMIN_PASSWORD"
elif [ -f "$WEBMIN_ADMIN_PASSWORD_FILE" ]; then
  echo "Setting Webmin admin password from secret..."
  WEBMIN_ADMIN_PASSWORD=$(cat "$WEBMIN_ADMIN_PASSWORD_FILE")
  /usr/libexec/webmin/changepass.pl /etc/webmin admin "$WEBMIN_ADMIN_PASSWORD"
else
  echo "Warning: WEBMIN_ADMIN_PASSWORD not set, using default credentials"
fi

# Start Webmin and CUPS
/usr/sbin/service webmin start
/usr/sbin/service cups start

# Keep container running
tail -f /var/webmin/miniserv.log

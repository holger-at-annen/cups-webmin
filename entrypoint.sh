#!/bin/bash

# Start D-Bus (required for CUPS)
echo "Starting D-Bus..."
/usr/bin/dbus-daemon --system --fork

# Start CUPS
echo "Starting CUPS..."
/usr/sbin/cupsd
if [ $? -ne 0 ]; then
  echo "CUPS failed to start. Checking logs..."
  cat /var/log/cups/error_log || echo "No CUPS log found"
  exit 1
fi

# Start Webmin
echo "Starting Webmin..."
/usr/sbin/service webmin start
if [ $? -ne 0 ]; then
  echo "Webmin failed to start. Checking logs..."
  cat /var/webmin/miniserv.error || echo "No Webmin log found"
  exit 1
fi

# Set admin password if provided
if [ -n "$WEBMIN_ADMIN_PASSWORD" ]; then
  echo "Setting Webmin admin password..."
  /usr/share/webmin/changepass.pl /etc/webmin admin "$WEBMIN_ADMIN_PASSWORD"
  if [ $? -ne 0 ]; then
    echo "Failed to set Webmin password. Check /usr/share/webmin/changepass.pl"
    exit 1
  fi
elif [ -f "$WEBMIN_ADMIN_PASSWORD_FILE" ]; then
  echo "Setting Webmin admin password from secret..."
  WEBMIN_ADMIN_PASSWORD=$(cat "$WEBMIN_ADMIN_PASSWORD_FILE")
  /usr/share/webmin/changepass.pl /etc/webmin admin "$WEBMIN_ADMIN_PASSWORD"
  if [ $? -ne 0 ]; then
    echo "Failed to set Webmin password from secret."
    exit 1
  fi
else
  echo "Warning: WEBMIN_ADMIN_PASSWORD not set, using default credentials"
fi

# Keep container running
exec tail -f /var/webmin/miniserv.log

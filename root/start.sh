/usr/bin/dbus-daemon --system --nopidfile --fork &
/usr/sbin/avahi-daemon -D &
/usr/sbin/cupsd -f &
# optional
#/usr/sbin/ipp-usb &
 
# main container command
/usr/bin/tail -f /dev/null

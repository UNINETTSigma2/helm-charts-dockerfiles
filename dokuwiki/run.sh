#!/bin/sh

echo "\$conf['baseurl']     = '$DOKUWIKI_BASE_URL';" >> /dokuwiki/conf/local.php
/usr/sbin/lighttpd -D -f /etc/lighttpd/lighttpd.conf

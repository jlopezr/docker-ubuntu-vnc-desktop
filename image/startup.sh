#!/bin/bash

mkdir -p /var/run/sshd

chown -R root:root /root
mkdir -p /root/.config/pcmanfm/LXDE/
cp /usr/share/doro-lxde-wallpapers/desktop-items-0.conf /root/.config/pcmanfm/LXDE/

if [ -n "$VNC_PASSWORD" ]; then
    echo -n "$VNC_PASSWORD" > /.password1
    x11vnc -storepasswd $(cat /.password1) /.password2
    chmod 400 /.password*
    sed -i 's/^command=x11vnc.*/& -rfbauth \/.password2/' /etc/supervisor/conf.d/supervisord.conf
    export VNC_PASSWORD=
fi

if [ -n "$RESOLUTION" ]; then
    #cat /etc/supervisor/conf.d/supervisord.conf | sed 's/^command=\/usr\/bin\/Xvfb.*/command=\/usr\/bin\/Xvfb :1 -screen 0 '"$RESOLUTION"'/' > /etc/supervisor/conf.d/supervisor.conf.2
    sed -i 's/^command=\/usr\/bin\/Xvfb.*/command=\/usr\/bin\/Xvfb :1 -screen 0 '"$RESOLUTION"'/' /etc/supervisor/conf.d/supervisord.conf
fi

echo "127.0.0.1   dmi.local.downjones.com" >> /etc/hosts
echo "127.0.0.1   utilities.factiva.com" >> /etc/hosts

tar xzf /usr/share/intellij/dotIntelliJ.tar.gz -C /root
#tar xzf /usr/share/intellij/idea-config.tgz -C /root

cd /usr/lib/web && ./run.py > /var/log/web.log 2>&1 &
nginx -c /etc/nginx/nginx.conf
exec /bin/tini -- /usr/bin/supervisord -n

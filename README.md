docker-ubuntu-vnc-desktop
=========================

[![Docker Pulls](https://img.shields.io/docker/pulls/dorowu/ubuntu-desktop-lxde-vnc.svg)](https://hub.docker.com/r/dorowu/ubuntu-desktop-lxde-vnc/)
[![Docker Stars](https://img.shields.io/docker/stars/dorowu/ubuntu-desktop-lxde-vnc.svg)](https://hub.docker.com/r/dorowu/ubuntu-desktop-lxde-vnc/)

Docker image to provide HTML5 VNC interface to access Ubuntu 16.04 LXDE desktop environment.


Quick Start
-------------------------

```
./build.sh        # <---- crear la imagen de docker. solo la primera vez
./start.sh        # <---- iniciar la imagen
```

Ahora nos conectamos con un cliente VNC (p.e [RealVNC](https://www.realvnc.com/en/connect/download/viewer/)) o directamente desde el navegador `http://localhost:6080`.

Una vez dentro del contenedor podemos montar el directorio encriptado. En la maquina host lo encontraremos (encriptado) dentro de la
carpeta `data` situada en la misma carpeta que el `Dockerfile`.

```
mount-secure.sh     # <---- la primera vez seleccionamos opciones por defecto y ponemos el password que queramos.
                    #       las veces siguientes unicamente nos pedira el password.
umount-secure.sh    # <---- si necesitamos desmontar el directorio encriptado.
```

Una vez hecho esto veremos en la carpeta `/secure` los archivos desencriptados. La carpeta data del host tambien la veremos montada en
`/data`, aunque aqui no deberiamos tocar nada porque esta encriptada.

Quick Start
-------------------------

Run the docker image and open port `6080`

```
docker run -it --rm -p 6080:80 dorowu/ubuntu-desktop-lxde-vnc
```

Browse http://127.0.0.1:6080/

<img src="https://raw.github.com/fcwu/docker-ubuntu-vnc-desktop/master/screenshots/lxde.png?v1" width=700/>


Connect with VNC Viewer and protect by VNC Password
------------------

Forward VNC service port 5900 to host by

```
docker run -it --rm -p 6080:80 -p 5900:5900 dorowu/ubuntu-desktop-lxde-vnc
```

Now, open the vnc viewer and connect to port 5900. If you would like to protect vnc service by password, set environment variable `VNC_PASSWORD`, for example

```
docker run -it --rm -p 6080:80 -p 5900:5900 -e VNC_PASSWORD=mypassword dorowu/ubuntu-desktop-lxde-vnc
```

A prompt will ask password either in the browser or vnc viewer.


Troubleshooting and FAQ
==================

1. boot2docker connection issue, https://github.com/fcwu/docker-ubuntu-vnc-desktop/issues/2
2. Screen resolution is fitted to browser's window size when first connecting to the desktop. If you would like to change resolution, you have to re-create the container


License
==================

See the LICENSE file for details.

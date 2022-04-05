# Configuracion de un buen servidor linux

## 1. Introduccion

En esta breve guía para linux veremos como instalar y configurar un servidor web junto con apache y mysql, también la configuración de ip estática y montar discos externos

## 2. Primeros comandos

Es importante antes de comenzar asegurarse de tener todos los paquetes actualizados 👍

```
sudo apt list --upgradable
```

```
sudo apt upgrade
```

```
sudo apt update
```

Una vez ejecutado estos comandos podremos dar comienzo 🚀

## 3. Configurar ip estatica

Para un buen servidor siempre es importante tener una ip estatica no??

### 3.1. Que ip tengo?

Utilizando el siguiente comando podras ver tu ip actual como se muestra en la imagen (En este caso yo ya tengo una ip estática y estoy conectado por wifi)
```
ifconfig
```
![image](https://user-images.githubusercontent.com/81438736/161845383-b6fd2a8b-8a2b-4951-a9da-7a111ab0c09a.png)

### 3.2. Cambiar ip

Bien para conseguir esta ip estatica deveremos configurar el archivo:
```
sudo nano /etc/netplan/00-installer-config.yaml
```
*(Puede tener otro nombre en tu equipo, pero la misma direccion.)*

#### El archivo que encontraremos sear algo asi
```
# This is the network config written by 'subiquity'
network:
  ethernets:
    enp1s0:
      dhcp4: no
      addresses: [192.168.1.25/24]
      gateway4: 192.168.1.201
      nameservers:
        addresses: [200.40.30.245, 8.8.8.8]
  version: 2
```


- dhcp4: Iria en no para desactivarlo, si lo colocamos en 'true' está activado.
- addresses: Sería la ip de tu equipo actual.
- gateway4: La puerta de enlace predeterminado.
- nameservers: Lista de DNS.

### 3.3. Importante❗❗

Una vez echo todo lo anterior tendras que ejecutar el siguiente comando para actualizar la configuracion de red.
```
sudo netplan apply
```
**Asegúrate de poder volver a conectarte luego si estás en una conexión SSH**

# 4. Configurar claves RSA para la conexión SSH (Opcional)

Para agregar aun más seguridad a ti conexión ssh es necesario agregar claves RSA, para esto veremos como generar estas claves e instalarlas en cualquier equipo, también como desactivar la autentificación por contraseña por ssh

### 4.1 Generar el par de claves 🔐

Para esto usaremos el siguiente comando (Por defecto se generarn en `~/.ssh/id_rsa` a no ser especifiques otra ruta).
```
sudo ssh-keygen
```

Una vez tengas las claves generadas es nesesario agregar una a 




##########################################################################
### Instalar apache2

sudo apt install apache2

##########################################################################
### Instalar mysql

sudo apt install mysql-server
sudo mysql_secure_installation

# Configurar usuario root de mysql con nueva contraseña


##########################################################################
### Instalar php para apache2

sudo apt install php libapache2-mod-php
sudo systemctl restart apache2


##########################################################################
### Configura laptop para cuando cierres la tapa no se suspenda
# sudo nano /etc/systemd/logind.conf
# HandleLidSwitch=ignore




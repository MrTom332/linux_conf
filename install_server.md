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
      dhcp4: true
  version: 2
```

#### Tendria que quedar asi
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

**Asegúrate de poder volver a conectarte luego si estás en una conexión SSH**

```
sudo netplan apply
```

# 4. Configurar claves RSA para la conexión SSH (Opcional)

Para agregar aun más seguridad a ti conexión ssh es necesario agregar claves RSA, para esto veremos como generar estas claves e instalarlas en cualquier equipo, también como desactivar la autentificación por contraseña por ssh

### 4.1. Generar el par de claves 🔐

Para esto usaremos el siguiente comando (Por defecto se generarn en `~/.ssh/id_rsa` a no ser especifiques otra ruta).
```
sudo ssh-keygen
```

Una vez las tengas generadas es necesario agregar la clave '*.pub' al archivo '~/.ssh/authorized_keys' si no existe créalo.

```
sudo echo public_key_string >> ~/.ssh/authorized_keys
```

o

```
sudo cat id_rsa.pub >> ~/.ssh/authorized_keys
```

Con esto ya agregaste la clave a la lista de claves autorizadas!

**Importante!**

Recuerda que si estás en el usuario root y estás configurando este acceso para un usuario en específico la carpeta '~/.ssh' debe tener el conjunto de permisos apropiados y pertenecer al usuario en cuestión.

```
sudo chmod -R go= ~/.ssh
sudo chown -R username:username ~/.ssh
```

### 4.2. Ahora como ingresamos desde otro equipo con esta clave ❓

El otro archivo `~/.ssh/id_rsa` devemos copiarlo al equipo en cuestion que se quiera conectar a nuestro servidor.

- Si estas en Linux es importante que el archivo `id_rsa` tenga permisos 400
- Si estás en Windows tendrás que ir a propiedades y en la sección seguridad, deshabilitar la herencia, asignar solo tu usuario a la lista de permitidos y dar control total en la lista de permisos.

##### 4.2.1. PowerShell

Desde aquí es tan sencillo como usar el siguiente comando, recuerda cambiar la ruta por donde se encuentre tu archivo `id_rsa` y listo (Si configuraste alguna contraseña para las claves te la pedirá)

```
ssh -i "ruta\id_rsa" username@ip_servidor
```

##### 4.2.2. Putty y WinSCP

Estas dos aplicaciones aunque muy buenas te pedirán tener una clave '*.ppk', pero tranquilo es muy sencillo conseguir una utilizando el programa 'Putty Key Generator' que ya deberías tener instalado si instalaste 'Putty' o 'WinSCP'.

![image](https://user-images.githubusercontent.com/81438736/161854398-8f849ae0-7870-4464-b2af-b2a44608fd02.png)

Harás clic en el botón load (Recuerda cambiar la búsqueda de archivos a 'All Filles (\*.\*)') y selecciona tu clave 'id_rsa' (Si configuraste alguna contraseña para las claves te la pedirá), por último clic en 'Save private key' puedes llamarla 'id_rsa_putty.ppk' y listo ya tendrás guardada tu clave como .ppk

Para ingresar tu '*.ppk' en **Putty** solo tendrás que ir a ese submenú y buscarla, luego inicia normalmente como siempre.
![image](https://user-images.githubusercontent.com/81438736/161855055-c6f8119c-72df-4cb5-9c53-a84fa8841368.png)

En el caso de **WinSCP** tendrás que ir a 'Avanzado' y luego a 'Autentificación'
![image](https://user-images.githubusercontent.com/81438736/161855176-f7cc9aee-335f-4317-9c46-e0376b949f25.png)

### 4.3. Por último desactivar la autenticación con contraseña de SSH

Utilizando el siguiente comando ingresaremos al archivo de configuración de ssh

```
sudo nano /etc/ssh/sshd_config
```

Una vez dentro tendras que localizar
```
. . .
PasswordAuthentication no
. . .
```
Verifica que la línea no quede comentada con '#' y que diga 'no', para que los cambios surtan efecto deberás resetear el SSH con el siguiente comando

***(Importante: recuerda comprobar en otra terminal poder acceder con tu clave RSA antes de desactivar la autenticación por contraseña)***

```
sudo systemctl restart ssh
```

# 5. Configura laptop para cuando cierres la tapa no se suspenda (Opcional) 💻

En el caso de que tu servidor sea una laptop como es mi caso, es inconveniente tener la pantalla levantada todo el rato, para evitar que el equipo se suspenda si cerramos la tapa tendremos que configurar el siguiente archivo.

```
sudo nano /etc/systemd/logind.conf
```

En él localizaremos la siguiente línea y la estableceremos en 'ignore' recuerda comprobar la línea quede des comentada.

```
HandleLidSwitch=ignore
```

Para aplicar los cambios reinicia tu equipo y listo.






















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






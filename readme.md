# Configuracion de un buen servidor linux


## Indice

1. **[Introduccion](#1-introduccion)**
2. **[Primeros comandos](#2-primeros-comandos)**
   - 2.1. [Cosas importantes que tienes que saber](#21-cosas-importantes-que-tienes-que-saber)
     - 2.1.1. [Permisos](#211-permisos)
     - 2.1.2. [Usuarios y grupos](#212-usuarios-y-grupos)
     - 2.1.3. [Propietario y grupo de un archivo](#213-propietario-y-grupo-de-un-archivo)
3. **[Configurar ip estatica](#3-configurar-ip-estatica)**
   - 3.1. [Que ip tengo?](#31-que-ip-tengo)
   - 3.2. [Cambiar ip](#32-cambiar-ip)
   - 3.3. [Importante鉂梋(#33-importante)
4. **[Configurar claves RSA para la conexi贸n SSH (Opcional)](#4-configurar-claves-rsa-para-la-conexi贸n-ssh-opcional)**
   - 4.1. [Generar el par de claves 馃攼](#41-generar-el-par-de-claves-)
   - 4.2. [Ahora como ingresamos desde otro equipo con esta clave 鉂揮(#42-ahora-como-ingresamos-desde-otro-equipo-con-esta-clave-)
     - 4.2.1. [PowerShell](#421-powershell)
     - 4.2.2. [Putty y WinSCP](#422-putty-y-winscp)
   - 4.3. [Por 煤ltimo desactivar la autenticaci贸n con contrase帽a de SSH](#43-por-煤ltimo-desactivar-la-autenticaci贸n-con-contrase帽a-de-ssh)
5. **[Configura laptop para cuando cierres la tapa no se suspenda (Opcional) 馃捇](#5-configura-laptop-para-cuando-cierres-la-tapa-no-se-suspenda-opcional-)**
6. **[Formateo y montado de unidad externa (Opcional)](#6-formateo-y-montado-de-unidad-externa-opcional)**
   - 6.1. [Como formateo mi disco?](#61-como-formateo-mi-disco)
   - 6.2. [Como montar esta nueva unidad en una carpeta?](#62-como-montar-esta-nueva-unidad-en-una-carpeta)
7. **[Instalar apache2](#7-instalar-apache2)**
   - 7.1. [Logs (OPCIONAL)](#71-logs-opcional)
   - 7.2. [Listado de directorios (OPCIONAL)](#72-listado-de-directorios-opcional)
   - 7.3. [Instalacion y configuracion de ModEvasive (OPCIONAL PERO NO TANTO)](#73-instalacion-y-configuracion-de-modevasive-opcional-pero-no-tanto)
8. **[Instalar mysql 馃捑](#8-instalar-mysql-)**
   - 8.1. [Ajustar autenticaci贸n y privilegios de usuarios (OPCIONAL)](#81-ajustar-autenticaci贸n-y-privilegios-de-usuarios-opcional)
   - 8.2. [Ajustar nivel de validaci贸n de contrase帽a (OPCIONAL)](#82-ajustar-nivel-de-validaci贸n-de-contrase帽a-opcional)
   - 8.3. [Cambiar carpeta de guardado para las bases de datos (OPCIONAL)](#83-cambiar-carpeta-de-guardado-para-las-bases-de-datos-opcional)
9. **[Instalar php para apache2](#9-instalar-php-para-apache2)**
   - 9.1. [Aumentar buffer para archivos de subida y POST (OPCIONAL)](#91-aumentar-buffer-para-archivos-de-subida-y-post-opcional)
10. **[Https 馃攽](#10-https-)**
11. **[Fin 馃憦馃憦馃憦馃帄馃帄馃帄](#11-fin-)**


<!--############################################################################################################-->
<!--############################################################################################################-->
<!--############################################################################################################-->
<!--############################################################################################################-->


## 1. Introduccion

En esta breve (pero no tanto) gu铆a para linux veremos como instalar y configurar un servidor web junto con apache y mysql, tambi茅n la configuraci贸n de ip est谩tica y montar discos externos


[- Volver al indice -](#indice)
<!--############################################################################################################-->
<!--############################################################################################################-->
<!--############################################################################################################-->
<!--############################################################################################################-->


## 2. Primeros comandos

Es importante antes de comenzar asegurarse de tener todos los paquetes actualizados 馃憤

```
sudo apt list --upgradable
```

```
sudo apt upgrade
```

```
sudo apt update
```

Una vez ejecutado estos comandos podremos dar comienzo 馃殌

### 2.1. Cosas importantes que tienes que saber

A continuacion veremos algunos comandos basicos que estaremos usando y algunas otras cosas.

#### 2.1.1. Permisos

Saber reconocer que permisos tiene una carpeta o archivo es tan importante como saber darlos, aqu铆 un breve repaso a este tema.

Para poder ver los permisos de un archivo o directorio debes usar el siguiente comando:

```
ls -l
```

Al comando `ls` normal le agregamos el flag `-l` para ver una lista detallada de todo, tambi茅n podemos agregar `-a` para ver los archivos ocultos

![image](https://user-images.githubusercontent.com/81438736/161981333-b7adbc51-c836-4a72-80cc-1be9232fa17e.png)

Ahora repasemos lo que vemos en esta imagen, como puedes ver resalte con colores lo importante, el primer `-` que est谩 al principio indica que esto es un archivo, si tuvi茅ramos una `d` ser铆a un directorio, los permisos se dividen en conjuntos de 3 que resalte con colores.

- Verde: Los primeros son los permisos del usuario propietario del archivo.
- Naranja: Los siguientes son permisos para el grupo del archivo.
- Amarillo: Por 煤ltimo los permisos para cualquier otra persona.

Definimos los permisos para cada secci贸n con la letra que corresponda o la ausencia de ella, en ese caso colocamos un `-`, el orden siempre es el mismo, primero `r` permisos de lectura, `w` permisos de escritura y por 煤ltimo `x` permisos de ejecuci贸n.

Para cambiar los permisos de un archivo o directorio usamos el siguiente comando:

```
sudo chmod 664 /archivo/en/cuestion
```

(Podemos agregar el flag `-R` para que en el caso de un directorio los permisos se agreguen de forma recursiva a todo su contenido)

Como identificar los n煤meros y saber que conjunto de permisos estamos dando? Muy f谩cil, lo aremos sumando los siguientes n煤meros que te mostrar茅 a continuaci贸n.

- 4 Lectura
- 2 Escritura
- 1 Ejecuci贸n

Sumando estos n煤meros obtendremos toda la lista de permisos combinados, ej. queremos permisos de lectura y escritura pues sumaremos 4 + 2 lo que nos dar谩 6

1. --x
2. -w-
3. -wx
4. r--
5. r-x
6. rw-
7. rwx

#### 2.1.2. Usuarios y grupos

Cuando un usuario nuevo es creado se genera un grupo con su mismo nombre para ese usuario, veamos como crear usuarios, como crear grupos, como asignar grupos a usuarios y como cambiar el usuario propietario y grupo a archivos y directorios.

Para crear un usuario en Linux es tan sencillo como ejecutar el siguiente comando:

```
sudo useradd nombre_usuario
```

Y para eliminar

```
sudo userdel nombre_usuario
```
(Puedes usar el flag `-r` para eliminar el usuario y su directorio home)

Con el comando `su` y seguido el nombre de usuario podremos ingresar a este.

Para modificar la contrase帽a de este nuevo usuario podremos hacerlo de la siguiente forma:

```
sudo passwd nombre_usuario
```

Ahora para crear un nuevo grupo podemos usar el comando:

```
sudo groupadd nombre_grupo
```

Y para eliminar

```
sudo groupdel nombre_grupo
```

Para listar los grupos de un usuario:

```
sudo groups nombre_usuario
```
(Si no se ingresa un nombre de usuario, listara los del actual)


Como agregamos un grupo a un usuario? Con el siguiente comando:

(***Importante!*** Recuerda que agregar o eliminar grupos solo ser谩 efectivo luego de que el usuario cierre e inicie sesi贸n nuevamente)

```
sudo usermod -a -G nombre_grupo nombre_usuario
```
(Se usa el flag `-G` para especificar un grupo secundario si quieras cambiar el grupo principal de un usuario usar铆as `-g`)

Y para eliminar a un usuario de un grupo usamos:

```
sudo gpasswd -d nombre_usuario nombre_grupo
```

#### 2.1.3. Propietario y grupo de un archivo

Los archivos tienen un due帽o y un grupo al cual pertenecen, Como vimos antes, los permisos para estos dos est谩n separados, adem谩s de los permisos para el resto de usuarios, pero como cambiamos al propietario de un archivo, y su grupo

Primero veremos como identificar esto en un archivo o directorio.

![image](https://user-images.githubusercontent.com/81438736/161992786-3c3552a5-d8af-4011-a0da-19335cbf396c.png)

- Verde: Se resalta el usuario propietario del archivo.
- Naranja: Es a que grupo pertenece el archivo.

Utilizando el siguiente comando podremos cambiar ambos o uno solo.

```
sudo chown nombre_usuario:nombre_grupo archivo_en_cuestion
```
(Podemos agregar el flag `-R` para que se apliquen los mismos cambios de manera recursiva a todos los ficheros en el interior si se tratase de un directorio)

En el caso de solo querer cambiar el usuario, pues dejar铆amos la parte de grupo en blanco, tal que as铆:

```
sudo chown nombre_usuario: archivo_en_cuestion
```

Y viceversa para cambiar solo el grupo

[- Volver al indice -](#indice)
<!--############################################################################################################-->
<!--############################################################################################################-->
<!--############################################################################################################-->
<!--############################################################################################################-->



## 3. Configurar ip estatica

Para un buen servidor siempre es importante tener una ip estatica no??

### 3.1. Que ip tengo?

Utilizando el siguiente comando podras ver tu ip actual como se muestra en la imagen (En este caso yo ya tengo una ip est谩tica y estoy conectado por wifi)
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

***El archivo que encontraremos sear algo asi***
```
# This is the network config written by 'subiquity'
network:
  ethernets:
    enp1s0:
      dhcp4: true
  version: 2
```

***Tendria que quedar asi***
```
# This is the network config written by 'subiquity'
network:
  ethernets:
    enp1s0:
      dhcp4: no
      optional: true
      addresses: [192.168.1.25/24]
      gateway4: 192.168.1.201
      nameservers:
        addresses: [200.40.30.245, 8.8.8.8]
  version: 2
```

- dhcp4: Iria en no para desactivarlo, si lo colocamos en `true` est谩 activado.
- addresses: Ser铆a la ip de tu equipo actual.
- gateway4: La puerta de enlace predeterminado.
- nameservers: Lista de DNS.
- optional: Colocamos esta opci贸n en true para que al iniciar el equipo no quede esperando a tener conexi贸n.

### 3.3. Importante鉂?

Una vez echo todo lo anterior tendras que ejecutar el siguiente comando para actualizar la configuracion de red.

**Aseg煤rate de poder volver a conectarte luego si est谩s en una conexi贸n SSH**

```
sudo netplan apply
```

[- Volver al indice -](#indice)
<!--############################################################################################################-->
<!--############################################################################################################-->
<!--############################################################################################################-->
<!--############################################################################################################-->


# 4. Configurar claves RSA para la conexi贸n SSH (Opcional)

Para agregar aun m谩s seguridad a ti conexi贸n ssh es necesario agregar claves RSA, para esto veremos como generar estas claves e instalarlas en cualquier equipo, tambi茅n como desactivar la autentificaci贸n por contrase帽a por ssh

### 4.1. Generar el par de claves 馃攼

Para esto usaremos el siguiente comando (Por defecto se generarn en `~/.ssh/id_rsa` a no ser especifiques otra ruta).
```
sudo ssh-keygen
```

Una vez las tengas generadas es necesario agregar la clave `*.pub` al archivo `~/.ssh/authorized_keys` si no existe cr茅alo.

```
sudo echo public_key_string >> ~/.ssh/authorized_keys
```

o

```
sudo cat id_rsa.pub >> ~/.ssh/authorized_keys
```

Con esto ya agregaste la clave a la lista de claves autorizadas!

**Importante!**

Recuerda que si est谩s en el usuario root y est谩s configurando este acceso para un usuario en espec铆fico la carpeta `~/.ssh` debe tener el conjunto de permisos apropiados y pertenecer al usuario en cuesti贸n.

```
sudo chmod -R go= ~/.ssh
sudo chown -R username:username ~/.ssh
```

### 4.2. Ahora como ingresamos desde otro equipo con esta clave 鉂?

El otro archivo `~/.ssh/id_rsa` devemos copiarlo al equipo en cuestion que se quiera conectar a nuestro servidor.

- Si estas en Linux es importante que el archivo `id_rsa` tenga permisos 400
- Si est谩s en Windows tendr谩s que ir a propiedades y en la secci贸n seguridad, deshabilitar la herencia, asignar solo tu usuario a la lista de permitidos y dar control total en la lista de permisos.

##### 4.2.1. PowerShell

Desde aqu铆 es tan sencillo como usar el siguiente comando, recuerda cambiar la ruta por donde se encuentre tu archivo `id_rsa` y listo (Si configuraste alguna contrase帽a para las claves te la pedir谩)

```
ssh -i "ruta\id_rsa" username@ip_servidor
```

##### 4.2.2. Putty y WinSCP

Estas dos aplicaciones aunque muy buenas te pedir谩n tener una clave `*.ppk`, pero tranquilo es muy sencillo conseguir una utilizando el programa `Putty Key Generator` que ya deber铆as tener instalado si instalaste `Putty` o `WinSCP`.

![image](https://user-images.githubusercontent.com/81438736/161854398-8f849ae0-7870-4464-b2af-b2a44608fd02.png)

Har谩s clic en el bot贸n load (Recuerda cambiar la b煤squeda de archivos a `All Filles (\*.\*)`) y selecciona tu clave `id_rsa` (Si configuraste alguna contrase帽a para las claves te la pedir谩), por 煤ltimo clic en `Save private key` puedes llamarla `id_rsa_putty.ppk` y listo ya tendr谩s guardada tu clave como .ppk

Para ingresar tu `*.ppk` en **Putty** solo tendr谩s que ir a ese submen煤 y buscarla, luego inicia normalmente como siempre.
![image](https://user-images.githubusercontent.com/81438736/161855055-c6f8119c-72df-4cb5-9c53-a84fa8841368.png)

En el caso de **WinSCP** tendr谩s que ir a `Avanzado` y luego a `Autentificaci贸n`
![image](https://user-images.githubusercontent.com/81438736/161855176-f7cc9aee-335f-4317-9c46-e0376b949f25.png)

### 4.3. Por 煤ltimo desactivar la autenticaci贸n con contrase帽a de SSH

Utilizando el siguiente comando ingresaremos al archivo de configuraci贸n de ssh

```
sudo nano /etc/ssh/sshd_config
```

Una vez dentro tendras que localizar
```
. . .
PasswordAuthentication no
. . .
```
Verifica que la l铆nea no quede comentada con `#` y que diga `no`, para que los cambios surtan efecto deber谩s resetear el SSH con el siguiente comando

***(Importante: recuerda comprobar en otra terminal poder acceder con tu clave RSA antes de desactivar la autenticaci贸n por contrase帽a)***

```
sudo systemctl restart ssh
```

[- Volver al indice -](#indice)
<!--############################################################################################################-->
<!--############################################################################################################-->
<!--############################################################################################################-->
<!--############################################################################################################-->


# 5. Configura laptop para cuando cierres la tapa no se suspenda (Opcional) 馃捇

En el caso de que tu servidor sea una laptop como es mi caso, es inconveniente tener la pantalla levantada todo el rato, para evitar que el equipo se suspenda si cerramos la tapa tendremos que configurar el siguiente archivo.

```
sudo nano /etc/systemd/logind.conf
```

En 茅l localizaremos la siguiente l铆nea y la estableceremos en `ignore` recuerda comprobar la l铆nea quede des comentada.

```
HandleLidSwitch=ignore
```

Para aplicar los cambios reinicia tu equipo y listo.



[- Volver al indice -](#indice)
<!--############################################################################################################-->
<!--############################################################################################################-->
<!--############################################################################################################-->
<!--############################################################################################################-->



# 6. Formateo y montado de unidad externa (Opcional)

Un buen servidor siempre debe tener almacenamiento suficiente para la informaci贸n, de preferencia todo en un RAID 1 o superior, pero como hacemos que Linux reconozca este dispositivo que ingresamos? 馃捊

Primero usaremos el comando siguiente para ver la lista de discos y particiones conectadas.

```
sudo fdisk -l
```

![image](https://user-images.githubusercontent.com/81438736/161866415-4855fd6d-123b-46ce-a25c-ecfd6928aa1c.png)


***IMPORTANTE!!***

Debes saber diferenciar cu谩l es la ruta al disco y cu谩l es la partici贸n, en este caso con verde resalte la ruta al disco y con amarillo la partici贸n de este disco. (Si bien puedes guardar informaci贸n en un disco sin particionar no es recomendable).

Tambi茅n es posible que si tu disco es nuevo no tengas creada una particion, por lo que la tabla en amarillo no te saldr铆a.

Si encuentras una tabla de peticiones que tiene varios registros cuidado!, esa probablemente sea la tabla de peticiones del sistema, no debes tocar eso, para los discos externos se genera una nueva tabla en la parte inferior.


### 6.1. Como formateo mi disco?

Primero antes de arrancar es necesario saber si tu disco est谩 montado en alguna carpeta, para esto usaras el comando a continuaci贸n te devolver谩 una lista de rutas de particiones, en que carpetas est谩n montadas y cuanta capacidad del disco ha sido utilizada.

```
sudo df
```

En el caso que tu disco este montado, utiliza el siguiente comando para desmontar la unidad.


```
sudo umount /dev/sdb1
```

Ahora si, para iniciar el particionamiento de nuestro disco, utiliza el siguiente comando. (Comprueba estar particionando tu disco y no una partici贸n)

```
fdisk /dev/sdb
```

Este comando te abrir谩 una interfaz en el que podr谩s interactuar con letras y realizar acciones.

- **p**: Te permitir谩 imprimir en pantalla la tabla de particiones actuales.
- **d**: Te permitir谩 eliminar una partici贸n.
- **n**: Te permitir谩 crear una nueva partici贸n.
- **t**: Te permitir谩 cambiar el tipo de sistema de fichero (C贸digo 83 es el identificador de los sistemas Linux).
- **w**: Para finalizar y guardar los cambios.

El proceso es muy sencillo, si est谩s realizando un disco para guardar informaci贸n, primero elimina todas las particiones con la opci贸n `d`, a continuaci贸n crea una 煤nica partici贸n primaria con `n` (Te saldr谩n algunas preguntas, si das enter dejando todo en blanco se configurara por default), con `t` cambias el tipo de sistema de fichero a 83 y para finalizar `w` para guardar los cambios y salir.

Ahora para poder formatear esta nueva partici贸n que creamos simplemente usamos: (Recuerda colocar la ruta a la partici贸n de tu disco y no al disco en s铆)
```
sudo mkfs.ext4 /dev/sdb1
```

Listo!!

### 6.2. Como montar esta nueva unidad en una carpeta?

Esta es la parte m谩s sencilla, primero seleccionaremos en que carpeta queremos montar nuestra unidad, en mi caso crear茅 una.

```
sudo mkdir /media/discoduro
```

Y ahora para montar el disco simplemente usamos: (Recuerda cambiar las rutas por las que correspondan en tu caso)

```
mount /dev/sdb1 /media/discoduro
```

Puedes comprobar de manera sencilla si el disco quedo montado con el siguiente comando:

```
sudo df
```
![image](https://user-images.githubusercontent.com/81438736/161868903-967346ee-53cd-460b-bcc1-b1bb76a0de41.png)

Fantastico!!

***Importante!!***

Cuando se reinicie nuestro equipo, este disco tendr谩s que volver a montarlo a la misma carpeta, para facilitarnos la vida vamos a ingresar la l铆nea de montado en el archivo **Fstab** del sistema (Este es el archivo de configuraci贸n de Linux en el que se registran las particiones que deben montarse al iniciarse. Por esto si tu equipo arranca y luego le conectas ti dispositivo no se montara autom谩ticamente a no ser que reinicies o lo hagas manualmente)


```
sudo nano /etc/fstab
```

Agregaras al final del archivo

```
/dev/sdb1       /media/discoduro       ext4      rw,nouser,dev,exec,auto 0 0
```

Y listo, al reiniciar el equipo, tu unidad se montar谩 autom谩ticamente al inicio.


[- Volver al indice -](#indice)
<!--############################################################################################################-->
<!--############################################################################################################-->
<!--############################################################################################################-->
<!--############################################################################################################-->



# 7. Instalar apache2

Para que nuestro equipo se transforme en un servidor web echo y derecho necesitamos un programa que nos haga de servidor web, en este caso apache2, tambi茅n instalaremos apache2-utils es un paquete de programas que son 煤tiles para cualquier servidor web.

Para instalarlo simplemente ejecutamos el siguiente comando:

```
sudo apt install apache2 apache2-utils
```

Y listo as铆 de sencillo ya tenemos un servidor web.

### 7.1. Logs (OPCIONAL)

Como puede que sepas apache guarda un registro de cada conexi贸n que recibe y cada error que pueda producirse, es lo que se conoce como archivo log, en el caso de apache estos archivos por default est谩n en `/var/log/apache2/\*`, en s铆 mismo no es un problema dejarlos ac谩, pero si tenemos un servidor que registra muchas peticiones capas es conveniente guardar estos logs en un disco externo, la ruta de los log est谩 en el siguiente archivo:

```
sudo nano /etc/apache2/envvars
```

![image](https://user-images.githubusercontent.com/81438736/161870504-ded60379-1a67-4e16-a766-85c1c34d1c95.png)

Por 煤ltimo recuerda reiniciar apache para aplicar los cambios.
```
sudo systemctl restart apache2
```

### 7.2. Listado de directorios (OPCIONAL)

En la configuraci贸n default de apache, si alguien ingresa a una carpeta desde la web este devolver谩 una lista de todo lo que contiene, en ambiente de producci贸n esto no es nada seguro, as铆 que veamos como desactivarlo.

```
sudo nano /etc/apache2/apache2.conf
```

![image](https://user-images.githubusercontent.com/81438736/161871364-97e12f3f-a2dd-43a5-b14a-8da45ae3db39.png)

Una vez en el archivo de configuraci贸n de apache localizar谩s la secci贸n que dice `<Directory /var/www/&gt;` el contenido de esta carpeta es el que apache expone al puerto 80, en el rengl贸n inferior encontraremos que dir谩 `Options Indexes FollowSymLinks` tendr谩s que borrar `Indexes` para que te quede como en la imagen.

Por 煤ltimo recuerda reiniciar apache para aplicar los cambios.
```
sudo systemctl restart apache2
```

### 7.3. Instalacion y configuracion de ModEvasive (OPCIONAL PERO NO TANTO)

Tener proteccion contra posibles ataque DoS, DDoS y de fuerza bruta nunca esta demas, este m贸dulo creara una tabla hash de direcciones IP y URI con la cual supervisara las solicitudes entrantes al servidor y bloqueara aquellas sospechosas.

Para instalar este m贸dulo ejecutaremos el siguiente comando:

```
sudo apt install libapache2-mod-evasive
```

Durante la instalaci贸n se le pedir谩 que configure un servidor de correo para recibir notificaciones, elijan la opci贸n que desean.

Muy bien, ahora ya puede configurar mod-evasive yendo a su archivo de configuraci贸n.

```
sudo nano /etc/apache2/mods-enabled/evasive.conf
```

![image](https://user-images.githubusercontent.com/81438736/161874115-5fb04662-18de-4b59-8b11-56bc0d680e9e.png)

Aqu铆 puede configurar una ruta para los archivos log y el resto de par谩metros.

- **DOSHashTableSize**: Se especifica el tama帽o de la tabla hash.
- **DOSPageCount**: Cantidad de solicitudes permitidas por segundo de un mismo URI.
- **DOSSiteCount**: Numero maximo de solicitudes permitidas por una Ip.
- **DOSPageInterval**: Intervalo de recuento de p谩guinas.
- **DOSSiteInterval**: Intervalo de recuento de sitios.
- **DOSBlockingPeriod**: Tiempo en segundo que un cliente ser谩 bloqueado.
- **DOSEmailNotify**: Correo electr贸nico al que avisar cuando una Ip sea bloqueada.
- **DOSSystemCommand**: Comando que se ejecutara cuando una Ip sea bloqueada.
- **DOSLogDir**: Directorio para logs.

Por 煤ltimo recuerda reiniciar apache para aplicar los cambios.
```
sudo systemctl restart apache2
```

[- Volver al indice -](#indice)
<!--############################################################################################################-->
<!--############################################################################################################-->
<!--############################################################################################################-->
<!--############################################################################################################-->



# 8. Instalar mysql 馃捑

Todo buen servidor necesitara una base de datos para guardar y gestionar informaci贸n (Puede que tu servidor no lo necesite si solo muestra im谩genes o algo as铆, pero nunca esta dem谩s)

```
sudo apt install mysql-server
```

Una vez instalado pasaremos a ejecutar el siguiente comando para configurarlo

```
sudo mysql_secure_installation
```

Ejecutando esto tendr谩n una serie de preguntas para establecer algunos par谩metros de la instalaci贸n, tan sencillo como seguir los pasos y configurarlo a tu gusto.

### 8.1. Ajustar autenticaci贸n y privilegios de usuarios (OPCIONAL)

Por defecto, el usuario root de MySQL se configura para la autenticaci贸n usando el complemento `auth_socket` y no una contrase帽a, lo que aporta mayor seguridad, pero presenta complicaciones cuando queremos que un programa externo ingrese a este usuario.

Para ingresar como root en MySQL deberemos cambiar su m茅todo de autenticaci贸n de `auth_socket` a otro complemento como `caching_sha2_password` o `mysql_native_password`.

Que elegir? `caching_sha2_password` es la opcion pereferida por MySQL proporciona un cifrado de contrase帽a mas seguro, pero muchas aplicaciones PHP no funcionan de forma fiable con `caching_sha2_password` asi que se recomienda usar `mysql_native_password` si es que trabajas con PHP

Para hacer esto primero entraremos a mysql desde la terminal:

```
sudo mysql
```

Con la siguiente sentencia podremos ver la lista de usuarios y sus plugins

```
SELECT user,authentication_string,plugin,host FROM mysql.user;
```

Y con la siguiente sentencia cambiaremos este plugin y estableceremos una contrase帽a:

```
ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'password';
```

o

```
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
```

Al finalizar ejecuta el siguiente comando para volver a cargar la tabla de permisos y aplicar los nuevos cambios;

```
FLUSH PRIVILEGES;
```

### 8.2. Ajustar nivel de validaci贸n de contrase帽a (OPCIONAL)

Si tienes un servidor mysql local sin salida a la red es posible quieras tener una contrase帽a corta para tu usuario MySQL, un error que puede pasarte al intentar establecer esta contrase帽a es: `ERROR 1819 (HY000): Your password does not satisfy the current policy requirements.` como arreglamos esto? Primero ingresa a mysql

Con la siguiente sentencia podr谩s ver el nivel actual de validaci贸n de contrase帽as

```
SHOW VARIABLES LIKE 'validate_password%';
```

Y con la siguiente sentencia cambiar este nivel a LOW

```
SET GLOBAL validate_password.policy = 0;
```

Si su contrase帽a a煤n no cumple los criterios m铆nimos (No recomiendo hacer esto) pero puede deshabilitar la validaci贸n con la siguiente sentencia (Dentro de MySQL).

```
UNINSTALL COMPONENT "file://component_validate_password";
```

Ahora puede crear su usuario y luego volver a activar el complemento

```
INSTALL COMPONENT "file://component_validate_password";
```

### 8.3. Cambiar carpeta de guardado para las bases de datos (OPCIONAL)

Si usted cuenta con un disco externo de RAID 1 muy probablemente quiera que la informaci贸n sensible como lo son las base de datos se guarden en este, veamos como hacerlo.

Primero que nada detendremos el servicio MySQL y AppArmor si lo tenemos instalado.

AppArmor es un m贸dulo de seguridad del Kernel Linux que permite al administrador del sistema restringir las capacidades de un programa, en conclucion, si queremos que el programa MySQL tenga alcance a su nueva carpeta deberemos ajustar las reglas en AppArmor.

```
sudo systemctl stop mysql
```
```
sudo systemctl stop apparmor
```

Moveremos todos los archivos de MySQL a la nueva ubicaci贸n que deseamos, por defecto los archivos de base de datos de MySQL en Ubuntu est谩n en `/var/lib/mysql/`, una vez tengamos todo en la nueva direcci贸n procederemos a cambiar el nombre a la carpeta original por algo as铆 `/var/lib/mysql_safe` hacemos esto por si fuera necesario regresar a la configuraci贸n anterior luego.

```
sudo cp /var/lib/mysql_safe /nueva/ruta/mysql
```

Es importante que esta nueva carpeta tenga los permisos apropiados y el due帽o sea MySQL

```
sudo chown -R mysql:mysql /nueva/ruta/mysql
```
```
sudo chmod -R 700 /nueva/ruta/mysql
```

En esta nueva carpeta debeos borrar ciertos archivos logs

```
sudo rm /nueva/ruta/mysql/ib_logfile*
```

Ahora iremos al archivo de configuraci贸n de MySQL e indicaremos la nueva ruta:

```
sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
```

![image](https://user-images.githubusercontent.com/81438736/161881065-e813b5a4-a57e-4dea-89f2-fd06aa1294af.png)

Modificaremos 'datadir' con nuestra nueva direcci贸n.

Como mencione antes debemos modificar la configuraci贸n de AppArmor, vamos a editar o crear en caso de que no exista el siguiente archivo:

```
sudo nano /etc/apparmor.d/local/usr.sbin.mysqld
```

Dentro de este pondremos las siguientes l铆neas

```
/nueva/ruta/mysql/ r,
/nueva/ruta/mysql/** rwk,
```

Por 煤ltimo iniciamos AppArmor y MySQL

```
sudo service apparmor start
```
```
sudo systemctl start mysql
```

Si hicimos todo correctamente deber铆a iniciarse sin problemas

[- Volver al indice -](#indice)
<!--############################################################################################################-->
<!--############################################################################################################-->
<!--############################################################################################################-->
<!--############################################################################################################-->



# 9. Instalar php para apache2

En este caso yo soy un fan incondicional de PHP as铆 que para mi servidor usar茅 esto jaja, la instalaci贸n es r谩pida y sencilla

```
sudo apt install php libapache2-mod-php
```

Recuerda es necesario reiniciar apache para que PHP empiece a funcionar

```
sudo systemctl restart apache2
```

Instalar complementos de php para manejar strings
```
sudo apt-get install php-mbstring
```

Instalar complementos de php para usar 'DOMImplementation'
```
sudo apt-get install php-xml
```

Mejore las capacidades de GD para manejar m谩s formatos de imagen especificando la opci贸n de configuraci贸n
```
sudo apt-get install php7.4-gd
```
Verifique su version de php para instalar la versi贸n correcta

Recuerda es necesario reiniciar apache para que PHP empiece a funcionar

```
sudo systemctl restart apache2
```

### 9.1. Aumentar buffer para archivos de subida y POST (OPCIONAL)

Si piensas permitir que se suban archivos a tu servidor a trav茅s de PHP, seguramente con el m谩ximo tama帽o permitido por default te quede un poco corto, as铆 que veamos como solucionar eso. (La idea es entrar a `php.ini puede que tu ruta sea distinta dependiendo la versi贸n de PHP entre otras cosas

```
sudo nano /etc/php/7.4/apache2/php.ini
```

Una vez dentro del archivo de configuraci贸n debemos localizar las siguientes l铆neas:

```
upload_max_filesize = 2M
post_max_size = 8M
```

Si utilizas nano recuerda que con `CRTL + W` podr谩s buscar, las l铆neas no se encuentran juntas sino en secciones separadas del archivo, aumenta el size a lo que te convenga m谩s, importante que `post_max_size` sea siempre un poco mayor que `upload_max_filesize`.

[- Volver al indice -](#indice)
<!--############################################################################################################-->
<!--############################################################################################################-->
<!--############################################################################################################-->
<!--############################################################################################################-->



# 10. Https 馃攽

En la actualidad ya quedan muy pocos servidores que no tengan https y el nuestro no va a ser menos, tener tu propio certificado https para tu dominio es muy sencillo y gratuito gracias a la herramienta certbot, pero como se usa? Esta es la mejor parte en la propia p谩gina de certbot encontrar谩s un instructivo de como se instala y se automatiza, aqu铆 te escribir茅 los puntos importantes y por arriba

Primero que nada necesitar谩s instalar `snapd` es un sistema de implementaci贸n y empaquetado de software desarrollado por Canonical para sistemas operativos que utilizan el kernel de Linux, lo m谩s seguro es que si est谩s utilizando las 煤ltimas versiones de Ubuntu ya venga instalado, es f谩cil de saber ejecutado el siguiente comando.

```
sudo snap --version
```

Si no lo llegas a tener instalado puedes buscar como en su web [-Instalar snapd-](https://snapcraft.io/docs/installing-snapd)

Ejecuta los siguientes comandos para asegurarte tienes la 煤ltima versi贸n

```
sudo snap install core; sudo snap refresh core
```

***Importante!!!***

Si llegaras a tener una previa instalaci贸n de cerbot deber谩s eliminarla para que se use el complemento y no la instalaci贸n

No es necesario hacer esto si ya instalaste el complemento y solo est谩s agregando un nuevo certificado

```
sudo apt remove certbot
```


**Bien es momento de ahora si instalar cerbot**

```
sudo snap install --classic certbot
```

Luego de la instalaci贸n ejecute este comando para asegurarse de que cerbot se pueda ejecutar con el comando

```
sudo ln -s /snap/bin/certbot /usr/bin/certbot
```

Ahora para ejecutar cerbot y obtener un certificado tienes dos caminos, dejar que cerbot se encargue de toda la configuraci贸n de apache o pedir un certificado y tu hacer las configuraciones manualmente.

En lo personal he probado lo suficiente el modo autom谩tico como para sentirme c贸modo utiliz谩ndolo, no veo la necesidad de hacer la configuraci贸n manualmente.

```
sudo certbot --apache
```

Al ejecutar este comando empezara la configuraci贸n autom谩tica, nos llevara por una serie de preguntas que deberemos completar y listo ya tendremos nuestro certificado instalado, ahora solo queda comprobarlo en el navegador!

Por 煤ltimo con el siguiente comando se activar谩 la renovaci贸n autom谩tica del certificado cuando este expire.

```
sudo certbot renew --dry-run
```

[- Volver al indice -](#indice)
<!--############################################################################################################-->
<!--############################################################################################################-->
<!--############################################################################################################-->
<!--############################################################################################################-->



# 11. Fin 馃憦馃憦馃憦馃帄馃帄馃帄

Si pudiste seguir todos los pasos, felicidades amigos m铆o ya tienes un buen servidor linux en tus manos!!

Hasta otra 馃枛

[- Volver al indice -](#indice)

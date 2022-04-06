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
   - 3.3. [Importante❗](#33-importante)
4. **[Configurar claves RSA para la conexión SSH (Opcional)](#4-configurar-claves-rsa-para-la-conexión-ssh-opcional)**
   - 4.1. [Generar el par de claves 🔐](#41-generar-el-par-de-claves-)
   - 4.2. [Ahora como ingresamos desde otro equipo con esta clave ❓](#42-ahora-como-ingresamos-desde-otro-equipo-con-esta-clave-)
     - 4.2.1. [PowerShell](#421-powershell)
     - 4.2.2. [Putty y WinSCP](#422-putty-y-winscp)
   - 4.3. [Por último desactivar la autenticación con contraseña de SSH](#43-por-último-desactivar-la-autenticación-con-contraseña-de-ssh)
5. **[Configura laptop para cuando cierres la tapa no se suspenda (Opcional) 💻](#5-configura-laptop-para-cuando-cierres-la-tapa-no-se-suspenda-opcional-)**
6. **[Formateo y montado de unidad externa (Opcional)](#6-formateo-y-montado-de-unidad-externa-opcional)**
   - 6.1. [Como formateo mi disco?](#61-como-formateo-mi-disco)
   - 6.2. [Como montar esta nueva unidad en una carpeta?](#62-como-montar-esta-nueva-unidad-en-una-carpeta)
7. **[Instalar apache2](#7-instalar-apache2)**
   - 7.1. [Logs (OPCIONAL)](#71-logs-opcional)
   - 7.2. [Listado de directorios (OPCIONAL)](#72-listado-de-directorios-opcional)
   - 7.3. [Instalacion y configuracion de ModEvasive (OPCIONAL PERO NO TANTO)](#73-instalacion-y-configuracion-de-modevasive-opcional-pero-no-tanto)
8. **[Instalar mysql 💾](#8-instalar-mysql-)**
   - 8.1. [Ajustar autenticación y privilegios de usuarios (OPCIONAL)](#81-ajustar-autenticación-y-privilegios-de-usuarios-opcional)
   - 8.2. [Ajustar nivel de validación de contraseña (OPCIONAL)](#82-ajustar-nivel-de-validación-de-contraseña-opcional)
   - 8.3. [Cambiar carpeta de guardado para las bases de datos (OPCIONAL)](#83-cambiar-carpeta-de-guardado-para-las-bases-de-datos-opcional)
9. **[Instalar php para apache2](#9-instalar-php-para-apache2)**
   - 9.1. [Aumentar buffer para archivos de subida y POST (OPCIONAL)](#91-aumentar-buffer-para-archivos-de-subida-y-post-opcional)
10. **[Https 🔑](#10-https-)**
11. **[Fin 👏👏👏🎊🎊🎊](#11-fin-)**


<!--############################################################################################################-->
<!--############################################################################################################-->
<!--############################################################################################################-->
<!--############################################################################################################-->


## 1. Introduccion

En esta breve (pero no tanto) guía para linux veremos como instalar y configurar un servidor web junto con apache y mysql, también la configuración de ip estática y montar discos externos


[- Volver al indice -](#indice)
<!--############################################################################################################-->
<!--############################################################################################################-->
<!--############################################################################################################-->
<!--############################################################################################################-->


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

### 2.1. Cosas importantes que tienes que saber

A continuacion veremos algunos comandos basicos que estaremos usando y algunas otras cosas.

#### 2.1.1. Permisos

Saber reconocer que permisos tiene una carpeta o archivo es tan importante como saber darlos, aquí un breve repaso a este tema.

Para poder ver los permisos de un archivo o directorio debes usar el siguiente comando:

```
ls -l
```

Al comando ls normal le agregamos el flag `-l` para ver una lista detallada de todo, también podemos agregar `-a` para ver los archivos ocultos

![image](https://user-images.githubusercontent.com/81438736/161981333-b7adbc51-c836-4a72-80cc-1be9232fa17e.png)

Ahora repasemos lo que vemos en esta imagen, como puedes ver resalte con colores lo importante, el primer `-` que está al principio indica que esto es un archivo, si tuviéramos una `d` sería un directorio, los permisos se dividen en conjuntos de 3 que resalte con colores.

- Verde: Los primeros son los permisos del usuario propietario del archivo.
- Naranja: Los siguientes son permisos para el grupo del archivo.
- Amarillo: Por último los permisos para cualquier otra persona.

Definimos los permisos para cada sección con la letra que corresponda o la ausencia de ella, en ese caso colocamos un `-`, el orden siempre es el mismo, primero `r` permisos de lectura, `w` permisos de escritura y por último `x` permisos de ejecución.

Para cambiar los permisos de un archivo o directorio usamos el siguiente comando:

```
sudo chmod 664 /archivo/en/cuestion
```

(Podemos agregar el flag `-R` para que en el caso de un directorio los permisos se agreguen de forma recursiva a todo su contenido)

Como identificar los números y saber que conjunto de permisos estamos dando? Muy fácil, lo aremos sumando los siguientes números que te mostraré a continuación.

- 4 Lectura
- 2 Escritura
- 1 Ejecución

Sumando estos números obtendremos toda la lista de permisos combinados, ej. queremos permisos de lectura y escritura pues sumaremos 4 + 2 lo que nos dará 6

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

Para modificar la contraseña de este nuevo usuario podremos hacerlo de la siguiente forma:

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

(***Importante!*** Recuerda que agregar o eliminar grupos solo será efectivo luego de que el usuario cierre e inicie sesión nuevamente)

```
sudo usermod -a -G nombre_grupo nombre_usuario
```
(Se usa el flag `-G` para especificar un grupo secundario si quieras cambiar el grupo principal de un usuario usarías `-g`)

Y para eliminar a un usuario de un grupo usamos:

```
sudo gpasswd -d nombre_usuario nombre_grupo
```

#### 2.1.3. Propietario y grupo de un archivo

Los archivos tienen un dueño y un grupo al cual pertenecen, Como vimos antes, los permisos para estos dos están separados, además de los permisos para el resto de usuarios, pero como cambiamos al propietario de un archivo, y su grupo

Primero veremos como identificar esto en un archivo o directorio.

![image](https://user-images.githubusercontent.com/81438736/161992786-3c3552a5-d8af-4011-a0da-19335cbf396c.png)

- Verde: Se resalta el usuario propietario del archivo.
- Naranja: Es a que grupo pertenece el archivo.

Utilizando el siguiente comando podremos cambiar ambos o uno solo.

```
sudo chown nombre_usuario:nombre_grupo archivo_en_cuestion
```
(Podemos agregar el flag `-R` para que se apliquen los mismos cambios de manera recursiva a todos los ficheros en el interior si se tratase de un directorio)

En el caso de solo querer cambiar el usuario, pues dejaríamos la parte de grupo en blanco, tal que así:

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

- dhcp4: Iria en no para desactivarlo, si lo colocamos en `true` está activado.
- addresses: Sería la ip de tu equipo actual.
- gateway4: La puerta de enlace predeterminado.
- nameservers: Lista de DNS.
- optional: Colocamos esta opción en true para que al iniciar el equipo no quede esperando a tener conexión.

### 3.3. Importante❗

Una vez echo todo lo anterior tendras que ejecutar el siguiente comando para actualizar la configuracion de red.

**Asegúrate de poder volver a conectarte luego si estás en una conexión SSH**

```
sudo netplan apply
```

[- Volver al indice -](#indice)
<!--############################################################################################################-->
<!--############################################################################################################-->
<!--############################################################################################################-->
<!--############################################################################################################-->


# 4. Configurar claves RSA para la conexión SSH (Opcional)

Para agregar aun más seguridad a ti conexión ssh es necesario agregar claves RSA, para esto veremos como generar estas claves e instalarlas en cualquier equipo, también como desactivar la autentificación por contraseña por ssh

### 4.1. Generar el par de claves 🔐

Para esto usaremos el siguiente comando (Por defecto se generarn en `~/.ssh/id_rsa` a no ser especifiques otra ruta).
```
sudo ssh-keygen
```

Una vez las tengas generadas es necesario agregar la clave `*.pub` al archivo `~/.ssh/authorized_keys` si no existe créalo.

```
sudo echo public_key_string >> ~/.ssh/authorized_keys
```

o

```
sudo cat id_rsa.pub >> ~/.ssh/authorized_keys
```

Con esto ya agregaste la clave a la lista de claves autorizadas!

**Importante!**

Recuerda que si estás en el usuario root y estás configurando este acceso para un usuario en específico la carpeta `~/.ssh` debe tener el conjunto de permisos apropiados y pertenecer al usuario en cuestión.

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

Estas dos aplicaciones aunque muy buenas te pedirán tener una clave `*.ppk`, pero tranquilo es muy sencillo conseguir una utilizando el programa `Putty Key Generator` que ya deberías tener instalado si instalaste `Putty` o `WinSCP`.

![image](https://user-images.githubusercontent.com/81438736/161854398-8f849ae0-7870-4464-b2af-b2a44608fd02.png)

Harás clic en el botón load (Recuerda cambiar la búsqueda de archivos a `All Filles (\*.\*)`) y selecciona tu clave `id_rsa` (Si configuraste alguna contraseña para las claves te la pedirá), por último clic en `Save private key` puedes llamarla `id_rsa_putty.ppk` y listo ya tendrás guardada tu clave como .ppk

Para ingresar tu `*.ppk` en **Putty** solo tendrás que ir a ese submenú y buscarla, luego inicia normalmente como siempre.
![image](https://user-images.githubusercontent.com/81438736/161855055-c6f8119c-72df-4cb5-9c53-a84fa8841368.png)

En el caso de **WinSCP** tendrás que ir a `Avanzado` y luego a `Autentificación`
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
Verifica que la línea no quede comentada con `#` y que diga `no`, para que los cambios surtan efecto deberás resetear el SSH con el siguiente comando

***(Importante: recuerda comprobar en otra terminal poder acceder con tu clave RSA antes de desactivar la autenticación por contraseña)***

```
sudo systemctl restart ssh
```

[- Volver al indice -](#indice)
<!--############################################################################################################-->
<!--############################################################################################################-->
<!--############################################################################################################-->
<!--############################################################################################################-->


# 5. Configura laptop para cuando cierres la tapa no se suspenda (Opcional) 💻

En el caso de que tu servidor sea una laptop como es mi caso, es inconveniente tener la pantalla levantada todo el rato, para evitar que el equipo se suspenda si cerramos la tapa tendremos que configurar el siguiente archivo.

```
sudo nano /etc/systemd/logind.conf
```

En él localizaremos la siguiente línea y la estableceremos en `ignore` recuerda comprobar la línea quede des comentada.

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

Un buen servidor siempre debe tener almacenamiento suficiente para la información, de preferencia todo en un RAID 1 o superior, pero como hacemos que Linux reconozca este dispositivo que ingresamos? 💽

Primero usaremos el comando siguiente para ver la lista de discos y particiones conectadas.

```
sudo fdisk -l
```

![image](https://user-images.githubusercontent.com/81438736/161866415-4855fd6d-123b-46ce-a25c-ecfd6928aa1c.png)


***IMPORTANTE!!***

Debes saber diferenciar cuál es la ruta al disco y cuál es la partición, en este caso con verde resalte la ruta al disco y con amarillo la partición de este disco. (Si bien puedes guardar información en un disco sin particionar no es recomendable).

También es posible que si tu disco es nuevo no tengas creada una particion, por lo que la tabla en amarillo no te saldría.

Si encuentras una tabla de peticiones que tiene varios registros cuidado!, esa probablemente sea la tabla de peticiones del sistema, no debes tocar eso, para los discos externos se genera una nueva tabla en la parte inferior.


### 6.1. Como formateo mi disco?

Primero antes de arrancar es necesario saber si tu disco está montado en alguna carpeta, para esto usaras el comando a continuación te devolverá una lista de rutas de particiones, en que carpetas están montadas y cuanta capacidad del disco ha sido utilizada.

```
sudo df
```

En el caso que tu disco este montado, utiliza el siguiente comando para desmontar la unidad.


```
sudo umount /dev/sdb1
```

Ahora si, para iniciar el particionamiento de nuestro disco, utiliza el siguiente comando. (Comprueba estar particionando tu disco y no una partición)

```
fdisk /dev/sdb
```

Este comando te abrirá una interfaz en el que podrás interactuar con letras y realizar acciones.

- **p**: Te permitirá imprimir en pantalla la tabla de particiones actuales.
- **d**: Te permitirá eliminar una partición.
- **n**: Te permitirá crear una nueva partición.
- **t**: Te permitirá cambiar el tipo de sistema de fichero (Código 83 es el identificador de los sistemas Linux).
- **w**: Para finalizar y guardar los cambios.

El proceso es muy sencillo, si estás realizando un disco para guardar información, primero elimina todas las particiones con la opción `d`, a continuación crea una única partición primaria con `n` (Te saldrán algunas preguntas, si das enter dejando todo en blanco se configurara por default), con `t` cambias el tipo de sistema de fichero a 83 y para finalizar `w` para guardar los cambios y salir.

Ahora para poder formatear esta nueva partición que creamos simplemente usamos: (Recuerda colocar la ruta a la partición de tu disco y no al disco en sí)
```
sudo mkfs.ext4 /dev/sdb1
```

Listo!!

### 6.2. Como montar esta nueva unidad en una carpeta?

Esta es la parte más sencilla, primero seleccionaremos en que carpeta queremos montar nuestra unidad, en mi caso crearé una.

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

Cuando se reinicie nuestro equipo, este disco tendrás que volver a montarlo a la misma carpeta, para facilitarnos la vida vamos a ingresar la línea de montado en el archivo **Fstab** del sistema (Este es el archivo de configuración de Linux en el que se registran las particiones que deben montarse al iniciarse. Por esto si tu equipo arranca y luego le conectas ti dispositivo no se montara automáticamente a no ser que reinicies o lo hagas manualmente)


```
sudo nano /etc/fstab
```

Agregaras al final del archivo

```
/dev/sdb1       /media/discoduro       ext4      rw,nouser,dev,exec,auto 0 0
```

Y listo, al reiniciar el equipo, tu unidad se montará automáticamente al inicio.


[- Volver al indice -](#indice)
<!--############################################################################################################-->
<!--############################################################################################################-->
<!--############################################################################################################-->
<!--############################################################################################################-->



# 7. Instalar apache2

Para que nuestro equipo se transforme en un servidor web echo y derecho necesitamos un programa que nos haga de servidor web, en este caso apache2, también instalaremos apache2-utils es un paquete de programas que son útiles para cualquier servidor web.

Para instalarlo simplemente ejecutamos el siguiente comando:

```
sudo apt install apache2 apache2-utils
```

Y listo así de sencillo ya tenemos un servidor web.

### 7.1. Logs (OPCIONAL)

Como puede que sepas apache guarda un registro de cada conexión que recibe y cada error que pueda producirse, es lo que se conoce como archivo log, en el caso de apache estos archivos por default están en `/var/log/apache2/\*`, en sí mismo no es un problema dejarlos acá, pero si tenemos un servidor que registra muchas peticiones capas es conveniente guardar estos logs en un disco externo, la ruta de los log está en el siguiente archivo:

```
sudo nano /etc/apache2/envvars
```

![image](https://user-images.githubusercontent.com/81438736/161870504-ded60379-1a67-4e16-a766-85c1c34d1c95.png)

Por último recuerda reiniciar apache para aplicar los cambios.
```
sudo systemctl restart apache2
```

### 7.2. Listado de directorios (OPCIONAL)

En la configuración default de apache, si alguien ingresa a una carpeta desde la web este devolverá una lista de todo lo que contiene, en ambiente de producción esto no es nada seguro, así que veamos como desactivarlo.

```
sudo nano /etc/apache2/apache2.conf
```

![image](https://user-images.githubusercontent.com/81438736/161871364-97e12f3f-a2dd-43a5-b14a-8da45ae3db39.png)

Una vez en el archivo de configuración de apache localizarás la sección que dice `<Directory /var/www/&gt;` el contenido de esta carpeta es el que apache expone al puerto 80, en el renglón inferior encontraremos que dirá `Options Indexes FollowSymLinks` tendrás que borrar `Indexes` para que te quede como en la imagen.

Por último recuerda reiniciar apache para aplicar los cambios.
```
sudo systemctl restart apache2
```

### 7.3. Instalacion y configuracion de ModEvasive (OPCIONAL PERO NO TANTO)

Tener proteccion contra posibles ataque DoS, DDoS y de fuerza bruta nunca esta demas, este módulo creara una tabla hash de direcciones IP y URI con la cual supervisara las solicitudes entrantes al servidor y bloqueara aquellas sospechosas.

Para instalar este módulo ejecutaremos el siguiente comando:

```
sudo apt install libapache2-mod-evasive
```

Durante la instalación se le pedirá que configure un servidor de correo para recibir notificaciones, elijan la opción que desean.

Muy bien, ahora ya puede configurar mod-evasive yendo a su archivo de configuración.

```
sudo nano /etc/apache2/mods-enabled/evasive.conf
```

![image](https://user-images.githubusercontent.com/81438736/161874115-5fb04662-18de-4b59-8b11-56bc0d680e9e.png)

Aquí puede configurar una ruta para los archivos log y el resto de parámetros.

- **DOSHashTableSize**: Se especifica el tamaño de la tabla hash.
- **DOSPageCount**: Cantidad de solicitudes permitidas por segundo de un mismo URI.
- **DOSSiteCount**: Numero maximo de solicitudes permitidas por una Ip.
- **DOSPageInterval**: Intervalo de recuento de páguinas.
- **DOSSiteInterval**: Intervalo de recuento de sitios.
- **DOSBlockingPeriod**: Tiempo en segundo que un cliente será bloqueado.
- **DOSEmailNotify**: Correo electrónico al que avisar cuando una Ip sea bloqueada.
- **DOSSystemCommand**: Comando que se ejecutara cuando una Ip sea bloqueada.
- **DOSLogDir**: Directorio para logs.

Por último recuerda reiniciar apache para aplicar los cambios.
```
sudo systemctl restart apache2
```

[- Volver al indice -](#indice)
<!--############################################################################################################-->
<!--############################################################################################################-->
<!--############################################################################################################-->
<!--############################################################################################################-->



# 8. Instalar mysql 💾

Todo buen servidor necesitara una base de datos para guardar y gestionar información (Puede que tu servidor no lo necesite si solo muestra imágenes o algo así, pero nunca esta demás)

```
sudo apt install mysql-server
```

Una vez instalado pasaremos a ejecutar el siguiente comando para configurarlo

```
sudo mysql_secure_installation
```

Ejecutando esto tendrán una serie de preguntas para establecer algunos parámetros de la instalación, tan sencillo como seguir los pasos y configurarlo a tu gusto.

### 8.1. Ajustar autenticación y privilegios de usuarios (OPCIONAL)

Por defecto, el usuario root de MySQL se configura para la autenticación usando el complemento `auth_socket` y no una contraseña, lo que aporta mayor seguridad, pero presenta complicaciones cuando queremos que un programa externo ingrese a este usuario.

Para ingresar como root en MySQL deberemos cambiar su método de autenticación de `auth_socket` a otro complemento como `caching_sha2_password` o `mysql_native_password`.

Que elegir? `caching_sha2_password` es la opcion pereferida por MySQL proporciona un cifrado de contraseña mas seguro, pero muchas aplicaciones PHP no funcionan de forma fiable con `caching_sha2_password` asi que se recomienda usar `mysql_native_password` si es que trabajas con PHP

Para hacer esto primero entraremos a mysql desde la terminal:

```
sudo mysql
```

Con la siguiente sentencia podremos ver la lista de usuarios y sus plugins

```
SELECT user,authentication_string,plugin,host FROM mysql.user;
```

Y con la siguiente sentencia cambiaremos este plugin y estableceremos una contraseña:

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

### 8.2. Ajustar nivel de validación de contraseña (OPCIONAL)

Si tienes un servidor mysql local sin salida a la red es posible quieras tener una contraseña corta para tu usuario MySQL, un error que puede pasarte al intentar establecer esta contraseña es: `ERROR 1819 (HY000): Your password does not satisfy the current policy requirements.` como arreglamos esto? Primero ingresa a mysql

Con la siguiente sentencia podrás ver el nivel actual de validación de contraseñas

```
SHOW VARIABLES LIKE 'validate_password%';
```

Y con la siguiente sentencia cambiar este nivel a LOW

```
SET GLOBAL validate_password.policy = 0;
```

Si su contraseña aún no cumple los criterios mínimos (No recomiendo hacer esto) pero puede deshabilitar la validación con la siguiente sentencia (Dentro de MySQL).

```
UNINSTALL COMPONENT "file://component_validate_password";
```

Ahora puede crear su usuario y luego volver a activar el complemento

```
INSTALL COMPONENT "file://component_validate_password";
```

### 8.3. Cambiar carpeta de guardado para las bases de datos (OPCIONAL)

Si usted cuenta con un disco externo de RAID 1 muy probablemente quiera que la información sensible como lo son las base de datos se guarden en este, veamos como hacerlo.

Primero que nada detendremos el servicio MySQL y AppArmor si lo tenemos instalado.

AppArmor es un módulo de seguridad del Kernel Linux que permite al administrador del sistema restringir las capacidades de un programa, en conclucion, si queremos que el programa MySQL tenga alcance a su nueva carpeta deberemos ajustar las reglas en AppArmor.

```
sudo systemctl stop mysql
```
```
sudo systemctl stop apparmor
```

Moveremos todos los archivos de MySQL a la nueva ubicación que deseamos, por defecto los archivos de base de datos de MySQL en Ubuntu están en `/var/lib/mysql/`, una vez tengamos todo en la nueva dirección procederemos a cambiar el nombre a la carpeta original por algo así `/var/lib/mysql_safe` hacemos esto por si fuera necesario regresar a la configuración anterior luego.

```
sudo cp /var/lib/mysql_safe /nueva/ruta/mysql
```

Es importante que esta nueva carpeta tenga los permisos apropiados y el dueño sea MySQL

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

Ahora iremos al archivo de configuración de MySQL e indicaremos la nueva ruta:

```
sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
```

![image](https://user-images.githubusercontent.com/81438736/161881065-e813b5a4-a57e-4dea-89f2-fd06aa1294af.png)

Modificaremos 'datadir' con nuestra nueva dirección.

Como mencione antes debemos modificar la configuración de AppArmor, vamos a editar o crear en caso de que no exista el siguiente archivo:

```
sudo nano /etc/apparmor.d/local/usr.sbin.mysqld
```

Dentro de este pondremos las siguientes líneas

```
/nueva/ruta/mysql/ r,
/nueva/ruta/mysql/** rwk,
```

Por último iniciamos AppArmor y MySQL

```
sudo service apparmor start
```
```
sudo systemctl start mysql
```

Si hicimos todo correctamente debería iniciarse sin problemas

[- Volver al indice -](#indice)
<!--############################################################################################################-->
<!--############################################################################################################-->
<!--############################################################################################################-->
<!--############################################################################################################-->



# 9. Instalar php para apache2

En este caso yo soy un fan incondicional de PHP así que para mi servidor usaré esto jaja, la instalación es rápida y sencilla

```
sudo apt install php libapache2-mod-php
```

Recuerda es necesario reiniciar apache para que PHP empiece a funcionar

```
sudo systemctl restart apache2
```

### 9.1. Aumentar buffer para archivos de subida y POST (OPCIONAL)

Si piensas permitir que se suban archivos a tu servidor a través de PHP, seguramente con el máximo tamaño permitido por default te quede un poco corto, así que veamos como solucionar eso. (La idea es entrar a `php.ini puede que tu ruta sea distinta dependiendo la versión de PHP entre otras cosas

```
sudo nano /etc/php/7.4/apache2/php.ini
```

Una vez dentro del archivo de configuración debemos localizar las siguientes líneas:

```
upload_max_filesize = 2M
post_max_size = 8M
```

Si utilizas nano recuerda que con `CRTL + W` podrás buscar, las líneas no se encuentran juntas sino en secciones separadas del archivo, aumenta el size a lo que te convenga más, importante que `post_max_size` sea siempre un poco mayor que `upload_max_filesize`.

[- Volver al indice -](#indice)
<!--############################################################################################################-->
<!--############################################################################################################-->
<!--############################################################################################################-->
<!--############################################################################################################-->



# 10. Https 🔑

En la actualidad ya quedan muy pocos servidores que no tengan https y el nuestro no va a ser menos, tener tu propio certificado https para tu dominio es muy sencillo y gratuito gracias a la herramienta certbot, pero como se usa? Esta es la mejor parte en la propia página de certbot encontrarás un instructivo de como se instala y se automatiza, aquí te escribiré los puntos importantes y por arriba

Primero que nada necesitarás instalar `snapd` es un sistema de implementación y empaquetado de software desarrollado por Canonical para sistemas operativos que utilizan el kernel de Linux, lo más seguro es que si estás utilizando las últimas versiones de Ubuntu ya venga instalado, es fácil de saber ejecutado el siguiente comando.

```
sudo snap --version
```

Si no lo llegas a tener instalado puedes buscar como en su web [-Instalar snapd-](https://snapcraft.io/docs/installing-snapd)

Ejecuta los siguientes comandos para asegurarte tienes la última versión

```
sudo snap install core; sudo snap refresh core
```

***Importante!!!***

Si llegaras a tener una previa instalación de cerbot deberás eliminarla para que se use el complemento y no la instalación

No es necesario hacer esto si ya instalaste el complemento y solo estás agregando un nuevo certificado

```
sudo apt remove certbot
```


**Bien es momento de ahora si instalar cerbot**

```
sudo snap install --classic certbot
```

Luego de la instalación ejecute este comando para asegurarse de que cerbot se pueda ejecutar con el comando

```
sudo ln -s /snap/bin/certbot /usr/bin/certbot
```

Ahora para ejecutar cerbot y obtener un certificado tienes dos caminos, dejar que cerbot se encargue de toda la configuración de apache o pedir un certificado y tu hacer las configuraciones manualmente.

En lo personal he probado lo suficiente el modo automático como para sentirme cómodo utilizándolo, no veo la necesidad de hacer la configuración manualmente.

```
sudo certbot --apache
```

Al ejecutar este comando empezara la configuración automática, nos llevara por una serie de preguntas que deberemos completar y listo ya tendremos nuestro certificado instalado, ahora solo queda comprobarlo en el navegador!

Por último con el siguiente comando se activará la renovación automática del certificado cuando este expire.

```
sudo certbot renew --dry-run
```

[- Volver al indice -](#indice)
<!--############################################################################################################-->
<!--############################################################################################################-->
<!--############################################################################################################-->
<!--############################################################################################################-->



# 11. Fin 👏👏👏🎊🎊🎊

Si pudiste seguir todos los pasos, felicidades amigos mío ya tienes un buen servidor linux en tus manos!!

Hasta otra 🖖

[- Volver al indice -](#indice)

apt list --upgradable
apt upgrade
apt update
apt install apache2
apt install mysql-server
mysql_secure_installation

#Configurar usuario root de mysql con nueva contraseña

apt install php libapache2-mod-php



### Configura laptop para cuando cierres la tapa no se suspenda
# sudo nano /etc/systemd/logind.conf
# HandleLidSwitch=ignore



## Configurar ip estatica "ifconfig -a"
# sudo nano /etc/netplan/00-*.yaml
#network:
# version: 2
# renderer: networkd
# ethernets:
#  enp1s0:
#   dhcp4: no
#   addresses: [192.168.1.25/24]
#   gateway4: 192.168.1.201
#   nameservers:
#    addresses: [200.40.30.245, 8.8.8.8]

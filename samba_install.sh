#!/bin/bash
#Script de instalação do Samba a partir de código-fonte
#Versão: 1.0
#Data: 10/02/2017
fsroot=/dev/sda1
version=4.8.8
realm=lab.howto.online

##também configurar estas opções no fstab:
###Obs: caso o filesystem seja XFS, não são necessárias estas alterações:
tune2fs -o acl,user_xattr $fsroot
mount -o remount /

##baixando e instalando o samba e os pacotes necessários:
yum install perl gcc attr libacl-devel libblkid-devel gnutls-devel readline-devel python-devel gdb pkgconfig krb5-workstation zlib-devel setroubleshoot-server libaio-devel setroubleshoot-plugins policycoreutils-python libsemanage-python perl-ExtUtils-MakeMaker perl-Parse-Yapp perl-Test-Base popt-devel libxml2-devel libattr-devel keyutils-libs-devel cups-devel bind-utils libxslt docbook-style-xsl openldap-devel autoconf python-crypto pam-devel ntp wget vim -y

wget https://ftp.samba.org/pub/samba/samba-latest.tar.gz
tar -xzvf samba-latest.tar.gz
cd samba-$version
./configure --prefix /usr --enable-fhs --enable-cups --sysconfdir=/etc --localstatedir=/var --with-privatedir=/var/lib/samba/private --with-piddir=/var/run/samba --with-automount --datadir=/usr/share --with-lockdir=/var/run/samba --with-statedir=/var/lib/samba --with-cachedir=/var/cache/samba --with-systemd
make
make install
ldconfig
##Provisionando o domínio:
echo "
[libdefaults]
        default_realm = $realm
        dns_lookup_realm = false
        dns_lookup_kdc = true" > /var/lib/samba/private/krb5.conf 
rm -f /etc/samba/smb.conf
cp -f /var/lib/samba/private/krb5.conf /etc/krb5.conf
samba-tool domain provision --use-rfc2307 --interactive
##Criando o arquivo se serviço no SystemD:

echo "
[Unit]
Description=Samba4 AD DC
After=network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
LimitNOFILE=16384
ExecStart=/usr/sbin/samba -D
ExecReload=/usr/bin/kill -HUP $MAINPID
PIDFile=/var/run/samba/samba.pid

[Install]
WantedBy=multi-user.target" > /lib/systemd/system/samba-ad-dc.service

##Ativando o serviço do samba no boot e iniciando o samba:
systemctl daemon-reload
systemctl enable samba-ad-dc
systemctl start samba-ad-dc



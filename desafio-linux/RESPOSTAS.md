

## 1. Kernel e Boot loader

1-Adicionei o comando single init=/bin/bash no cmd do GRUB e adicionei o usuário vagrant ao arquivo sudoers.
Também adicionei ele ao grupo root.

## 2. Usuários

### 2.1 Criação de usuários

1-Criei o usuário com parâmetros pra o uid ser 1111 </br>
2-adicionei ele ao grupo bin com "gpasswd -a getup" </br>
3-mudei o gid do grupo getup pra 2222 com "groupmod" </br>
3-dei unlock na senha


```
[getup@centos8 ~]$ id
uid=1111(getup) gid=2222(getup) groups=2222(getup),1(bin)
```

### 3.2 Criação de chaves

1 - criei o par de chaves usando ssh-keygen</br>
2 - ssh-copy-id da chave pra um usuário remoto (no caso o próprio vagrant, porque acessei o próprio server via ssh)</br>
3 - ssh vagrant@localhost. O resultado: </br>

```
[vagrant@centos8 ~]$ ssh vagrant@localhost
Last login: Mon Sep  5 18:21:21 2022 from 127.0.0.1
[vagrant@centos8 ~]$ exit
logout
Connection to localhost closed.
[vagrant@centos8 ~]$


```  

### 3.3 Análise de logs e configurações ssh

[ FAZENDO AINDA ]

1-Decodifiquei o base64 com "base64 -d id_rsa-desafio-linux-devel.gz.b64 > id.gz"</br>
2 - Dezipei o gz com "gzip -d id.gz" </br>
3-Obtive a openssh privatekey


## 4. Systemd

1-adicionei um ";" no arquivo nginx.conf na linha 45 para corrigir o erro 
  "invalid number of arguments in "root" directive in /etc/nginx/nginx.conf:45"

2-pra resolver o próximo erro, modifiquei o arquivo /usr/lib/systemd/system/nginx.service que quebra a inicialização do nginx

3-carregar as mudanças desse arquivo

4-conteúdo do curl do endereço após a correção:
```
"Duas palavrinhas pra você: para, béns!"
```

## 5. SSL

### 5.1 Criação de certificados

#### 1-criei certificado ROOT, SERVER e loguei
Utilizei esses comandos para criar o rootCA e o serverCA:

```
openssl ecparam -out rootCA.key -name prime256v1 -genkey

sudo openssl req -new -sha256 -key rootCA.key -out rootCA.csr

sudo openssl x509 -req -sha256 -days 365 -in rootCA.csr -signkey rootCA.key -out rootCA.crt

openssl ecparam -out server.key -name prime256v1 -genkey

openssl req -new -sha256 -key server.key -out server.csr

openssl x509 -req -in server.csr -CA  rootCA.crt -CAkey rootCA.key -CAcreateserial -out server.crt -days 365 -sha256

openssl x509 -in server.crt -text -noout

```

#### 2-adicionei ROOT CA à trusted store:
```
yum install ca-certificates
update-ca-trust force-enable
cp rootCA.crt /etc/pki/ca-trust/source/anchors/
update-ca-trust extract
```

#### 3-Alteração do arquivo de config. do NGINX pra aceitar conexões na porta 443 com SSL on. </br>


### 4-Response completa do curl "https://www.desafio.local" com verificação do certificado

```
RESPONSE:

* Rebuilt URL to: https://www.desafio.local/
*   Trying 127.0.0.1...
* TCP_NODELAY set
* Connected to www.desafio.local (127.0.0.1) port 443 (#0)
* ALPN, offering h2
* ALPN, offering http/1.1
* successfully set certificate verify locations:
*   CAfile: /etc/pki/tls/certs/ca-bundle.crt
  CApath: none
* TLSv1.3 (OUT), TLS handshake, Client hello (1):
* TLSv1.3 (IN), TLS handshake, Server hello (2):
* TLSv1.2 (IN), TLS handshake, Certificate (11):
* TLSv1.2 (IN), TLS handshake, Server key exchange (12):
* TLSv1.2 (IN), TLS handshake, Server finished (14):
* TLSv1.2 (OUT), TLS handshake, Client key exchange (16):
* TLSv1.2 (OUT), TLS change cipher, Change cipher spec (1):
* TLSv1.2 (OUT), TLS handshake, Finished (20):
* TLSv1.2 (IN), TLS handshake, Finished (20):
* SSL connection using TLSv1.2 / ECDHE-ECDSA-AES256-GCM-SHA384
* ALPN, server accepted to use http/1.1
* Server certificate:
*  subject: C=XX; L=Default City; O=Default Company Ltd; CN=www.desafio.local
*  start date: Sep  5 06:37:38 2022 GMT
*  expire date: Sep  5 06:37:38 2023 GMT
*  common name: www.desafio.local (matched)
*  issuer: C=XX; L=Default City; O=Default Company Ltd; CN=www.root.local
*  SSL certificate verify ok.
> GET / HTTP/1.1
> Host: www.desafio.local
> User-Agent: curl/7.61.1
> Accept: */*
>
< HTTP/1.1 200 OK
< Server: nginx/1.14.1
< Date: Mon, 05 Sep 2022 06:53:46 GMT
< Content-Type: text/html
< Content-Length: 41
< Connection: keep-alive
< Last-Modified: Fri, 02 Sep 2022 18:01:23 GMT
< ETag: "631244f3-29"
< Accept-Ranges: bytes
<
Duas palavrinhas pra você: para, béns!
* Connection #0 to host www.desafio.local left intact

```

## 6. Rede

### 6.1 Firewall

1-Verifiquei as regras de firewall com iptables, mas não havia nenhuma e portanto esse comando já estava funcionando:

```
[vagrant@centos8 ~]$ ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=117 time=29.5 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=117 time=29.7 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=117 time=29.5 ms
64 bytes from 8.8.8.8: icmp_seq=4 ttl=117 time=31.3 ms
^C
--- 8.8.8.8 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3006ms
rtt min/avg/max/mdev = 29.478/29.974/31.253/0.752 ms

```


### 6.2 HTTP

Resposta completa, com headers, da URL `https://httpbin.org/response-headers?hello=world`

```

HTTP/2 200
date: Mon, 05 Sep 2022 00:51:04 GMT
content-type: application/json
content-length: 89
server: gunicorn/19.9.0
hello: world
access-control-allow-origin: *
access-control-allow-credentials: true

{
  "Content-Length": "89",
  "Content-Type": "application/json",
  "hello": "world"
}

```

## Logs
1-Adicionei configurações específicas em /etc/logrotate.d pra os arquivos /var/log/nginx/errors.log e /var/log/nginx/access.log 
2-ficou +- assim cada um:
```
/var/log/nginx/errors.log {
        missingok
        monthly
        (...)
}
```

## 7. Filesystem

### 7.1 Expandir partição LVM

1-Expandi sdb1 de 1G pra 5G com fdisk com o seguinte algoritmo </br>
&emsp; 1.1 - desmontar LV </br>
&emsp; 1.2 - inativar LV </br>
&emsp; 1.3 - extender PV com fdisk </br>
&emsp; 1.4 - partprobe </br>
&emsp; 1.5 - pvresize </br>
&emsp; 1.6 - reativar LV </br>
2-Expandi LV pra 5G.  </br>
3-Resultados dos comandos pvdisplay, lvdisplay e df -hT:

```
  PV Name               /dev/sdb1
  VG Name               data_vg
  PV Size               <5.00 GiB / not usable 3.00 MiB
  Allocatable           yes (but full)
  PE Size               4.00 MiB
  Total PE              1279
  Free PE               0
  Allocated PE          1279
  PV UUID               XTxaEN-Cze7-7EWl-vWWE-7keb-p2Mq-mqJpiH
```

```
  LV Path                /dev/data_vg/data_lv
  LV Name                data_lv
  VG Name                data_vg
  LV UUID                sKjwY1-FbUA-D80u-U2sa-xCgU-1HZl-KYMmWO
  LV Write Access        read/write
  LV Creation host, time centos8.localdomain, 2022-09-02 18:01:23 +0000
  LV Status              available
  # open                 1
  LV Size                <5.00 GiB
  Current LE             1279
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     8192
  Block device           253:2
```

```
Filesystem                  Type      Size  Used Avail Use% Mounted on
/dev/mapper/data_vg-data_lv ext4      5.0G  4.0M  4.7G   1% /data
```



### 7.2 Criar partição LVM

1 - Criei sdb2 de 5G com fdisk e formatei com "mkfs.ext4 /dev/sdb2" </br>
2 - o resultado pode ser visto após montagem de sdb2 em /mnt. df -hT mostra:
```
Filesystem                  Type      Size  Used Avail Use% Mounted on
/dev/sdb2                   ext4      4.9G   20M  4.6G   1% /mnt
```


### 7.3 Criar partição XFS
1 - Formatei com mkfs.xfs
2 - visualização montando no /mnt:
```
Filesystem                  Type      Size  Used Avail Use% Mounted on
/dev/sdc                    xfs        10G  104M  9.9G   2% /mnt
```
# SimpleBashMonitor2Telegram
Una aplicacion de monitoreo creada en Bash y unido a un Bot de Telegram

## Acerca del Sistema 

Esta aplicacion fue diseñada para tener una herramienta de facil uso en la verificacion de los diferentes servicios y servidores de una red corporativa

-  Verifica respuesta mediante PING a servidores y dispositivos de la red
-  Verifica Servicio de sitio web (indica si pagina se carga correctamente para un proposito ej: login de acceso, mostrar formulario, mostrar datos)
-  Verifica Servicio de Navegacion de Proxy SQUID + Dansguardian (verifica si el servidor responde al ping y aceptando query's)   
-  Verifica Servicio de LDAP (verifica si el servidor responde al ping y aceptando query's)  
-  Verifica Servicio DNS (verifica si el servidor responde al ping y aceptando query's)  
-  Verifica Servicio SMTP (verifica si el servidor responde al ping y puede enviar correos)  
-  Envia resultado de la verificacion de servicios a un Bot de telegram previamente personalizado y a grupo seleccionado en telegram

Se estaran agregando nuevas funciones.

### Nota del autor: 
Para utilizar este aplicativo se requiere tener previamente instalado
- curl
- wget
- bind9-utils
- ldap-utils

Queda pendiente la actualizacion que provee la verificacion de:
- Servicios DNS
- Servicios SMTP

Se esta trabajando actualmente en la integracion al sistema operativo linux para que el chequeo sea mas comodo

Este aplicativo no requiere permisos de ROOT para su ejecucion

### Security Vulnerabilities

Si descubres alguna vulneravilidad o error, por favor enviame un correo a: britojq@gmail.com

### License

The aplication is open-sourced software licensed under the [MIT license](http://opensource.org/licenses/MIT).

## Autor
Jose A. Brito H. 
: @britojq : @britojab :
www.britojab.com.ve

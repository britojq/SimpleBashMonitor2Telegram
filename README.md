# SimpleBashMonitor2Telegram
Una aplicacion de monitoreo creada en Bash y unido a un Bot de Telegramm, está escrito en bash. Depende de los comandos normalmente disponibles en un entorno Linux / Unix

Para obtener más información sobre los comandos proporcionados por versiones recientes de [coreutils](https://en.wikipedia.org/wiki/List_of_GNU_Core_Utilities_commands), [busybox](https://en.wikipedia.org/wiki/BusyBox#Commands) o [toybox](https://landley.net/toybox/help.html), ver [Developer Notes](doc/7_develop.md#common-commands).

-  ** Nota para usuarios de MacOS y BSD: ** MyPersonalBashMonitor2Telegram no se ejecutará sin instalar software adicional ya que utiliza funciones modernas de bash.

-  ** Nota para sistemas integrados: ** Necesita instalar un bash "real" ya que la instalación básica de busybox o toybox no es suficiente.

Para instalar y ejecutar BashMonitor, necesita acceso a una línea de comandos de Linux / Unix con bash, un [cliente de Telegram] (https://telegram.org) y un teléfono móvil [con una cuenta de Telegram] (https://telegramguide.com / crear-una-cuenta-de-telegram /).
Primero necesitas [crear un nuevo token de Telegram Bot](doc/1_firstbot.md) para tu bot y escribirlo.

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

## Prerequisitos
Para utilizar este aplicativo se requiere tener previamente instalado
- curl
- wget
- bind9-utils
- ldap-utils

### Notas del autor: 
Queda pendiente la actualizacion que provee la verificacion de:
- Servicios DNS
- Servicios SMTP

Se esta trabajando actualmente en la integracion al sistema operativo linux para que el chequeo sea mas comodo

Este aplicativo no requiere permisos de ROOT para su ejecucion

### License

The aplication is open-sourced software licensed under the [MIT license](http://opensource.org/licenses/MIT).

## Consideraciones de Seguridad
Ejecutar un Telegram Bot significa que está conectado al público y nunca se sabe qué se envía a su Bot.
Los scripts de bash en general no están diseñados para ser a prueba de balas, así que considere esto como una prueba de concepto.
Consulte [Implicaciones de las citas incorrectas](https://unix.stackexchange.com/questions/171346/security-implications-of-forgetting-to-quote-a-variable-in-bash-posix-shells).

### Ejecuta tu bash como usuario restringido
** Recomiendo ejecutar el SimpleBashMonitor2Telegram como un usuario casi sin derechos de acceso. **
Todos los archivos a los que tiene acceso de escritura están en peligro de ser sobrescritos / eliminados si es pirateado.
Por la misma razón, todos los archivos que puede leer están en peligro de ser revelados. Restrinja los derechos de acceso al mínimo absoluto.
** ¡Nunca lo ejecute como root, esto es lo más peligroso que puede hacer! ** Por lo general, recomiendo usar el usuario 'nobody' que casi no tiene derechos en los sistemas Linux / Unix.

### Asegure la instalación
** La configuración no debe ser legible por otros usuarios. ** ¡Todos los que puedan leer su token de Bots pueden actuar como su Bot y tienen acceso a todos los chats en los que se encuentra el Bot!
Todas las personas con acceso de lectura a sus archivos de configuracion del bot pueden extraer sus datos de Bots. Especialmente la configuración de su Bot en `monitor.conf` debe estar protegida contra otros usuarios. Nadie, excepto usted, debería tener acceso de escritura a los archivos utilizados para el Bot. El Bot debe estar restringido para tener acceso de escritura a `monitor.conf`

## ¡Eso es todo, chicos!

Si cree que falta algo o si encontró un error, ¡no dude en enviar una solicitud de pull request! o enviame un correo a: britojq@gmail.com


## Autor
Jose A. Brito H. 
: @britojq : @britojab :
www.britojab.com.ve

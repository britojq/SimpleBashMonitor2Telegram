# SimpleBashMonitor2Telegram
Una aplicacion de monitoreo simple creada en Bash la cual envia el reporte de la revision de los servicios a un bot en telegram, está escrito en bash.
Depende de los comandos normalmente disponibles en un entorno Linux / Unix

Para obtener más información sobre los comandos proporcionados por versiones recientes de [coreutils](https://en.wikipedia.org/wiki/List_of_GNU_Core_Utilities_commands), [busybox](https://en.wikipedia.org/wiki/BusyBox#Commands) o [toybox](https://landley.net/toybox/help.html), ver [Developer Notes](doc/7_develop.md#common-commands).

-  ** Nota para usuarios de MacOS y BSD: ** MyPersonalBashMonitor2Telegram no se ejecutará sin instalar software adicional ya que utiliza funciones modernas de bash.

-  ** Nota para sistemas integrados: ** Necesita instalar un bash "real" ya que la instalación básica de busybox o toybox no es suficiente.

Para instalar y ejecutar BashMonitor, necesita acceso a una línea de comandos de Linux / Unix con bash, un [cliente de Telegram] (https://telegram.org) y un teléfono móvil [con una cuenta de Telegram] (https://telegramguide.com / crear-una-cuenta-de-telegram /).
Primero necesitas [crear un nuevo token de Telegram Bot](doc/1_firstbot.md) para tu bot y escribirlo.

## Acerca del Sistema 

Esta aplicacion fue diseñada para tener una herramienta de facil uso en la verificacion de los diferentes servicios y servidores de una red corporativa


- Verifica respuesta mediante PING a servidores y dispositivos de la red
- Verifica Servicio de sitio web (chequea si el sitio web carga sin problemas)
- Verifica Servicio de Navegacion a internet mediante el Proxy
- Verifica Servicio de LDAP
- Verifica Servicio de impresion CUPS
- Verifica Servicio DNS
- Verifica Servicio SMTP
- Verifica Servicio DHCP
- Envia resultado de la verificacion de servicios mediante un Bot de telegram previamente personalizado y al grupo en telegram donde se encuetra el bot

Se estaran agregando nuevas funciones.

## Prerequisitos
Para utilizar este aplicativo se requiere tener previamente instalado

- curl
- wget
- bind9-utils
- ldap-utils
- lpstat
- netcat
- nmap

### License
The aplication is open-sourced software licensed under the GNU Affero General Public License version 3 (AGPL-3.0) .

## Consideraciones de Seguridad
Los scripts de bash en general no están diseñados para ser a prueba de balas, así que considere esto como una prueba de concepto.
Consulte [Implicaciones de las citas incorrectas](https://unix.stackexchange.com/questions/171346/security-implications-of-forgetting-to-quote-a-variable-in-bash-posix-shells).

Todos los archivos a los que tiene acceso de escritura están en peligro de ser sobrescritos / eliminados.
Por la misma razón, todos los archivos que puede leer están en peligro de ser revelados. Restrinja los derechos de acceso al mínimo absoluto.

### Asegure la instalación
** La configuración no debe ser legible por otros usuarios. ** ¡Todos los que puedan leer su token de Bots pueden actuar como su Bot y tienen acceso a todos los chats en los que se encuentra el Bot!
Todas las personas con acceso de lectura a sus archivos de configuracion del bot pueden extraer sus datos de Bots. Especialmente la configuración de su Bot en `monitor.conf` debe estar protegida contra otros usuarios. Nadie, excepto usted, debería tener acceso de escritura a los archivos utilizados para el Bot. El Bot debe estar restringido para tener acceso de escritura a `monitor.conf`

## ¡Eso es todo, chicos!

Si cree que falta algo o si encontró un error, ¡no dude en enviar una solicitud de pull request! o enviame un correo a: britojq@gmail.com

## Autor
Jose A. Brito H. 
: @britojq : @britojab :
www.britojab.com

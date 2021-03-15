#### [Home](../README.md)
## Crea un bot de Telegram con Botfather
**[BotFather es el único bot para gobernarlos a todos](https://core.telegram.org/bots#3-how-do-i-create-a-bot). Le ayudará a crear nuevos bots y cambiar la configuración de los existentes..** [Commands known by Botfather](https://core.telegram.org/bots#generating-an-authorization-token)

### Creando un nuevo bot

1. Envíe un mensaje a @botfather https://telegram.me/botfather con lo siguiente
texto: `/ newbot`
   Si no sabe cómo enviar mensajes por nombre de usuario, haga clic en la búsqueda
en su aplicación de Telegram y escriba `@ botfather`, debería poder
para iniciar una conversación. Tenga cuidado de no enviarlo al mal
contacto, porque hay usuarios con un nombre de usuario similar.

   ![botfather conversación inicial](http://i.imgur.com/aI26ixR.png)

2. @botfather responde con `Muy bien, un nuevo bot. Como vamos a
¿llámarlo? Elija un nombre para su bot.`

3. Escriba el nombre que desee para su bot.

4. @botfather responde con `Bien. Ahora, elija un nombre de usuario para su
Bot. Debe terminar en bot. Así, por ejemplo: TetrisBot o
tetris_bot.`

5. Escriba el nombre de usuario que desee para su bot, mínimo 5 caracteres,
y debe terminar con "bot". Por ejemplo: `telesample_bot`

6. @botfather responde con:

    ¡Hecho! Felicitaciones por su nuevo bot. Lo encontrarás en
telegram.me/telesample_bot. Ahora puede agregar una descripción sobre
sección e imagen de perfil de su bot, consulte  /help para obtener una lista de
comandos.

    Utilice este token para acceder a la API HTTP:
    <b>123456789:AAG90e14-0f8-40183D-18491dDE</b>

    Para obtener una descripción de la API de bot, consulte esta página:
https://core.telegram.org/bots/api

7. Anote el 'token' mencionado anteriormente.

8. Escribe `/ setprivacy` a @botfather.

   ![botfather later conversation](http://i.imgur.com/tWDVvh4.png)

9. @botfather responde con `Elija un bot para cambiar la configuración de mensajes grupales.`

10. Escriba `@ telesample_bot` (cambie al nombre de usuario que estableció en el paso 5
arriba, pero comienza con `@`)

11. @botfather responde con

    'Enable' - su bot solo recibirá mensajes que comiencen
con el símbolo '/' o mencione el bot por nombre de usuario..
    'Disable' - su bot recibirá todos los mensajes que las personas envíen a los grupos.
    El estado actual es: ENABLED

12. Escriba `Disable` para permitir que su bot reciba todos los mensajes enviados a un
grupo.  Este paso depende de ti en realidad.

13. @botfather responde con `¡Éxito! El nuevo estado es: DISABLED. /help`






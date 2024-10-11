#!/bin/bash
##############################################################################################################
#
#     License: GNU Affero General Public License v3.0  https://cutt.ly/SxMDfO2
#      Author: Jose A. Brito H. (@britojab:@britojq), https://britojab.com
#		Copyright (c) 2021 Jose A. Brito H.
#
############################################

start=`date +%s`
clear
source /scripts/monitor/config/monitoreo.conf
source /scripts/monitor/config/bot.conf
###### Funcion para manejar la señal CTRL + C en caso de ser presionado
function handle_ctrl_c {
    echo "Ctrl+C Fue presionado, Terminando Script."
    sudo chattr -i /tmp/monitor.lock
	sudo rm -rf /tmp/monitor.lock
    exit 1
}
# Trap the SIGINT signal
trap 'handle_ctrl_c' SIGINT

###### VERIFICA SI SE ESTA EJECUTANDO Y CREA ARCHIVO DE BLOQUEO SINO SE ESTA EJECUTANDO PARA PREVENIR MULTIPLE EJECUCION
LOCKFILE=/tmp/monitor.lock
if [ -f $LOCKFILE ]; then
timelock_now=$(date +%s)
timelock_modified=$(stat -c %Y "$LOCKFILE")
	if [ $(($timelock_now - $timelock_modified)) -gt 300 ]; then
		  echo "YA SE EJECUTO Y BLOQUEO QUEDO ACTIVO EJECUTANDO CORRECTIVO"
		  sudo chattr -i $LOCKFILE
		  sudo rm -rf $LOCKFILE
	else
		  echo "YA SE ESTA EJECUTANDO ESPERE QUE TERMINE"
		  exit 1
	fi
fi
###### CREA NUEVO ARCHIVO DE BLOQUEO PARA PREVENIR EJECUCION
touch $LOCKFILE
sudo chattr +i $LOCKFILE

###### CREA CARPETA CONTENEDORA PARA ALMACENAR LOS DATOS UTILIZADOS PARA CHEQUEO
DIRTEMP=/tmp/monitor
if [ -d $DIRTEMP ]; then
    #echo "YA EXISTE CARPETA TEMPORAL"
    sudo rm -rf /tmp/monitor >/dev/null 2>&1
    sudo mkdir -p /tmp/monitor
    sudo chmod -R 777 /tmp/monitor
else
    #echo "NO EXISTE CARPETA TEMPORAL"
    sudo mkdir -p /tmp/monitor
    sudo chmod -R 777 /tmp/monitor
fi
##############################################################################################################
###### INICIO DE FUNCIONES

##############################################################################################################
########## FUNCION PARA LIMPIAR ARCHIVOS DONDE SE GUARDA VARIABLES DE REPORTES/DATA
prepare_exec() {
echo "###################################################################"
echo "PREPARANDO ENTORNO DE EJECUCION"
##############################################################################################################
##########  CREA ARCHIVOS ESPECIFICOS Y LOS DEJA EN BLANCO PARA RECIBIR CONTENIDO DEL SCRIPT
for letter in {A..Z}; do
    touch /tmp/monitor/${letter}-service-log.txt
done
fileVA1="/tmp/monitor/servicelog.txt"
	if [ -f "$fileVA1" ]; then
		rm /tmp/monitor/servicelog.txt >/dev/null 2>&1
		touch /tmp/monitor/servicelog.txt >/dev/null 2>&1
	else
		touch /tmp/monitor/servicelog.txt >/dev/null 2>&1
	fi
fileVA2="/tmp/monitor/services-reports.txt"
	if [ -f "$fileVA2" ]
		then
			rm /tmp/monitor/services-reports.txt >/dev/null 2>&1
			touch /tmp/monitor/services-reports.txt >/dev/null 2>&1
		else
			touch /tmp/monitor/services-reports.txt >/dev/null 2>&1
	fi
fileVA3="/tmp/monitor/sites-reports.txt"
	if [ -f "$fileVA3" ]
		then
			rm /tmp/monitor/sites-reports.txt >/dev/null 2>&1
			touch /tmp/monitor/sites-reports.txt >/dev/null 2>&1
		else
			touch /tmp/monitor/sites-reports.txt >/dev/null 2>&1
	fi
fileP0="/tmp/monitor/define-proxy.txt"
	if [ -f "$fileP0" ]; then
		rm /tmp/monitor/define-proxy.txt >/dev/null 2>&1
		touch /tmp/monitor/define-proxy.txt >/dev/null 2>&1
	else
		touch /tmp/monitor/define-proxy.txt >/dev/null 2>&1
	fi
	### 1
fileP1="/tmp/monitor/result-proxy.txt"
	if [ -f "$fileP1" ]; then
		rm /tmp/monitor/result-proxy.txt >/dev/null 2>&1
		touch /tmp/monitor/result-proxy.txt >/dev/null 2>&1
	else
		touch /tmp/monitor/result-proxy.txt >/dev/null 2>&1
	fi
fileP2="/tmp/monitor/sended-reports.txt"
	if [ -f "$fileP1" ]; then
		rm /tmp/monitor/sended-reports.txt >/dev/null 2>&1
		touch /tmp/monitor/sended-reports.txt >/dev/null 2>&1
	else
		touch /tmp/monitor/sended-reports.txt >/dev/null 2>&1
	fi
}
##############################################################################################################
##########  FUNCION PARA LIMPIAR ARCHIVOS INNECESARIOS AL TERMINAR LA EJECUCION DEL SCRIPT
clean_ONEXIT() {
	#LOG SERVICIOS
	rm /tmp/monitor/A-service-log.txt >/dev/null 2>&1
	rm /tmp/monitor/B-service-log.txt >/dev/null 2>&1
	rm /tmp/monitor/C-service-log.txt >/dev/null 2>&1
	rm /tmp/monitor/D-service-log.txt >/dev/null 2>&1
	rm /tmp/monitor/E-service-log.txt >/dev/null 2>&1
	rm /tmp/monitor/F-service-log.txt >/dev/null 2>&1
	rm /tmp/monitor/G-service-log.txt >/dev/null 2>&1
	rm /tmp/monitor/H-service-log.txt >/dev/null 2>&1
	rm /tmp/monitor/I-service-log.txt >/dev/null 2>&1
	rm /tmp/monitor/J-service-log.txt >/dev/null 2>&1
	rm /tmp/monitor/K-service-log.txt >/dev/null 2>&1
	rm /tmp/monitor/L-service-log.txt >/dev/null 2>&1
	rm /tmp/monitor/M-service-log.txt >/dev/null 2>&1
	rm /tmp/monitor/N-service-log.txt >/dev/null 2>&1
	rm /tmp/monitor/O-service-log.txt >/dev/null 2>&1
	rm /tmp/monitor/P-service-log.txt >/dev/null 2>&1
	rm /tmp/monitor/Q-service-log.txt >/dev/null 2>&1
	rm /tmp/monitor/R-service-log.txt >/dev/null 2>&1
	rm /tmp/monitor/S-service-log.txt >/dev/null 2>&1
	rm /tmp/monitor/T-service-log.txt >/dev/null 2>&1
	rm /tmp/monitor/U-service-log.txt >/dev/null 2>&1
	rm /tmp/monitor/V-service-log.txt >/dev/null 2>&1
	rm /tmp/monitor/W-service-log.txt >/dev/null 2>&1
	rm /tmp/monitor/X-service-log.txt >/dev/null 2>&1
	rm /tmp/monitor/Y-service-log.txt >/dev/null 2>&1
	rm /tmp/monitor/Z-service-log.txt >/dev/null 2>&1
	rm /tmp/monitor/result-proxy.txt >/dev/null 2>&1
}
##############################################################################################################
##########  FUNCION TERMINA PROCESSOS EN CASO DE NO HABER FINALIZADO CORRECTAMENTE SU EJECUCION
termina_procesos() {
	kill $P1 >/dev/null 2>&1
	kill $P2 >/dev/null 2>&1
	kill $P3 >/dev/null 2>&1
	kill $P4 >/dev/null 2>&1
	kill $P5 >/dev/null 2>&1
	kill $P6 >/dev/null 2>&1
	kill $P7 >/dev/null 2>&1
	kill $P8 >/dev/null 2>&1
	kill $P9 >/dev/null 2>&1
	kill $P10 >/dev/null 2>&1
	kill $P11 >/dev/null 2>&1
	kill $P12 >/dev/null 2>&1
	kill $P13 >/dev/null 2>&1
	kill $P14 >/dev/null 2>&1
	kill $P15 >/dev/null 2>&1
	kill $P16 >/dev/null 2>&1
	kill $P17 >/dev/null 2>&1
	kill $P18 >/dev/null 2>&1
	kill $P19 >/dev/null 2>&1
	kill $P20 >/dev/null 2>&1
	kill $P21 >/dev/null 2>&1
	kill $P22 >/dev/null 2>&1
	kill $P23 >/dev/null 2>&1
	kill $P24 >/dev/null 2>&1
	kill $P25 >/dev/null 2>&1
	kill $P26 >/dev/null 2>&1
	kill $PX1 >/dev/null 2>&1
	kill $PX2 >/dev/null 2>&1
	kill $PX3 >/dev/null 2>&1
	kill $PX4 >/dev/null 2>&1
	kill $PX5 >/dev/null 2>&1
	kill $PX6 >/dev/null 2>&1
	kill $PX7 >/dev/null 2>&1
	kill $PX8 >/dev/null 2>&1
	kill $PX9 >/dev/null 2>&1
	kill $PX10 >/dev/null 2>&1
	kill $PX11 >/dev/null 2>&1
	kill $PX12 >/dev/null 2>&1
	kill $PX13 >/dev/null 2>&1
	kill $PX14 >/dev/null 2>&1
	kill $PX15 >/dev/null 2>&1
	kill $PX16 >/dev/null 2>&1
	kill $PX17 >/dev/null 2>&1
	kill $PX18 >/dev/null 2>&1
	kill $PX19 >/dev/null 2>&1
	kill $PX20 >/dev/null 2>&1
	kill $PX21 >/dev/null 2>&1
	kill $PX22 >/dev/null 2>&1
	kill $PX23 >/dev/null 2>&1
	kill $PX24 >/dev/null 2>&1
	kill $PX25 >/dev/null 2>&1
	kill $PX26 >/dev/null 2>&1
	kill $PX27 >/dev/null 2>&1
	kill $PX28 >/dev/null 2>&1
	kill $PX29 >/dev/null 2>&1
	kill $PX30 >/dev/null 2>&1
	kill $PX31 >/dev/null 2>&1
	kill $PX32 >/dev/null 2>&1
	kill $PX33 >/dev/null 2>&1
	kill $PX34 >/dev/null 2>&1
	kill $PX35 >/dev/null 2>&1
	kill $PX36 >/dev/null 2>&1
	kill $PX37 >/dev/null 2>&1
	kill $PX38 >/dev/null 2>&1
	kill $PX39 >/dev/null 2>&1
	kill $PX40 >/dev/null 2>&1
	kill $PX41 >/dev/null 2>&1
	kill $PX42 >/dev/null 2>&1
	kill $PX43 >/dev/null 2>&1
	kill $PX44 >/dev/null 2>&1
	kill $PX45 >/dev/null 2>&1
	kill $PX46 >/dev/null 2>&1
	kill $PX47 >/dev/null 2>&1
	kill $PX48 >/dev/null 2>&1
	kill $PX49 >/dev/null 2>&1
	kill $PX50 >/dev/null 2>&1
	kill $PX51 >/dev/null 2>&1
	kill $PX52 >/dev/null 2>&1
	kill $PX53 >/dev/null 2>&1
	kill $PX54 >/dev/null 2>&1
	kill $PX55 >/dev/null 2>&1
	kill $PX56 >/dev/null 2>&1
	kill $PX57 >/dev/null 2>&1
	kill $PX58 >/dev/null 2>&1
	kill $PX59 >/dev/null 2>&1
	kill $PX60 >/dev/null 2>&1
	kill $PX61 >/dev/null 2>&1
	kill $PX62 >/dev/null 2>&1
	kill $PX63 >/dev/null 2>&1
	kill $PX63 >/dev/null 2>&1
	kill $PX64 >/dev/null 2>&1
	kill $PX65 >/dev/null 2>&1
	kill $PX66 >/dev/null 2>&1
	kill $PX67 >/dev/null 2>&1
	kill $PX68 >/dev/null 2>&1
	kill $PX69 >/dev/null 2>&1
	kill $PX70 >/dev/null 2>&1
	kill $PX71 >/dev/null 2>&1
	kill $PX72 >/dev/null 2>&1
}
##############################################################################################################
########## FUNCIONES PARA VERIFICAR SERVICIOS
verifica_SERVICIOS() {
	#CREA UN PID PARA CADA LETRA EJECUTANDO UN COMANDO
		case $letter in
		A) #"PROCESO 1"
		P1=$!
		;;
		B) #"PROCESO 1"
		P2=$!
		;;
		C) #"PROCESO 1"
		P3=$!
		;;
		D) #"PROCESO 1"
		P4=$!
		;;
		E) #"PROCESO 1"
		P5=$!
		;;
		F) #"PROCESO 1"
		P6=$!
		;;
		G) #"PROCESO 1"
		P7=$!
		;;
		H) #"PROCESO 1"
		P8=$!
		;;
		I) #"PROCESO 1"
		P9=$!
		;;
		J) #"PROCESO 1"
		;;
		K) #"PROCESO 1"
		P11=$!
		;;
		L) #"PROCESO 1"
		P12=$!
		;;
		M) #"PROCESO 1"
		P13=$!
		;;
		N) #"PROCESO 1"
		P14=$!
		;;
		O) #"PROCESO 1"
		P15=$!
		;;
		P) #"PROCESO 1"
		P16=$!
		;;
		Q) #"PROCESO 1"
		P17=$!
		;;
		R) #"PROCESO 1"
		P18=$!
		;;
		S) #"PROCESO 1"
		P19=$!
		;;
		T) #"PROCESO 1"
		P20=$!
		;;
		U) #"PROCESO 1"
		P21=$!
		;;
		V) #"PROCESO 1"
		P22=$!
		;;
		W) #"PROCESO 1"
		P23=$!
		;;
		X) #"PROCESO 1"
		P24=$!
		;;
		Y) #"PROCESO 1"
		P25=$!
		;;
		Z) #"PROCESO 1"
		P26=$!
		;;
		*) #"CUALQUIER OTRO NO CONFIGURADO"
		echo "nada"
		;;
	esac

	case ${!VARTIPOSERVICIO} in
		WEB)##APLICATIVO WEB SE REALIZA UN REQUEST AL SITIO WEB A VERIFICAR
			RESPUESTAWEB=$(curl -k -s -o /dev/null -w "%{http_code}" ${!VARWEBHOST})
			# VERIFICA EL ESTATUS DEL CODIGO HTTP
			if [ $RESPUESTAWEB -eq 200 ]; then
				#CREANDO ARCHIVO REGISTRO DE EVENTOS
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				echo "INFORMACION PARA EL REGISTRO DE ERRORES" >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				echo "LOG DE ERROR DE : ${!VARNOMBREMOSTRARS}" >> /tmp/monitor/${letter}-service-log.txt
				echo "SITIO WEB ARRIBA (CODIGO HTTP: $RESPUESTA)" >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt

				#CREANDO ARCHIVO CONTENEDOR DE DATOS PARA ENVIO DE MENSAJES (API/BOT)
				echo "STHOST${letter}='${!VARMENSAJENORMAL}'" >> /tmp/monitor/data-services.txt
				echo "STATESERVICE${letter}=ACTIVO" >> /tmp/monitor/data-services.txt

			elif [ $RESPUESTAWEB -eq 301 ]; then
				#CREANDO ARCHIVO REGISTRO DE EVENTOS
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				echo "INFORMACION PARA EL REGISTRO DE ERRORES" >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				echo "LOG DE ERROR  DE: ${!VARNOMBREMOSTRARS}" >> /tmp/monitor/${letter}-service-log.txt
				echo "PROXY ARRIBA (CODIGO HTTP: $RESPUESTA)" >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt

				#CREANDO ARCHIVO CONTENEDOR DE DATOS PARA ENVIO DE MENSAJES (API/BOT)
				echo "STHOST${letter}='${!VARMENSAJENORMAL}'" >> /tmp/monitor/data-services.txt
				echo "STATESERVICE${letter}=ACTIVO" >> /tmp/monitor/data-services.txt

			else
				#CREANDO ARCHIVO REGISTRO DE EVENTOS
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				echo "INFORMACION PARA EL REGISTRO DE ERRORES" >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				echo "LOG DE ERROR  DE: ${!VARNOMBREMOSTRARS}" >> /tmp/monitor/${letter}-service-log.txt
				echo "SITIO WEB CAIDO (CODIGO HTTP: $RESPUESTA)" >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt

				#CREANDO ARCHIVO CONTENEDOR DE DATOS PARA ENVIO DE MENSAJES (API/BOT)
				echo "STHOST${letter}='${!VARMENSAJEERROR}'" >> /tmp/monitor/data-services.txt
				echo "STATESERVICE${letter}=APAGADO" >> /tmp/monitor/data-services.txt
			fi
		;;
		DNS) #EJECUTA UN QUERY AL SERVIDOR DNS Y VERIFICA SI HAY RESPUESTA
		RESPUESTADNS=";; Got answer:"
		VERIFICADNS=$(dig @${!VARIPHOSTS} ${!VARDNSEQUIPOVER} | grep -i "got")
			if [ -z "$VERIFICADNS" ]; then
                #CREANDO ARCHIVO REGISTRO DE EVENTOS
                echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
                echo "INFORMACION PARA EL REGISTRO DE ERRORES" >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				echo "LOG DE ERROR  DE: ${!VARNOMBREMOSTRARS}" >> /tmp/monitor/${letter}-service-log.txt
				echo "ESTATUS: CAIDO : SERVICIO NO RESPONDE" >> /tmp/monitor/${letter}-service-log.txt
				dig @${!VARIPHOSTS} ${!VARDNSEQUIPOVER} >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt

				#CREANDO ARCHIVO CONTENEDOR DE DATOS PARA ENVIO DE MENSAJES (API/BOT)
				echo "STHOST${letter}='${!VARMENSAJEERROR}'" >> /tmp/monitor/data-services.txt
				echo "STATESERVICE${letter}=APAGADO" >> /tmp/monitor/data-services.txt

			elif [[ $VERIFICADNS == $RESPUESTADNS ]] ; then
                #CREANDO ARCHIVO REGISTRO DE EVENTOS
                echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
                echo "INFORMACION PARA EL REGISTRO DE ERRORES" >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				echo "LOG DE ERROR  DE: ${!VARNOMBREMOSTRARS}" >> /tmp/monitor/${letter}-service-log.txt
				dig @${!VARIPHOSTS} ${!VARDNSEQUIPOVER} >> /tmp/monitor/${letter}-service-log.txt
                echo "SERVICIO ACTIVO RESPONDE" >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt

				#CREANDO ARCHIVO CONTENEDOR DE DATOS PARA ENVIO DE MENSAJES (API/BOT)
				echo "STHOST${letter}='${!VARMENSAJENORMAL}'" >> /tmp/monitor/data-services.txt
				echo "STATESERVICE${letter}=ACTIVO" >> /tmp/monitor/data-services.txt

			 else
				#CREANDO ARCHIVO REGISTRO DE EVENTOS
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				echo "INFORMACION PARA EL REGISTRO DE ERRORES" >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				echo "LOG DE ERROR  DE: ${!VARNOMBREMOSTRARS}" >> /tmp/monitor/${letter}-service-log.txt
				echo "ESTATUS: CAIDO : SERVICIO NO RESPONDE" >> /tmp/monitor/${letter}-service-log.txt
				dig @${!VARIPHOSTS} ${!VARDNSEQUIPOVER} >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt

				#CREANDO ARCHIVO CONTENEDOR DE DATOS PARA ENVIO DE MENSAJES (API/BOT)
				echo "STHOST${letter}='${!VARMENSAJEERROR}'" >> /tmp/monitor/data-services.txt
				echo "STATESERVICE${letter}=APAGADO" >> /tmp/monitor/data-services.txt

			fi
		;;
		PROXY) #"SERVIDOR PROXY"
			# REALIZA UN REQUEST AL SITIO WEB A VERIFICAR
			RESPUESTAWEB=$(curl -U ${!VARUSUARIOCLAVEPROXY} -x ${!VARIPPROXYPUERTO} -k -s -o /dev/null -w "%{http_code}" ${!VARURLCONTROL})
			# VERIFICA EL ESTATUS DEL CODIGO HTTP
			if [ $RESPUESTAWEB -eq 200 ]; then
				#CREANDO ARCHIVO REGISTRO DE EVENTOS
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				echo "INFORMACION PARA EL REGISTRO DE ERRORES" >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				echo "LOG DE ERROR  DE: ${!VARNOMBREMOSTRARS}" >> /tmp/monitor/${letter}-service-log.txt
				echo "PROXY ARRIBA (CODIGO HTTP: $RESPUESTA)" >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt

				#CREANDO ARCHIVO CONTENEDOR DE DATOS PARA ENVIO DE MENSAJES (API/BOT)
				echo "STHOST${letter}='${!VARMENSAJENORMAL}'" >> /tmp/monitor/data-services.txt
				echo "STATESERVICE${letter}=ACTIVO" >> /tmp/monitor/data-services.txt

			elif [ $RESPUESTAWEB -eq 301 ]; then
				#CREANDO ARCHIVO REGISTRO DE EVENTOS
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				echo "INFORMACION PARA EL REGISTRO DE ERRORES" >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				echo "LOG DE ERROR  DE: ${!VARNOMBREMOSTRARS}" >> /tmp/monitor/${letter}-service-log.txt
				echo "PROXY ARRIBA (CODIGO HTTP: $RESPUESTA)" >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt

				#CREANDO ARCHIVO CONTENEDOR DE DATOS PARA ENVIO DE MENSAJES (API/BOT)
				echo "STHOST${letter}='${!VARMENSAJENORMAL}'" >> /tmp/monitor/data-services.txt
				echo "STATESERVICE${letter}=ACTIVO" >> /tmp/monitor/data-services.txt

			elif [ $RESPUESTAWEB -eq 302 ]; then
				#CREANDO ARCHIVO REGISTRO DE EVENTOS
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				echo "INFORMACION PARA EL REGISTRO DE ERRORES" >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				echo "LOG DE ERROR  DE: ${!VARNOMBREMOSTRARS}" >> /tmp/monitor/${letter}-service-log.txt
				echo "PROXY ARRIBA (CODIGO HTTP: $RESPUESTA)" >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt

				#CREANDO ARCHIVO CONTENEDOR DE DATOS PARA ENVIO DE MENSAJES (API/BOT)
				echo "STHOST${letter}='${!VARMENSAJENORMAL}'" >> /tmp/monitor/data-services.txt
				echo "STATESERVICE${letter}=ACTIVO" >> /tmp/monitor/data-services.txt

			else
				#CREANDO ARCHIVO REGISTRO DE EVENTOS
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				echo "INFORMACION PARA EL REGISTRO DE ERRORES" >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				echo "LOG DE ERROR  DE: ${!VARNOMBREMOSTRARS}" >> /tmp/monitor/${letter}-service-log.txt
				echo "PROXY CAIDO (CODIGO HTTP: $RESPUESTA)" >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt

				#CREANDO ARCHIVO CONTENEDOR DE DATOS PARA ENVIO DE MENSAJES (API/BOT)
				echo "STHOST${letter}='${!VARMENSAJEERROR}'" >> /tmp/monitor/data-services.txt
				echo "STATESERVICE${letter}=APAGADO" >> /tmp/monitor/data-services.txt

			fi
		;;
		SMTP) #"SERVIDOR CORREO SMTP"
nc -w 5 ${!VARIPHOSTS} ${!VARSMTPPUERTO} << EOF
HELO mail.mydom.com
QUIT
EOF
			if [ $? == 0 ]; then
				#CREANDO ARCHIVO REGISTRO DE EVENTOS
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				echo "INFORMACION PARA EL REGISTRO DE ERRORES" >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				echo "LOG DE ERROR  DE: ${!VARNOMBREMOSTRARS}" >> /tmp/monitor/${letter}-service-log.txt
				echo "$letter - ACTIVO : NOMBRE: ${!VARNOMBREMOSTRARS} RESPONDE" >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt

				#CREANDO ARCHIVO CONTENEDOR DE DATOS PARA ENVIO DE MENSAJES (API/BOT)
				echo "STHOST${letter}='${!VARMENSAJENORMAL}'" >> /tmp/monitor/data-services.txt
				echo "STATESERVICE${letter}=ACTIVO" >> /tmp/monitor/data-services.txt

			else
				#CREANDO ARCHIVO REGISTRO DE EVENTOS
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				echo "INFORMACION PARA EL REGISTRO DE ERRORES" >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				echo "LOG DE ERROR  DE: ${!VARNOMBREMOSTRARS}" >> /tmp/monitor/${letter}-service-log.txt
				echo "ESTATUS: CAIDO : SERVICIO NO RESPONDE" >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				#CREANDO ARCHIVO CONTENEDOR DE DATOS PARA ENVIO DE MENSAJES (API/BOT)

				echo "STHOST${letter}='${!VARMENSAJEERROR}'" >> /tmp/monitor/data-services.txt
				echo "STATESERVICE${letter}=APAGADO" >> /tmp/monitor/data-services.txt

			fi
		;;
		DHCP) #"SERVIDOR DHCP"
		VARDHCP=$(sudo nmap --script broadcast-dhcp-discover -e ${!VARINTERFAZRED} | grep -i "|     DHCP Message Type: DHCPOFFER")
			if [ -z "$VARDHCP" ]; then
				#CREANDO ARCHIVO REGISTRO DE EVENTOS
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				echo "INFORMACION PARA EL REGISTRO DE ERRORES" >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				echo "LOG DE ERROR  DE: ${!VARNOMBREMOSTRARS}" >> /tmp/monitor/${letter}-service-log.txt
				echo "ESTATUS: CAIDO : SERVICIO NO RESPONDE" >> /tmp/monitor/${letter}-service-log.txt
				sudo nmap --script broadcast-dhcp-discover -e ${!VARINTERFAZRED} | grep -i "|     DHCP Message Type: DHCPOFFER" >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt

				#CREANDO ARCHIVO CONTENEDOR DE DATOS PARA ENVIO DE MENSAJES (API/BOT)
				echo "STHOST${letter}='${!VARMENSAJEERROR}'" >> /tmp/monitor/data-services.txt
				echo "STATESERVICE${letter}=APAGADO" >> /tmp/monitor/data-services.txt

			elif [ "$VARDHCP" == "|     DHCP Message Type: DHCPOFFER" ]; then
				#CREANDO ARCHIVO REGISTRO DE EVENTOS
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				echo "INFORMACION PARA EL REGISTRO DE ERRORES" >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				echo "LOG DE ERROR  DE: ${!VARNOMBREMOSTRARS}" >> /tmp/monitor/${letter}-service-log.txt
				echo "$letter - ACTIVO : NOMBRE: ${!VARNOMBREMOSTRARS} RESPONDE" >> /tmp/monitor/${letter}-service-log.txt
				echo "$VARDHCPClog" >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt

				#CREANDO ARCHIVO CONTENEDOR DE DATOS PARA ENVIO DE MENSAJES (API/BOT)
				echo "STHOST${letter}='${!VARMENSAJENORMAL}'" >> /tmp/monitor/data-services.txt
				echo "STATESERVICE${letter}=ACTIVO" >> /tmp/monitor/data-services.txt

			else
				#CREANDO ARCHIVO REGISTRO DE EVENTOS
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				echo "INFORMACION PARA EL REGISTRO DE ERRORES" >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				echo "LOG DE ERROR  DE: ${!VARNOMBREMOSTRARS}" >> /tmp/monitor/${letter}-service-log.txt
				echo "ESTATUS: CAIDO : SERVICIO NO RESPONDE" >> /tmp/monitor/${letter}-service-log.txt
				sudo nmap --script broadcast-dhcp-discover -e ${!VARINTERFAZRED} | grep -i "|     DHCP Message Type: DHCPOFFER" >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt

				#CREANDO ARCHIVO CONTENEDOR DE DATOS PARA ENVIO DE MENSAJES (API/BOT)
				echo "STHOST${letter}='${!VARMENSAJEERROR}'" >> /tmp/monitor/data-services.txt
				echo "STATESERVICE${letter}=APAGADO" >> /tmp/monitor/data-services.txt

			fi
		;;
		CUPS) #"SERVIDOR CUPS (SERVIDOR DE IMPRESION)"
	    VARCUPS=$(lpstat -h ${!VARIPCUPSPUERTO} -t -o | grep -i "Ready to print" | tail -n 1 | cut '-d ' '-f1')
			if [ -z "$VARCUPS" ]; then
				#CREANDO ARCHIVO REGISTRO DE EVENTOS
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				echo "INFORMACION PARA EL REGISTRO DE ERRORES" >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				echo "LOG DE ERROR  DE: ${!VARNOMBREMOSTRARS}" >> /tmp/monitor/${letter}-service-log.txt
				echo "ESTATUS: CAIDO : SERVICIO NO RESPONDE" >> /tmp/monitor/${letter}-service-log.txt
				lpstat -h ${!VARIPCUPSPUERTO} -t -o | grep -i "Ready to print"  >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt

				#CREANDO ARCHIVO CONTENEDOR DE DATOS PARA ENVIO DE MENSAJES (API/BOT)
				echo "STHOST${letter}='${!VARMENSAJEERROR}'" >> /tmp/monitor/data-services.txt
				echo "STATESERVICE${letter}=APAGADO" >> /tmp/monitor/data-services.txt

			elif [ "$VARCUPS" == "	Ready" ]; then
				#CREANDO ARCHIVO REGISTRO DE EVENTOS
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				echo "INFORMACION PARA EL REGISTRO DE ERRORES" >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				echo "LOG DE ERROR  DE: ${!VARNOMBREMOSTRARS}" >> /tmp/monitor/${letter}-service-log.txt
				echo "$letter - ACTIVO : NOMBRE: ${!VARNOMBREMOSTRARS} RESPONDE" >> /tmp/monitor/${letter}-service-log.txt
				lpstat -h ${!VARIPCUPSPUERTO} -t -o | grep -i "Ready to print"  >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt

				#CREANDO ARCHIVO CONTENEDOR DE DATOS PARA ENVIO DE MENSAJES (API/BOT)
				echo "STHOST${letter}='${!VARMENSAJENORMAL}'" >> /tmp/monitor/data-services.txt
				echo "STATESERVICE${letter}=ACTIVO" >> /tmp/monitor/data-services.txt

			else
				#CREANDO ARCHIVO REGISTRO DE EVENTOS
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				echo "INFORMACION PARA EL REGISTRO DE ERRORES" >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				echo "LOG DE ERROR  DE: ${!VARNOMBREMOSTRARS}" >> /tmp/monitor/${letter}-service-log.txt
				echo "ESTATUS: CAIDO : SERVICIO NO RESPONDE" >> /tmp/monitor/${letter}-service-log.txt
				lpstat -h ${!VARIPCUPSPUERTO} -t -o | grep -i "Ready to print"  >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt

				#CREANDO ARCHIVO CONTENEDOR DE DATOS PARA ENVIO DE MENSAJES (API/BOT)
				echo "STHOST${letter}='${!VARMENSAJEERROR}'" >> /tmp/monitor/data-services.txt
				echo "STATESERVICE${letter}=APAGADO" >> /tmp/monitor/data-services.txt

			fi
		;;
		LDAP) #"SERVIDOR LDAP"
			nc -zv ${!VARIPHOSTS} ${!VARIPLDAPPORT} > /dev/null 2>&1
			if [ $? -eq 0 ]; then
				#CREANDO ARCHIVO REGISTRO DE EVENTOS
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				echo "INFORMACION PARA EL REGISTRO DE ERRORES" >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				echo "LOG DE ERROR  DE: ${!VARNOMBREMOSTRARS}" >> /tmp/monitor/${letter}-service-log.txt
				echo "$letter - ACTIVO : NOMBRE: ${!VARNOMBREMOSTRARS} RESPONDE" >> /tmp/monitor/${letter}-service-log.txt
				#ldapsearch -x -h ${!VARIPHOSTS} -p ${!VARIPLDAPPORT} -b "ou=users,ou=*,dc=corpoelec,dc=gob,dc=ve" >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt

				#CREANDO ARCHIVO CONTENEDOR DE DATOS PARA ENVIO DE MENSAJES (API/BOT)
				echo "STHOST${letter}='${!VARMENSAJENORMAL}'" >> /tmp/monitor/data-services.txt
				echo "STATESERVICE${letter}=ACTIVO" >> /tmp/monitor/data-services.txt

			else
				#CREANDO ARCHIVO REGISTRO DE EVENTOS
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				echo "INFORMACION PARA EL REGISTRO DE ERRORES" >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				echo "LOG DE ERROR  DE: ${!VARNOMBREMOSTRARS}" >> /tmp/monitor/${letter}-service-log.txt
				echo "ESTATUS: CAIDO : SERVICIO NO RESPONDE" >> /tmp/monitor/${letter}-service-log.txt
				#ldapsearch -x -h ${!VARIPHOSTS} -p ${!VARIPLDAPPORT} -b "ou=users,ou=*,dc=corpoelec,dc=gob,dc=ve" >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt

				#CREANDO ARCHIVO CONTENEDOR DE DATOS PARA ENVIO DE MENSAJES (API/BOT)
				echo "STHOST${letter}='${!VARMENSAJEERROR}'" >> /tmp/monitor/data-services.txt
				echo "STATESERVICE${letter}=APAGADO" >> /tmp/monitor/data-services.txt

			fi
		;;
		*) #"CUALQUIER OTRO NO CONFIGURADO"
			if ping -qc 20 ${!VARIPHOSTS} >/dev/null; then
				#CREANDO ARCHIVO REGISTRO DE EVENTOS
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				echo "INFORMACION PARA EL REGISTRO DE ERRORES" >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				echo "LOG DE ERROR  DE: ${!VARNOMBREMOSTRARS}" >> /tmp/monitor/${letter}-service-log.txt
				echo "ESTATUS: ACTIVO - RESPONDE AL PING " >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt

				#CREANDO ARCHIVO CONTENEDOR DE DATOS PARA ENVIO DE MENSAJES (API/BOT)
				echo "STHOST${letter}='${!VARMENSAJENORMAL}'" >> /tmp/monitor/data-services.txt
				echo "STATESERVICE${letter}=ACTIVO" >> /tmp/monitor/data-services.txt

			else
				#CREANDO ARCHIVO REGISTRO DE EVENTOS
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				echo "INFORMACION PARA EL REGISTRO DE ERRORES" >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt
				echo "LOG DE ERROR  DE: ${!VARNOMBREMOSTRARS}" >> /tmp/monitor/${letter}-service-log.txt
				echo "ESTATUS: CAIDO - NO RESPONDE AL PING"  >> /tmp/monitor/${letter}-service-log.txt
				echo "----------------------------------------" >> /tmp/monitor/${letter}-service-log.txt

				#CREANDO ARCHIVO CONTENEDOR DE DATOS PARA ENVIO DE MENSAJES (API/BOT)
				echo "STHOST${letter}='${!VARMENSAJEERROR}'" >> /tmp/monitor/data-services.txt
				echo "STATESERVICE${letter}=APAGADO" >> /tmp/monitor/data-services.txt

			fi
		;;
	esac

}

##############################################################################################################
########## FUNCION PARA EJECUTA EL CHEQUEO DE SERVICIOS
ejecuta_servicios() {
###### INICA VERIFICACION DE SERVICIOS
for letter in {A..Z}; do
	#CONVERSION DE VARIABLES PARA SU USO
	VARTIPOSERVICIO="TYPESERVICE${letter}"
	VARNOMBREMOSTRARS="NAMESERVICE${letter}"
	VARWEBHOST="WEBSERVICE${letter}"
	VARIPHOSTS="IPSERVICE${letter}"
	VARIPCUPSPUERTO="CUPSPORTIP${letter}"
	VARIPLDAPPORT="LDAPPORTIP${letter}"
	VARSMTPPUERTO="SMTPPORT${letter}"
	VARINTERFAZRED="NETINTERFACE${letter}"
	VARDNSEQUIPOVER="TESTHOSTDNS${letter}"
	VARUSUARIOCLAVEPROXY="PROXYUSERPASSW${letter}"
	VARIPPROXYPUERTO="PROXYIPPORT${letter}"
	VARURLCONTROL="URLTESTSITE${letter}"
	VARMENSAJENORMAL="NORMALESTATEMSG${letter}"
	VARMENSAJEERROR="ERRORESTATEMSG${letter}"
	#FIN DE CONVERSION DE VARIABLES

	#EJECUTANDO PROCESO DE CHEQUEO DE SERVICIOS
	#printf '*'
	verifica_SERVICIOS &
	sleep 1
done

########## HACIENDO QUE ESPERE HASTA QUE TERMINE LA EJECUCION DE LOS PROCESOS
printf "\nPROCESANDO DATOS DE CHEQUEO DE SERVICIOS\n"
wait $P1 $P2 $P3 $P4 $P5 $P6 $P7 $P8 $P9 $P10 $P11 $P12 $P13 $P14 $P15 $P16 $P17 $P18 $P19 $P20 $P21 $P22 $P23 $P24 $P25 $P26 $P27

}
##############################################################################################################
########## FUNCIONES PARA GENERAR ARCHIVO UNICO CON LOGS DE LOS SERVICIOS VERIFICADOS
genera_logs() {
	#ESTE SEGMENTO REUNE TODOS LOS LOGS DE LAS EJECUCIONES EN UN SOLO ARCHIVO PARA UNA MEJOR VISUALIZACION
	fechaPLOG=$(date '+ %A, %B %d, %Y.')
	horaPLOG=$(date '+ %H:%M:%S')
	echo "################################################" >> /tmp/monitor/servicelog.txt
	echo "##  REGISTROS DE CADA CHEQUEO DE SERVICIOS " >> /tmp/monitor/servicelog.txt
	echo "##  FECHA DE EJECUCION: $fechaPLOG " >> /tmp/monitor/servicelog.txt
	echo "##  HORA DE LA EJECUCION: $horaPLOG " >> /tmp/monitor/servicelog.txt
	echo "########" >> /tmp/monitor/servicelog.txt
	echo " " >> /tmp/monitor/servicelog.txt
	for letter in {A..Z}; do
	cat /tmp/monitor/${letter}-service-log.txt >> /tmp/monitor/servicelog.txt
	done
}

##############################################################################################################
########## FUNCION PARA CHEQUEAR SITES
sedes () {
#CREA UN PID PARA CADA LETRA EJECUTANDO UN COMANDO
		case $letter in
		A) #"PROCESO 1"
		PX1=$!
		;;
		B) #"PROCESO 1"
		PX2=$!
		;;
		C) #"PROCESO 1"
		PX3=$!
		;;
		D) #"PROCESO 1"
		PX4=$!
		;;
		E) #"PROCESO 1"
		PX5=$!
		;;
		F) #"PROCESO 1"
		PX6=$!
		;;
		G) #"PROCESO 1"
		PX7=$!
		;;
		H) #"PROCESO 1"
		PX8=$!
		;;
		*) #"CUALQUIER OTRO NO CONFIGURADO"
		echo "nada"
		;;
	esac

	#VERIFICA SITES
	if ping -qc 20 ${!VARSITE} >/dev/null; then
		echo "STSITE${letter}='${!VARNORMALSITE}'" >> /tmp/monitor/data-sites.txt
		echo "ESTATSITE${letter}=ACTIVO" >> /tmp/monitor/data-sites.txt
	else
		echo "STSITE${letter}='${!VARERRORSITE}'" >> /tmp/monitor/data-sites.txt
		echo "ESTATSITE${letter}=APAGADO" >> /tmp/monitor/data-sites.txt
	fi

}

##############################################################################################################
########## FUNCION PARA CHEQUEAR EQUIPOS
equipos() {
case $letter$number in
		A1) #"PROCESO 1"
		PX9=$!
		;;
		A2) #"PROCESO 1"
		PX10=$!
		;;
		A3) #"PROCESO 1"
		PX11=$!
		;;
		A4) #"PROCESO 1"
		PX12=$!
		;;
		A5) #"PROCESO 1"
		PX13=$!
		;;
		A6) #"PROCESO 1"
		PX14=$!
		;;
		A7) #"PROCESO 1"
		PX15=$!
		;;
		A8) #"PROCESO 1"
		PX16=$!
		;;
		B1) #"PROCESO 1"
		PX17=$!
		;;
		B2) #"PROCESO 1"
		PX18=$!
		;;
		B3) #"PROCESO 1"
		PX19=$!
		;;
		B4) #"PROCESO 1"
		PX20=$!
		;;
		B5) #"PROCESO 1"
		PX21=$!
		;;
		B6) #"PROCESO 1"
		PX22=$!
		;;
		B7) #"PROCESO 1"
		PX23=$!
		;;
		B8) #"PROCESO 1"
		PX24=$!
		;;
		C1) #"PROCESO 1"
		PX25=$!
		;;
		C2) #"PROCESO 1"
		PX26=$!
		;;
		C3) #"PROCESO 1"
		PX27=$!
		;;
		C4) #"PROCESO 1"
		PX28=$!
		;;
		C5) #"PROCESO 1"
		PX29=$!
		;;
		C6) #"PROCESO 1"
		PX30=$!
		;;
		C7) #"PROCESO 1"
		PX31=$!
		;;
		C8) #"PROCESO 1"
		PX32=$!
		;;
		D1) #"PROCESO 1"
		PX33=$!
		;;
		D2) #"PROCESO 1"
		PX34=$!
		;;
		D3) #"PROCESO 1"
		PX35=$!
		;;
		D4) #"PROCESO 1"
		PX36=$!
		;;
		D5) #"PROCESO 1"
		PX37=$!
		;;
		D6) #"PROCESO 1"
		PX38=$!
		;;
		D7) #"PROCESO 1"
		PX39=$!
		;;
		D8) #"PROCESO 1"
		PX40=$!
		;;
		E1) #"PROCESO 1"
		PX41=$!
		;;
		E2) #"PROCESO 1"
		PX42=$!
		;;
		E3) #"PROCESO 1"
		PX43=$!
		;;
		E4) #"PROCESO 1"
		PX44=$!
		;;
		E5) #"PROCESO 1"
		PX45=$!
		;;
		E6) #"PROCESO 1"
		PX46=$!
		;;
		E7) #"PROCESO 1"
		PX47=$!
		;;
		E8) #"PROCESO 1"
		PX48=$!
		;;
		F1) #"PROCESO 1"
		PX49=$!
		;;
		F2) #"PROCESO 1"
		PX50=$!
		;;
		F3) #"PROCESO 1"
		PX51=$!
		;;
		F4) #"PROCESO 1"
		PX52=$!
		;;
		F5) #"PROCESO 1"
		PX53=$!
		;;
		F6) #"PROCESO 1"
		PX54=$!
		;;
		F7) #"PROCESO 1"
		PX55=$!
		;;
		F8) #"PROCESO 1"
		PX56=$!
		;;
		G1) #"PROCESO 1"
		PX57=$!
		;;
		G2) #"PROCESO 1"
		PX58=$!
		;;
		G3) #"PROCESO 1"
		PX59=$!
		;;
		G4) #"PROCESO 1"
		PX60=$!
		;;
		G5) #"PROCESO 1"
		PX61=$!
		;;
		G6) #"PROCESO 1"
		PX62=$!
		;;
		G7) #"PROCESO 1"
		PX63=$!
		;;
		G8) #"PROCESO 1"
		PX64=$!
		;;
		H1) #"PROCESO 1"
		PX65=$!
		;;
		H2) #"PROCESO 1"
		PX66=$!
		;;
		H3) #"PROCESO 1"
		PX67=$!
		;;
		H4) #"PROCESO 1"
		PX68=$!
		;;
		H5) #"PROCESO 1"
		PX69=$!
		;;
		H6) #"PROCESO 1"
		PX70=$!
		;;
		H7) #"PROCESO 1"
		PX71=$!
		;;
		H8) #"PROCESO 1"
		PX72=$!
		;;
		*) #"CUALQUIER OTRO NO CONFIGURADO"
		echo "nada"
		;;
	esac

	#VERIFICA EQUIPOS POR SITE
	if ping -qc 20 ${!VARSITEEQUIPO} >/dev/null; then
		echo "STSITE${letter}EQUIPO${number}='${!VARNORMALSITEEQUIPO}'" >> /tmp/monitor/data-sites.txt
		echo "ESTATSITE${letter}EQUIPO${number}=ACTIVO" >> /tmp/monitor/data-sites.txt
	else
        echo "STSITE${letter}EQUIPO${number}='${!VARERRORSITEEQUIPO}'" >> /tmp/monitor/data-sites.txt
        echo "ESTATSITE${letter}EQUIPO${number}=APAGADO" >> /tmp/monitor/data-sites.txt
    fi

}

##############################################################################################################
########## FUNCION PARA EJECUTAR EL CHEQUEO DE SITES Y EQUIPOS
ejecuta_sedes() {

for letter in {A..H}; do

	#INTERCAMBIA VARIABLES
	VARNAMESITE="NAMESITE${letter}"
	VARSITE="IPSITE${letter}"
	VARNORMALSITE="NORMALSITE${letter}"
	VARERRORSITE="ERRORSITE${letter}"
	#FIN INTERCAMBIA VARIABLES

	#INICIA VERIFICACION DE SITES
	sedes &

	#INICIA VERIFICACION DE EQUIPOS POR SITE
    for number in {1..8}; do
		#INTERCAMBIA VARIABLES
        VARNAMESITEEQUIPO="NAMESITE${letter}EQUIPO${number}"
        VARSITEEQUIPO="IPSITE${letter}EQUIPO${number}"
        VARNORMALSITEEQUIPO="NORMALSITE${letter}EQUIPO${number}"
        VARERRORSITEEQUIPO="ERRORSITE${letter}EQUIPO${number}"
        #FIN INTERCAMBIA VARIABLES
        #INICIA VERIFICACION DE EQUIPOS POR SITE
		equipos &
    done
	sleep 1
done

printf "\nPROCESANDO DATOS DE CHEQUEO DE SITIOS\n"
wait $PX1 $PX2 $PX3 $PX4 $PX5 $PX6 $PX7 $PX8 $PX9 $PX10 $PX11 $PX12 $PX13 $PX14 $PX15 $PX16 $PX17 $PX18 $PX19 $PX20 $PX21 $PX22 $PX23 $PX24 $XP25 $XP26 $PX27 $PX28 $P29 $PX30 $PX31 $PX32 $PX33 $PX34 $XP35 $XP36 $PX37 $PX38 $P39 $PX40 $PX41 $PX42 $PX43 $PX44 $XP45 $XP46 $PX47 $PX48 $P49 $PX50 $PX51 $PX52 $PX53 $PX54 $XP55 $XP56 $PX57 $PX58 $P59 $PX60 $PX61 $PX62 $PX63 $PX64 $XP65 $XP66 $PX67 $PX68 $P69 $PX70 $PX77 $PX72

}

proxy(){
        PROXYTEST=$(curl -U ${!TESTUSERPASS} -x ${!TESTPROXYIP} -k -s -o /dev/null -w "%{http_code}" ${!URLCONTROL})
        # VERIFICA EL ESTATUS DEL CODIGO HTTP
        if [ $PROXYTEST -eq 200 ]; then
            #ACTIVO
            echo "### PROXY (${letter}) OPERATIVO!" >> /tmp/monitor/result-proxy.txt
            echo "PROXY${letter}=OK" >> /tmp/monitor/result-proxy.txt
        else
            #FALLO
            echo "### PROXY (${letter}) APAGADO!" >> /tmp/monitor/result-proxy.txt
            echo "PROXY${letter}=APAGADO" >> /tmp/monitor/result-proxy.txt
        fi
}
detect_proxy() {
for letter in {A..D}; do
    case $letter in
        A) #"PROCESO 1"
            PRXYA=$!
        ;;
        B) #"PROCESO 1"
            PRXYB=$!
        ;;
        C) #"PROCESO 1"
            PRXYC=$!
        ;;
        D) #"PROCESO 1"
            PRXYD=$!
        ;;
        *) #"CUALQUIER OTRO NO CONFIGURADO"
        echo "nada"
        ;;
    esac
    #INTERCAMBIA VARIABLES
    TESTPROXYIP="IPADDRPORTPROXY${letter}"
    TESTUSERPASS="USERPASSWDPROXY${letter}"
    URLCONTROL="DEFAULTURLCONTROL"
    # REALIZA UN REQUEST AL SITIO WEB A VERIFICAR
    proxy &
    sleep 1
done
echo "DETERMINANDO PROXY ESPERE"
wait $PRXYA $PRXYB $PRXYC $PRXYD
##########  COMPROBANDO CUAL ESTA ACTIVO
source /tmp/monitor/result-proxy.txt
	if [ "$PROXYA" = "OK" ];then
		USUARIOCLAVEPROXY=$USERPASSWDPROXYA
		DEFAULTPROXY=$IPADDRPORTPROXYA
		echo "###### PROXY A UTILIZAR ######" >> /tmp/monitor/define-proxy.txt
		echo "DEFAULTPROXY=$DEFAULTPROXY" >> /tmp/monitor/define-proxy.txt
	elif [ "$PROXYB" = "OK" ];then
		USUARIOCLAVEPROXY=$USERPASSWDPROXYB
		DEFAULTPROXY=$IPADDRPORTPROXYB
		echo "###### PROXY A UTILIZAR ######" >> /tmp/monitor/define-proxy.txt
		echo "DEFAULTPROXY=$DEFAULTPROXY" >> /tmp/monitor/define-proxy.txt
	elif [ "$PROXYC" = "OK" ];then
		USUARIOCLAVEPROXY=$USERPASSWDPROXYC
		DEFAULTPROXY=$IPADDRPORTPROXYC
		echo "###### PROXY A UTILIZAR ######" >> /tmp/monitor/define-proxy.txt
		echo "DEFAULTPROXY=$DEFAULTPROXY" >> /tmp/monitor/define-proxy.txt
    elif [ "$PROXYD" = "OK" ];then
		USUARIOCLAVEPROXY=$USERPASSWDPROXYD
		DEFAULTPROXY=$IPADDRPORTPROXYD
		echo "###### PROXY A UTILIZAR ######" >> /tmp/monitor/define-proxy.txt
		echo "DEFAULTPROXY=$DEFAULTPROXY" >> /tmp/monitor/define-proxy.txt
	else
        echo "NO SE DETECTO CONEXION A INTERNET"
		USUARIOCLAVEPROXY=$USERPASSWDPROXYD
		DEFAULTPROXY=$IPADDRPORTPROXYD
		echo "###### PROXY A UTILIZAR ######" >> /tmp/monitor/define-proxy.txt
		echo "USUARIOCLAVEPROXY=$USUARIOCLAVEPROXY" >> /tmp/monitor/define-proxy.txt
		echo "DEFAULTPROXY=$DEFAULTPROXY" >> /tmp/monitor/define-proxy.txt
	fi
}

##############################################################################################################
########## SECCION DEFINE COMO ENVIARA LOS MENSAJES

########## MENSAJES DEBUG
mensajeDEBUGAB() {
    echo "$MENSAJEDEBUGA" >> /tmp/monitor/sended-reports.txt
    echo "$MENSAJEDEBUGB" >> /tmp/monitor/sended-reports.txt
    curl POST $URLPOST -d chat_id=$IDC -d text="INFORMACION COMPLETA" >/dev/null 2>&1
    curl POST $URLPOST -d chat_id=$IDC -d text="$MENSAJEDEBUGA" >/dev/null 2>&1
    curl POST $URLPOST -d chat_id=$IDC -d text="$MENSAJEDEBUGB" >/dev/null 2>&1
    curl POST $URLPOST -d chat_id=$IDC -d text="ARCHIVO CON EL LOG DE EJECUCION" >/dev/null 2>&1
    curl -F document=@"/tmp/monitor/servicelog.txt" https://api.telegram.org/bot$TOKENA/sendDocument?chat_id=$IDC >/dev/null 2>&1
    curl POST $URLPOST -d chat_id=$IDC -d text="El chequeo y reporte ha sido generado en  `expr $end - $start` segundos." >/dev/null 2>&1
}
proxyDEBUGAB() {
    echo "$MENSAJEDEBUGA" >> /tmp/monitor/sended-reports.txt
    echo "$MENSAJEDEBUGB" >> /tmp/monitor/sended-reports.txt
    curl -U $USUARIOCLAVEPROXY -x $DEFAULTPROXY POST $URLPOST -d chat_id=$IDC -d text="INFORMACION COMPLETA" >/dev/null 2>&1
    curl -U $USUARIOCLAVEPROXY -x $DEFAULTPROXY POST $URLPOST -d chat_id=$IDC -d text="$MENSAJEDEBUGA" >/dev/null 2>&1
    curl -U $USUARIOCLAVEPROXY -x $DEFAULTPROXY POST $URLPOST -d chat_id=$IDC -d text="$MENSAJEDEBUGB" >/dev/null 2>&1
    curl -U $USUARIOCLAVEPROXY -x $DEFAULTPROXY POST $URLPOST -d chat_id=$IDC -d text="ARCHIVO CON EL LOG DE EJECUCION" >/dev/null 2>&1
    curl -U $USUARIOCLAVEPROXY -x $DEFAULTPROXY -F document=@"/tmp/monitor/servicelog.txt" https://api.telegram.org/bot$TOKENA/sendDocument?chat_id=$IDC >/dev/null 2>&1
    curl -U $USUARIOCLAVEPROXY -x $DEFAULTPROXY POST $URLPOST -d chat_id=$IDC -d text="El chequeo y reporte ha sido generado en  `expr $end - $start` segundos." >/dev/null 2>&1
}
DEBUGAB_USERNPX() {
echo "$MENSAJEDEBUGA" >> /tmp/monitor/sended-reports.txt
echo "$MENSAJEDEBUGB" >> /tmp/monitor/sended-reports.txt
curl POST $URLPOST -d chat_id=$IDA -d text="INFORMACION COMPLETA" >/dev/null 2>&1
curl POST $URLPOST -d chat_id=$IDA -d text="$MENSAJEDEBUGA" >/dev/null 2>&1
curl POST $URLPOST -d chat_id=$IDA -d text="$MENSAJEDEBUGB" >/dev/null 2>&1
curl POST $URLPOST -d chat_id=$IDA -d text="El chequeo y reporte ha sido generado en  `expr $end - $start` segundos." >/dev/null 2>&1
}
DEBUGAB_USERPROXY() {
echo "$MENSAJEDEBUGA" >> /tmp/monitor/sended-reports.txt
echo "$MENSAJEDEBUGB" >> /tmp/monitor/sended-reports.txt
curl -U $USUARIOCLAVEPROXY -x $DEFAULTPROXY POST $URLPOST -d chat_id=$IDA -d text="INFORMACION COMPLETA" >/dev/null 2>&1
curl -U $USUARIOCLAVEPROXY -x $DEFAULTPROXY POST $URLPOST -d chat_id=$IDA -d text="$MENSAJEDEBUGA" >/dev/null 2>&1
curl -U $USUARIOCLAVEPROXY -x $DEFAULTPROXY POST $URLPOST -d chat_id=$IDA -d text="$MENSAJEDEBUGB" >/dev/null 2>&1
curl -U $USUARIOCLAVEPROXY -x $DEFAULTPROXY POST $URLPOST -d chat_id=$IDA -d text="El chequeo y reporte ha sido generado en  `expr $end - $start` segundos." >/dev/null 2>&1
}
########## MENSAJES SERVICIOS
mensaje_SERVCREADOR() {
    echo "$MENSAJEA" >> /tmp/monitor/sended-reports.txt
	curl POST $URLPOST -d chat_id=$IDC -d text="REPORTE SERVICIOS CORPORATIVOS" >/dev/null 2>&1
	curl POST $URLPOST -d chat_id=$IDC -d text="$MENSAJEA" >/dev/null 2>&1
	curl POST $URLPOST -d chat_id=$IDC -d text="ARCHIVO CON EL LOG DE EJECUCION" >/dev/null 2>&1
	curl -F document=@"/tmp/monitor/servicelog.txt" https://api.telegram.org/bot$TOKENA/sendDocument?chat_id=$IDC >/dev/null 2>&1
	curl POST $URLPOST -d chat_id=$IDC -d text="El chequeo y reporte ha sido generado en  `expr $end - $start` segundos." >/dev/null 2>&1
}
PROXY_SERVCREADOR() {
    echo "$MENSAJEA" >> /tmp/monitor/sended-reports.txt
	curl -U $USUARIOCLAVEPROXY -x $DEFAULTPROXY POST $URLPOST -d chat_id=$IDC -d text="REPORTE SERVICIOS CORPORATIVOS" >/dev/null 2>&1
	curl -U $USUARIOCLAVEPROXY -x $DEFAULTPROXY POST $URLPOST -d chat_id=$IDC -d text="$MENSAJEA" >/dev/null 2>&1
	curl -U $USUARIOCLAVEPROXY -x $DEFAULTPROXY POST $URLPOST -d chat_id=$IDC -d text="ARCHIVO CON EL LOG DE EJECUCION" >/dev/null 2>&1
	curl -U $USUARIOCLAVEPROXY -x $DEFAULTPROXY -F document=@"/tmp/monitor/servicelog.txt" https://api.telegram.org/bot$TOKENA/sendDocument?chat_id=$IDC >/dev/null 2>&1
	curl -U $USUARIOCLAVEPROXY -x $DEFAULTPROXY POST $URLPOST -d chat_id=$IDC -d text="El chequeo y reporte ha sido generado en  `expr $end - $start` segundos." >/dev/null 2>&1
}
mensaje_SERVGRUPO() {
    echo "$MENSAJEA" >> /tmp/monitor/sended-reports.txt
	curl POST $URLPOST -d chat_id=$IDA -d text="REPORTE SERVICIOS CORPORATIVOS" >/dev/null 2>&1
	curl POST $URLPOST -d chat_id=$IDA -d text="$MENSAJEA" >/dev/null 2>&1
	curl POST $URLPOST -d chat_id=$IDA -d text="El chequeo y reporte ha sido generado en  `expr $end - $start` segundos." >/dev/null 2>&1
}
PROXY_SERVGRUPO() {
    echo "$MENSAJEA" >> /tmp/monitor/sended-reports.txt
	curl -U $USUARIOCLAVEPROXY -x $DEFAULTPROXY POST $URLPOST -d chat_id=$IDA -d text="REPORTE SERVICIOS CORPORATIVOS" >/dev/null 2>&1
	curl -U $USUARIOCLAVEPROXY -x $DEFAULTPROXY POST $URLPOST -d chat_id=$IDA -d text="$MENSAJEA" >/dev/null 2>&1
	curl -U $USUARIOCLAVEPROXY -x $DEFAULTPROXY POST $URLPOST -d chat_id=$IDA -d text="El chequeo y reporte ha sido generado en  `expr $end - $start` segundos." >/dev/null 2>&1
}
########## MENSAJES SEDES Y EQUIPOS
mensaje_SEDCREADOR() {
    echo "$MENSAJEC" >> /tmp/monitor/sended-reports.txt
	curl POST $URLPOST -d chat_id=$IDC -d text="REPORTE CIAU Y SEDES EJE COSTERO" >/dev/null 2>&1
	curl POST $URLPOST -d chat_id=$IDC -d text="$MENSAJEC" >/dev/null 2>&1
	curl POST $URLPOST -d chat_id=$IDC -d text="El chequeo y reporte ha sido generado en  `expr $end - $start` segundos." >/dev/null 2>&1
}
PROXY_SEDCREADOR() {
    echo "$MENSAJEC" >> /tmp/monitor/sended-reports.txt
	curl -U $USUARIOCLAVEPROXY -x $DEFAULTPROXY POST $URLPOST -d chat_id=$IDC -d text="REPORTE CIAU Y SEDES EJE COSTERO" >/dev/null 2>&1
    curl -U $USUARIOCLAVEPROXY -x $DEFAULTPROXY POST $URLPOST -d chat_id=$IDC -d text="$MENSAJEC" >/dev/null 2>&1
	curl -U $USUARIOCLAVEPROXY -x $DEFAULTPROXY POST $URLPOST -d chat_id=$IDC -d text="El chequeo y reporte ha sido generado en  `expr $end - $start` segundos." >/dev/null 2>&1
	?chat_id=$IDC >/dev/null 2>&1
}
mensaje_SEDGRUPO() {
    echo "$MENSAJEC" >> /tmp/monitor/sended-reports.txt
	curl POST $URLPOST -d chat_id=$IDA -d text="REPORTE CIAU Y SEDES EJE COSTERO" >/dev/null 2>&1
	curl POST $URLPOST -d chat_id=$IDA -d text="$MENSAJEC" >/dev/null 2>&1
	curl POST $URLPOST -d chat_id=$IDA -d text="El chequeo y reporte ha sido generado en  `expr $end - $start` segundos." >/dev/null 2>&1
}
PROXY_SEDGRUPO() {
    echo "$MENSAJEC" >> /tmp/monitor/sended-reports.txt
	curl -U $USUARIOCLAVEPROXY -x $DEFAULTPROXY POST $URLPOST -d chat_id=$IDA -d text="REPORTE CIAU Y SEDES EJE COSTERO" >/dev/null 2>&1
	curl -U $USUARIOCLAVEPROXY -x $DEFAULTPROXY POST $URLPOST -d chat_id=$IDA -d text="$MENSAJEC" >/dev/null 2>&1
	curl -U $USUARIOCLAVEPROXY -x $DEFAULTPROXY POST $URLPOST -d chat_id=$IDA -d text="El chequeo y reporte ha sido generado en  `expr $end - $start` segundos." >/dev/null 2>&1
}
########## MENSAJES COMPLETOS SERVICIOS, SEDES y EQUIPOS SIN ENCABEZADOS
mensaje_COMPCREADOR() {
    echo "$MENSAJEA" >> /tmp/monitor/sended-reports.txt
    echo "$MENSAJEC" >> /tmp/monitor/sended-reports.txt
	curl POST $URLPOST -d chat_id=$IDC -d text="REPORTE COMPLETO SERVICIOS CORPORATIVOS Y SEDES" >/dev/null 2>&1
	curl POST $URLPOST -d chat_id=$IDC -d text="$MENSAJEA" >/dev/null 2>&1
	curl POST $URLPOST -d chat_id=$IDC -d text="$MENSAJEC" >/dev/null 2>&1
	curl POST $URLPOST -d chat_id=$IDC -d text="ARCHIVO CON EL LOG DE EJECUCION" >/dev/null 2>&1
	curl -F document=@"/tmp/monitor/servicelog.txt" https://api.telegram.org/bot$TOKENA/sendDocument?chat_id=$IDC >/dev/null 2>&1
	curl POST $URLPOST -d chat_id=$IDC -d text="El chequeo y reporte ha sido generado en  `expr $end - $start` segundos." >/dev/null 2>&1
}
PROXY_COMPCREADOR() {
    echo "$MENSAJEA" >> /tmp/monitor/sended-reports.txt
    echo "$MENSAJEC" >> /tmp/monitor/sended-reports.txt
	curl -U $USUARIOCLAVEPROXY -x $DEFAULTPROXY POST $URLPOST -d chat_id=$IDC -d text="REPORTE COMPLETO SERVICIOS CORPORATIVOS Y SEDES" >/dev/null 2>&1
	curl -U $USUARIOCLAVEPROXY -x $DEFAULTPROXY POST $URLPOST -d chat_id=$IDC -d text="$MENSAJEA" >/dev/null 2>&1
	curl -U $USUARIOCLAVEPROXY -x $DEFAULTPROXY POST $URLPOST -d chat_id=$IDC -d text="$MENSAJEC" >/dev/null 2>&1
	curl -U $USUARIOCLAVEPROXY -x $DEFAULTPROXY POST $URLPOST -d chat_id=$IDC -d text="ARCHIVO CON EL LOG DE EJECUCION" >/dev/null 2>&1
	curl -U $USUARIOCLAVEPROXY -x $DEFAULTPROXY -F document=@"/tmp/monitor/servicelog.txt" https://api.telegram.org/bot$TOKENA/sendDocument?chat_id=$IDC >/dev/null 2>&1
	curl -U $USUARIOCLAVEPROXY -x $DEFAULTPROXY POST $URLPOST -d chat_id=$IDC -d text="El chequeo y reporte ha sido generado en  `expr $end - $start` segundos." >/dev/null 2>&1
}
mensaje_COMPGRUPO() {
    echo "$MENSAJEA" >> /tmp/monitor/sended-reports.txt
    echo "$MENSAJEC" >> /tmp/monitor/sended-reports.txt
	curl POST $URLPOST -d chat_id=$IDA -d text="REPORTE COMPLETO SERVICIOS CORPORATIVOS Y SEDES" >/dev/null 2>&1
	curl POST $URLPOST -d chat_id=$IDA -d text="$MENSAJEA" >/dev/null 2>&1
	curl POST $URLPOST -d chat_id=$IDA -d text="$MENSAJEC" >/dev/null 2>&1
	curl POST $URLPOST -d chat_id=$IDA -d text="El chequeo y reporte ha sido generado en  `expr $end - $start` segundos." >/dev/null 2>&1
}
PROXY_COMPGRUPO() {
    echo "$MENSAJEA" >> /tmp/monitor/sended-reports.txt
    echo "$MENSAJEC" >> /tmp/monitor/sended-reports.txt
	curl -U $USUARIOCLAVEPROXY -x $DEFAULTPROXY POST $URLPOST -d chat_id=$IDA -d text="REPORTE COMPLETO SERVICIOS CORPORATIVOS Y SEDES" >/dev/null 2>&1
	curl -U $USUARIOCLAVEPROXY -x $DEFAULTPROXY POST $URLPOST -d chat_id=$IDA -d text="$MENSAJEA" >/dev/null 2>&1
	curl -U $USUARIOCLAVEPROXY -x $DEFAULTPROXY POST $URLPOST -d chat_id=$IDA -d text="$MENSAJEC" >/dev/null 2>&1
	curl -U $USUARIOCLAVEPROXY -x $DEFAULTPROXY POST $URLPOST -d chat_id=$IDA -d text="El chequeo y reporte ha sido generado en  `expr $end - $start` segundos." >/dev/null 2>&1
}

##############################################################################################################
########## SECCION REQUERIMIENTO

########## ENVIO MENSAJE DE SERVICIOS
mensaje_servicios() {
fechaMSG=$(date '+ %A, %B %d, %Y.')
horaMSG=$(date '+ %H:%M:%S')
source /tmp/monitor/data-services.txt
source /scripts/monitor/config/mensajes.conf
source /scripts/monitor/config/bot.conf
##############################################################################################################
### ESTA VARIABLE SE UTILIZA PARA EL ENVIO DE MENSAJES AL CREADOR DEL BOT

##############################################################################################################
### VERIFICA SI DEBUG ESTA ACTIVO Y SI ESTA CONECTADO SIN PROXY
if [ "$DEBUG" == "ACTIVADO" ]; then
	#DEBUG ACTIVADO
	verifica_telegram="https://core.telegram.org/bots"
	NON_PROXY=$(curl -s -o /dev/null -w "%{http_code}" $verifica_telegram)
	if [ $NON_PROXY -eq 200 ]; then
		mensaje_SERVCREADOR
		curl POST $URLPOST -d chat_id=$IDC -d text="ENVIANDO MENSAJE SIN PROXY" >/dev/null 2>&1
	else
		PROXY_SERVCREADOR
	fi
else
	#DEBUG DESACTIVADO
	verifica_telegram="https://core.telegram.org/bots"
	NON_PROXY=$(curl -s -o /dev/null -w "%{http_code}" $verifica_telegram)
	if [ $NON_PROXY -eq 200 ]; then
		mensaje_SERVGRUPO
		curl POST $URLPOST -d chat_id=$IDC -d text="ENVIANDO MENSAJE SIN PROXY" >/dev/null 2>&1
	else
		PROXY_SERVGRUPO
	fi
fi

}

########## ENVIO MENSAJE DE SEDES Y EQUIPOS
mensaje_sedes() {
fechaMSG=$(date '+ %A, %B %d, %Y.')
horaMSG=$(date '+ %H:%M:%S')
source /tmp/monitor/data-sites.txt
source /scripts/monitor/config/mensajes.conf
source /scripts/monitor/config/bot.conf
##############################################################################################################
### ESTA VARIABLE SE UTILIZA PARA EL ENVIO DE MENSAJES AL CREADOR DEL BOT

##############################################################################################################
### VERIFICA SI DEBUG ESTA ACTIVO Y SI ESTA CONECTADO SIN PROXY
if [ "$DEBUG" == "ACTIVADO" ]; then
	#DEBUG ACTIVADO
	verifica_telegram="https://core.telegram.org/bots"
	NON_PROXY=$(curl -s -o /dev/null -w "%{http_code}" $verifica_telegram)
	if [ $NON_PROXY -eq 200 ]; then
		mensaje_SEDCREADOR
		curl POST $URLPOST -d chat_id=$IDC -d text="ENVIANDO MENSAJE SIN PROXY" >/dev/null 2>&1
	else
		PROXY_SEDCREADOR
	fi
else
	#DEBUG DESACTIVADO
	verifica_telegram="https://core.telegram.org/bots"
	NON_PROXY=$(curl -s -o /dev/null -w "%{http_code}" $verifica_telegram)
	if [ $NON_PROXY -eq 200 ]; then
		mensaje_SEDGRUPO
		curl POST $URLPOST -d chat_id=$IDC -d text="ENVIANDO MENSAJE SIN PROXY" >/dev/null 2>&1
	else
		PROXY_SEDGRUPO
	fi
fi

}
########## ENVIO MENSAJE COMPLETO SERVICIOS, SEDES Y EQUIPOS
mensaje_completo() {
fechaMSG=$(date '+ %A, %B %d, %Y.')
horaMSG=$(date '+ %H:%M:%S')
source /tmp/monitor/data-services.txt
source /tmp/monitor/data-sites.txt
source /scripts/monitor/config/mensajes.conf
source /scripts/monitor/config/bot.conf
##############################################################################################################
### ESTA VARIABLE SE UTILIZA PARA EL ENVIO DE MENSAJES AL CREADOR DEL BOT

##############################################################################################################

### VERIFICA SI DEBUG ESTA ACTIVO Y SI ESTA CONECTADO SIN PROXY
if [ "$DEBUG" == "ACTIVADO" ]; then
	#DEBUG ACTIVADO
	verifica_telegram="https://core.telegram.org/bots"
	NON_PROXY=$(curl -s -o /dev/null -w "%{http_code}" $verifica_telegram)
	if [ $NON_PROXY -eq 200 ]; then
		mensaje_COMPCREADOR
		curl POST $URLPOST -d chat_id=$IDC -d text="ENVIANDO MENSAJE SIN PROXY" >/dev/null 2>&1
	else
		PROXY_COMPCREADOR
	fi
else
	#DEBUG DESACTIVADO
	verifica_telegram="https://core.telegram.org/bots"
	NON_PROXY=$(curl -s -o /dev/null -w "%{http_code}" $verifica_telegram)
	if [ $NON_PROXY -eq 200 ]; then
		mensaje_COMPGRUPO
		curl POST $URLPOST -d chat_id=$IDC -d text="ENVIANDO MENSAJE SIN PROXY" >/dev/null 2>&1
	else
		PROXY_COMPGRUPO
	fi
fi

}
########## ENVIO MENSAJE AL CREADOR DEL BOT PARA SEGUIMIENTO
mensaje_creador() {
fechaMSG=$(date '+ %A, %B %d, %Y.')
horaMSG=$(date '+ %H:%M:%S')
source /tmp/monitor/data-services.txt
source /tmp/monitor/data-sites.txt
source /scripts/monitor/config/mensajes.conf
source /scripts/monitor/config/bot.conf
##############################################################################################################
### ESTA VARIABLE SE UTILIZA PARA EL ENVIO DE MENSAJES AL CREADOR DEL BOT

##############################################################################################################
### VERIFICA SI DEBUG ESTA ACTIVO Y SI ESTA CONECTADO SIN PROXY
if [ "$DEBUG" == "ACTIVADO" ]; then
	#DEBUG ACTIVADO
	verifica_telegram="https://core.telegram.org/bots"
	NON_PROXY=$(curl -s -o /dev/null -w "%{http_code}" $verifica_telegram)
	if [ $NON_PROXY -eq 200 ]; then
		mensaje_COMPCREADOR
		curl POST $URLPOST -d chat_id=$IDC -d text="ENVIANDO MENSAJE SIN PROXY" >/dev/null 2>&1
	else
		PROXY_COMPCREADOR
	fi
else
	#DEBUG DESACTIVADO
	verifica_telegram="https://core.telegram.org/bots"
	NON_PROXY=$(curl -s -o /dev/null -w "%{http_code}" $verifica_telegram)
	if [ $NON_PROXY -eq 200 ]; then
		mensaje_COMPCREADOR
		curl POST $URLPOST -d chat_id=$IDC -d text="ENVIANDO MENSAJE SIN PROXY" >/dev/null 2>&1
	else
		PROXY_COMPCREADOR
	fi
fi

}
########## ENVIO MENSAJES CON TODA LA INFORMACION SIN ENCABEZADOS
MSGDEBUG_CREADOR() {
fechaMSG=$(date '+ %A, %B %d, %Y.')
horaMSG=$(date '+ %H:%M:%S')
source /tmp/monitor/data-services.txt
source /tmp/monitor/data-sites.txt
source /scripts/monitor/config/mensajes.conf
source /scripts/monitor/config/bot.conf
##############################################################################################################
### ESTA VARIABLE SE UTILIZA PARA EL ENVIO DE MENSAJES AL CREADOR DEL BOT

##############################################################################################################
### VERIFICA SI DEBUG ESTA ACTIVO Y SI ESTA CONECTADO SIN PROXY
if [ "$DEBUG" == "ACTIVADO" ]; then
	#DEBUG ACTIVADO
	verifica_telegram="https://core.telegram.org/bots"
	NON_PROXY=$(curl -s -o /dev/null -w "%{http_code}" $verifica_telegram)
	if [ $NON_PROXY -eq 200 ]; then
		mensajeDEBUGAB
		curl POST $URLPOST -d chat_id=$IDC -d text="ENVIANDO MENSAJE SIN PROXY" >/dev/null 2>&1
	else
		proxyDEBUGAB
	fi
else
	#DEBUG DESACTIVADO
	verifica_telegram="https://core.telegram.org/bots"
	NON_PROXY=$(curl -s -o /dev/null -w "%{http_code}" $verifica_telegram)
	if [ $NON_PROXY -eq 200 ]; then
		mensajeDEBUGAB
		curl POST $URLPOST -d chat_id=$IDC -d text="ENVIANDO MENSAJE SIN PROXY" >/dev/null 2>&1
	else
		proxyDEBUGAB
	fi
fi

}
MSGDEBUG_USUARIO() {
fechaMSG=$(date '+ %A, %B %d, %Y.')
horaMSG=$(date '+ %H:%M:%S')
source /tmp/monitor/data-services.txt
source /tmp/monitor/data-sites.txt
source /scripts/monitor/config/mensajes.conf
source /scripts/monitor/config/bot.conf
##############################################################################################################
### ESTA VARIABLE SE UTILIZA PARA EL ENVIO DE MENSAJES AL CREADOR DEL BOT

##############################################################################################################
### VERIFICA SI DEBUG ESTA ACTIVO Y SI ESTA CONECTADO SIN PROXY
if [ "$DEBUG" == "ACTIVADO" ]; then
	#DEBUG ACTIVADO
	verifica_telegram="https://core.telegram.org/bots"
	NON_PROXY=$(curl -s -o /dev/null -w "%{http_code}" $verifica_telegram)
	if [ $NON_PROXY -eq 200 ]; then
		mensajeDEBUGAB
		curl POST $URLPOST -d chat_id=$IDC -d text="ENVIANDO MENSAJE SIN PROXY" >/dev/null 2>&1
	else
		proxyDEBUGAB
	fi
else
	#DEBUG DESACTIVADO
	verifica_telegram="https://core.telegram.org/bots"
	NON_PROXY=$(curl -s -o /dev/null -w "%{http_code}" $verifica_telegram)
	if [ $NON_PROXY -eq 200 ]; then
		DEBUGAB_USERNPX
		curl POST $URLPOST -d chat_id=$IDA -d text="ENVIANDO MENSAJE SIN PROXY" >/dev/null 2>&1
	else
		DEBUGAB_USERPROXY
		#curl -U $USUARIOCLAVEPROXY -x $DEFAULTPROXY POST $URLPOST -d chat_id=$IDA -d text="ENVIANDO MENSAJE VIA PROXY" >/dev/null 2>&1
	fi
fi
}

##############################################################################################################
##############################################################################################################
################################ SECCION EJECUTA TODO
if [ -z "$1" ]; then
		clear
		echo "No Especifico el reporte que desea ejecutar"
		echo "Las opciones son: servicios - sedes - completo"
		echo "Opciones de debug: creador - debuga - debugb"
else
    case $1 in
        servicios) clear
            echo "#####################################################################################"
			echo "ATENCION!!! SE INICIARA PROCESO DE CHEQUEO DE SERVICIOS CORPORATIVOS"
			prepare_exec
			echo "########################################"
			echo "EJECUTANDO PROCESO DE CHEQUEO"
			echo "ESPERE POR FAVOR..."
			echo "########################################"
			#EJECUTA REVISION DE SERVICIOS ACA
			ejecuta_servicios
            genera_logs
            detect_proxy
			end=`date +%s`
			mensaje_servicios
			clean_ONEXIT
		;;
		sedes) clear
			echo "########################################################################################"
			echo "ATENCION!!! SE INICIARA PROCESO DE CHEQUEO SEDES (SOLO SEDES Y EQUIPOS DE COMUNICACION)"
			prepare_exec
			echo "########################################"
			echo "EJECUTANDO PROCESO DE CHEQUEO"
			echo "ESPERE POR FAVOR..."
			echo "########################################"
			#EJECUTA REVISION DE SEDES ACA
            ejecuta_sedes
            genera_logs
            detect_proxy
			end=`date +%s`
			mensaje_sedes
			clean_ONEXIT
		;;
		completo) clear
			echo "#####################################################################################"
			echo "ATENCION!!! SE INICIARA EL PROCESO DE CHEQUEO COMPLETO (SERVICIOS/SEDES)"
			prepare_exec
			echo "########################################"
			echo "EJECUTANDO PROCESO DE CHEQUEO"
			echo "ESPERE POR FAVOR..."
			echo "########################################"
			#EJECUTA REVISION COMPLETA ACA
			ejecuta_servicios
            ejecuta_sedes
            genera_logs
            detect_proxy
			end=`date +%s`
			mensaje_completo
			clean_ONEXIT
		;;
		creador) clear
			echo "#####################################################################################"
			echo "ATENCION!!! SE INICIARA EL PROCESO DE CHEQUEO COMPLETO (SERVICIOS/SEDES)"
			prepare_exec
			end=`date +%s`
			echo "########################################"
			echo "EJECUTANDO PROCESO DE CHEQUEO"
			echo "ESPERE POR FAVOR..."
			echo "########################################"
			ejecuta_servicios
            ejecuta_sedes
            genera_logs
            detect_proxy
			end=`date +%s`
			mensaje_creador
			clean_ONEXIT
		;;
		debuga) clear
			echo "#####################################################################################"
			echo "ATENCION!!! SE INICIARA EL PROCESO DE CHEQUEO COMPLETO (SERVICIOS/SEDES)"
			prepare_exec
			end=`date +%s`
			echo "########################################"
			echo "EJECUTANDO PROCESO DE CHEQUEO"
			echo "ESPERE POR FAVOR..."
			echo "########################################"
			ejecuta_servicios
            ejecuta_sedes
            genera_logs
            detect_proxy
			end=`date +%s`
			MSGDEBUG_CREADOR
			clean_ONEXIT
		;;
		debugb) clear
			echo "#####################################################################################"
			echo "ATENCION!!! SE INICIARA EL PROCESO DE CHEQUEO COMPLETO (SERVICIOS/SEDES)"
			prepare_exec
			end=`date +%s`
			echo "########################################"
			echo "EJECUTANDO PROCESO DE CHEQUEO"
			echo "ESPERE POR FAVOR..."
			echo "########################################"
			ejecuta_servicios
            ejecuta_sedes
            genera_logs
            detect_proxy
			end=`date +%s`
			MSGDEBUG_USUARIO
			clean_ONEXIT
		;;
		*)
	  clear
	  echo "NO SE ESCRIBIO UNA OPCION VALIDA"
	  echo "DEBE AGREGAR QUE TIPO DE REPORTE DESEA EJECUTAR"
	  echo "LAS OPCIONES SON: SERVICIOS - SEDES - COMPLETO"
		;;
		esac
	fi
	########################################################################################
		termina_procesos
		sudo chattr -i $LOCKFILE
		rm $LOCKFILE
		exit 1
	else
		echo "No existe el archivo de Configuracion"
		termina_procesos
		sudo chattr -i $LOCKFILE
		rm $LOCKFILE
		exit
fi

##############################################################################################################

################################## EJECUTA


echo "SE EJECUTA"
ejecuta_servicios
ejecuta_sedes
genera_logs
detect_proxy
end=`date +%s`
MSGDEBUG_CREADOR
clean_ONEXIT

###### ELIMINANDO BLOQUEO DE EJECUCION
sudo chattr -i /tmp/monitor.lock
sudo rm -rf /tmp/monitor.lock

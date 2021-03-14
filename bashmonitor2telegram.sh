#/bin/bash
###################################################################
######  #APLICATIVO PARA CHUEQUEO DE SERVICIOS CORPORATIVOS #######
###################################################################
# INICIA REVISION Y CARGA DE PARAMETROS DESDE ARCHIVO DE CONFIGURACION

file="monitor.conf"
if [ -f "$file" ]
then
source /opt/monitor/monitor.conf

### FUNCIONES 

termina_procesos() {
# Kill process
	kill $$P1=$! >/dev/null 2>&1
	kill $$P2=$! >/dev/null 2>&1
	kill $$P3=$! >/dev/null 2>&1
	kill $$P4=$! >/dev/null 2>&1
	kill $$P5=$! >/dev/null 2>&1
	kill $$P6=$! >/dev/null 2>&1
	kill $$P7=$! >/dev/null 2>&1
	kill $$P8=$! >/dev/null 2>&1
	kill $$P9=$! >/dev/null 2>&1
	kill $$P10=$! >/dev/null 2>&1
	kill $$P11=$! >/dev/null 2>&1
}

cargadatos_correo() {
echo "From: Jose A. Brito H. <britojq@gmail.com>" > /tmp/mail.txt
echo "To: Jose A. Brito H. <britojq@gmail.com>" >> /tmp/mail.txt
echo "Date: $date" >> /tmp/mail.txt
echo "Subject: Estatus de Servicio" >> /tmp/mail.txt
echo "A continuacion el estatus de los servicios," >> /tmp/mail.txt
echo "Fecha: $fecha , $hora" >> /tmp/mail.txt
echo "$MENSAJE">> /tmp/mail.txt
}

cargadatos_correob() {
#Configura aqui los datos de envio al correo B destino
echo "From:  Jose A. Brito H. <britojq@gmail.com>" > /tmp/mailb.txt
echo "To: nombre de usuario <correob@dominio.com>" >> /tmp/mailb.txt
echo "Date: $date" >> /tmp/mailb.txt
echo "Subject: Estatus de Servicio" >> /tmp/mailb.txt
echo "A continuacion el estatus de los servicios," >> /tmp/mailb.txt
echo "Date: $fecha , $hora" >> /tmp/mailb.txt
echo "$MENSAJE">> /tmp/mailb.txt
}

cargadatos_correoc() {
#Configura aqui los datos de envio al correo B destino
echo "From:  Jose A. Brito H. <britojq@gmail.com>" > /tmp/mailc.txt
echo "To: nombre de usuario <correob@dominio.com>" >> /tmp/mailc.txt
echo "Date: $date" >> /tmp/mailc.txt
echo "Subject: Estatus de Servicio" >> /tmp/mailc.txt
echo "A continuacion el estatus de los servicios," >> /tmp/mailc.txt
echo "Date: $fecha , $hora" >> /tmp/mailc.txt
echo "$MENSAJE">> /tmp/mailc.txt
}

#######################
# FIN DE SECCION ######
#######################


#########################
#### SERVICIO WEB A #####
#########################

verifica_SERVICIOA() {

#Verificando y limpiando archivo temporal 

file2="/tmp/headersA"
	if [ -f "$file" ]
		then
			rm /tmp/headersA >/dev/null 2>&1
			touch /tmp/headersA >/dev/null 2>&1
		else
			touch /tmp/headersA >/dev/null 2>&1
	fi

 #Inicia Proceso de Verificacion
 
 #Se verifica servidor haciendo ping de ser positivo se realiza siguiente comprobacion de servicio
  if ping -qc 20 $SERVICEAIP >/dev/null; then
	  echo "Servidor OTRS responde al ping verificando interfaz web"

	  # Utilizando sitio web de OTRS para verificar que servicio este disponible
	  # descarga sitio web
	  curl ${URLSERVICEA} -I -o /tmp/headersA -s
	  
	  #Lee encabezado del sitio web
	  VAR=$(cat /tmp/headersA | head -n 1 | cut '-d ' '-f2')
	  
	  # Obtiene codigo de respuesta
	  ## se espera 200 indicando sitio activo
		if [ -z "$VAR" ]
		 then
			STSERVICEAIP="❌ WEB-A - Servicio NO DISPONIBLE"
			echo 'STSERVICEAIP="❌ WEB-A - Servicio NO DISPONIBLE"' >> /tmp/temporal.txt
			echo "$STSERVICEAIP"
		elif [[ $VAR -gt 200 ]]
		 then
			STSERVICEAIP="❌ WEB-A - Servicio NO DISPONIBLE"
			echo 'STSERVICEAIP="❌ WEB-A - Servicio NO DISPONIBLE"' >> /tmp/temporal.txt
			echo "$STSERVICEAIP"
		 else
			STSERVICEAIP="✅ WEB-A"
			echo 'STSERVICEAIP="✅ WEB-A"' >> /tmp/temporal.txt
			echo "$STSERVICEAIP"
		fi
else
    echo "Servidor NO responde al ping No se verifico Servicio"
	STSERVICEAIP="❌ WEB-A - Servicio NO DISPONIBLE"
	echo 'STSERVICEAIP="❌ WEB-A - Servicio NO DISPONIBLE"' >> /tmp/temporal.txt
	echo "$STSERVICEAIP"
	
fi

}
#######################
# FIN DE SECCION ######
#######################


#########################
####  SERVICIO WEB B ####
#########################

verifica_SERVICIOB() {

#Verificando y limpiando archivo temporal 

file2="/tmp/headersB"
	if [ -f "$file" ]
		then
			rm /tmp/headersB >/dev/null 2>&1
			touch /tmp/headersB >/dev/null 2>&1
		else
			touch /tmp/headersB >/dev/null 2>&1
	fi

 #Inicia Proceso de Verificacion
 
 #Se verifica servidor haciendo ping de ser positivo se realiza siguiente comprobacion de servicio
  if ping -qc 20 $SERVICEBIP >/dev/null; then
	  echo "Servidor OTRS responde al ping verificando interfaz web"

	  # Utilizando sitio web de OTRS para verificar que servicio este disponible
	  # descarga sitio web
	  curl ${URLSERVICEB} -I -o /tmp/headersA -s
	  
	  #Lee encabezado del sitio web
	  VAR=$(cat /tmp/headersB | head -n 1 | cut '-d ' '-f2')
	  
	  # Obtiene codigo de respuesta
	  ## se espera 200 indicando sitio activo
		if [ -z "$VAR" ]
		 then
			STSERVICEBIP="❌ WEB-B - Servicio NO DISPONIBLE"
			echo 'STSERVICEBIP="❌ WEB-B - Servicio NO DISPONIBLE"' >> /tmp/temporal.txt
			echo "$STSERVICEBIP"
		elif [[ $VAR -gt 200 ]]
		 then
			STSERVICEBIP="❌ WEB-B - Servicio NO DISPONIBLE"
			echo 'STSERVICEBIP="❌ WEB-B - Servicio NO DISPONIBLE"' >> /tmp/temporal.txt
			echo "$STSERVICEBIP"
		 else
			STSERVICEAIP="✅ WEB-B"
			echo 'STSERVICEBIP="✅ WEB-B"' >> /tmp/temporal.txt
			echo "$STSERVICEBIP"
		fi
else
    echo "Servidor NO responde al ping No se verifico Servicio"
	STSERVICEBIP="❌ WEB-B - Servicio NO DISPONIBLE"
	echo 'STSERVICEBIP="❌ WEB-B - Servicio NO DISPONIBLE"' >> /tmp/temporal.txt
	echo "$STSERVICEBIP"
	
fi

}
#######################
# FIN DE SECCION ######
#######################


#######################
### DNS 1 #############
#######################
verifica_DNS1() {

#Inicia revision de Servicios

#Se verifica servidor haciendo ping de ser positivo se realiza siguiente comprobacion de servicio
if ping -qc 20 $IPDNS1 >/dev/null; then
		echo "Servidor DNS responde al ping verificando servicio"
		STipdns1="✅ SERVIDOR DNS - ACTIVO"
		echo 'STipdns1="✅ SERVIDOR DNS - ACTIVO"' >> /tmp/temporal.txt
		echo "$STipdns1"
else
    echo "Servidor NO responde al ping No se verifico Servicio"
    STipdns1="❌ SERVIDOR DNS - Servicio NO DISPONIBLE"
    echo 'STipdns1="❌ SERVIDOR DNS - Servicio NO DISPONIBLE"' >> /tmp/temporal.txt
	echo "$STipdns1"
	
fi

}
###################################################################
####################### FIN DE SECCION ############################
###################################################################


#######################
### DNS 2 #############
#######################
verifica_DNS2() {

#Inicia revision de Servicios

#Se verifica servidor haciendo ping de ser positivo se realiza siguiente comprobacion de servicio
if ping -qc 20 $IPDNS2 >/dev/null; then
		echo "Servidor DNS responde al ping verificando servicio"
		STipdns2="✅ SERVIDOR DNS - ACTIVO"
		echo 'STipdns2="✅ SERVIDOR DNS - ACTIVO"' >> /tmp/temporal.txt
		echo "$STipdns2"
else
    echo "Servidor NO responde al ping No se verifico Servicio"
    STipdns2="❌ SERVIDOR DNS - Servicio NO DISPONIBLE"
    echo 'STipdns2="❌ SERVIDOR DNS - Servicio NO DISPONIBLE"' >> /tmp/temporal.txt
	echo "$STipdns2"
	
fi

}
#######################
#### FIN DE SECCION ###
#######################


########################
## SERVICIO XXXXXXXX ###
########################

verifica_SERVICIOX() {
#Inicia verificacion de servicios

#Se verifica servidor haciendo ping de ser positivo se realiza siguiente comprobacion de servicio
if ping -qc 20 $IPSERVICIOX >/dev/null; then
	echo "Servidor XXXXXXX responde al ping verificando servicio"
	STSERVICIOX="✅ Servidor XXXXXXX - DISPONIBLE"
	echo 'STSERVICIOX="✅ Servidor XXXXXXX - DISPONIBLE"' >> /tmp/temporal.txt
	echo "Solo se verifico usando ping"
	echo "$STSERVICIOX"
else
    echo "Servidor NO responde al ping No se verifico Servicio"
	STSERVICIOX="❌ SERVIDOR XXXXXXX - Servicio NO DISPONIBLE"
	echo 'STSERVICIOX="❌ SERVIDOR XXXXXXX - Servicio NO DISPONIBLE"' >> /tmp/temporal.txt
	echo "$STSERVICIOX"
	
fi

}
#######################
#### FIN DE SECCION ###
#######################


#######################
#####  LDAP ###########
#######################

verifica_LDAP() {

#Verificando y limpiando archivo temporal 
file3="/tmp/ldapheader"
	if [ -f "$file3" ]
		then
			rm /tmp/ldapheader
			touch /tmp/ldapheader
		else
			touch /tmp/ldapheader
	fi

#Inicia verificacion de servicios

#Se verifica servidor haciendo ping de ser positivo se realiza siguiente comprobacion de servicio
if ping -qc 20 $IPLDAP >/dev/null; then
	echo "Servidor LDAP responde al ping verificando servicio"
	# sitio web a verificar
	ldapsearch -x -h $IPLDAURL -p $IPLDAPPORT -b "ou=users,ou=*,dc=corpoelec,dc=gob,dc=ve" > ldapheader 
	
	# procesa el archivo
	VAR2=$(cat ldapheader  | tail -n 1 )
    
    # Obtiene codigo de respuesta
    ## Se espera respuesta: # numResponses: 1 de no ser asi indicara servicio no disponible
		
		if [ "$VAR2" == "# numResponses: 1" ]; then
			echo "SERVICIO LDAP ACTIVO"
			STLDAP="✅ Servidor LDAP - DISPONIBLE"
			echo 'STLDAP="✅ Servidor LDAP - DISPONIBLE"' >> /tmp/temporal.txt
			echo "$STLDAP"
 
		else
			STLDAP=="❌ Servidor LDAP - Servicio NO DISPONIBLE"
			echo 'STLDAP=="❌ Servidor LDAP - Servicio NO DISPONIBLE"' >> /tmp/temporal.txt
			echo "$STLDAP"
			
		fi

	else
		echo "Servidor NO responde al ping No se verifico Servicio"
		STLDAP="❌ SERVIDOR LDAP - Servicio NO DISPONIBLE"
		echo 'STLDAP="❌ SERVIDOR LDAP - Servicio NO DISPONIBLE"' >> /tmp/temporal.txt
		echo "$STLDAP"
		
	fi

}
#######################
#### FIN DE SECCION ###
#######################

###################################################################
####################### CORREO T4 #################################
###################################################################
verifica_SMTP() {
#Inicia verificacion de servicios

#Se verifica servidor haciendo ping de ser positivo se realiza siguiente comprobacion de servicio
if ping -qc 20 $IPCORREOSMTP >/dev/null; then
	echo "Servidor SMTP responde al ping verificando servicio"
	STSMTP="✅ Servidor SMTP - DISPONIBLE"
	echo 'STSMTP="✅ Servidor SMTP - DISPONIBLE"' >> /tmp/temporal.txt
	echo "$STSMTP"
else
    echo "Servidor NO responde al ping No se verifico Servicio"
	STSMTP="❌ SERVIDOR SMTP - Servicio NO DISPONIBLE"
	echo 'STSMTP="❌ SERVIDOR SMTP - Servicio NO DISPONIBLE"' >> /tmp/temporal.txt
	echo "$STSMTP"
	
fi

}
#######################
#### FIN DE SECCION ###
#######################

########################
# Squid Dansguardian A #
########################

verifica_PROXYA() {

#Verificando y limpiando archivo temporal 
file2="/tmp/headerspA"
	if [ -f "$file" ]
		then
			rm /tmp/headerspA >/dev/null 2>&1
			touch /tmp/headerspA >/dev/null 2>&1
		else
			touch /tmp/headerspA >/dev/null 2>&1
	fi

#Inicia verificacion de servicio

#Se verifica servidor haciendo ping de ser positivo se realiza siguiente comprobacion de servicio
if ping -qc 20 $PROXYIPA >/dev/null; then
  echo "Servidor Dansguardian A responde al ping verificando Conexion a Internet"
  
  # Verificando si el proxy se usar para navegar por internet
  curl -U ${usuarioclave} -x ${ipproxypuertoA} ${url} -I -o /tmp/headerspcar -s  
  # descarga archivo
  VAR=$(cat /tmp/headerspA | head -n 1 | cut '-d ' '-f2')
  # Obtiene codigo de respuesta
  ## se espera 200 indicando sitio activo
	if [ -z "$VAR" ]
	 then
		STSPROXYIPA="❌ PROXY A - INTENET NO DISPONIBLE"
		echo 'STSPROXYIPA="❌ PROXY A - INTENET NO DISPONIBLE"' >> /tmp/temporal.txt
		echo "$STSPROXYIPA"
	elif [[ $VAR -gt 200 ]]
	 then
		STSPROXYIPA="❌ PROXY A - INTENET NO DISPONIBLE"
		echo 'STSPROXYIPA="❌ PROXY A - INTENET NO DISPONIBLE"' >> /tmp/temporal.txt
		echo "$STSPROXYIPA"
	 else
		STSPROXYIPA="✅ PROXY A - Servicio DISPONIBLE"
		echo 'STSPROXYIPA="✅ PROXY A - Servicio DISPONIBLE"' >> /tmp/temporal.txt
		PROXYCAROK="CAROK"
		echo 'PROXYAOK="PROXYAOK"' >> /tmp/temporal.txt
		echo "$STSPROXYIPA"
	fi
else
    echo "Servidor NO responde al ping No se verifica Servicio"
	STSPROXYIPA="❌ PROXY A - INTENET NO DISPONIBLE"
	echo 'STSPROXYIPA="❌ A - INTENET NO DISPONIBLE"' >> /tmp/temporal.txt
	echo "$STSPROXYIPA"
	
fi

}
#######################
#### FIN DE SECCION ###
#######################


########################
# Squid Dansguardian B #
########################

verifica_PROXYB() {

#Verificando y limpiando archivo temporal 
file2="/tmp/headerspB"
	if [ -f "$file" ]
		then
			rm /tmp/headerspB >/dev/null 2>&1
			touch /tmp/headerspB >/dev/null 2>&1
		else
			touch /tmp/headerspB >/dev/null 2>&1
	fi

#Inicia verificacion de servicio

#Se verifica servidor haciendo ping de ser positivo se realiza siguiente comprobacion de servicio
if ping -qc 20 $PROXYIPA >/dev/null; then
  echo "Servidor Dansguardian B responde al ping verificando Conexion a Internet"
  
  # Verificando si el proxy se usar para navegar por internet
  curl -U ${usuarioclave} -x ${ipproxypuertoB} ${url} -I -o /tmp/headerspcar -s  
  # descarga archivo
  VAR=$(cat /tmp/headerspA | head -n 1 | cut '-d ' '-f2')
  # Obtiene codigo de respuesta
  ## se espera 200 indicando sitio activo
	if [ -z "$VAR" ]
	 then
		STSPROXYIPB="❌ PROXY B - INTENET NO DISPONIBLE"
		echo 'STSPROXYIPB="❌ PROXY B - INTENET NO DISPONIBLE"' >> /tmp/temporal.txt
		echo "$STSPROXYIPB"
	elif [[ $VAR -gt 200 ]]
	 then
		STSPROXYIPB="❌ PROXY B - INTENET NO DISPONIBLE"
		echo 'STSPROXYIPB="❌ PROXY B - INTENET NO DISPONIBLE"' >> /tmp/temporal.txt
		echo "$STSPROXYIPB"
	 else
		STSPROXYIPB="✅ PROXY B - Servicio DISPONIBLE"
		echo 'STSPROXYIPB="✅ PROXY B - Servicio DISPONIBLE"' >> /tmp/temporal.txt
		PROXYBOK="CAROK"
		echo 'PROXYBOK="PROXYBOK"' >> /tmp/temporal.txt
		echo "$STSPROXYIPB"
	fi
else
    echo "Servidor NO responde al ping No se verifica Servicio"
	STSPROXYIPA="❌ PROXY A - INTENET NO DISPONIBLE"
	echo 'STSPROXYIPA="❌ A - INTENET NO DISPONIBLE"' >> /tmp/temporal.txt
	echo "$STSPROXYIPA"
	
fi

}
#######################
#### FIN DE SECCION ###
#######################


#######################
#### DNS GOOGLE #######
#######################

verifica_GOOGLE() {

# ESTE ESPACIO ES UTILIZADO PARA DETERMINAR SI EL COMANDO SE EJECUTA EN UNA PC CON CONEXION DIRECTA A INTERNET O ESTA DETRAS DE UN PROXY
#Inicia
#Se verifica servidor haciendo ping de ser positivo se realiza siguiente comprobacion de servicio
if ping -qc 20 $NOPROXYIP >/dev/null; then
		echo "DNS GOOGLE responde al ping"
		STNOPROXYIP="✅ DNS GOOGLE - DISPONIBLE"
		NOPROXYIPOK="GOOGLEOK"
		echo 'NOPROXYIPOK="GOOGLEOK"' >> /tmp/temporal.txt
		echo "$STNOPROXYIP"
else
    echo "DNS GOOGLE NO RESPONDE al ping"
	STNOPROXYIP="❌ DNS GOOGLE - Servicio NO DISPONIBLE"
	echo "$STNOPROXYIP"
	
fi

}
#######################
#### FIN DE SECCION ###
#######################

###################################################################
####### FINALIZA SEGMENTO DE FUNCIONES PARA MULTI PROCESOS ########
###################################################################


###################################################################
#######################  INICIA PROCESO   #########################
###################################################################
# borrando archivo temporal
rm /tmp/temporal.txt >/dev/null 2>&1

# Iniciando multi ejecucion de revision
verifica_SERVICIOA &
P1=$!
verifica_SERVICIOB &
P2=$!
verifica_DNS1 &
P3=$!
verifica_DNS2 &
P4=$!
verifica_SERVICIOX &
P5=$!
verifica_LDAP &
P6=$!
verifica_SMTP &
P7=$!
verifica_PROXYA &
P8=$!
verifica_PROXYB &
P9=$!
verifica_GOOGLE &
P10=$!

#Mientras se realiza en Background el chequeo de servicios se limpia la pantalla
clear
echo "EJECUTANDO PROCESO DE CHEQUEO"
echo "ESPERE POR FAVOR..."

# Esperando que culminen los procesos simultaneos 
wait $P1 $P2 $P3 $P4 $P5 $P6 $P7 $P8 $P9 $P10

#Iniciando la construccion del reporte usando diferentes metodos de captura de datos generados
echo "INICIANDO PROCESO PARA GENERAR REPORTES"


filemessage="mensaje.conf"
if [ -f "$file" ]
then
source mensaje.conf
source /tmp/temporal.txt

###################################################################
########################### INICIA REPORTE ########################
###################################################################
#Capturando Fecha para el reporte
fecha=$(date '+ %A, %B %d, %Y.')
hora=$(date '+ %H:%M:%S')


###################################################################
#### INICIA DETECION DE METODO DE CONEXION PARA ENVIAR REPORTE ####
###################################################################
#####
# Esta linea se usa para configuracion de pruebas directas con mensajes exclusivos para mi comentar los envios a grupo
IDC="38914901"
#####

	if [ "$NOPROXYIPOK" == "GOOGLEOK" ]; then
		echo "USANDO METODO SIN PROXY"
		echo "ENVIANDO REPORTE SIN USAR PROXY"
		curl  -s -X POST ${URLPOST} -d chat_id=$IDB -d text="$MENSAJE"
		curl  -s -X POST ${URLPOST} -d chat_id=$IDB -d text="SE DETECTO UBICACION DESCONOCIDA"
		curl  -s -X POST ${URLPOST} -d chat_id=$IDB -d text="AL NO ESTAR EN LA RED CORPORATIVA ES POSIBLE QUE EL ESTATUS DE LOS SERVICIOS APAREZCA SIN CONEXION"
		
		###################################################################
		#linea de pruebas agregada para enviar mensajes directos a mi desactivar las demas y usar esta para pruebas
		#curl -s -X POST $URLPOST -d chat_id=$IDC -d text="$MENSAJE" >/dev/null 2>&1
		#fin linea de prueba
		###################################################################
		
	elif [ "$PROXYAOK" == "PROXYAOK" ]; then
    	echo "METODO CON PROXY SELECIONADO"
		echo "USANDO PROXY A PARA ENVIAR REPORTE"
		curl -U ${usuarioclave} -x ${ipproxypuertocar} POST ${URLPOST} -d chat_id=$IDB -d text="PRUEBA INTEGRACION AL S.O"  >/dev/null 2>&1
	    curl -U ${usuarioclave} -x ${ipproxypuertocar} POST ${URLPOST} -d chat_id=$IDB -d text="EJECUTANDO SERVICIO VIA CRON"  >/dev/null 2>&1
		curl -U ${usuarioclave} -x ${ipproxypuertocar} POST ${URLPOST} -d chat_id=$IDB -d text="$MENSAJE"  >/dev/null 2>&1
		curl -U ${usuarioclave} -x ${ipproxypuertocar} POST ${URLPOST} -d chat_id=$IDB -d text="SE UTILIZO EL PROXY CARABOBO PARA ENVIAR REPORTE" >/dev/null 2>&1
		echo "CARGANDO DATOS DE CORREO"
		cargadatos_correo
		cargadatos_correob
		echo "ENVIANDO REPORTE POR CORREO"
		curl smtp://servidordecorreo.com --mail-from "$sender" --mail-rcpt "$rcptA" --upload-file /tmp/mail.txt
		curl smtp://servidordecorreo.com --mail-from "$sender" --mail-rcpt "$rcptB" --upload-file /tmp/mailb.txt
		curl smtp://servidordecorreo.com --mail-from "$sender" --mail-rcpt "$rcptC" --upload-file /tmp/mailc.txt
		
		###################################################################
		#linea de pruebas agregada para enviar mensajes directos a mi desactivar las demas y usar esta para pruebas
		#curl -U ${usuarioclave} -x ${ipproxypuertocar} POST ${URLPOST} -d chat_id=$IDC -d text="$MENSAJE" >/dev/null 2>&1
		#fin linea de prueba
		###################################################################


	elif [ "$PROXYBOK" == "PROXYBOK" ]; then
		echo "METODO CON PROXY SELECIONADO"
		echo "USANDO PROXY B PARA ENVIAR REPORTE"
		curl -U ${usuarioclave} -x ${ipproxypuertovs} POST ${URLPOST} -d chat_id=$IDB -d text="PRUEBA INTEGRACION AL S.O"  >/dev/null 2>&1
		curl -U ${usuarioclave} -x ${ipproxypuertovs} POST ${URLPOST} -d chat_id=$IDB -d text="EJECUTANDO SERVICIO VIA CRON"  >/dev/null 2>&1
		curl -U ${usuarioclave} -x ${ipproxypuertovs} POST ${URLPOST} -d chat_id=$IDB -d text="$MENSAJE"  >/dev/null 2>&1
		curl -U ${usuarioclave} -x ${ipproxypuertovs} POST ${URLPOST} -d chat_id=$IDB -d text="SE UTILIZO EL PROXY VALLE SECO PARA ENVIAR REPORTE" >/dev/null 2>&1
		echo "CARGANDO DATOS DE CORREO"
		cargadatos_correo
		cargadatos_correob
		echo "ENVIANDO REPORTE POR CORREO"
		curl smtp://servidordecorreo.com --mail-from "$sender" --mail-rcpt "$rcptA" --upload-file /tmp/mail.txt
		curl smtp://servidordecorreo.com --mail-from "$sender" --mail-rcpt "$rcptB" --upload-file /tmp/mailb.txt
		curl smtp://servidordecorreo.com --mail-from "$sender" --mail-rcpt "$rcptC" --upload-file /tmp/mailc.txt
		
		###################################################################
		#linea de pruebas agregada para enviar mensajes directos a mi desactivar las demas y usar esta para pruebas
		#curl -U ${usuarioclave} -x ${ipproxypuertovs} POST ${URLPOST} -d chat_id=$IDC -d text="$MENSAJE" >/dev/null 2>&1
		#fin linea de prueba
		###################################################################
	else
		echo "NO HAY CONEXION A INTERNET"
		echo "NO PUEDO ENVIAR EL MENSAJE"
	fi
else
	echo "No existe el archivo de Configuracion"
	exit
fi
#	echo "Finalizando procesos en segundo plano"
#	termina_procesos
else
	echo "No existe el archivo de Configuracion"
fi
echo "Finalizando procesos en segundo plano"
	termina_procesos
	echo "Vaciando archivos Temporales"
	rm /tmp/temporal.txt >/dev/null 2>&1
	rm /tmp/mail.txt >/dev/null 2>&1
	rm /tmp/mailb.txt >/dev/null 2>&1
## HELPER 
### >/dev/null 2>&1




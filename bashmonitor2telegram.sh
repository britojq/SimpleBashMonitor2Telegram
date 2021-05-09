#/bin/bash

####################################################################################################
#
#	                                BASHMONITOR2TELEGRAM
#
#     License: MIT License https://github.com/britojq/SimpleBashMonitor2Telegram/blob/main/LICENSE
#      Author: Jose A. Brito H. (britojab:britojq), britojab.com.ve
#		Copyright (c) 2021 Jose A. Brito H.
#
###############################################################################

start=`date +%s`
proceso_inicial() {
#Apaga y enciende el monitor verificando asi poder capturar la pantalla sin novedad al momento de la ejecucion
sleep 1 && xset dpms force standby && sleep 5 && xset dpms force on
}
Xfile="/scripts/monitoreo/monitor.conf"
if [ -f "$Xfile" ]
then
source /scripts/monitoreo/monitor.conf
termina_procesos() {
# Kill process
	kill $P1=$! >/dev/null 2>&1
	kill $P2=$! >/dev/null 2>&1
	kill $P3=$! >/dev/null 2>&1
	kill $P4=$! >/dev/null 2>&1
	kill $PX1 >/dev/null 2>&1
	kill $PX2 >/dev/null 2>&1
	kill $PX3 >/dev/null 2>&1
	kill $PX4 >/dev/null 2>&1
	
}
#################################################################################
################### SECCION DE CHEQUEO (CLASIFICADO POR HOSTS ###################
######## HOST (A)
verifica_HOSTSA() {
if ping -qc 20 $IPHOSTSA >/dev/null; then
	case $TIPOSERVA in
	  WEB) #"APLICATIVO WEB"
		  fileA="/tmp/headersWA"
			if [ -f "$fileA" ]
				then
					rm /tmp/headersWA >/dev/null 2>&1
					touch /tmp/headersWA >/dev/null 2>&1
				else
					touch /tmp/headersWA >/dev/null 2>&1
			fi
			curl -k ${HOSTSA} -I -o /tmp/headersWA -s
			VARA=$(cat /tmp/headersWA | head -n 1 | cut '-d ' '-f2')
				if [ -z "$VARA" ]
				 then
					echo "STHOSTA='$ERRORA'" >> /tmp/temporal.txt
				elif [[ $VARA -gt $HEADERWEBSA ]]
				 then
					echo "STHOSTA='$ERRORA'" >> /tmp/temporal.txt
				 else
					echo "STHOSTA='$NORMALA'" >> /tmp/temporal.txt
				fi
		;;
	  DNS) #"SERVIDOR DNS" 
		fileA="/tmp/headersDNSA"
			if [ -f "$fileA" ]
				then
					rm /tmp/headersDNSA >/dev/null 2>&1
					touch /tmp/headersDNSA >/dev/null 2>&1
				else
					touch /tmp/headersDNSA >/dev/null 2>&1
			fi
		RESPDNSA=";; Got answer:"
		VARA=$(dig @$IPHOSTSA intranet.corpoelec.com.ve | grep -i "got")
			if [ -z "$VARA" ]
			 then
				echo "STHOSTA='$ERRORA'" >> /tmp/temporal.txt
				echo "$VARA" >> /tmp/headersDNSA
			elif [[ $VARA == $RESPDNSA ]]
			 then
				echo "STHOSTA='$NORMALA'" >> /tmp/temporal.txt
				echo "$VARA" >> /tmp/headersDNSA
			 else
				echo "STHOSTA='$ERRORA'" >> /tmp/temporal.txt
				echo "$VARA" >> /tmp/headersDNSA
			fi
	  ;;
	  PROXY) #"SERVIDOR PROXY" 
		fileA="/tmp/headersPA"
		if [ -f "$fileA" ]
			then
				rm /tmp/headersPA >/dev/null 2>&1
				touch /tmp/headersPA >/dev/null 2>&1
			else
				touch /tmp/headersPA >/dev/null 2>&1
		fi
		curl -U ${USUARIOCLAVEPROXY} -x ${IPPROXYPUERTOA} ${URLCONTROL} -I -o /tmp/headersPA -s  
		VARA=$(cat /tmp/headersPA | head -n 1 | cut '-d ' '-f2')
			if [ -z "$VARA" ]
			 then
				echo "STHOSTA='$ERRORA'" >> /tmp/temporal.txt
			elif [[ $VARA -gt 200 ]]
			 then
				echo "STHOSTA='$ERRORA'" >> /tmp/temporal.txt
			 else
				echo "STHOSTA='$NORMALA'" >> /tmp/temporal.txt
				echo 'PROXYA="OK"' >> /tmp/temporal.txt
			fi
	  ;;
	  LDAP) #"SERVIDOR LDAP" 
	  fileA="/tmp/ldapheaderA"
		if [ -f "$fileA" ]
			then
				rm /tmp/ldapheaderA
				touch /tmp/ldapheaderA
			else
				touch /tmp/ldapheaderA
		fi
		ldapsearch -x -h $IPHOSTSA -p $IPLDAPPORTA -b "ou=users,ou=*,dc=corpoelec,dc=gob,dc=ve" > /tmp/ldapheaderA
		VARA=$(cat /tmp/ldapheaderA  | tail -n 1 )
			if [ "$VARA" == "# numResponses: 1" ]; then
				echo "STHOSTA='$NORMALA'" >> /tmp/temporal.txt
			else
				echo "STHOSTA='$ERRORA'" >> /tmp/temporal.txt
			fi
	  ;;
	  CUPS) #"SERVIDOR CUPS (SERVIDOR DE IMPRESION)" 
	    VARCUPSA=$(lpstat -h $IPCUPSPUERTOA -t -o | grep -i "Ready to print" | tail -n 1 | cut '-d ' '-f1')
			if [ -z "$VARCUPSA" ]; then
				echo "$VARCUPSA" >> /tmp/headerscupsA
			elif [ "$VARCUPSA" == "	Ready" ]; then
				echo "STHOSTA='$NORMALA'" >> /tmp/temporal.txt
				echo "$VARCUPSA" >> /tmp/headerscupsA
			else
				echo "STHOSTA='$ERRORA'" >> /tmp/temporal.txt
				echo "$VARCUPSA" >> /tmp/headerscupsA
			fi
	  ;;
	  DHCP) #"SERVIDOR DHCP"
		echo "STHOSTA='$NORMALA'" >> /tmp/temporal.txt
	  ;;
	  SMTP) #"SERVIDOR CORREO SMTP" 
		echo "STHOSTA='$NORMALA'" >> /tmp/temporal.txt
	  ;;
	  SAMBA) #"SERVIDOR SAMBA (RECURSOS COMPARTIDOS LINUX)" 
		echo "STHOSTA='$NORMALA'" >> /tmp/temporal.txt
	  ;;
	  COMPWIN) #"SERVIDOR COMPWIN (RECURSOS COMPARTIDOS WINDOWS)" 
		echo "STHOSTA='$NORMALA'" >> /tmp/temporal.txt
	  ;;
	  *) #"CUALQUIER OTRO NO CONFIGURADO" 
		echo "STHOSTA='$NORMALA'" >> /tmp/temporal.txt
	  ;;
	esac
else
	#echo "NO RESPONDE AL PING" >> /tmp/temporal.txt
	echo "STHOSTA='$ERRORA'" >> /tmp/temporal.txt
fi
}
######## HOST (B)
verifica_HOSTSB() {
if ping -qc 20 $IPHOSTSB >/dev/null; then
	case $TIPOSERVB in
	  WEB) #"APLICATIVO WEB"
		  fileB="/tmp/headersWB"
			if [ -f "$fileB" ]
				then
					rm /tmp/headersWB >/dev/null 2>&1
					touch /tmp/headersWB >/dev/null 2>&1
				else
					touch /tmp/headersWB >/dev/null 2>&1
			fi
			curl -k ${HOSTSB} -I -o /tmp/headersWB -s
			VARB=$(cat /tmp/headersWB | head -n 1 | cut '-d ' '-f2')
				if [ -z "$VARB" ]
				 then
					echo "STHOSTB='$ERRORB'" >> /tmp/temporal.txt
				elif [[ $VARB -gt $HEADERWEBSB ]]
				 then
					echo "STHOSTB='$ERRORB'" >> /tmp/temporal.txt
				 else
					echo "STHOSTB='$NORMALB'" >> /tmp/temporal.txt
				fi
		;;
	  DNS) #"SERVIDOR DNS" 
		fileB="/tmp/headersDNSB"
			if [ -f "$fileB" ]
				then
					rm /tmp/headersDNSB >/dev/null 2>&1
					touch /tmp/headersDNSB >/dev/null 2>&1
				else
					touch /tmp/headersDNSB >/dev/null 2>&1
			fi
		RESPDNSB=";; Got answer:"
		VARB=$(dig @$IPHOSTSB intranet.corpoelec.com.ve | grep -i "got")
			if [ -z "$VARB" ]
			 then
				echo "STHOSTB='$ERRORB'" >> /tmp/temporal.txt
				echo "$VARB" >> /tmp/headersDNSB
			elif [[ $VARB == $RESPDNSB ]]
			 then
				echo "STHOSTB='$NORMALB'" >> /tmp/temporal.txt
				echo "$VARB" >> /tmp/headersDNSB
			 else
				echo "STHOSTB='$ERRORB'" >> /tmp/temporal.txt
				echo "$VARB" >> /tmp/headersDNSB
			fi
	  ;;
	  PROXY) #"SERVIDOR PROXY" 
		fileB="/tmp/headersPB"
		if [ -f "$fileB" ]
			then
				rm /tmp/headersPB >/dev/null 2>&1
				touch /tmp/headersPB >/dev/null 2>&1
			else
				touch /tmp/headersPB >/dev/null 2>&1
		fi
		curl -U ${USUARIOCLAVEPROXY} -x ${IPPROXYPUERTOB} ${URLCONTROL} -I -o /tmp/headersPB -s  
		VARB=$(cat /tmp/headersPB | head -n 1 | cut '-d ' '-f2')
			if [ -z "$VARB" ]
			 then
				echo "STHOSTB='$ERRORB'" >> /tmp/temporal.txt
			elif [[ $VARB -gt 200 ]]
			 then
				echo "STHOSTB='$ERRORB'" >> /tmp/temporal.txt
			 else
				echo "STHOSTB='$NORMALB'" >> /tmp/temporal.txt
				echo 'PROXYB="OK"' >> /tmp/temporal.txt
			fi
	  ;;
	  LDAP) #"SERVIDOR LDAP" 
	  fileB="/tmp/ldapheaderB"
		if [ -f "$fileB" ]
			then
				rm /tmp/ldapheaderB
				touch /tmp/ldapheaderB
			else
				touch /tmp/ldapheaderB
		fi
		ldapsearch -x -h $IPHOSTSB -p $IPLDAPPORTB -b "ou=users,ou=*,dc=corpoelec,dc=gob,dc=ve" > /tmp/ldapheaderB
		VARB=$(cat /tmp/ldapheaderB  | tail -n 1 )
			if [ "$VARB" == "# numResponses: 1" ]; then
				echo "STHOSTB='$NORMALB'" >> /tmp/temporal.txt
			else
				echo "STHOSTB='$ERRORB'" >> /tmp/temporal.txt
			fi
	  ;;
	  CUPS) #"SERVIDOR CUPS (SERVIDOR DE IMPRESION)" 
	    VARCUPSB=$(lpstat -h $IPCUPSPUERTOB -t -o | grep -i "Ready to print" | tail -n 1 | cut '-d ' '-f1')
			if [ -z "$VARCUPSB" ]; then
				echo "$VARCUPSB" >> /tmp/headerscupsB
			elif [ "$VARCUPSB" == "	Ready" ]; then
				echo "STHOSTB='$NORMALB'" >> /tmp/temporal.txt
				echo "$VARCUPSB" >> /tmp/headerscupsB
			else
				echo "STHOSTB='$ERRORB'" >> /tmp/temporal.txt
				echo "$VARCUPSB" >> /tmp/headerscupsB
			fi
	  ;;
	  DHCP) #"SERVIDOR DHCP"
		echo "STHOSTB='$NORMALB'" >> /tmp/temporal.txt
	  ;;
	  SMTP) #"SERVIDOR CORREO SMTP" 
		echo "STHOSTB='$NORMALB'" >> /tmp/temporal.txt
	  ;;
	  SAMBA) #"SERVIDOR SAMBA (RECURSOS COMPARTIDOS LINUX)" 
		echo "STHOSTB='$NORMALB'" >> /tmp/temporal.txt
	  ;;
	  COMPWIN) #"SERVIDOR COMPWIN (RECURSOS COMPARTIDOS WINDOWS)" 
		echo "STHOSTB='$NORMALB'" >> /tmp/temporal.txt
	  ;;
	  *) #"CUALQUIER OTRO NO CONFIGURADO" 
		echo "STHOSTB='$NORMALB'" >> /tmp/temporal.txt
	  ;;
	esac
else
	#echo "NO RESPONDE AL PING" >> /tmp/temporal.txt
	echo "STHOSTB='$ERRORB'" >> /tmp/temporal.txt
fi
}
######## HOST (C)
verifica_HOSTSC() {
if ping -qc 20 $IPHOSTSC >/dev/null; then
	case $TIPOSERVC in
	  WEB) #"APLICATIVO WEB"
		  fileC="/tmp/headersWC"
			if [ -f "$fileC" ]
				then
					rm /tmp/headersWC >/dev/null 2>&1
					touch /tmp/headersWC >/dev/null 2>&1
				else
					touch /tmp/headersWC >/dev/null 2>&1
			fi
			curl -k ${HOSTSC} -I -o /tmp/headersWC -s
			VARC=$(cat /tmp/headersWC | head -n 1 | cut '-d ' '-f2')
				if [ -z "$VARC" ]
				 then
					echo "STHOSTC='$ERRORC'" >> /tmp/temporal.txt
				elif [[ $VARC -gt $HEADERWEBSC ]]
				 then
					echo "STHOSTC='$ERRORC'" >> /tmp/temporal.txt
				 else
					echo "STHOSTC='$NORMALC'" >> /tmp/temporal.txt
				fi
		;;
	  DNS) #"SERVIDOR DNS" 
		fileC="/tmp/headersDNSC"
			if [ -f "$fileC" ]
				then
					rm /tmp/headersDNSC >/dev/null 2>&1
					touch /tmp/headersDNSC >/dev/null 2>&1
				else
					touch /tmp/headersDNSC >/dev/null 2>&1
			fi
		RESPDNSC=";; Got answer:"
		VARC=$(dig @$IPHOSTSC intranet.corpoelec.com.ve | grep -i "got")
			if [ -z "$VARC" ]
			 then
				echo "STHOSTC='$ERRORC'" >> /tmp/temporal.txt
				echo "$VARC" >> /tmp/headersDNSC
			elif [[ $VARC == $RESPDNSC ]]
			 then
				echo "STHOSTC='$NORMALC'" >> /tmp/temporal.txt
				echo "$VARC" >> /tmp/headersDNSC
			 else
				echo "STHOSTC='$ERRORC'" >> /tmp/temporal.txt
				echo "$VARC" >> /tmp/headersDNSC
			fi
	  ;;
	  PROXY) #"SERVIDOR PROXY" 
		fileC="/tmp/headersPC"
		if [ -f "$fileC" ]
			then
				rm /tmp/headersPC >/dev/null 2>&1
				touch /tmp/headersPC >/dev/null 2>&1
			else
				touch /tmp/headersPC >/dev/null 2>&1
		fi
		curl -U ${USUARIOCLAVEPROXY} -x ${IPPROXYPUERTOC} ${URLCONTROL} -I -o /tmp/headersPC -s  
		VARC=$(cat /tmp/headersPC | head -n 1 | cut '-d ' '-f2')
			if [ -z "$VARC" ]
			 then
				echo "STHOSTC='$ERRORC'" >> /tmp/temporal.txt
			elif [[ $VARC -gt 200 ]]
			 then
				echo "STHOSTC='$ERRORC'" >> /tmp/temporal.txt
			 else
				echo "STHOSTC='$NORMALC'" >> /tmp/temporal.txt
				echo 'PROXYC="OK"' >> /tmp/temporal.txt
			fi
	  ;;
	  LDAP) #"SERVIDOR LDAP" 
	  fileC="/tmp/ldapheaderC"
		if [ -f "$fileC" ]
			then
				rm /tmp/ldapheaderC
				touch /tmp/ldapheaderC
			else
				touch /tmp/ldapheaderC
		fi
		ldapsearch -x -h $IPHOSTSC -p $IPLDAPPORTC -b "ou=users,ou=*,dc=corpoelec,dc=gob,dc=ve" > /tmp/ldapheaderC
		VARC=$(cat /tmp/ldapheaderC  | tail -n 1 )
			if [ "$VARC" == "# numResponses: 1" ]; then
				echo "STHOSTC='$NORMALC'" >> /tmp/temporal.txt
			else
				echo "STHOSTC='$ERRORC'" >> /tmp/temporal.txt
			fi
	  ;;
	  CUPS) #"SERVIDOR CUPS (SERVIDOR DE IMPRESION)" 
	    VARCUPSC=$(lpstat -h $IPCUPSPUERTOC -t -o | grep -i "Ready to print" | tail -n 1 | cut '-d ' '-f1')
			if [ -z "$VARCUPSC" ]; then
				echo "$VARCUPSC" >> /tmp/headerscupsC
			elif [ "$VARCUPSC" == "	Ready" ]; then
				echo "STHOSTC='$NORMALC'" >> /tmp/temporal.txt
				echo "$VARCUPSC" >> /tmp/headerscupsC
			else
				echo "STHOSTC='$ERRORC'" >> /tmp/temporal.txt
				echo "$VARCUPSC" >> /tmp/headerscupsC
			fi
	  ;;
	  DHCP) #"SERVIDOR DHCP"
		echo "STHOSTC='$NORMALC'" >> /tmp/temporal.txt
	  ;;
	  SMTP) #"SERVIDOR CORREO SMTP" 
		echo "STHOSTC='$NORMALC'" >> /tmp/temporal.txt
	  ;;
	  SAMBA) #"SERVIDOR SAMBA (RECURSOS COMPARTIDOS LINUX)" 
		echo "STHOSTC='$NORMALC'" >> /tmp/temporal.txt
	  ;;
	  COMPWIN) #"SERVIDOR COMPWIN (RECURSOS COMPARTIDOS WINDOWS)" 
		echo "STHOSTC='$NORMALC'" >> /tmp/temporal.txt
	  ;;
	  *) #"CUALQUIER OTRO NO CONFIGURADO" 
		echo "STHOSTC='$NORMALC'" >> /tmp/temporal.txt
	  ;;
	esac
else
	#echo "NO RESPONDE AL PING" >> /tmp/temporal.txt
	echo "STHOSTC='$ERRORC'" >> /tmp/temporal.txt
fi
}
######## HOST (D)
verifica_HOSTSD() {
if ping -qc 20 $IPHOSTSD >/dev/null; then
	case $TIPOSERVD in
	  WEB) #"APLICATIVO WEB"
		  fileD="/tmp/headersWD"
			if [ -f "$fileD" ]
				then
					rm /tmp/headersWD >/dev/null 2>&1
					touch /tmp/headersWD >/dev/null 2>&1
				else
					touch /tmp/headersWD >/dev/null 2>&1
			fi
			curl -k ${HOSTSD} -I -o /tmp/headersWD -s
			VARD=$(cat /tmp/headersWD | head -n 1 | cut '-d ' '-f2')
				if [ -z "$VARD" ]
				 then
					echo "STHOSTD='$ERRORD'" >> /tmp/temporal.txt
				elif [[ $VARD -gt $HEADERWEBSD ]]
				 then
					echo "STHOSTD='$ERRORD'" >> /tmp/temporal.txt
				 else
					echo "STHOSTD='$NORMALD'" >> /tmp/temporal.txt
				fi
		;;
	  DNS) #"SERVIDOR DNS" 
		fileD="/tmp/headersDNSD"
			if [ -f "$fileD" ]
				then
					rm /tmp/headersDNSD >/dev/null 2>&1
					touch /tmp/headersDNSD >/dev/null 2>&1
				else
					touch /tmp/headersDNSD >/dev/null 2>&1
			fi
		RESPDNSD=";; Got answer:"
		VARD=$(dig @$IPHOSTSD intranet.corpoelec.com.ve | grep -i "got")
			if [ -z "$VARD" ]
			 then
				echo "STHOSTD='$ERRORD'" >> /tmp/temporal.txt
				echo "$VARD" >> /tmp/headersDNSD
			elif [[ $VARD == $RESPDNSD ]]
			 then
				echo "STHOSTD='$NORMALD'" >> /tmp/temporal.txt
				echo "$VARD" >> /tmp/headersDNSD
			 else
				echo "STHOSTD='$ERRORD'" >> /tmp/temporal.txt
				echo "$VARD" >> /tmp/headersDNSD
			fi
	  ;;
	  PROXY) #"SERVIDOR PROXY" 
		fileD="/tmp/headersPD"
		if [ -f "$fileD" ]
			then
				rm /tmp/headersPD >/dev/null 2>&1
				touch /tmp/headersPD >/dev/null 2>&1
			else
				touch /tmp/headersPD >/dev/null 2>&1
		fi
		curl -U ${USUARIOCLAVEPROXY} -x ${IPPROXYPUERTOD} ${URLCONTROL} -I -o /tmp/headersPD -s  
		VARD=$(cat /tmp/headersPD | head -n 1 | cut '-d ' '-f2')
			if [ -z "$VARD" ]
			 then
				echo "STHOSTD='$ERRORD'" >> /tmp/temporal.txt
			elif [[ $VARD -gt 200 ]]
			 then
				echo "STHOSTD='$ERRORD'" >> /tmp/temporal.txt
			 else
				echo "STHOSTD='$NORMALD'" >> /tmp/temporal.txt
				echo 'PROXYD="OK"' >> /tmp/temporal.txt
			fi
	  ;;
	  LDAP) #"SERVIDOR LDAP" 
	  fileD="/tmp/ldapheaderD"
		if [ -f "$fileD" ]
			then
				rm /tmp/ldapheaderD
				touch /tmp/ldapheaderD
			else
				touch /tmp/ldapheaderD
		fi
		ldapsearch -x -h $IPHOSTSD -p $IPLDAPPORTD -b "ou=users,ou=*,dc=corpoelec,dc=gob,dc=ve" > /tmp/ldapheaderD
		VARD=$(cat /tmp/ldapheaderD  | tail -n 1 )
			if [ "$VARD" == "# numResponses: 1" ]; then
				echo "STHOSTD='$NORMALD'" >> /tmp/temporal.txt
			else
				echo "STHOSTD='$ERRORD'" >> /tmp/temporal.txt
			fi
	  ;;
	  CUPS) #"SERVIDOR CUPS (SERVIDOR DE IMPRESION)" 
	    VARCUPSD=$(lpstat -h $IPCUPSPUERTOD -t -o | grep -i "Ready to print" | tail -n 1 | cut '-d ' '-f1')
			if [ -z "$VARCUPSD" ]; then
				echo "$VARCUPSD" >> /tmp/headerscupsD
			elif [ "$VARCUPSD" == "	Ready" ]; then
				echo "STHOSTD='$NORMALD'" >> /tmp/temporal.txt
				echo "$VARCUPSD" >> /tmp/headerscupsD
			else
				echo "STHOSTD='$ERRORD'" >> /tmp/temporal.txt
				echo "$VARCUPSD" >> /tmp/headerscupsD
			fi
	  ;;
	  DHCP) #"SERVIDOR DHCP"
		echo "STHOSTD='$NORMALD'" >> /tmp/temporal.txt
	  ;;
	  SMTP) #"SERVIDOR CORREO SMTP" 
		echo "STHOSTD='$NORMALD'" >> /tmp/temporal.txt
	  ;;
	  SAMBA) #"SERVIDOR SAMBA (RECURSOS COMPARTIDOS LINUX)" 
		echo "STHOSTD='$NORMALD'" >> /tmp/temporal.txt
	  ;;
	  COMPWIN) #"SERVIDOR COMPWIN (RECURSOS COMPARTIDOS WINDOWS)" 
		echo "STHOSTD='$NORMALD'" >> /tmp/temporal.txt
	  ;;
	  *) #"CUALQUIER OTRO NO CONFIGURADO" 
		echo "STHOSTD='$NORMALD'" >> /tmp/temporal.txt
	  ;;
	esac
else
	#echo "NO RESPONDE AL PING" >> /tmp/temporal.txt
	echo "STHOSTD='$ERRORD'" >> /tmp/temporal.txt
fi
}
#################################################################################
################### SECCION DE CHEQUEO (CLASIFICADO POR SEDES ###################
######## SEDE A
verifica_SEDEA() {
if ping -qc 20 $SEDEA >/dev/null; then
	echo "STSEDEA='$NORMALSEDEA'" >> /tmp/temporal.txt
else
	echo "STSEDEA='$ERRORSEDEA'" >> /tmp/temporal.txt
fi
}
verifica_SEDEAEQUIPO1() {
if ping -qc 20 $SEDEAEQUIPO1 >/dev/null; then
	echo "STSEDEAEQUIPO1='$NORMALSEDEAEQUIPO1'" >> /tmp/temporal.txt
else
	echo "STSEDEAEQUIPO1='$ERRORSEDEAEQUIPO1'" >> /tmp/temporal.txt
fi
}
verifica_SEDEAEQUIPO2() {
if ping -qc 20 $SEDEAEQUIPO2 >/dev/null; then
	echo "STSEDEAEQUIPO2='$NORMALSEDEAEQUIPO2'" >> /tmp/temporal.txt
else
	echo "STSEDEAEQUIPO2='$ERRORSEDEAEQUIPO2'" >> /tmp/temporal.txt
fi
}
verifica_SEDEAEQUIPO3() {
if ping -qc 20 $SEDEAEQUIPO1 >/dev/null; then
	echo "STSEDEAEQUIPO3='$NORMALSEDEAEQUIPO3'" >> /tmp/temporal.txt
else
	echo "STSEDEAEQUIPO3='$ERRORSEDEAEQUIPO3'" >> /tmp/temporal.txt
fi
}
verifica_SEDEAEQUIPO4() {
if ping -qc 20 $SEDEAEQUIPO4 >/dev/null; then
	echo "STSEDEAEQUIPO4='$NORMALSEDEAEQUIPO4'" >> /tmp/temporal.txt
else
	echo "STSEDEAEQUIPO4='$ERRORSEDEAEQUIPO4'" >> /tmp/temporal.txt
fi
}
verifica_SEDEAEQUIPO5() {
if ping -qc 20 $SEDEAEQUIPO5 >/dev/null; then
	echo "STSEDEAEQUIPO5='$NORMALSEDEAEQUIPO5'" >> /tmp/temporal.txt
else
	echo "STSEDEAEQUIPO5='$ERRORSEDEAEQUIPO5'" >> /tmp/temporal.txt
fi
}
verifica_SEDEAEQUIPO6() {
if ping -qc 20 $SEDEAEQUIPO6 >/dev/null; then
	echo "STSEDEAEQUIPO6='$NORMALSEDEAEQUIPO6'" >> /tmp/temporal.txt
else
	echo "STSEDEAEQUIPO6='$ERRORSEDEAEQUIPO6'" >> /tmp/temporal.txt
fi
}
verifica_SEDEAEQUIPO7() {
if ping -qc 20 $SEDEAEQUIPO7 >/dev/null; then
	echo "STSEDEAEQUIPO7='$NORMALSEDEAEQUIPO7'" >> /tmp/temporal.txt
else
	echo "STSEDEAEQUIPO7='$ERRORSEDEAEQUIPO7'" >> /tmp/temporal.txt
fi
}
verifica_SEDEAEQUIPO8() {
if ping -qc 20 $SEDEAEQUIPO8 >/dev/null; then
	echo "STSEDEAEQUIPO8='$NORMALSEDEAEQUIPO8'" >> /tmp/temporal.txt
else
	echo "STSEDEAEQUIPO8='$ERRORSEDEAEQUIPO8'" >> /tmp/temporal.txt
fi
}
######## SEDE B
verifica_SEDEB() {
if ping -qc 20 $SEDEB >/dev/null; then
	echo "STSEDEB='$NORMALSEDEB'" >> /tmp/temporal.txt
else
	echo "STSEDEB='$ERRORSEDEB'" >> /tmp/temporal.txt
fi
}
verifica_SEDEBEQUIPO1() {
if ping -qc 20 $SEDEBEQUIPO1 >/dev/null; then
	echo "STSEDEBEQUIPO1='$NORMALSEDEBEQUIPO1'" >> /tmp/temporal.txt
else
	echo "STSEDEBEQUIPO1='$ERRORSEDEBEQUIPO1'" >> /tmp/temporal.txt
fi
}
verifica_SEDEBEQUIPO2() {
if ping -qc 20 $SEDEBEQUIPO2 >/dev/null; then
	echo "STSEDEBEQUIPO2='$NORMALSEDEBEQUIPO2'" >> /tmp/temporal.txt
else
	echo "STSEDEBEQUIPO2='$ERRORSEDEBEQUIPO2'" >> /tmp/temporal.txt
fi
}
verifica_SEDEBEQUIPO3() {
if ping -qc 20 $SEDEBEQUIPO3 >/dev/null; then
	echo "STSEDEBEQUIPO3='$NORMALSEDEBEQUIPO3'" >> /tmp/temporal.txt
else
	echo "STSEDEBEQUIPO3='$ERRORSEDEBEQUIPO3'" >> /tmp/temporal.txt
fi
}
verifica_SEDEBEQUIPO4() {
if ping -qc 20 $SEDEBEQUIPO4 >/dev/null; then
	echo "STSEDEBEQUIPO4='$NORMALSEDEBEQUIPO4'" >> /tmp/temporal.txt
else
	echo "STSEDEBEQUIPO4='$ERRORSEDEBEQUIPO4'" >> /tmp/temporal.txt
fi
}
verifica_SEDEBEQUIPO5() {
if ping -qc 20 $SEDEBEQUIPO5 >/dev/null; then
	echo "STSEDEBEQUIPO5='$NORMALSEDEBEQUIPO5'" >> /tmp/temporal.txt
else
	echo "STSEDEBEQUIPO5='$ERRORSEDEBEQUIPO5'" >> /tmp/temporal.txt
fi
}
verifica_SEDEBEQUIPO6() {
if ping -qc 20 $SEDEBEQUIPO6 >/dev/null; then
	echo "STSEDEBEQUIPO6='$NORMALSEDEBEQUIPO6'" >> /tmp/temporal.txt
else
	echo "STSEDEBEQUIPO6='$ERRORSEDEBEQUIPO6'" >> /tmp/temporal.txt
fi
}
verifica_SEDEBEQUIPO7() {
if ping -qc 20 $SEDEBEQUIPO7 >/dev/null; then
	echo "STSEDEBEQUIPO7='$NORMALSEDEBEQUIPO7'" >> /tmp/temporal.txt
else
	echo "STSEDEBEQUIPO7='$ERRORSEDEBEQUIPO7'" >> /tmp/temporal.txt
fi
}
verifica_SEDEBEQUIPO8() {
if ping -qc 20 $SEDEBEQUIPO8 >/dev/null; then
	echo "STSEDEBEQUIPO8='$NORMALSEDEBEQUIPO8'" >> /tmp/temporal.txt
else
	echo "STSEDEBEQUIPO8='$ERRORSEDEBEQUIPO8'" >> /tmp/temporal.txt
fi
}
######## SEDE C
verifica_SEDEC() {
if ping -qc 20 $SEDEC >/dev/null; then
	echo "STSEDEC='$NORMALSEDEC'" >> /tmp/temporal.txt
else
	echo "STSEDEC='$ERRORSEDEC'" >> /tmp/temporal.txt
fi
}
verifica_SEDECEQUIPO1() {
if ping -qc 20 $SEDECEQUIPO1 >/dev/null; then
	echo "STSEDECEQUIPO1='$NORMALSEDECEQUIPO1'" >> /tmp/temporal.txt
else
	echo "STSEDECEQUIPO1='$ERRORSEDECEQUIPO1'" >> /tmp/temporal.txt
fi
}
verifica_SEDECEQUIPO2() {
if ping -qc 20 $SEDECEQUIPO2 >/dev/null; then
	echo "STSEDECEQUIPO2='$NORMALSEDECEQUIPO2'" >> /tmp/temporal.txt
else
	echo "STSEDECEQUIPO2='$ERRORSEDECEQUIPO2'" >> /tmp/temporal.txt
fi
}
verifica_SEDECEQUIPO3() {
if ping -qc 20 $SEDECEQUIPO3 >/dev/null; then
	echo "STSEDECEQUIPO3='$NORMALSEDECEQUIPO3'" >> /tmp/temporal.txt
else
	echo "STSEDECEQUIPO3='$ERRORSEDECEQUIPO3'" >> /tmp/temporal.txt
fi
}
verifica_SEDECEQUIPO4() {
if ping -qc 20 $SEDECEQUIPO4 >/dev/null; then
	echo "STSEDECEQUIPO4='$NORMALSEDECEQUIPO4'" >> /tmp/temporal.txt
else
	echo "STSEDECEQUIPO4='$ERRORSEDECEQUIPO4'" >> /tmp/temporal.txt
fi
}
verifica_SEDECEQUIPO5() {
if ping -qc 20 $SEDECEQUIPO5 >/dev/null; then
	echo "STSEDECEQUIPO5='$NORMALSEDECEQUIPO5'" >> /tmp/temporal.txt
else
	echo "STSEDECEQUIPO5='$ERRORSEDECEQUIPO5'" >> /tmp/temporal.txt
fi
}
verifica_SEDECEQUIPO6() {
if ping -qc 20 $SEDECEQUIPO6 >/dev/null; then
	echo "STSEDECEQUIPO6='$NORMALSEDECEQUIPO6'" >> /tmp/temporal.txt
else
	echo "STSEDECEQUIPO6='$ERRORSEDECEQUIPO6'" >> /tmp/temporal.txt
fi
}
verifica_SEDECEQUIPO7() {
if ping -qc 20 $SEDECEQUIPO7 >/dev/null; then
	echo "STSEDECEQUIPO7='$NORMALSEDECEQUIPO7'" >> /tmp/temporal.txt
else
	echo "STSEDECEQUIPO7='$ERRORSEDECEQUIPO7'" >> /tmp/temporal.txt
fi
}
verifica_SEDECEQUIPO8() {
if ping -qc 20 $SEDECEQUIPO8 >/dev/null; then
	echo "STSEDECEQUIPO8='$NORMALSEDECEQUIPO8'" >> /tmp/temporal.txt
else
	echo "STSEDECEQUIPO8='$ERRORSEDECEQUIPO8'" >> /tmp/temporal.txt
fi
}
######## SEDE D
verifica_SEDED() {
if ping -qc 20 $SEDED >/dev/null; then
	echo "STSEDED='$NORMALSEDED'" >> /tmp/temporal.txt
else
	echo "STSEDED='$ERRORSEDED'" >> /tmp/temporal.txt
fi
}
verifica_SEDEDEQUIPO1() {
if ping -qc 20 $SEDEDEQUIPO1 >/dev/null; then
	echo "STSEDEDEQUIPO1='$NORMALSEDEDEQUIPO1'" >> /tmp/temporal.txt
else
	echo "STSEDEDEQUIPO1='$ERRORSEDEDEQUIPO1'" >> /tmp/temporal.txt
fi
}
verifica_SEDEDEQUIPO2() {
if ping -qc 20 $SEDEDEQUIPO2 >/dev/null; then
	echo "STSEDEDEQUIPO2='$NORMALSEDEDEQUIPO2'" >> /tmp/temporal.txt
else
	echo "STSEDEDEQUIPO2='$ERRORSEDEDEQUIPO2'" >> /tmp/temporal.txt
fi
}
verifica_SEDEDEQUIPO3() {
if ping -qc 20 $SEDEDEQUIPO3 >/dev/null; then
	echo "STSEDEDEQUIPO3='$NORMALSEDEDEQUIPO3'" >> /tmp/temporal.txt
else
	echo "STSEDEDEQUIPO3='$ERRORSEDEDEQUIPO3'" >> /tmp/temporal.txt
fi
}
verifica_SEDEDEQUIPO4() {
if ping -qc 20 $SEDEDEQUIPO4 >/dev/null; then
	echo "STSEDEDEQUIPO4='$NORMALSEDEDEQUIPO4'" >> /tmp/temporal.txt
else
	echo "STSEDEDEQUIPO4='$ERRORSEDEDEQUIPO4'" >> /tmp/temporal.txt
fi
}
verifica_SEDEDEQUIPO5() {
if ping -qc 20 $SEDEDEQUIPO5 >/dev/null; then
	echo "STSEDEDEQUIPO5='$NORMALSEDEDEQUIPO5'" >> /tmp/temporal.txt
else
	echo "STSEDEDEQUIPO5='$ERRORSEDEDEQUIPO5'" >> /tmp/temporal.txt
fi
}
verifica_SEDEDEQUIPO6() {
if ping -qc 20 $SEDEDEQUIPO6 >/dev/null; then
	echo "STSEDEDEQUIPO6='$NORMALSEDEDEQUIPO6'" >> /tmp/temporal.txt
else
	echo "STSEDEDEQUIPO6='$ERRORSEDEDEQUIPO6'" >> /tmp/temporal.txt
fi
}
verifica_SEDEDEQUIPO7() {
if ping -qc 20 $SEDEDEQUIPO7 >/dev/null; then
	echo "STSEDEDEQUIPO7='$NORMALSEDEDEQUIPO7'" >> /tmp/temporal.txt
else
	echo "STSEDEDEQUIPO7='$ERRORSEDEDEQUIPO7'" >> /tmp/temporal.txt
fi
}
verifica_SEDEDEQUIPO8() {
if ping -qc 20 $SEDEDEQUIPO8 >/dev/null; then
	echo "STSEDEDEQUIPO8='$NORMALSEDEDEQUIPO8'" >> /tmp/temporal.txt
else
	echo "STSEDEDEQUIPO8='$ERRORSEDEDEQUIPO8'" >> /tmp/temporal.txt
fi
}
######## DNS GOOGLE
verifica_GOOGLE() {
if ping -qc 20 $NOPROXYIP >/dev/null; then
	INTERNETDIRECT="OK"
	echo 'INTERNETDIRECT="OK"' >> /tmp/temporal.txt
else
	INTERNETDIRECT="NO"

fi
}
#################################################################################
################# SECCION EJECUTA CHEQUEO DE SERVICIOS  Y SEDES #################
verifica_SERVICIOS() {
	verifica_HOSTSA &
	P1=$!
	verifica_HOSTSB &
	P2=$!
	verifica_HOSTSC &
	P3=$!
	verifica_HOSTSD &
	P4=$!
	verifica_GOOGLE
	P5=$!
    verifica_SEDEA &
    PX1=$!
	verifica_SEDEAEQUIPO1 &
	PX2=$!
	verifica_SEDEAEQUIPO2 &
	PX3=$!
	verifica_SEDEAEQUIPO3 &
	PX4=$!
	verifica_SEDEAEQUIPO4 &
	PX5=$!
	verifica_SEDEAEQUIPO5 &
	PX6=$!
	verifica_SEDEAEQUIPO6 &
	PX7=$!
	verifica_SEDEAEQUIPO7 &
	PX8=$!
	verifica_SEDEAEQUIPO8 &
	PX9=$!
	verifica_SEDEB &
    PX10=$!
	verifica_SEDEBEQUIPO1 &
	PX11=$!
	verifica_SEDEBEQUIPO2 &
	PX12=$!
	verifica_SEDEBEQUIPO3 &
	PX13=$!
	verifica_SEDEBEQUIPO4 &
	PX14=$!
	verifica_SEDEBEQUIPO5 &
	PX15=$!
	verifica_SEDEBEQUIPO6 &
	PX16=$!
	verifica_SEDEBEQUIPO7 &
	PX17=$!
	verifica_SEDEBEQUIPO8 &
	PX18=$!
    verifica_SEDEC &
    PX19=$!
	verifica_SEDECEQUIPO1 &
	PX20=$!
	verifica_SEDECEQUIPO2 &
	PX21=$!
	verifica_SEDECEQUIPO3 &
	PX22=$!
	verifica_SEDECEQUIPO4 &
	PX23=$!
	verifica_SEDECEQUIPO5 &
	PX24=$!
	verifica_SEDECEQUIPO6 &
	PX25=$!
	verifica_SEDECEQUIPO7 &
	PX26=$!
	verifica_SEDECEQUIPO8 &
	PX27=$!
    verifica_SEDED &
	PX28=$!
	verifica_SEDEDEQUIPO1 &
	PX29=$!
	verifica_SEDEDEQUIPO2 &
	PX30=$!
	verifica_SEDEDEQUIPO3 &
	PX31=$!
	verifica_SEDEDEQUIPO4 &
	PX32=$!
	verifica_SEDEDEQUIPO5 &
	PX33=$!
	verifica_SEDEDEQUIPO6 &
	PX34=$!
	verifica_SEDEDEQUIPO7 &
	PX35=$!
	verifica_SEDEDEQUIPO8 &
	PX36=$!
}
#################################################################################
###################### SECCION DETERMINA PROXY A UTILIZAR  ######################
determina_PROXY() {
source /tmp/temporal.txt

if [ "$PROXYA" = "OK" ];then
DEFAULTPROXY=$IPPROXYPUERTOA
PROXYEXIST=OK
	if [ "$DEBUGER" == "PROXY" ];then
		echo "SE ASIGNO EL PROXY: $DEFAULTPROXY "
		echo "USUARIO Y CLAVE UTILIZADA EN PROXY: $USUARIOCLAVEPROXY "
	fi
fi
if [ "$PROXYB" == "OK" ];then
DEFAULTPROXY=$IPPROXYPUERTOB
PROXYEXIST=OK
	if [ "$DEBUGER" == "PROXY" ];then
		echo "SE ASIGNO EL PROXY: $DEFAULTPROXY "
		echo "USUARIO Y CLAVE UTILIZADA EN PROXY: $USUARIOCLAVEPROXY "
	fi
fi
if [ "$PROXYC" == "OK" ];then
DEFAULTPROXY=$IPPROXYPUERTOC
PROXYEXIST=OK
	if [ "$DEBUGER" == "PROXY" ];then
		echo "SE ASIGNO EL PROXY: $DEFAULTPROXY "
		echo "USUARIO Y CLAVE UTILIZADA EN PROXY: $USUARIOCLAVEPROXY "
	fi
fi
if [ "$PROXYD" == "OK" ];then
DEFAULTPROXY=$IPPROXYPUERTOD
PROXYEXIST=OK
	if [ "$DEBUGER" == "PROXY" ];then
		echo "SE ASIGNO EL PROXY: $DEFAULTPROXY "
		echo "USUARIO Y CLAVE UTILIZADA EN PROXY: $USUARIOCLAVEPROXY "
	fi
fi
if [ "$PROXYE" == "OK" ];then
DEFAULTPROXY=$IPPROXYPUERTOE
PROXYEXIST=OK
	if [ "$DEBUGER" == "PROXY" ];then
		echo "SE ASIGNO EL PROXY: $DEFAULTPROXY "
		echo "USUARIO Y CLAVE UTILIZADA EN PROXY: $USUARIOCLAVEPROXY "
	fi
fi
if [ "$PROXYF" == "OK" ];then
DEFAULTPROXY=$IPPROXYPUERTOF
PROXYEXIST=OK
	if [ "$DEBUGER" == "PROXY" ];then
		echo "SE ASIGNO EL PROXY: $DEFAULTPROXY "
		echo "USUARIO Y CLAVE UTILIZADA EN PROXY: $USUARIOCLAVEPROXY "
	fi
fi
if [ "$PROXYG" == "OK" ];then
DEFAULTPROXY=$IPPROXYPUERTOG
PROXYEXIST=OK
	if [ "$DEBUGER" == "PROXY" ];then
		echo "SE ASIGNO EL PROXY: $DEFAULTPROXY "
		echo "USUARIO Y CLAVE UTILIZADA EN PROXY: $USUARIOCLAVEPROXY "
	fi
fi
if [ "$PROXYH" == "OK" ];then
DEFAULTPROXY=$IPPROXYPUERTOH
PROXYEXIST=OK
	if [ "$DEBUGER" == "PROXY" ];then
		echo "SE ASIGNO EL PROXY: $DEFAULTPROXY "
		echo "USUARIO Y CLAVE UTILIZADA EN PROXY: $USUARIOCLAVEPROXY "
	fi
fi
if [ "$PROXYI" == "OK" ];then
DEFAULTPROXY=$IPPROXYPUERTOI
PROXYEXIST=OK
	if [ "$DEBUGER" == "PROXY" ];then
		echo "SE ASIGNO EL PROXY: $DEFAULTPROXY "
		echo "USUARIO Y CLAVE UTILIZADA EN PROXY: $USUARIOCLAVEPROXY "
	fi
fi
if [ "$PROXYJ" == "OK" ];then
DEFAULTPROXY=$IPPROXYPUERTOJ
PROXYEXIST=OK
	if [ "$DEBUGER" == "PROXY" ];then
		echo "SE ASIGNO EL PROXY: $DEFAULTPROXY "
		echo "USUARIO Y CLAVE UTILIZADA EN PROXY: $USUARIOCLAVEPROXY "
	fi
fi
if [ "$PROXYK" == "OK" ];then
DEFAULTPROXY=$IPPROXYPUERTOK
PROXYEXIST=OK
	if [ "$DEBUGER" == "PROXY" ];then
		echo "SE ASIGNO EL PROXY: $DEFAULTPROXY "
		echo "USUARIO Y CLAVE UTILIZADA EN PROXY: $USUARIOCLAVEPROXY "
	fi
fi
if [ "$PROXYL" == "OK" ];then
DEFAULTPROXY=$IPPROXYPUERTOL
PROXYEXIST=OK
	if [ "$DEBUGER" == "PROXY" ];then
		echo "SE ASIGNO EL PROXY: $DEFAULTPROXY "
		echo "USUARIO Y CLAVE UTILIZADA EN PROXY: $USUARIOCLAVEPROXY "
	fi
fi
if [ "$PROXYM" == "OK" ];then
DEFAULTPROXY=$IPPROXYPUERTOM
PROXYEXIST=OK
	if [ "$DEBUGER" == "PROXY" ];then
		echo "SE ASIGNO EL PROXY: $DEFAULTPROXY "
		echo "USUARIO Y CLAVE UTILIZADA EN PROXY: $USUARIOCLAVEPROXY "
	fi
fi
if [ "$PROXYN" == "OK" ];then
DEFAULTPROXY=$IPPROXYPUERTON
PROXYEXIST=OK
	if [ "$DEBUGER" == "PROXY" ];then
		echo "SE ASIGNO EL PROXY: $DEFAULTPROXY "
		echo "USUARIO Y CLAVE UTILIZADA EN PROXY: $USUARIOCLAVEPROXY "
	fi
fi
if [ "$PROXYO" == "OK" ];then
DEFAULTPROXY=$IPPROXYPUERTOO
PROXYEXIST=OK
	if [ "$DEBUGER" == "PROXY" ];then
		echo "SE ASIGNO EL PROXY: $DEFAULTPROXY "
		echo "USUARIO Y CLAVE UTILIZADA EN PROXY: $USUARIOCLAVEPROXY "
	fi
fi
if [ "$PROXYP" == "OK" ];then
DEFAULTPROXY=$IPPROXYPUERTOP
PROXYEXIST=OK
	if [ "$DEBUGER" == "PROXY" ];then
		echo "SE ASIGNO EL PROXY: $DEFAULTPROXY "
		echo "USUARIO Y CLAVE UTILIZADA EN PROXY: $USUARIOCLAVEPROXY "
	fi
fi
if [ "$PROXYQ" == "OK" ];then
DEFAULTPROXY=$IPPROXYPUERTOQ
PROXYEXIST=OK
	if [ "$DEBUGER" == "PROXY" ];then
		echo "SE ASIGNO EL PROXY: $DEFAULTPROXY "
		echo "USUARIO Y CLAVE UTILIZADA EN PROXY: $USUARIOCLAVEPROXY "
	fi
fi
if [ "$PROXYR" == "OK" ];then
DEFAULTPROXY=$IPPROXYPUERTOR
PROXYEXIST=OK
	if [ "$DEBUGER" == "PROXY" ];then
		echo "SE ASIGNO EL PROXY: $DEFAULTPROXY "
		echo "USUARIO Y CLAVE UTILIZADA EN PROXY: $USUARIOCLAVEPROXY "
	fi
fi
if [ "$PROXYS" == "OK" ];then
DEFAULTPROXY=$IPPROXYPUERTOS
PROXYEXIST=OK
	if [ "$DEBUGER" == "PROXY" ];then
		echo "SE ASIGNO EL PROXY: $DEFAULTPROXY "
		echo "USUARIO Y CLAVE UTILIZADA EN PROXY: $USUARIOCLAVEPROXY "
	fi
fi
if [ "$PROXYT" == "OK" ];then
DEFAULTPROXY=$IPPROXYPUERTOT
PROXYEXIST=OK
	if [ "$DEBUGER" == "PROXY" ];then
		echo "SE ASIGNO EL PROXY: $DEFAULTPROXY "
		echo "USUARIO Y CLAVE UTILIZADA EN PROXY: $USUARIOCLAVEPROXY "
	fi
fi
if [ "$PROXYU" == "OK" ];then
DEFAULTPROXY=$IPPROXYPUERTOU
PROXYEXIST=OK
	if [ "$DEBUGER" == "PROXY" ];then
		echo "SE ASIGNO EL PROXY: $DEFAULTPROXY "
		echo "USUARIO Y CLAVE UTILIZADA EN PROXY: $USUARIOCLAVEPROXY "
	fi
fi
if [ "$PROXYV" == "OK" ];then
DEFAULTPROXY=$IPPROXYPUERTOV
PROXYEXIST=OK
	if [ "$DEBUGER" == "PROXY" ];then
	echo "SE ASIGNO EL PROXY: $DEFAULTPROXY "
	echo "USUARIO Y CLAVE UTILIZADA EN PROXY: $USUARIOCLAVEPROXY "
	fi
fi
if [ "$PROXYW" == "OK" ];then
DEFAULTPROXY=$IPPROXYPUERTOW
PROXYEXIST=OK
	if [ "$DEBUGER" == "PROXY" ];then
		echo "SE ASIGNO EL PROXY: $DEFAULTPROXY "
		echo "USUARIO Y CLAVE UTILIZADA EN PROXY: $USUARIOCLAVEPROXY "
	fi
fi
if [ "$PROXYX" == "OK" ];then
DEFAULTPROXY=$IPPROXYPUERTOX
PROXYEXIST=OK
	if [ "$DEBUGER" == "PROXY" ];then
		echo "SE ASIGNO EL PROXY: $DEFAULTPROXY "
		echo "USUARIO Y CLAVE UTILIZADA EN PROXY: $USUARIOCLAVEPROXY "
	fi
fi
if [ "$PROXYY" == "OK" ];then
DEFAULTPROXY=$IPPROXYPUERTOY
PROXYEXIST=OK
	if [ "$DEBUGER" == "PROXY" ];then
		echo "SE ASIGNO EL PROXY: $DEFAULTPROXY "
		echo "USUARIO Y CLAVE UTILIZADA EN PROXY: $USUARIOCLAVEPROXY "
	fi
fi
if [ "$PROXYZ" == "OK" ];then
DEFAULTPROXY=$IPPROXYPUERTOZ
PROXYEXIST=OK
	if [ "$DEBUGER" == "PROXY" ];then
		echo "SE ASIGNO EL PROXY: $DEFAULTPROXY "
		echo "USUARIO Y CLAVE UTILIZADA EN PROXY: $USUARIOCLAVEPROXY "
	fi
fi
}
#################################################################################
#################### SECCION MUESTRA RESULTADO EN CONSOLA  ######################
consola_SERVICIOS() {
	if [ "$DEBUG" == "ACTIVADO" ]; then
		echo "*APLICACIONES:*"
		echo "$STHOSTA"
		echo "$STHOSTB"
		echo "$STHOSTC"
		echo "$STHOSTD"
		echo "$STHOSTE"
		echo "$STHOSTF"
		echo "$STHOSTG"
		echo "$STHOSTH"
		echo "$STHOSTI"
		echo "$STHOSTJ"
		echo "$STHOSTW"
		echo "*SERVICIOS:*"
		echo "$STHOSTK"
		echo "$STHOSTL"
		echo "$STHOSTM"
		echo "$STHOSTN"
		echo "$STHOSTO"
		echo "$STHOSTP"
		echo "$STHOSTQ"
		echo "$STHOSTR"
		echo "$STHOSTS"
		echo "$STHOSTT"
		echo "$STHOSTU"
		echo "$STHOSTV"
	fi
}
consola_SEDES() {
	if [ "$DEBUG" == "ACTIVADO" ]; then
		echo "SEDES MONITOREADAS:"
		echo "$STSEDEA"
		echo "$STSEDEB"
		echo "$STSEDEC"		
		echo "$STSEDED (oficina depende router consolidado)"
		echo "$STSEDEE"
	fi
}
consola_COMPLETO() {
	if [ "$DEBUG" == "ACTIVADO" ]; then
		echo "*APLICACIONES:*"
		echo "$STHOSTA"
		echo "$STHOSTB"
		echo "$STHOSTC"
		echo "$STHOSTD"
		echo "$STHOSTE"
		echo "$STHOSTF"
		echo "$STHOSTG"
		echo "$STHOSTH"
		echo "$STHOSTI"
		echo "$STHOSTJ"
		echo "$STHOSTW"
		echo "*SERVICIOS:*"
		echo "$STHOSTK"
		echo "$STHOSTL"
		echo "$STHOSTM"
		echo "$STHOSTN"
		echo "$STHOSTO"
		echo "$STHOSTP"
		echo "$STHOSTQ"
		echo "$STHOSTR"
		echo "$STHOSTS"
		echo "$STHOSTT"
		echo "$STHOSTU"
		echo "$STHOSTV"
		echo "*SEDES MONITOREADAS:*"
		echo "*SEDE A:*"
		echo "$STSEDEA"
		echo "$STSEDEAEQUIPO1"
		echo "$STSEDEAEQUIPO2"
		echo "$STSEDEAEQUIPO3"
		echo "$STSEDEAEQUIPO4"
		echo "$STSEDEAEQUIPO5"
		echo "$STSEDEAEQUIPO6"
		echo "$STSEDEAEQUIPO7"
		echo "$STSEDEAEQUIPO8"
		echo "*SEDE B:*"
		echo "$STSEDEB"
		echo "$STSEDEBEQUIPO1"
		echo "$STSEDEBEQUIPO2"
		echo "$STSEDEBEQUIPO3"
		echo "$STSEDEBEQUIPO8"
		echo "*SEDE C:*"
		echo "$STSEDEC"
		echo "$STSEDECEQUIPO1"
		echo "$STSEDECEQUIPO2"
		echo "$STSEDECEQUIPO3"
		echo "$STSEDECEQUIPO5"
		echo "$STSEDECEQUIPO8"
		echo "*SEDE D:*"
		echo "$STSEDED"
		echo "$STSEDEDEQUIPO2"
		echo "$STSEDEDEQUIPO3"
		echo "*CIAU MORON:*"
		echo "$STSEDEE"
		echo "$STSEDEEEQUIPO1"
		echo "$STSEDEEEQUIPO2"
		echo "$STSEDEEEQUIPO3"
		echo "$STSEDEEEQUIPO4"
		echo "$STSEDEEEQUIPO5"
		echo "$STSEDEEEQUIPO8"
	fi
}
#################################################################################
###################### SECCION GENERA TODOS LOS REPORTES  #######################
reporte_SERVICIOS() {
	if [ "$INTERNETDIRECT" == "OK" ]; then
		echo "USANDO METODO SIN PROXY"
		echo "ENVIANDO REPORTE SIN USAR PROXY"
		case $DEBUG in
			ACTIVADO) 
			echo "DEBUG ACTIVADO"
			captura="/tmp/captura.png"
			if [ -f "$captura" ]
			then
				rm /tmp/captura.png
				import -window root /tmp/captura.png
			else
				import -window root /tmp/captura.png
			fi
			curl -s -X POST ${URLPOST} -d chat_id=$IDC -d text="REPORTE ESTATUS SERVICIOS" >/dev/null 2>&1
			curl -s -X POST $URLPOSTF -F chat_id=$IDC -F photo="@/tmp/captura.png" -F caption="NAGIOS" >/dev/null 2>&1
			curl -s -X POST ${URLPOST} -d chat_id=$IDC -d text="$MENSAJE" >/dev/null 2>&1
			curl -s -X POST ${URLPOST} -d chat_id=$IDC -d text="El chequeo y reporte ha sido generado en  `expr $end - $start` segundos." >/dev/null 2>&1
			;;
			DESACTIVADO) 
			echo "MODO NORMAL"
			echo "USANDO METODO SIN PROXY"
			echo "ENVIANDO REPORTE SIN USAR PROXY"
			captura="/tmp/captura.png"
			if [ -f "$captura" ]
			then
				rm /tmp/captura.png
				import -window root /tmp/captura.png
			else
				import -window root /tmp/captura.png
			fi
			curl -s -X POST ${URLPOST} -d chat_id=$IDC -d text="REPORTE ESTATUS SERVICIOS CORPORATIVOS" >/dev/null 2>&1
			curl -s -X POST $URLPOSTF -F chat_id=$IDC -F photo="@/tmp/captura.png" -F caption="NAGIOS" >/dev/null 2>&1
			curl -s -X POST ${URLPOST} -d chat_id=$IDC -d text="$MENSAJE" >/dev/null 2>&1
			curl -s -X POST ${URLPOST} -d chat_id=$IDC -d text="El chequeo y reporte ha sido generado en  `expr $end - $start` segundos." >/dev/null 2>&1
			curl  -s -X POST ${URLPOST} -d chat_id=$IDB -d text="ADVERTENCIA: SE DETECTO UBICACION DESCONOCIDA"
			curl  -s -X POST ${URLPOST} -d chat_id=$IDB -d text="AL NO ESTAR EN LA RED CORPORATIVA ES POSIBLE QUE EL ESTATUS DE LOS SERVICIOS APAREZCA SIN CONEXION"
			;;
			*) echo "NO SE ENVIA EL REPORTE SE MUESTRA EN PANTALLA"
			   ;;
		esac
	elif [ "$PROXYEXIST" == "OK" ]; then
		case $DEBUG in
			ACTIVADO) 
			echo "DEBUG ACTIVADO"
			captura="/tmp/captura.png"
			if [ -f "$captura" ]
			then
				rm /tmp/captura.png
				import -window root /tmp/captura.png
			else
				import -window root /tmp/captura.png
			fi
			curl -U ${USUARIOCLAVEPROXY} -x ${DEFAULTPROXY} POST ${URLPOST} -d chat_id=$IDC -d text="ESTATUS DE LOS SERVICIOS CORPORATIVOS" >/dev/null 2>&1
			curl -U $USUARIOCLAVEPROXY -x $DEFAULTPROXY POST $URLPOSTF -F chat_id=$IDC -F photo="@/tmp/captura.png" -F caption="REPORTE" >/dev/null 2>&1
			curl -U ${USUARIOCLAVEPROXY} -x ${DEFAULTPROXY} POST ${URLPOST} -d chat_id=$IDC -d text="$MENSAJE" >/dev/null 2>&1
			curl -U ${USUARIOCLAVEPROXY} -x ${DEFAULTPROXY} POST ${URLPOST} -d chat_id=$IDC -d text="El chequeo y reporte ha sido generado en  `expr $end - $start` segundos." >/dev/null 2>&1
			curl -U ${USUARIOCLAVEPROXY} -x ${DEFAULTPROXY} POST ${URLPOST} -d chat_id=$IDC -d text="SE UTILIZO EL METODO PROXY PARA ENVIAR REPORTE" >/dev/null 2>&1
			;;
			DESACTIVADO) 
			echo "MODO NORMAL"
			echo "METODO CON PROXY SELECIONADO"
			echo "USANDO PROXY PARA ENVIAR REPORTE"			
			captura="/tmp/captura.png"
			if [ -f "$captura" ]
			then
				rm /tmp/captura.png
				import -window root /tmp/captura.png
			else
				import -window root /tmp/captura.png
			fi
			curl -U ${USUARIOCLAVEPROXY} -x ${DEFAULTPROXY} POST ${URLPOST} -d chat_id=$IDB -d text="ESTATUS DE LOS SERVICIOS CORPORATIVOS" >/dev/null 2>&1
			curl -U $USUARIOCLAVEPROXY -x $DEFAULTPROXY POST $URLPOSTF -F chat_id=$IDB -F photo="@/tmp/captura.png" -F caption="REPORTE" >/dev/null 2>&1
			curl -U ${USUARIOCLAVEPROXY} -x ${DEFAULTPROXY} POST ${URLPOST} -d chat_id=$IDB -d text="$MENSAJE" >/dev/null 2>&1
			curl -U ${USUARIOCLAVEPROXY} -x ${DEFAULTPROXY} POST ${URLPOST} -d chat_id=$IDB -d text="El chequeo y reporte ha sido generado en  `expr $end - $start` segundos." >/dev/null 2>&1
			curl -U ${USUARIOCLAVEPROXY} -x ${DEFAULTPROXY} POST ${URLPOST} -d chat_id=$IDB -d text="SE UTILIZO EL PROXY PARA ENVIAR REPORTE" >/dev/null 2>&1
			;;
			*) echo "NO SE ENVIA EL REPORTE SE MUESTRA EN PANTALLA"
			   echo "$MENSAJE";;
		esac
	else
		echo "NO HAY CONEXION A INTERNET"
		echo "NO PUEDO ENVIAR EL MENSAJE"
	fi

}
reporte_SEDES() {
	if [ "$INTERNETDIRECT" == "OK" ]; then
		echo "USANDO METODO SIN PROXY"
		echo "ENVIANDO REPORTE SIN USAR PROXY"
		case $DEBUG in
			ACTIVADO) 
			echo "DEBUG ACTIVADO"
			captura="/tmp/captura.png"
			if [ -f "$captura" ]
			then
				rm /tmp/captura.png
				import -window root /tmp/captura.png
			else
				import -window root /tmp/captura.png
			fi
			curl -s -X POST ${URLPOST} -d chat_id=$IDC -d text="ESTATUS SEDES MONITOREADAS" >/dev/null 2>&1
			curl -s -X POST $URLPOSTF -F chat_id=$IDC -F photo="@/tmp/captura.png" -F caption="NAGIOS" >/dev/null 2>&1
			curl -s -X POST ${URLPOST} -d chat_id=$IDC -d text="$MENSAJE2B" >/dev/null 2>&1
			curl -s -X POST ${URLPOST} -d chat_id=$IDC -d text="El chequeo y reporte ha sido generado en  `expr $end - $start` segundos." >/dev/null 2>&1
			;;
			DESACTIVADO) 
			echo "MODO NORMAL"
			echo "USANDO METODO SIN PROXY"
			echo "ENVIANDO REPORTE SIN USAR PROXY"
			captura="/tmp/captura.png"
			if [ -f "$captura" ]
			then
				rm /tmp/captura.png
				import -window root /tmp/captura.png
			else
				import -window root /tmp/captura.png
			fi
			curl -s -X POST ${URLPOST} -d chat_id=$IDC -d text="ESTATUS SEDES MONITOREADAS" >/dev/null 2>&1
			curl -s -X POST $URLPOSTF -F chat_id=$IDC -F photo="@/tmp/captura.png" -F caption="NAGIOS" >/dev/null 2>&1
			curl -s -X POST ${URLPOST} -d chat_id=$IDC -d text="$MENSAJE2B" >/dev/null 2>&1
			curl  -s -X POST ${URLPOST} -d chat_id=$IDB -d text="ADVERTENCIA: SE DETECTO UBICACION DESCONOCIDA"
			curl  -s -X POST ${URLPOST} -d chat_id=$IDB -d text="AL NO ESTAR EN LA RED CORPORATIVA ES POSIBLE QUE EL ESTATUS DE LOS SERVICIOS APAREZCA SIN CONEXION"
			;;
			*) echo "NO SE ENVIA EL REPORTE SE MUESTRA EN PANTALLA"
			   echo "$MENSAJE";;
		esac
	elif [ "$PROXYEXIST" == "OK" ]; then
		case $DEBUG in
			ACTIVADO) 
			echo "DEBUG ACTIVADO"
			captura="/tmp/captura.png"
			if [ -f "$captura" ]
			then
				rm /tmp/captura.png
				import -window root /tmp/captura.png
			else
				import -window root /tmp/captura.png
			fi
			curl -U ${USUARIOCLAVEPROXY} -x ${DEFAULTPROXY} POST ${URLPOST} -d chat_id=$IDC -d text="ESTATUS SEDES MONITOREADAS" >/dev/null 2>&1
			curl -U $USUARIOCLAVEPROXY -x $DEFAULTPROXY POST $URLPOSTF -F chat_id=$IDC -F photo="@/tmp/captura.png" -F caption="REPORTE" >/dev/null 2>&1
			curl -U ${USUARIOCLAVEPROXY} -x ${DEFAULTPROXY} POST ${URLPOST} -d chat_id=$IDC -d text="$MENSAJE2B" >/dev/null 2>&1
			curl -U ${USUARIOCLAVEPROXY} -x ${DEFAULTPROXY} POST ${URLPOST} -d chat_id=$IDC -d text="El chequeo y reporte ha sido generado en  `expr $end - $start` segundos." >/dev/null 2>&1
			curl -U ${USUARIOCLAVEPROXY} -x ${DEFAULTPROXY} POST ${URLPOST} -d chat_id=$IDC -d text="SE UTILIZO EL PROXY PARA ENVIAR REPORTE" >/dev/null 2>&1
			;;
			DESACTIVADO) 
			echo "MODO NORMAL"
			echo "METODO CON PROXY SELECIONADO"
			echo "USANDO PROXY PARA ENVIAR REPORTE"			
			captura="/tmp/captura.png"
			if [ -f "$captura" ]
			then
				rm /tmp/captura.png
				import -window root /tmp/captura.png
			else
				import -window root /tmp/captura.png
			fi
			curl -U ${USUARIOCLAVEPROXY} -x ${DEFAULTPROXY} POST ${URLPOST} -d chat_id=$IDB -d text="ESTATUS SEDES MONITOREADAS" >/dev/null 2>&1
			curl -U $USUARIOCLAVEPROXY -x $DEFAULTPROXY POST $URLPOSTF -F chat_id=$IDB -F photo="@/tmp/captura.png" -F caption="REPORTE" >/dev/null 2>&1			
			curl -U ${USUARIOCLAVEPROXY} -x ${DEFAULTPROXY} POST ${URLPOST} -d chat_id=$IDB -d text="$MENSAJE2B" >/dev/null 2>&1
			curl -U ${USUARIOCLAVEPROXY} -x ${DEFAULTPROXY} POST ${URLPOST} -d chat_id=$IDB -d text="El chequeo y reporte ha sido generado en  `expr $end - $start` segundos." >/dev/null 2>&1
			curl -U ${USUARIOCLAVEPROXY} -x ${DEFAULTPROXY} POST ${URLPOST} -d chat_id=$IDB -d text="SE UTILIZO EL PROXY PARA ENVIAR REPORTE" >/dev/null 2>&1
			;;
			*) echo "NO SE ENVIA EL REPORTE SE MUESTRA EN PANTALLA"
			   echo "$MENSAJE";;
		esac
	else
		echo "NO HAY CONEXION A INTERNET"
		echo "NO PUEDO ENVIAR EL MENSAJE"
	fi

}
reporte_COMPLETO() {
	if [ "$INTERNETDIRECT" == "OK" ]; then
		echo "USANDO METODO SIN PROXY"
		echo "ENVIANDO REPORTE SIN USAR PROXY"
		case $DEBUG in
			ACTIVADO) 
			echo "DEBUG ACTIVADO"
			captura="/tmp/captura.png"
			if [ -f "$captura" ]
			then
				rm /tmp/captura.png
				import -window root /tmp/captura.png
			else
				import -window root /tmp/captura.png
			fi
			curl -s -X POST ${URLPOST} -d chat_id=$IDC -d text="REPORTES COMPLETO SEDES Y SERVICIOS CORPORATIVOS" >/dev/null 2>&1
			curl -s -X POST $URLPOSTF -F chat_id=$IDC -F photo="@/tmp/captura.png" -F caption="NAGIOS" >/dev/null 2>&1
			curl -s -X POST ${URLPOST} -d chat_id=$IDC -d text="$MENSAJE" >/dev/null 2>&1
			curl -s -X POST ${URLPOST} -d chat_id=$IDC -d text="$MENSAJE2F" >/dev/null 2>&1
			curl -s -X POST ${URLPOST} -d chat_id=$IDC -d text="El chequeo y reporte ha sido generado en  `expr $end - $start` segundos." >/dev/null 2>&1
			;;
			DESACTIVADO) 
			echo "MODO NORMAL"
			echo "USANDO METODO SIN PROXY"
			echo "ENVIANDO REPORTE SIN USAR PROXY"
			captura="/tmp/captura.png"
			if [ -f "$captura" ]
			then
				rm /tmp/captura.png
				import -window root /tmp/captura.png
			else
				import -window root /tmp/captura.png
			fi
			curl -s -X POST ${URLPOST} -d chat_id=$IDB -d text="REPORTES COMPLETO SEDES Y SERVICIOS CORPORATIVOS" >/dev/null 2>&1
			curl -s -X POST ${URLPOST} -d chat_id=$IDB -d text="$MENSAJE"
			curl -s -X POST ${URLPOST} -d chat_id=$IDB -d text="$MENSAJE2F" >/dev/null 2>&1
			curl -s -X POST ${URLPOST} -d chat_id=$IDB -d text="ADVERTENCIA: SE DETECTO UBICACION DESCONOCIDA"
			curl -s -X POST ${URLPOST} -d chat_id=$IDB -d text="AL NO ESTAR EN LA RED CORPORATIVA ES POSIBLE QUE EL ESTATUS DE LOS SERVICIOS APAREZCA SIN CONEXION"
			;;
			*) echo "NO SE ENVIA EL REPORTE SE MUESTRA EN PANTALLA"
			   echo "$MENSAJE";;
		esac
	elif [ "$PROXYEXIST" == "OK" ]; then
		case $DEBUG in
			ACTIVADO) 
			echo "DEBUG ACTIVADO"
			captura="/tmp/captura.png"
			if [ -f "$captura" ]
			then
				rm /tmp/captura.png
				import -window root /tmp/captura.png
			else
				import -window root /tmp/captura.png
			fi
			curl -U ${USUARIOCLAVEPROXY} -x ${DEFAULTPROXY} POST ${URLPOST} -d chat_id=$IDC -d text="REPORTES COMPLETO SEDES Y SERVICIOS CORPORATIVOS" >/dev/null 2>&1
			curl -U $USUARIOCLAVEPROXY -x $DEFAULTPROXY POST $URLPOSTF -F chat_id=$IDC -F photo="@/tmp/captura.png" -F caption="REPORTE" >/dev/null 2>&1
			curl -U ${USUARIOCLAVEPROXY} -x ${DEFAULTPROXY} POST ${URLPOST} -d chat_id=$IDC -d text="$MENSAJE" >/dev/null 2>&1
			curl -U ${USUARIOCLAVEPROXY} -x ${DEFAULTPROXY} POST ${URLPOST} -d chat_id=$IDC -d text="$MENSAJE2F" >/dev/null 2>&1
			curl -U ${USUARIOCLAVEPROXY} -x ${DEFAULTPROXY} POST ${URLPOST} -d chat_id=$IDC -d text="El chequeo y reporte ha sido generado en  `expr $end - $start` segundos." >/dev/null 2>&1
			curl -U ${USUARIOCLAVEPROXY} -x ${DEFAULTPROXY} POST ${URLPOST} -d chat_id=$IDC -d text="SE UTILIZO EL METODO PROXY PARA ENVIAR REPORTE" >/dev/null 2>&1
			;;
			DESACTIVADO) 
			echo "MODO NORMAL"
			echo "METODO CON PROXY SELECIONADO"
			echo "USANDO PROXY PARA ENVIAR REPORTE"			
			captura="/tmp/captura.png"
			if [ -f "$captura" ]
			then
				rm /tmp/captura.png
				import -window root /tmp/captura.png
			else
				import -window root /tmp/captura.png
			fi
			curl -U ${USUARIOCLAVEPROXY} -x ${DEFAULTPROXY} POST ${URLPOST} -d chat_id=$IDB -d text="REPORTES COMPLETO SEDES Y SERVICIOS CORPORATIVOS" >/dev/null 2>&1
			curl -U $USUARIOCLAVEPROXY -x $DEFAULTPROXY POST $URLPOSTF -F chat_id=$IDB -F photo="@/tmp/captura.png" -F caption="REPORTE" >/dev/null 2>&1
			curl -U ${USUARIOCLAVEPROXY} -x ${DEFAULTPROXY} POST ${URLPOST} -d chat_id=$IDB -d text="$MENSAJE" >/dev/null 2>&1
			curl -U ${USUARIOCLAVEPROXY} -x ${DEFAULTPROXY} POST ${URLPOST} -d chat_id=$IDB -d text="$MENSAJE2F" >/dev/null 2>&1
			curl -U ${USUARIOCLAVEPROXY} -x ${DEFAULTPROXY} POST ${URLPOST} -d chat_id=$IDB -d text="El chequeo y reporte ha sido generado en  `expr $end - $start` segundos." >/dev/null 2>&1
			curl -U ${USUARIOCLAVEPROXY} -x ${DEFAULTPROXY} POST ${URLPOST} -d chat_id=$IDB -d text="SE UTILIZO EL METODO PROXY PARA ENVIAR REPORTE" >/dev/null 2>&1
			;;
			*) echo "NO SE ENVIA EL REPORTE SE MUESTRA EN PANTALLA"
			   echo "$MENSAJE";;
		esac
	else
		echo "NO HAY CONEXION A INTERNET"
		echo "NO PUEDO ENVIAR EL MENSAJE"
	fi

}
#################################################################################
# Esta linea se usa para configuracion de pruebas mensajes privados al creador
IDC="38914901"
#################################################################################
############################ SECCION EJECUTA TODO  ##############################
if [ -z "$1" ]
then
	clear
	echo "No Especifico el reporte que desea ejecutar"
	echo "Las opciones son: servicios - sedes - completo"
else
	case $1 in
	  servicios) echo "Procesando Reporte Servicios" 
		if [ "$DEBUG" == "ACTIVADO" ]; then
			echo "COMPROBACION DE PANTALLA DESACTIVADA"
		else
			proceso_inicial
		fi
		clear
		echo "EJECUTANDO PROCESO DE CHEQUEO"
		echo "ESPERE POR FAVOR..."
		verifica_SERVICIOS
		wait $P1 $P2 $P3 $P4 $P5 $PX1 $PX2 $PX3 $PX4
		echo "INICIANDO PROCESO PARA GENERAR REPORTES"
		source /tmp/temporal.txt
		source /scripts/monitoreo/mensaje.conf
		fecha=$(date '+ %A, %B %d, %Y.')
		hora=$(date '+ %H:%M:%S')
		end=`date +%s`
		determina_PROXY
		reporte_SERVICIOS
		consola_SERVICIOS
	  ;;
	  sedes) echo "Procesando Reporte Sedes"
		if [ "$DEBUG" == "ACTIVADO" ]; then
			echo "COMPROBACION DE PANTALLA DESACTIVADA"
		else
			proceso_inicial
		fi
		clear
		echo "EJECUTANDO PROCESO DE CHEQUEO"
		echo "ESPERE POR FAVOR..."
		verifica_SERVICIOS
		wait $P1 $P2 $P3 $P4 $P5 $PX1 $PX2 $PX3 $PX4
		echo "INICIANDO PROCESO PARA GENERAR REPORTES"
		source /tmp/temporal.txt
		source /scripts/monitoreo/mensaje2B.conf
		fecha=$(date '+ %A, %B %d, %Y.')
		hora=$(date '+ %H:%M:%S')
		end=`date +%s`
		determina_PROXY
		reporte_SEDES
		consola_SEDES
	  ;;
	  completo) echo "Procesando Reporte Completo"
		if [ "$DEBUG" == "ACTIVADO" ]; then
			echo "COMPROBACION DE PANTALLA DESACTIVADA"
		else
			proceso_inicial
		fi
		clear
		echo "EJECUTANDO PROCESO DE CHEQUEO"
		echo "ESPERE POR FAVOR..."
		verifica_SERVICIOS
		wait $P1 $P2 $P3 $P4 $P5 $PX1 $PX2 $PX3 $PX4
		echo "INICIANDO PROCESO PARA GENERAR REPORTES"
		source /tmp/temporal.txt
		source /scripts/monitoreo/mensaje.conf
		source /scripts/monitoreo/mensaje2F.conf
		fecha=$(date '+ %A, %B %d, %Y.')
		hora=$(date '+ %H:%M:%S')
		end=`date +%s`
		determina_PROXY
		reporte_COMPLETO
		consola_COMPLETO
	  ;;
	  *)
	  clear 
	  echo "No se indico una opcion valida"
	  echo "Debe indicar que reporte desea ejecutar"
	  echo "Las opciones son: reporte - sedes - completo"
	  ;;
	esac
fi
	if [ "$DEBUG" == "ACTIVADO" ]; then
		echo "$DEFAULTPROXY"
	fi
	rm /tmp/temporal.txt >/dev/null 2>&1
	rm /tmp/headers* >/dev/null 2>&1
	rm /tmp/ldapheader* >/dev/null 2>&1
	termina_procesos
	exit
else
	echo "No existe el archivo de Configuracion"
	exit
fi

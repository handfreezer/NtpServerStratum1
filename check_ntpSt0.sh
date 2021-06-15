#!/bin/bash

UPDATE_GPIO=0
GPIO_DIR="/sys/class/gpio"
GPIO_RED="5"
GPIO_RED_DIR="${GPIO_DIR}/gpio${GPIO_RED}"
GPIO_YELLOW="13"
GPIO_YELLOW_DIR="${GPIO_DIR}/gpio${GPIO_YELLOW}"
GPIO_GREEN="26"
GPIO_GREEN_DIR="${GPIO_DIR}/gpio${GPIO_GREEN}"

function switchGPIO {
	value=${1}
	shift
	for gpio in ${*}
	do
		echo ${value} >${gpio}/value
	done
}

RELOAD=0
if [ ${#} -eq 1 ]
then
	RELOAD=${1}
	exec 1>/dev/null 2>&1
fi

if [ -d "/sys/class/gpio" ]
then
	UPDATE_GPIO=1
	if [ ! -d "${GPIO_RED_DIR}" ]
	then
		echo ${GPIO_RED} >${GPIO_DIR}/export
		echo "out" >${GPIO_RED_DIR}/direction
	fi
	if [ ! -d "${GPIO_YELLOW_DIR}" ]
	then
		echo ${GPIO_YELLOW} >${GPIO_DIR}/export
		echo "out" >${GPIO_YELLOW_DIR}/direction
	fi
	if [ ! -d "${GPIO_GREEN_DIR}" ]
	then
		echo ${GPIO_GREEN} >${GPIO_DIR}/export
		echo "out" >${GPIO_GREEN_DIR}/direction
	fi
	switchGPIO 0 ${GPIO_RED_DIR} ${GPIO_YELLOW_DIR} ${GPIO_GREEN_DIR}
	switchGPIO 1 ${GPIO_RED_DIR} ${GPIO_YELLOW_DIR} ${GPIO_GREEN_DIR}
	sleep 0.05
	switchGPIO 0 ${GPIO_RED_DIR} ${GPIO_YELLOW_DIR} ${GPIO_GREEN_DIR}
fi

RES_NTPQ=$(ntpq -pn 127.0.0.1)

echo "${RES_NTPQ}"|egrep "^\*.*$" 1>/dev/null 2>&1
(( RES_SYNC = 1 - $? ))
echo "${RES_NTPQ}"|grep "*127.127.20.0" 1>/dev/null 2>&1
(( RES_GPS = 1 - $? ))
echo "${RES_NTPQ}"|grep "o127.127.22.0" 1>/dev/null 2>&1
(( RES_PPS = 1 - $? ))

echo "RES_SYNC=$RES_SYNC RES_GPS=$RES_GPS RES_PPS=$RES_PPS"
if [ $RES_GPS -eq 1 ]
then
	if [ $RES_PPS -eq 1 ]
	then
		switchGPIO 1 ${GPIO_GREEN_DIR}
	else
		switchGPIO 1 ${GPIO_YELLOW_DIR}
	fi
else
	switchGPIO $RES_SYNC ${GPIO_RED_DIR}
fi
sleep 0.3
switchGPIO 0 ${GPIO_RED_DIR} ${GPIO_YELLOW_DIR} ${GPIO_GREEN_DIR}

if [ ${RELOAD} -ne 0 ]
then
	sleep ${RELOAD}
	${0} ${RELOAD} &
fi


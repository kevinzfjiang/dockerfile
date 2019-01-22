#!/bin/bash

SS_CONFIG=${SS_CONFIG:-""}
SS_MODULE=${SS_MODULE:-"ss-server"}
KCP_CONFIG=${KCP_CONFIG:-""}
KCP_MODULE=${KCP_MODULE:-"kcpserver"}
KCP_FLAG=${KCP_FLAG:-"false"}
UDP2RAW_CONFIG=${UDP2RAW_CONFIG:-""}
UDP2RAW_MODULE=${UDP2RAW_MODULE:-"udp2raw_amd64"}
UDP2RAW_FLAG=${UDP2RAW_FLAG:-"false"}
RNGD_FLAG=${RNGD_FLAG:-"false"}

while getopts "s:m:k:e:v:w:xru" OPT; do
    case $OPT in
        s)
            SS_CONFIG=$OPTARG;;
        m)
            SS_MODULE=$OPTARG;;
        k)
            KCP_CONFIG=$OPTARG;;
        e)
            KCP_MODULE=$OPTARG;;
        v)
            UDP2RAW_CONFIG=$OPTARG;;
        w)
            UDP2RAW_MODULE=$OPTARG;;
        x)
            KCP_FLAG="true";;
        r)
            RNGD_FLAG="true";;
        u)
            UDP2RAW_FLAG="true";;
    esac
done

if [ "${RNGD_FLAG}" == "true" ]; then
    echo -e "\033[32mUse /dev/urandom to quickly generate high-quality random numbers......\033[0m"
    rngd -r /dev/urandom
fi

if [ "${KCP_FLAG}" == "true" ] && [ "${KCP_CONFIG}" != "" ]; then
    echo -e "\033[32mStarting kcptun......\033[0m"
    ${KCP_MODULE} ${KCP_CONFIG} 2>&1 &
else
    echo -e "\033[33mKcptun not started......\033[0m"
fi

if [ "${UDP2RAW_FLAG}" == "true" ] && [ "${UDP2RAW_CONFIG}" != "" ]; then
    echo -e "\033[32mStarting udp2raw......\033[0m"
    ${UDP2RAW_MODULE} ${UDP2RAW_CONFIG} 2>&1 &
else
    echo -e "\033[33mUDP2RAW not started......\033[0m"
fi

if [ "${SS_CONFIG}" != "" ]; then
    echo -e "\033[32mStarting shadowsocks......\033[0m"
    ${SS_MODULE} ${SS_CONFIG}
else
    echo -e "\033[31mError: SS_CONFIG is blank!\033[0m"
    exit 1
fi
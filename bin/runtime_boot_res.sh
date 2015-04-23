#!/system/bin/sh

OPERATOR=`getprop ro.build.target_operator`
COUNTRY=`getprop ro.build.target_country`
BUILD_TYPE=`getprop ro.build.type`
DCOUNTRY=`getprop ro.build.default_country`
UI_BASE_CA=`getprop ro.build.ui_base_ca`
MCC=`getprop persist.sys.ntcode`
FIRSTPOWERON=`getprop persist.radio.first-mccmnc`
LGBOOTANIM=`getprop ro.lge.firstboot.openani`
MCC=${MCC#*,}
MCC=${MCC:1:3}

USER_BOOTANIMATION_FILE=/data/local/bootanimation.zip
USER_BOOTANIMATION_SOUND_FILE=/data/local/PowerOn.ogg
USER_SHUTDOWNANIMATION_FILE=/data/local/shutdownanimation.zip
USER_SHUTDOWNANIMATION_SOUND_FILE=/data/local/PowerOff.ogg
USER_APP_MANAGER_INSTALLATION_FILE=/data/local/app-enabled-conf.json

COTA_BOOTANIMATION_FILE=/data/shared/cust/bootanimation.zip
COTA_BOOTANIMATION_SOUND_FILE=/data/shared/cust/PowerOn.ogg
COTA_SHUTDOWNANIMATION_FILE=/data/shared/cust/shutdownanimation.zip
COTA_SHUTDOWNANIMATION_SOUND_FILE=/data/shared/cust/PowerOff.ogg

if [ $DCOUNTRY != "" ]; then
    if [ $UI_BASE_CA != "NO" ]; then
        SUBCA_FILE=${UI_BASE_CA}/${DCOUNTRY}
    else
        SUBCA_FILE=${OPERATOR}_${COUNTRY}/${DCOUNTRY}
    fi
else
    if [ $UI_BASE_CA != "NO" ]; then
        SUBCA_FILE=${UI_BASE_CA}
    else
        SUBCA_FILE=${OPERATOR}_${COUNTRY}
    fi
fi

/system/bin/chown -R system:system /data/.OP
/system/bin/chmod -R 0771 /data/.OP
/system/bin/chmod -R 0644 /data/.OP/$SUBCA_FILE/power*/*
/system/bin/chmod 0644 /data/.OP/*/apps/*
/system/bin/chmod -R 0644 /data/.OP/*/prop
/system/bin/chmod 0644 /data/.OP/app-enabled-conf.json

DOWNCA_APP_MANAGER_INSTALLATION_FILE=/data/.OP/app-enabled-conf.json

if [ $(ls /data/.OP/${SUBCA_FILE}/poweron/bootanimation_${MCC}.zip | grep bootanimation_${MCC}.zip) ]; then
    if [ $LGBOOTANIM != "" ] && [ $LGBOOTANIM == "true" ]; then
        if [ $FIRSTPOWERON != "" ]; then
            DOWNCA_BOOTANIMATION_FILE=/data/.OP/${SUBCA_FILE}/poweron/bootanimation_${MCC}.zip
        fi
    else
        DOWNCA_BOOTANIMATION_FILE=/data/.OP/${SUBCA_FILE}/poweron/bootanimation_${MCC}.zip
    fi
else
    DOWNCA_BOOTANIMATION_FILE=/data/.OP/${SUBCA_FILE}/poweron/bootanimation.zip
fi

if [ $(ls /data/.OP/${SUBCA_FILE}/poweron/PowerOn_${MCC}.ogg | grep PowerOn_${MCC}.ogg) ]; then
    if [ $LGBOOTANIM != "" ] && [ $LGBOOTANIM == "true" ]; then
        if [ $FIRSTPOWERON != "" ]; then
            DOWNCA_BOOTANIMATION_SOUND_FILE=/data/.OP/${SUBCA_FILE}/poweron/PowerOn_${MCC}.ogg
        fi
    else
        DOWNCA_BOOTANIMATION_SOUND_FILE=/data/.OP/${SUBCA_FILE}/poweron/PowerOn_${MCC}.ogg
    fi

else
    DOWNCA_BOOTANIMATION_SOUND_FILE=/data/.OP/${SUBCA_FILE}/poweron/PowerOn.ogg
fi

if [ $(ls /data/.OP/${SUBCA_FILE}/poweroff/shutdownanimation_${MCC}.zip | grep shutdownanimation_${MCC}.zip) ]; then
    if [ $LGBOOTANIM != "" ] && [ $LGBOOTANIM == "true" ]; then
        if [ $FIRSTPOWERON != "" ]; then
            DOWNCA_SHUTDOWNANIMATION_FILE=/data/.OP/${SUBCA_FILE}/poweroff/shutdownanimation_${MCC}.zip
        fi
    else
        DOWNCA_SHUTDOWNANIMATION_FILE=/data/.OP/${SUBCA_FILE}/poweroff/shutdownanimation_${MCC}.zip
    fi

else
    DOWNCA_SHUTDOWNANIMATION_FILE=/data/.OP/${SUBCA_FILE}/poweroff/shutdownanimation.zip
fi

if [ $(ls /data/.OP/${SUBCA_FILE}/poweroff/PowerOff_${MCC}.ogg | grep PowerOff_${MCC}.ogg) ]; then
    if [ $LGBOOTANIM != "" ] && [ $LGBOOTANIM == "true" ]; then
        if [ $FIRSTPOWERON != "" ]; then
            DOWNCA_SHUTDOWNANIMATION_SOUND_FILE=/data/.OP/${SUBCA_FILE}/poweroff/PowerOff_${MCC}.ogg
        fi
    else
        DOWNCA_SHUTDOWNANIMATION_SOUND_FILE=/data/.OP/${SUBCA_FILE}/poweroff/PowerOff_${MCC}.ogg
    fi

else
    DOWNCA_SHUTDOWNANIMATION_SOUND_FILE=/data/.OP/${SUBCA_FILE}/poweroff/PowerOff.ogg
fi

if [ $OPERATOR != "GLOBAL" ]; then

    rm $USER_BOOTANIMATION_FILE
    rm $USER_BOOTANIMATION_SOUND_FILE
    rm $USER_SHUTDOWNANIMATION_FILE
    rm $USER_SHUTDOWNANIMATION_SOUND_FILE

    if [ -f $DOWNCA_BOOTANIMATION_FILE ]; then
        if [ ! $(ls /data/.OP/${SUBCA_FILE}/poweron/nobootani_${MCC}.open) ]; then
            ln -s $DOWNCA_BOOTANIMATION_FILE $USER_BOOTANIMATION_FILE
        fi
    fi

    if [ -f $DOWNCA_BOOTANIMATION_SOUND_FILE ]; then
        if [ ! $(ls /data/.OP/${SUBCA_FILE}/poweron/nobootani_sound_${MCC}.open) ]; then
            ln -s $DOWNCA_BOOTANIMATION_SOUND_FILE $USER_BOOTANIMATION_SOUND_FILE
        fi
    fi

    if [ -f $DOWNCA_SHUTDOWNANIMATION_FILE ]; then
        if [ ! $(ls /data/.OP/${SUBCA_FILE}/poweroff/noshutdownani_${MCC}.open) ]; then
            ln -s $DOWNCA_SHUTDOWNANIMATION_FILE $USER_SHUTDOWNANIMATION_FILE
        fi
    fi

    if [ -f $DOWNCA_SHUTDOWNANIMATION_SOUND_FILE ]; then
        if [ ! $(ls /data/.OP/${SUBCA_FILE}/poweroff/noshutdownani_sound_${MCC}.open) ]; then
            ln -s $DOWNCA_SHUTDOWNANIMATION_SOUND_FILE $USER_SHUTDOWNANIMATION_SOUND_FILE
        fi
    fi

    if [ -f $COTA_BOOTANIMATION_FILE ]; then
        ln -s $COTA_BOOTANIMATION_FILE $USER_BOOTANIMATION_FILE
    fi

    if [ -f $COTA_BOOTANIMATION_SOUND_FILE ]; then
        ln -s $COTA_BOOTANIMATION_SOUND_FILE $USER_BOOTANIMATION_SOUND_FILE
    fi

    if [ -f $COTA_SHUTDOWNANIMATION_FILE ]; then
        ln -s $COTA_SHUTDOWNANIMATION_FILE $USER_SHUTDOWNANIMATION_FILE
    fi

    if [ -f $COTA_SHUTDOWNANIMATION_SOUND_FILE ]; then
        ln -s $COTA_SHUTDOWNANIMATION_SOUND_FILE $USER_SHUTDOWNANIMATION_SOUND_FILE
    fi

else
    rm $USER_APP_MANAGER_INSTALLATION_FILE
    if [ -f $DOWNCA_APP_MANAGER_INSTALLATION_FILE ]; then
        ln -s $DOWNCA_APP_MANAGER_INSTALLATION_FILE $USER_APP_MANAGER_INSTALLATION_FILE
    fi
fi

CUST_AUDIO_PATH=/cust/${SUBCA_FILE}/media/audio
CUST_RINGTONE_PATH=${CUST_AUDIO_PATH}/ringtones
CUST_NOTIFICATION_PATH=${CUST_AUDIO_PATH}/notifications
CUST_ALARM_ALERT_PATH=${CUST_AUDIO_PATH}/alarms

USER_MEDIA_PATH=/data/local/media
USER_AUDIO_PATH=/${USER_MEDIA_PATH}/audio
USER_RINGTONE_PATH=${USER_AUDIO_PATH}/ringtones
USER_NOTIFICATION_PATH=${USER_AUDIO_PATH}/notifications
USER_ALARM_ALERT_PATH=${USER_AUDIO_PATH}/alarms

rm -rf $USER_MEDIA_PATH

IS_SUBCA_EXIST=$(ls -R ${CUST_AUDIO_PATH} | grep "\_[0-9]\{3\}\.")
if [ $? -eq 0 ]; then
    mkdir -p $USER_AUDIO_PATH
    mkdir $USER_RINGTONE_PATH
    mkdir $USER_NOTIFICATION_PATH
    mkdir $USER_ALARM_ALERT_PATH
    chmod 755 $USER_MEDIA_PATH
    chmod 755 -R $USER_MEDIA_PATH/*
    if [ -d ${CUST_RINGTONE_PATH} ]; then
        if [ ! $(ls /cust/${SUBCA_FILE}/config/noringtone.open) ]; then
        CUST_RINGTONE_FILES=$(ls ${CUST_RINGTONE_PATH} | grep ${MCC})
        if [ $? -eq 0 ]; then
            for CUST_RINGTONE_FILE in ${CUST_RINGTONE_FILES}; do
                    RINGTONE_EXTENTION=${CUST_RINGTONE_FILE##*.}
                    RINGTONE_FILE_NAME=${CUST_RINGTONE_FILE%%_${MCC}*}
                    cp -p ${CUST_RINGTONE_PATH}/${CUST_RINGTONE_FILE} ${USER_RINGTONE_PATH}/${RINGTONE_FILE_NAME}.${RINGTONE_EXTENTION}
            done
        else
            RINGTONE_FILES=$(ls ${CUST_RINGTONE_PATH} | grep -v "\_[0-9]\{3\}\.")
            if [ $? -eq 0 ]; then
                for RINGTONE_FILE in ${RINGTONE_FILES}; do
                    cp -p ${CUST_RINGTONE_PATH}/${RINGTONE_FILE} ${USER_RINGTONE_PATH}/${RINGTONE_FILE}
                done
            fi
        fi
    fi
    fi
    if [ -d ${CUST_NOTIFICATION_PATH} ]; then
        if [ ! $(ls /cust/${SUBCA_FILE}/config/nonotification.open) ]; then
        CUST_NOTIFICATION_FILES=$(ls ${CUST_NOTIFICATION_PATH} | grep ${MCC})
        if [ $? -eq 0 ]; then
            for CUST_NOTIFICATION_FILE in ${CUST_NOTIFICATION_FILES}; do
                    NOTIFICATION_EXTENTION=${CUST_NOTIFICATION_FILE##*.}
                    NOTIFICATION_FILE_NAME=${CUST_NOTIFICATION_FILE%%_${MCC}*}
                    cp -p ${CUST_NOTIFICATION_PATH}/${CUST_NOTIFICATION_FILE} ${USER_NOTIFICATION_PATH}/${NOTIFICATION_FILE_NAME}.${NOTIFICATION_EXTENTION}
            done
        else
            NOTIFICATION_FILES=$(ls ${CUST_NOTIFICATION_PATH} | grep -v "\_[0-9]\{3\}\.")
            if [ $? -eq 0 ]; then
                for NOTIFICATION_FILE in ${NOTIFICATION_FILES}; do
                    cp -p ${CUST_NOTIFICATION_PATH}/${NOTIFICATION_FILE} ${USER_NOTIFICATION_PATH}/${NOTIFICATION_FILE}
                done
            fi
        fi
        fi
    fi
    if [ -d ${CUST_ALARM_ALERT_PATH} ]; then
        if [ ! $(ls /cust/${SUBCA_FILE}/config/noalarm.open) ]; then
        CUST_ALARM_ALERT_FILES=$(ls ${CUST_ALARM_ALERT_PATH} | grep ${MCC})
        if [ $? -eq 0 ]; then
            for CUST_ALARM_ALERT_FILE in ${CUST_ALARM_ALERT_FILES}; do
                    ALARM_ALERT_EXTENTION=${CUST_ALARM_ALERT_FILE##*.}
                    ALARM_ALERT_FILE_NAME=${CUST_ALARM_ALERT_FILE%%_${MCC}*}
                    cp -p ${CUST_ALARM_ALERT_PATH}/${CUST_ALARM_ALERT_FILE} ${USER_ALARM_ALERT_PATH}/${ALARM_ALERT_FILE_NAME}.${ALARM_ALERT_EXTENTION}
            done
        else
            ALARM_ALERT_FILES=$(ls ${CUST_ALARM_ALERT_PATH} | grep -v "\_[0-9]\{3\}\.")
            if [ $? -eq 0 ]; then
                for ALARM_ALERT_FILE in ${ALARM_ALERT_FILES}; do
                    cp -p ${CUST_ALARM_ALERT_PATH}/${ALARM_ALERT_FILE} ${USER_ALARM_ALERT_PATH}/${ALARM_ALERT_FILE}
                done
            fi
        fi
        fi
    fi
fi
exit 0
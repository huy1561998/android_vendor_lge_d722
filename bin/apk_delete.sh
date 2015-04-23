#!/system/bin/sh

OPERATOR=`getprop ro.build.target_operator`
COUNTRY=`getprop ro.build.target_country`
BUILD_TYPE=`getprop ro.build.type`
MCC=`getprop persist.sys.ntcode`
MCC=${MCC:5:3}

NAVIGON_FOLDER_PATH=/data/media/0/navigon

if [ $OPERATOR != "GLOBAL" ]; then
    # Delete other operator dir
#    if [ $BUILD_TYPE == "user" ]; then
        ls /data/.OP > /data/del_entry
        for del_item in `cat /data/del_entry`
        do
            if [ $del_item != ${OPERATOR}_${COUNTRY} ] && [ $del_item != userdata.ubid ] && [ $del_item != app-enabled-conf.json ]; then
                rm -rf /data/.OP/$del_item
            fi
        done
        rm /data/del_entry
	if [ $OPERATOR = "TMO" ] && [ $MCC != "262" ]; then
		if [ -d $NAVIGON_FOLDER_PATH ]; then
			rm -rf $NAVIGON_FOLDER_PATH
		fi
	fi
        setprop persist.data.sbp.update 2
#    fi
else
	if [ $MCC = "999" ]; then
		if [ -d $NAVIGON_FOLDER_PATH ]; then
			rm -rf $NAVIGON_FOLDER_PATH
		fi
	fi
	setprop persist.data.sbp.update 0
fi

exit 0

#!/bin/bash

KEY_INFO_FILE=/etc/pritunl/key.txt
PW_INFO_FILE=/etc/pritunl/user.txt


get_default_pw () {
    RC=1
    while [ "$RC" != "0" ]; do
        CREDS=$(pritunl default-password)
        if [ "$?" == "0" ]; then
            echo -e "${CREDS}" | tail -n3 > ${PW_INFO_FILE}
            RC=0
        fi
    done
} 

pritunl_init () {
    echo "creating setup-key in ${KEY_INFO_FILE} and adm credentials in ${PW_INFO_FILE}"
    echo "to see this, mount yourpath:/etc/pritunl/"

    if [ "${PRITUNL_MONGO_URI}" != "" ]; then
        echo "setting mongodb uri ${PRITUNL_MONGO_URI}"
        pritunl set-mongodb "${PRITUNL_MONGO_URI}"
    fi

    pritunl setup-key | tee ${KEY_INFO_FILE}

    get_default_pw &
}

pritunl_start () {
    echo "starting pritunl..."
    pritunl start
}

case "${1}" in
    init)   pritunl_init
            ;;

    start)  pritunl_start
            ;;

    *)      pritunl_init
            pritunl_start
            ;;
esac
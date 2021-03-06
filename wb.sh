#!/usr/bin/env bash

usage()
{
    echo "Usage: wb.sh eu|na|tr|vn [version [server]]"
    exit 1
}

error()
{
    echo "failed"
    exit $1
}

[ $# -lt 1 ] && usage
cd `dirname $0`

case "$1" in
    eu|na|tr )
        read -p "Email: " email
        read -s -p "Password: " psswd
        echo
        echo -n 'Connecting...'

        res=$(curl -ks -X POST \
            -A 'u-launcher' \
            --data-urlencode "email=${email}" \
            --data-urlencode "password=${psswd}" \
            'https://gflauncher.gface.com/api/login') || error 3

        echo "$res" | grep 'fail' && error 1
        echo 'done'

        token=$(echo "$res" | sed 's/^.*sessionToken":"\([-0-9a-f]*\).*$/\1/')
        userid=$(echo "$res" | sed 's/^.*userid":\([0-9]*\).*$/\1/')
        ;;

    vn )
        read -p "Username: " username
        read -s -p "Password: " psswd
        echo
        echo -n 'Connecting...'

        psswd=$(echo -n "$psswd" | md5sum | sed 's/ .*//')
        ip=$(curl -A goPlay -s 'http://rank.goconnect.vtc.vn:8086/getipadd.aspx')
        cpid=100001
        uuid=3e367435-ced4-429f-90df-62acc887b427
        sign=$(echo -n "${username}${psswd}${ip}${cpid}${uuid}"| md5sum | sed 's/ .*//')

        res=$(curl -Gs \
            --data-urlencode "username=${username}" \
            --data-urlencode "password=${psswd}" \
            --data "cpid=100001" \
            --data "clientip=${ip}" \
            --data "sign=${sign}" \
            'http://authen.goplay.vn/fastlogin') || error 3

        echo "$res" | grep -- '"ret":-' && error 1
        echo 'done'

        token=$(echo "$res" | sed 's/^.*token":"\([^"]*\).*$/\1/')
        userid=$(echo "$res" | sed 's/^.*ret":\([0-9]*\).*$/\1/')
        ;;

    ru )
        echo "TODO"
        usage
        ;;
    * )
        echo "Unimplemented"
        usage
        ;;
esac

./wb ${token} ${userid} $@

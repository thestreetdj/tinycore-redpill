#!/bin/bash

function beginArray() {

    case $1 in
    DS3615xs)
        permanent="LWN"
        serialstart="1130 1230 1330 1430"
        ;;
    DS3617xs)
        permanent="ODN"
        serialstart="1130 1230 1330 1430"
        ;;
    DS916+)
        permanent="NZN"
        serialstart="1130 1230 1330 1430"
        ;;
    DS918+)
        permanent="PDN"
        serialstart="1780 1790 1860 1980"
        ;;
    DS1019+)
        permanent="PDN"
        serialstart="1780 1790 1860 1980"
        ;;
    DS920+)
        permanent="SBR"
        serialstart="2030 2040 20C0 2150"
        ;;
    DS1520+)
        permanent="TRR"
        serialstart="2270"
        ;;    
    DS3622xs+)
        permanent="SQR"
        serialstart="2030 2040 20C0 2150"
        ;;
    DS1621xs+)
        permanent="S7R"
        serialstart="2080"
        ;;
    RS4021xs+)
        permanent="T2R"
        serialstart="2250"
        ;;
    DS923+)
        permanent="TQR"
        serialstart="2270"
        ;;
    DS1522+)
        permanent="TRR"
        serialstart="2270"
        ;;
    DS723+)
        permanent="TQR"
        serialstart="2270"
        ;;
    DS1621+)
        permanent="S7R"
        serialstart="2080"
        ;;
    DS2422+)
        permanent="S7R"
        serialstart="2080"
        ;;
    FS2500)
        permanent="PSN"
        serialstart="1960"
        ;;
    FS6400)
        permanent="PSN"
        serialstart="1960"
        ;;
    DVA3219)
        permanent="RFR"
        serialstart="1930 1940"
        ;;
    DVA3221)
        permanent="SJR"
        serialstart="2030 2040 20C0 2150"
        ;;
    DVA1622)
        permanent="SJR"
        serialstart="2030 2040 20C0 2150"
        ;;
    RS3618xs)
        permanent="ODN"
        serialstart="1130 1230 1330 1430"
        ;;
    RS3413xs+)
        permanent="S7R"
        serialstart="2080"
        ;;
    esac

}

function random() {
        printf "%06d" $(($RANDOM % 30000 + 1))
}
function randomhex() {
        val=$(($RANDOM % 255 + 1))
        echo "obase=16; $val" | bc
}

function generateRandomLetter() {
        for i in a b c d e f g h j k l m n p q r s t v w x y z; do
                echo $i
        done | sort -R | tail -1
}

function generateRandomValue() {
        for i in 0 1 2 3 4 5 6 7 8 9 a b c d e f g h j k l m n p q r s t v w x y z; do
                echo $i
        done | sort -R | tail -1
}

function toupper() {

        echo $1 | tr '[:lower:]' '[:upper:]'

}

function generateMacAddress() {

        #toupper "Mac Address: 00:11:32:$(randomhex):$(randomhex):$(randomhex)"
        printf '00:11:32:%02X:%02X:%02X' $((RANDOM % 256)) $((RANDOM % 256)) $((RANDOM % 256))

}

function generateSerial() {

    beginArray $1

    case $1 in

    DS3615xs)
        serialnum="$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(random)
        ;;
    DS3617xs)
        serialnum="$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(random)
        ;;
    DS916+)
        serialnum="$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(random)
        ;;
    DS918+)
        serialnum="$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(random)
        ;;
    DS1019+)
        serialnum="$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(random)
        ;;
    FS2500)
        serialnum="$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(random)
        ;;
    FS6400)
        serialnum="$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(random)
        ;;
    DS920+)
        serialnum=$(toupper "$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(generateRandomLetter)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomLetter))
        ;;
    DS923+)
        serialnum=$(toupper "$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(generateRandomLetter)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomLetter))
        ;;
    DS1522+)
        serialnum=$(toupper "$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(generateRandomLetter)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomLetter))
        ;;
    DS723+)
        serialnum=$(toupper "$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(generateRandomLetter)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomLetter))
        ;;
    DS1520+)
        serialnum=$(toupper "$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(generateRandomLetter)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomLetter))
        ;;
    DS3622xs+)
        serialnum=$(toupper "$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(generateRandomLetter)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomLetter))
        ;;
    DS1621xs+)
        serialnum=$(toupper "$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(generateRandomLetter)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomLetter))
        ;;
    RS4021xs+)
        serialnum=$(toupper "$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(generateRandomLetter)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomLetter))
        ;;
    DS1621+)
        serialnum=$(toupper "$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(generateRandomLetter)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomLetter))
        ;;
    DS2422+)
        serialnum=$(toupper "$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(generateRandomLetter)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomLetter))
        ;;
    DVA3219)
        serialnum=$(toupper "$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(generateRandomLetter)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomLetter))
        ;;
    DVA3221)
        serialnum=$(toupper "$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(generateRandomLetter)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomLetter))
        ;;
    DVA1622)
        serialnum=$(toupper "$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(generateRandomLetter)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomLetter))
        ;;
    RS3618xs)
        serialnum="$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(random)
        ;;
    RS3413xs+)
        serialnum=$(toupper "$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(generateRandomLetter)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomLetter))
        ;;
    esac

    echo $serialnum

}

function showhelp() {

        cat <<EOF
$(basename ${0})

----------------------------------------------------------------------------------------
Usage: ${0} <platform>

Available platforms :
----------------------------------------------------------------------------------------
DS3615xs DS3617xs DS916+ DS918+ DS1019+ DS920+ DS3622xs+ FS6400 DVA3219 DVA3221 DVA1622
DS1621+ DS1621xs+ RS4021xs+ DS2422+ DS1520+ FS2500 RS3618xs RS3413xs+ DS923+ DS723+ DS1522+

e.g. $(basename ${0}) DS3615xs
----------------------------------------------------------------------------------------
EOF

}

if [ -z "$1" ]; then
    showhelp
else
    if [ "$1" = "DS3615xs" ] || [ "$1" = "DS3617xs" ] || [ "$1" = "DS916+" ] || [ "$1" = "DS918+" ] || [ "$1" = "DS1019+" ] || [ "$1" = "DS920+" ] || [ "$1" = "DS923+" ] || [ "$1" = "DS723+" ] || [ "$1" = "DS1522+" ] || [ "$1" = "DS3622xs+" ] || [ "$1" = "FS6400" ] || [ "$1" = "DVA3219" ] || [ "$1" = "DVA3221" ] || [ "$1" = "DVA1622" ] || [ "$1" = "DS1621+" ] || [ "$1" = "DS1621xs+" ] || [ "$1" = "RS4021xs+" ] || [ "$1" = "DS2422+" ] || [ "$1" = "DS1520+" ] || [ "$1" = "FS2500" ] || [ "$1" = "RS3618xs" ] || [ "$1" = "RS3413xs+" ] ; then
        echo $(generateSerial $1)
    else
        echo "Error : $1 is not an available model for serial number generation. "
        echo "Available Models : DS3615xs DS3617xs DS916+ DS918+ DS1019+ DS920+ DS3622xs+ FS6400 DVA3219 DVA3221 DVA1622 DS1621+ DS1621xs+ RS4021xs+ DS2422+ DS1520+ FS2500 RS3618xs RS3413xs+ DS923+ DS723+ DS1522+"
    fi
fi

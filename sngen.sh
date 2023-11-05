#!/bin/bash

##### INCLUDES #########################################################################################################
source myfunc.h

getvarsmshell "$1"

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

    case ${suffix} in
    numeric)
        serialnum="$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(random)
        ;;
    alpha)
        serialnum=$(toupper "$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(generateRandomLetter)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomValue)$(generateRandomLetter))
        ;;
    *)    
        serialnum="$(echo "$serialstart" | tr ' ' '\n' | sort -R | tail -1)$permanent"$(random)
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
${MODELS}"

e.g. $(basename ${0}) DS3622xs+
----------------------------------------------------------------------------------------
EOF

}

if [ -z "$1" ]; then
    showhelp
else
    echo $(generateSerial $1)
fi

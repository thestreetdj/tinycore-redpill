#!/usr/bin/env bash

#. /home/tc/include/functions.sh

[[ "$(which dialog)_" == "_" ]] && tce-load -wi dialog

# Get actual IP
IP="$(ifconfig | grep -i "inet " | grep -v "127.0.0.1" | awk '{print $2}')"

TMP_PATH=/tmp
MODEL="DS3622xs+"
BUILD="42962"

###############################################################################
# Mounts backtitle dynamically
function backtitle() {
  BACKTITLE="TCRP 0.9.2.9"
  if [ -n "${MODEL}" ]; then
    BACKTITLE+=" ${MODEL}"
  else
    BACKTITLE+=" (no model)"
  fi
  if [ -n "${BUILD}" ]; then
    BACKTITLE+=" ${BUILD}"
  else
    BACKTITLE+=" (no build)"
  fi
  if [ -n "${SN}" ]; then
    BACKTITLE+=" ${SN}"
  else
    BACKTITLE+=" (no SN)"
  fi
  if [ -n "${IP}" ]; then
    BACKTITLE+=" ${IP}"
  else
    BACKTITLE+=" (no IP)"
  fi
  if [ -n "${KEYMAP}" ]; then
    BACKTITLE+=" (${LAYOUT}/${KEYMAP})"
  else
    BACKTITLE+=" (qwerty/us)"
  fi
  echo ${BACKTITLE}
}

###############################################################################
# Shows available models to user choose one
function modelMenu() {
  dialog --backtitle "`backtitle`" --default-item "${MODEL}" --no-items \
    --menu "Choose a model" 0 0 0 "DS3622xs+" "DS1621xs+" "RS4021xs+" "DS1019+" "DS918+" \
		"DS920+" "DS1520+" "DS1621+" "DS2422+" "FS2500" \
		"DS3617xs" "RS3618xs" "DVA1622" "DVA3221" "DVA3219" "DS3615xs" \
    2>${TMP_PATH}/resp
  [ $? -ne 0 ] && return
  MODEL="`<${TMP_PATH}/resp`"
}

###############################################################################
# Shows menu to user type one or generate randomly
function serialMenu() {
  while true; do
    dialog --clear --backtitle "`backtitle`" \
      --menu "Choose a option" 0 0 0 \
      a "Generate a random serial number" \
      m "Enter a serial number" \
    2>${TMP_PATH}/resp
    [ $? -ne 0 ] && return
    resp=$(<${TMP_PATH}/resp)
    [ -z "${resp}" ] && return
    if [ "${resp}" = "m" ]; then
      while true; do
        dialog --backtitle "`backtitle`" \
          --inputbox "Please enter a serial number " 0 0 "" \
          2>${TMP_PATH}/resp
        [ $? -ne 0 ] && return
        SERIAL=`cat ${TMP_PATH}/resp`
        if [ -z "${SERIAL}" ]; then
          return
        elif [ `validateSerial ${MODEL} ${SERIAL}` -eq 1 ]; then
          break
        fi
        dialog --backtitle "`backtitle`" --title "Alert" \
          --yesno "Invalid serial, continue?" 0 0
        [ $? -eq 0 ] && break
      done
      break
    elif [ "${resp}" = "a" ]; then
      SERIAL=`./serialnumbergen.sh "${MODEL}"`
      break
    fi
  done
  SN="${SERIAL}"
}

###############################################################################
# Shows available keymaps to user choose one
function keymapMenu() {
  dialog --backtitle "`backtitle`" --default-item "${LAYOUT}" --no-items \
    --menu "Choose a layout" 0 0 0 "azerty" "bepo" "carpalx" "colemak" \
    "dvorak" "fgGIod" "neo" "olpc" "qwerty" "qwertz" \
    2>${TMP_PATH}/resp
  [ $? -ne 0 ] && return
  LAYOUT="`<${TMP_PATH}/resp`"
  OPTIONS=""
  while read KM; do
    OPTIONS+="${KM::-7} "
  done < <(cd /usr/share/keymaps/i386/${LAYOUT}; ls *.map.gz)
  dialog --backtitle "`backtitle`" --no-items --default-item "${KEYMAP}" \
    --menu "Choice a keymap" 0 0 0 ${OPTIONS} \
    2>/tmp/resp
  [ $? -ne 0 ] && return
  resp=`cat /tmp/resp 2>/dev/null`
  [ -z "${resp}" ] && return
  KEYMAP=${resp}
  writeConfigKey "layout" "${LAYOUT}" "${USER_CONFIG_FILE}"
  writeConfigKey "keymap" "${KEYMAP}" "${USER_CONFIG_FILE}"
  zcat /usr/share/keymaps/i386/${LAYOUT}/${KEYMAP}.map.gz | loadkeys
}

###############################################################################
# Where the magic happens!
function make() {
  clear

  ./my.sh "${MODEL}"F noconfig
  if [ $? -ne 0 ]; then
    dialog --backtitle "`backtitle`" --title "Error" --aspect 18 \
      --msgbox "Ramdisk not patched:\n`<"${LOG_FILE}"`" 0 0
    return 1
  fi

  echo "Ready!"
  sleep 3
  DIRTY=0
  return 0
}

function reboot() {
    sudo reboot
}

# Main loop
NEXT="m"
while true; do
  echo "m \"Choose a model\""                          > "${TMP_PATH}/menu"
  if [ -n "${MODEL}" ]; then
    echo "s \"Choose a serial number\""               >> "${TMP_PATH}/menu"
    echo "x \"Cmdline menu\""                         >> "${TMP_PATH}/menu"
    echo "d \"Build the loader\""                     >> "${TMP_PATH}/menu"
  fi
  echo "u \"Edit user config file manually\""         >> "${TMP_PATH}/menu"
  echo "k \"Choose a keymap\" "                       >> "${TMP_PATH}/menu"
  echo "r \"Reboot\"" 				      >> "${TMP_PATH}/menu"
  echo "e \"Exit\""                                   >> "${TMP_PATH}/menu"
  dialog --clear --default-item ${NEXT} --backtitle "`backtitle`" --colors \
    --menu "Choose the option" 0 0 0 --file "${TMP_PATH}/menu" \
    2>${TMP_PATH}/resp
  [ $? -ne 0 ] && break
  case `<"${TMP_PATH}/resp"` in
    m) modelMenu; NEXT="s" ;;
    s) serialMenu; NEXT="d" ;;
    x) cmdlineMenu;;
    d) make; NEXT="e" ;;
    u) editUserConfig; NEXT="u" ;;
    k) keymapMenu ;;
    c) dialog --backtitle "`backtitle`" --title "Cleaning" --aspect 18 \
      --prgbox "rm -rfv \"${CACHE_PATH}/dl\"" 0 0 ;;
    r) reboot ;;
    e) break ;;
  esac
done
clear
echo -e "Call \033[1;32mmenu.sh\033[0m to return to menu"

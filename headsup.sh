#!/bin/bash
#Fonksiyonlar
function greenMessage {
  echo -e "\\033[32;1m${*}\033[0m"
}

function magentaMessage {
  echo -e "\\033[35;1m${*}\033[0m"
}

function cyanMessage {
  echo -e "\\033[36;1m${*}\033[0m"
}

function redMessage {
  echo -e "\\033[31;1m${*}\033[0m"
}

function yellowMessage {
  echo -e "\\033[33;1m${*}\033[0m"
}

function errorQuit {
  errorExit 'Exit now!'
}

function errorExit {
  redMessage "${@}"
  exit 0
}

function errorContinue {
  redMessage "Invalid option."
  return
}

#root Konrtolü...
clear
yellowMessage "Orkun @kemiksiz"
export hdcontrol
sdk=$(getprop ro.build.version.sdk)
control=$(ls /data > /dev/null 2>&1 ; echo $?)
sucontrol=$([ -f /system/*bin/su ]; echo $?)
sucontrol2=$(su -c "echo succesfully" > /dev/null 2>&1; echo $?)
hdcontrol=$(su -c 'settings get global heads_up_notifications_enabled' > /dev/null 2>&1; echo $?)
hdcontrol2=$(echo $hdcontrol)
if [ $sdk -le "18" ];then
  errorExit "Your sdk version is $sdk"
else
  greenMessage "Your sdk version $sdk"
  if [ $hdcontrol2 == "0" ];then
    cyanMessage "Current headsup status: Disable"
  else
    cyanMessage "Current headsup status: Enable"
  fi
  if [ "$USER" == "root" ]; then
    if [ $control == "0" ];then
    magentaMessage "Already root!"
       OPTIONS=("Enable" "Disable" "Exit")
    select OPTION in "${OPTIONS[@]}"; do
      case "$REPLY" in
        1|2|3 ) break;;
        4 ) errorQuit;;
        *) errorContinue;;
      esac
    done
  
    if [ "$OPTION" == "Enable" ]; then
    yellowMessage "Headsup enabling..."
    settings put global heads_up_notifications_enabled 1 >/dev/null
    greenMessage 'Success'
    elif [ "$OPTION" == "Disable" ]; then
    yellowMessage "Headsup disabling..."
    settings put global heads_up_notifications_enabled 0 >/dev/null
    greenMessage 'Success'
    elif [ "$OPTION" == "Exit" ]; then
    cyanMessage "Exiting..."
    fi
    else 
    redMessage "You are fake root! Checking root!.."
    if [ $sucontrol == "0" ] || [ $sucontrol2 == "0" ]; then
      yellowMessage "Root available. Trying sudo!"
    OPTIONS=("Enable" "Disable" "Exit")
    select OPTION in "${OPTIONS[@]}"; do
      case "$REPLY" in
        1|2|3 ) break;;
        4 ) errorQuit;;
        *) errorContinue;;
      esac
    done
  
    if [ "$OPTION" == "Enable" ]; then
    yellowMessage "Headsup enabling..."
    su -c 'settings put global heads_up_notifications_enabled 1' >/dev/null
    greenMessage 'Success'
    elif [ "$OPTION" == "Disable" ]; then
    yellowMessage "Headsup disabling..."
    su -c 'settings put global heads_up_notifications_enabled 0' >/dev/null
    greenMessage 'Success'
    elif [ "$OPTION" == "Exit" ]; then
    cyanMessage "Exiting..."
    fi
    else 
    errorExit "Your device not root! Exit now..."
   fi
fi

  else
   if [ $sucontrol == "0" ] || [ $sucontrol2 == "0" ]; then
      yellowMessage "Root available."
      greenMessage "You're not root, Trying with sudo!"
         OPTIONS=("Enable" "Disable" "Exit")
      select OPTION in "${OPTIONS[@]}"; do
        case "$REPLY" in
          1|2|3 ) break;;
          4 ) errorQuit;;
          *) errorContinue;;
        esac
      done
  
      if [ "$OPTION" == "Enable" ]; then
      yellowMessage "Headsup enabling..."
      su -c 'settings put global heads_up_notifications_enabled 1'
      magentaMessage 'Success'
      elif [ "$OPTION" == "Disable" ]; then
      yellowMessage "Headsup disabling..."
      su -c 'settings put global heads_up_notifications_enabled 0'
      magentaMessage 'Success'
      elif [ "$OPTION" == "Exit" ]; then
      cyanMessage 'Exiting...'

      fi
   else 
     errorExit "Your device not root! Exit now..."
   fi

  fi
fi

#!/bin/bash
set -e
source dependencies.sh
echo "Downloading BYOND version $BYOND_MAJOR.$BYOND_MINOR"
  #Try and grab the file from BYOND itself. We might fail (DoS or simply unavailable), if so we'll error out and go for a backup if one exists.
  $(curl --fail -H "User-Agent: daedalus/1.0 CI Script" "http://www.byond.com/download/build/${BYOND_MAJOR}/${BYOND_MAJOR}.${BYOND_MINOR}_byond_linux.zip" -o byond.zip)
  #22 - Unacceptable status code.
  if [ $? -eq 22 ];
  then
    #Try and retrieve the fallback download location.
    export FALLBACK_URL=$(printenv "DL_FALLBACK_${BYOND_MAJOR}_${BYOND_MINOR}")
    if [ -z $FALLBACK_URL];
    then
      echo "Download failed without fallback, Aborting"
      exit 22
    fi
    curl --fail -H "User-Agent: daedalus/1.0 CI Script" ${FALLBACK_URL} -o byond.zip
  else
    echo ""
  fi

#!/bin/bash
set -e
source dependencies.sh
echo "Downloading BYOND version $BYOND_MAJOR.$BYOND_MINOR"
set +e #We need to allow errors for a little bit.
#Try and grab the file from BYOND itself. We might fail (DoS or simply unavailable), if so we'll error out and go for a backup if one exists.
$(curl --fail -H "User-Agent: daedalus/1.0 CI Script" "http://www.byond.com/download/build/$BYOND_MAJOR/$BYOND_MAJOR.${BYOND_MINOR}_byond.zip" -o C:/byond.zip)
#22 - Unacceptable status code.
if [ $? -eq 22 ];
then
source tools/ci/fallbacks.sh
#Try and retrieve the fallback download location.
export FALLBACK_URL=$(printenv "DL_FALLBACK_${BYOND_MAJOR}_${BYOND_MINOR}_WIN")
if [ -z "$FALLBACK_URL" ];
then
  #Do we have a linux fallback?
  export FALLBACK_URL=$(printenv "DL_FALLBACK_${BYOND_MAJOR}_${BYOND_MINOR}")
  if [ -n "$FALLBACK_URL" ];
  then
    echo "No windows fallback provided, but a linux fallback exists. Did you forget?"
  else
    echo "Download failed without fallback, Aborting."
  fi
  exit 22
fi
set -e #Do or die time.
curl --fail -H "User-Agent: daedalus/1.0 CI Script" ${FALLBACK_URL} -o C:/byond.zip
else
set -e #Unset error allowance.
fi

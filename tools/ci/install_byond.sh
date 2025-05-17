#!/bin/bash
set -euo pipefail

# BYOND_MAJOR and BYOND_MINOR can be explicitly set, such as in alt_byond_versions.txt
if [ -z "${BYOND_MAJOR+x}" ]; then
  source dependencies.sh
fi

# Load possible fallback download URLs before we change directory.
source tools/ci/fallbacks.sh

if [ -d "$HOME/BYOND/byond/bin" ] && grep -Fxq "${BYOND_MAJOR}.${BYOND_MINOR}" $HOME/BYOND/version.txt;
then
  echo "Using cached directory."
else
  echo "Setting up BYOND."
  rm -rf "$HOME/BYOND"
  mkdir -p "$HOME/BYOND"
  cd "$HOME/BYOND"
  set +e #We need to allow errors for a little bit.
  #Try and grab the file from BYOND itself. We might fail (DoS or simply unavailable), if so we'll error out and go for a backup if one exists.
  $(curl --fail -H "User-Agent: daedalus/1.0 CI Script" "http://www.byond.com/download/build/${BYOND_MAJOR}/${BYOND_MAJOR}.${BYOND_MINOR}_byond_linux.zip" -o byond.zip)
  #22 - Unacceptable status code.
  if [ $? -eq 22 ];
  then
    #Try and retrieve the fallback download location.
    export FALLBACK_URL=$(printenv "DL_FALLBACK_${BYOND_MAJOR}_${BYOND_MINOR}")
    if [ -z "$FALLBACK_URL" ];
    then
      echo "Download failed without fallback, Aborting"
      exit 22
    fi
    set -e #Do or die time.
    curl --fail -H "User-Agent: daedalus/1.0 CI Script" ${FALLBACK_URL} -o byond.zip
  else
    set -e #Unset error allowance.
  fi
  unzip byond.zip
  rm byond.zip
  cd byond
  make here
  echo "$BYOND_MAJOR.$BYOND_MINOR" > "$HOME/BYOND/version.txt"
  cd ~/
fi

#!/usr/bin/env bash
set -o errexit
set -o nounset

# Ensure that we have a valid OTHER_LDFLAGS environment variable
OTHER_LDFLAGS=${OTHER_LDFLAGS:=""}

# Ensure that we have a valid LOOKINSERVER_FILENAME environment variable
LOOKINSERVER_FILENAME=${LOOKINSERVER_FILENAME:="LookinServer.framework"}

# Ensure that we have a valid LOOKINSERVER_PATH environment variable
LOOKINSERVER_PATH=${LOOKINSERVER_PATH:="${SRCROOT}/${LOOKINSERVER_FILENAME}"}

# The path to copy the framework to
app_frameworks_dir="${CODESIGNING_FOLDER_PATH}/Frameworks"

copy_library() {
  mkdir -p "$app_frameworks_dir"
  cp -vRf "$LOOKINSERVER_PATH" "${app_frameworks_dir}/"
}

codesign_library() {
  if [ -n "${EXPANDED_CODE_SIGN_IDENTITY}" ]; then
    codesign -fs "${EXPANDED_CODE_SIGN_IDENTITY}" "${app_frameworks_dir}/${LOOKINSERVER_FILENAME}"
  fi
}

main() {
  if  [[ $OTHER_LDFLAGS =~ "LookinServer" ]]; then
    if [ -e "$LOOKINSERVER_PATH" ]; then
      copy_library
      codesign_library
      echo "${LOOKINSERVER_FILENAME} is included in this build, and has been copied to $CODESIGNING_FOLDER_PATH"
    else
      echo "${LOOKINSERVER_FILENAME} is not included in this build, as it could not be found at $LOOKINSERVER_PATH"
    fi
  else
    echo "${LOOKINSERVER_FILENAME} is not included in this build because LookinServer was not present in the OTHER_LDFLAGS environment variable."
  fi
}

main

#!/bin/bash

# ---------------------------------------------------------------------
# SCRIPT VARIABLES

# gets the directory of this script
ROOTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

MY_USERNAME="${SUDO_USER:-$(logname 2> /dev/null || echo "${USER}")}"
MY_HOME=$(getent passwd "${MY_USERNAME}" | cut -d: -f6)

# where the custom CSS files are
# the script will copy the files from here to your themes folder
FIREFOX_SRC_DIR="$ROOTDIR/whitesur/src/other/firefox"

# local firefox config
FIREFOX_DIR_HOME="${MY_HOME}/.mozilla/firefox"

# the dir where you will put your custom CSS
# the `chrome` folder will be symlinked here
FIREFOX_THEME_DIR="${FIREFOX_DIR_HOME}/firefox-themes"

# ---------------------------------------------------------------------
# HELPER FUNCTIONS

# echo an error message and exit the script
oops() {
  echo "$0:" "$@" >&2
  exit 1
}

# args: $1 = a binary you want to require e.g. tar, gpg, mail
#       $2 = a message briefly describing what you need the binary for
require() {
  command -v "$1" > /dev/null 2>&1 \
    || oops "you do not have '$1' installed or its not in your PATH; needed for: $2"
}

# desc: remove ALL existing firefox themes if any are installed
remove_firefox_theme() {
  echo "Deleting all old firefox themes"
  rm -rf "${FIREFOX_DIR_HOME}/"*"default"*"/chrome"
  rm -rf "${FIREFOX_THEME_DIR}"
}

# desc: apply custom firefox config/hardening
config_firefox() {
  for d in "${FIREFOX_DIR_HOME}/"*"default"*; do
    echo "Applying firefox config to: ${d}"

    if [[ -f "${d}/prefs.js" ]]; then
      rm -rf                          "${d}/chrome"
      ln -sf "${FIREFOX_THEME_DIR}"   "${d}/chrome"

      # run the Arkenfox/userjs updater script
      # to install the hardened userjs (with custom overrides)
      "$ROOTDIR"/userjs/updater.sh \
        -p "${d}" \
        -o "$ROOTDIR"/user-overrides.js \
        -u \
        -s
    fi
  done
}

install_all_firefox_stuff() {
  # ensure that we're working with a clean set of folders
  remove_firefox_theme

  # ensure that the theme folder exists
  mkdir -p                                                       "${FIREFOX_THEME_DIR}"

  # copy all of the custom theme files to the theme folder
  cp -rf "${FIREFOX_SRC_DIR}"/Monterey                        -t "${FIREFOX_THEME_DIR}"
  cp -rf "${FIREFOX_SRC_DIR}"/WhiteSur/{icons,titlebuttons}   -t "${FIREFOX_THEME_DIR}"/Monterey
  cp -rf "${FIREFOX_SRC_DIR}"/userChrome-Monterey.css            "${FIREFOX_THEME_DIR}"/userChrome.css

  # if you've got a custom CSS file then throw that in as well
  if [[ -f "$ROOTDIR"/customChrome.css ]]; then
    cp -rf "$ROOTDIR"/customChrome.css                        -t "${FIREFOX_THEME_DIR}"
  fi

  # apply custom config & firefox hardening
  config_firefox
}

# ---------------------------------------------------------------------
# ACTUAL SCRIPT EXECUTION


# ensure that Firefox has been initialised and is not currently running

require pidof "check running processes"

if [[ ! -d "${FIREFOX_DIR_HOME}" ]]; then
  oops "ERROR: Firefox is installed but not yet initialised. Don't forget to close it after you run/initialise it"
elif pidof "firefox" &> /dev/null || pidof "firefox-bin" &> /dev/null; then
  oops "ERROR: Firefox is running, please close it"
fi


# install all custom firefox stuff

echo "Installing Firefox theme..."; echo
install_all_firefox_stuff
echo "Done! Firefox theme has been installed."; echo


# notify of steps to carry out after installation

echo "FIREFOX: Please go to [Firefox menu] > [Customize...], and customize your Firefox to make it work. Move your 'new tab' button to the titlebar instead of tab-switcher."
echo "FIREFOX: Anyways, you can also edit 'userChrome.css' and 'customChrome.css' later in your Firefox profile directory."
echo
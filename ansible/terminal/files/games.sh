#!/bin/bash

# ----------------------------------------------------------------------
# Variables

FZF_OPTS=(
    "--height" "30%"
    "--border"
    "--layout=reverse"
    "--cycle"
)

# ----------------------------------------------------------------------
# Util function/s

# echo an error message and exit the script
oops() {
    echo "$0:" "$@" >&2
    exit 1
}

# args: $1 = a binary you want to require e.g. tar, gpg, mail
#       $2 = a message briefly describing what you need the binary for
require() {
    command -v "$1" > /dev/null 2>&1 \
        || oops "you do not have '$1' installed; needed for: $2"
}

log() {
    echo "[$(date)] - $1"
}

do_validation() {
    require wine64 "for emulating Windows"

    if ! locale -a | grep -q ja_JP ; then
        oops "please install the japanese locale to continue"
    fi
}

GAMES="$HOME/Documents/VirtualMachines"

# ----------------------------------------------------------------------
# Actual logic

choose_action_and_do_it() {
    local OPTIONS=(
        'A Sky Full of Stars'
        'A Sky Full of Stars Fine Days'
        'Fureraba'
        'Hatsukoi 1/1'
        'Making Lovers'
        'Saku Saku Love Blooms With The Cherry Blossoms'
        'Sanoba Witch'
        'Senren Banka'
        'Sugar Style'
        'The Language of Love'
        'Totono'
    )

    local ACTION
    ACTION="$(printf '%s\n' "${OPTIONS[@]}" | fzf "${FZF_OPTS[@]}")"

    case "$ACTION" in
        'The Language of Love')
            if [ -f "$GAMES/VN_TheLanguageOfLove/lovelanguage.sh" ] ; then
                echo "running $ACTION"
                ("$GAMES/VN_TheLanguageOfLove/lovelanguage.sh")
            else
                oops "you don't have '$ACTION' in $GAMES"
            fi
            ;;

        'A Sky Full of Stars')
            if [ -f "$GAMES/VN_ASkyFullofStars/AdvHD.exe" ] ; then
                echo "running '$ACTION'"
                echo "if the game hasn't launched correctly, chmod +x the .exe file"
                ( set -x; export LANG=ja_JP.utf8 \
                    && wine64 "$GAMES/VN_ASkyFullofStars/AdvHD.exe" &>/dev/null & )
            else
                oops "you don't have '$ACTION' in $GAMES"
            fi
            ;;

        'A Sky Full of Stars Fine Days')
            if [ -f "$GAMES/VN_ASkyFullofStarsFineDays/AdvHD.exe" ] ; then
                echo "running '$ACTION'"
                echo "if the game hasn't launched correctly, chmod +x the .exe file"
                ( set -x; export LANG=ja_JP.utf8 \
                    && wine64 "$GAMES/VN_ASkyFullofStarsFineDays/AdvHD.exe" &>/dev/null & )
            else
                oops "you don't have '$ACTION' in $GAMES"
            fi
            ;;

        'Fureraba')
            if [ -f "$GAMES/VN_Fureraba/Setup.exe" ] ; then
                echo "running '$ACTION'"
                echo "if the game hasn't launched correctly, chmod +x the .exe file"
                ( set -x; export LANG=ja_JP.utf8 \
                    && wine64 "$GAMES/VN_Fureraba/Setup.exe" &>/dev/null & )
            else
                oops "you don't have '$ACTION' in $GAMES"
            fi
            ;;

        'Hatsukoi 1/1')
            if [ -f "$GAMES/VN_Hatsukoi_1_1/game/toneworks/Hatsukoi/SiglusEngine.exe" ] ; then
                echo "running '$ACTION'"
                ( set -x; export LANG=ja_JP.utf8 \
                    && wine64 "$GAMES/VN_Hatsukoi_1_1/game/toneworks/Hatsukoi/SiglusEngine.exe" &>/dev/null & )
            else
                oops "you don't have '$ACTION' in $GAMES"
            fi
            ;;

        'Making Lovers')
            if [ -f "$GAMES/VN_MakingLovers/MakingLovers.exe" ] ; then
                echo "running '$ACTION'"
                ( set -x; export LANG=ja_JP.utf8 \
                    && wine64 "$GAMES/VN_MakingLovers/MakingLovers.exe" &>/dev/null & )
            else
                oops "you don't have '$ACTION' in $GAMES"
            fi
            ;;

        'Saku Saku Love Blooms With The Cherry Blossoms')
            if [ -f "$GAMES/VN_SakuSakuLoveBloomsWithTheCherryBlossoms/sakusaku.exe" ] ; then
                echo "running '$ACTION'"
                ( set -x; export LANG=ja_JP.utf8 \
                    && wine64 "$GAMES/VN_SakuSakuLoveBloomsWithTheCherryBlossoms/sakusaku.exe" &>/dev/null & )
            else
                oops "you don't have '$ACTION' in $GAMES"
            fi
            ;;

        'Sanoba Witch')
            if [ -f "$GAMES/VN_SanobaWitch/SabbatOfTheWitch.exe" ] ; then
                echo "running '$ACTION'"
                ( set -x; export LANG=ja_JP.utf8 \
                    && wine64 "$GAMES/VN_SanobaWitch/SabbatOfTheWitch.exe" &>/dev/null & )
            else
                oops "you don't have '$ACTION' in $GAMES"
            fi
            ;;

        'Senren Banka')
            if [ -f "$GAMES/VN_SenrenBanka/SenrenBanka.exe" ] ; then
                echo "running '$ACTION'"
                ( set -x; export LANG=ja_JP.utf8 \
                    && wine64 "$GAMES/VN_SenrenBanka/SenrenBanka.exe" &>/dev/null & )
            else
                oops "you don't have '$ACTION' in $GAMES"
            fi
            ;;

        'Sugar Style')
            if [ -f "$GAMES/VN_SugarStyle/SugarStyle.exe" ] ; then
                echo "running '$ACTION'"
                ( set -x; export LANG=ja_JP.utf8 \
                    && wine64 "$GAMES/VN_SugarStyle/SugarStyle.exe" &>/dev/null & )
            else
                oops "you don't have '$ACTION' in $GAMES"
            fi
            ;;

        'Totono')
            echo "this game doesn't work, run it manually"
            ;;

        *)
            exit 0
            ;;
    esac
}

# ----------------------------------------------------------------------
# Main script execution

do_validation
choose_action_and_do_it


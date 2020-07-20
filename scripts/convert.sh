#/bin/bash

main() {
    cat "$1" \
        | sed "/.*:.*/d" \
        | sed "/.*tutanota/d" \
        | sed "/^$/d" \
        | sed '/^[[:space:]]*$/d' \
        | tr '\r\n' ' ' \
        | sed "s/\ //g" \
        | base64 --decode \
        | pandoc -t plain
}

main "$@"

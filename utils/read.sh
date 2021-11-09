BASEDIR="$(dirname "${BASH_SOURCE[0]}")"
source "$BASEDIR/print.sh"

prompt_and_read() {
    local prmpt="$1"
    local deflt="$2"
    local out="$3"

    echo -n "$prmpt"
    if [[ -n "$deflt" ]]; then echo " [$deflt]:"; else echo ':'; fi
    read -p '> ' inpt
    if [[ -z "$inpt" && -n "$deflt" ]]; then
        inpt="$deflt"
    fi

    eval "$out=\$inpt"
}

prompt_and_pasw() {
    local prmpt="$1"
    local out="$2"

    echo "$prmpt: (leave blank to generate a random one)"
    read -sp '> ' inpt
    echo
    if [[ -z "$inpt" ]]; then
        inpt=$(pwgen -s 32 1)
    fi

    eval "$out=\$inpt"
}

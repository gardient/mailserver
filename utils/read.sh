BASEDIR="$(dirname "${BASH_SOURCE[0]}")"
source "$BASEDIR/print.sh"

prompt_and_read() {
    local prmpt="$1"
    local deflt="$2"
    local out="$3"

    echo -n "$prmpt"
    if [[ -n "$deflt" ]]; then echo " [$deflt]:"; else echo ':'; fi
    echo -n '> '
    read inpt
    if [[ -z "$inpt" && -n "$deflt" ]]; then
        inpt="$deflt"
    fi

    eval "$out=\$inpt"
}

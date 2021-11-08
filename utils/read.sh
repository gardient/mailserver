BASEDIR="$(dirname "${BASH_SOURCE[0]}")"
source "$BASEDIR/print.sh"

prompt_and_read() {
    prmpt="$1"
    deflt="$2"
    out="$3"

    echo -n "$prmpt"
    if [[ -n "$deflt" ]]; then echo "[$deflt]"; else echo '' fi
    read inpt
    if [[ -z "$inpt" && -n "$deflt" ]]; then
        inpt="$deflt"
    fi

    eval "$out=\$inpt"
}

BASEDIR="$(dirname "${BASH_SOURCE[0]}")"
source "$BASEDIR/env.sh"

_inst_data_getpath() {
    echo "$INSTALLER_DATA/$1.dat"
}

_inst_data_load() {
    local store="$(_inst_data_getpath $1)"
    local key val
    set -a
    if [[ -f "$store" ]]; then
        while read -r line; do
            if [[ $line =~ ^[[:alpha:]_]*=.*$ ]]; then
                key=$(cut -d= -f1 <<< "$line" | sed 's/[[:space:]]*$//')
                val=$(cut -d= -f2- <<< "$line" | sed -e 's/^[[:space:]]*//' -e s/^\'// -e s/\'$//)
                __ensure_env "$key" "$val"
            fi
        done < "$store"
    fi
    set +a
}

_inst_data_save() {
    local store="$(_inst_data_getpath $1)"
    local key="$2"
    local val="$3"

    if [[ -f "$store" ]]; then
        # the lazy way of removing a key from the store
        egrep -v "^$key[[:space:]]*=.*$" "$store" > "$store.swp"
        mv "$store.swp" "$store"
    fi

    echo "$key='$val'" >> "$store"
    chmod 600 "$store"
}

_inst_step_hasrun() {
    [[ -f "$INSTALLER_DATA/$1.step" ]]
}

_inst_step_success() {
    touch "$INSTALLER_DATA/$1.step"
}

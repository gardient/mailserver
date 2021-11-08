BASEDIR="$(dirname "${BASH_SOURCE[0]}")"
source "$BASEDIR/env.sh"

_inst_data_load() {
    local store="$1"
    local key val
    set -a
    if [[ -f "$INSTALLER_DATA/$store.dta" ]]; then
        while read -r line; do
            if [[ $line =~ ^[[:alpha:]_]*=.*$ ]]; then
                key=$(cut -d= -f1 <<< "$line" | sed 's/[[:space:]]*$//')
                val=$(cut -d= -f2- <<< "$line" | sed -e 's/^[[:space:]]*//' -e s/^\'// -e s/\'$//)
                __ensure_env "$key" "$val"
            fi
        done < "$INSTALLER_DATA/$store.dta"
    fi
    set +a
}

_inst_data_save() {
    local store="$1"
    local key="$2"
    local val="$3"

    if [[ -f "$INSTALLER_DATA/$store.dta" ]]; then
        # the lazy way of removing a key from the store
        egrep -v "^$key[[:space:]]*=.*$" "$INSTALLER_DATA/$store.dta" > "$INSTALLER_DATA/$store.dta.swp"
        mv "$INSTALLER_DATA/$store.dta.swp" "$INSTALLER_DATA/$store.dta"
    fi

    echo "$key='$val'" > "$INSTALLER_DATA/$store.dta"
    chmod 600 "$INSTALLER_DATA/$store.dta"
}

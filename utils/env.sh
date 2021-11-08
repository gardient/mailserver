__ensure_env() {
    if [[ -z $(eval "echo \${$1}") ]]; then
        eval "$1=\${2}"
    fi
}

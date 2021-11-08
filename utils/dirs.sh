__ensure_directory_exists() {
    if [[ ! -d "$1" ]]; then
        mkdir "$1"
    fi
}
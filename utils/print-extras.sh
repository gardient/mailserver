BASEDIR="$(dirname "${BASH_SOURCE[0]}")"
source "$BASEDIR/env.sh"

set -a
__ensure_env term_rst '\e[0m'
__ensure_env term_err '\e[0;31m'
__ensure_env term_suc '\e[0;32m'
__ensure_env term_wrn '\e[0;33m'
__ensure_env term_inf '\e[0;94m'
set +a

__print() {
    echo -e "$1$2${term_rst}\n"
}

print_err() {
    __print $term_err "${@}"
}

print_suc() {
    __print $term_suc "${@}"
}

print_wrn() {
    __print $term_wrn "${@}"
}

print_inf() {
    __print $term_inf "${@}"
}

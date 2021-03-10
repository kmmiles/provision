if [[ -z "${BASH_SOURCE[1]:-}" ]]; then
  printf "Don't source from the shell.\n"
  return 1
fi

# Directory of the script that sourced this library. 
__DIR="$(cd "$(dirname "${BASH_SOURCE[1]}")" && pwd)"
# Filename of the script that sourced this library.
__FILE="${__DIR}/$(basename "${BASH_SOURCE[1]}")"
# Parent directory of the script that sourced this library.
__ROOT="$(cd "$(dirname "${__DIR}")" && pwd)"
export __DIR __FILE __ROOT __SOURCE

# source library modules
# shellcheck disable=SC1090
for s in "$__ROOT"/lib/provision.sh.d/*.sh; do source "$s"; done

# set options
set -o errexit
set -o pipefail
set -o nounset

# set trap
trap handle_trap_err ERR

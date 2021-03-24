# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Source any bashrc files
bashrcd="$HOME/.config/bashrc.d"
if [[ -d "$bashrcd" ]]; then
  for b in "$bashrcd"/*.sh; do
    # shellcheck disable=SC1090
    source "$b"
  done
fi

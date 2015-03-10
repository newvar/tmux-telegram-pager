#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/shared.sh"
source "$CURRENT_DIR/variables.sh"

DIR_PATH="$(echo "$1" | tail -1)" # fixes a bug with invalid param
WIDTH="$2"
delimiter=$'\t'

replace_directory_width() {
	sed "s|^${DIR_PATH}${delimiter}.*|${DIR_PATH}${delimiter}${WIDTH}|g" $(tg_file) > $(tg_file).bak
	mv $(tg_file).bak $(tg_file)
}

add_directory_width() {
	mkdir -p "$(tg_dir)"
	echo "${DIR_PATH}${delimiter}${WIDTH}" >> $(tg_file)
}

save_tg_width() {
	if directory_in_tg_file "$DIR_PATH"; then
		replace_directory_width
	else
		add_directory_width
	fi
}

main() {
	save_tg_width
}
main

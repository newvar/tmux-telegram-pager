get_tmux_option() {
	local option=$1
	local default_value=$2
	local option_value=$(tmux show-option -gqv "$option")
	if [ -z "$option_value" ]; then
		echo $default_value
	else
		echo $option_value
	fi
}

set_tmux_option() {
	local option=$1
	local value=$2
	tmux set-option -gq "$option" "$value"
}

is_osx() {
	[ $(uname) == "Darwin" ]
}

is_cygwin() {
	command -v WMIC > /dev/null
}

command_exists() {
	local command="$1"
	type "$command" >/dev/null 2>&1
}

get_pane_info() {
	local pane_id="$1"
	local format_strings="#{pane_id},$2"
	tmux list-panes -t "$pane_id" -F "$format_strings" |
		\grep "$pane_id" |
		cut -d',' -f2-
}

tg_dir() {
	echo "$TG_DIR"
}

tg_file() {
	echo "$(tg_dir)/directory_widths.txt"
}

directory_in_tg_file() {
	grep -q "^$1" $(tg_file) 2>/dev/null
}

width_from_tg_file() {
	grep "^$1" $(tg_file) |
		cut -f2
}

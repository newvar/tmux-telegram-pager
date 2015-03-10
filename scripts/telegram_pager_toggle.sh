#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/shared.sh"
source "$CURRENT_DIR/variables.sh"
source "$CURRENT_DIR/save_tg_width.sh"

PANE_ID="$1"
PANE_WIDTH="$(get_pane_info "$PANE_ID" "#{pane_width}")"
PANE_CURRENT_PATH="$(get_pane_info "$PANE_ID" "#{pane_current_path}")"

pane_registration() {
	get_tmux_option "${REGISTERED_PANE_PREFIX}-${PANE_ID}" ""
}
tg_pane_id() {
	pane_registration |
		cut -d',' -f1
}
register_tg() {
    local tg_id="$1"
    set_tmux_option "${REGISTERED_TG_PREFIX}-${tg_id}" "$PANE_ID"
    set_tmux_option "${REGISTERED_PANE_PREFIX}-${PANE_ID}" "${tg_id}"
}
tg_exists() {
	local pane_id="$(tg_pane_id)"
	tmux list-panes -F "#{pane_id}" 2>/dev/null |
		\grep -q "^${pane_id}$"
}
has_tg() {
	if [ -n "$(pane_registration)" ] && tg_exists; then
		return 0
	else
		return 1
	fi
}
current_pane_width_not_changed() {
	if [ $PANE_WIDTH -eq $1 ]; then
		return 0
	else
		return 1
	fi
}
kill_tg() {
	# get data before killing the tg
	local tg_pane_id="$(tg_pane_id)"
	local tg_width="$(get_pane_info "$tg_pane_id" "#{pane_width}")"

	$CURRENT_DIR/save_tg_width.sh "$PANE_CURRENT_PATH" "$tg_width"

	# kill the tg
	tmux kill-pane -t "$tg_pane_id"

	# check current pane "expanded" properly
	local new_current_pane_width="$(get_pane_info "$PANE_ID" "#{pane_width}")"
	if current_pane_width_not_changed "$new_current_pane_width"; then
		# need to expand current pane manually
		local direction_flag
        direction_flag="-R"
		# compensate 1 column
		tmux resize-pane "$direction_flag" "$((tg_width + 1))"
	fi
	PANE_WIDTH="$new_current_pane_width"
}
size_defined() {
	[ -n $SIZE ]
}
desired_tg_size() {
	local half_pane="$((PANE_WIDTH / 2))"
	if directory_in_tg_file "$PANE_CURRENT_PATH"; then
		# use stored tg width for the directory
		echo "$(width_from_tg_file "$PANE_CURRENT_PATH")"
	elif size_defined && [ $SIZE -lt $half_pane ]; then
		echo "$SIZE"
	else
		echo "$half_pane"
	fi
}
split_tg_right() {
	local tg_size=$(desired_tg_size)
    local port=$(get_tmux_option "$telegram_pager_port" "$telegram_pager_default_port")
    local args=$(get_tmux_option "$telegram_pager_args" "$telegram_pager_default_args")
    local tmux=$(get_tmux_option "$telegram_pager_tmux" "$telegram_pager_default_tmux")
    local session=$(get_tmux_option "$telegram_pager_session" "$telegram_pager_default_session")
    local tmux_conf=$(get_tmux_option "$telegram_pager_tmux_conf" $CURRENT_DIR/tmux.telegram.conf)
    local COMMAND="tmux -L ${tmux} attach -t ${session} || tmux -L ${tmux} -f ${conf} new -s ${session} \"telegram-cli ${args} -P${port}; tmux kill-server\""
	tmux split-window -h -l "$tg_size" -c "$PANE_CURRENT_PATH" -P -F "#{pane_id}" "echo \"${COMMAND}\""
}
create_tg() {
	local position="$1" # left / right
	local tg_id="$(split_tg_${position})"
	register_tg "$tg_id"
}
current_pane_is_tg() {
	local var="$(get_tmux_option "${REGISTERED_TG_PREFIX}-${PANE_ID}" "")"
	[ -n "$var" ]
}
execute_command_from_main_pane() {
	# get pane_id for this sidebar
	local main_pane_id="$(get_tmux_option "${REGISTERED_TG_PREFIX}-${PANE_ID}" "")"
	# execute the same command as if from the "main" pane
	$CURRENT_DIR/telegram_pager_toggle.sh "$main_pane_id"
}
toggle_tg() {
	if has_tg; then
		kill_tg
	else
		#exit_if_pane_too_narrow
        create_tg "right"
	fi
}

main() {
    if current_pane_is_tg; then
        execute_command_from_main_pane
    else
        toggle_tg
    fi
}
main

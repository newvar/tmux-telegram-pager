#!/usr/bin/env bash

source "$CURRENT_DIR/scripts/shared.sh"

toggle_default="C-t"
toggle_option="@telegram-pager-toggle"

telegram_pager_toggle_key() {
	echo "$(get_tmux_option "$toggle_option" "$toggle_default")"
}

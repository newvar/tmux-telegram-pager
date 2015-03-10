#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/scripts/shared.sh"
source "$CURRENT_DIR/scripts/variables.sh"

set_toggle_pager_bindings() {
	local key_bindings=$(get_tmux_option "$telegram_pager_toggle" "$telegram_pager_toggle_default")
	local key
	for key in $key_bindings; do
		tmux bind-key "$key" run-shell "$CURRENT_DIR/scripts/toggle.sh"
	done
}

main() {
    set_toggle_pager_bindings
}
main

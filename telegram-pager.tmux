#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/scripts/shared.sh"
source "$CURRENT_DIR/scripts/variables.sh"
source "$CURRENT_DIR/scripts/key_bindings_helper.sh"

set_toggle_pager_bindings() {
    tmux bind-key "$(telegram_pager_toggle_key)" run-shell "$CURRENT_DIR/scripts/telegram_pager_toggle.sh '#{pane_id}'"
}

main() {
    set_toggle_pager_bindings
}
main

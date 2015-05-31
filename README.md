# Tmux Telegram Pager

This plugin is used for quick access to the same Telegram CLI (TG CLI) instance from any split, window or session you currently use. This tmux plugin starts a separate tmux server with TG CLI inside and creates a split with the tmux server attached.

You able to use it with [Tmux Telegram Unread](https://github.com/newvar/tmux-telegram-daemon-unread)

### Usage

Use shortcut (C-t by default) to open a pager split in tmux. It starts separated tmux server (if not started), then it starts TG CLI instance. If you quit from the TG CLI or kill it, the tmux server quits too. You can use this behaviour to easely restart TG CLI: kill it and open pager by the shortcut again.

Tmux server starts with different .tmux.conf (you can find it in plugin folder). You can change the path in the configuration.

### Configuration

Configuration is not required, but you can specify these settings.

- Set shortcut for open/close split (C-t is by default)

        set -g @telegram-pager-toggle 'C-t'

- Set telegram-cli port with the setting in `.tmux.conf`:

        set -g @telegram-pager-port '2391'

- Set telegram-cli starting options (-NWl1 is by default)

        set -g @telegram-pager-args '-NWl1'

- Set tmux server socket name (-L option, "telegram" is by default)

        set -g @telegram-pager-tmux 'telegram'

- Set tmux server session name ("tg" is by default)

        set -g @telegram-pager-session 'tg'

- Set tmux server configuration file path (-f option, internal tmux.telegram.conf is by default)

        set -g @telegram-pager-tmux-conf '~/.tmux.telegram.conf'

### Dependecies

Depends on
* [Telegram CLI](https://github.com/vysheng/tg)

### Known issues

TG CLI fails sometimes if there is no connection, its tmux server stops right after that. Check your connection and pager settings if a split doesn't open or closes right after opening.

### Installation with [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) (recommended)

Add plugin to the list of TPM plugins in `.tmux.conf`:

    set -g @tpm_plugins '                  \
      tmux-plugins/tpm                     \
      newvar/tmux-telegram-pager           \
    '

Hit `prefix + I` to fetch the plugin and source it. You should now be able to
use the plugin.

### Manual Installation

Clone the repo:

    $ git clone https://github.com/newvar/tmux-telegram-pager ~/clone/path

Add this line to the bottom of `.tmux.conf`:

    run-shell ~/clone/path/tmux-telegram-pager.tmux

Reload TMUX environment:

    # type this in terminal
    $ tmux source-file ~/.tmux.conf

You should now be able to use the plugin.

# License

Inspired by [Tmux Sidebar Plugin](https://github.com/tmux-plugins/tmux-sidebar)

MIT

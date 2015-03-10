# Tmux Telegram Pager

TODO create description

### Usage

TODO describe usage

### Configuration

Configuration is not required, but you can specify the port of telegram-cli instance and netcat timeout.

- Set telegram-cli port with the setting in `.tmux.conf`:

        set -g @telegram-daemon-port '2391'

- Set netcat connection timeout (in seconds). Try it only if something doesn't work:

        set -g @telegram-daemon-timeout '1'

### Dependecies

Depends on
* [Telegram CLI](https://github.com/vysheng/tg)
* nc (netcat)

Update time depends on status-interval option

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

MIT

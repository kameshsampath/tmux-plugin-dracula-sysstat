### [tmux](https://github.com/tmux/tmux/wiki)

#### Install using tpm

If you are a tpm user, you can install the theme and keep up to date by adding the following to your .tmux.conf file:

	set -g @plugin 'kameshsampath/tmux'

#### Activating theme

1. Make sure  `run -b '~/.tmux/plugins/tpm/tpm'` is at the bottom of your .tmux.conf
2. Run tmux
3. Use the tpm install command: `prefix + I` (default prefix is ctrl+b)

#### Configuration

Customize the status bar by adding any of these lines to your .tmux.conf as desired:  
* Disable battery functionality: `set -g @dracula-show-battery false`
* Disable network functionality: `set -g @dracula-show-network false`
* Disable weather functionality: `set -g @dracula-show-weather false`
* Switch from default fahrenheit to celsius: `set -g @dracula-show-fahrenheit false`

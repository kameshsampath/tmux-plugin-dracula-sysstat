#!/usr/bin/env bash

current_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$current_dir/helpers.sh"

get_tmux_option() {
  local option=$1
  local default_value=$2
  local option_value=$(tmux show-option -gqv "$option")
  if [ -z $option_value ]; then
    echo $default_value
  else
    echo $option_value
  fi
}

placeholders=(
  "\#{sysstat_cpu}"
  "\#{sysstat_mem}"
  # "\#{sysstat_swap}"
  # "\#{sysstat_loadavg}"
)

commands=(
  "#($current_dir/cpu.sh)"
  "#($current_dir/mem.sh)"
  # "#($current_dir/swap.sh)"
  # "#($current_dir/loadavg.sh)"
)


# Dracula Color Pallette
white='#f8f8f2'
gray='#44475a'
dark_gray='#282a36'
light_purple='#bd93f9'
dark_purple='#6272a4'
cyan='#8be9fd'
green='#50fa7b'
orange='#ffb86c'
red='#ff5555'
pink='#ff79c6'
yellow='#f1fa8c'

do_interpolation() {
  local all_interpolated="$1"
  for ((i=0; i<${#commands[@]}; i++)); do
    all_interpolated=${all_interpolated//${placeholders[$i]}/${commands[$i]}}
  done
  echo "$all_interpolated"
}

update_tmux_option() {
  local option="$1"
  local option_value="$(get_tmux_option "$option")"
  local new_option_value="$(do_interpolation "$option_value")"
  set_tmux_option "$option" "$new_option_value"
}

main()
{


  # sysstat
  cpu_tmp_dir=$(mktemp -d)
  tmux set-option -gq "@sysstat_cpu_tmp_dir" "$cpu_tmp_dir"

  # set configuration option variables
  show_battery=$(get_tmux_option "@dracula-show-battery" true)
  show_network=$(get_tmux_option "@dracula-show-network" true)
  show_weather=$(get_tmux_option "@dracula-show-weather" true)
  show_fahrenheit=$(get_tmux_option "@dracula-show-fahrenheit" true)


  # start weather script in background
  if $show_weather; then
    $current_dir/sleep_weather.sh $show_fahrenheit &
  fi

  # set refresh interval
  tmux set-option -g status-interval 5

  # set clock
  tmux set-option -g clock-mode-style 12

  # set length 
  tmux set-option -g status-left-length 100
  tmux set-option -g status-right-length 100

  # pane border styling
  tmux set-option -g pane-active-border-style "fg=${dark_purple}"
  tmux set-option -g pane-border-style "fg=${gray}"

  # message styling
  tmux set-option -g message-style "bg=${gray},fg=${white}"

  # status bar
  tmux set-option -g status-style "bg=${gray},fg=${white}"

  tmux set-option -g status-left "#[bg=${green},fg=${dark_gray}]#{?client_prefix,#[bg=${yellow}],} ☺ " 

  tmux set-option -g  status-right ""

  tmux set-option -g  status-right "#[fg=${dark_gray},bg=${pink}] #($current_dir/battery.sh) "

  update_tmux_option "status-right"
  # update_tmux_option "status-left"

  tmux set-option -ga status-right "#[bg=${yellow}]  #($current_dir/cpu.sh) "

	tmux set-option -ga status-right " #($current_dir/mem.sh) "

  tmux set-option -ga status-right "#[fg=${white},bg=${dark_purple}] %m/%d %I:%M %p #(date +%Z) "
  
  # window tabs 
  tmux set-window-option -g window-status-current-format "#[fg=${white},bg=${dark_purple}] #I #W "
  tmux set-window-option -g window-status-format "#[fg=${white}]#[bg=${gray}] #I #W "

}

# run main function
main

#!/bin/sh

# Ensure the script runs as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Total number of tasks for progress calculation
total_tasks=6
current_task=0

# Define output file with timestamp
output_file="audioTestlib_$(date +%Y%m%d%H%M%S).log"

# Get the directory where the script is located
MODDIR=$(dirname "$(readlink -f "$0")")

# Function to update the progress bar
update_progress() {
  current_task=$((current_task + 1))
  percentage=$((current_task * 100 / total_tasks))
  echo "Progress: $percentage% complete" | tee -a "$output_file"
}

# Function to add colored section headers for better readability
add_section_header() {
  echo -e "\033[1;32m======================== $1 ========================\033[0m" | tee -a "$output_file"
}

# Function to run a script and append output to the log file
run_script() {
  script_name=$1
  options=$2
  add_section_header "$script_name"
  su -c "/system/bin/sh $MODDIR/$script_name $options" 2>&1 | tee -a "$output_file"
  sleep 3
  update_progress
}

# Parse command-line arguments to select specific scripts to run
run_all=0
run_alsa=0
run_dumpsys_audio=0
run_audio_conf_src=0
run_dumpsys_bt=0
run_dmesg_audio=0
run_tinymix=0

while getopts "agbdtmA" opt; do
  case $opt in
    a) run_alsa=1 ;;
    g) run_audio_conf_src=1 ;;
    b) run_dumpsys_bt=1 ;;
    d) run_dumpsys_audio=1 ;;
    m) run_dmesg_audio=1 ;;
    t) run_tinymix=1 ;;
    A) run_all=1 ;;
    *) echo "Invalid option"; exit 1 ;;
  esac
done

# If -all option is used, set all scripts to run
if [ $run_all -eq 1 ]; then
  run_alsa=1
  run_audio_conf_src=1
  run_dumpsys_bt=1
  run_dumpsys_audio=1
  run_dmesg_audio=1
  run_tinymix=1
fi

# If no options were specified, default to running all scripts
if [ $run_alsa -eq 0 ] && [ $run_audio_conf_src -eq 0 ] && [ $run_dumpsys_bt -eq 0 ] && [ $run_dumpsys_audio -eq 0 ] && [ $run_dmesg_audio -eq 0 ] && [ $run_tinymix -eq 0 ]; then
  run_alsa=1
  run_audio_conf_src=1
  run_dumpsys_bt=1
  run_dumpsys_audio=1
  run_dmesg_audio=1
  run_tinymix=1
fi

# Run selected scripts
[ $run_alsa -eq 1 ] && run_script "alsa-dac-profile.sh" "--all"
[ $run_audio_conf_src -eq 1 ] && run_script "audio-conf-src.sh" ""
[ $run_dumpsys_bt -eq 1 ] && run_script "dumpsys-bt.sh" "--all"
[ $run_dumpsys_audio -eq 1 ] && run_script "dumpsys-audio.sh" "--all"
[ $run_dmesg_audio -eq 1 ] && run_script "dmesg-audio.sh" "--all"
[ $run_tinymix -eq 1 ] && add_section_header "/system/bin/tinymix" && /system/bin/tinymix 2>&1 | tee -a "$output_file" && update_progress

# Indicate script completion
add_section_header "Complete"

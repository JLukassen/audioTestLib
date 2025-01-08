#!/bin/bash

# Filter and display audio-related logs from dmesg
filter_logs() {
  local filter_type=$1
  local pattern=$2
  echo "======================== ${filter_type} ========================"
  dmesg | grep -iE "$pattern"
}

# Filter for common audio-related terms
filter_logs "Audio-related dmesg logs" 'alsa|snd|audio|sound|codec|speaker|headset|pcm|hdmi|i2s|hdaudio|volume|mixer|amplifier|equalizer'

# Append additional troubleshooting information, such as errors or warnings
filter_logs "Error and Warning logs" 'error|fail|warn|fault'

# Add final message to indicate script completion
echo "Audio troubleshooting logs displayed"

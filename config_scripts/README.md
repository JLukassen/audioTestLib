# Audio Configuration Scripts - README

## Overview

This directory contains various shell scripts used for audio configuration and optimization on Android devices. These scripts are intended to be used in conjunction with a Magisk module, which installs the necessary tools and binaries, such as `tinymix`, and provides access to advanced audio settings and configurations. The goal is to provide flexible audio configurations for users seeking more control over their device's audio subsystem.

## Directory Structure

```
config_scripts/
  |— USB_48k_24_offload-hifi-playback.sh # Script for 48kHz/24-bit USB hi-fi playback offload
  |— USB_SampleRate_Changer.sh           # Script to change USB sample rate
  |— change-usb-period.sh                # Adjust USB audio period settings
  |— functions3.shlib                    # Library of functions for audio configuration
  |— jitter-reducer-functions.shlib      # Functions for reducing audio jitter
  |— jitter-reducer.sh                   # Main script to reduce audio jitter
  |— jitterLiteReducer.sh                # Lightweight version of the jitter reducer
  |— jitterReducer.sh                    # General audio jitter reduction script
  |— jitterrestore_sh.sh                 # Restore audio jitter settings
  |— offload-hifi-playback.sh            # Script for hi-fi playback offload
  |— resampling.sh                       # Script for resampling audio configurations
  |— readme.md                           # Documentation file
```


## Scripts Description

### 1. `USB_48k_24_offload-hifi-playback.sh`
This script configures the system for 48kHz/24-bit USB hi-fi audio playback with offload capabilities, ensuring optimal performance and audio quality.

### 2. `USB_SampleRate_Changer.sh`
This script allows users to change the sample rate for USB audio devices, providing flexibility for various audio setups and hardware compatibility.

### 3. `change-usb-period.sh`
This script adjusts the USB audio period settings to improve performance and reduce latency during playback or recording.

### 4. `functions3.shlib`
A library of reusable functions designed to simplify and modularize audio configuration tasks, supporting the primary scripts in the directory.

### 5. `jitter-reducer-functions.shlib`
This library contains specialized functions to reduce audio jitter, enhancing sound stability and minimizing playback artifacts.

### 6. `jitter-reducer.sh`
The primary script for reducing audio jitter by applying optimal configurations and leveraging helper functions from the associated library.

### 7. `jitterLiteReducer.sh`
A lightweight version of the jitter reduction script, offering a simpler and faster alternative for basic jitter management.

### 8. `jitterReducer.sh`
A general-purpose script for managing and reducing audio jitter across different hardware and software setups.

### 9. `jitterrestore.sh`
This script restores the audio jitter settings to their default or previously saved state, ensuring a fallback option if issues arise.

### 10. `offload-hifi-playback.sh`
A script to enable hi-fi audio playback offloading, improving efficiency and ensuring high-quality audio output.

### 11. `resampling.sh`
This script manages audio resampling configurations, allowing adjustments to sample rates for compatibility and performance tuning.


## Usage Instructions

### Prerequisites
1. **Tinymix**: Ensure that the `tinymix` binary is installed on your device (either in `/system/bin` or `/vendor/bin`). 
2. **Root Access**: The scripts require root privileges to modify system-level audio settings.
3. **Executable Permissions**: Ensure all scripts are executable:
   ```sh
   chmod +x *.sh
   ```
### Running a Script
To run any of the configuration scripts, open a terminal emulator on your Android device or use ADB. Here’s an example command:

```sh
su -c /path/to/config_scripts/<script_name>.sh
```

Replace `<script_name>.sh` with the name of the script you wish to execute.


### Example Scenarios
- **Optimize USB Audio Period Settings**: Run `change-usb-period.sh` to adjust the USB audio period settings to improve performance and reduce latency during playback.
- **Reduce Latency**: Run `reduce_jitter.sh` to minimize jitter, which may be helpful during audio playback for latency-sensitive applications.
- **Restore Jitter Defaults**: To restore the audio jitter settings back to their default, simply run `jitterrestore.sh`.

## Important Notes
- **Backup**: Always create a backup of your current audio configuration before making changes. This ensures that you can restore functionality in case of any issues.
- **Testing**: After applying changes, test different audio scenarios (e.g., calls, media playback, recording) to verify that the settings are applied correctly and there are no unwanted side effects.

## Troubleshooting
- **Permission Denied**: If you encounter "permission denied" errors, ensure that you have root access and that the scripts have executable permissions (`chmod +x script_name.sh`).

## Contributing
Feel free to contribute to this project by adding more scripts or enhancing existing functionality. Please ensure all contributions are well-documented and thoroughly tested.

## License
This project is licensed under the MIT License. Feel free to modify and use it according to your needs.

## Contact
For questions or support, please reach out to github.com/JLukassen.


# Audio Configuration Scripts - README

## Overview

This directory contains various shell scripts used for audio configuration and optimization on Android devices. These scripts are intended to be used in conjunction with a Magisk module, which installs the necessary tools and binaries, such as `Tinyalsa`, and provides access to advanced audio settings and configurations. The goal is to provide flexible audio configurations for users seeking more control over their device's audio subsystem.

## Directory Structure

```
config-scripts/
  |— audio_config.sh          # Primary audio configuration script
  |— reduce_jitter.sh          # Script to reduce audio jitter by setting parameters
  |— restore_defaults.sh       # Restore default audio settings
  |— tuning_helpers.sh        # Collection of functions used for various audio tunings
  |— tinymix_commands.sh      # Commands utilizing Tinyalsa for specific hardware-level tuning
```

## Scripts Description

### 1. `audio_config.sh`
This script is the primary entry point for configuring the audio system. It adjusts key parameters such as volume levels, equalizer settings, and audio routing, making use of `Tinyalsa` commands. Run this script to apply your preferred audio configuration.

### 2. `reduce_jitter.sh`
This script focuses on reducing system jitter during audio playback. It optimizes CPU and I/O settings that may have an impact on audio latency, helping to ensure smooth playback without drops or stuttering.

### 3. `restore_defaults.sh`
This script restores all audio-related settings to their factory defaults. It can be used when you want to undo the configurations made by the other scripts and return to the default state.

### 4. `tuning_helpers.sh`
A collection of helper functions that are used by the other scripts to perform common tasks, such as reading and writing system properties, checking for permissions, and making use of `Tinyalsa` commands. These helper functions are modular and designed to be reusable across different configuration scripts.

### 5. `tinymix_commands.sh`
This script uses `tinymix` commands to interact directly with the hardware components. It provides fine-grained control over mixers and other hardware settings, allowing advanced users to fine-tune their audio output.

## Usage Instructions

To use these scripts effectively, you need to have root access on your device, typically provided by a Magisk module. Make sure that the following prerequisites are met:

1. **Tinyalsa**: Ensure that the `tinymix` binary is installed on your device (either in `/system/bin` or `/vendor/bin`).
2. **Root Access**: The scripts require root privileges to modify system-level audio settings.

### Running a Script
To run any of the configuration scripts, open a terminal emulator on your Android device or use ADB. Here’s an example command:

```sh
su -c /system/etc/config-scripts/audio_config.sh
```

Replace `audio_config.sh` with the name of the script you wish to execute.

### Example Scenarios
- **Apply Custom Audio Settings**: Run `audio_config.sh` to apply a custom set of audio configurations tailored for optimal playback quality.
- **Reduce Latency**: Run `reduce_jitter.sh` to minimize jitter, which may be helpful during audio playback for latency-sensitive applications.
- **Restore Defaults**: If you want to undo changes, simply run `restore_defaults.sh`.

## Important Notes
- **Backup**: Always create a backup of your current audio configuration before making changes. This ensures that you can restore functionality in case of any issues.
- **Testing**: After applying changes, test different audio scenarios (e.g., calls, media playback, recording) to verify that the settings are applied correctly and there are no unwanted side effects.

## Troubleshooting
- **Permission Denied**: If you encounter "permission denied" errors, ensure that you have root access and that the scripts have executable permissions (`chmod +x script_name.sh`).
- **Audio Issues After Changes**: Run `restore_defaults.sh` to revert back to the default audio settings.

## Contributing
Feel free to contribute to this project by adding more scripts or enhancing existing functionality. Please ensure all contributions are well-documented and thoroughly tested.

## License
This project is licensed under the MIT License. Feel free to modify and use it according to your needs.

## Contact
For questions or support, please reach out to [Your Contact Info or GitHub Profile].


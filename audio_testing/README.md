# Audio Testing Library

## Overview
This audio testing library provides a set of scripts to troubleshoot and gather detailed information regarding the audio hardware and configuration of your system. The library is designed to run various audio-related diagnostics and capture their outputs.

## Scripts Included
The following scripts are included in the audio testing library:

1. **alsa-dac-profile.sh**: Displays hardware and software configuration for ALSA DACs, including USB DACs and Bluetooth/speaker configurations.
2. **audio-conf-src.sh**: Retrieves audio policy configuration information.
3. **dumpsys-bt.sh**: Filters Bluetooth-specific audio information using dumpsys.
4. **dumpsys-audio.sh**: Captures relevant audio system dumpsys information, filtering key details.
5. **dmesg-audio.sh**: Captures and filters audio-related logs from the kernel ring buffer (dmesg).
6. **tinymix.sh**: Provides audio mixer settings for the connected device.

## Features
- **Device-Specific Configuration**: Displays device-specific hardware and software capabilities/parameters.
  - **Card0**: Bluetooth/Speaker. Provides details such as `id`, `aoc_audio_state`, and `aoc_aocdump_state`.
  - **Card1**: USB DAC. Displays information such as `id`, `stream`, `usbbus`, `usbid`, and `usbmixer`.
- **Troubleshooting and Debugging**: Uses various system logs for gathering information and debugging.
- **Filtered and Readable Output**: The output is currently a single file that is filtered, formatted, and modular.

## Usage
To run the audio testing library, ensure you have root privileges. The main script allows you to select which diagnostics to run using command-line options.

### Running the Main Script
```
sudo sh audioTestlib.sh [options]
```

### Available Options
You can use the following options to choose which scripts to run:

- `-a`: Run `alsa-dac-profile.sh` to gather ALSA hardware parameters for Bluetooth, speakers, and USB DACs.
- `-g`: Run `audio-conf-src.sh` to gather audio policy configurations.
- `-b`: Run `dumpsys-bt.sh` to filter Bluetooth audio information.
- `-d`: Run `dumpsys-audio.sh` to capture filtered audio dumpsys data.
- `-m`: Run `dmesg-audio.sh` to capture filtered kernel audio logs.
- `-t`: Run `tinymix.sh` to capture mixer settings for the connected device.
- `-A` or `--all`: Run all the above scripts.

If no options are specified, the script defaults to running all scripts.

You can combine multiple options to run several scripts at once. For example:
```
sudo sh audioTestlib.sh -a -g -b
```

## Example Output
The output from each script is saved to a log file named in the format `audioTestlib_YYYYMMDDHHMMSS.log`, where the timestamp indicates the time the script was run.

Each section in the log file is clearly marked with a green, colored headers to make it easy to locate information.

## Requirements
- Root privileges are required to run most of the diagnostics.
- Ensure all the scripts have executable permissions.
- The `tinymix` executable must be available on the system at `/system/bin/`.

To make the scripts executable:
```sh
chmod +x *.sh
```

## Future Enhancements
- **Front-End Integration**: The script library could be extended with a front-end interface to allow users to select scripts and view output results in a more user-friendly format.
- **Enhanced Audio Configuration Checks**: Add features to check audio configurations, hardware capabilities, make changes, and troubleshoot issues.
- **Packaging**: Package the library, `tinymix`, `tinyalsa`, and other tools as a standalone app.
- **Smart Assistance**: Potentially include a lightweight form of ChatGPT or LLVM to assist in configuring or optimizing audio settings for Android intelligently.
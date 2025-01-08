#!/system/bin/sh

# Initialize status as 'closed'
rst="closed"

# Display all available sound cards
echo "Available Sound Cards:"
cat /proc/asound/cards

# Function to check and display hardware profile for card0 (Bluetooth/Speaker)
check_card0() {
    card=0
    if [ -r "/proc/asound/card${card}/id" ]; then
        echo "Card${card} ID:"
        cat "/proc/asound/card${card}/id"
    fi

    if [ -r "/proc/asound/card${card}/aoc_audio_state" ]; then
        echo "Card${card} AOC Audio State:"
        cat "/proc/asound/card${card}/aoc_audio_state"
    else
        echo "Card${card} AOC Audio State: Not available"
    fi

    if [ -r "/proc/asound/card${card}/aoc_aocdump_state" ]; then
        echo "Card${card} AOC Dump State:"
        cat "/proc/asound/card${card}/aoc_aocdump_state"
    else
        echo "Card${card} AOC Dump State: Not available"
    fi
}

# Function to check and display hardware profile for card1 (USB)
check_card1() {
    card=1
    if [ -r "/proc/asound/card${card}/id" ]; then
        echo "Card${card} ID:"
        cat "/proc/asound/card${card}/id"
    else
        echo "Card${card} ID: Not available"
    fi

    if [ -r "/proc/asound/card${card}/stream0" ]; then
        echo "Displaying DAC Hardware Profile:"
        cat "/proc/asound/card${card}/stream0"
    else
        echo "Card${card} Stream Information: Not available"
    fi

    if [ -r "/proc/asound/card${card}/usbbus" ]; then
        echo "Card${card} USB Bus Information:"
        cat "/proc/asound/card${card}/usbbus"
    else
        echo "Card${card} USB Bus Information: Not available"
    fi

    if [ -r "/proc/asound/card${card}/usbid" ]; then
        echo "Card${card} USB ID:"
        cat "/proc/asound/card${card}/usbid"
    else
        echo "Card${card} USB ID: Not available"
    fi

    if [ -r "/proc/asound/card${card}/usbmixer" ]; then
        echo "Card${card} USB Mixer Information:"
        cat "/proc/asound/card${card}/usbmixer"
    else
        echo "Card${card} USB Mixer Information: Not available"
    fi
}

# Check DAC connection status for all cards
echo "Starting alsa-dac-profile.sh"

# Check card0 details (Bluetooth/Speaker)
echo "Checking card0 (Bluetooth/Speaker)..."
check_card0

# Check card1 details (USB)
echo "Checking card1 (USB)..."
check_card1

echo "alsa-dac-profile.sh completed."

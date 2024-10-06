#!/bin/bash

# A convencience script to download the latest Arch Linux ISO and write it to a USB stick

# Temporary file to store the dialog output
tempfile=$(mktemp)

BASE_ISO_NAME="archlinux-x86_64.iso"
CKSUM_FILE="sha256sums.txt"
ARCH_ISO_VERSION="latest"

ARCH_ISO_URL="https://ftp.halifax.rwth-aachen.de/archlinux/iso/$ARCH_ISO_VERSION/$BASE_ISO_NAME"
CHECKSUM_FILE="https://ftp.halifax.rwth-aachen.de/archlinux/iso/$ARCH_ISO_VERSION/$CKSUM_FILE"


# Download the ISO file
# Full path for the downloaded file in the temporary directory
ISOFILE="/tmp/$BASE_ISO_NAME"
CHECKSUMFILE="/tmp/$CKSUM_FILE"
# Check if the file already exists in the temporary directory
if [[ -f "$ISOFILE" ]]; then
    echo "The file '$BASE_ISO_NAME' already exists in the temporary directory. Skipping download."
    wget -q -O "$CHECKSUMFILE" "$CHECKSUM_FILE"
else
    # Download the file with wget and show progress
    echo "Downloading '$BASE_ISO_NAME' and checksum file to temporary directory '$temp_dir'..."
    wget --progress=bar -O "$ISOFILE" "$ARCH_ISO_URL"
    wget --progress=bar -O "$CHECKSUMFILE" "$CHECKSUM_FILE"
fi


# Check if the checksum file exists
if [[ ! -f $CHECKSUMFILE ]]; then
    echo "Checksum file '$CHECKSUMFILE' not found."
    exit 1
fi

# Extract the expected checksum for the specified file
expected_checksum=$(grep "$BASE_ISO_NAME" "$CHECKSUMFILE" | awk '{print $1}')

# Check if the file's checksum was found in the checksum file
if [[ -z $expected_checksum ]]; then
    echo "No checksum found for '$BASE_ISO_NAME' in '$CHECKSUMFILE'."
    exit 1
fi

# Compute the actual checksum of the specified file
if [[ ! -f $ISOFILE ]]; then
    echo "File '$ISOFILE' not found."
    exit 1
fi

actual_checksum=$(sha256sum "$ISOFILE" | awk '{print $1}')

# Compare the checksums
if [[ $actual_checksum == $expected_checksum ]]; then
    echo "Checksum match: '$ISOFILE' is valid."
else
    echo "Checksum mismatch: '$ISOFILE' is invalid."
    echo "Expected: $expected_checksum"
    echo "Actual: $actual_checksum"

    echo "Delete $ISOFILE and try again: 'rm $ISOFILE'"
    exit 1
fi

# Function to list USB devices with their labels and meta information
list_usb_devices() {
    lsblk -o NAME,SIZE,LABEL,MODEL,TRAN | grep usb | while read line; do
        device=$(echo "$line" | awk '{print $1}')
        size=$(echo "$line" | awk '{print $2}')
        label=$(echo "$line" | awk '{print $3}')
        model=$(echo "$line" | awk '{print $4}')
        transport=$(echo "$line" | awk '{print $5}')
        
        # Output a formatted line: "device" and detailed description
        echo "$device $device: Size: $size, Label: $label, Model: $model, Transport: $transport"
    done
}

# Check if dialog is installed
if ! command -v dialog &> /dev/null
then
    echo "dialog command not found, please install dialog package."
    exit
fi

# Get the list of USB devices
usb_devices=$(list_usb_devices)

# If no USB devices found, exit with a message
if [[ -z "$usb_devices" ]]; then
    dialog --msgbox "No USB devices found!" 10 40
    clear
    exit
fi

# Create menu items by formatting the usb_devices list for dialog
menu_items=()
while IFS= read -r line; do
    device_name=$(echo "$line" | awk '{print $1}')
    description=$(echo "$line" | cut -d' ' -f2-)
    menu_items+=("$device_name" "$description")
done <<< "$usb_devices"

# Display the menu and store the selected device in a variable
dialog --menu "Select a USB device" 20 70 10 "${menu_items[@]}" 2>"$tempfile"

# Get the user's choice
usb_device=$(<"$tempfile")

# Clear the screen and show the result
clear
echo "You selected: $usb_device"

# Clean up temporary file
rm -f "$tempfile"

# Confirm the user wants to write to the USB device
usb_device="/dev/$usb_device"
echo "WARNING: This will overwrite '$usb_device'. Are you sure? (YESYESYES/n) in capital letters"
read -r confirmation
if [[ "$confirmation" != "YESYESYES" ]]; then
    echo "Aborted."
    exit 0
fi

# Use dd to copy the image to the USB stick with progress
echo "Copying '$ISOFILE' to '$usb_device'..."

pv -tpreb $ISOFILE | sudo dd of=$usb_device bs=4096 conv=notrunc,noerror

# Ensure all data is written to the USB stick
echo $'Syncing data to the USB stick...\nPlease wait.'
sync

# Inform the user to safely unmount the USB
echo "Data copied successfully. You can now safely remove '$usb_device' it."

# Cleanup: Remove the temporary files
rm -r "$ISOFILE" "$CHECKSUMFILE"
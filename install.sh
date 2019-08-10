#!/bin/bash

# Get the max dialog size
dialog --print-maxsize 2>size.txt
dialog_y=$(cat size.txt | awk '{print $2}' | tr -d ,
dialog_x=$(cat size.txt | awk '{print $3}'
rm size.txt

# Check for internet connectivity
if ! ping -c2 google.com; then
	wifi-menu
	if ! ping -c2 google.com; then
		dialog --pause 'No internet connection detected.' $dialog_y $dialog_x 10
		exit
	fi
fi

# Synchronize the time with a time server so contating the update server works
timedatectl set-ntp true

# Helper function that displays the disk partition scheme
disk_display_partition() {
	"Current disk partition scheme:\n" > buf.txt
	lsblk >> buf.txt
	"\n\nDo you wish to make changes to this partition scheme?" >> buf.txt
	dialog --title 'Partition Scheme' --no-collapse --yesno "$(cat buf.txt)" $dialog_y $dialog_x
	return $?
}

# Ask user for partitions to be used during the install
while [[ -z $root_partition ]] || [[ -z $boot_partition ]]; do
	# Ask user to make changes to the partition scheme
	while disk_display_partition; do
		cgdisk
	done

	# Ask user for root partition
	"Current disk partition scheme:\n" > buf.txt
	lsblk >> buf.txt
	"\n\nEnter the partition to be used as the ROOT partition (or enter to cancel):" >> buf.txt

	dialog --no-collapse --input "$(cat buf.txt)" $dialog_y $dialog_x 2>res.txt
	rm buf.txt

	if ! ls res.txt >/dev/null 2>&1 || [[ $(cat res.txt) == "" ]]; then
		rm res.txt
		continue
	elif ! ls $(cat res.txt) >/dev/null 2>&1 ; then
		dialog --pause "'$(cat res.txt)' is not a device" $dialog_y $dialog_x 10
		rm res.txt
		continue
	else
		rm res.txt
		$root_partition=$(cat res.txt)
	fi

	# Ask user for boot partition
	"Current disk partition scheme:\n" > buf.txt
	lsblk >> buf.txt
	"\n\nEnter the partition to be used as the BOOT partition (or enter to cancel):" >> buf.txt

	dialog --no-collapse --input "$(cat buf.txt)" $dialog_y $dialog_x 2>res.txt
	rm buf.txt

	if ! ls res.txt >/dev/null 2>&1 || [[ $(cat res.txt) == "" ]]; then
		rm res.txt
		continue
	elif ! ls $(cat res.txt) >/dev/null 2>&1 ; then
		dialog --pause "'$(cat res.txt)' is not a device" $dialog_y $dialog_x 10
		rm res.txt
		continue
	elif [[ $root_partition == $(cat res.txt) ]];
		rm res.txt
		dialog --pause "The boot partition cannot be the same as the root partition." $dialog_y $dialog_x 10
		continue
	else
		rm res.txt
		$root_partition=$(cat res.txt)
	fi

	# Confirm that this is correct
	"Current disk partition scheme:\n" > buf.txt
	lsblk >> buf.txt
	"\n\nRoot partition: $root_partition" >> buf.txt
	"\nBoot partition: $boot_partition" >> buf.txt
	"\nAre these settings correct?" >> buf.txt
	if ! dialog --defaultno --no-collapse --yesno "$(cat buf.txt)" $dialog_y $dialog_x; then
		$root_partition=""
		$boot_partition=""
		rm buf.txt
		continue
	fi
	rm buf.txt
done

# Ask user for encryption password for the disk if it is not already encrypted
if ! cryptsetup isLuks $root_partition && ! cryptsetup --type luks2 --cipher aes-xts-plain64 --key-size 512 --hash sha512 --iter-time 1500 $root_partition; then
	echo "Password not given for cryptsetup"
	exit
fi

# Ask user to open disk
if ! cryptsetup --type luks2 open $root_partition cryptlvm; then
	echo "Disk was not unlocked"
	exit
fi

# Make lvm partitions
if ! pvcreate /dev/mapper/cryptlvm; ||
	! vgcreate vg0 /dev/mapper/cryptlvm; ||
	! lvcreate -L 20G -n swap vg0; ||
	! lvcreate -l +100%FREE -n root vg0; then
	exit
fi

# Ask user to format disk
if ! dialog --menu "Select a root filesystem" $dialog_y $dialog_x 4 1 ext4 2 btrfs 3 f2fs 4 xfs 2>res.txt
	echo "A filesystem was not chosen"
	exit
fi

# Format partitions and mount them
if ! mkfs.$(cat res.txt) /dev/mapper/vg0-root; ||
	! mkswap /dev/mapper/vg0-swap; ||
	! mount /dev/mapper/vg0-root /mnt; ||
	! mount /dev/nvme0n1p1 /mnt/boot; ||
	! swapon /dev/mapper/vg0-swap; then
	exit
fi

# Prepare for chroot
echo "Installing base system..."
if ! pacstrap --noconfirm /mnt $(cat files-install/pacman-list); ||
	! genfstab -pU /mnt >> /mnt/etc/fstab; ||
	! cp -r files-install/base /mnt/install-base; ||
	! cp -r files-install/yay-packages /mnt/; ||
	! cp -r files-install/install-yay.sh; then
	exit
fi

# Chroot
arch-chroot /mnt /bin/bash files-install/install-chroot.sh

swapoff -a
umount -R /mnt
reboot

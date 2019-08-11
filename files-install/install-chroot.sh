# reset dialog size vars
dialog --print-maxsize 2>size.txt
dialog_y=$(cat size.txt | awk '{print $2}' | tr -d ,
dialog_x=$(cat size.txt | awk '{print $3}'
rm size.txt

# set timezone
while ! ls /etc/localtime >/dev/null 2>&1; do
	dialog --title "Select a timezone" --fselect /usr/share/zoneinfo/ $dialog_y $dialog_x 2>zone.txt
	if ! ls $(cat zone.txt) | grep "^-";
		dialog --pause "$(cat zone.txt) is not a timezone" $dialog_y $dialog_x 10
		rm zone.txt
		continue
	fi

	if ! ln -sf $(cat zone.txt) /etc/localtime; then
		exit
	fi

	rm zone.txt
done

# set language
if ! echo "LANG=en_US.UTF-8" > /etc/locale.conf ||
	! sed -ire 's/^#en_US\.UTF-8 UTF-8/en_US\.UTF-8 UTF-8/' /etc/locale.gen ||
	! locale-gen; then
	exit
fi

# get username
while [[ -z $username ]]; do
	dialog --inputbox "Enter the username for the main account" $dialog_y $dialog_x 2>user.txt
	if [[ $(cat user.txt) == "" ]];
		continue
	fi
	$username=$(cat user.txt)
done

mv /install-base/home/__MAIN_USER__ /install-base/home/$username

if ! useradd -m -G wheel -s /bin/zsh $username; then
	exit
fi

while ! passwd $username;
	echo "Please set a password for $username"
fi

if dialog --yesno "Would you like to set a root password?" $dialog_y $dialog_x; then
	while ! passwd;
		echo "Please set a password for root"
	fi
fi

# link home files to root equivalents
ln -s /home/$username/.vimrc /root/.vimrc
ln -s /home/$username/.vim /root/.vim
mkdir /root/.config
ln -s /home/$username/.config/nvim /root/.config/nvim
ln -s /home/$username/.zshrc /root/.zshrc

# install bootloader
if ! bootctl install; then
	exit
fi

# finally install yay packages
su jonathan -c '/bin/bash /install-yay.sh'
rm /yay-list

# install base files
mv -r install-base/*
rmdir install-base

systemctl enable snapd
systemctl enable NetworkManager
systemctl enable sleep@$username

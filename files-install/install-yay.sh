if ! git clone https://aur.archlinux.org/yay.git; then
	exit
fi

cd yay
makepkg -si --noconfirm
cd ..
rm -r yay
yay -S $(cat /yay-list) --noconfirm --mflags --nocheck

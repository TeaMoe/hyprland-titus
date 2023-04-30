#!/bin/bash

#### dont need your yay on openSUSE
# #### Check for yay ####
# ISYAY=/sbin/yay
# if [ -f "$ISYAY" ]; then
#     echo -e "$COK - yay was located, moving on."
#     yay -Suy
# else
#     echo -e "$CWR - Yay was NOT located"
#     read -n1 -rep $'[\e[1;33mACTION\e[0m] - Would you like to install yay (y,n) ' INSTYAY
#     if [[ $INSTYAY == "Y" || $INSTYAY == "y" ]]; then
#         git clone https://aur.archlinux.org/yay-git.git &>> $INSTLOG
#         cd yay-git
#         makepkg -si --noconfirm &>> ../$INSTLOG
#         cd ..
#
#     else
#         echo -e "$CER - Yay is required for this script, now exiting"
#         exit
#     fi
# fi
#
# we need to find a source for those
# sddm-git         # we wil use gdm instead which should work fine
# swaylock-effects # TODO: build from source https://github.com/mortie/swaylock-effects
# noise-suppression-for-voice

nerdfont() {
	curl -L --output "$1".zip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/"$1".zip && unzip -d ~/.local/share/fonts/ "$1".zip && rm "$1".zip
}

### Install all of the above pacakges ####
read -n1 -rep 'Would you like to install the packages? (y,n)' INST
if [[ $INST == "Y" || $INST == "y" ]]; then
	sudo zypper remove -u waybar # swaylock # keep swaylock for now until we build it from scratch
	sudo zypper install --no-confirm \
		dunst \
		ffmpeg \
		ffmpegthumbnailer \
		grim \
		hyprland \
		kitty \
		ladspa-rnnoise \
		neovim \
		noto-fonts \
		pamixer \
		papirus-icon-theme \
		pavucontrol \
		playerctl \
		polkit-gnome \
		rofi \
		scdoc \
		starship \
		swaybg \
		swaylock \
		texlive-comfortaa-fonts \
		texlive-noto-emoji-fonts \
		thunar \
		thunar-plugin-archive \
		tumbler \
		viewnior \
		wf-recorder \
		wl-clipboard \
		wlsunset

	opi adobe-source-code-pro-fonts
	opi inter-fonts
	opi nwg-look
	opi fira-mono-otf-fonts
	opi waybar-hyprland # TODO: publish branch
	opi wlogout
	opi xdg-desktop-portal-hyprland

	mkdir -p ~/.themes
	curl -L https://github.com/EliverLara/Nordic/releases/download/v2.2.0/Nordic.tar.xz | tar -C ~/.themes/ -xJ

	nerdfont FiraMono
	nerdfont FantasqueSansMono
	nerdfont Iosevka
	nerdfont JetBrainsMono
	nerdfont NerdFontsSymbolsOnly

	curl -L --output master.zip https://github.com/sora-xor/sora-font/archive/refs/heads/master.zip && unzip master.zip \
		sora-font-master/fonts/otf/Sora-Bold.otf \
		sora-font-master/fonts/otf/Sora-ExtraBold.otf \
		sora-font-master/fonts/otf/Sora-ExtraLight.otf \
		sora-font-master/fonts/otf/Sora-Light.otf \
		sora-font-master/fonts/otf/Sora-Regular.otf \
		sora-font-master/fonts/otf/Sora-SemiBold.otf \
		sora-font-master/fonts/otf/Sora-Thin.otf \
		-d ~/.local/share/fonts/ && rm master.zip

	curl -L --output ~/.local/share/fonts/feather.ttf https://github.com/AT-UI/feather-font/raw/master/src/fonts/feather.ttf

	# build (it really is just install) grimblast
	git clone https://github.com/hyprwm/contrib ~/.local/src/hyprwm-contrib
	cd ~/.local/src/hyprwm-contrib/grimblast || exit
	sudo make install
fi

### Copy Config Files ###
read -n1 -rep 'Would you like to copy config files? (y,n)' CFG
if [[ $CFG == "Y" || $CFG == "y" ]]; then
	echo -e "Copying config files...\n"
	cp -R ./dotconfig/dunst ~/.config/
	cp -R ./dotconfig/hypr ~/.config/
	cp -R ./dotconfig/kitty ~/.config/
	cp -R ./dotconfig/pipewire ~/.config/
	cp -R ./dotconfig/rofi ~/.config/
	cp -R ./dotconfig/swaylock ~/.config/
	cp -R ./dotconfig/waybar ~/.config/
	cp -R ./dotconfig/wlogout ~/.config/

	# Set some files as exacutable
	chmod +x ~/.config/hypr/xdg-portal-hyprland
	chmod +x ~/.config/waybar/scripts/waybar-wttr.py
fi

### Enable SDDM Autologin ###
read -n1 -rep 'Would you like to enable SDDM autologin? (y,n)' WIFI
if [[ $WIFI == "Y" || $WIFI == "y" ]]; then
	LOC="/etc/sddm.conf"
	echo -e "The following has been added to $LOC.\n"
	echo -e "[Autologin]\nUser = $(whoami)\nSession=hyprland" | sudo tee -a $LOC
	echo -e "\n"
	echo -e "Enable SDDM service...\n"
	sudo systemctl enable sddm
	sleep 3
fi

### Script is done ###
echo -e "Script had completed.\n"
echo -e "You can start Hyprland by typing Hyprland (note the capital H).\n"
read -n1 -rep 'Would you like to start Hyprland now? (y,n)' HYP
if [[ $HYP == "Y" || $HYP == "y" ]]; then
	exec Hyprland
else
	exit
fi

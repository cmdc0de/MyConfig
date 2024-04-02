#!/bin/bash

function printHeader() {
	echo "copywrite 2024 Demetrius Comes A.K.A. cmdc0de"
	echo "This repo contains my personal set up for vim, kitty and many other applications"
	echo "Please feel free to use it and modify (in your own fork)"
}

function install_kitty() {
	echo "Installing Kitty"
	curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
	# Create symbolic links to add kitty and kitten to PATH (assuming ~/.local/bin is in
	# your system-wide PATH)
	ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
	# Place the kitty.desktop file somewhere it can be found by the OS
	cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
	# If you want to open text files and images in kitty via your file manager also add the kitty-open.desktop file
	cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
	# Update the paths to the kitty and its icon in the kitty.desktop file(s)
	sed -i "s|Icon=kitty|Icon=/home/$USER/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
	sed -i "s|Exec=kitty|Exec=/home/$USER/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop

	echo "Configuring Kitty"
	echo "backing up original kitty config"
	if [ -f ~/.config/kitty/kitty.conf ]
	then
		mv ~/.config/kitty/kitty.conf ~/.config/kitty/kitty.conf.bak
	fi
	echo "soft linking to github version"
	if [ -e ~/.config/kitty/kitty.conf ] 
	then
		rm ~/.config/kitty/kitty.conf
	fi
	if [ -e ~/.config/kitty/dracula.conf ] 
	then
		rm ~/.config/kitty/dracula.conf
	fi
	ln -s $PWD/kitty/kitty.conf ~/.config/kitty/kitty.conf
	ln -s $PWD/kitty/dracula.conf ~/.config/kitty/dracula.conf
}

function setupVim() {
	echo "adding .vimrc"
	if [ -e ~/.vimrc ]
	then
		mv ~/.vimrc ~/.vimrc.bak
	fi
	ln -s $PWD/vim/vimrc ~/.vimrc
}

printf 'Install and configure Kitty? [Y/n]'
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
    install_kitty
else
    echo "Skipping install and configure Kitty"
fi

echo "Configure vim? [Y/n]"
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
	setupVim
else
    echo "Skipping configure vim"
fi


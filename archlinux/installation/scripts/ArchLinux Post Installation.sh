# -------------------
# [Post Installation]
# -------------------

# [User Control]
# Create Admin user
read -p "Username: " uname
read -p "Groups: " ugroups
read -p "Home Directory: " home_dir
read -p "Additional Options: " add_opt
if [ "$ugroups" == " " ]; then
	ugroups="wheel"
fi
useradd $add_opt -G $ugroups -d $home_dir $uname
# Set Admin user password
passwd $uname
# Test if user can login
if [ "$(sudo su - $uname)" ]; then
	# Success
else
	# Error
fi

# [Home Directory]
# Dotfiles/Dotfolders
DOTFLDRS=(~/.archive ~/.logs ~/.configs ~/.local ~/.vim)
DEFAULT_FLDRS=(~/configs ~/Desktop ~/Downloads ~/globals)
DOTFILES=(~/.bashrc-personal ~/.Xresources)
for fldrs in ${DOTFLDRS[@]}; do
	mkdir -p $fldrs
done
for deffldrs in ${DEFAULT_FLDRS[@]}; do
	mkdir -p $deffldrs
done
for files in ${DOTFILES[@]}; do
	touch $files
done

# Xresources
## Generate Xresources with a default template
xrdb -query | tee -a ~/.Xresources

# [Networking]
# Install Networking Packages
# sudo pacman -S dhcpcd wireless_tools wpa_supplicant wpa_actiond dialog netctl
sudo pacman -S dhcpcd wireless_tools wpa_supplicant dialog netctl

# Setup Network - Wired 
sudo NetworkManager start

# Setup Network - wireless
nmcli dev wifi
read -p "Enter your AP name: " AP_name
read -p "Enter your AP pass: " AP_pass
if [ ! -z "$AP_name" ] && [ ! -z "$AP_pass" ]; then
	nmcli device wifi connect $AP_name password $AP_pass && echo "Successfully connected." || echo "Error connecting"
done

# [Important Utilities]
# Install File Manager
read -p "File Manager: " filemgr
# Install Terminal Emulator
read -p "Terminal Emulator: " term
# Install Web Browser
read -p "Web Browser: " browser
# Install Text Editor
read -p "Text Editor: " texteditor
sudo pacman -S $filemgr $term $browser $texteditor

# Validate git
if [ ! "$(pacman -Qq | grep "git")" ]; then
	# Install git
	echo "Package 'git' is not installed - installing git..."
	pacman -S git
fi

# [Setup AUR]
# Install AUR Helper
# AUR: yay
# NOTE:
#	Before you can build packages in arch - requires base-devel
git clone https://aur.archlinux.org/yay-git.git # clone yay repository from aur
cd yay-git
makepkg -si 					# Make and Install Arch Package
yay 						# To use yay AUR manager to install stuff from the AUR

# [MicroCodes]
sudo pacman -S intel-ucode amd-ucode

# [System]
# Install and Setup Graphics
sudo pacman -S xorg-server xorg-xinit xorg-server-utils

# Audio control
pacman -S pulseaudio pulseaudio-alsa

# 3D-support
sudo pacman -S mesa

# NVIDIA Support
sudo pacman -S nvidia lib32-nvidia-utils

# Laptop support
sudo pacman -S xf86-input-synaptics

# Install Fonts
sudo pacman -S ttf-dejavu

# Window Manager
# Default WM
# Install Packages
sudo pacman -S xorg-twm xorg-xclock xterm

# Main WM
start_x=""
read -p "Desktop Environment (DE) | Window Manager (WM)?: " opt
case "$opt" in
	"WM")	# WM Managment
		wm_list=("OpenBox" "i3" "Awesome" "Deepin" "Sway" "dwm")
		for wm_ in ${wm_list[@]}; do
			echo "	$wm_"
		done
		read -p "Window Manager: " wm
		case "$wm" in
			"OpenBox") sudo pacman -S openbox
				start_x="openbox-session"
				;;
			"i3") sudo pacman -S i3
				start_x="i3"
				;;
			"Awesome") sudo pacman -S awesome
				start_x="awesome"
				;;
			"Deepin") sudo pacman -S deepin
				start_x="startdde"
				;;
			"Sway") sudo pacman -S swaywm
				;;
			"dwm") 
				git clone git://git.suckless.org/dwm
				;;
		esac
		;;
	"DE")	# Desktop Environment
		de_list=("GNOME" "KDE-Plasma" "XFCE" "Cinnamon" "Mate" "LXDE")
		for de_ in ${de_list[@]}; do
			echo "	$de_"
		done
		read -p "Desktop Environment: " de
		case "$de" in 
			"GNOME") sudo pacman -S gnome
				start_x="gnome-session"
				;;
			"KDE-Plasma") sudo pacman -S xorg plasma plasma-wayland-session kde-applications
				start_x="plasma"
				;;
			"XFCE") sudo pacman -S xfce4
				start_x="startxfce4"
				;;
			"Cinnamon") sudo pacman -S cinnamon
				start_x="cinnamon-session"
				;;
			"Mate") sudo pacman -S mate
				start_x="mate-session"
				;;
			"LXDE") sudo pacman -S lxde
				start_x="startdde"
				;;
        esac
        ;;
	*) echo "Invalid option - either DE or WM"
		;;
esac

# To launch the window manager / Desktop Environment automatically 
# NOTE: This is to automatically use the GUI (DE)/WM of choice to go in (if this is your only DE/WM installed)
# Use Display Managers if you have more than 1 (Refer Below)
# create file of initiation for GUI
# echo "(gui of choice)" >> ~/.xinitrc
echo "exec $start_x" >> ~/.xinitrc
# If no display manager
# startx

# Display Managers
read -p "Display Manager [gdm|sddm|lightdm|others]: " dm
selected_dm="$dm"
case "$dm" in 
	"gdm") sudo pacman -S gdm
		;;
	"sddm") sudo pacman -S sddm
		;;
	"lightdm") sudo pacman -S lightdm
		;;
	*) read -p "Enter display manager: " custom_dm
		sudo pacman -S $custom_dm
		selected_dm="$custom_dm"
		;;
esac

dm_service=$selected_dm.service
read -p "Display Manager [Start|Enable|Both]: " dm_control
case "$dm_control" in 
	"Start") sudo systemctl start $dm_service
		;;
	"Enable") sudo systemctl enable $dm_service
		;;
	"Both") sudo systemctl enable $dm_service
		sudo systemctl start $dm_service
		;;
esac

# [File Manager capabilities]
sudo pacman -S gvfs gvfs-samba

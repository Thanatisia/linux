#
# ArchLinux Post Install Script
# - Direct Version (No-Menu)
# TODO WIP - DO NOT USE FOR NOW
#
# Last modified: 
#	2020-11-02 2224H
# Changes:
#  	2020-11-02 2224H, Created this script
#

echo "--- Post Installation Start ---"
echo ""

#--------------
# User Control
#--------------
# To refer to "ArchLinux Post Installation under [User Control]"
read -p "Additonal Options [i.e. -m]: " add_opt
read -p "Groups: " ugroups
read -p "Home Directory: " home_dir
read -p "Username: " uname

if [ -z "$ugroups" ]; then
	ugroups="wheel"
fi

#--------------------------
# Generate useradd command
command="useradd"
command+=" $add_opt -G $ugroups "
case "$add_opt" in 
	"-m") command+="-d $home_dir"
		;;
	*) ;;
esac
command+="$ uname"
echo "Command: [$command]"
# -------------------------

uc_success="0"
# useradd $add_opt -G $ugroups -d $home_dir $uname && uc_success="1" || uc_success="0"
# Substitue raw command with variable
$command && uc_success="1" || uc_success="0"

if [ "$uc_success" == "1" ]; then
	echo "User $uname successfully created."
	# Set Admin user password
	passwd $uname
else
	echo "Error creating user $uname"
fi

#------------
# Networking
#------------
sudo pacman -S networkmanager dhcpcd wireless_tools wpa_supplicant dialog netctl

# -------- Unable to run systemctl commands in arch-chroot
# Setup Network - Wired
# sudo NetworkManager start

# Sleep for a while to let the networkmanager take effect
# sleep 5

# Setup Network - Wireless
# nmcli dev wifi
# read -p "Enter your AP name: " AP_name
# read -p "Enter your AP pass: " AP_pass
# if [ ! -z "$AP_name" ] && [ ! -z "$AP_pass" ]; then
# 	nmcli device wifi connect $AP_name password $AP_pass && echo "Successfully connected." || echo "Error connecting"
#fi					


#---------------------
# Package Management
#---------------------
# To refer to "ArchLinux Post Installation under [Package Management]"
read -p "File Manager: " filemgr
read -p "Terminal Emulator: " term
read -p "Web Browser: " browser
read -p "Text Editor: " texteditor
sudo pacman -S $filemgr $term $browser $texteditor

#--------------------------
# Other Package Mangement
#--------------------------
# To refer to "ArchLinux Post Installation under [Additional Package Installations]"
echo "Installing microcodes..."
sudo pacman -S intel-ucode amd-ucode
echo ""
echo "Installing graphical utilities..."
sudo pacman -S xorg xorg-server xorg-xinit xorg-server-utils
echo ""
echo "Installing audio controls..."
sudo pacman -S pulseaudio pulseaudio-alsa
echo ""
echo "Installing 3D support..."
sudo pacman -S mesa
echo ""
echo "Installing NVIDIA support..."
sudo pacman -S nvidia lib32-nvidia-utils
echo ""
echo "Installing Laptop support..."
sudo pacman -S xf86-input-synaptics
echo ""
echo "Installing Fonts"
sudo pacman -S ttf-dejavu
echo ""
echo "Installing default window manager and X controls..."
sudo pacman -S xorg-twm xorg-xclock xterm
echo ""

#----------------
# Home Directory
#----------------
# To refer to "ArchLinux Post Installation under [Home Directory]"
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
;;
						
#-------
# AUR
#-------
# To refer to "ArchLinux Post Installation under [AUR]"
# Pre-Requisites: git
if [ ! "$(pacman -Qq | grep "git")" ]; then
	# Install git
	echo "Package 'git' is not installed - installing git..."
	pacman -S git
fi

# Setup AUR
git clone https://aur.archlinux.org/yay-git.git
cd yay-git
makepkg -si
yay
							
#----------------
# Frontend Setup
#----------------
read -p "(DE) Desktop Environment | (WM) Window Manager?: " opt
case "$opt" in 
	"WM") 
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
					
#-----------------
# Display Manager
#-----------------
# To refer to "ArchLinux Post Installation under [Display Manager]"
read -p "(DM) Display Manager | (S) Static exec ?: " display_opt
selected_ = ""
while [ -z "$selected_" ]; do
	# While not selected
	case "$display_opt" in
		"DM" | "Display Manager") 
				selected_="DM"
				read -p "Display Manager [gdm | sddm | lightdm | others]: " dm
				selected_dm="$dm"
				case "$dm" in 
					"gdm") sudo pacman -S gdm
							;;
					"sddm") sudo pacman -S sddm
							;;
					"lightdm") sudo pacman -S lightdm
							;;
					"others") read -p "Enter display manager: " custom_dm
						sudo pacman -S $custom_dm
						selected_dm="$custom_dm"
						;;
					*) echo "Invalid option."
						;;
				esac

				# Display Manager service
				dm_service=$selected_dm.service
				read -p "Display Manager [(S)tart | (E)nable | (B)oth]: " dm_control
				case "$dm_control" in
					"S" | "Start") sudo systemctl start $dm_service
								;;
					"E" | "Enable") sudo systemctl enable $dm_service
								;;
					"B" | "Both")
								sudo systemctl enable $dm_service
								sudo systemctl start $dm_service
								;;
				esac
				;;
		"S"  | "Static exec") 
				selected_="S"
				echo "exec $start_x" | ~/.xinitrc
				;;
		*) echo "Invalid option";;
	esac
done

echo ""
echo "--- Post Installation Setup - END ---"
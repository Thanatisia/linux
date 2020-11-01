#	README
+ Folder Name: ArchLinux
+ Purpose: A folder for archlinux files - dotfiles, ricing designs, installation guides and config files for easy minimal installs or reinstallation.

# Contents
## Files
1. installation/scripts
```
ArchLinux Minimal Install.sh    : A W.I.P Install script for a minimal ArchLinux Installation that will reformat the drive at the moment.
ArchLinux_Minimal_Install-Manual.sh : A combined version of the seperated string - ignores the issue of arch-chroot for the time being, do not use this unless for coding references. Thank you!
ArchLinux_Minimal_Install-Manual_Part1.sh : Use this in the main installer iso; Previously "ArchLinux Minimal Install - Self-Partition.sh", this is part 1 of a W.I.P Install script based of "ArchLinux Minimal Install.sh" - modified to make partition controls more dynamic and terminal options for single line installations (TESTING).
ArchLinux_Minimal_Install-Manual_Part2.sh : Use this after arch-chroot /mnt; Previously "ArchLinux_Minimal_Install - Self-Partition.sh", this is part 2 of a W.I.P Install script based of "ArchLinux Minimal Install.sh" - modified to make partition controls more dynamic and terminal options for single line installations (TESTING)
ArchLinux Post Installation.sh  : A W.I.P Post installation script for use after an ArchLinux installation.
```
2. installation/guides
```
ArchLinux Installation.txt      : A write-up guide on how to install a minimal ArchLinux installation
ArchLinux Post Installation.txt : A Post-Installation write-up on things to do after installing a minimal build
```
3. installation/scripts/archive/ 
```
ArchLinux Minimal Install - Self-partition 20201030-2000H.sh : A W.I.P Install script based off "ArchLinux Minimal Install.sh" - modified to make partition controls more dynamic instead of just [ /dev/sdX1 : Boot Partition, /dev/sdX2 : Mount Partition, /dev/sdX3 : Home Partition ];
```

## Folders
+ installation : This folder is for all contents regarding ArchLinux installation
``` Subfolders
1. guides  : This is used for all guides regarding ArchLinux installation
2. scripts : This is used for all install scripts for ArchLinux and config installs
2.1. archive : An archive for all scripts - store your old edits
```

## Grabbing the individual files
You can retrieve the scripts by 
1. Cloning
```
git clone https://github.com/Thanatisia/linux/tree/master/archlinux
```
2. Obtaining the individual files using curl
```
[Scripts]
ArchLinux Minimal Install.sh:
  curl -o "ArchLinux Minimal Install.sh" "https://raw.githubusercontent.com/Thanatisia/linux/master/archlinux/installation/scripts/ArchLinux%20Minimal%20Install.sh"

ArchLinux_Minimal_Install-Manual_Part1.sh:
  curl -o "ArchLinux_Minimal_Install-Manual_Part1.sh" "https://raw.githubusercontent.com/Thanatisia/linux/master/archlinux/installation/scripts/ArchLinux_Minimal_Install-Manual_Part1.sh"

ArchLinux_Minimal_Install-Manual_Part2.sh:
  curl -o "ArchLinux_Minimal_Install-Manual_Part2.sh" "https://raw.githubusercontent.com/Thanatisia/linux/master/archlinux/installation/scripts/ArchLinux_Minimal_Install-Manual_Part2.sh"

ArchLinux Post Installation.sh:
  curl -o "ArchLinux Post Installation.sh" "https://raw.githubusercontent.com/Thanatisia/linux/master/archlinux/installation/scripts/ArchLinux%20Post%20Installation.sh"

[Guides]
ArchLinux Installation.txt:
  curl -o "ArchLinux Installation.txt" "https://raw.githubusercontent.com/Thanatisia/linux/master/archlinux/installation/guides/ArchLinux%20Installation.txt"

ArchLinux Post Installation.txt:
  curl -o "ArchLinux Post Installation.txt" "https://raw.githubusercontent.com/Thanatisia/linux/master/archlinux/installation/guides/ArchLinux%20Post%20Installation.txt"
```

# Changelogs
## Folders
+ installation/scripts/ 
```
20201101 1112H : Seperated 'ArchLinux Minimal Install - Self-partition.sh' to 2 parts - 'ArchLinux_Minimal_Install-Manual_Part1.sh' and 'ArchLinux_Minimal_Install-Manual_Part2.sh'
```

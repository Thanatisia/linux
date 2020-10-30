#	README
+ Folder Name: ArchLinux
+ Purpose: A folder for archlinux files - dotfiles, ricing designs, installation guides and config files for easy minimal installs or reinstallation.

# Contents
## Files
1. installation/scripts
```
ArchLinux Minimal Install.sh    : A W.I.P Install script for a minimal ArchLinux Installation that will reformat the drive at the moment.
ArchLinux Minimal Install - Self-partition.sh : A W.I.P Install script based of "ArchLinux Minimal Install.sh" - modified to make partition controls more dynamic and terminal options for single line installations (TESTING).
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

ArchLinux Minimal Install - Self-partition.sh:
  curl -o "ArchLinux Minimal Install - Self-partition.sh" "https://raw.githubusercontent.com/Thanatisia/linux/master/archlinux/installation/scripts/ArchLinux%20Minimal%20Install%20-%20Self-partition.sh"

ArchLinux Post Installation.sh:
  curl -o "ArchLinux Post Installation.sh" "https://raw.githubusercontent.com/Thanatisia/linux/master/archlinux/installation/scripts/ArchLinux%20Post%20Installation.sh"

[Guides]
ArchLinux Installation.txt:
  curl -o "ArchLinux Installation.txt" "https://raw.githubusercontent.com/Thanatisia/linux/master/archlinux/installation/guides/ArchLinux%20Installation.txt"

ArchLinux Post Installation.txt:
  curl -o "ArchLinux Post Installation.txt" "https://raw.githubusercontent.com/Thanatisia/linux/master/archlinux/installation/guides/ArchLinux%20Post%20Installation.txt"
```

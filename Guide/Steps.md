# Arch Linux Installation Guide

## Wi-Fi Setup

1. Open a terminal and run the following commands to connect to Wi-Fi:
    ```
    iwctl
    device list
    station wlan0 scan
    station wlan0 get-networks
    station wlan0 connect "2nd home 3"
    ```

2. Test the connection:
    ```
    ping -c 5 8.8.8.8
    ```

## Disk Partitioning

1. List and identify your disks and partitions:
    ```
    lsblk
    ```

2. Partition your drive using GPT and create necessary partitions:
    ```
    gdisk nvme0n1
    ```
    - Create a new EFI partition: `+512M`, Type `ef00`

3. Format the partitions:
    ```
    mkfs.fat -F32 /dev/nvme0n1p1
    mkfs.btrfs /dev/nvme0n1p2 -f
    ```

4. Mount the partitions:
    ```
    mount /dev/nvme0n1p2 /mnt
    ```

5. Create Btrfs subvolumes:
    ```
    btrfs subvolume create /mnt/@
    btrfs subvolume create /mnt/@home
    btrfs subvolume create /mnt/@var
    ```

6. Mount the subvolumes:
    ```
    mount -o noatime,compress=zstd,ssd,discard=async,space_cache=v2,subvol=@ /dev/nvme0n1p2 /mnt
    mount -o noatime,compress=zstd,ssd,discard=async,space_cache=v2,subvol=@home /dev/nvme0n1p2 /mnt/home
    mount -o noatime,compress=zstd,ssd,discard=async,space_cache=v2,subvol=@var /dev/nvme0n1p2 /mnt/var
    mount /dev/nvme0n1p1 /mnt/boot/efi
    ```

## Installation

1. Install essential packages:
    ```
    pacstrap /mnt base linux linux-lts linux-firmware git nano intel-ucode btrfs-progs sudo
    ```

2. Generate fstab:
    ```
    genfstab -U /mnt >> /mnt/etc/fstab
    ```

3. Chroot into the new system:
    ```
    arch-chroot /mnt
    ```

4. Set timezone and locale:
    ```
    ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime
    hwclock --systohc
    nano /etc/locale.gen
    locale-gen
    echo "LANG=en_US.UTF-8" >> /etc/locale.conf
    ```

5. Set hostname and hosts file:
    ```
    echo "ArchKDE" >> /etc/hostname
    nano /etc/hosts
    ```

6. Set root password:
    ```
    passwd
    ```

7. Install essential packages:
    ```
    pacman -S grub efibootmgr networkmanager dialog mtools dosfstools base-devel linux-headers linux-lts-headers xdg-utils xdg-user-dirs pulseaudio pulseaudio-bluetooth wireless_tools
    ```

## Bootloader Setup

1. Install GRUB and OS prober:
    ```
    grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
    pacman -S os-prober
    nano /etc/default/grub
    ```

2. Uncomment the line `GRUB_DISABLE_OS_PROBER=false` in `grub` configuration.

3. Generate GRUB configuration:
    ```
    grub-mkconfig -o /boot/grub/grub.cfg
    ```

4. Enable services:
    ```
    systemctl enable NetworkManager
    systemctl start bluetooth.service
    systemctl enable bluetooth.service
    systemctl enable bluetooth
    systemctl enable fstrim.timer
    ```

## User Setup

1. Create a user:
    ```
    useradd -m koushik
    passwd koushik
    usermod -aG wheel,power,storage koushik
    ```

2. Configure sudo:
    ```
    EDITOR=nano visudo
    ```

3. Uncomment `%wheel ALL=(ALL:ALL) ALL` and add `Defaults timestamp_timeout=0`.

4. Configure Btrfs in `mkinitcpio.conf`:
    ```
    nano /etc/mkinitcpio.conf
    ```

5. Replace `MODULES=()` with `MODULES=(btrfs)`.

6. Regenerate the initramfs:
    ```
    mkinitcpio -p linux
    mkinitcpio -p linux-lts
    ```

7. Exit the chroot environment:
    ```
    exit
    ```

## Final Steps

1. Unmount partitions and reboot:
    ```
    umount -R /mnt
    reboot
    ```

2. Log in as the user you created.

3. Set up network connections:
    ```
    nmtui
    ```

4. Update system:
    ```
    sudo pacman -Sy
    ```

5. Install Xorg and graphics drivers:
    ```
    sudo pacman -S xorg xf86-video-intel
    ```

6. Install KDE Plasma desktop:
    ```
    sudo pacman -S plasma-desktop dolphin dolphin-plugins ark konsole plasma-nm plasma-pa kdeplasma-addons kde-gtk-config powerdevil sddm sddm-kcm bluedevil kscreen kinfocenter firefox
    sudo systemctl enable sddm
    reboot
    ```

...
## Installing Chaotic-AUR Repository

1. Install Chaotic-AUR repository:
    ```
    pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
    pacman-key --lsign-key FBA220DFC880C036
    pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
    ```

2. Update `pacman.conf`:
    ```
    nano /etc/pacman.conf
    ```

3. Add the following to the file:
    ```
    [chaotic-aur]
    Include = /etc/pacman.d/chaotic-mirrorlist
    ```

4. Install additional packages:
    ```
    sudo pacman -S vscode brave
    ```

## Firefox Profile Switcher

1. Install Firefox profile switcher connector:
    ```
    rustup default stable
    git clone https://aur.archlinux.org/firefox-profile-switcher-connector.git
    cd firefox-profile-switcher-connector
    makepkg -si
    ```

2. Add profiles in Firefox:
    ```
    firefox -ProfileManager
    ```

3. To import passwords from a file:
    ```
    about:config
    signon.management.page.fileImport.enabled (set this to true)
    security.allow_eval_in_parent_process (set this to true)
    ```

4. Enable DRM for audio and video playback:
    - Configure Firefox to require DRM.

5. Install Adblock Plus extension.

## Setting Up Visual Studio Code

1. Install necessary packages:
    ```
    sudo pacman -S python-pip
    sudo pacman -S mingw-w64-gcc
    ```

2. Install VS Code extensions:
    - Autodocstring
    - C/C++ Extension Pack
    - C/C++ themes
    - Code runner
    - Gruvbox theme or Shades Of Purple Theme
    - Python
    - Jupyter
    - Markdown all in one
    - Python indent

## Creating System Snapshots

1. Install Timeshift and set up automatic snapshots:
    ```
    sudo pacman -S timeshift timeshift-autosnap
    ```

2. Configure ZRAM:
    ```
    git clone https://aur.archlinux.org/zramd.git
    cd zramd
    makepkg -si
    sudo systemctl enable --now zramd
    ```

3. Install `grub-btrfs` and update GRUB:
    ```
    sudo pacman -S grub-btrfs
    sudo pacman -S update-grub
    sudo timeshift-gtk
    ```

4. Create a snapshot and update GRUB.

## Additional Software

1. Install NTFS support:
    ```
    sudo pacman -S ntfs-3g
    ```

2. Configure KWallet Manager:
    - Disable KWallet services in system settings.

3. Install Latte Dock:
    ```
    sudo pacman -S latte-dock-git
    ```

...


...

## Touchpad Gestures and System Time

1. Set up touchpad gestures:
    ```
    sudo gpasswd -a $USER input
    sudo pacman -S xdotool wmctrl
    git clone https://aur.archlinux.org/libinput-gestures.git
    cd libinput-gestures
    makepkg -si
    sudo cp /etc/libinput-gestures.conf ~/.config/libinput-gestures.conf
    ```

2. Edit touchpad gestures configuration:
    - Modify `~/.config/libinput-gestures.conf` to define gestures.

3. Reboot and start the gestures service:
    ```
    reboot
    libinput-gestures-setup start
    libinput-gestures-setup autostart
    ```

4. If your system time is wrong, adjust it using the following commands:
    ```
    sudo timedatectl set-local-rtc 1 --adjust-system-clock
    sudo timedatectl set-ntp true
    sudo timedatectl timesync-status
    ```

## Additional Video Codecs

1. Install extra video codec packages:
    ```
    sudo pacman -S a52dec ffmpeg libdvbpsi libebml libmad libmatroska libmpeg2 libtar libupnp lua52 wayland-protocols
    ```

## Screenshot Tool

1. Install a screenshot tool:
    ```
    sudo pacman -S spectacle
    ```

## System Monitor and System Utilities

1. Install Stacer for system monitoring:
    ```
    sudo pacman -S stacer
    ```

2. Install Albert launcher:
    ```
    sudo pacman -S albert
    ```

## Latte Dock Setup

1. Install Latte Dock sidebar button:
    ```
    git clone https://aur.archlinux.org/plasma5-applets-latte-sidebar-button.git
    cd plasma5-applets-latte-sidebar-button
    makepkg -si
    ```

## Live Wallpaper and Streamio

1. Set up a live wallpaper:
    - Choose a live wallpaper plugin through the "Configure Desktop and Wallpaper" settings.

2. Install Stremio:
    ```
    sudo pacman -S stremio
    ```


...

## Softwares and Customizations

1. Install additional software:
    - jamesdsp or jamesdsp-pulse
    - evince (PDF viewer)
    - kamoso (webcam application)
    - vlc or smplayer (media players)
    - kdeconnect (KDE device integration)
    - deluge, ktorrent, or transmission-qt (torrent clients)
    - gpicview (image viewer)
    - htop (system monitor)
    - partitionmanager (disk utility)
    - pamac (GUI package manager)

2. To enable live wallpaper:
    - Use the "SmartER Video Wallpaper" plugin.

3. Install Latte Dock side panel button for on-demand access:
    - Use the "plasma5-applets-latte-sidebar-button" AUR package.

## Visual and Desktop Customizations

1. Customize global, application, and plasma styles, colors, fonts, and more:
    - Use the System Settings to configure these settings.

2. Set up a wallpaper:
    - Download a wallpaper from your preferred source.

3. Configure Latte Dock with animations:
    - Add the desired effects to Latte Dock using the "Load My Layout" feature.

4. Install Albert launcher and configure it:
    - Use the "Press Mod to activate application launcher" feature.

5. Configure various widgets and applets:
    - Use the KDE online store to install and customize widgets.

## Creating Workspace Switch Gestures

1. Set up workspace switch gestures:
    - Modify `~/.config/libinput-gestures.conf` to include swipe gestures for workspace switching.

## Additional Tips and Features

1. Continue with any additional software installation and customization you desire.
   
2. Explore and enjoy your newly set up Arch Linux system with KDE Plasma!

Remember, these instructions provide an overview of the installation and setup process. Adjustments or variations might be necessary based on your specific hardware and preferences.

(End of Guide)

(Hope u were able to follow lol)

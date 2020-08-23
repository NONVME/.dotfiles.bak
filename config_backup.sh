#!/bin/env bash

# For backup configs please try
# ./config_backup.sh
# sudo ./config_backup.sh

set -e

mount_dir=$(mount| grep /dev/mapper/luks-eabd21af-6196-48aa-858f-3d7f58a5e309| awk '{print $3}')
backup_dir=""$mount_dir"/backup/"$HOSTNAME"/"$USER"_"$(date +'%Y-%m-%d')""
options="-auhCRvr --stats --files-from=/tmp/rsync_list_$USER"

# Список архивируемых дирректорий/файлов
rsync_list=(
    $HOME/.config/autorandr
    $HOME/.config/compton
    $HOME/.config/Dunst
    $HOME/.config/firejail
    $HOME/.config/htop
    $HOME/.config/gtk-3.0
    $HOME/.config/i3
    $HOME/.config/polybar
    $HOME/.config/ranger
    $HOME/.config/rofi
    $HOME/.config/terminator
    $HOME/.config/redshift.conf
    $HOME/.config/nvim
    $HOME/.gnupg
    $HOME/firejail/firefox*/.mozilla/firefox/????????.default*/user.js
    $HOME/.local/share/TelegramDesktop
    $HOME/.gtkrc-2.0
    $HOME/.selected_editor
    $HOME/.Xresources
    $HOME/.bashrc
    $HOME/.oh-my-zsh
    $HOME/.tmux
    $HOME/.tmux.conf
    $HOME/.vim
    $HOME/.vimrc
    $HOME/.shell.pre-oh-my-zsh
    $HOME/.zshrc
    /usr/share/X11/xorg.conf.d/10-keyboard.conf
    /usr/share/X11/xorg.conf.d/10-touchpad.conf
    /usr/share/X11/xorg.conf.d/20-intel.conf
    /usr/share/X11/xorg.conf.d/99-stick.conf
    /usr/share/themes/Nordic
    /usr/share/lightdm/lightdm-gtk-greeter.conf.d/02_noname.conf
    /usr/share/lightdm/lightdm.conf.d/02_noname.conf
    /etc/lightdm/lightdm-gtk-greeter.conf
    /etc/nginx/nginx.conf
    /etc/nginx/sites-available
    /etc/tor/torrc
    /etc/ssh/ssh_config
    /var/www/gitbook
    /etc/hosts
)

start_backup() {
    rsync $options / $backup_dir
}

# Оставляем только существующие файлы для каждого юзера
for i in "${rsync_list[@]}"; do
    if [[ -e "$i" ]] && [[ -G "$i" ]] ; then
        echo "$i" >> /tmp/rsync_list_"$USER"
    fi
done

# Проверяем есть ли доступная для записи дирректория и вызываем функцию бэкапа
cd "$mount_dir"/backup
if [[ -d "$backup_dir" ]] && [[ -G "$backup_dir" ]]; then
        start_backup
    elif
        [[ "$EUID" -eq 0 ]]; then
        mkdir -p ./"$HOSTNAME"/"$USER"_"$(date +'%Y-%m-%d')"; chown "$USER":backup ./"$HOSTNAME"; chmod g=+rwx ./"$HOSTNAME" && start_backup
    else
        mkdir -p ./"$HOSTNAME"/"$USER"_"$(date +'%Y-%m-%d')" && start_backup

fi
cd - &>/dev/null

# т.к. Rsync собака сутулая "не умеет" удалять файлы, удаляем их сами
for i in "${rsync_list[@]}"; do
    if [[ ! -e "$i" ]] && [[ -e "$backup_dir""$i" ]]; then
        find "$backup_dir""$i" -exec rm -rf {} \;
    fi
done

# Clean
unset mount_dir
unset backup_dir
unset options
rm -rf /tmp/rsync_list_"$USER"

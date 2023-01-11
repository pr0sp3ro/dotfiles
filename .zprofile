#!/bin/zsh

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DESKTOP_DIR="$HOME/"
export XDG_DOWNLOAD_DIR="$HOME/tmp/downloads"
export XDG_DOCUMENTS_DIR="$HOME/doc"
export XDG_MUSIC_DIR="$HOME/music"
export XDG_PICTURES_DIR="$HOME/img"
export XDG_VIDEOS_DIR="$HOME/.local/vids"
export XDG_STATE_HOME="$HOME/.local/state"

export PATH="$HOME/.local/sc:${$(/usr/bin/find $HOME/.local/sc -type d -printf %p:)%%:}:$HOME/.local/bin:$HOME/.local/share/go/bin:$XDG_CONFIG_HOME/composer/vendor/bin:$XDG_DATA_HOME/npm/bin:$PATH"

unsetopt PROMPT_SP
export LC_TIME="C"

export EDITOR="nvim"
export TERMINAL="alacritty"
export BROWSER="brave-nightly"

# export GNUPGHOME="$XDG_DOCUMENTS_DIR/gnupg"
export XCURSOR_PATH=/usr/share/icons:$XDG_DATA_HOME/icon
export XINITRC="$XDG_CONFIG_HOME/x11/xinitrc"
export NOTMUCH_CONFIG="$XDG_CONFIG_HOME/notmuch-config"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"
export LESSHISTFILE="-"
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export ALSA_CONFIG_PATH="$XDG_CONFIG_HOME/alsa/asoundrc"
export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
export ANDROID_SDK_HOME="$XDG_CONFIG_HOME/android"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export ANSIBLE_CONFIG="$XDG_CONFIG_HOME/ansible/ansible.cfg"
export UNISON="$XDG_DATA_HOME/unison"
export HISTFILE="$XDG_DATA_HOME/history"
export WEECHAT_HOME="$XDG_CONFIG_HOME/weechat"
export MBSYNCRC="$XDG_CONFIG_HOME/mbsync/config"
export ELECTRUMDIR="$XDG_DATA_HOME/electrum"
export DICS="/usr/share/stardict/dic/"
export SUDO_ASKPASS="$HOME/.local/sc/dmenu/dmenupass"
export MYSQL_HISTFILE="$XDG_DATA_HOME/mysql_history"
# export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export GOPATH="$XDG_DATA_HOME/go"
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"

export LESS=-R
export LESS_TERMCAP_mb="$(printf '%b' '[1;31m')"
export LESS_TERMCAP_md="$(printf '%b' '[1;36m')"
export LESS_TERMCAP_me="$(printf '%b' '[0m')"
export LESS_TERMCAP_so="$(printf '%b' '[01;44;33m')"
export LESS_TERMCAP_se="$(printf '%b' '[0m')"
export LESS_TERMCAP_us="$(printf '%b' '[1;32m')"
export LESS_TERMCAP_ue="$(printf '%b' '[0m')"
export LESSOPEN="| /usr/bin/highlight -O ansi %s 2>/dev/null"

export QT_QPA_PLATFORMTHEME="qt5ct"
# export AWT_TOOLKIT="MToolkit wmname LG3D" # may have to install wmname
export _JAVA_AWT_WM_NONREPARENTING=1 # fix for Java applications in dwm
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on'

[ "$(tty)" = "/dev/tty1" ] && ! pidof -s Xorg >/dev/null 2>&1 && exec startx "$XINITRC"

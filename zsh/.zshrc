autoload -U colors && colors
setopt autocd extendedglob nomatch menucomplete
stty stop undef	# disable ctrl-s to freeze terminal
setopt interactive_comments
zle_highlight=('paste:none') # get rid of paste highlight

HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$XDG_CONFIG_HOME/zsh/history"

autoload -U compinit
compinit
zmodload zsh/complist
_comp_options+=(globdots) # hidden files
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors 'di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

bindkey -v
export KEYTIMEOUT=1

autoload -U up-line-or-beginning-search; zle -N up-line-or-beginning-search
autoload -U down-line-or-beginning-search; zle -N down-line-or-beginning-search
bindkey "^p" up-line-or-beginning-search
bindkey "^n" down-line-or-beginning-search
bindkey "^k" up-line-or-beginning-search
bindkey "^j" down-line-or-beginning-search

# Tab complete menu.
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^c' backward-delete-char

lfcd () {
    tmp="$(mktemp -uq)"
    trap 'rm -f $tmp >/dev/null 2>&1 && trap - HUP INT QUIT TERM PWR EXIT' HUP INT QUIT TERM PWR EXIT
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}

alias spseg="source pse git"
alias spses="source pse src"
alias spsets="source pse tsrc"

bindkey -s '^o' '^ulfcd^m'
bindkey -s '^f' '^ufg^m'
bindkey -s '^g' '^uspseg^m'
bindkey -s '^s' '^uspses^m'
bindkey -s '^t' '^uspsets^m'
bindkey '^[[P' delete-char
bindkey '^r' history-incremental-search-backward

# Edit line in vim with ctrl-e.
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line
bindkey -M vicmd '^e' edit-command-line

source "$XDG_CONFIG_HOME/zsh/aliasrc"
source "$XDG_CONFIG_HOME/zsh/prompt.zsh"
source "$XDG_CONFIG_HOME/zsh/vim.zsh"

source "/usr/share/zsh/plugins/zsh-system-clipboard/zsh-system-clipboard.zsh"
source "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
source "/usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"

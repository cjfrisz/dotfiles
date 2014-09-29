# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' group-name ''
zstyle ':completion:*' ignore-parents parent pwd .. directory
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' max-errors 2
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' use-compctl false
zstyle :compinstall filename '/home/cjfrisz/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.history
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd
unsetopt beep extendedglob nomatch notify
bindkey -e
# End of lines configured by zsh-newuser-install

# Do nothing if not running interactively
[[ $- != *i* ]] && return

export PROMPT='[%n@%m %~]$ '

os_type=`uname`

# macs don't like these options to ls
if [[ $os_type == 'Linux' ]] ; then
  alias ls='ls --color=auto'

  alias l='ls --color=auto'
  alias ll='ls -l --color=auto'
  alias la='ls -a --color=auto'
  alias lla='ls -la --color=auto'
fi

osx_emacs_bin='/Applications/Emacs.app/Contents/MacOS/Emacs'

if [[ $os_type == 'Darwin' ]] && [[ -e $osx_emacs_bin ]] ; then
  alias emacs="$osx_emacs_bin -nw"
else
  alias emacs='emacs -nw'
fi

# stuff just for my home machine
if [[ `hostname` == 'leto-ii' ]] ; then
  alias reboot='systemctl reboot'
  alias poweroff='systemctl poweroff'
  alias suspend='systemctl suspend'
  alias hibernate='systemctl hibernate'
  alias hybrid-sleep='systemctl hybrid-sleep'

  alias screen-on='xset -dpms; xset s off'
fi

alias less='less -X'

if [[ $os_type == 'Darwin' ]] ; then
  export JAVA_HOME=`/usr/libexec/java_home -v 1.7`
fi

bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward

setopt notify
setopt CSH_NULL_GLOB

source .dotfiles/zsh-history-substring-search

# bind UP and DOWN arrow keys
if [[ $os_type == 'Darwin' ]] ; then
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
else
  zmodload zsh/terminfo
  bindkey "$terminfo[kcuu1]" history-substring-search-up
  bindkey "$terminfo[kcud1]" history-substring-search-down
fi

# bind P and N for EMACS mode
bindkey -M emacs '^p' history-substring-search-up
bindkey -M emacs '^n' history-substring-search-down

# bind k and j for VI mode
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

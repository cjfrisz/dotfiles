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

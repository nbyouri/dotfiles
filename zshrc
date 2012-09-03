#TimeZone
export TZ=Europe/Brussels

# Locales
#export LANG=en_US.utf8
#export LANGUAGE=en_US.utf8
#export LC_ADDRESS=en_US.utf8
#export LC_ALL=en_US.utf8
#export LC_COLLATE=en_US.utf8
#export LC_IDENTIFICATION=en_US.utf8
#export LC_MESSAGES=en_US.utf8
#export LC_MEASUREMENT=en_US.utf8
#export LC_MONETARY=en_US.utf8
#export LC_NAME=en_US.utf8
#export LC_NUMERIC=en_US.utf8
#export LC_PAPER=en_US.utf8
#export LC_TELEPHONE=en_US.utf8
#export LC_TIME=en_US.utf8
#export LC_TYPE=en_US.utf8


#Colored ManPages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

export PAGER=less
export TERM=xterm

#Colorgcc
#export CC=/usr/local/bin/colorgcc

# -----/ aliases /-----

# color grep
alias mplay='mplayer -vo x11 -msgmodule -msgcolor -aspect 16:9'
export GREP_COLOR=32
alias grep='grep --color'
alias egrep='egrep --color'
alias rmy='rm -rf'
alias htop='htop --sort-key cpu'
alias netcon='ping www.google.be'
alias lsl='ls++ -a'
alias sshfundp='ssh ymouton@info.fundp.ac.be'
# keymap

bindkey -v
bindkey "^?"    backward-delete-char
bindkey "^H"    backward-delete-char
bindkey "^[[3~" delete-char
bindkey "^[[1~" beginning-of-line
bindkey "^[[4~" end-of-line
##
## Some nice keybindings
##
bindkey '^r' history-incremental-search-backward
bindkey "^[[5~" up-line-or-history
bindkey "^[[6~" down-line-or-history
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^W" backward-delete-word
bindkey "^b" backward-word
bindkey "^f" forward-word
bindkey "^d" delete-word
bindkey "^k" kill-line
bindkey ' ' magic-space    # also do history expansion on space
bindkey '^I' complete-word # complete on tab, leave expansion to _expand


# history
HISTFILE=$HOME/.zsh-history
HISTSIZE=3000
SAVEHIST=10000 # nice for logging
setopt extended_history
setopt share_history
function history-all { history -E 1 }


# path
export PATH=~/bin:$PATH:/usr/local/sbin:/usr/local/bin:/usr/local/sbin:/usr/libexec:/opt/local/bin:/opt/local/sbin:/usr/local/mysql/bin


# abbreviation for later use
export EDITOR=vim
export PAGER=less

# Some default extension stuff
### OPTIONS ###
#setopt PROMPT_SUBST
setopt autopushd
setopt NOTIFY
#setopt NO_FLOW_CONTROL
setopt APPEND_HISTORY
# setopt AUTO_LIST		# these two should be turned off
# setopt AUTO_REMOVE_SLASH
# setopt AUTO_RESUME		# tries to resume command of same name
unsetopt BG_NICE		# do NOT nice bg commands
setopt EXTENDED_HISTORY		# puts timestamps in the history
setopt HASH_CMDS		# turns on hashing
setopt HIST_ALLOW_CLOBBER
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY SHARE_HISTORY
setopt ALL_EXPORT

# Set/unset  shell options
setopt   notify globdots pushdtohome cdablevars autolist
setopt   autocd recexact longlistjobs
setopt   autoresume histignoredups pushdsilent noclobber
setopt   autopushd pushdminus extendedglob rcquotes mailwarning
unsetopt bgnice autoparamslash

# Autoload zsh modules when they are referenced
zmodload -a zsh/stat stat
zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof
#zmodload -ap zsh/mapfile mapfile

# completion
##
##  completion
##
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:processes' command 'ps -axw'
zstyle ':completion:*:processes-names' command 'ps -awxho command'
# Completion Styles
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
# list of completers to use
#zstyle ':completion:*::::' completer _expand _complete _ignored _approximate
#NEW completion:
# 1. All /etc/hosts hostnames are in autocomplete
# 2. If you have a comment in /etc/hosts like #%foobar.domain,
#    then foobar.domain will show up in autocomplete!
zstyle ':completion:*' hosts $(awk '/^[^#]/ {print $2 $3" "$4" "$5}' /etc/hosts | grep -v ip6- && grep "^#%" /etc/hosts | awk -F% '{print $2}') 
# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# offer indexes before parameters in subscripts
#zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
# command for process lists, the local web server details and host completion
zstyle '*' hosts $hosts
# ignore completion functions (until the _ignored completer)
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:scp:*' tag-order \
   files users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:scp:*' group-order \
   files all-files users hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*' tag-order \
   users 'hosts:-host hosts:-domain:domain hosts:-ipaddr"IP\ Address *'
zstyle ':completion:*:ssh:*' group-order \
   hosts-domain hosts-host users hosts-ipaddr
#zstyle '*' single-ignored show

if [ -z "$LINES" ] || ! ( echo $LINES | grep -q '^[0-9]\+$' ) ; then
      LINES=20
fi

function maxhead() { head -n `echo $LINES - 5|bc` ; }
function maxtail() { tail -n `echo $LINES - 5|bc` ; }
# Prompt
#. ~/.zshprompt
#setprompt

# prompt line
PROMPT='%B%F{red}[%B%F{white}%~%B%F{red}]%B%F{white}%B%F{cyan}-%B%F{yellow}> %f'
#export DYLD_INSERT_LIBRARIES=/usr/local/lib/stderred.dylib DYLD_FORCE_FLAT_NAMESPACE=1
eval `dircolors ~/.LS_COLORS`
alias ls="gls --color=auto"
# zsh syntax coloring completion 
# Define the path where zsh can find live-command-coloring.sh
source ~/.live.sh
alias spc="spc -c ~/.sprc"
alias spcc="spc -c ~/.sprcc"
alias spcp="spc -c ~/.sprcp"
alias spcd="spc -c ~/.sprcd"
alias sshsun='ssh ymouton@sunset.info.fundp.ac.be'
export PATH='/usr/local/lib/cw:/Users/youri/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/local/bin:/usr/X11/bin:/Users/youri/bin:/usr/local/sbin:/usr/libexec:/opt/local/sbin:/usr/local/mysql/bin:/usr/local/sbin:/usr/local/bin:/usr/local/sbin:/usr/libexec:/opt/local/bin:/opt/local/sbin:/usr/local/mysql/bin'

if [ `/usr/bin/tty` = '/dev/ttyv0' ]; then
  startx --:7: 2> /dev/null & 
fi


source ~/.zshrc2

#
# yrmt's zshrc.
#
# October 2013.
#
#
#
#
# TimeZone
export TZ=Europe/Brussels

# Locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Colored ManPages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

export PAGER=less

# history
HISTFILE=$HOME/.zsh-history
HISTSIZE=3000
SAVEHIST=10000 # nice for logging
setopt extended_history
setopt share_history
function history-all { history -E 1 }

# Term variable
export TERM=rxvt-256color

# path
export PATH=/usr/pkg/lib/cw:/Volumes/pkgsrc/pkg/bin:/Volumes/pkgsrc/pkg/sbin:/usr/local/homebrew/bin:~/bin:$PATH:/usr/local/sbin:/usr/local/bin:/usr/local/sbin:/usr/libexec:/opt/local/bin:/opt/local/sbin:/usr/local/mysql/bin:/usr/pkg/bin:/usr/pkg/sbin

# abbreviation for later use
export EDITOR=vim
export PAGER=less

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

## display fancy terminal title

# completion
autoload -U compinit
compinit

##
##  completion
##
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


# Prompt
PROMPT='
%B%F{black}──── %f'

###
#
# Live coloring.
#
###

ZLE_RESERVED_WORD_STYLE='fg=yellow,bold'
ZLE_ALIAS_STYLE='fg=magenta,bold'
ZLE_BUILTIN_STYLE='fg=cyan,bold'
ZLE_FUNCTION_STYLE='fg=blue,bold'
ZLE_COMMAND_STYLE='fg=green,bold'
ZLE_COMMAND_UNKNOWN_TOKEN_STYLE='fg=red,bold'

ZLE_HYPHEN_CLI_OPTION='fg=yellow,bold'
ZLE_DOUBLE_HYPHEN_CLI_OPTION='fg=green,bold'
ZLE_SINGLE_QUOTED='fg=magenta,bold'
ZLE_DOUBLE_QUOTED='fg=red,bold'
ZLE_BACK_QUOTED='fg=cyan,bold'
ZLE_GLOBING='fg=blue,bold'

ZLE_DEFAULT='fg=white,bold'

ZLE_TOKENS_FOLLOWED_BY_COMMANDS=('|' '||' ';' '&' '&&' 'sudo' 'start' 'time' 'strace' '§')

# Recolorize the current ZLE buffer.
colorize-zle-buffer() {
  region_highlight=()
  colorize=true
start_pos=0
  for arg in ${(z)BUFFER}; do
    ((start_pos+=${#BUFFER[$start_pos+1,-1]}-${#${BUFFER[$start_pos+1,-1]## #}}))
    ((end_pos=$start_pos+${#arg}))
    if $colorize; then
colorize=false
res=$(LC_ALL=C builtin type $arg 2>/dev/null)
      case $res in
        *'reserved word'*) style=$ZLE_RESERVED_WORD_STYLE;;
        *'an alias'*) style=$ZLE_ALIAS_STYLE;;
        *'shell builtin'*) style=$ZLE_BUILTIN_STYLE;;
        *'shell function'*) style=$ZLE_FUNCTION_STYLE;;
        *"$cmd is"*) style=$ZLE_COMMAND_STYLE;;
        *) style=$ZLE_COMMAND_UNKNOWN_TOKEN_STYLE;;
      esac
else
case $arg in
'--'*) style=$ZLE_DOUBLE_HYPHEN_CLI_OPTION;;
'-'*) style=$ZLE_HYPHEN_CLI_OPTION;;
"'"*"'") style=$ZLE_SINGLE_QUOTED;;
'"'*'"') style=$ZLE_DOUBLE_QUOTED;;
'`'*'`') style=$ZLE_BACK_QUOTED;;
*"*"*) style=$ZLE_GLOBING;;
*) style=$ZLE_DEFAULT;;
esac
fi
region_highlight+=("$start_pos $end_pos $style")
    [[ ${${ZLE_TOKENS_FOLLOWED_BY_COMMANDS[(r)${arg//|/\|}]}:+yes} = 'yes' ]] && colorize=true
start_pos=$end_pos
  done
}

# Bind the function to ZLE events.
ZLE_COLORED_FUNCTIONS=(
    self-insert
    delete-char
    backward-delete-char
    kill-word
    backward-kill-word
    up-line-or-history
    down-line-or-history
    beginning-of-history
    end-of-history
    undo
    redo
    yank
)

for f in $ZLE_COLORED_FUNCTIONS; do
eval "$f() { zle .$f && colorize-zle-buffer } ; zle -N $f"
done

# create an expansion widget which mimics the original "expand-or-complete" (you can see the default setup using "zle -l -L")
zle -C orig-expand-or-complete .expand-or-complete _main_complete

# use the orig-expand-or-complete inside the colorize function (for some reason, using the ".expand-or-complete" widget doesn't work the same)
expand-or-complete() { builtin zle orig-expand-or-complete && colorize-zle-buffer }
zle -N expand-or-complete

# mutt background fix
COLORFGBG="default;default"


###
#
# Shell aliases.
#
###
alias wifi='open -a "Wireless Network Utility"'
alias cro='open -a "Chromium"'
alias o='open .'
alias xerg='launchctl start com.beastie.startx'
alias top='top -s1 -o cpu -R -F'
alias solaris="sudo ssh -X ymouton@sunset.info.fundp.ac.be -D 80"
alias grep='grep --color'
alias mplay='mplayer -msgmodule -msgcolor -aspect 16:9'
alias w4m='w3m -cookie'
alias w5m='w3m -cookie unixhub.net'
alias xel='xelatex -interaction=nonstopmode'
alias hmp='pkg_info|wc -l'
alias ls='ls -G'
alias l='ls -lah'
alias up=' rsync -avhz --progress /Volumes/Second/pkgsrc/packages/ root@saveosx.org:/usr/local/www/saveosx/packages/Darwin/2013Q2/x86_64/'
alias pup='sudo pkgin up'
alias pin='sudo pkgin -y in'
alias pav='pkgin av'
alias pls='pkgin ls'
alias sauce='source ~/.zshrc'
alias spc='spc -c /etc/supercat/spcrc-c'

###
#
# Shell functions.
#
###

if [[  $TERM == xterm-termite ]]; then
    . /etc/profile.d/vte.sh

    __vte_ps1

    chpwd() {
        __vte_ps1
    }
fi

findsym () {
      [[ -z $1 ]] && return 1
      SYMBOL=$1
      LIBDIR=${2:-/usr/lib}
      for lib in $LIBDIR/*.a
      do 
        nm $lib &> /dev/null | grep -q $SYMBOL && \
        print "symbol found in $lib\n -L$LIBDIR -l${${lib:t:r}#lib}"
      done
}

upb () {
    cd ~/downloads/git/blog;
    jekyll build;
    rsync -avhz --progress _site/* root@saveosx.org:/usr/local/www/saveosx/blog/; 
    git add -A;
    git commit -m 'update';
    git push;
    cd -;
}

gpb () {
    COM=$1
    git add *;
    git add .*;
    git commit -m $COM;
    git push;
}

cl () { 
    cd $1; 
    ls 
}

case $TERM in
    rxvt-256color*)
        precmd () {print -Pn "\e]0; %~\a"}
        ;;
esac

###
#
# Key setup for Colemak on an HHKB.
#
###
bindkey '^E' backward-char
bindkey "^P" up-line-or-search
bindkey "^N" down-line-or-search
bindkey "^A" beginning-of-line
bindkey "^O" end-of-line

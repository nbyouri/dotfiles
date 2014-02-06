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
#export LC_CTYPE=en_US.UTF-8
#export LC_ALL=


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
#export TERM=rxvt-256color
export TERM=wsvt25

# path
export PATH=/usr/pkg/lib/cw:/sbin/:/usr/X11R7/bin:/Volumes/pkgsrc/pkg/bin:/Volumes/pkgsrc/pkg/sbin:/usr/local/homebrew/bin:~/bin:$PATH:/usr/local/sbin:/usr/local/bin:/usr/local/sbin:/usr/libexec:/opt/local/bin:/opt/local/sbin:/usr/local/mysql/bin:/usr/pkg/bin:/usr/pkg/sbin
export MANPATH="/usr/pkg/man:$MANPATH"

# Go env
export GOROOT=~/go
export GOPATH=~/gopath
export PATH=$GOROOT/bin:$PATH
export PATH=$GOPATH/bin:$PATH
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
%B%F{black}> %f'

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
alias top='top -o cpu '
alias solaris="sudo ssh -X ymouton@sunset.info.fundp.ac.be -D 80"
alias grep='grep --color'
alias mplay='mplayer -msgmodule -msgcolor -aspect 16:9'
alias w4m='w3m -cookie'
alias w5m='w3m -cookie unixhub.net'
alias xel='xelatex -interaction=nonstopmode'
alias hmp='pkg_info|wc -l'
#alias ls='ls -G'
alias ls='gls --color=auto'
alias l='ls -lah'
alias up=' rsync -avhz --progress /Users/yrmt/downloads/pkgsrc/packages/ root@saveosx.org:/usr/local/www/saveosx/packages/Darwin/2013Q2/x86_64/'
alias pup='sudo pkgin up'
alias pin='sudo pkgin -y in'
alias pav='pkgin av'
alias pls='pkgin ls'
alias sauce='source ~/.zshrc'
alias spc='spc -c /etc/supercat/spcrc-c'
alias mipc='sudo make install package clean'
alias mc='sudo make clean'
alias ext='sudo make extract'
alias mdi='sudo make mdi'

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
      for lib in $LIBDIR/*.dylib
      do 
        nm $lib &> /dev/null | grep -q $SYMBOL && \
        print "symbol found in $lib\n -L$LIBDIR -l${${lib:t:r}#lib}"
      done
}

upb () {
    cd ~/downloads/git/blog;
    jekyll build 2>/dev/null;
    rsync -ahz _site/* root@saveosx.org:/usr/local/www/saveosx/blog/; 
    git add -A;
    git commit -m 'update';
    git push --quiet;
    cd -;
}

gpb () {
    COM=$1
    git add *;
    git add .*;
    git commit -m $COM;
    git push --quiet;
}

cl () { 
    cd $1; 
    ls 
}

add () {
	echo "Uploading the package to remote server...";
    scp $1 ssx:/usr/local/www/saveosx/packages/Darwin/2013Q2/x86_64/All/ 2>/dev/null;
    echo "Updating the package summary...";
    ssh ssx 'cd /usr/local/www/saveosx/packages/Darwin/2013Q2/x86_64/All/;
    		 rm pkg_summary.gz;
    		 /pkginfo -X *.tgz | gzip -9 > pkg_summary.gz';
    echo "Package uploaded, I'll update your pkgin...";
    sudo pkgin update;
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

###
#
# LS colors for gnu ls and gnu dircolors.
#
# ##
LS_COLORS='bd=38;5;68:ca=38;5;17:cd=38;5;113;1:di=38;5;30:do=38;5;127:ex=38;5;166;1:pi=38;5;126:fi=38;5;253:ln=target:mh=38;5;220;1:or=48;5;196;38;5;232;1:ow=38;5;220;1:sg=48;5;234;38;5;100;1:su=38;5;137:so=38;5;197:st=38;5;86;48;5;234:tw=48;5;235;38;5;139;3:*LS_COLORS=48;5;89;38;5;197;1;3;4;7:*.BAT=38;5;108:*.PL=38;5;160:*.asm=38;5;240;1:*.awk=38;5;148;1:*.bash=38;5;173:*.bat=38;5;108:*.c=38;5;110:*.cc=38;5;24;1:*.ii=38;5;24;1:*.cfg=1:*.cl=38;5;204;1:*.coffee=38;5;94;1:*.conf=1:*.C=38;5;24;1:*.cp=38;5;24;1:*.cpp=38;5;24;1:*.cxx=38;5;24;1:*.c++=38;5;24;1:*.ii=38;5;24;1:*.cs=38;5;74;1:*.css=38;5;91:*.csv=38;5;78:*.ctp=38;5;95:*.diff=48;5;197;38;5;232:*.enc=38;5;192;3:*.eps=38;5;192:*.etx=38;5;172:*.ex=38;5;148;1:*.example=38;5;225;1:*.git=38;5;197:*.gitignore=38;5;240:*.go=38;5;36;1:*.h=38;5;81:*.H=38;5;81:*.hpp=38;5;81:*.hxx=38;5;81:*.h++=38;5;81:*.tcc=38;5;81:*.f=38;5;81:*.for=38;5;81:*.ftn=38;5;81:*.s=38;5;81:*.S=38;5;81:*.sx=38;5;81:*.hi=38;5;240:*.hs=38;5;155;1:*.htm=38;5;125;1:*.html=38;5;125;1:*.info=38;5;101:*.ini=38;5;122:*.java=38;5;142;1:*.jhtm=38;5;125;1:*.js=38;5;42:*.jsm=38;5;42:*.jsm=38;5;42:*.json=38;5;199:*.jsp=38;5;45:*.lisp=38;5;204;1:*.log=38;5;190:*.lua=38;5;34;1:*.m=38;5;130;3:*.mht=38;5;129:*.mm=38;5;130;3:*.M=38;5;130;3:*.map=38;5;58;3:*.markdown=38;5;184:*.md=38;5;184:*.mf=38;5;220;3:*.mfasl=38;5;73:*.mi=38;5;124:*.mkd=38;5;184:*.mtx=38;5;36;3:*.nfo=38;5;220:*.o=38;5;240:*.pacnew=38;5;33:*.patch=48;5;197;38;5;232;1:*.pc=38;5;100:*.pfa=38;5;43:*.php=38;5;93:*.pl=38;5;214:*.plt=38;5;204;1:*.pm=38;5;197;1:*.pod=38;5;172;1:*.py=38;5;41:*.pyc=38;5;240:*.rb=38;5;192:*.rdf=38;5;144:*.rst=38;5;67:*.ru=38;5;142:*.scm=38;5;204;1:*.sed=38;5;130;1:*.sfv=38;5;197:*.sh=38;5;113:*.signature=38;5;206:*.sql=38;5;222:*.srt=38;5;116:*.sty=38;5;58:*.sug=38;5;44:*.t=38;5;28;1:*.tcl=38;5;64;1:*.tdy=38;5;214:*.tex=38;5;172:*.textile=38;5;106:*.tfm=38;5;64:*.tfnt=38;5;140:*.theme=38;5;109:*.txt=38;5;192:*.urlview=38;5;85:*.vim=1:*.viminfo=38;5;240;1:*.xml=38;5;199:*.yml=38;5;208:*.zsh=38;5;173:*README=38;5;220;1:*Makefile=38;5;196:*MANIFEST=38;5;243:*pm_to_blib=38;5;240:*.1=38;5;196;1:*.3=38;5;196;1:*.7=38;5;196;1:*.1p=38;5;160:*.3p=38;5;160:*.am=38;5;242:*.in=38;5;242:*.old=38;5;242:*.out=38;5;46;1:*.bmp=38;5;62:*.cdr=38;5;59:*.gif=38;5;72:*.ico=38;5;73:*.jpeg=38;5;66:*.jpg=38;5;66:*.JPG=38;5;66:*.png=38;5;68;1:*.svg=38;5;24;1:*.xpm=38;5;36:*.32x=38;5;137:*.A64=38;5;82:*.a00=38;5;11:*.a52=38;5;112:*.a64=38;5;82:*.a78=38;5;112:*.adf=38;5;35:*.atr=38;5;213:*.cdi=38;5;124:*.fm2=38;5;35:*.gb=38;5;203:*.gba=38;5;205:*.gbc=38;5;204:*.gel=38;5;83:*.gg=38;5;138:*.ggl=38;5;83:*.j64=38;5;102:*.nds=38;5;193:*.nes=38;5;160:*.rom=38;5;59;1:*.sav=38;5;220:*.sms=38;5;33:*.st=38;5;208;1:*.iso=38;5;124:*.nrg=38;5;124:*.qcow=38;5;141:*.VOB=38;5;137:*.IFO=38;5;240:*.BUP=38;5;241:*.MOV=38;5;42:*.3gp=38;5;134:*.3g2=38;5;133:*.asf=38;5;25:*.avi=38;5;114:*.divx=38;5;112:*.f4v=38;5;125:*.flv=38;5;131:*.m2v=38;5;166:*.mkv=38;5;202:*.mov=38;5;42:*.mp4=38;5;124:*.mpg=38;5;38:*.mpeg=38;5;38:*.ogm=38;5;97:*.ogv=38;5;94:*.rmvb=38;5;112:*.sample=38;5;130;1:*.ts=38;5;39:*.vob=38;5;137:*.webm=38;5;109:*.wmv=38;5;113:*.S3M=38;5;71;1:*.aac=38;5;137:*.cue=38;5;112:*.dat=38;5;165:*.dts=38;5;100;1:*.fcm=38;5;41:*.flac=38;5;166;1:*.m3u=38;5;172:*.m4=38;5;196;3:*.m4a=38;5;137;1:*.mid=38;5;102:*.midi=38;5;102:*.mod=38;5;72:*.mp3=38;5;191:*.oga=38;5;95:*.ogg=38;5;96:*.s3m=38;5;71;1:*.sid=38;5;69;1:*.spl=38;5;173:*.wv=38;5;149:*.wvc=38;5;149:*.afm=38;5;58:*.pfb=38;5;58:*.pfm=38;5;58:*.ttf=38;5;66:*.pcf=38;5;65:*.psf=38;5;64:*.bak=38;5;41;1:*.bin=38;5;249:*.pid=38;5;160:*.state=38;5;124:*.swo=38;5;236:*.swp=38;5;241:*.tmp=38;5;244:*.un~=38;5;240:*.zcompdump=38;5;240:*.zwc=38;5;240:*.db=38;5;60:*.dump=38;5;119:*.sqlite=38;5;60:*.typelib=38;5;60:*.7z=38;5;40:*.a=38;5;46:*.apk=38;5;172;3:*.arj=38;5;41:*.bz2=38;5;44:*.deb=38;5;215:*.ipk=38;5;117:*.jad=38;5;50:*.jar=38;5;51:*.nth=38;5;40:*.sis=38;5;39:*.part=38;5;239;1:*.r00=38;5;239:*.r01=38;5;239:*.r02=38;5;239:*.r03=38;5;239:*.r04=38;5;239:*.r05=38;5;239:*.r06=38;5;239:*.r07=38;5;239:*.r08=38;5;239:*.r09=38;5;239:*.r10=38;5;239:*.r100=38;5;239:*.r101=38;5;239:*.r102=38;5;239:*.r103=38;5;239:*.r104=38;5;239:*.r105=38;5;239:*.r106=38;5;239:*.r107=38;5;239:*.r108=38;5;239:*.r109=38;5;239:*.r11=38;5;239:*.r110=38;5;239:*.r111=38;5;239:*.r112=38;5;239:*.r113=38;5;239:*.r114=38;5;239:*.r115=38;5;239:*.r116=38;5;239:*.r12=38;5;239:*.r13=38;5;239:*.r14=38;5;239:*.r15=38;5;239:*.r16=38;5;239:*.r17=38;5;239:*.r18=38;5;239:*.r19=38;5;239:*.r20=38;5;239:*.r21=38;5;239:*.r22=38;5;239:*.r25=38;5;239:*.r26=38;5;239:*.r27=38;5;239:*.r28=38;5;239:*.r29=38;5;239:*.r30=38;5;239:*.r31=38;5;239:*.r32=38;5;239:*.r33=38;5;239:*.r34=38;5;239:*.r35=38;5;239:*.r36=38;5;239:*.r37=38;5;239:*.r38=38;5;239:*.r39=38;5;239:*.r40=38;5;239:*.r41=38;5;239:*.r42=38;5;239:*.r43=38;5;239:*.r44=38;5;239:*.r45=38;5;239:*.r46=38;5;239:*.r47=38;5;239:*.r48=38;5;239:*.r49=38;5;239:*.r50=38;5;239:*.r51=38;5;239:*.r52=38;5;239:*.r53=38;5;239:*.r54=38;5;239:*.r55=38;5;239:*.r56=38;5;239:*.r57=38;5;239:*.r58=38;5;239:*.r59=38;5;239:*.r60=38;5;239:*.r61=38;5;239:*.r62=38;5;239:*.r63=38;5;239:*.r64=38;5;239:*.r65=38;5;239:*.r66=38;5;239:*.r67=38;5;239:*.r68=38;5;239:*.r69=38;5;239:*.r69=38;5;239:*.r70=38;5;239:*.r71=38;5;239:*.r72=38;5;239:*.r73=38;5;239:*.r74=38;5;239:*.r75=38;5;239:*.r76=38;5;239:*.r77=38;5;239:*.r78=38;5;239:*.r79=38;5;239:*.r80=38;5;239:*.r81=38;5;239:*.r82=38;5;239:*.r83=38;5;239:*.r84=38;5;239:*.r85=38;5;239:*.r86=38;5;239:*.r87=38;5;239:*.r88=38;5;239:*.r89=38;5;239:*.r90=38;5;239:*.r91=38;5;239:*.r92=38;5;239:*.r93=38;5;239:*.r94=38;5;239:*.r95=38;5;239:*.r96=38;5;239:*.r97=38;5;239:*.r98=38;5;239:*.r99=38;5;239:*.rar=38;5;106;1:*.tar=38;5;118:*.tar.gz=38;5;34:*.tgz=38;5;35;1:*.xz=38;5;118:*.zip=38;5;41:*.pdf=38;5;203:*.djvu=38;5;141:*.cbr=38;5;140:*.cbz=38;5;140:*.chm=38;5;144:*.odt=38;5;111:*.ods=38;5;112:*.odp=38;5;166:*.odb=38;5;161:*.allow=38;5;112:*.deny=38;5;196:*.SKIP=38;5;244:*.def=38;5;136:*.directory=38;5;83:*.err=38;5;160;1:*.error=38;5;160;1:*.pi=38;5;126:*.properties=38;5;197;1:*.torrent=38;5;58:*.gp3=38;5;114:*.gp4=38;5;115:*.tg=38;5;99:*.pcap=38;5;29:*.cap=38;5;29:*.dmp=38;5;29:*.service=38;5;81:*@.service=38;5;45:*.socket=38;5;75:*.device=38;5;24:*.mount=38;5;115:*.automount=38;5;114:*.swap=38;5;113:*.target=38;5;73:*.path=38;5;116:*.timer=38;5;111:*.snapshot=38;5;139:';
export LS_COLORS

if [ `/usr/bin/tty` = '/dev/ttyE0' ]; then
#startx --:7: 2> /dev/null &
mlterm-fb -e zsh
fi


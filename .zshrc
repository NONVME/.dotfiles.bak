# If you come from bash you might have to change your $PATH.
export PATH=$HOME/.local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-syntax-highlighting zsh-autosuggestions poetry)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

#------------------------------
# setopt
#------------------------------
setopt histignorealldups # remove command lines from the history list when the first character on the line is a space
setopt hist_expire_dups_first # when trimming history, lose oldest duplicates first
setopt histignorespace
setopt nonomatch # try to avoid the 'zsh: no matches found...'
setopt hash_list_all  # whenever a command completion is attempted, make sure the entire command path is hashed first.
setopt completeinword # not just at the end
setopt globdots # включить cкрытые папки и файлы в глобалингё
setopt transient_rprompt # only show the rprompt on the current prompt
typeset -U path cdpath fpath manpath # automatically remove duplicates from these arrays

# editor
export EDITOR="vim"
export PAGER=/usr/bin/vimpager
alias less=$PAGER
alias zless=$PAGER

#------------------------------
# Prompt
#------------------------------

if [[ "$SHLVL" -gt "1" ]] then
   local LSHLVL=$SHLVL
fi

PROMPT="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ )"
PROMPT+='$LSHLVL'
PROMPT+=' %{$fg[cyan]%}%(4~|%-1~/.../%2~|%3~)%{$reset_color%} $(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

#------------------------------
# Alias
#------------------------------

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    #alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

if [ -f /usr/bin/grc ]; then
alias irclog="grc --colour=auto irclog"
alias log="grc --colour=auto log"
alias configure="grc --colour=auto configure"
alias ping="grc --colour=auto ping"
alias traceroute="grc --colour=auto traceroute"
alias gcc="grc --colour=auto gcc"
alias netstat="grc --colour=auto netstat"
alias stat="grc --colour=auto stat"
alias ss="grc --colour=auto ss"
alias diff="grc --colour=auto diff"
alias wdiff="grc --colour=auto wdiff"
alias last="grc --colour=auto last"
alias ldap="grc --colour=auto ldap"
alias cvs="grc --colour=auto cvs"
alias mount="grc --colour=auto mount"
alias findmnt="grc --colour=auto findmnt"
alias mtr="grc --colour=auto mtr"
alias ps="grc --colour=auto ps"
alias dig="grc --colour=auto dig"
alias ifconfig="grc --colour=auto ifconfig"
#alias ls="grc --colour=auto ls"
alias mount="grc --colour=auto mount"
alias df="grc --colour=auto df"
alias du="grc --colour=auto du"
alias ipaddr="grc --colour=auto ipaddr"
alias iproute="grc --colour=auto iproute"
alias ipneighbor="grc --colour=auto ipneighbor"
alias ip="grc --colour=auto ip"
alias env="grc --colour=auto env"
alias iptables="grc --colour=auto iptables"
alias lspci="grc --colour=auto lspci"
alias lsblk="grc --colour=auto lsblk"
alias lsof="grc --colour=auto lsof"
alias blkid="grc --colour=auto blkid"
alias id="grc --colour=auto id"
alias iostat_sar="grc --colour=auto iostat_sar"
alias fdisk="grc --colour=auto fdisk"
alias free="grc --colour=auto free"
alias findmnt="grc --colour=auto findmnt"
alias dockerps="grc --colour=auto dockerps"
alias dockerimages="grc --colour=auto dockerimages"
alias dockersearch="grc --colour=auto dockersearch"
alias dockerpull="grc --colour=auto dockerpull"
alias docker-machinels="grc --colour=auto docker-machinels"
alias dockernetwork="grc --colour=auto dockernetwork"
alias dockerinfo="grc --colour=auto dockerinfo"
alias dockerversion="grc --colour=auto dockerversion"
alias systemctl="grc --colour=auto systemctl"
alias sysctl="grc --colour=auto sysctl"
alias tcpdump="grc --colour=auto tcpdump"
alias tune2fs="grc --colour=auto tune2fs"
alias lsmod="grc --colour=auto lsmod"
alias lsattr="grc --colour=auto lsattr"
alias semanageboolean="grc --colour=auto semanageboolean"
alias semanagefcontext="grc --colour=auto semanagefcontext"
alias semanageuser="grc --colour=auto semanageuser"
alias getsebool="grc --colour=auto getsebool"
alias ulimit="grc --colour=auto ulimit"
alias vmstat="grc --colour=auto vmstat"
alias dnf="grc --colour=auto dnf"
alias nmap="grc --colour=auto nmap"
alias uptime="grc --colour=auto uptime"
alias getfacl="grc --colour=auto getfacl"
alias ntpdate="grc --colour=auto ntpdate"
alias showmount="grc --colour=auto showmount"
alias ant="grc --colour=auto ant"
alias mvn="grc --colour=auto mvn"
alias iwconfig="grc --colour=auto iwconfig"
alias lolcat="grc --colour=auto lolcat"
alias whois="grc --colour=auto whois"
fi

alias ll='ls -alhv --color=auto --group-directories-first'
alias l="ls -lhart --color=auto"
alias lf='find . -type f -ls'
alias cpr='rsync -ah --progress'
alias pwgen='pwgen -1 -Bs -n 15'
alias ra='. ranger'
alias man="man -L ru"
alias sudo="sudo "

pyvenv()
    { /usr/bin/python3 -m venv --copies ./$1;
}

#------------------------------
# ShellFuncs
#------------------------------

#GPG
export GPG_TTY=$(tty)

gpg-connect-agent /bye

unset SSH_AGENT_PID
if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
  export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
fi

# Зашифорвать
gpge() {
    tar cz $1 | gpg -r 'master' -e -o $1.tgz.gpg
    rm -rf $1
}

# Расшифровать
gpgd() {
    gpg -r 'master' -d $1 | tar xz
    rm -rf $1
}

# Transfer.sh
transfer () {
    # check arguments
    if [ $# -eq 0 ]; then
        echo "No arguments specified." >&2
        echo "Usage:" >&2
        echo "  transfer <file|directory>" >&2
        echo "  ... | transfer <file_name>" >&2
        return 1
    fi

    # upload stdin or file
    if tty -s; then
        file="$1"
        if [ ! -e "$file" ]; then
            echo "$file: No such file or directory" >&2
            return 1
        fi

        file_name=$(basename "$file" | sed -e 's/[^a-zA-Z0-9._-]/-/g')

        # upload file or directory
        if [ -d "$file" ]; then
            # transfer directory
            file_name="$file_name.zip"
            (cd "$file" && zip -r -q - .) | curl --progress-bar --upload-file "-" "https://alpha.transfer.sh/$file_name" | tee /dev/null
        else
            # transfer file
            cat "$file" | curl --progress-bar --upload-file "-" "https://alpha.transfer.sh/$file_name" | tee /dev/null
        fi
    else
        # transfer pipe
        file_name=$1
        curl --progress-bar --upload-file "-" "https://alpha.transfer.sh/$file_name" | tee /dev/null
    fi
    echo
}

## Распаковать архив
## example: exctract file
#extract () {
#if [ -z "$1" ]; then
## display usage if no parameters given
#echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
#else
#if [ -f $1 ] ; then
##NAME=${1%.*}
##mkdir $NAME && cd $NAME
#case $1 in
#*.tar.bz2)   tar xvjf ./$1    ;;
#*.tar.gz)    tar xvzf ./$1    ;;
#*.tar.xz)    tar xvJf ./$1    ;;
#*.lzma)      unlzma ./$1      ;;
#*.bz2)       bunzip2 ./$1     ;;
#*.rar)       unrar x -ad ./$1 ;;
#*.gz)        gunzip ./$1      ;;
#*.tar)       tar xvf ./$1     ;;
#*.tbz2)      tar xvjf ./$1    ;;
#*.tgz)       tar xvzf ./$1    ;;
#*.zip)       unzip ./$1       ;;
#*.Z)         uncompress ./$1  ;;
#*.7z)        7z x ./$1        ;;
#*.xz)        unxz ./$1        ;;
#*.exe)       cabextract ./$1  ;;
#*)           echo "extract: '$1' - unknown archive method" ;;
#esac
#else
#echo "$1 - file does not exist"
#fi
#fi
#}
#
## Запаковать архив
## example: pk tar file
#pk () {
# if [ $1 ] ; then
# case $1 in
# tbz)       tar cjvf $2.tar.bz2 $2      ;;
# tgz)       tar czvf $2.tar.gz  $2       ;;
# tar)      tar cpvf $2.tar  $2       ;;
# bz2)    bzip $2 ;;
# gz)        gzip -c -9 -n $2 > $2.gz ;;
# zip)       zip -r $2.zip $2   ;;
# 7z)        7z a $2.7z $2    ;;
# *)         echo "'$1' cannot be packed via pk()" ;;
# esac
# else
# echo "'$1' is not a valid file"
# fi
#}
#------------------------------
# Comp stuff
#------------------------------

#- buggy
zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
#-/buggy

zstyle ':completion:*:pacman:*' force-list always
zstyle ':completion:*:*:pacman:*' menu yes select

zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:*:processes' command 'ps -ax'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;32'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always

zstyle ':completion:*:processes-names' command 'ps -e -o comm='
zstyle ':completion:*:*:killall:*' menu yes select
zstyle ':completion:*:killall:*'   force-list always
#-----------------------------
# Dircolors
#-----------------------------
LS_COLORS='rs=0:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.3des=01;35:*.aes=01;35:*.gpg=01;35:*.pgp=01;35:*.bak=02;37:*.BAK=02;37:*.log=02;37:*.log=02;37:*.old=02;37:*.OLD=02;37:*.orig=02;37:*.ORIG=02;37:*.swo=02;37:*.swp=02;37:';
export LS_COLORS


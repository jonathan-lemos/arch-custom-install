# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
  export ZSH="~/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="agnoster"

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
DISABLE_AUTO_UPDATE="true"

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
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

ZSH_DISABLE_COMPFIX=true
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

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh
#
export VISUAL="nvim"
export PATH="$PATH:~/bin"

export IPUSER="lj437670"
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# user-defined aliases
alias please='sudo $(fc -ln -1)'
alias cd..="cd .."
alias ..="cd .."
alias gcc="gcc -Wall -Wextra -std=c99 -pedantic"
alias g++="g++ -Wall -Wextra -std=c++17 -pedantic"
alias objdump="objdump -M intel"
alias shutdown="shutdown now"
alias grep="grep --color -i -P"
alias ren="mv --no-target-directory"
alias osprey="ssh N01367640@osprey.unf.edu"
alias unmount="umount"
alias ff="find . -name"
alias md="mkdir"
alias mountiso="sudo mount -o loop"
alias mountusb="sudo mount -o rw,users,umask=000"
alias cp="cp --no-clobber"
alias quit="exit"
alias :q="exit"
alias :Q="exit"
alias :wq="exit"
alias hiber='systemctl hibernate'
alias qemu="qemu-system-x86_64"
alias make="make -j 18"
alias highcpu='echo -e "CPU\tPROCESS" && ps aux | awk '\''''{print $3"\t"$11}'\'' | sort -gr | head -10'
alias mktest="pushd . && cd ~/Documents/ezbackup && make test && popd"
alias vg="valgrind --leak-check=full -v"
alias cls="clear"
alias ohmyzsh="mate ~/.oh-my-zsh"
alias ipserver="ssh lj437670@139.62.210.181"
alias vim="nvim"

back+() {
	if [[ ! $1 ]]; then
		echo "Adds a path to the backup script"
		echo "Usage: back+ [path]"
		return
	fi
	echo $(realpath $1) >> ~/bin/backup_2.0_in
}

back-() {
	if [[ ! $1 ]]; then
		echo "Adds a path to be excluded from the backup script"
		echo "Usage: back- [path]"
		return
	fi
	echo $(realpath $1) >> ~/bin/backup_2.0_exclude
}

back() {
	~/bin/backup_2.0 ~/bin/backup_2.0_in ~/bin/backup_2.0_exclude
}

pv() {
	if [[ ! $1 ]]; then
		echo "Python eVal"
		echo "Usage: pv [command]"
		return
	fi
	python <<< "from math import *;cosd=lambda x:cos(x*pi/180);sind=lambda x:sin(x*pi/180);tand=lambda x:tan(x*pi/180);print("$@")"
}

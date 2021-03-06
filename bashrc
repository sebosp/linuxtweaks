#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export HOME="/home/seb"
alias ls='ls --color=auto'
#COREPS1='"[\u@\h \W]"'
#COREPS1='\A \[\e[36m\]\u:[\w]\[\e[0m\] $ '
#COREPS1='"\A \[\e[36m\]\u\[\e[0;31m\]@\h\[\e[0;31m\]\[\e[m\]:[\[\e[1;30m\]\w\[\e[m\]]"'
COREPS1='"\A \[\e[36m\]\u\[\e[0;31m\]@\h\[\e[0;31m\]\[\e[m\]:[\[\e[2m\]\w\[\e[0m\]]"'
export VISUAL=vim
export EDITOR=vim
export HISTSIZE=10000
export HISTFILESIZE=50000
shopt -s histappend
export HISTCONTROL=ignoreboth:erasedups
export HISTFILE=$HOME/.bash_history
source /usr/share/git/completion/git-prompt.sh
export PREPS1='__git_ps1 '
export POSPS1=' "\\\$ "'
export PROMPT_COMMAND="${PREPS1}${COREPS1}${POSPS1}"
#export PROMPT_COMMAND='__git_ps1 "\u@\h:\w" "\\\$ "'
#export PROMPT_COMMAND=__git_prompt
no_git_prompt ()
{
	export PREPS1=' '
	export PS1='\A \[\e[36m\]\u\[\e[0;31m\]@\h\[\e[0;31m\]\[\e[m\]:[\[\e[2m\]\w\[\e[0m\]] '
	unset PROMPT_COMMAND
}
git_prompt ()
{
	export PS1="${PREPS1}${COREPS1}${POSPS1}"
}
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWCOLORHINTS=1
GIT_PS1_DESCRIBE_STYLE="branch"
GIT_PS1_SHOWUPSTREAM="auto git"
PS1="${PREPS1}${COREPS1}${POSPS1}"

PATH="/home/seb/perl5/bin${PATH+:}${PATH}";
PERL5LIB="/home/seb/perl5/lib/perl5${PERL5LIB+:}/usr/share/perl5/vendor_perl"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/seb/perl5${PERL_LOCAL_LIB_ROOT+:}${PERL_LOCAL_LIB_ROOT}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/seb/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/seb/perl5"; export PERL_MM_OPT;

source ~/preexec.bash.txt
if [[ $TERM =~ "screen" ]]; then
	preexec_xterm_title_install
	source ~/screen-preexec.sh
fi
WDL=/usr
MESA_DEBUG=1
EGL_LOG_LEVEL=debug
LIBGL_DEBUG=verbose
WAYLAND_DEBUG=1
export WDL MESA_DEBUG EGL_LOG_LEVEL LIBGL_DEBUG WAYLAND_DEBUG
export PATH=$PATH:android-studio/bin/
export PATH="$PATH:$HOME/.rvm/bin"
alias R='R --quiet'
man() {
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    command man "$@"
}
randTagFile () { perl -e '($ml)=(split " ",`wc -l tags`);$rl=int(rand($ml));while(<>){($f)=(split(/\t/))[1] if ($. == $rl)}print "$f\n"' tags; }
export PATH=$PATH:/data/kubernetes/kubernetes/cluster:$HOME/.cargo/bin
export KUBERNETES_PROVIDER=vagrant
export JAVA_HOME=/usr/lib/jvm/default
export GOPATH=/data/git/go
export PATH=$PATH:/data/git/go/bin
alias proveall='prove -j9 --state=slow,save -lr t'
export PROMPT_DIRTRIM=4

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/var/tmp/google-cloud-sdk/path.bash.inc' ]; then source '/var/tmp/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/var/tmp/google-cloud-sdk/completion.bash.inc' ]; then source '/var/tmp/google-cloud-sdk/completion.bash.inc'; fi

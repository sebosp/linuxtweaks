#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
#COREPS1='"[\u@\h \W]"'
#COREPS1='\A \[\e[36m\]\u:[\w]\[\e[0m\] $ '
COREPS1='"\A \[\e[36m\]\u\[\e[0;31m\]@\h\[\e[0;31m\]\[\e[m\]:[\[\e[1;30m\]\w\[\e[m\]]"'
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
__git_prompt ()
{
		txtblk='\e[0;30m' # Black - Regular
		txtred='\e[0;31m' # Red
		txtgrn='\e[0;32m' # Green
		txtylw='\e[0;33m' # Yellow
		txtblu='\e[0;34m' # Blue
		txtpur='\e[0;35m' # Purple
		txtcyn='\e[0;36m' # Cyan
		txtwht='\e[0;37m' # White
		bldblk='\e[1;30m' # Black - Bold
		bldred='\e[1;31m' # Red
		bldgrn='\e[1;32m' # Green
		bldylw='\e[1;33m' # Yellow
		bldblu='\e[1;34m' # Blue
		bldpur='\e[1;35m' # Purple
		bldcyn='\e[1;36m' # Cyan
		bldwht='\e[1;37m' # White
		txtrst='\e[0m' # Text Reset
		 
		CURRENT_BRANCH=`git branch 2>/dev/null | grep '*' | head -n1`
		CURRENT_BRANCH=${CURRENT_BRANCH:2}
		if [ -z "$CURRENT_BRANCH" ] ; then
				gitstatus=''
		else
				STATUS_LINES=`git status`
				if [[ "$STATUS_LINES" =~ "# Changed but not updated" ]] ; then
						colour=$bldred
				elif [[ "$STATUS_LINES" =~ "# Changes to be committed" ]] ; then
						colour=$bldgrn
				elif [[ "$STATUS_LINES" =~ "# Untracked files" ]] ; then
						colour=$bldblu
				else
						colour=$bldblk
				fi
				gitstatus=" "$colour":"${CURRENT_BRANCH}$txtrst
		fi
		PS1="${PREPS1}${COREPS1}${POSPS1}"
}
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWCOLORHINTS=1
GIT_PS1_DESCRIBE_STYLE="branch"
GIT_PS1_SHOWUPSTREAM="auto git"
PS1="${PREPS1}${COREPS1}${POSPS1}"

PATH="/home/seb/perl5/bin${PATH+:}${PATH}"; export PATH;
PERL5LIB="/home/seb/perl5/lib/perl5${PERL5LIB+:}${PERL5LIB}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/seb/perl5${PERL_LOCAL_LIB_ROOT+:}${PERL_LOCAL_LIB_ROOT}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/seb/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/seb/perl5"; export PERL_MM_OPT;
if [[ $TERM =~ "screen" ]]; then
	preexec_xterm_title_install
	source ~/screen-preexec.sh
else
	source ~/preexec.bash.txt
fi


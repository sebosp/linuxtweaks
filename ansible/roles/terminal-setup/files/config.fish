
abbr -a yr 'cal -y'
abbr -a c cargo
abbr -a e nvim
abbr -a vim nvim
abbr -a m make
abbr -a k kubectl
abbr -a o xdg-open
abbr -a g git
abbr -a gc 'git checkout'
abbr -a ga 'git add -p'
abbr -a vimdiff 'nvim -d'
abbr -a ct 'cargo t'
abbr -a ais "aws ec2 describe-instances | jq '.Reservations[] | .Instances[] | {iid: .InstanceId, type: .InstanceType, key:.KeyName, state:.State.Name, host:.PublicDnsName}'"
abbr -a gah 'git stash; and git pull --rebase; and git stash pop'

if status is-interactive
	and not set -q TMUX
	tmux new -t: || tmux new -s seb
end

set -gx K8SCTX ""
set -gx K8SNS ""
set -gx K8S_PS1_SHOW 1
set -gx AWS_PS1_SHOW 0
set -gx K8S_PROMPT_TTL 5
set -gx AWS_PROMPT_TTL 15
set -gx K8S_LAST_NS_PROMPT_CHECK 1
set -gx K8S_LAST_CTX_PROMPT_CHECK 1
set -gx AWS_LAST_PROMPT_CHECK 1
if command -v aurman > /dev/null
	abbr -a p 'aurman'
	abbr -a up 'aurman -Syu'
else
	abbr -a p 'sudo pacman'
	abbr -a up 'sudo pacman -Syu'
end

if command -v exa > /dev/null
	abbr -a l 'exa'
	abbr -a ll 'exa -l'
	abbr -a lll 'exa -la'
else
	abbr -a l 'ls'
	abbr -a ll 'ls -l'
	abbr -a lll 'ls -la'
end

if [ -e /usr/share/fish/functions/fzf_key_bindings.fish ]; and status --is-interactive
	source /usr/share/fish/functions/fzf_key_bindings.fish
end

if test -f /usr/share/autojump/autojump.fish;
	source /usr/share/autojump/autojump.fish;
end

# Init the k8s and aws prompts
# fish_k8s_prompt

function ssh
	switch $argv[1]
	case "*.amazonaws.com"
		env TERM=xterm /usr/bin/ssh $argv
	case "ubuntu@"
		env TERM=xterm /usr/bin/ssh $argv
	case "*"
		/usr/bin/ssh $argv
	end
end

function apass
	if test (count $argv) -ne 1
		pass $argv
		return
	end

	adb shell input text (pass $argv[1] | head -n1 | sed -e 's/ /%s/g' -e 's/\([()<>$|;&*\\~"\'`]\)/\\\\\1/g')
end

function limit
	numactl -C 0,2 $argv
end

function remote_alacritty
	# https://gist.github.com/costis/5135502
	set fn (mktemp)
	infocmp alacritty > $fn
	scp $fn $argv[1]":alacritty.ti"
	ssh $argv[1] tic "alacritty.ti"
	ssh $argv[1] rm "alacritty.ti"
end

# Type - to move up to top parent dir which is a repository
function d
	while test $PWD != "/"
		if test -d .git
			break
		end
		cd ..
	end
end

# Find config files for terraform, python, yamls, jsons in current dir
function ff
    # TODO: Does not support space separated... need $@
    if [ -z $argv[1] ]
      echo "Missing search argument" 1>&2
      return
   end
   find . -type f -name '*.yaml' -o -name '*.yml' -o -name '*.json' -o -name '*.py' -o -name '*.tf*' -exec grep -Hi $argv[1] {} \;
end

# Fish git prompt
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate ''
set __fish_git_prompt_showupstream 'none'
set -g fish_prompt_pwd_dir_length 3

# colored man output
# from http://linuxtidbits.wordpress.com/2009/03/23/less-colors-for-man-pages/
setenv LESS_TERMCAP_mb \e'[01;31m'       # begin blinking
setenv LESS_TERMCAP_md \e'[01;38;5;74m'  # begin bold
setenv LESS_TERMCAP_me \e'[0m'           # end mode
setenv LESS_TERMCAP_se \e'[0m'           # end standout-mode
setenv LESS_TERMCAP_so \e'[38;5;246m'    # begin standout-mode - info box
setenv LESS_TERMCAP_ue \e'[0m'           # end underline
setenv LESS_TERMCAP_us \e'[04;38;5;146m' # begin underline

# For RLS
# https://github.com/fish-shell/fish-shell/issues/2456
setenv LD_LIBRARY_PATH (rustc +nightly --print sysroot)"/lib:$LD_LIBRARY_PATH"
setenv RUST_SRC_PATH (rustc --print sysroot)"/lib/rustlib/src/rust/src"

setenv FZF_DEFAULT_COMMAND 'fd --type file --follow'
setenv FZF_CTRL_T_COMMAND 'fd --type file --follow'
setenv FZF_DEFAULT_OPTS '--height 20%'

# Fish should not add things to clipboard when killing
# See https://github.com/fish-shell/fish-shell/issues/772
set FISH_CLIPBOARD_CMD "cat"

function fish_user_key_bindings
	bind \cz 'fg>/dev/null ^/dev/null'
	if functions -q fzf_key_bindings
		fzf_key_bindings
	end
end

function fish_prompt
	set_color brblack
	echo -n "["(date "+%H:%M")"] "
	if test $K8S_PS1_SHOW = 1
		printf -- '%s' (fish_k8s_prompt)
	end
	set_color blue
	if test $AWS_PS1_SHOW = 1
		printf '@%s' (fish_aws_role_prompt)
	end
	if test "$PWD" != "$HOME"
		set_color brblack
		echo -n ':'
		set_color yellow
        # show up to 3 more depth directories:
		echo -n (echo $PWD|sed "s|$HOME|~|"|sed 's|^.*/\([^/]*/[^/]*/[^/]*\)$|\1|')
	end
	set_color green
	printf '%s ' (__fish_git_prompt)
	set_color red
	echo -n '| '
	set_color normal
end

function fish_greeting
	echo
	echo -e (uname -v | awk '{print " \\\\e[1mOS: \\\\e[0;32m"$0"\\\\e[0m"}')
	echo -e (uptime | awk '{print " \\\\e[1mUptime: \\\\e[0;32m"$0"\\\\e[0m"}')
	echo -e " \\e[1mDisk usage:\\e[0m "
    set -l is_darwin (uname -v | grep -c Darwin)
    if test "$is_darwin" = "1"
        df -h|grep '^/dev' | while read fs size used avail capacity isud ifree iused mounted;
            set -l cap (echo $capacity| cut -d% -f1)
            if test $cap -lt 80
                set_color green
            else if test $cap -lt 90
                set_color yellow
            else
                set_color red
            end
            printf "%5s%%\t%20s\t%s\n" $cap $mounted $fs
        end
	else
       echo -ne (\
               df -l -h | grep -E 'dev/(xvda|sd|mapper)' | \
               awk '{printf "\\\\t%s\\\\t%4s / %4s  %s\\\\n\n", $6, $3, $2, $5}' | \
               sed -e 's/^\(.*\([8][5-9]\|[9][0-9]\)%.*\)$/\\\\e[0;31m\1\\\\e[0m/' -e 's/^\(.*\([7][5-9]\|[8][0-4]\)%.*\)$/\\\\e[0;33m\1\\\\e[0m/' | \
               paste -sd ''\
       )
       echo

    end
	set_color normal
	echo

	if test -s ~/todo
		set r (random 0 100)
#		if [ $r -lt 5 ] # only occasionally show backlog (5%)
#			echo -e " \e[1mBacklog\e[0;32m"
#			set_color blue
#	                grep '^BACKLOG' ~/todo| sed 's/^BACKLOG/ - /g'
#			echo
#		end

		set_color normal
		echo -e " \e[1mTODOs\e[0;32m"
		echo
		# urgent, so prompt always
		set_color red
	        grep -E '^URGENT' ~/todo| sed 's/^URGENT/ - /g'
	        # todo looks like <PRIORITY> PROJECT Description
		if [ $r -lt 10 ]
			# unimportant, so show rarely
			set_color cyan
	                grep '^UNIMPORTANT' ~/todo| sed 's/^UNIMPORTANT/ - /g'
		end
		if [ $r -lt 25 ]
			# back-of-my-mind, so show occasionally
			set_color green
	                grep '^BACKOFMYMIND' ~/todo| sed 's/^BACKOFMYMIND/ - /g'
		end
		if [ $r -lt 50 ]
			# upcoming, so prompt regularly
			set_color yellow
	                grep -E '^UPCOMING' ~/todo| sed 's/^UPCOMING/ - /g'
		end
	
		echo
	end

	set_color normal
end

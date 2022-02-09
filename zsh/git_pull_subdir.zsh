function _gpl() {
	if [[ ! $(git rev-parse --remotes=$1 2>/dev/null) ]]
	then
		if [[ $1 ]]
		then
			echo "Remote \`$1\` does not exist, pull default upstream instead."
			git pull
		else
			echo "No remote is configured for this repo."
		fi
	else
		if [[ $1 ]]
		then
			if [[ $2 ]]
			then
				git pull $1 $2
			else
				local currentbranch=$(git branch --show-current)
				echo "Branch not specified, use current branch \`$currentbranch\` instead."
				git pull $1 $currentbranch
			fi
		else
			echo "Remote not specified, pull default upstream instead."
			git pull
		fi
	fi
}

function gpl() {
	echo $(pwd)
	echo -----

	ls -d */ &>/dev/null
	local f=$?
	if [[ $f -eq 0 ]]
	then
		for i in $(ls -d */)
		do
			echo $i
			cd -q $i
			local f=$?
			if [[ ! $f -eq 0 ]]
			then
				echo "cd \`$i\` failed. Continue..."
			else
				if [ ! command git rev-parse --is-inside-work-tree &>/dev/null ]
				then
					echo "\`$i\` is not inside git repo."
				else
					local gitdir=$(git rev-parse --absolute-git-dir 2>/dev/null)
					if [[ $lastgitdir && $gitdir = $lastgitdir ]]
					then
						echo "Git dir same with last one. Skip..."
					else
						_gpl $@
						local lastgitdir=$gitdir
					fi
				fi
				cd -q ..
			fi
			echo -----
		done
	else
		if [ ! command git rev-parse --is-inside-work-tree &>/dev/null ]
		then
			echo "\`$(pwd)\` is not inside git repo."
		else
			echo ${$(git rev-parse --absolute-git-dir 2>/dev/null)%/.git}
			_gpl $@
		fi
	fi
}

alias gplu='gpl upstream'


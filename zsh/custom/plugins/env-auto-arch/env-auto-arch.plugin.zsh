if [ "$(arch)" = "arm64" ]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
else
	eval "$(/usr/local/bin/brew shellenv)"
	# export PYENV_ROOT="$HOME/.pyenv-x86"
fi

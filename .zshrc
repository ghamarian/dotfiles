#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
zstyle ':prezto:load' pmodule \
  'environment' \
  'terminal' \
  'editor' \
  'history' \
  'directory' \
  'spectrum' \
  'utility' \
  'completion' \
  'git' \
  'syntax-highlighting' \
  'history-substring-search' \
  'prompt' \
  'macos'

zstyle ':prezto:module:prompt' theme 'paradox'
#source ~/Projects/config/env.sh

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
setopt clobber
export SDKMAN_DIR="/Users/ghama/.sdkman"
[[ -s "/Users/ghama/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/ghama/.sdkman/bin/sdkman-init.sh"
setopt -o noclobber

source "$HOME/.sdkman/bin/sdkman-init.sh"
export JAVA_HOME=$(/usr/libexec/java_home)

export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"

export GOPATH="$HOME/go"

alias ls='ls --color=auto'

export PATH="$HOME/bin/:/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
export PATH="/Users/ghama/.stack/snapshots/x86_64-osx/lts-8.13/8.0.2/bin:/Users/ghama/.stack/programs/x86_64-osx/ghc-8.0.2/bin:$PATH"
export PATH="/Users/ghama/pega/prpc-git/prgit/build/dist:$PATH"
export PATH="/Library/TeX/texbin:$PATH"
export PATH="/Users/ghama/.local/bin:$PATH"
export PATH="$GOPATH/bin:$PATH"

export VISUAL="vim"
export EDITOR="$EDITOR"

export CDIFF_OPTIONS='-s -w0'
. /usr/local/etc/profile.d/z.sh

#source ~/.iterm2_shell_integration.`basename $SHELL`

eval "$(rbenv init -)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
rbenv shell 2.4.1
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export CPPFLAGS=-I/usr/local/opt/openssl/include
export LDFLAGS=-L/usr/local/opt/openssl/lib

#export PATH="$(pyenv root)/versions/2.7.6/bin:$(pyenv root)/versions/3.7-dev/bin:$PATH"

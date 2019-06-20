#!/bin/sh
echo "Setting up Python"

# Install Python and applications
eval "$(pyenv init -)"
pyenv install 3.7.2
pyenv global 3.7.2


export PATH="/usr/local/opt/python/libexec/bin:$PATH"
pip install cheat

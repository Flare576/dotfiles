#!/bin/sh
echo "Setting up Python"

# Install Python and applications
pyenv install 3.7.2
pyenv global 3.7.2
eval "$(pyenv init -)"
pip install cheat

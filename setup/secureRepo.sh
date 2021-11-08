#!/bin/bash
echo "Securing DotFiles repo"

pushd "$HOME/dotfiles"
bash -c "$(curl -sSL https://thoughtworks.github.io/talisman/install.sh)" -- pre-commit
popd

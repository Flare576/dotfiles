#!/bin/bash
# Make working on images suck less - make them feel like $HOME. Only expectation is that curl was used to retrieve script
# from initial prompt:
# apt-get update &> /dev/null;apt-get install -y --no-install-recommends ca-certificates curl &> /dev/null;bash -c "$(curl -sSL https://raw.githubusercontent.com/Flare576/dotfiles/main/setup/NIX/ubuntu_remote.sh)"

starting=$(date +%s%N)
apt-get update &> /dev/null
# Install git to pull down dotfiles repo
apt-get install -y git &> /dev/null

# Pull the rest of the project
cd $HOME

if [ ! -d dotfiles ]; then
  if ! command -v git &> /dev/null; then
    echo "Installing git for project clone"
    apt-get install -y --no-install-recommends git
  fi
  # Pull the rest of the project
  git clone https://github.com/Flare576/dotfiles.git

  # Install safety precautions around this repo
  bash $HOME/dotfiles/setup/secureRepo.sh
fi

# Link dotFiles
echo "Linking dotfiles"
bash $HOME/dotfiles/setup/linkFiles.sh

# Install Applications - the flags are to prevent prompts
DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC bash $HOME/dotfiles/setup/installer.sh -p remote -m

# Finish with a CTA!
ending=$(date +%s%N)
sec=1000000000
duration=$((ending - starting))
seconds=$(( duration / sec ))
millis=$(( (duration - (seconds * sec)) / 1000000 ))

echo "[31;47m⏱  TIME ⏱ [0m
Finished in ${seconds}.${millis}s.
Type [91;47mzsh[0m then either [93;47mst light[0m or [37;40mst dark[0m to get stated."

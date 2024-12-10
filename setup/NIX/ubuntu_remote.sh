#!/bin/bash
# Make working on images suck less - make them feel like $HOME. Only expectation is that curl was used to retrieve script
# from initial prompt:
# apt-get update &> /dev/null;apt-get install -y --no-install-recommends ca-certificates curl &> /dev/null;bash -c "$(curl -sSL https://raw.githubusercontent.com/Flare576/dotfiles/main/setup/NIX/ubuntu_remote.sh)"

starting=$(date +%s%N)
apt-get update &> /dev/null
# Install git to pull down dotfiles repo, sudo because not every system needs it
apt-get install -y git sudo &> /dev/null

# Pull the rest of the project
cd $HOME
echo "Cloning dotfiles"
git clone -q https://github.com/Flare576/dotfiles.git

# Install safety precautions around this repo
bash $HOME/dotfiles/setup/secureRepo.sh

# Link dotFiles
echo "Linking dotfiles"
bash $HOME/dotfiles/setup/linkFiles.sh

# Setup Apps
bash $HOME/dotfiles/setup/installer.sh -p remote -m

# Finish with a CTA!
ending=$(date +%s%N)
sec=1000000000
duration=$((ending - starting))
seconds=$(( duration / sec ))
millis=$(( (duration - (seconds * sec)) / 1000000 ))

echo "[31;47m⏱  TIME ⏱ [0m
Finished in ${seconds}.${millis}s.
Type [91;47mzsh[0m then either [93;47mst light[0m or [37;40mst dark[0m to get stated."

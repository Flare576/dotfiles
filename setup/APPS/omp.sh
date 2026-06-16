#!/bin/bash
source "$(dirname "$0")/../utils.sh"
usage="$(basename "$0") [-hvadmu]
Installs, links, and manages Oh My Pi (OMP) and its skill npm dependencies.
OMP is an AI coding agent harness built on top of Claude.
Options:
  -h Show this help
  -v Display version
  -a Install binary + all skill npm deps (unattended)
  -d Uninstall OMP binary and remove skill symlinks
  -m Minimal: install binary only, skip skill linking and npm deps
  -u Update OMP binary (skips if not installed)
"
while getopts ':hvadmu' option; do
  case "$option" in
    h) echo "$usage"
      exit
      ;;
    v) echo "$VERSION"
      exit
      ;;
    a) allDeps="true"
      ;;
    d) doDestroy="true"
      ;;
    m) minimal="true"
      ;;
    u) doUpdate="true"
      ;;
    *) echo "Unknown Option '$OPTARG', exiting"
      exit
      ;;
  esac
done
shift $((OPTIND -1))

check="$allDeps$doDestroy$minimal$doUpdate"

if [ -n "$check" ] && [ "$check" != "true" ]; then
  echo "-a, -d, -m, and -u are mutually exclusive; use one only"
  exit
fi

SKILLS_DIR="$HOME/dotfiles/skills"
OMP_SKILLS="$HOME/.omp/agent/skills"

if [ "$doDestroy" == "true" ]; then
  echo "Uninstalling OMP..."
  bun remove -g @oh-my-pi/pi-coding-agent
  if [ -d "$OMP_SKILLS" ]; then
    for link in "$OMP_SKILLS"/*/; do
      target="$(readlink "${link%/}")"
      if [[ "$target" == "$SKILLS_DIR"* ]]; then
        echo "Removing skill symlink: $(basename "${link%/}")"
        rm -f "${link%/}"
      fi
    done
  fi
  exit
fi

command -v bun &> /dev/null || { echo 'bun required: https://bun.sh'; exit 1; }

if [ "$doUpdate" == "true" ]; then
  if ! command -v omp &> /dev/null; then
    echo "OMP not installed, skipping update"
    exit
  fi
  echo "Updating OMP..."
  bun update -g @oh-my-pi/pi-coding-agent
  exit
fi

echo "Installing OMP binary..."
bun install -g @oh-my-pi/pi-coding-agent

if [ "$minimal" == "true" ]; then
  echo "Minimal install complete (skill linking and npm deps skipped)"
  exit
fi

echo "Linking skills..."
mkdir -p "$OMP_SKILLS"
for skill in "$SKILLS_DIR"/*/; do
  ln -sf "$skill" "$OMP_SKILLS/$(basename "$skill")"
  echo "  Linked: $(basename "$skill")"
done

# npm deps for skills that ship scripts/package.json
for skill in "$SKILLS_DIR"/*/; do
  pkgjson="${skill}scripts/package.json"
  if [[ -f "$pkgjson" ]]; then
    skillName="$(basename "$skill")"
    if [ "$allDeps" == "true" ]; then
      echo "Installing npm deps for skill: $skillName"
      (cd "${skill}scripts" && npm install --silent)
    else
      read -rp "Install npm deps for skill '$skillName'? (y/n): " answer
      if [[ "$answer" == "y"* ]]; then
        (cd "${skill}scripts" && npm install --silent)
      fi
    fi
  fi
done

linkToHome .zshenv.omp

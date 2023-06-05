#!/bin/bash

script="check_ubuntu_updates.sh"
version="1.2.0"
author="John Gonzalez"

while getopts ":v" opt; do
  case $opt in
    v)
      echo "$script - $author - $version"
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

# Check for updates
updates=$(apt list --upgradable 2>/dev/null | grep -c /)

# Check for security, stable, and recommended updates
security=$(apt list --upgradable 2>/dev/null | grep -cE '/.*security|/.*ubuntu.*security')
stable=$(apt list --upgradable 2>/dev/null | grep -cE '/.*stable|/.*ubuntu.*stable')

# Check for kernel updates
kernel=$(apt list --upgradable linux-image-* 2>/dev/null | grep -c linux-image)

# Check if any packages are in phased update
phased_updates=0
for package in $(apt list --upgradable 2>/dev/null | awk -F/ '{print $1}'); do
  policy_output=$(apt-cache policy "$package")
  if echo "$policy_output" | grep -q "phased"; then
    phased_updates=$((phased_updates + 1))
  fi
done

if [ $updates -eq 0 ]; then
  echo "No updates available."
  exit 0
elif [ $phased_updates -eq $updates ]; then
  echo "$updates Ubuntu updates are available. All updates are in phased updates."
  exit 0
elif [ $security -gt 0 ] || [ $stable -gt 0 ] || [ $kernel -gt 0 ] || [ $phased_updates -gt 0 ]; then
  echo "$updates Ubuntu updates are available. $security are security updates, $stable are stable updates, $kernel are kernel updates. $phased_updates updates are in phased update."
  exit 2
else
  echo "$updates Ubuntu updates are available. $security are security updates, $stable are stable updates, $kernel are kernel updates. $phased_updates updates are in phased update."
  exit 1
fi

#!/bin/bash

script="check_debian_updates.sh"
version="1.1.0"
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
security=$(apt list --upgradable 2>/dev/null | grep -c /.*security)
stable=$(apt list --upgradable 2>/dev/null | grep -c /.*stable)

# Check for kernel updates
kernel=$(apt list --upgradable linux-image-* 2>/dev/null | grep -c linux-image)

if [ $updates -eq 0 ]; then
  echo "No updates available"
  exit 0
elif [ $security -gt 0 ] || [ $stable -gt 0 ] || [ $kernel -gt 0 ]; then
  echo "$updates Debian updates are available. $security are security updates, $stable are stable updates, $kernel are kernel updates."
  exit 2
else
  echo "$updates Debian updates are available. $security are security updates, $stable are stable updates, $kernel are kernel updates."
  exit 1
fi

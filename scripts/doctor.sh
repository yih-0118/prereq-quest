#!/usr/bin/env bash
# Prerequisite Quest - environment doctor.
#
# Non-destructive. Only reports what it finds; never installs anything.
#
# Usage:
#   ./scripts/doctor.sh

echo "Prerequisite Quest Doctor"
echo

report() {
  local name="$1" status="$2" hint="$3"
  printf '%-10s %s\n' "$name" "$status"
  if [ -n "$hint" ] && [ "$status" != "OK" ]; then
    printf '           %s\n' "$hint"
  fi
}

if command -v git >/dev/null 2>&1; then
  report "git" "OK" ""
else
  report "git" "MISSING" "Install Git: https://git-scm.com/downloads"
fi

if command -v ssh >/dev/null 2>&1; then
  report "ssh" "OK" ""
else
  report "ssh" "MISSING" "An OpenSSH client ships with macOS, most Linux distros, Git Bash, and Windows 10+ (Settings > Optional features > OpenSSH Client)."
fi

if command -v docker >/dev/null 2>&1; then
  if docker info >/dev/null 2>&1; then
    report "docker" "OK" ""
  else
    report "docker" "INSTALLED (not running)" "Start Docker Desktop / the Docker daemon."
  fi
else
  report "docker" "MISSING" "Install Docker: https://docs.docker.com/get-docker/"
fi

if command -v janet >/dev/null 2>&1; then
  report "janet" "OK" ""
else
  report "janet" "MISSING" "Optional locally: you can also run the program via Docker (Mission 05). To install: https://janet-lang.org/docs/index.html"
fi

if [ -n "${BASH_VERSION:-}" ]; then
  report "bash" "OK" ""
else
  report "bash" "MISSING" "This script expects bash; try running it with 'bash scripts/doctor.sh'."
fi

key="missions/03-ssh/knock knock"

if [ -f "$key" ]; then
    perms=$(stat -f "%Lp" "$key" 2>/dev/null || stat -c "%a" "$key" 2>/dev/null)

    if [ "$perms" != "600" ] && [ "$perms" != "400" ]; then
        echo "ssh private key permissions are $perms; try: chmod 600 \"$key\""
    fi
fi

echo
echo "This is a diagnostic, not an installer. Fix what's MISSING using"
echo "whatever method you'd normally use on your own machine."

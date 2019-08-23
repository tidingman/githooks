#!/bin/sh

# This script should be saved in a git repo as a hook file, e.g. .git/hooks/pre-receive.
# It looks for scripts in the .git/hooks/pre-receive.d directory and executes them in order,
# passing along stdin. If any script exits with a non-zero status, this script exits.

hooks_dir=$(dirname $0)

hook_name=$(basename $0)
hook_dir="$hooks_dir/$hook_name.d"

echo "hooks_dir = $hooks_dir"

echo "hook_name = $hook_name"
echo "hook_dir = $hook_dir"

if [[ -d $hook_dir ]]; then
  stdin=$(cat /dev/stdin)

  for hook in $hook_dir/*; do
    echo "Running $hook_name/$hook hook"
    echo "$stdin" | $hook "$@"

    exit_code=$?

    if [ $exit_code != 0 ]; then
      exit $exit_code
    fi
  done
fi

exit 0

#!/bin/sh

#set -x -e

if [[ -f "go.mod" ]];then

echo "workdir=$PWD"
echo "executing golang pre-commit hook"

# 目前goimports变更后的内容无法直接被commit，所以这里先注释掉，改用提醒并退出commit的方式
# goimports -l -w $PWD/cmd $PWD/pkg $PWD/internal && exit 0

# git goimports pre-commit hook
#
# To use, store as .git/hooks/pre-commit inside your repository and make sure
# it has execute permissions.
#
# This script does not handle file names that contain spaces.

gofiles=$(git diff --cached --name-only --diff-filter=ACM | grep '\.go$')
[ -z "$gofiles" ] && exit 0

unformatted=$(goimports -l $gofiles)
[ -z "$unformatted" ] && exit 0

# Some files are not goimports'd. Print message and fail.

echo >&2 "Go files must be formatted with goimports. Please run:"
for fn in $unformatted; do
	echo >&2 " goimports -w $PWD/$fn"
done

exit 1

fi

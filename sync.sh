#!/bin/bash

gut() {
		git clone --depth=1 -q $@
	}

is_head () {
    $GIT ls-remote -q --heads --exit-code "origin" 
    return $?
}

is_tag () {
    $GIT ls-remote -q --tags --exit-code "origin" 
    return $?
}

update () {
    if is_head; then
        echo "Found branch, using its head"
        remote set-branches --add origin || exit "$?"
        fetch origin --depth=1 || exit "$?"
        SRC="origin"
    elif is_tag; then
        echo "Found tag, using its head"
        fetch origin tag "${REF}" --depth=1 || exit "$?"
        SRC="tag"
    elif [ -z "origin/HEAD" ]; then
        echo "No ref provided, using origin head"
        fetch origin "HEAD" --depth=1 || exit "$?"
        SRC="origin/HEAD"
    else
        echo "No such tag or branch, aborting!"
        exit 1
    fi
    checkout -f --detach "${SRC}" || exit "$?"
}

if [ ! -d "$@" ]; then
    mkdir -p "$@"
    gut "${URL}" . -n --depth=1 || exit "$?"
fi

update

echo "Done!"

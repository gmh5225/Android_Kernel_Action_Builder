#!/bin/bash

gut() {
		git clone --depth=1 -q $@
	}

is_head () {
    ls-remote -q --heads --exit-code "origin" 
    return $?
}

is_tag () {
    ls-remote -q --tags --exit-code "origin" 
    return $?
}

update () {
    if is_head; then
        echo "Found branch, using its head"
        remote set-branches --add origin
        fetch origin 
        SRC="origin"
    elif is_tag; then
        echo "Found tag, using its head"
        fetch origin tag 
        SRC="origin"
    elif [ -z "origin/HEAD" ]; then
        echo "No ref provided, using origin head"
        fetch origin "HEAD" 
        SRC="origin/HEAD"
    else
        echo "No such tag or branch, aborting!"
        exit 1
    fi
    checkout -f --detach "${SRC}"
}

if [ ! -d "$@" ]; then
    mkdir -p "$@"
    gut "${URL}"
fi

update

echo "Done!"

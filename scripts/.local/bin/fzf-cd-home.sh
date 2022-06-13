#!/bin/bash

main() {
    local fdRes=$(fd --base-directory ~ --type directory)
	cd $($fdRes | fzf) || exit
	# fd --base-directory ~ --type directory | xargs cd || exit
}

main "@"

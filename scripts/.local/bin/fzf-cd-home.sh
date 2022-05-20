#!/bin/bash

main() {
	cd $(fd --base-directory ~ --type directory | fzf) || exit
}

main "@"

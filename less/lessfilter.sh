#! /usr/bin/env sh
mime=$(file -bL --mime-type "$1")
category=${mime%%/*}
kind=${mime##*/}
if [ -d "$1" ]; then
	lsd -h --color=always --blocks=name,size,date,links "$1"
elif [ "$category" = image ]; then
	chafa "$1"
	exiftool "$1"
elif [ "$kind" = vnd.openxmlformats-officedocument.spreadsheetml.sheet ] ||
	[ "$kind" = vnd.ms-excel ]; then
	bat -ltsv --color=always
elif [ "$category" = text ]; then
	bat --color=always "$1"
else
	lesspipe.sh "$1" | bat --color=always
fi

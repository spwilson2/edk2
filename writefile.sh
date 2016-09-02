#!/bin/bash

# A POSIX variable
OPTIND=1         # Reset in case getopts has been used previously in the shell.

help () {
	echo "$0 -i <in_file> -o <out_dev> [-v verbose]"
}

# Initialize our own variables:
in_file=""
out_dev=""
verbose=""

if [[ $EUID != 0 ]]; then 
	echo "Must be root, try using: \n\nsudo $0 $@"
	exit

fi

while getopts "vi:o:" opt; do
    case "$opt" in
    v)  verbose="-i"
        ;;
	i)  in_file=$OPTARG
        ;;
	o)	out_dev=$OPTARG
		;;
    esac
done

shift $((OPTIND-1))

if [ -z "$in_file" ] || [ -z "$out_dev" ]; then
	help
fi

if [ ! -z "$verbose" ]; then
	set -x
fi

TEMP="$(mktemp -d)"
mount "$out_dev" "$TEMP"
cp $verbose "$in_file" "$TEMP" 
umount "$TEMP"

#! /bin/bash
#
# n - Simple note taking tool by Chang
# Feel free to change anything.

BIN_PATH=/usr/local/bin

NOTES=~/.n/notes
TIME=$(printf "[%(%Y/%m/%d %r)T]")

function install {
    # Add n to bing path if it's not there
    [ ! -f "$BIN_PATH/n" ] &&
    echo "Adding n to $BIN_PATH..." &&
    sudo cp $0 $BIN_PATH/n &&
    sudo chmod +x $BIN_PATH/n

    # Create $NOTES file if it doesn't exist
    [ ! -f "$NOTES" ] &&
    echo "Creating $NOTES..." &&
    mkdir -p $(dirname $NOTES) &&
    touch $NOTES

    [ -f "$BIN_PATH/n" ] &&
    [ -f "$NOTES" ] &&
    echo "Install complete." &&
    echo "Try adding a note by typing 'n'   in the command line." &&
    echo "                         or 'n h' for more instructions." &&
    exit

    echo "Install failed." &&
    echo "You're on your own because Chang clearly was in a rush to share this and didn't test this properly." &&
    exit
}

# Install n and create notes file if notes file or n doesn't exist
[ ! -f "$NOTES" -o ! -f "$BIN_PATH/n" ] &&
echo "$NOTES file or $BIN_PATH/n doesn't exist, so I assume n isn't installed. So I'm going to try to install it now." &&
install

case "$1" in
    p) # p for print
        less +G $NOTES
        ;;

    g) # g for grep
        if [ -z "$2" ]; then
            cat $NOTES | grep $(date +%Y/%m/%d) | less
        else
            cat $NOTES | grep "$2" | less
        fi
        ;;

    c) # c for clear
        rm $NOTES
        touch $NOTES
        ;;

    e) # e for edit
        vim + $NOTES
        ;;

    t) # t for tail
        if [ -z $2 ]; then
            tail -1 $NOTES
        else
            tail -$2 $NOTES
        fi
        ;;

    h) # h for help
cat << EOF
Usage:
n                   - insert a new note
n p                 - prints all notes
n g [SEARCH_OPTION] - list today's notes or search for notes using [SEARCH_OPTION]
n c                 - WARNING!!! removes all notes
n e                 - edit notes file (just in case you need it.)
n t [NUMBER]        - print last note or last [NUMBER] notes
n h                 - prints this help message
n uninstall         - uninstall n. I don't know why anyone would want to do this but oh well...
EOF
        ;;

    uninstall)
        echo "Removing $BIN_PATH/n..."
        sudo rm $BIN_PATH/n &&
        echo "Uninstalled! Your notes are still in $NOTES."
        ;;

    *) # default is to read in a note
        read note
        printf "$TIME %s\n" "$note" >> $NOTES
        ;;
esac

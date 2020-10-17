#! /bin/bash
#
# n - Simple note taking tool by Chang
# Feel free to change anything.

BIN_PATH=/usr/local/bin

NOTES=~/.n/notes
CURRENT_TASK=~/.n/.current_task
TIME=$(printf "[%(%Y/%m/%d %r)T]")

function install {
    # Add n to bing path if it's not there
    [ ! -f "$BIN_PATH/n" ] &&
    echo "Adding n to $BIN_PATH..." &&
    sudo cp $0 $BIN_PATH/n &&
    sudo chmod +x $BIN_PATH/n

    # Add n to bing path if it's not there
    [ ! -f "$BIN_PATH/n_timesheet" ] &&
    echo "Adding n_timesheet to $BIN_PATH..." &&
    sudo cp $(dirname $0)/n_timesheet $BIN_PATH/n_timesheet &&
    sudo chmod +x $BIN_PATH/n_timesheet

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
    return

    echo "Install failed." &&
    echo "You're on your own because Chang clearly was in a rush to share this and didn't test this properly." &&
    return
}

# Install n and create notes file if notes file or n doesn't exist
[ ! -f "$NOTES" -o ! -f "$BIN_PATH/n" -o ! -f "$BIN_PATH/n_timesheet" ] &&
echo "$NOTES file or $BIN_PATH/n or $BIN_PATH/n_timesheet doesn't exist, so I assume n isn't installed. So I'm going to try to install it now." &&
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
        BACKUP_FILE_PATH="$NOTES-$(date +%F-%H-%M-%S)"
        echo -n "To confirm deletion of notes, enter \"$NOTES\": "
        read input
        if [ $input == $NOTES ]
        then
            echo "Backing up $NOTES to $BACKUP_FILE_PATH..." &&
            mv $NOTES $BACKUP_FILE_PATH &&
            touch $NOTES &&
            echo "$NOTES has been cleared." && exit

            echo "Failed to backup $NOTES. Notes have not been cleared."
        else
            echo "Not clearing $NOTES, input didn't match \"$NOTES\" exactly."
        fi
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
n update            - update n in $BIN_PATH
n start             - insert a new note for start of day
n stop              - insert a new note for end of day
n do                - set current task
n done              - finish current task
n s                 - summarise today
EOF
        ;;

    uninstall)
        echo "Removing $BIN_PATH/n..."
        sudo rm $BIN_PATH/n &&
        echo "Uninstalled! Your notes are still in $NOTES."
        ;;

    update)
        echo "Updating $BIN_PATH/n..."

        sudo cp $0 $BIN_PATH/n &&
        sudo chmod +x $BIN_PATH/n &&
        [ -f "$BIN_PATH/n" ] && echo "Update complete."

        echo "Updating $BIN_PATH/n_timesheet..."

        sudo cp $(dirname $0)/n_timesheet $BIN_PATH/n_timesheet &&
        sudo chmod +x $BIN_PATH/n_timesheet &&
        [ -f "$BIN_PATH/n_timesheet" ] && echo "Update complete." && exit

        echo "Update failed. Run with updated n.sh script instead." && exit
        ;;

    start)
        read note
        printf "$TIME NSTART %s\n" "$note" >> $NOTES
        ;;

    stop)
        read note
        printf "$TIME NSTOP %s\n" "$note" >> $NOTES
        printf "" > $CURRENT_TASK
        ;;

    do)
        read task
        printf "$TIME NDO %s\n" "$task" >> $NOTES
        printf "$task" > $CURRENT_TASK
        ;;

    done)
        if [ -f $CURRENT_TASK ]
        then
            current_task=$(cat $CURRENT_TASK)
            if [ -z "$current_task" ]
            then
                echo "There's no current task." && exit
            fi
        fi
        read note
        printf "$TIME NDONE %s\n" "$note" >> $NOTES
        printf "" > $CURRENT_TASK
        ;;

    s)
        n_timesheet <(n g)
        ;;

    *) # default is to read in a note
        read note
        printf "$TIME %s\n" "$note" >> $NOTES
        ;;
esac

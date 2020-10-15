# Display current task in prompt

```
n_current_task() {
    if [ -f ~/.n/.current_task ]
    then
        current_task=$(cat ~/.n/.current_task)
        if [ -n "$current_task" ]
        then
            echo " ($current_task) "
        fi
    fi
}

# Example
export PS1="[\u@\h \W]\$(n_current_task)\$ "
```

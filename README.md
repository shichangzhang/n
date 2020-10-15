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

# Usage
```
$ n start
start of day :)
$ n do
clear out emails
$ n
checking jira
$ n do
JOB-4993
$ n stop
stop for today :)
$ n s
2020/10/15
JOB-4993 0h 0m
    NDO JOB-4993
    NSTOP stop for today :)
clear out emails 0h 1m
    NDO clear out emails
    checking jira
unspecified 0h 0m
    NSTART start of day :)
0h 1m
Total 0h 1m
```

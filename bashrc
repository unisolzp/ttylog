shopt -s histappend

CLIENT_ID=$(echo $PPID $SSH_CLIENT | awk '{print $1"-"$2":"$3}')
DATETIME=$(TZ="Europe/Kiev" date "+%d/%m/%Y %H:%M:%S")
IP=$(echo $SSH_CONNECTION | awk '{print $1}')
PORT=$(echo $SSH_CONNECTION | awk '{print $2}')
XDG=$(echo $XDG_SESSION_ID)
TTY_ID=$(tty | cut -d "/" -f4-)
SESSION_ID=$(date +%s)

export CLIENT_ID
export DATETIME
export IP
export PORT
export XDG
export TTY_ID
export SESSION_ID


HISTSIZE=-1
HISTFILESIZE=-1
HISTTIMEFORMAT="%d/%m/%y %T "
HISTCONTROL=ignoreboth:ignoredups:ignorespace:erasedups


OLD_PWD=$(echo $OLDPWD)

if [ -z "$OLDPWD" ]
then
    OLDPWD=$(echo $PWD)
fi
export PROMPT_COMMAND='echo $(echo $CLIENT_ID) $(echo $OLDPWD) $(echo $PWD) $(echo $DATETIME) $(history 1) >> /mnt/sessions/HOSTNAME.history'

[[ -v IN_SCRIPT ]] || { export IN_SCRIPT=1 ; (curl -X POST -H 'Content-type: application/json' --data '{"text":"```HOSTNAME:\n'$IP' user has joined the server.\nView session: view-session '$SESSION_ID'```"}' https://hooks.slack.com/services/KEY1/KEY2/KEY3 >&2) >/dev/null 2>&1; echo $SESSION_ID >> /mnt/sessions/HOSTNAME/xdg/$XDG ; echo $TTY_ID >> /mnt/sessions/HOSTNAME/sessions/$SESSION_ID ; ttyrec -f /mnt/sessions/HOSTNAME/records/$SESSION_ID ; exit $?; }
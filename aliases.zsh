# SHELL

alias "$"=''  # Useful for ignoring the `$` when copy-pasting certain commands from the web, does not work on bash

alias al='nano ~/.oh-my-zsh/custom/aliases.zsh'  # Edit the aliases file
alias rc='nano ~/.zshrc'  # Edit the shell config file
alias refresh='source ~/.zshrc'  # Refresh the shell after editing one of the above files
alias p10krc='nano ~/.p10k.zsh'  # Edit the Powerlevel10k config file

HISTORY_PUSH=$(cat <<-EOF
krishnan
y
y
y
EOF
)

alias history-push='echo "$HISTORY_PUSH" | history_sync_push'  # history_sync_push is the old `zhps` alias
alias zhps='history-push'

# UTILITY

alias commands='nano ~/Downloads/UbuntuApps/COMMANDS.txt'  # To keep track of installed apt packages

# Shortcut to `cd` then `ls`
cdls() {
    local dir="$1"
    local dir="${dir:=$HOME}"
    if [[ -d "$dir" ]]; then
        cd "$dir" >/dev/null; ls
    else
        echo cdls: no such directory: "$dir"
    fi
}

alias indent="sed 's/^/  /'"

git-all() {
    base_dir="/home/krishnan"
    regex="$base_dir/[^.].*/\.git"

    found=$(find "$base_dir" -regex "$regex" -type d)
    disp=""

    while test "$#" -gt 0
    do
        case "$1" in
            -h | --help)
                echo "usage: git-all [options]..."
                echo Fetch all known git repositories recursively
                echo
                echo "  -a, --all       Include git repositories in hidden directories within the base directory"
                echo "  -v, --verbose   List all git repositories being fetched"
                return
                ;;
            -a | --all)
                echo Note: Checking hidden directories
                echo
                regex="$base_dir/.*/\.git"
                ;;
            -v | --verbose)
                disp="true"
                ;;
            --*)
                echo Bad Option "$1"
                ;;
        esac
        shift
    done

    found=$(find "$base_dir" -regex "$regex" -type d)

    if [ "$disp" = "true" ]
    then
        echo Fetching:
        echo "$found" | indent
        echo
    fi

    echo "$found" |
    while read -r d
    do
        echo "$d"
        git --git-dir="$d" --work-tree="$d"/.. fetch --all --recurse-submodules --quiet
    done | tqdm --total $(echo "$found" | wc -l) >> /dev/null
}

alias g-size='git gc && git count-objects -vH | grep size'

gc-past() {
    export GIT_AUTHOR_DATE="$1"
    export GIT_COMMITTER_DATE="$1"
    shift
    git commit "$@"
    unset GIT_AUTHOR_DATE
    unset GIT_COMMITTER_DATE
}

alias dc='docker compose'  # Docker Compose
alias pmpy='python manage.py'  # Django manage.py

alias autoclicker='xdotool click --repeat 1000 --delay 10 1'  # Clicks 1000 times with a delay of 10ms between each click

alias copy='xclip -selection c'  # Clipboard

alias reset-textedit='rm ~/.local/share/org.gnome.TextEditor/session.gvariant'  # When GNOME Text Editor is stuck on binary files

alias discord-update='curl -L https://discord.com/api/download/stable\?platform\=linux\&format\=deb --output ~/Downloads/discord.deb && sudo apt install ~/Downloads/discord.deb && rm ~/Downloads/discord.deb'
alias vencord='echo Y | sh -c "$(curl -sS https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh)"'

doc-img() {
    URL=$(xclip -selection c -o -t text/html | xmllint --html -xpath "string(//img/@src)" -)
    echo "$URL"
    curl "$URL" -o - | xclip -selection c -target image/png
}

spotify-download() {
    cd ~/Music/Spotify
    source venv/bin/activate

    ulimit -n 16384  # Fixes ERROR: [requests] Unexpected error: OSError: [Errno 24] Too many open files

    lists=( "songs" "classical" "jams" "youtubers" "movies" "christmas" "theme-songs" )
    if [[ "$1" != "" ]]
    then
        lists=( "$@" )
    fi

    echo "Downloading ${lists[*]}"

    for list in "${lists[@]}"
    do
        spotdl --log-level DEBUG --threads 16 --user-auth --dont-filter-results --output "${list}/{list-position} - {artist} - {album} - {title}" sync "${list}.spotdl"
    done

    ulimit -n 1024

    deactivate
    cd - > /dev/null
}

alias s='cd ~/School'  # Shortcut to School directory
alias sm='cd ~/School/multi'
alias sml='cd ~/School/ML'
alias sq='cd ~/School/quantum'
alias t='cd ~/Tech'  # Shortcut to Tech directory
alias th='cd ~/Tech/Hobby'

alias piserver='ssh -J serveo.net krishnan@krishnans2006'  # SSH into my Raspberry Pi server, proxied through serveo.net
alias piserver-local='ssh krishnan@piserver.local'

alias gcloudvm='gcloud compute ssh krishnans2006@personal --project personal-vmserver --zone us-central1-f --ssh-key-file ~/.ssh/id_ed25519'

# TJUAV

alias tjuav='cd ~/Tech/TJUAV/'  # Shortcut to TJUAV directory

# Run an ArduPilot SITL simulation
tjuav-sim() {
    if [ "$1" != "" ]
    then
        ~/Tech/TJUAV/ardupilot/Tools/autotest/sim_vehicle.py --no-mavproxy -v ArduPlane --add-param-file ~/Tech/TJUAV/ardupilot/Tools/autotest/default_params/avalon.parm -L "$1"
    else
        ~/Tech/TJUAV/ardupilot/Tools/autotest/sim_vehicle.py --no-mavproxy -v ArduPlane --add-param-file ~/Tech/TJUAV/ardupilot/Tools/autotest/default_params/avalon.parm -L FARM_RC
    fi
}

# Start the TJUAV backend server
tjuav-server() {
    cd ~/Tech/TJUAV/GroundStation/server/
    source ~/Tech/TJUAV/GroundStation/server/venv/bin/activate
    python ~/Tech/TJUAV/GroundStation/server/app.py
}

alias tjuav-client='npm start --prefix ~/Tech/TJUAV/GroundStation/client'  # Start the TJUAV frontend client
alias mission-planner='mono ~/Tech/TJUAV/MissionPlanner/MissionPlanner.exe'  # Start Mission Planner

# tjCSL

alias tjcsl='cd ~/Tech/tjCSL/'  # Shortcut to tjCSL directory

# Decrypt a passcard and print it to the terminal (primarily for piping to other commands)
raw-passcard() {
    gpg -d ~/Tech/tjCSL/keybase-passcard/passwords/"$1".txt.gpg 2>/dev/null
}

# Decrypt a passcard, copy it, and optionally print it to the terminal (primarily for shell usage)
p() {
    password=$(gpg -d ~/Tech/tjCSL/keybase-passcard/passwords/"$1".txt.gpg 2>/dev/null)
    echo "$password" | copy
    if [[ "$2" != "" ]]
    then
        echo "$password"
    fi
}

# List all passcards that include some text
p-grep() {
    ls ~/Tech/tjCSL/keybase-passcard/passwords | grep "$1"
}

# Fetch passcard updates
alias p-pull='git -C ~/Tech/tjCSL/keybase-passcard pull'

# Get a kerberos ticket, using the saved kerberos password
kb() {
    pass tjcsl/kerberos | kinit 2024kshankar/root
    echo kinit as 2024kshankar/root complete!
}

# SSH into the tjCSL's remote access server, using the saved kerberos password
tjras() {
    export SSHPASS=$(pass tjcsl/kerberos)
    sshpass -e ssh "$@" 2024kshankar@ras2.tjhsst.edu
}

# SSH into any *.csl.tjhsst.edu server intelligently (using passcards, kerberos, proxying, etc.)
tjssh() {
    CSL_USERNAME="2024kshankar"
    PASSCARD_DIR="/home/krishnan/Tech/tjCSL/keybase-passcard"

    # Set INPUT as server
    INPUT="$1"

    # Set HOST as server.csl.tjhsst.edu
    if [[ "$INPUT" == *"@"* ]]
    then
        HOST=$(echo "$INPUT" | cut -d"@" -f2)
    else
        HOST="$INPUT"
    fi

    # Set SERVER as user@server.csl.tjhsst.edu
    if [[ "$INPUT" != *"."* ]]
    then
        SERVER="$INPUT".csl.tjhsst.edu
        HOST="$HOST".csl.tjhsst.edu
    fi

    if ping -c 1 "$HOST" &> /dev/null
    then
        if [ -e "$PASSCARD_DIR"/passwords/"$INPUT".txt.gpg ]
        then
            export SSHPASS=$(gpg -d "$PASSCARD_DIR"/passwords/"$INPUT".txt.gpg 2>/dev/null)
            if [[ "$SSHPASS" != "" ]]
            then
                echo Found passcard! SSHing...
                sshpass -e ssh "${@:2}" "$SERVER"
            else
                echo No access to passcard! SSHing...
                ssh "${@:2}" "$SERVER"
            fi
        else
            echo -n "No passcard! Enter alternate passcard (leave blank to continue): "
            read PASSCARD_NAME
            if [[ "$PASSCARD_NAME" != "" ]]
            then
                if [ -e "$PASSCARD_DIR"/passwords/"$PASSCARD_NAME".txt.gpg ]
                then
                    export SSHPASS=$(gpg -d "$PASSCARD_DIR"/passwords/"$PASSCARD_NAME".txt.gpg 2>/dev/null)
                    if [[ "$SSHPASS" != "" ]]
                    then
                        echo Found passcard! SSHing...
                        sshpass -e ssh "${@:2}" "$SERVER"
                    else
                        echo No access to passcard! SSHing...
                        ssh "${@:2}" "$SERVER"
                    fi
                else
                    echo Passcard not found! SSHing...
                    ssh "${@:2}" "$SERVER"
                fi
            else
                echo SSHing...
                ssh "${@:2}" "$SERVER"
            fi
        fi
    else
        echo Unpingable! Using ras host-chaining...
        ssh "${@:2}" -J "$CSL_USERNAME"@ras2.tjhsst.edu "$SERVER"
    fi
}

# Run a tjCSL ansible playbook intelligently (using ssh passcards, vault password files, etc.)
tjans() {
    ANSIBLE_DIR="/home/krishnan/Tech/tjCSL/ansible"
    TEMP_FILE="/home/krishnan/.ansible-playbook-runner.sh"

    NUM_FORKS="100"
    CONNECT_USER="root"
    PLAY="$1"
    SSH_PASS_NAME=""
    VAULT_PASS_NAME="ansible"

    if [[ "$PLAY" == "" ]]
    then
        echo "usage: tjans (playbook) [options]..."
        return
    fi

    if [[ "$PLAY" != "-h" ]] && [[ "$PLAY" != "--help" ]]
    then
        shift
    fi

    other_args=()

    while [[ $# -gt 0 ]]
    do
        case $1 in
            -h | --help)
                echo "usage: tjans (playbook) [options]..."
                echo Run a tjCSL ansible play intelligently
                echo
                echo "  -p, --pass PASS                 Specify the name of the passcard file to use when connecting"
                echo "  -v, --vault, --vault-pass PASS  Specify the name of the vault passcard file (excluding \"_vault\") to use"
                echo "  -u, --user USERNAME             Specify the username to connect with"
                echo "  -f, --forks N                   Set the number of concurrent processes to use at once"
                echo
                echo "  ...any other valid ansible-playbook options are also permitted and will be passed to ansible"
                return
                ;;
            -p | --pass)
                SSH_PASS_NAME="$2"
                shift
                shift
                ;;
            -v | --vault | --vault-pass)
                VAULT_PASS_NAME="$2"
                shift
                shift
                ;;
            -u | --user)
                CONNECT_USER="$2"
                shift
                shift
                ;;
            -f | --forks)
                NUM_FORKS="$2"
                shift
                shift
                ;;
            -* | --*)
                other_args+=("$1")
                shift
                ;;
            *)
                other_args+=("$1")
                shift
                ;;
        esac
    done

    set -- "${other_args[@]}"

    export SSHPASS=$(raw-passcard "$SSH_PASS_NAME")
    echo "$SSHPASS"

    export VAULTPASS=$(raw-passcard "$VAULT_PASS_NAME"_vault)
    echo "#!/bin/bash" > "$TEMP_FILE"
    echo 'echo $VAULTPASS' >> "$TEMP_FILE"
    chmod +x "$TEMP_FILE"

    echo RUNNING COMMAND: "\n"    ansible-playbook "$ANSIBLE_DIR"/"$PLAY".yml -i "$ANSIBLE_DIR"/hosts -f "$NUM_FORKS" -u "$CONNECT_USER" "$@"
    git -C "$ANSIBLE_DIR" pull
    ansible-playbook "$ANSIBLE_DIR"/"$PLAY".yml -i "$ANSIBLE_DIR"/hosts --ask-pass --vault-password-file "$TEMP_FILE" -f "$NUM_FORKS" -u "$CONNECT_USER" "$@"
}

# Quickly deploy tin using the ansible playbook
deploy-tin() {
    tjans tin -p tin -v tin -t tin-django
}

# VPN controls
alias vpnon='sudo wg-quick up 2024kshankar'
alias vpnoff='sudo wg-quick down 2024kshankar'

# DEPRECATED: Connect to the tjCSL's openvpn server
alias tjovpn='sudo openvpn ~/Tech/tjCSL/2024kshankar.ovpn'

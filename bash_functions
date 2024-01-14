# vi:syntax=sh

function psgrep() {
    ps aux | grep -i --color=always "$1" | grep -v "grep"
}

function md5() {
    echo -n "$1" | md5sum | awk '{print $1}'
}

function t() {
    thunar "$1" &
}

function hash-compare() {
    if [ "$#" -ne 2 ]; then
        echo "Please supply two files to diff"
    else
        sum1=$(md5sum $1)
        sum2=$(md5sum $2)
        hash1="${sum1/$1/}"
        hash2="${sum2/$2/}"
        if [ "$hash1" == "$hash2" ]; then
            echo -e "\e[92midentical\e[39m"
        else
            echo -e "\e[91mdifferent\e[39m"
        fi
    fi
}

function c() {
    cd "$1" && ls -lh
}

function ed() {
    geany "$1" &
}

# Update system time from ntp server and set hardware clock
function time-sync() {
    sudo ntpdate ptbtime1.ptb.de ptbtime2.ptb.de ptbtime3.ptb.de 0.de.pool.ntp.org
    sudo hwclock --systohc
}

function transfer() {
    if [ $# -eq 0 ]; then
        echo -e "No arguments specified. Usage:\ntransfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"
        return 1
    fi
    tmpfile=$(mktemp -t transferXXX)
    file=$1
    if tty -s; then
        basefile=$(basename "$file" | sed -e 's/[^a-zA-Z0-9._-]/-/g')
        if [ ! -e $file ]; then
            echo "File $file doesn't exists."
            return 1
        fi
        if [ -d $file ]; then
            zipfile=$(mktemp -t transferXXX.zip)
            cd $(dirname $file) && zip -r -q - $(basename $file) >>$zipfile
            curl --progress-bar --upload-file "$zipfile" "https://transfer.sh/$basefile.zip" >>$tmpfile
            rm -f $zipfile
        else
            curl --progress-bar --upload-file "$file" "https://transfer.sh/$basefile" >>$tmpfile
        fi
    else
        curl --progress-bar --upload-file "-" "https://transfer.sh/$file" >>$tmpfile
    fi
    cat $tmpfile
    rm -f $tmpfile
}

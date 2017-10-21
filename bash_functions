# vi:syntax=sh

function psgrep() {
    ps aux | grep -i --color=always "$1" | grep -v "grep"
}

function md5() {
    echo -n "$1" | md5sum | awk '{print $1}'
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
    # check arguments
    if [ $# -eq 0 ]; then 
        echo -e "No arguments specified. Usage:\ntransfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"
        return 1
    fi
 
    # get temporarily filename, output is written to this file show progress can be showed
    tmpfile=$( mktemp -t transferXXX )
    
    # upload stdin or file
    file=$1
 
    if tty -s; then 
        basefile=$(basename "$file" | sed -e 's/[^a-zA-Z0-9._-]/-/g') 
 
        if [ ! -e $file ]; then
            echo "File $file doesn't exists."
            return 1
        fi
        
        if [ -d $file ]; then
            # zip directory and transfer
            zipfile=$( mktemp -t transferXXX.zip )
            cd $(dirname $file) && zip -r -q - $(basename $file) >> $zipfile
            curl --progress-bar --upload-file "$zipfile" "https://transfer.sh/$basefile.zip" >> $tmpfile
            rm -f $zipfile
        else
            # transfer file
            curl --progress-bar --upload-file "$file" "https://transfer.sh/$basefile" >> $tmpfile
        fi
    else 
        # transfer pipe
        curl --progress-bar --upload-file "-" "https://transfer.sh/$file" >> $tmpfile
    fi
   
    # cat output link
    cat $tmpfile
 
    # cleanup
    rm -f $tmpfile
}

function burn-folder {
    if [ $# -lt 1 ]; then
        echo Usage: ${FUNCNAME[0]} [DIRECTORY]
        return 1
    fi

    temp_dir="/tmp"
    device="/dev/sr0"
    volume_name="Volume"

    mkdir -p "$temp_dir"

    echo -e "\nCreating temporary image of $1\n"

    mkisofs -V $volume_name -J -r -o $temp_dir/isoimage.iso $1

    echo -e "\nBurning to disc.\n"

    wodim -v dev=$device $temp_dir/isoimage.iso

    if [ "$?" == "1" ] ; then
        echo -e -n "\nBurning failed. "
        return 1
    else
        echo -e -n "\nBurning finished. "
        eject $device
    fi

    while ( [ "$clean" != "y" ] && [ "$clean" != "n" ] ); do
        echo "Delete temporary image? [y,n]"
        read -s -n 1 clean
    done

    if [ $clean == "y" ]; then
        rm $temp_dir/isoimage.iso -f
        echo -e "\nImage deleted."
    else
        echo -e "\nImage was saved in $temp_dir"
    fi

    echo -e "\nBye!"
}

function burn-mp3 {
    if [ $# -lt 1 ]; then
        echo Burn a gapless Audio CD from MP3 source folder.
        echo Usage: ${FUNCNAME[0]} [DIRECTORY]
        return 1
    fi

    source_dir=$1
    temp_dir="/tmp/mp3burn"
    device="/dev/sr0"

    if [ -e $temp_dir ]; then
	rm "$temp_dir" -r	
    fi

    mkdir -p "$temp_dir"
    cd "$source_dir"

    for file in *.[mM][pP]3 ; do
	echo "Converting '$file' into wav format."
	lame -S --decode "$file" "$temp_dir/$file.wav"
	if [ "$?" == "1" ] ; then
	    echo -e "Decoding error!\n"
	    return 1
	fi
    done

    echo -e "\nCreating gapless toc."
    cd "$temp_dir"
    {
	echo "CD_DA"
	for file in *.wav ; do
	    echo "TRACK AUDIO"
	    echo "FILE \"$file\" 0"
	done
    } > toc

    echo -e "\nEverything is ready. Press any key to start burning (or <ctrl-c> to cancel)."
    read -s -n 1
    echo

    while true; do
	cdrdao write -n --device $device toc
	if [ "$?" == "1" ] ; then
	    echo -e -n "\nBurning failed. "
	    echo "retry? [y,n]"
	    read -s -n 1 retry
	    if [ $retry != "y" ]; then
		break
	    fi
	else
	    echo -e -n "\nBurning successful."
	    break
	fi
    done
}

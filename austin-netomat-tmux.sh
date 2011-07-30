# Seriously, there MUST be a way of chanding directories in a tmux window.
echo "#! /usr/bin/env bash
cd /Volumes/vodka/home/pavel/projects/mobilityserver
/usr/bin/env bash
" > /tmp/cd_ms
echo "#! /usr/bin/env bash
cd /Volumes/vodka/home/pavel/projects/csmobility
/usr/bin/env bash
" > /tmp/cd_msa

# Mount vodka.
if [ -d /Volumes/vodka ]; then
    umount /Volumes/vodka
fi
if [ -e /Volumes/vodka ]; then 
	rm /Volumes/vodka
fi

mkdir -p /Volumes/vodka

if ! sshfs vodka:/ /Volumes/vodka; then
    echo "Unable to mount vodka."
    exit
else
    # Launch tmux
    if ! tmux has-session -t netomat 1>/dev/null 2>/dev/null; then
        # Create new session with a window that starts lampp
        tmux new-session -d -s netomat -n 'vodka' "/usr/bin/env bash /tmp/cd_msa"
        tmux split-window -v -p 50 "/usr/bin/env bash /tmp/cd_ms"
    fi

    # Attach
    tmux attach -t netomat

fi





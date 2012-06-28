#! /bin/bash -e

# cloudadmins v. 0.1
# Copyright (c) 2012 Jamieson Becker <jamieson@jamiesonbecker.com>
# Released under the GPL version 2 or later

green="\033[32m"
red="\033[31m"
blue="\033[34m"

# Spawn no more than host_processes * user_processes at a time.
# Generally, scale is bound by I/O (specifically,
# network) in most situations
# 16^2 = 256
host_processes=16
user_processes=16

function check_for_root {
    # check to make sure the user is NOT root
    if [[ $EUID == 0 ]]; then
        echo Sorry, you ARE root. This script needs access to your SSH agent and will use sudo where needed. >&2
        exit 1
    fi
}

function wipe_errors {
    set +e
    rm -Rf errors/ 2>/dev/null
    mkdir errors/ 2>/dev/null
    set -e
}

function adduser {
    # echo 'egad! in adduser'; exit 1
    if [ "x$sHostname" == "x" ]; then
        echo "Please set hostname"
        exit 1
    fi
    if [ "x$sUsername" == "x" ]; then
        echo "Please set username"
        exit 1
    fi

    # this might be adjusted depending on linux distribution
    # (for instance, consider adding the user to the wheel(rh) or
    # admin(deb) group, so that userdel would also remove
    # the access instead of leaving it hanging out there)
    sudocmd='echo "$sUsername     ALL=NOPASSWD: ALL" >> /etc/sudoers'

    # "inception" programming ;)
    set +e
    output=$(cat << EOF | ssh $sHostname "bash -e" 2>&1
cat << SUDOEOF | sudo -ES "sh"
#! /bin/sh
# abort completely if user already exists
set -e
useradd -m $sUsername
mkdir /home/$sUsername/.ssh/
cat << KEYEOF > /home/$sUsername/.ssh/authorized_keys
# added by cloudadmins $(date -I)
$(cat users/$sUsername/id_rsa.pub)
# end cloudadmins $(date -I)
KEYEOF
chown -R $sUsername:$sUsername /home/$sUsername/
$sudocmd
SUDOEOF
EOF
)
    err=$?
    mkdir -p errors/$MYCMD/$sUsername/ 2>/dev/null
    if [ $err != 0 ]; then
        cat << EOF > errors/$MYCMD/$sUsername/$sHostname
$output
EOF
        echo "error; please see ./errors/$MYCMD/$sUsername/$sHostname"
    fi
    sleep 1; rmdir -p errors/$MYCMD/$sUsername/ 2>/dev/null
}

function demo {
    echo "hello $sUsername, Im going to do something on $sHostname in $sHostgroup (sleeping one second)"
    sleep 1
}

function host_cmd {
    export sHostname="$*"
    $MYCMD
}

function walk_hosts {
    export sHostgroup="$*"
    echo "Walking Hosts for $sHostgroup.."
    cat users/$sUsername/hostgroups/$sHostgroup |
        xargs --no-run-if-empty -L1 --max-procs=$user_processes $0 host_cmd
}

function walk_hostgroups {
    export sUsername="$*"
    echo "Walking Hostgroups for $sUsername.."
    ls -1 users/$sUsername/hostgroups/ |
        xargs --no-run-if-empty -L1 --max-procs=$user_processes $0 walk_hosts
}

function walk_users {
    echo "Walking Users.."
    ls -1 users/ |
        xargs --no-run-if-empty -L1 --max-procs=$user_processes $0 walk_hostgroups
}

function setup {

    echo "Installing in $(pwd)"

    # make demo user 1

    mkdir users/user1/hostgroups/ -p
    mkdir -p hostgroups/
    echo "hostX-a" > hostgroups/hostgroupX
    echo "hostX-b" >> hostgroups/hostgroupX
    echo "hostX-c" >> hostgroups/hostgroupX
    echo "hostX-d" >> hostgroups/hostgroupX
    echo "hostX-e" >> hostgroups/hostgroupX
    echo "hostX-f" >> hostgroups/hostgroupX
    echo "hostX-g" >> hostgroups/hostgroupX
    echo "hostY-a" > hostgroups/hostgroupY
    echo "hostY-b" >> hostgroups/hostgroupY
    echo "hostY-c" >> hostgroups/hostgroupY
    echo "hostY-d" >> hostgroups/hostgroupY
    echo "hostY-e" >> hostgroups/hostgroupY
    echo "hostY-f" >> hostgroups/hostgroupY
    echo "hostY-g" >> hostgroups/hostgroupY
    echo 'ssh-rsa AAA...something user1@demo' > users/user1/id_rsa.pub
    ln -s ../../../hostgroups/hostgroupX users/user1/hostgroups/
    ln -s ../../../hostgroups/hostgroupY users/user1/hostgroups/

    # make demo user 2

    mkdir users/user2/hostgroups/ -p
    mkdir -p hostgroups/
    echo 'ssh-rsa AAA...something user2@demo' > users/user2/id_rsa.pub

    ln -s ../../../hostgroups/hostgroupX users/user2/hostgroups/

    echo "Please review README."
    echo "Notice in the following demo that the total script only takes"
    echo "about one second to run even though EACH call sleeps 1 second."

    cat << 'EOF' > README.md
cloudadmins
-----------

INTRO
=====

Create SSH administrative accounts across your entire cloud for groups of
administrators.

This is a super-simple system to distribute your group of admins to
potentially thousands of boxen.

It also adds each user to that server's *sudoers* (by default - you can just
comment that line out).

It's a very simple script - read through it and it will probably be very simple
to customize.

There's a built in demo -- running the cloudadmins script will automatically
create this README, create some sample directories and run a demonstration.


1.  Create a hostgroup in hostgroups/ with a single hostname on each line.


2.  Create a user directory with the directory's name
    as the user's username in the users/ directory.


3.  Copy the user's public key as users/username/id_rsa.pub


4.  Symlink the previously-created hostgroup into that user's directory.


KNOWN BUGS
==========


1. No option to remove a user. (userdel -r username)


AUTHOR(S)
=========

*   [Twitter] (http://twitter.com/JamiesonBecker)

*   [Homepage] (http://jamiesonbecker.com)


LICENSE
=======

Copyright (c) 2012 Jamieson Becker <jamieson@jamiesonbecker.com>

Free Software released under the GPL version 2 or later (at your option)

EOF
}

# main

check_for_root
wipe_errors 

export cloudadmins_cmd=$1
if [ "x$cloudadmins_cmd" == "x" ]; then
    export cloudadmins_cmd="walk_users"
fi

if [ ! -d users/ ]; then
    export MYCMD=demo
    setup
else
    if [ "x$MYCMD" == "x" ]; then
        export MYCMD=adduser
    fi
fi

$cloudadmins_cmd $2

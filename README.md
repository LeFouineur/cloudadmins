cloudadmins
===========

Intro
-----

Create SSH administrative accounts across your entire cloud for groups of
administrators. (Note: there is a limit of around 250-500 servers before
forking delays become significant. Try [userify](http://userify.com) for an enterprise solution.)


This is a super-simple system to distribute your group of admins to
hundreds of cloud instances. (A similar system has been used in production to
approximately 500 real servers across distributed networks.)

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


Important Notes
---------------

This script requires bash. Please do not do fancy shell script shortcuts like wget -O- $url | bash as they'll mess up xargs.
Just download it into /tmp somewhere, make executable, and run it properly and nobody will get hurt. :) Also, this of course
requires the use of SSH keys, and cannot work with SSH passwords.

Example installation/test:
    cd /tmp/; mkdir test; cd test; wget https://raw.github.com/jamiesonbecker/cloudadmins/master/cloudadmins.sh; chmod +x cloudadmins.sh; ./cloudadmins.sh

Expected output:

    Walking Users..
    Walking Hostgroups for user1..
    Walking Hostgroups for user2..
    Walking Hosts for hostgroupY..
    Walking Hosts for hostgroupX..
    Walking Hosts for hostgroupX..
    error; please see ./errors/adduser/user1/hostX-a
    error; please see ./errors/adduser/user2/hostX-a
    error; please see ./errors/adduser/user1/hostX-f
    error; please see ./errors/adduser/user1/hostX-b
    error; please see ./errors/adduser/user1/hostY-e
    error; please see ./errors/adduser/user1/hostY-g
    error; please see ./errors/adduser/user1/hostY-d
    error; please see ./errors/adduser/user1/hostY-a
    error; please see ./errors/adduser/user1/hostX-d
    error; please see ./errors/adduser/user1/hostX-e
    error; please see ./errors/adduser/user1/hostY-f
    error; please see ./errors/adduser/user2/hostX-g
    error; please see ./errors/adduser/user2/hostX-c
    error; please see ./errors/adduser/user1/hostX-c
    error; please see ./errors/adduser/user2/hostX-e
    error; please see ./errors/adduser/user2/hostX-b
    error; please see ./errors/adduser/user1/hostY-b
    error; please see ./errors/adduser/user1/hostX-g
    error; please see ./errors/adduser/user2/hostX-d
    error; please see ./errors/adduser/user1/hostY-c
    error; please see ./errors/adduser/user2/hostX-f

As we would expect, the fake hostnames give us an error, but they're just there as an example of how to run the example:

    $ cat ./errors/adduser/user1/hostX-a
    ssh: Could not resolve hostname hostX-a: Name or service not known





Known bugs/limitations
----------------------


1.  No option to remove or perform other operations on a user. (userdel -r username)

2.  "Push" model not very scalable (see userify.com for a far more powerful solution with an open agent.)



Author
------

*   Userify: [http://userify.com]

*   Twitter: [http://twitter.com/JamiesonBecker]

*   Author Homepage: [http://jamiesonbecker.com]


License
-------

Copyright (c) 2012 Jamieson Becker <jamieson@jamiesonbecker.com>

Free Software released under the GPL version 2 or later (at your option)


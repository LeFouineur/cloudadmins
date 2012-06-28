cloudadmins
===========

INTRO
-----

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
----------


1. No option to remove a user. (userdel -r username)


AUTHOR(S)
---------

[Twitter] (http://twitter.com/JamiesonBecker)
[Homepage] (http://jamiesonbecker.com)


LICENSE
-------

Copyright (c) 2012 Jamieson Becker <jamieson@jamiesonbecker.com>

Free Software Released Under The GPL version 2 Or Later (at your option)


cloudadmins
===========

Create SSH administrative accounts across your entire cloud for groups of
administrators.

This parallelizes connections to potentially thousands of servers
and creates a user account (if it doesn't already exist) on each
of those servers.

Running the cloudadmins script will automatically create this README,
create some sample directories and run a demonstration.

It ALSO adds each user to that server's sudoers.


1.  Create a hostgroup in hostgroups/ with a single hostname on each line.


2.  Create a user directory with the directory's name
    as the user's username in the users/ directory.


3.  Copy the user's public key as users/username/id_rsa.pub


4.  Symlink the previously-created hostgroup into that user's directory.


KNOWN BUGS


1. No option to remove a user. (userdel -r username)


LICENSE

Copyright (c) 2012 Jamieson Becker <jamieson@jamiesonbecker.com>
Free Software Released Under The GPL version 2 Or Later (at your option)


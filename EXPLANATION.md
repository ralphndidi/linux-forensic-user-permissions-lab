# Short Explanation

## What `grep` does
`grep` searches text line by line and prints every line that matches a pattern.
`grep "ERROR" file` finds a fixed word, and `grep -E "root|user01" file` uses
extended regular expressions so `|` means "or". It is the core tool for
filtering large logs in forensic work.

## What `chown` does
`chown` changes the owner (and optionally the group) of a file or directory,
e.g. `sudo chown root:root confidential.txt`. Only root (or sudo) can give a
file to another user. Together with `chmod`, it decides who may read, write or
execute the file.

## What `usermod` does
`usermod` modifies an existing user account. `usermod -aG sudo guest1`
**a**ppends guest1 to the **G**roup `sudo` without removing other group
memberships (omitting `-a` would replace them). It can also change the shell,
home directory, login name, or lock the account.

## What I learned from accessing `confidential.txt` after changing ownership
After `chmod 600` and `chown root:root`, the file is `-rw------- root root`.
`forensic01` is no longer the owner and is not in the group, so it falls into
"others", which has **no permissions** - both `cat` and editing return
**Permission denied**. Key lessons:

- Ownership decides which permission set (user/group/other) applies to you.
- Even though `forensic01` is in the `sudo` group, normal commands do not use
  that power; it must be requested explicitly with `sudo cat confidential.txt`.
- The *directory* is still owned by `forensic01`, so the user can still
  delete or rename the file (directory write permission governs that) even
  though they cannot read it.

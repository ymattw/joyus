---
layout: post
title: Reject large files in GitLab
tags: [git, gitlab]
---

Junior people tend to commit large binaries into git, unconsciously or not,
this is a headache to the git admins.  As a GitLab Admin, I recently ran into
this when I see our backup file is getting bigger and bigger from time being.
I got a list of repos contain large binaries (see how I did that in this post:
[Find large files in GitLab](/2016/05/find-large-files-in-gitlab.html)), but
it's now not that easy to remove them - I have to contact those people and
teach them rewrite history.

What I can do first is, before the backup size getting more bigger, I can write
a git hook to prevent more large binaries from being pushed to GitLab.  That
obviously has to be a [server side
hook](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks#Server-Side-Hooks).
The right hook to use is the `pre-receive` hook, which is the first script
to run when handling a push from a client.

According to the document, the script needs to take 3 arguments in following
order:

1. The SHA-1 that reference pointed to before the push
2. The SHA-1 the user is trying to push, and
3. The name of the reference (branch)

If the update script exits non-zero, that reference will be rejected, awesome!
I can get enough information of the objects being pushed according to the given
SHA-1's, for example, filename extension and file size.

Some thoughts to get started:

- Filtering by filename extension won't solve the problem because people can
  easily work around, what I want is filtering by file size
- I need to be careful - only filter those _**new objects**_, otherwise those
  people will complain right away because no new commits can be pushed
- Push of new branches should be allowed at this time due to the same reason

After some experimental I know some facts:

- I can use `git ls-tree` over the two SHA-1's and diff the output to tell
  _**new objects**_ and their sizes
- When the first SHA-1 is all zero (40 digits), it's a new branch, and `git
  ls-tree` on that will produce "not a tree object" error
- When the second SHA-1 is all zero (40 digits), it's a branch deletion
- I can `echo $'\e[31m'` ([ANSI escape
  code](https://en.wikipedia.org/wiki/ANSI_escape_code)) to highlight text in
  red and `echo $'\e[0m'` to reset
- GitLab expects my customized hook to be placed under
  **REPO/custom_hooks/pre-receive**

Finally I worked out a prototype in bash script and it worked fine, no more
file has size exceeds 10MB can be pushed in!

```bash
#!/bin/bash
#
# Put this under REPO/custom_hooks/ to limit single file size
#
# The diff output is like:
#
# --- /proc/self/fd/11    2016-05-05 18:07:12.528260482 +0800
# +++ /proc/self/fd/12    2016-05-05 18:07:12.528260482 +0800
# @@ -5 +5 @@
# +100644 blob a657cd3ed8a48e083458a1eeb579eeb69b049338    3246   UPGRADE.md
# +100755 blob d7f47aa098e6524dfd26afd572a07244969cb9d9    1944   bin/sync.sh

while read OLDSHA1 NEWSHA1 REF; do
    # Skip branch deletion
    [[ $NEWSHA1 != 0000000000000000000000000000000000000000 ]] || continue

    # Suppress the 'not a tree object' error when $OLDSHA1 is all zero
    OUT=$(diff -U0 \
            <(git ls-tree -rl $OLDSHA1 2>/dev/null) \
            <(git ls-tree -rl $NEWSHA1) \
        | awk '/^\+.* blob / && int($4) > 1024*1024*10 {printf("%10d %s\n", $4, $5)}')

    if [[ -n $OUT ]]; then
        echo $'\e[31m'
        echo "$REF: following file(s) has size exceeds 10M"
        echo
        echo "$OUT"
        echo
        echo "Please DO NOT ABUSE with binaries and large files."

        # Ignore branch push (and possible initial push)
        if [[ $OLDSHA1 == 0000000000000000000000000000000000000000 ]]; then
            echo
            echo "Above large files will soon be rejected, action ASAP!"
            echo $'\e[0m'
        else
            echo $'\e[0m'
            exit 1
        fi
    fi
done
```

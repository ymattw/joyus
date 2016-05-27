---
layout: post
title: Find large files in GitLab
tags: [git, gitlab]
---

I maintain a GitLab server for developers in our department, when reviewing
repositories stats in "Admin area", I see some of them are really large.
I guess some junior people committed large binaries into it, so how do I tell
where are they?

After read the git manual I found it's very easy to get with `git ls-tree`
command.  The two important options are:

    -r
        Recurse into sub-trees.

    -l, --long
        Show object size of blob (file) entries.

For example, run `git ls-tree -lr HEAD` on my github page repo of this site
shows me:

```
100644 blob d0174fbbb18973f0c7c93f26d5ed0f74455580a6      81    .gitignore
100644 blob 3187e8e7484916b9067d866c1061c682c17f52bb     270    404.html
100644 blob 4875605ff9bb511d4214dcb883b1110035f583af      10    CNAME
100644 blob d3c4799576ce1217f41a8f4fbca9c387650db0bf     259    Gemfile
100644 blob 1cb1921e62f36b138288e6962fccb1e922b2cbdb    3262    Gemfile.lock
...
100644 blob 3a592ace134535d8003bad502d7b119821e84820    8265    images/nose-96x96.jpg
...
```

That's it - the 4th column is the file size in byte.  Pipe to `awk 'int($4)
> 1024*1024*10'` would give me all file that has size greater than 10MB.

A complete script is like below:

```bash
#!/bin/bash
# List objects larger than 10M. Example usage:
#
# cd /var/opt/gitlab/git-data/repositories
# find-large-file.sh group-foo/*

[[ -n $1 ]] || set .

for GIT_REPO in "$@"; do
    (
    cd $GIT_REPO || exit 1
    NAME=$(basename $(dirname $GIT_REPO))/$(basename $GIT_REPO)
    git ls-tree -lr HEAD 2>/dev/null | \
        awk 'int($4) > 1024*1024*10 {printf("%50s  %4.1fM  %s\n", '"\"$NAME\""', $4/1024/1024, $5)}'
    )
done
```

Guess what I found after running the script over our GitLab repos?

```
...  209.5M  crontab_run.log
...  165.2M  kafka-deploy/packages/jdk-8u45-linux-x64.tar.gz
...  146.4M  kafka-deploy/packages/jdk-7u79-linux-x64.tar.gz
...  138.2M  elasticsearch/ads_compass_unix_1_6_0.sh
...  117.9M  buffalo/rigel_risk/bin/rigel.jar
...  108.7M  thirdparty.tar.gz
```

You newbies!!

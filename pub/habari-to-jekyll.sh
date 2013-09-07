#!/bin/bash

db=myhabari.db
postdir=../_posts

id_list=$(sqlite3 $db "select id from hb_posts where status=2")

for id in $id_list; do

    meta=$(sqlite3 $db \
        "select slug, title, pubdate from hb_posts where id=$id")
    slug=$(echo "$meta" | awk -F'|' '{print $1}')
    title=$(echo "$meta" | awk -F'|' '{print $2}')
    pubdate=$(echo "$meta" | awk -F'|' '{print $3}')
    content=$(sqlite3 $db \
        "select content from hb_posts where id=$id")
    pubdate=$(date -d "@$pubdate" '+%Y-%m-%d')
    file=$postdir/$pubdate-$slug.md

    echo "$pubdate (id=$id, slug='$slug', title='$title') -> $file"

    cat > $file << EOT
---
layout: post
title: $title
---

$content
EOT

done

---
layout: post
title: One line fix accepted
tags: [opensource, ubuntu]
---

前段时间为 ubuntu gdm 做的一个 [bugfix](/2006/08/contribute-to-ubuntu.html),
今天进到 gdm 2.15.9 了。虽然只是一个 one line fix, 但是查到根源还不是那么容易滴，
要不这么容易重现的bug怎么晾在那两个月之久都没人解决呢。嘿嘿，虚荣一下。

    From: SebastienBacher <ubuntu>
    Reply-To: Bug 48876 <4887unchpad.net>
    To: <dot******@gmail.com>
    Date: Aug 16, 2006 11:44 PM
    Subject: [Bug 48876] Re: gnome-session fails when "alias ls='ls --color'" in .profile

    Fixed to edgy with this upload:

    gdm (2.15.9-0ubuntu2) edgy; urgency=low
    .
    * debian/Xsession:
        - specify "ls" path, fix gnome-session not starting due to some parsing
        issues for people using an ls="ls --color" alias to their profile,
        thanks to Matthew Wang <dot******@gmail.com> from tracking it and
        suggesting the change (Ubuntu: #48876)

    ** Changed in: gdm (Ubuntu)
        Status: Fix Committed => Fix Released

    --
    gnome-session fails when "alias ls='ls --color'" in .profile
    https://launchpad.net/bugs/48876

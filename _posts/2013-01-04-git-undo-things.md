---
layout: post
title: Git 的后悔药
category:
tags: []
---
{% include JB/setup %}

将工作区换到指定版本，HEAD 不再指向任何一个分支：

    git checkout 7ce3

起一个新分支并恢复到指定版本：

    git checkout -b old-state 7ce3

丢弃本地修改并恢复到指定版本：

    git reset --hard 7ce3

**不**丢弃本地修改并恢复到指定版本（保存本地修改，revert 后合并，可能产生冲突）：

    git stash
    git reset --hard 7ce3
    git stash pop

撤销已经 push 的修改（将产生新的 revert commit）：

    git revert 7ce3 ee4c a4af

或者

    git checkout 7ce3 .

然后提交。

参见：

- [git-revert(1) man page](http://www.kernel.org/pub/software/scm/git/docs/git-revert.html)
- [Git Basics - Undoing Things](http://git-scm.com/book/en/Git-Basics-Undoing-Things)

---
layout: post
title: Vim 的 Outline 模式
category:
tags: []
---
{% include JB/setup %}

今天要写一个逻辑结构比较明朗的文档，Emacs 的 outline mode 是很好的，但是太久不
用了，实在习惯不了 Emacs 的操作方式，Vim 怎么就没有这样的模式呢？Google 了一下
，找到了这个： <a href="http://www.vim.org/scripts/download_script.php?src_id=4213">Emacs outline
mode for Vim</a>，就在 vim.org 的网站上。把这个 outline.vim 下载下来之后放到
<i>~/.vim/syntax/</i> 下面就行了，用的时候 <i>:set ft=outline</i> 就激活这个模
式，可以自己调整一下颜色。Outline 模式的格式很简单：

```
    * 一级标题
    ** 二级标题
    *** 三级标题
    **** 四级标题
```

依此类推。


Win32 版本的 gvim 是要放到自己的主目录下的 <i>vimfiles\syntax\</i> 下面，主目录
就是 <i>USERPROFILE</i> 这个环境变量的值，一般就是 <i>C:\Documents and
Settings\USERNAME</i>。

这里的 ~/.vim 和 vimfiles 目录可以在 vim 里用 <i>:set runtimepath</i> 看到。

它的折叠功能还不够完善，如果不喜欢，把 <i>setl foldmethod=expr</i> 那句注释掉就行了。

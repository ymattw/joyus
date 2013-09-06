---
layout: post
title: 豆沙绿
category:
tags: []
---
{% include JB/setup %}

<p style="margin: 5px; padding: 5px; float: right; width: 120px; color: rgb(68, 68, 68); height: 90px; background-color: rgb(199, 237, 204);">豆沙绿</p>

换了个 22" 大显示器，白茫茫一片比以前更伤眼睛了。随手 google 了一下，#c7edcc
(RGB: 199/237/204)这个背景色号称是眼科专家推荐的，说是能最大限度保护视力，它还
有个好听的名字 --豆沙绿。试用了一下，就像 Python以缩进来定义语句块一样，挨过了
最初的那几分钟不适应之后，感觉挺好的。

- gnome-terminal 可以编辑 profile，修改背景色
- Firefox 可以通过 about:config 进入配置编辑器，修改
  browser.display.background\_color
- Thunderbird 同样，在某个“高级”选项里面可以找到 Config Editor，修改
  browser.display.background\_color 和 editor.background\_color
- 不支持自定义颜色的 gtk 应用程序可以通过定制主题来配置默认的窗口背景色，例如
  Clearlooks 主题修改<pre>
    cd /usr/share/themes
    cp -a Clearlooks Clearlooks-custom
    cd Clearlooks-custom
    vi index.theme 修改 Name 换名字
    vi gtk-2.0/gtkrc 修改 base\[NORMAL\]</pre>
- Qt 应用程序可以通过 qt\[34\]-qtconfig 来定制
- Windows? 自行 google 吧

话说这个便宜没好货的 VPS，今天下午又一次 disk full 了，但是我还是要榨干它最后一
点价值，写完就备份，到月底了再换...

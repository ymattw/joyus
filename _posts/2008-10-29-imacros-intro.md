---
layout: post
title: 用 iMacros 成功约到周末练车
category: tech
tags: [imacros]
---
{% include JB/setup %}

[iMacros](http://wiki.imacros.net) 简单的说就是一个基于浏览器的录宏回放插件，利
用它可以模拟任何人工的点击，除了手工录制，它还提供一套简单的脚本，还有
javascript，vbscript 等接口方便进行复杂的逻辑控制。听说了这个插件后我就在琢磨怎
么用来自动网上约车。

我报的是东方时尚驾校预约计时班，网上约车每天从早 9 点开放到晚 9 点，只能约 7 天
以内的。一般周末约的人非常多，我这次因为周末外出不能上网，错过了约车的时机，只
能等人退订了我再抢，这个机会非常小，但还是有可能。

断断续续研究了几个小时，终于写出了一个 javascript 脚本调用 iMacros 的接口，并且
大约半小时就成功抢到了退票，呵呵。

大概总结一下：

<ul>
<li>Firefox 版本的插件<a href="https://addons.mozilla.org/en-US/firefox/addon/3863">安装地址</a></li>
<li>录制很简单，点击 record 然后鼠标键盘正常操作，结束后按 stop，然后查看脚本源码，获得第一手感性认识，然后可以对照手册自己添加一些代码</li>
<li>SET !REPLAYSPEED FAST 用来设定回放速度为最快，即执行语句中间不等待</li>
<li>SET !ERRORIGNORE YES 用来忽略错误</li>
<li>REFRESH 用来刷新页面</li>
<li>WAIT SECONDES=3 等待 3 秒</li>
<li>ONDIALOG POS=1 BUTTON=CANCEL CONTENT= 看到弹出窗口后点 Cancel</li>
</ul>

写 js 用到的接口：

<ol>
<li>iimPlay("CODE:...")执行 iMacros 的脚本语句，语句可以是一段，必须以 CODE: 开始，行间要用 "\n" 分隔，返回值为负数代表执行有错</li>
<li>iimGetLastError() 返回最近错误对应的错误信息（字符串）</li>
<li>iimDisplay(msg) 以独立对话框形式显示一个消息</li>
<li>SET 语句只在一个 CODE: 块中有效</li>
<li>Tag 未找到时会默认会等待 !TIMEOUT /10 这么常时间，默认值就是 6 秒</li>
<li>不支持使用 document.getElementById() 来判断 tag 是否存在</li>
</ol>

有了这些就可以用 js 来处理复杂的逻辑控制，我是在先在一个循环中登录，直到登录成
功，然后点击预约按钮转到约车界面，然后点击相应的表格，表格对应的 id 可以直接查
看源码得到，或者用 <a href="https://addons.mozilla.org/en-US/firefox/addon/60">Web Developer</a>，
<a href="https://addons.mozilla.org/firefox/addon/271">Colorzilla</a>
等插件查看，判断返回值可知是不是约成功了，成功之后再点会变成取消，所以要增加
ONDIALOG 语句来点击 Cancel 按钮。

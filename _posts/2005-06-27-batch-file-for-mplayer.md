---
layout: post
title: MPlayer (Win32) 的批处理脚本
category:
tags: []
---
{% include JB/setup %}

<p>
目标是能处理一到两个参数，这样便可以从资源管理器中把文件拖到它的图标上播放了。带一个参数时则是单个视频文件，两个参数则认为一个是视频文件，一个是字幕。要点：
</p>



<ul>

    <li>从资源管理器拖出时，若路径或文件名有空格，则参数会被用双引号引起来，因此比较的时候应改用单引号： if '%2'==''</li>
    <li>echo %2| findstr ... 这里要注意'|'符号之前不能有空格，否则会成为 echo 的参数</li>
    <li>errorlevel 环境变量记录了最后一条命令的返回值</li>
    <li>带两个参数时 %1 和 %2 哪一个是字幕文件是按文件名排序的，而不是在资源管理器中鼠标点击的顺序</li>

</ul>




<p>
下面便是最终的代码，在桌面上为它建个快捷方式，在资源管理器中选中视频文件和字幕文件，拖到它的图标上就可以啦，用了一段时间，效果还不错。
</p>




<pre>

@<font color="#008b8b">rem</font> mp.bat<font color="#a52a2a"><b> - </b></font>batch file <font color="#a52a2a"><b>for</b></font> mplayer
@<font color="#008b8b">rem</font> 把 <font color="#ff00ff">&quot;mplayer_dir&quot;</font> 环境变量改成你自己的，把这个文件放到桌面，或
@<font color="#008b8b">rem</font> 建一个快捷方式。在资源管理器中选择电影文件和字幕文件（如果有的
@<font color="#008b8b">rem</font> 话），拖到 mp.bat 的图标上就行了。只能识别 <font color="#ff00ff">&quot;.sub&quot;</font> 和 <font color="#ff00ff">&quot;.srt&quot;</font> 的
@<font color="#008b8b">rem</font> 字幕，其他的可以自己修改。
@<font color="#008b8b">rem</font> wayman Jun. <font color="#ff00ff">6</font>, <font color="#ff00ff">2005</font>

@<font color="#008b8b">echo</font><font color="#a52a2a"><b> off</b></font>

<font color="#008b8b">set</font><font color="#008b8b"> mplayer_dir</font><font color="#a52a2a"><b>=</b></font>e:&#92;app&#92;mplayer

@<font color="#008b8b">rem</font> 用单引号保证能正确处理路径和文件名含空格的情况
@<font color="#008b8b">rem</font> 同样的道理，<font color="#008b8b">%1</font>、<font color="#008b8b">%2</font> 也不要带双引号
<font color="#a52a2a"><b>if</b></font><font color="#a52a2a"><b> </b></font>'<font color="#008b8b">%2</font>'<font color="#a52a2a"><b>==</b></font>'' <font color="#a52a2a"><b>goto</b></font><font color="#a52a2a"><b> nosub</b></font>

<font color="#008b8b">set</font><font color="#008b8b"> file</font><font color="#a52a2a"><b>=</b></font><font color="#008b8b">%1</font>
<font color="#008b8b">set</font><font color="#008b8b"> sub</font><font color="#a52a2a"><b>=</b></font><font color="#008b8b">%2</font>

@<font color="#008b8b">rem</font> 注意 <font color="#008b8b">%2</font> 后面不要空格!
@<font color="#008b8b">rem</font> 不能写 &#92;.srt$，因为 <font color="#008b8b">%2</font> 最后一个字符可能是引号（当路径上有空格）
<font color="#008b8b">echo</font><font color="#ff00ff"> </font><font color="#008b8b">%2</font>| <font color="#008b8b">findstr</font> <font color="#6a5acd">/i</font> <font color="#6a5acd">/r</font> <font color="#ff00ff">&quot;&#92;.srt&quot;</font>
<font color="#a52a2a"><b>if</b></font><font color="#a52a2a"><b> </b></font><font color="#008b8b">%errorlevel%</font> <font color="#a52a2a"><b>EQU</b></font> <font color="#ff00ff">0</font> <font color="#a52a2a"><b>goto</b></font><font color="#a52a2a"><b> ok</b></font>

<font color="#008b8b">echo</font><font color="#ff00ff"> </font><font color="#008b8b">%2</font>| <font color="#008b8b">findstr</font> <font color="#6a5acd">/i</font> <font color="#6a5acd">/r</font> <font color="#ff00ff">&quot;&#92;.sub&quot;</font>
<font color="#a52a2a"><b>if</b></font><font color="#a52a2a"><b> </b></font><font color="#008b8b">%errorlevel%</font> <font color="#a52a2a"><b>EQU</b></font> <font color="#ff00ff">0</font> <font color="#a52a2a"><b>goto</b></font><font color="#a52a2a"><b> ok</b></font>

<font color="#008b8b">rem</font><font color="#0000ff"> exchange file and subtitle</font>
<font color="#008b8b">set</font><font color="#008b8b"> file</font><font color="#a52a2a"><b>=</b></font><font color="#008b8b">%2</font>
<font color="#008b8b">set</font><font color="#008b8b"> sub</font><font color="#a52a2a"><b>=</b></font><font color="#008b8b">%1</font>
<font color="#a52a2a"><b>goto</b></font><font color="#a52a2a"><b> ok</b></font>

<font color="#a52a2a"><b>:ok</b></font>
<font color="#008b8b">%mplayer_dir%</font>&#92;mplayer.exe -fs <font color="#008b8b">%file%</font> -sub <font color="#008b8b">%sub%</font>
<font color="#008b8b">set</font><font color="#008b8b"> file</font><font color="#a52a2a"><b>=</b></font>
<font color="#008b8b">set</font><font color="#008b8b"> sub</font><font color="#a52a2a"><b>=</b></font>
<font color="#a52a2a"><b>goto</b></font><font color="#a52a2a"><b> end</b></font>

<font color="#a52a2a"><b>:nosub</b></font>
<font color="#008b8b">echo</font><font color="#ff00ff"> subtitle unspecified!</font>
<font color="#008b8b">%mplayer_dir%</font>&#92;mplayer.exe -fs <font color="#008b8b">%1</font>
<font color="#a52a2a"><b>goto</b></font><font color="#a52a2a"><b> end</b></font>

<font color="#a52a2a"><b>:end</b></font>
<font color="#008b8b">set</font><font color="#008b8b"> mplayer_dir</font><font color="#a52a2a"><b>=</b></font>

</pre>


---
layout: post
title: Wordpress 标点问题
category:
tags: []
---
{% include JB/setup %}

<p>
我的单引号、双引号、后引号还有连一起的减号在页面里总是显得怪怪的，一看源码
它们都已经被替换了，例如两个连一起的单引号''被替换为&#8221;（&amp;#8221;），两
个连一起的后引号``被替换为&#8220;（&amp;#8220;），但在&lt;pre&gt;和
&lt;code&gt;标签里面不变。打开帖子编辑又发现它完全正常，这着实让我郁闷。搜了一
些，<a href="http://www.ennonce.com/blog/">土路托</a>提到<a href="http://www.ennonce.com/blog/?p=174">字体的问题</a>，一开始我也怀疑是这个，因为正巧正常的&lt;pre&gt;和&lt;code&gt;标签里面用的是不同字体，然而试验了多个字体都未能解决让我否决了这个原因。
</p>



<p>
最后解决的很简单，我用 grep 在 wordpress 目录下搜索 8221 这样的玩意，找到了 wp-includes/functions-formatting.php，看到了这样的代码：
</p>



<pre>

<font color="#a020f0">function</font> wptexturize<font color="#6a5acd">(</font><font color="#a52a2a"><b>$</b></font><font color="#008b8b">text</font><font color="#6a5acd">)</font> <font color="#6a5acd">{</font>
    <font color="#a52a2a"><b>...</b></font>
    <font color="#a52a2a"><b>for</b></font> <font color="#6a5acd">(</font><font color="#a52a2a"><b>$</b></font><font color="#008b8b">i</font> <font color="#a52a2a"><b>=</b></font> <font color="#ff00ff">0</font>; <font color="#a52a2a"><b>$</b></font><font color="#008b8b">i</font> <font color="#a52a2a"><b>&lt;</b></font> <font color="#a52a2a"><b>$</b></font><font color="#008b8b">stop</font>; <font color="#a52a2a"><b>$</b></font><font color="#008b8b">i</font><font color="#a52a2a"><b>++</b></font><font color="#6a5acd">)</font> <font color="#6a5acd">{</font>
        <font color="#a52a2a"><b>$</b></font><font color="#008b8b">curl</font> <font color="#a52a2a"><b>=</b></font> <font color="#a52a2a"><b>$</b></font><font color="#008b8b">textarr</font><font color="#6a5acd">[</font><font color="#a52a2a"><b>$</b></font><font color="#008b8b">i</font><font color="#6a5acd">]</font>;

        <font color="#a52a2a"><b>if</b></font> <font color="#6a5acd">(</font><font color="#008b8b">isset</font><font color="#6a5acd">(</font><font color="#a52a2a"><b>$</b></font><font color="#008b8b">curl</font><font color="#6a5acd">{</font><font color="#ff00ff">0</font><font color="#6a5acd">})</font> <font color="#a52a2a"><b>&amp;&amp;</b></font> '<font color="#ff00ff">&lt;</font>' <font color="#a52a2a"><b>!=</b></font> <font color="#a52a2a"><b>$</b></font><font color="#008b8b">curl</font><font color="#6a5acd">{</font><font color="#ff00ff">0</font><font color="#6a5acd">}</font> <font color="#a52a2a"><b>&amp;&amp;</b></font> <font color="#a52a2a"><b>$</b></font><font color="#008b8b">next</font><font color="#6a5acd">)</font> <font color="#6a5acd">{</font>
            <font color="#a52a2a"><b>$</b></font><font color="#008b8b">curl</font> <font color="#a52a2a"><b>=</b></font> <font color="#008b8b">str_replace</font><font color="#6a5acd">(</font>'<font color="#ff00ff">---</font>', '<font color="#ff00ff">&amp;#8212;</font>', <font color="#a52a2a"><b>$</b></font><font color="#008b8b">curl</font><font color="#6a5acd">)</font>;
            <font color="#a52a2a"><b>$</b></font><font color="#008b8b">curl</font> <font color="#a52a2a"><b>=</b></font> <font color="#008b8b">str_replace</font><font color="#6a5acd">(</font>'<font color="#ff00ff"> -- </font>', '<font color="#ff00ff"> &amp;#8212; </font>', <font color="#a52a2a"><b>$</b></font><font color="#008b8b">curl</font><font color="#6a5acd">)</font>;
            <font color="#a52a2a"><b>$</b></font><font color="#008b8b">curl</font> <font color="#a52a2a"><b>=</b></font> <font color="#008b8b">str_replace</font><font color="#6a5acd">(</font>'<font color="#ff00ff">--</font>', '<font color="#ff00ff">&amp;#8211;</font>', <font color="#a52a2a"><b>$</b></font><font color="#008b8b">curl</font><font color="#6a5acd">)</font>;
            <font color="#a52a2a"><b>$</b></font><font color="#008b8b">curl</font> <font color="#a52a2a"><b>=</b></font> <font color="#008b8b">str_replace</font><font color="#6a5acd">(</font>'<font color="#ff00ff">xn&amp;#8211;</font>', '<font color="#ff00ff">xn--</font>', <font color="#a52a2a"><b>$</b></font><font color="#008b8b">curl</font><font color="#6a5acd">)</font>;
            <font color="#a52a2a"><b>$</b></font><font color="#008b8b">curl</font> <font color="#a52a2a"><b>=</b></font> <font color="#008b8b">str_replace</font><font color="#6a5acd">(</font>'<font color="#ff00ff">...</font>', '<font color="#ff00ff">&amp;#8230;</font>', <font color="#a52a2a"><b>$</b></font><font color="#008b8b">curl</font><font color="#6a5acd">)</font>;
            <font color="#a52a2a"><b>$</b></font><font color="#008b8b">curl</font> <font color="#a52a2a"><b>=</b></font> <font color="#008b8b">str_replace</font><font color="#6a5acd">(</font>'<font color="#ff00ff">``</font>', '<font color="#ff00ff">&amp;#8220;</font>', <font color="#a52a2a"><b>$</b></font><font color="#008b8b">curl</font><font color="#6a5acd">)</font>;
            <font color="#a52a2a"><b>...</b></font>
            <font color="#a52a2a"><b>$</b></font><font color="#008b8b">curl</font> <font color="#a52a2a"><b>=</b></font> <font color="#008b8b">str_replace</font><font color="#6a5acd">(</font>&quot;<font color="#ff00ff">''</font>&quot;, '<font color="#ff00ff">&amp;#8221;</font>', <font color="#a52a2a"><b>$</b></font><font color="#008b8b">curl</font><font color="#6a5acd">)</font>;
            <font color="#a52a2a"><b>...</b></font>

</pre>



<p>
我只昨晚上看过 10 分钟的 PHP 教程，看不懂为什么要这么做，但我看懂了它就是罪魁祸首。如果是为了美观才这样替换，那真是人神共愤的，至少应该提供一个选项吧？
</p>



<p>
取消替换的办法就简单了，不让替换哪个就注释掉那个好了，而我做得比较绝，我把 if () 里面的条件注释掉并换成了 false。
</p>



<p>
好了，世界清静了。
</p>


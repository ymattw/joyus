---
layout: post
title: 用普通用户身份使用XP
category: tech
tags: [windows, runas]
---
{% include JB/setup %}

建立一个 Users 组的用户，用于日常使用，再建立一个超级用户 root，用于系统管理和
维护（之所以新加一个超级用户，是因为缺省的 Administrator 用户不会在登录时的用户
名列表中出现，这样使用快速用户切换就不可行了），进一步，还可以建立更低权限的用
户用于特殊用途，如 BT、eMule 下载，严格限制这种用户可读写的目录权限。这思路符合
我使用 Linux 的习惯，多数的系统维护和管理操作可用 runas 命令搞定：runas
/user:root program，在资源管理器中右键点执行文件或快捷方式，选"运行方式"是
runas 的图形化版本。

### 配置网络

可用 netsh.exe 命令来实现。例如：

<ul>
<li>配置 IP: netsh interface ip set address name="本地连接" source=static addr=192.168.0.2<a href="http://192.168.0.2/"></a> mask=255.255.255.0 </li>
<li>配置网关: netsh interface ip set address name="本地连接" gateway=192.168.0.1 gwmetric=1</li>
<li>配置主 DNS: netsh interface ip set dns name="本地连接" source=static addr= 202.106.46.151<a href="http://202.106.46.151/"></a> register=PRIMARY</li>
<li>添加备用DNS: netsh interface ip add dns name="本地连接" addr=202.106.0.20<a href="http://202.106.0.20/"></a></li>
</ul>

当然其中网关或路由还可用 route 命令搞定。

### 计算机管理

mmc，打开 `%SystemRoot%\system32\compmgmt.msc` 就可以干很多事了

### 允许普通用户更改系统时间

gpedit.msc | 计算机配置 | Windows 设置 | 安全设置 | 本地策略 | 用户权利指派 |
更改系统时间，在这里添加允许修改时间的普通用户名或干脆加 Users 组

然而，Windows 可不象 Linux 那么好对付，不是所有操作都可以用 runas 搞定的，我按
这个方式使用了一段时间，遇到一些非常棘手的问题，有时不得不用快速用户切换来做，
实在是非常之土，例如：如何不切换用户以 superuser 身份打开 shell，即
explorer.exe？我知道可以先 kill 之，再 runas 起一个，但这显然不是正道。以
superuser 身份打开控制面板属于同一个问题。再就是相当多的软件没有考虑这种多用户
的情况，霸道地认为运行它的用户都有 superuser 权限，一个解决的办法是不要安装到
Program Files 目录，但这又和低权限运行的初衷相违背，难啊。

# Luacheck

[![在 Gitter 加入聊天](https://badges.gitter.im/luacheck/Lobby.svg)](https://gitter.im/luacheck/Lobby?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[![构建状态](https://travis-ci.org/mpeterv/luacheck.png?branch=master)](https://travis-ci.org/mpeterv/luacheck)
[![Windows 构建状态](https://ci.appveyor.com/api/projects/status/pgox2vvelagw1fux/branch/master?svg=true&passingText=Windows%20build%20passing&failingText=Windows%20build%20failing)](https://ci.appveyor.com/project/mpeterv/luacheck/branch/master)
[![codecov](https://codecov.io/gh/mpeterv/luacheck/branch/master/graph/badge.svg)](https://codecov.io/gh/mpeterv/luacheck)
[![许可证](https://img.shields.io/badge/License-MIT-brightgreen.svg)](LICENSE)

## 目录

* [概述](#概述)
* [安装](#安装)
* [基本用法](#基本用法)
* [相关项目](#相关项目)
* [文档](#文档)
* [开发](#开发)
* [构建和测试](#构建和测试)
* [许可证](#许可证)

## 概述

Luacheck 是一个 [Lua](http://www.lua.org) 的静态分析器和代码检查工具。Luacheck 可以检测各种问题，如使用未定义的全局变量、未使用的变量和值、访问未初始化的变量、不可达代码等。检查的大多数方面都是可配置的：有选项可以定义自定义项目相关的全局变量、选择标准全局变量集（Lua 标准库版本）、按类型和相关变量名称过滤警告等。这些选项可以在命令行使用、放入配置文件或直接作为 Lua 注释放入被检查的文件中。

Luacheck 支持使用 Lua 5.1、Lua 5.2、Lua 5.3 和 LuaJIT 语法的 Lua 文件检查。Luacheck 本身用 Lua 编写，可以在所有提到的 Lua 版本上运行。

## 安装

### 使用 LuaRocks

从命令行运行以下命令（必要时使用 `sudo`）：

```
luarocks install luacheck
```

对于并行检查，Luacheck 还需要 [LuaLanes](https://github.com/LuaLanes/lanes)，也可以使用 LuaRocks 安装（`luarocks install lanes`）。

### Windows 二进制下载

对于 Windows，有单文件 64 位二进制分发版，使用 [LuaStatic](https://github.com/ers35/luastatic) 捆绑了 Lua 5.3.4、Luacheck、LuaFileSystem 和 LuaLanes：
[下载](https://github.com/mpeterv/luacheck/releases/download/0.23.0/luacheck.exe)。

## 基本用法

安装 Luacheck 后，从命令行运行 `luacheck` 程序。传递要检查的文件、[rockspecs](https://github.com/luarocks/luarocks/wiki/Rockspec-format) 或目录列表（需要 LuaFileSystem）：

```
luacheck src extra_file.lua another_file.lua
```

```
Checking src/good_code.lua               OK
Checking src/bad_code.lua                3 warnings

    src/bad_code.lua:3:23: unused variable length argument
    src/bad_code.lua:7:10: setting non-standard global variable embrace
    src/bad_code.lua:8:10: variable opt was previously defined as an argument on line 7

Checking src/python_code.lua             1 error

    src/python_code.lua:1:6: expected '=' near '__future__'

Checking extra_file.lua                  5 warnings

    extra_file.lua:3:18: unused argument baz
    extra_file.lua:4:8: unused loop variable i
    extra_file.lua:13:7: accessing uninitialized variable a
    extra_file.lua:14:1: value assigned to variable x is unused
    extra_file.lua:21:7: variable z is never accessed

Checking another_file.lua                2 warnings

    another_file.lua:2:7: unused variable height
    another_file.lua:3:7: accessing undefined variable heigth

Total: 10 warnings / 1 error in 5 files
```

更多信息请参阅[文档](https://luacheck.readthedocs.io/en/stable/)。

## 相关项目

### 编辑器支持

有几个插件允许直接在编辑器内使用 Luacheck，内联显示警告：

* 对于 Vim，[Syntastic](https://github.com/vim-syntastic/syntastic) 包含 [luacheck 检查器](https://github.com/vim-syntastic/syntastic/wiki/Lua%3A---luacheck)；
* 对于 Sublime Text 3，有 [SublimeLinter-luacheck](https://packagecontrol.io/packages/SublimeLinter-luacheck)，需要 [SublimeLinter](https://sublimelinter.readthedocs.io/en/latest/)；
* 对于 Atom，有 [linter-luacheck](https://atom.io/packages/linter-luacheck)，需要 [AtomLinter](https://github.com/steelbrain/linter)；
* 对于 Emacs，[Flycheck](http://www.flycheck.org/en/latest/) 包含 [luacheck 检查器](http://www.flycheck.org/en/latest/languages.html#lua)；
* 对于 Brackets，有 [linter.luacheck](https://github.com/Malcolm3141/brackets-luacheck) 扩展；
* 对于 Visual Studio Code，有 [vscode-luacheck](https://marketplace.visualstudio.com/items?itemName=dwenegar.vscode-luacheck) 扩展。[vscode-lua](https://marketplace.visualstudio.com/items?itemName=trixnz.vscode-lua) 扩展也包含 Luacheck 支持。

如果您是插件开发者，请参阅[在插件中使用 Luacheck 的推荐方式](http://luacheck.readthedocs.org/en/stable/cli.html#stable-interface-for-editor-plugins-and-tools)。

### 其他项目

* [Luacheck 的 Node.js 绑定](https://www.npmjs.com/package/luacheck)；
* [Luacheck 的 Gulp 插件](https://www.npmjs.com/package/gulp-luacheck)。

## 文档

文档可在线获取[在线文档](https://luacheck.readthedocs.io/en/stable/)。如果 Luacheck 是使用 LuaRocks 安装的，可以使用 `luarocks doc luacheck` 命令离线浏览。

文档可以使用 [Sphinx](http://sphinx-doc.org/) 构建：`sphinx-build docsrc doc`，文件将位于 `doc/` 目录中。

## 开发

Luacheck 目前正在开发中。最新发布版本是 0.23.0。`luacheck` 模块的接口可能在次版本发布之间发生变化。命令行接口相当稳定。

使用 GitHub 上的 Luacheck 问题跟踪器提交错误、建议和问题。也欢迎任何拉取请求。

## 构建和测试

克隆 Luacheck 仓库并进行更改后，从其根目录运行 `luarocks make`（必要时使用 `sudo`）来安装 Luacheck 的开发版本。要使用当前目录中的源码运行 Luacheck 而不安装它，请运行 `lua -e 'package.path="./src/?.lua;./src/?/init.lua;"..package.path' bin/luacheck.lua ...`。要测试 Luacheck，请确保您已安装 [busted](http://olivinelabs.com/busted/) 和 [luautf8](https://github.com/starwing/luautf8) 并运行 `busted`。

## 许可证

```
MIT 许可证 (MIT)

版权所有 (c) 2014 - 2018 Peter Melnichenko

特此免费授予任何获得本软件及相关文档文件（"软件"）副本的人不受限制地处理软件的权利，包括但不限于使用、复制、修改、合并、发布、分发、再许可和/或销售软件副本的权利，并允许获得软件的人这样做，但须符合以下条件：

上述版权声明和本许可声明应包含在软件的所有副本或实质性部分中。

本软件按"原样"提供，不提供任何形式的明示或暗示的保证，包括但不限于适销性、特定用途适用性和非侵权性的保证。在任何情况下，作者或版权持有人均不对因软件或软件的使用或其他交易而产生的任何索赔、损害或其他责任负责，无论是在合同、侵权还是其他方面。
```
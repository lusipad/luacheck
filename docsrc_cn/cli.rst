命令行界面
==========

``luacheck`` 程序接受文件、目录和 `rockspecs <https://github.com/luarocks/luarocks/wiki/Rockspec-format>`_ 作为参数。它们可以使用 ``--include-files`` 和 ``--exclude-files`` 选项进行过滤，详见下文。

* 给定文件，``luacheck`` 将检查该文件。
* 给定 ``-``，``luacheck`` 将检查标准输入。
* 给定目录，``luacheck`` 将检查其中的所有文件，除非使用 ``--include-files`` 选项，否则只选择扩展名为 ``.lua`` 的文件。此功能需要 `LuaFileSystem <http://keplerproject.github.io/luafilesystem/>`_（如果使用 LuaRocks 安装 Luacheck，则会自动安装）。
* 给定 rockspec（扩展名为 ``.rockspec`` 的文件），``luacheck`` 将检查 rockspec 中 ``build.install.lua``、``build.install.bin`` 和 ``build.modules`` 表中提到的所有扩展名为 ``.lua`` 的文件。

``luacheck`` 的输出由每个被检查文件的单独报告组成，并以摘要结束::

   $ luacheck src
   Checking src/bad_code.lua                         5 warnings

       src/bad_code.lua:3:16: unused variable helper
       src/bad_code.lua:3:23: unused variable length argument
       src/bad_code.lua:7:10: setting non-standard global variable embrace
       src/bad_code.lua:8:10: variable opt was previously defined as an argument on line 7
       src/bad_code.lua:9:11: accessing undefined variable hepler

   Checking src/good_code.lua                        OK
   Checking src/python_code.lua                      1 error

       src/python_code.lua:1:6: expected '=' near '__future__'

   Checking src/unused_code.lua                      9 warnings

       src/unused_code.lua:3:18: unused argument baz
       src/unused_code.lua:4:8: unused loop variable i
       src/unused_code.lua:5:13: unused variable q
       src/unused_code.lua:7:11: unused loop variable a
       src/unused_code.lua:7:14: unused loop variable b
       src/unused_code.lua:7:17: unused loop variable c
       src/unused_code.lua:13:7: value assigned to variable x is unused
       src/unused_code.lua:14:1: value assigned to variable x is unused
       src/unused_code.lua:22:1: value assigned to variable z is unused

   Total: 14 warnings / 1 error in 4 files

``luacheck`` 选择退出代码如下：

* 如果没有警告或错误发生，退出代码为 ``0``。
* 如果发生一些警告但没有语法错误或无效的内联选项，退出代码为 ``1``。
* 如果存在一些语法错误或无效的内联选项，退出代码为 ``2``。
* 如果某些文件无法检查，通常是由于文件名不正确，退出代码为 ``3``。
* 如果存在严重错误（无效的 CLI 参数、配置或缓存文件），退出代码为 ``4``。

.. _cliopts:

命令行选项
---------

不带参数的短选项可以组合成一个，因此 ``-qqu`` 等同于 ``-q -q -u``。对于长选项，可以使用 ``--option value`` 或 ``--option=value``。

接受多个参数的选项可以多次使用；``--ignore foo --ignore bar`` 等同于 ``--ignore foo bar``。

请注意，可能接受多个参数的选项，如 ``--globals``，不应紧接在位置参数之前使用；给定 ``--globals foo bar file.lua``，``luacheck`` 会将所有 ``foo``、``bar`` 和 ``file.lua`` 视为全局变量，然后因为没有剩余的文件名而崩溃。

======================================= ================================================================================
选项                                    含义
======================================= ================================================================================
``-g | --no-global``                    过滤掉与全局变量相关的警告。
``-u | --no-unused``                    过滤掉与未使用变量和值相关的警告。
``-r | --no-redefined``                 过滤掉与重定义变量相关的警告。
``-a | --no-unused-args``               过滤掉与未使用参数和循环变量相关的警告。
``-s | --no-unused-secondaries``        过滤掉与和已使用变量一起设置的未使用变量相关的警告。

                                        见 :ref:`secondaryvaluesandvariables`
``--no-self``                           过滤掉与隐式 ``self`` 参数相关的警告。
``--std <std>``                         设置标准全局变量，默认为 ``max``。``<std>`` 可以是以下之一：

                                        * ``max`` - Lua 5.1、Lua 5.2、Lua 5.3 和 LuaJIT 2.x 全局变量的并集；
                                        * ``min`` - Lua 5.1、Lua 5.2、Lua 5.3 和 LuaJIT 2.x 全局变量的交集；
                                        * ``lua51`` - Lua 5.1 的全局变量，不包括已弃用的；
                                        * ``lua51c`` - Lua 5.1 的全局变量；
                                        * ``lua52`` - Lua 5.2 的全局变量；
                                        * ``lua52c`` - 用 LUA_COMPAT_ALL 编译的 Lua 5.2 的全局变量；
                                        * ``lua53`` - Lua 5.3 的全局变量；
                                        * ``lua53c`` - 用 LUA_COMPAT_5_2 编译的 Lua 5.3 的全局变量；
                                        * ``luajit`` - LuaJIT 2.x 的全局变量；
                                        * ``ngx_lua`` - Openresty `lua-nginx-module <https://github.com/openresty/lua-nginx-module>`_ 0.10.10 的全局变量，包括标准 LuaJIT 2.x 全局变量；
                                        * ``love`` - `LÖVE <https://love2d.org>`_ 添加的全局变量；
                                        * ``busted`` - Busted 2.0 添加的全局变量，默认为 ``spec``、``test`` 和 ``tests`` 子目录中以 ``_spec.lua`` 结尾的文件添加；
                                        * ``rockspec`` - rockspec 中允许的全局变量，默认为以 ``.rockspec`` 结尾的文件添加；
                                        * ``luacheckrc`` - Luacheck 配置中允许的全局变量，默认为以 ``.luacheckrc`` 结尾的文件添加；
                                        * ``none`` - 没有标准全局变量。

                                        见 :ref:`stds`
``--globals [<name>] ...``              在标准全局变量之上添加自定义全局变量或字段。见 :ref:`fields`
``--read-globals [<name>] ...``         添加只读全局变量或字段。
``--new-globals [<name>] ...``          设置自定义全局变量或字段。移除之前添加的自定义全局变量。
``--new-read-globals [<name>] ...``     设置只读全局变量或字段。移除之前添加的只读全局变量。
``--not-globals [<name>] ...``          移除自定义和标准全局变量或字段。
``-c | --compat``                       等同于 ``--std max``。
``-d | --allow-defined``                允许通过设置来隐式定义全局变量。

                                        见 :ref:`implicitlydefinedglobals`
``-t | --allow-defined-top``            允许通过在顶层作用域设置来隐式定义全局变量。

                                        见 :ref:`implicitlydefinedglobals`
``-m | --module``                       将隐式定义的全局变量的可见性限制在其文件内。

                                        见 :ref:`modules`
``--max-line-length <length>``          设置最大允许行长度（默认：120）。
``--no-max-line-length``                不限制行长度。
``--max-code-line-length <length>``     设置以代码结尾的行的最大允许长度（默认：120）。
``--no-max-code-line-length``           不限制代码行长度。
``--max-string-line-length <length>``   设置字符串内行的最大允许长度（默认：120）。
``--no-max-string-line-length``         不限制字符串行长度。
``--max-comment-line-length <length>``  设置注释行的最大允许长度（默认：120）。
``--no-max-comment-line-length``        不限制注释行长度。
``--max-cyclomatic-complexity <limit>`` 设置函数的最大圈复杂度。
``--no-max-cyclomatic-complexity``      不限制函数圈复杂度（默认）。
``--ignore | -i <patt> [<patt>] ...``   过滤掉匹配模式的警告。
``--enable | -e <patt> [<patt>] ...``   不过滤匹配模式的警告。
``--only | -o <patt> [<patt>] ...``     过滤掉不匹配模式的警告。
``--config <config>``                   自定义配置文件的路径（默认：``.luacheckrc``）。
``--no-config``                         不查找自定义配置文件。
``--default-config <config>``           自定义配置文件的默认路径，当未使用 ``--[no-]config`` 且未找到 ``.luacheckrc`` 时使用。

                                        默认全局位置是：

                                        * Windows 上为 ``%LOCALAPPDATA%\Luacheck\.luacheckrc``；
                                        * OS X/macOS 上为 ``~/Library/Application Support/Luacheck/.luacheckrc``；
                                        * 其他系统上为 ``$XDG_CONFIG_HOME/luacheck/.luacheckrc`` 或 ``~/.config/luacheck/.luacheckrc``。
``--no-default-config``                 不使用备用配置文件。
``--filename <filename>``               在输出中使用另一个文件名，用于选择配置覆盖和文件过滤。
``--exclude-files <glob> [<glob>] ...`` 不检查匹配这些 glob 模式的文件。支持递归 glob，如 ``**/*.lua``。
``--include-files <glob> [<glob>] ...`` 不检查不匹配这些 glob 模式的文件。
``--cache [<cache>]``                   缓存文件的路径。（默认：``.luacheckcache``）。见 :ref:`cache`
``--no-cache``                          不使用缓存。
``-j | --jobs``                         并行检查 ``<jobs>`` 个文件。需要 `LuaLanes <http://cmr.github.io/lanes/>`_。
                                        默认作业数设置为可用处理单元的数量。
``--formatter <formatter>``             使用自定义格式化程序。``<formatter>`` 必须是模块名称或以下之一：

                                        * ``TAP`` - Test Anything Protocol 格式化程序；
                                        * ``JUnit`` - JUnit XML 格式化程序；
                                        * ``visual_studio`` - MSBuild/Visual Studio 感知格式化程序；
                                        * ``plain`` - 简单的每行警告格式化程序；
                                        * ``default`` - 标准格式化程序。
``-q | --quiet``                        抑制没有警告的文件的报告输出。

                                        * ``-qq`` - 抑制警告输出。
                                        * ``-qqq`` - 仅输出摘要。
``--codes``                             显示警告代码。
``--ranges``                            显示与警告相关的列范围。
``--no-color``                          不对输出着色。
``-v | --version``                      显示 Luacheck 及其依赖项的版本并退出。
``-h | --help``                         显示帮助并退出。
======================================= ================================================================================

.. _patterns:

模式
----

CLI 选项 ``--ignore``、``--enable`` 和 ``--only`` 以及相应的配置选项允许通过对警告代码、变量名称或两者进行模式匹配来过滤警告。如果模式包含斜杠，斜杠前的部分匹配警告代码，斜杠后的部分匹配变量名称。否则，如果模式包含字母或下划线，则匹配变量名称。否则，匹配警告代码。例如：

======= =========================================================================
模式    匹配的警告
======= =========================================================================
4.2     遮蔽参数声明或重新定义它们。
.*_     与以 ``_`` 后缀的变量相关的警告。
4.2/.*_ 遮蔽以 ``_`` 后缀的参数声明或重新定义它们。
======= =========================================================================

除非已经锚定，匹配变量名称的模式在两侧锚定，匹配警告代码的模式在开始处锚定。这允许按类别过滤警告（例如 ``--only 1`` 使 ``luacheck`` 专注于与全局变量相关的警告）。

.. _fields:

定义额外的全局变量和字段
------------------------

CLI 选项 ``--globals``、``--new-globals``、``--read-globals``、``--new-read-globals`` 以及相应的配置选项添加新的允许的全局变量或字段。例如 ``--read-globals foo --globals foo.bar`` 允许访问 ``foo`` 全局变量并修改其 ``bar`` 字段。``--not-globals`` 也对全局变量和字段操作，并移除标准和自定义全局变量的定义。

.. _stds:

标准全局变量集
--------------

CLI 选项 ``--stds`` 允许使用 ``+`` 组合上述内置集。例如，``--std max`` 等同于 ``--std=lua51c+lua52c+lua53c+luajit``。前导加号将新集添加到当前集而不是替换它。例如，``--std +love`` 适用于检查使用 `LÖVE <https://love2d.org>`_ 框架的文件。可以通过在配置中改变全局变量 ``stds`` 来定义自定义全局变量集。见 :ref:`custom_stds`

格式化程序
----------

CLI 选项 ``--formatter`` 允许为 ``luacheck`` 输出选择自定义格式化程序。自定义格式化程序是一个 Lua 模块，返回一个带有三个参数的函数：``luacheck`` 模块返回的报告（见 :ref:`report`）、文件名数组和选项表。选项包含在 CLI 或配置中分配给 ``quiet``、``color``、``limit``、``codes``、``ranges`` 和 ``formatter`` 选项的值。格式化程序函数必须返回一个字符串。

.. _cache:

缓存
----

如果 LuaFileSystem 可用，Luacheck 可以缓存检查文件的结果。在后续检查中，只有自上次检查以来发生更改的文件才会被重新检查，显著提高运行时间。更改选项（例如定义额外的全局变量）不会使缓存失效。可以通过使用 ``--cache <cache>`` 选项或 ``cache`` 配置选项来启用缓存。使用不带参数的 ``--cache`` 或将 ``cache`` 配置选项设置为 ``true`` 会将 ``.luacheckcache`` 设置为缓存文件。请注意，``--cache`` 必须在每次运行 ``luacheck`` 时使用，而不仅仅是在第一次运行时。

编辑器插件和工具的稳定接口
--------------------------

Luacheck 的命令行界面可能在次版本发布之间发生变化。从 0.11.0 版本开始，以下接口至少保证到 1.0.0 版本，应该由使用 Luacheck 输出的工具使用，例如编辑器插件。

* Luacheck 应从包含被检查文件的目录启动。
* 文件可以通过使用 ``-`` 作为参数通过 stdin 传递，或使用临时文件。真实文件名应使用 ``--filename`` 选项传递。
* 应使用 plain 格式化程序。它每行输出一个问题（警告或错误）。
* 要获得精确的错误位置，可以使用 ``--ranges`` 选项。每行以真实文件名（使用 ``--filename`` 传递）开头，后跟 ``:<line>:<start_column>-<end_column>:``，其中 ``<line>`` 是问题发生的行号，``<start_column>-<end_column>`` 是与问题相关的令牌的包含列范围。编号从 1 开始。如果未使用 ``--ranges``，则不打印结束列和破折号。
* 要获得警告和错误代码，可以使用 ``--codes`` 选项。对于每行，括号之间的子字符串包含三位数字的问题代码，错误前缀为 ``E``，警告前缀为 ``W``。缺少此类子字符串表示致命错误（例如 I/O 错误）。
* 行的其余部分是警告消息。

如果需要与旧版 Luacheck 兼容，可以使用 ``luacheck --help`` 的输出来获取其版本。如果它包含字符串 ``0.<minor>.<patch>``，其中 ``<minor>`` 至少为 11，``patch`` 为任意数字，则应使用上述接口。
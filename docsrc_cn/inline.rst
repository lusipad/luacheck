内联选项
========

Luacheck 支持使用内联配置注释直接在被检查的文件中设置一些选项。这些内联选项具有最高优先级，覆盖配置选项和 CLI 选项。

内联配置注释是一个以 ``luacheck:`` 标签开头的短注释，可能在一些空白字符之后。注释的主体应包含逗号分隔的选项，其中选项调用由其名称加上空格分隔的参数组成。它还可以包含包含在平衡括号内的注释，这些注释被忽略。支持以下选项：

======================= ====================================================================
选项                    参数数量
======================= ====================================================================
global                  0
unused                  0
redefined               0
unused args             0
unused secondaries      0
self                    0
compat                  0
module                  0
allow defined           0
allow defined top       0
max line length         1（使用 ``no`` 且没有参数会禁用行长度检查）
max code line length    1（使用 ``no`` 且没有参数会禁用代码行长度检查）
max string line length  1（使用 ``no`` 且没有参数会禁用字符串行长度检查）
max comment line length 1（使用 ``no`` 且没有参数会禁用注释行长度检查）
std                     1
globals                 0+
new globals             0+
read globals            0+
new read globals        0+
not globals             0+
ignore                  0+（没有参数时忽略所有内容）
enable                  1+
only                    1+
======================= ====================================================================

不带参数的选项可以加 ``no`` 前缀来反转其含义。例如 ``--luacheck: no unused args`` 禁用未使用参数警告。

受内联选项影响的文件部分取决于其放置位置。如果选项所在的行有任何代码，则只影响该行；否则，影响当前闭包结束之前的所有内容。特别是，文件顶部的内联选项影响整个文件：

.. code-block:: lua
   :linenos:

   -- luacheck: globals g1 g2, ignore foo
   local foo = g1(g2) -- 没有发出警告。

   -- 以下未使用的函数不被报告。
   local function f() -- luacheck: ignore
      -- luacheck: globals g3
      g3() -- 没有警告。
   end
   
   g3() -- 发出警告，因为定义 g3 的内联选项只影响函数 f。

要对内联选项可见性进行细粒度控制，请使用 ``luacheck: push`` 和 ``luacheck: pop`` 指令：

.. code-block:: lua
   :linenos:

   -- luacheck: push ignore foo
   foo() -- 没有警告。
   -- luacheck: pop
   foo() -- 发出警告。
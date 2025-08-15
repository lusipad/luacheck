配置文件
========

``luacheck`` 尝试从当前目录中的 ``.luacheckrc`` 文件加载配置。如果未找到，它将在父目录中查找，依此类推，向上直到到达文件系统根目录。可以使用 ``--config`` 选项设置配置路径，在这种情况下，它将在递归加载期间使用。配置中的路径相对于加载它的目录进行解释。

可以使用 ``--no-config`` 标志禁用配置加载。

如果既未使用 ``--config``、``--no-config`` 也未使用 ``--no-default-config`` 选项，``luacheck`` 将尝试从 ``--default-config`` 选项的值加载配置，
或者默认在 Windows 上为 ``%LOCALAPPDATA%\Luacheck\.luacheckrc``，在 OS X/macOS 上为 ``~/Library/Application Support/Luacheck/.luacheckrc``，在其他系统上为 ``$XDG_CONFIG_HOME/luacheck/.luacheckrc``
或 ``~/.config/luacheck/.luacheckrc``。默认配置中的路径相对于当前目录进行解释。

配置只是一个由 ``luacheck`` 执行的 Lua 脚本。它可以通过分配给全局变量或返回一个以选项名称为键的表来设置各种选项。

从配置加载的选项优先级最低：可以使用 CLI 选项或内联选项覆盖它们。

.. _options:

配置选项
------

============================= ======================================== ===================
选项                            类型                                     默认值
============================= ======================================== ===================
``quiet``                     0..3 范围内的整数                        ``0``
``color``                     布尔值                                  ``true``
``codes``                     布尔值                                  ``false``
``ranges``                    布尔值                                  ``false``
``formatter``                 字符串或函数                           ``"default"``
``cache``                     布尔值或字符串                        ``false``
``jobs``                      正整数                                 ``1``
``exclude_files``             字符串数组                             ``{}``
``include_files``             字符串数组                             （包含所有文件）
``global``                    布尔值                                  ``true``
``unused``                    布尔值                                  ``true``
``redefined``                 布尔值                                  ``true``
``unused_args``               布尔值                                  ``true``
``unused_secondaries``        布尔值                                  ``true``
``self``                      布尔值                                  ``true``
``std``                       字符串或标准全局变量集                 ``"max"``
``globals``                   字符串数组或字段定义映射              ``{}``
``new_globals``               字符串数组或字段定义映射              （不覆盖）
``read_globals``              字符串数组或字段定义映射              ``{}``
``new_read_globals``          字符串数组或字段定义映射              （不覆盖）
``not_globals``               字符串数组                             ``{}``
``compat``                    布尔值                                  ``false``
``allow_defined``             布尔值                                  ``false``
``allow_defined_top``         布尔值                                  ``false``
``module``                    布尔值                                  ``false``
``max_line_length``           数字或 ``false``                       ``120``
``max_code_line_length``      数字或 ``false``                       ``120``
``max_string_line_length``    数字或 ``false``                       ``120``
``max_comment_line_length``   数字或 ``false``                       ``120``
``max_cyclomatic_complexity`` 数字或 ``false``                       ``false``
``ignore``                    模式数组（见 :ref:`patterns`）        ``{}``
``enable``                    模式数组                               ``{}``
``only``                      模式数组                               （不过滤）
============================= ======================================== ===================

一个使 ``luacheck`` 确保只使用 Lua 5.1、Lua 5.2、Lua 5.3 和 LuaJIT 2.0 可移植交集的全局变量，并禁用未使用参数检测的配置示例：

.. code-block:: lua
   :linenos:

   std = "min"
   ignore = {"212"}

.. _custom_stds:

自定义全局变量集
--------------

``std`` 选项允许使用表设置自定义标准全局变量集。该表可以有两个字段：``globals`` 和 ``read_globals``。
两者都应包含定义一些全局变量的字段定义映射。定义全局变量的最简单方法是列出它们的名称：

.. code-block:: lua
   :linenos:

   std = {
      globals = {"foo", "bar"}, -- 这些全局变量可以被设置和访问。
      read_globals = {"baz", "quux"} -- 这些全局变量只能被访问。
   }

对于这样定义的全局变量，Luacheck 还会考虑其中的任何字段都已定义。要定义具有受限字段集的全局变量，使用
全局变量名作为键，表作为值。在该表中，``fields`` 子表可以包含相同格式的字段：

.. code-block:: lua
   :linenos:

   std = {
      read_globals = {
         foo = { -- 定义只读全局变量 `foo`...
            fields = {
               field1 = { -- `foo.field1` 现在已定义...
                  fields = {
                     nested_field = {} -- `foo.field1.nested_field` 现在已定义...
                  }
               },
               field2 = {} -- `foo.field2` 已定义。
            }
         }
      }
   }

全局变量和字段可以使用布尔值的 ``read_only`` 属性标记为只读或非只读。
属性 ``other_fields`` 控制全局变量或字段是否也可以包含其他未指定的字段：

.. code-block:: lua
   :linenos:

   std = {
      read_globals = {
         foo = { -- `foo` 及其字段默认为只读（因为它们在 `read_globals` 表内）。
            fields = {
               bar = {
                  read_only = false, -- `foo.bar` 不是只读的，可以被设置。
                  other_fields = true, -- `foo.bar[anything]` 已定义并且可以被设置或修改（继承自 `foo.bar`）。
                  fields = {
                     baz = {read_only = true}, -- `foo.bar.baz` 作为例外是只读的。
                  }
               }
            }
         }
      }
   }

可以通过改变全局 ``stds`` 变量为自定义集命名，以便它们随后可以在 ``--std`` CLI 选项
以及 ``std`` 内联和配置选项中使用。

.. code-block:: lua
   :linenos:

   stds.some_lib = {...}
   std = "min+some_lib"

在配置中，``globals``、``new_globals``、``read_globals`` 和 ``new_read_globals`` 也可以包含相同格式的定义：

.. code-block:: lua
   :linenos:

   read_globals = {
      server = {
         fields = {
            -- 允许使用任何键修改 `server.sessions`...
            sessions = {read_only = false, other_fields = true},
            -- 其他字段...
         }
      },
      --- 其他全局变量...
   }

按文件和按路径覆盖
------------------

``luacheck`` 加载配置的环境包含一个特殊的全局变量 ``files``。当检查文件 ``<path>`` 时，如果 ``<glob>`` 匹配 ``<path>``，``luacheck`` 将用 ``files[<glob>]`` 中的条目覆盖主配置中的选项，首先应用更通用 glob 的条目。例如，以下配置只为 ``src/dir`` 中的文件重新启用未使用参数的检测，但不为以 ``_special.lua`` 结尾的文件启用：

.. code-block:: lua
   :linenos:

   std = "min"
   ignore = {"212"}
   files["src/dir"] = {enable = {"212"}}
   files["src/dir/**/*_special.lua"] = {ignore = {"212"}}

请注意，``files`` 表支持自动生成，因此

.. code-block:: lua

   files["src/dir"].enable = {"212"}

和

.. code-block:: lua

   files["src/dir"] = {enable = {"212"}}

是等效的。

默认按路径 std 覆盖
------------------

``luacheck`` 使用一组默认的按路径覆盖：

.. code-block:: lua
   :linenos:

   files["**/spec/**/*_spec.lua"].std = "+busted"
   files["**/test/**/*_spec.lua"].std = "+busted"
   files["**/tests/**/*_spec.lua"].std = "+busted"
   files["**/*.rockspec"].std = "+rockspec"
   files["**/*.luacheckrc"].std = "+luacheckrc"

这些都可以通过在 ``files`` 中为相应键设置不同的 ``std`` 值来覆盖。
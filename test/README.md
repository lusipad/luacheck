# ks 语言测试套件说明

本目录包含了 ks 语言支持的完整测试套件，用于验证 Luacheck 对 ks 语言的正确实现。

## 目录结构

```
test/
├── sample.ks                    # 原始 ks 示例文件
├── basic_ks_example.ks          # 基础 ks 语言示例
├── advanced_ks_example.ks       # 高级 ks 语言应用示例
├── ks_vs_lua_comparison.ks      # ks 语言与标准 Lua 对比示例
├── ks_features_demo.ks          # ks 语言特性完整演示
├── test_ks_automation.lua       # 基础功能自动化测试
├── test_ks_comparison.lua      # 对比测试
├── test_ks_boundary.lua         # 边界和错误处理测试
└── test_ks_comprehensive.lua    # 综合测试运行器
```

## 示例文件说明

### 1. basic_ks_example.ks
展示 ks 语言的基础特性：
- 0-based 数组和字符串索引
- getlength() 函数的使用
- # 作为全局表标识符
- 基本循环和条件语句

### 2. advanced_ks_example.ks
展示 ks 语言的实际应用：
- 学生管理系统模拟
- 面向对象编程
- 复杂数据结构处理
- # 全局表的实际应用

### 3. ks_vs_lua_comparison.ks
详细对比 ks 语言和标准 Lua 的区别：
- 数组索引对比
- 长度获取对比
- # 运算符对比
- 循环遍历对比
- 字符串索引对比

### 4. ks_features_demo.ks
全面展示 ks 语言的各种特性：
- 数据结构实现（栈、队列）
- 文件操作模拟
- 网络请求模拟
- 数学计算工具
- 复杂的全局表使用

## 测试文件说明

### 1. test_ks_automation.lua
**基础功能自动化测试**

测试 ks 语言的核心功能：
- ✅ 0-based 索引访问
- ✅ getlength() 函数
- ✅ # 全局表定义和访问
- ✅ 字符串 0-based 索引
- ✅ 循环遍历
- ✅ 嵌套 # 全局表
- ✅ 函数参数传递
- ✅ 多维数组
- ✅ 条件语句
- ✅ 复杂数据结构

运行方式：
```bash
lua test_ks_automation.lua
```

### 2. test_ks_comparison.lua
**对比测试**

对比 ks 语言和标准 Lua 的行为差异：
- # 运算符行为对比
- 数组索引访问对比
- # 作为标识符对比
- 循环遍历对比
- 字符串索引对比
- 兼容性测试

运行方式：
```bash
lua test_ks_comparison.lua
```

### 3. test_ks_boundary.lua
**边界和错误处理测试**

测试边界情况和错误处理：
- 空数组访问
- 数组越界访问
- 负数索引
- 空字符串访问
- 大数组处理
- 深层嵌套访问
- 错误参数处理
- 混合使用测试
- 性能测试

运行方式：
```bash
lua test_ks_boundary.lua
```

### 4. test_ks_comprehensive.lua
**综合测试运行器**

统一的测试运行器，可以：
- 运行所有测试
- 运行特定测试套件
- 验证示例文件
- 生成详细测试报告

运行方式：
```bash
# 运行所有测试
lua test_ks_comprehensive.lua

# 运行基础功能测试
lua test_ks_comprehensive.lua --basic

# 运行对比测试
lua test_ks_comprehensive.lua --compare

# 运行边界测试
lua test_ks_comprehensive.lua --boundary

# 显示帮助
lua test_ks_comprehensive.lua --help
```

## 测试覆盖范围

### 功能测试
- [x] 0-based 数组索引
- [x] 0-based 字符串索引
- [x] getlength() 函数
- [x] # 全局表定义
- [x] # 全局表访问
- [x] 嵌套 # 全局表
- [x] 循环和条件语句
- [x] 函数定义和调用
- [x] 表和对象操作
- [x] 多维数组
- [x] 字符串操作

### 边界测试
- [x] 空数组处理
- [x] 数组越界访问
- [x] 负数索引
- [x] 空字符串处理
- [x] 大数组处理
- [x] 深层嵌套访问
- [x] 递归调用
- [x] 性能测试

### 错误处理测试
- [x] 无效 getlength 参数
- [x] 未定义 # 全局表访问
- [x] 混合使用 # 和 getlength
- [x] 变量名冲突
- [x] 语法错误检测
- [x] 类型错误检测

### 对比测试
- [x] 标准 Lua vs ks 语言
- [x] 兼容性测试
- [x] 行为差异验证
- [x] 迁移指南验证

## 使用建议

### 1. 开发阶段
```bash
# 运行基础功能测试
lua test_ks_comprehensive.lua --basic

# 验证特定功能
lua test_ks_automation.lua
```

### 2. 测试阶段
```bash
# 运行完整测试套件
lua test_ks_comprehensive.lua

# 检查边界情况
lua test_ks_comprehensive.lua --boundary

# 验证兼容性
lua test_ks_comprehensive.lua --compare
```

### 3. 部署阶段
```bash
# 运行所有测试确保质量
lua test_ks_comprehensive.lua

# 验证示例文件完整性
lua test_ks_comprehensive.lua
```

## 预期结果

所有测试应该通过，预期结果：
- 基础功能测试：10/10 通过
- 对比测试：成功验证差异
- 边界测试：正确处理边界情况
- 错误处理测试：正确报告错误
- 示例文件：全部有效

## 故障排除

如果测试失败，请检查：
1. Luacheck 是否正确编译
2. ks 语言支持是否正确实现
3. 示例文件是否存在
4. 测试文件是否有语法错误

## 贡献指南

如需添加新的测试用例：
1. 在相应的测试文件中添加测试用例
2. 确保测试用例覆盖新功能
3. 更新测试说明文档
4. 验证所有测试通过

## 版本历史

- v1.0.0: 初始版本，包含完整的测试套件
- v0.9.0: 基础功能测试
- v0.8.0: 示例文件和基础测试
-- ks 语言特性展示
-- 全面展示 ks 语言的各种特性和用法

-- =====================================================================
-- 基础数据类型和索引
-- =====================================================================

print("=== 基础数据类型和索引 ===")

-- 数组 (0-based)
local numbers = {10, 20, 30, 40, 50}
for i = 0, getlength(numbers) - 1 do
    print("numbers[" .. i .. "] =", numbers[i])
end

-- 字符串 (0-based)
local message = "Hello World"
print("字符串字符访问:")
for i = 0, getlength(message) - 1 do
    print("message[" .. i .. "] =", message[i])
end

-- =====================================================================
-- 全局表 # 的使用
-- =====================================================================

print("\n=== 全局表 # 的使用 ===")

#config = {
    app_name = "KS Demo",
    version = "1.0.0",
    debug = true,
    features = {
        "zero_based_indexing",
        "getlength_function",
        "hash_as_global"
    }
}

#database = {
    host = "localhost",
    port = 3306,
    username = "admin",
    password = "secret"
}

#utils = {
    format_date = function(timestamp)
        return "2024-01-01"  -- 简化的日期格式化
    end,
    
    calculate_tax = function(amount, rate)
        return amount * (rate / 100)
    end,
    
    validate_email = function(email)
        return email:find("@") ~= nil
    end
}

print("配置信息:")
print("应用名称:", #config.app_name)
print("版本:", #config.version)
print("调试模式:", #config.debug)
print("功能列表长度:", getlength(#config.features))

print("数据库配置:")
print("主机:", #database.host)
print("端口:", #database.port)

print("工具函数测试:")
print("税费计算:", #utils.calculate_tax(1000, 10))
print("邮箱验证:", #utils.validate_email("test@example.com"))

-- =====================================================================
-- 函数和参数处理
-- =====================================================================

print("\n=== 函数和参数处理 ===")

local function create_person(name, age, hobbies)
    return {
        name = name,
        age = age,
        hobbies = hobbies or {},
        introduce = function(self)
            print("大家好，我是" .. self.name .. "，今年" .. self.age .. "岁")
            if getlength(self.hobbies) > 0 then
                print("我的爱好有:")
                for i = 0, getlength(self.hobbies) - 1 do
                    print("  - " .. self.hobbies[i])
                end
            end
        end,
        add_hobby = function(self, hobby)
            self.hobbies[getlength(self.hobbies)] = hobby
        end
    }
end

local person = create_person("小明", 25, {"编程", "阅读", "旅行"})
person:introduce()
person:add_hobby("音乐")
person:introduce()

-- =====================================================================
-- 数据结构和算法
-- =====================================================================

print("\n=== 数据结构和算法 ===")

-- 栈的实现
local Stack = {
    new = function()
        return {items = {}, top = -1}
    end,
    
    push = function(self, item)
        self.top = self.top + 1
        self.items[self.top] = item
    end,
    
    pop = function(self)
        if self.top < 0 then
            return nil
        end
        local item = self.items[self.top]
        self.items[self.top] = nil
        self.top = self.top - 1
        return item
    end,
    
    peek = function(self)
        if self.top < 0 then
            return nil
        end
        return self.items[self.top]
    end,
    
    is_empty = function(self)
        return self.top < 0
    end,
    
    size = function(self)
        return self.top + 1
    end
}

local stack = Stack.new()
stack:push("第一")
stack:push("第二")
stack:push("第三")

print("栈操作:")
print("栈大小:", stack:size())
print("栈顶元素:", stack:peek())
print("弹出元素:", stack:pop())
print("弹出元素:", stack:pop())
print("栈大小:", stack:size())

-- 队列的实现
local Queue = {
    new = function()
        return {items = {}, front = 0, rear = 0}
    end,
    
    enqueue = function(self, item)
        self.items[self.rear] = item
        self.rear = self.rear + 1
    end,
    
    dequeue = function(self)
        if self.front >= self.rear then
            return nil
        end
        local item = self.items[self.front]
        self.items[self.front] = nil
        self.front = self.front + 1
        return item
    end,
    
    is_empty = function(self)
        return self.front >= self.rear
    end,
    
    size = function(self)
        return self.rear - self.front
    end
}

local queue = Queue.new()
queue:enqueue("A")
queue:enqueue("B")
queue:enqueue("C")

print("\n队列操作:")
print("队列大小:", queue:size())
print("出队元素:", queue:dequeue())
print("出队元素:", queue:dequeue())
print("队列大小:", queue:size())

-- =====================================================================
-- 文件操作示例
-- =====================================================================

print("\n=== 文件操作示例 ===")

#file_operations = {
    read_file = function(filename)
        -- 模拟文件读取
        local content = "这是文件内容的第一行\n这是第二行\n这是第三行"
        return content
    end,
    
    write_file = function(filename, content)
        -- 模拟文件写入
        print("写入文件 " .. filename .. " 成功")
        return true
    end,
    
    process_lines = function(content)
        local lines = {}
        for line in content:gmatch("([^\n]+)") do
            lines[getlength(lines)] = line
        end
        return lines
    end
}

local file_content = #file_operations.read_file("example.txt")
local lines = #file_operations.process_lines(file_content)

print("文件内容:")
for i = 0, getlength(lines) - 1 do
    print("行 " .. i .. ": " .. lines[i])
end

-- =====================================================================
-- 网络请求模拟
-- =====================================================================

print("\n=== 网络请求模拟 ===")

#network = {
    requests = {},
    
    send_request = function(self, url, method, data)
        local request = {
            url = url,
            method = method or "GET",
            data = data,
            timestamp = os.time()
        }
        self.requests[getlength(self.requests)] = request
        return {status = 200, response = "请求成功"}
    end,
    
    get_request_history = function(self)
        return self.requests
    end,
    
    clear_history = function(self)
        self.requests = {}
    end
}

local response1 = #network.send_request("https://api.example.com/users", "GET")
local response2 = #network.send_request("https://api.example.com/posts", "POST", "{title: 'Hello'}")

print("请求历史:")
local history = #network:get_request_history()
for i = 0, getlength(history) - 1 do
    local req = history[i]
    print(string.format("请求 %d: %s %s", i + 1, req.method, req.url))
end

-- =====================================================================
-- 数学计算示例
-- =====================================================================

print("\n=== 数学计算示例 ===")

#math_utils = {
    factorial = function(n)
        if n <= 1 then
            return 1
        end
        return n * #math_utils.factorial(n - 1)
    end,
    
    fibonacci = function(n)
        if n <= 1 then
            return n
        end
        return #math_utils.fibonacci(n - 1) + #math_utils.fibonacci(n - 2)
    end,
    
    is_prime = function(n)
        if n <= 1 then
            return false
        end
        for i = 2, math.sqrt(n) do
            if n % i == 0 then
                return false
            end
        end
        return true
    end
}

print("数学计算:")
print("5! =", #math_utils.factorial(5))
print("斐波那契数列第10项:", #math_utils.fibonacci(10))
print("17是质数吗?", #math_utils.is_prime(17) and "是" or "否")

-- =====================================================================
-- 程序结束
-- =====================================================================

print("\n=== ks 语言特性展示完成 ===")
print("总计演示了:")
print("- 0-based 数组和字符串索引")
print("- getlength() 函数的使用")
print("- # 全局表的定义和访问")
print("- 函数定义和调用")
print("- 数据结构实现 (栈、队列)")
print("- 文件操作模拟")
print("- 网络请求模拟")
print("- 数学计算工具")
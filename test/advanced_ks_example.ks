-- ks 语言实际应用示例
-- 模拟一个简单的学生管理系统

#students = {}  -- 全局学生表
#courses = {}   -- 全局课程表

-- 学生类
local Student = {
    new = function(name, id)
        return {
            name = name,
            id = id,
            grades = {},
            add_grade = function(self, course, grade)
                self.grades[course] = grade
            end,
            get_average = function(self)
                local sum = 0
                local count = 0
                for course, grade in pairs(self.grades) do
                    sum = sum + grade
                    count = count + 1
                end
                return count > 0 and sum / count or 0
            end
        }
    end
}

-- 课程类
local Course = {
    new = function(name, code)
        return {
            name = name,
            code = code,
            students = {},
            add_student = function(self, student)
                self.students[getlength(self.students)] = student
            end,
            get_student_count = function(self)
                return getlength(self.students)
            end
        }
    end
}

-- 初始化一些课程
#courses.math = Course.new("数学", "MATH101")
#courses.physics = Course.new("物理", "PHYS101")
#courses.chemistry = Course.new("化学", "CHEM101")

-- 创建一些学生
local function create_students()
    local students = {}
    local names = {"张三", "李四", "王五", "赵六", "钱七"}
    
    for i = 0, getlength(names) - 1 do
        local student = Student.new(names[i], 1000 + i)
        students[i] = student
        #students[student.id] = student  -- 用 #students 存储学生信息
    end
    
    return students
end

local students = create_students()

-- 为学生添加课程和成绩
local function enroll_students()
    -- 张三学习所有课程
    students[0]:add_grade("math", 95)
    students[0]:add_grade("physics", 88)
    students[0]:add_grade("chemistry", 92)
    
    -- 李四学习数学和物理
    students[1]:add_grade("math", 87)
    students[1]:add_grade("physics", 91)
    
    -- 王五学习物理和化学
    students[2]:add_grade("physics", 85)
    students[2]:add_grade("chemistry", 89)
    
    -- 赵六学习数学和化学
    students[3]:add_grade("math", 93)
    students[3]:add_grade("chemistry", 86)
    
    -- 钱七只学习数学
    students[4]:add_grade("math", 90)
end

enroll_students()

-- 将学生添加到课程中
for i = 0, getlength(students) - 1 do
    #courses.math:add_student(students[i])
    if i < 4 then  -- 前4个学生学习物理
        #courses.physics:add_student(students[i])
    end
    if i ~= 1 and i ~= 4 then  -- 除了李四和钱七，都学习化学
        #courses.chemistry:add_student(students[i])
    end
end

-- 打印学生信息
local function print_student_info()
    print("=== 学生信息 ===")
    for i = 0, getlength(students) - 1 do
        local student = students[i]
        print(string.format("学号: %d, 姓名: %s, 平均分: %.1f", 
              student.id, student.name, student:get_average()))
        
        print("  成绩:")
        for course, grade in pairs(student.grades) do
            print("    %s: %d", course, grade)
        end
        print()
    end
end

-- 打印课程信息
local function print_course_info()
    print("=== 课程信息 ===")
    print(string.format("数学课程学生数: %d", #courses.math:get_student_count()))
    print(string.format("物理课程学生数: %d", #courses.physics:get_student_count()))
    print(string.format("化学课程学生数: %d", #courses.chemistry:get_student_count()))
    print()
end

-- 使用 # 工具表进行统计
#stats = {
    calculate_class_average = function(students)
        local total = 0
        for i = 0, getlength(students) - 1 do
            total = total + students[i]:get_average()
        end
        return total / getlength(students)
    end,
    
    find_top_student = function(students)
        local top_student = students[0]
        local top_grade = top_student:get_average()
        
        for i = 1, getlength(students) - 1 do
            local grade = students[i]:get_average()
            if grade > top_grade then
                top_student = students[i]
                top_grade = grade
            end
        end
        
        return top_student, top_grade
    end
}

-- 运行统计和打印结果
print_student_info()
print_course_info()

local class_avg = #stats.calculate_class_average(students)
local top_student, top_grade = #stats.find_top_student(students)

print("=== 统计结果 ===")
print(string.format("班级平均分: %.1f", class_avg))
print(string.format("最高分学生: %s (%.1f分)", top_student.name, top_grade))

print("\n=== 程序运行完成 ===")
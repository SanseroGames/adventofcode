#!/usr/bin/lua

-- Base Op

Op = {}

function Op:new()
    local newObj = {name = 'Invalid'}
    self.__index = self
    return setmetatable(newObj, self)
end

function Op.parseArgModes(op, numArgs)
    local argModes = {}
    local modes = op//100
    for i = 1, numArgs do 
       argModes[i] = modes % 10
       modes = modes // 10
    end
    return argModes
end

function Op.resolveRead(addr, mode, program)
    if mode == 0 then
        return program[addr + 1]
    else
        return addr
    end       
end

function Op:execute()
    assert(false, "Invalid Operator")
end 

-- Length includes the operator and the arguments
function Op:__len()
    return 1
end

-- Operators

Add = Op:new()
function Add:new(op, arg1, arg2, dest)
    local newObj = {name = 'Add', arg1 = arg1, arg2 = arg2, dest = dest, argModes = Op.parseArgModes(op, 3)}
    self.__index = self
    return setmetatable(newObj, self)
end
function Add:execute(program)
    return self.dest, Op.resolveRead(self.arg1, self.argModes[1], program) + Op.resolveRead(self.arg2, self.argModes[2], program)
end
function Add:__len()
   return 4 
end

--

Mult = Op:new()
function Mult:new(op, arg1, arg2, dest)
    local newObj = {name = 'Mult', arg1 = arg1, arg2 = arg2, dest = dest, argModes = Op.parseArgModes(op, 3)}
    self.__index = self
    return setmetatable(newObj, self)
end
function Mult:execute(program)
    return self.dest, Op.resolveRead(self.arg1, self.argModes[1], program) * Op.resolveRead(self.arg2, self.argModes[2], program)
end
function Mult:__len()
   return 4
end

--

Read = Op:new()
function Read:new(op, dest)
    local newObj = {name = 'Read', dest = dest, argModes = Op.parseArgModes(op, 1)}
    self.__index = self
    return setmetatable(newObj, self)
end
function Read:execute(program, input)
    return self.dest, table.remove(input, 1)
end
function Read:__len()
   return 2
end

--

Write = Op:new()
function Write:new(op, arg1)
    local newObj = {name = 'Write', arg1 = arg1, argModes = Op.parseArgModes(op, 1)}
    self.__index = self
    return setmetatable(newObj, self)
end
function Write:execute(program)
    return nil, nil, nil, Op.resolveRead(self.arg1, self.argModes[1], program)
end
function Write:__len()
   return 2
end

--

JumpNZ = Op:new()
function JumpNZ:new(op, cond, target)
    local newObj = {name = 'JumpNZ', cond = cond, target = target, argModes = Op.parseArgModes(op, 2)}
    self.__index = self
    return setmetatable(newObj, self)
end
function JumpNZ:execute(program)
    if Op.resolveRead(self.cond, self.argModes[1], program) ~= 0 then
        return nil, nil, Op.resolveRead(self.target, self.argModes[2], program)
    end
end
function JumpNZ:__len()
   return 3
end

--

JumpZ = Op:new()
function JumpZ:new(op, cond, target)
    local newObj = {name = 'JumpZ', cond = cond, target = target, argModes = Op.parseArgModes(op, 2)}
    self.__index = self
    return setmetatable(newObj, self)
end
function JumpZ:execute(program)
    if Op.resolveRead(self.cond, self.argModes[1], program) == 0 then
        return nil, nil, Op.resolveRead(self.target, self.argModes[2], program)
    end
end
function JumpZ:__len()
   return 3
end

--

Less = Op:new()
function Less:new(op, arg1, arg2, dest)
    local newObj = {name = 'Less', arg1 = arg1, arg2 = arg2, dest = dest, argModes = Op.parseArgModes(op, 3)}
    self.__index = self
    return setmetatable(newObj, self)
end
function Less:execute(program)
    if Op.resolveRead(self.arg1, self.argModes[1], program) < Op.resolveRead(self.arg2, self.argModes[2], program) then
        return self.dest, 1
    else 
        return self.dest, 0
    end
end
function Less:__len()
   return 4
end

--

Equal = Op:new()
function Equal:new(op, arg1, arg2, dest)
    local newObj = {name = 'Equal', arg1 = arg1, arg2 = arg2, dest = dest, argModes = Op.parseArgModes(op, 3)}
    self.__index = self
    return setmetatable(newObj, self)
end
function Equal:execute(program)
    if Op.resolveRead(self.arg1, self.argModes[1], program) == Op.resolveRead(self.arg2, self.argModes[2], program) then
        return self.dest, 1
    else 
        return self.dest, 0
    end
end
function Equal:__len()
   return 4
end

--

Halt = Op:new()
function Halt:new(op)
    local newObj = {name = 'Halt', argModes = {}}
    self.__index = self
    return setmetatable(newObj, self)
end
function Halt:execute(program)
    return nil, nil, nil, nil, true
end
function Halt:__len()
   return 1
end

-- All Operators registrered

ops = {
    [1] = Add,
    [2] = Mult,
    [3] = Read,
    [4] = Write,
    [5] = JumpNZ,
    [6] = JumpZ,
    [7] = Less,
    [8] = Equal,
    [99] = Halt
    }

-- Main Program
Amplifier = {}
function Amplifier:new(program)
    local newObj = {program = table.pack(table.unpack(program)), pc = 1}
    self.__index = self
    return setmetatable(newObj, self)
end
function Amplifier:runProgram(input)
    for i = 0, 1000 do
        local op = ops[self.program[self.pc] % 100]
        assert(op, "Invalid operator at pc " .. self.pc .. ": " .. self.program[self.pc])
        op = op:new(self.program[self.pc + 0], self.program[self.pc + 1], self.program[self.pc + 2], self.program[self.pc + 3])
        self.pc = self.pc + #op
        local dest, res, newPc, out, halt = op:execute(self.program, input)
        if dest ~= nil and res ~= nil then
            self.program[dest + 1] = res
        end
        if newPc ~= nil then
           self.pc = newPc+1
        end
        if halt then
            return nil
        end
        if out then
            return out
        end
    end
    assert(false, "Program timed out")
end

function runAmplifier(program, amplifierModes)
    local amp1 = Amplifier:new(program)
    local amp2 = Amplifier:new(program)
    local amp3 = Amplifier:new(program)
    local amp4 = Amplifier:new(program)
    local amp5 = Amplifier:new(program)
    local lastOutput = 0
    local output = 0
    output = amp1:runProgram({amplifierModes[1], output})
    output = amp2:runProgram({amplifierModes[2], output})
    output = amp3:runProgram({amplifierModes[3], output})
    output = amp4:runProgram({amplifierModes[4], output})
    output = amp5:runProgram({amplifierModes[5], output})
    lastOutput = output
    while true do
        output = amp1:runProgram({output})
        if not output then
            return lastOutput
        end
        output = amp2:runProgram({output})
        output = amp3:runProgram({output})
        output = amp4:runProgram({output})
        output = amp5:runProgram({output})
        lastOutput = output
    end
    return lastOutput
end

function runAmplifierPermutation(a, size, n, program, allResults)
    if size == 1 then 
        allResults[#allResults + 1] = runAmplifier(program, a)
        return
    end
    for i = 1, size do
        runAmplifierPermutation(a, size - 1, n, program, allResults); 
  
        if size % 2 == 1 then
            a[1], a[size] = a[size], a[1] 
        else
            a[i], a[size] = a[size], a[i]
        end
    end
end

local input = arg[1]
assert(input, "No input file given")

local file = io.open(input, "r")
assert(file, "Could not open file" .. input)
local content = file:read "*a" -- *a or *all reads the whole file
file:close()

local program = {}
for word in string.gmatch(content, '([^,]+)') do
    program[#program+1] = tonumber(word)
end
-- runAmplifier(program, config)

--local config = {0,1,2,3,4}
local config = {5,6,7,8,9}
local allResults = {}
runAmplifierPermutation(config, #config, #config, program, allResults)

local maxVal = 0
for i = 1, #allResults do
    maxVal = math.max(maxVal, allResults[i])
end
print("Maximum is " .. maxVal)


---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2022/1/12 17:16
---

local UITweenNumberText_TextMeshPro = BaseClass("UITweenNumberText_TextMeshPro", UITextMeshProUGUIEx)
local base = UITextMeshProUGUIEx

local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
end

local function OnDestroy(self)
    self:DataDestroy()
    base.OnDestroy(self)
end

local function DataDefine(self)
    self.initNum = false
    self.curNum = 0
    self.targetNum = 0
    self.seq = nil
    self.prefix = ""
    self.suffix = ""
    self.textFunc = nil
    self.decimal = false
    self.separator = false
    self.kmg = false
    self.active = true
end

local function DataDestroy(self)
    self.initNum = nil
    self.curNum = nil
    self.targetNum = nil
    self.seq = nil
    self.prefix = nil
    self.suffix = nil
    self.textFunc = nil
    self.decimal = nil
    self.separator = nil
    self.kmg = nil
    self.active = nil
end

-- 获取当前值
local function GetCurNum(self)
    return self.curNum
end 

-- 获取目标值
local function GetTargetNum(self)
    return self.targetNum
end

-- 立刻设置数值
-- num: number 目标值
local function SetNum(self, num)
    assert(type(num) == "number")
    
    self:Stop()
    self.targetNum = num
    self.curNum = num
    self:UpdateText()
    self.initNum = true
    self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
end

-- 缓动至数值
-- targetNum: number 目标值
-- duration: number 持续时间
-- delay: number 起始延迟
-- scale: number 缓动时缩放
-- callback: func 回调
local function TweenToNum(self, targetNum, duration, delay, scale, callback)
    assert(type(targetNum) == "number")
    assert(type(duration) == "number")
    assert(type(delay) == "number" or type(delay) == "nil")
    assert(type(scale) == "number" or type(scale) == "nil")
    assert(type(callback) == "function" or type(callback) == "nil")
    
    if scale == nil then
        scale = 1
    end
    if delay == nil then
        delay = 0
    end
    
    self.targetNum = targetNum
    if self.initNum and duration > 0 then
        self:Stop()
        self.seq = DOTween.Sequence()
        if delay > 0 then
            self.seq:AppendInterval(delay)
        end
        local cutNum = 0
        if self.decimal then
            cutNum = self:GetCutNum(targetNum - self.curNum)
        end
        if scale ~= 1 then
            self.seq
            :Append(self.transform:DOScale(Vector3.New(scale, scale, 1), duration * 0.15))
            :Append(DOTween.To(function(x)
                if self.active then
                    self.curNum = self.decimal and x - x % cutNum or math.floor(x + 0.5)
                    self:UpdateText()
                end
            end, self.curNum, self.targetNum, duration * 0.7))
            :Append(self.transform:DOScale(ResetScale, duration * 0.15))
        else
            self.seq:Append(DOTween.To(function(x)
                if self.active then
                    self.curNum = self.decimal and x - x % cutNum or math.floor(x + 0.5)
                    self:UpdateText()
                end
            end, self.curNum, self.targetNum, duration))
        end
        self.seq:AppendCallback(function()
            if self.active then
                self.curNum = self.targetNum
                self:UpdateText()
                if callback then
                    callback()
                end
            end
        end)
    else
        self:SetNum(targetNum)
        if callback then
            callback()
        end
    end
end

-- 缓动至数值
-- startNum: number 起始值
-- targetNum: number 目标值
-- duration: number 持续时间
-- delay: number 起始延迟
-- scale: number 缓动时缩放
-- callback: func 回调
local function FromNumTweenToNum(self, startNum, targetNum, duration, delay, scale, callback)
    assert(type(startNum) == "number")
    assert(type(targetNum) == "number")
    assert(type(duration) == "number")
    assert(type(delay) == "number" or type(delay) == "nil")
    assert(type(scale) == "number" or type(scale) == "nil")
    assert(type(callback) == "function" or type(callback) == "nil")
    
    self:SetNum(startNum)
    self:TweenToNum(targetNum, duration, delay, scale, callback)
end

-- 获取前缀
local function GetPrefix(self)
    return self.prefix
end

-- 获取后缀
local function GetSuffix(self)
    return self.suffix
end

-- 设置前后缀
local function SetAffix(self, prefix, suffix)
    assert(type(prefix) == "string")
    assert(type(suffix) == "string")
    self:SetPrefix(prefix)
    self:SetSuffix(suffix)
end

-- 设置前缀
local function SetPrefix(self, prefix)
    assert(type(prefix) == "string")
    self.prefix = prefix
end

-- 设置后缀
local function SetSuffix(self, suffix)
    assert(type(suffix) == "string")
    self.suffix = suffix
end

-- 获取缓动队列
local function GetSequence(self)
    return self.seq
end

-- 是否正在缓动
local function IsPlaying(self)
    return self.seq ~= nil and self.seq:IsPlaying()
end

-- 停止缓动
local function Stop(self)
    if self.seq ~= nil then
        self.seq:Kill()
        self.seq = nil
    end
end

-- 设置文本 Setter，如果文本复杂，已有方法不能满足，可以使用 SetTextFunc
local function SetTextFunc(self, func)
    assert(type(func) == "function" or type(func) == "nil")
    self.textFunc = func
end

-- 设置是否显示小数
local function SetDecimal(self, show)
    assert(type(show) == "boolean")
    self.decimal = show
end

-- 设置是否显示千分位分隔符
local function SetSeparator(self, show)
    assert(type(show) == "boolean")
    self.separator = show
end

-- 设置是否显示K, M, G
local function SetKmg(self, show)
    assert(type(show) == "boolean")
    self.kmg = show
end

-- 将当前值展示到文本上
local function UpdateText(self)
    local numStr = tonumber(self.curNum)
    if self.separator then
        numStr = string.GetFormattedSeperatorNum(numStr)
    elseif self.kmg then
        numStr = string.GetFormattedStr(numStr)
    end
    if self.textFunc ~= nil then
        self:SetText(self.textFunc(numStr))
    else
        self:SetText(self.prefix .. numStr .. self.suffix)
    end
end

--获取显示的小数位数 shimin (不能改，其他数学方法全部都有bug)
local function GetCutNum(self,changeVal)
    local result = 1
    local temp = tostring(changeVal)
    local para = string.split_ii_array(temp,".")
    if table.count(para) > 1 then
        local sub = string.len(para[2])
        for i=1,sub,1 do
            result = result * 0.1
        end
    end
    return  result
end

UITweenNumberText_TextMeshPro.OnCreate = OnCreate
UITweenNumberText_TextMeshPro.OnDestroy = OnDestroy
UITweenNumberText_TextMeshPro.DataDefine = DataDefine
UITweenNumberText_TextMeshPro.DataDestroy = DataDestroy
UITweenNumberText_TextMeshPro.GetCurNum = GetCurNum
UITweenNumberText_TextMeshPro.GetTargetNum = GetTargetNum
UITweenNumberText_TextMeshPro.SetNum = SetNum
UITweenNumberText_TextMeshPro.TweenToNum = TweenToNum
UITweenNumberText_TextMeshPro.FromNumTweenToNum = FromNumTweenToNum
UITweenNumberText_TextMeshPro.GetSequence = GetSequence
UITweenNumberText_TextMeshPro.GetPrefix = GetPrefix
UITweenNumberText_TextMeshPro.GetSuffix = GetSuffix
UITweenNumberText_TextMeshPro.SetAffix = SetAffix
UITweenNumberText_TextMeshPro.SetPrefix = SetPrefix
UITweenNumberText_TextMeshPro.SetSuffix = SetSuffix
UITweenNumberText_TextMeshPro.IsPlaying = IsPlaying
UITweenNumberText_TextMeshPro.Stop = Stop
UITweenNumberText_TextMeshPro.SetTextFunc = SetTextFunc
UITweenNumberText_TextMeshPro.SetDecimal = SetDecimal
UITweenNumberText_TextMeshPro.SetSeparator = SetSeparator
UITweenNumberText_TextMeshPro.SetKmg = SetKmg
UITweenNumberText_TextMeshPro.UpdateText = UpdateText
UITweenNumberText_TextMeshPro.GetCutNum = GetCutNum

return UITweenNumberText_TextMeshPro
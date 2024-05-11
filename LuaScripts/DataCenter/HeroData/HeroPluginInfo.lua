--- Created by shimin.
--- DateTime: 2023/6/1 18:39
--- 英雄插件数据

local HeroPluginInfo = BaseClass('HeroPluginInfo')

function HeroPluginInfo:__init()
    self.lv = 0				--int 当前插件等级
    self.plugin = {}		--{插件id}  当前插件
    self.lockPlugin = {}		--{index, true} 锁定的插件 客户端主动 +1
    self.tmpPlugin = {}		--{插件id} 随机的临时插件
end

function HeroPluginInfo:__delete()
    self.lv = 0				--int 当前插件等级
    self.plugin = {}		--{插件id}  当前插件
    self.lockPlugin = {}		--{index, true} 锁定的插件 客户端主动 +1
    self.tmpPlugin = {}		--{插件id} 随机的临时插件
end

function HeroPluginInfo:UpdateInfo(message)
    if message == nil then
        return
    end

    self.lv = message["lv"]
    self.plugin = {}
    local temp = message["plugin"]
    if temp ~= nil and temp ~= "" then
        local spl = string.split_ss_array(temp, ";")
        for k, v in ipairs(spl) do
            local spl1 = string.split_ii_array(v, ",")
            local param = {}
            param.id = spl1[1] or 0
            param.level = spl1[2] or 0
            table.insert(self.plugin, param)
        end
    end

    self.lockPlugin = {}
    temp = message["lockPlugin"]
    if temp ~= nil and temp ~= "" then
        local list = string.split_ii_array(temp, "|")
        for k,v in ipairs(list) do
            self.lockPlugin[v + 1] = true
        end
    end

    self.tmpPlugin = {}
    temp = message["tmpPlugin"]
    if temp ~= nil and temp ~= "" then
        local spl = string.split_ss_array(temp, ";")
        for k, v in ipairs(spl) do
            local spl1 = string.split_ii_array(v, ",")
            local param = {}
            param.id = spl1[1] or 0
            param.level = spl1[2] or 0
            table.insert(self.tmpPlugin, param)
        end
    end
end

--是否锁定
function HeroPluginInfo:IsLock(index)
    return self.lockPlugin[index] == true
end

--获取锁定的数量
function HeroPluginInfo:GetLockPluginNum()
    return table.count(self.lockPlugin)
end

--获取插件的数量
function HeroPluginInfo:GetPluginNum()
    return table.count(self.plugin)
end

--获取插件的分数（固定 + 随机）
function HeroPluginInfo:GetScore()
    local result = 0
    local list = DataCenter.RandomPlugTemplateManager:GetMainTemplateByLevel(self.lv)
    if list ~= nil then
        for k, v in ipairs(list) do
            result = result + v:GetConstScore()
        end
    end
    
    for k, v in ipairs(self.plugin) do
        local template = DataCenter.RandomPlugTemplateManager:GetTemplate(v.id)
        if template ~= nil then
            result = result + template:GetScore(v.level)
        end
    end
    return result
end

--获取随机插件的分数（固定 + 随机）
function HeroPluginInfo:GetTmpScore()
    local result = 0
    local list = DataCenter.RandomPlugTemplateManager:GetMainTemplateByLevel(self.lv)
    if list ~= nil then
        for k, v in ipairs(list) do
            result = result + v:GetConstScore()
        end
    end
    
    for k, v in ipairs(self.tmpPlugin) do
        local template = DataCenter.RandomPlugTemplateManager:GetTemplate(v.id)
        if template ~= nil then
            result = result + template:GetScore(v.level)
        end
    end
    return result
end

return HeroPluginInfo
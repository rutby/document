---
--- Created by zzl.
--- DateTime: 
---
local VIPTemplateManager = BaseClass("VIPTemplateManager", Singleton);
local VipTemplate = require "DataCenter.VIPData.VipTemplate"
local function __init(self)
    self.vipDatas ={}
    self.maxLevel = 0
end

local function __delete(self)
    self.vipDatas =nil
    self.maxLevel = nil
end

local function InitAllTemplate(self)
    local level = 0
    local isOpen = LuaEntry.DataConfig:CheckSwitch("vip_reward2_new") -- 开关
    LocalController:instance():visitTable(self:GetTableName(),function(id,lineData)
        local item = VipTemplate.New()
        item:InitData(lineData,isOpen)
        if self.vipDatas[item.id] == nil then
            level = item.level
            self.vipDatas[item.id] = item
        end
    end)
    self.maxLevel = #self.vipDatas

end

local function GetAllTemplate(self)
    if self.vipDatas ~= nil then
        return self.vipDatas
    end
end


local function GetTemplate(self,level)
    if self.vipDatas[level] == nil then
        local isOpen = LuaEntry.DataConfig:CheckSwitch("vip_reward2_new") -- 开关
        local oneTemplate = LocalController:instance():getLine(self:GetTableName(),level)
        if oneTemplate~=nil then
            local item  = VipTemplate.New()
            item:InitData(oneTemplate,isOpen)
            if item.id ~=nil then
                self.vipDatas[item.id] = item
            end
        end
    end
    return self.vipDatas[level]
end

local function GetFormatAffectValue(self,data)
    if tonumber(data.num_type)  == 1 then
        return  "+"..data.value.."%"
    elseif tonumber(data.num_type)  == 2 then
        if data.value == 0 then
            return "+".. 0 .."%"
        else
            return  "+"..data.value/10 .."%"
        end
    elseif tonumber(data.num_type)  == 0 then
        return "+"..data.value
    elseif tonumber(data.num_type)  == 3 then
        return ""
    end
end

local function GetTableName(self)
    local isOpen = LuaEntry.DataConfig:CheckSwitch("new_vipstore") -- 开关
    if isOpen then
        return TableName.VipTemp
    end
    return TableName.Vip
end

VIPTemplateManager.__init = __init
VIPTemplateManager.__delete = __delete
VIPTemplateManager.InitAllTemplate = InitAllTemplate
VIPTemplateManager.GetAllTemplate = GetAllTemplate
VIPTemplateManager.GetTemplate = GetTemplate
VIPTemplateManager.GetFormatAffectValue = GetFormatAffectValue
VIPTemplateManager.GetTableName = GetTableName
return VIPTemplateManager

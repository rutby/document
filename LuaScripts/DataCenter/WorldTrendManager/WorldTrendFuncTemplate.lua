---
--- Created by zzl
--- DateTime: 
---
local WorldTrendFuncTemplate = BaseClass("WorldTrendFuncTemplate")
local Localization = CS.GameEntry.Localization
local function __init(self)
    self.id = 0                 --功能ID
    self.name = 0               --功能名字
    self.desc = 0        --功能介绍
    self.value = "" --介绍参数
    self.pic = ""
end

local function __delete(self)
    self.id = nil
    self.name = nil
    self.desc = nil
    self.value = nil
    self.pic = nil
end

local function InitData(self,row)
    if row ==nil then
        return
    end
    self.id = row:getValue("id")
    self.name = row:getValue("name")
    self.desc = row:getValue("description")
    self.value = row:getValue("description_value")
    self.pic =  row:getValue("pic")
end

local function GetName(self)
    return  Localization:GetString(self.name)
end

local function GetDesc(self)
    if self.value == "" then
        return Localization:GetString(self.desc)
    else
        local param = string.split(self.value,";")
        if #param == 1 then
            return Localization:GetString(self.desc,param[1])
        elseif  #param == 2 then
            return Localization:GetString(self.desc,param[1],param[2])
        elseif #param == 3 then
            return Localization:GetString(self.desc,param[1],param[2],param[3])
        end
    end
end

local function GetIcon(self)
    return string.format(LoadPath.UIChronicle, self.pic)
end

WorldTrendFuncTemplate.__init = __init
WorldTrendFuncTemplate.__delete = __delete
WorldTrendFuncTemplate.InitData = InitData
WorldTrendFuncTemplate.GetName = GetName
WorldTrendFuncTemplate.GetDesc = GetDesc
WorldTrendFuncTemplate.GetIcon = GetIcon
return WorldTrendFuncTemplate
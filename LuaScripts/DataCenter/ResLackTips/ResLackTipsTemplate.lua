---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2022/11/4 16:13
---

local ResLackTipsTemplate = BaseClass("ResLackTipsTemplate")

local function __init(self)
    self.id = 0
    self.res = 0
    self.tips = 0
    self.order = 0
    self.name = 0
    self.btnName = 0
    self.base = { min = IntMinValue, max = IntMaxValue }
    self.para1 = ""
    self.para2 = ""
    self.pic = ""
    self.group = 0
    self.level = { min = IntMinValue, max = IntMaxValue }
    self.goods = 0
    self.monsterLevelLimit = { min = IntMinValue, max = IntMaxValue }
    self.activeShow = false
    self.pveList = 0
    self.type = 0   --新增系统类型
    self.type_para = 0
    self.need_build = ""
    self.server = ""
end

local function __delete(self)
    self.id = nil
    self.res = nil
    self.tips = nil
    self.order = nil
    self.name = nil
    self.btnName = nil
    self.base = nil
    self.para1 = nil
    self.para2 = nil
    self.pic = nil
    self.group = nil
    self.level = nil
    self.goods = nil
    self.monsterLevelLimit = nil
    self.activeShow = nil
    self.pveList = nil
    self.type = 0
    self.type_para = 0
    self.need_build = ""
    self.server = ""
end

local function InitData(self, row)
    if row == nil then
        return
    end

    self.id = tonumber(row:getValue("id")) or 0
    self.res = tonumber(row:getValue("res")) or 0
    self.tips = tonumber(row:getValue("tips")) or 0
    self.order = tonumber(row:getValue("order")) or 0
    self.name = tonumber(row:getValue("name")) or 0
    self.btnName = tonumber(row:getValue("btn_name")) or 0
    self.base = {}
    local baseStrs = string.split(row:getValue("base") or "", "-")
    if #baseStrs == 2 then
        self.base.min = tonumber(baseStrs[1]) or 0
        self.base.max = tonumber(baseStrs[2]) or 0
    end
    self.para1 = row:getValue("para1") or ""
    self.para2 = row:getValue("para2") or ""
    self.pic = row:getValue("pic") or ""
    self.group = tonumber(row:getValue("group")) or 0
    self.level = {}
    local levelStrs = string.split(row:getValue("level") or "", "-")
    if #levelStrs == 2 then
        self.level.min = tonumber(levelStrs[1]) or 0
        self.level.max = tonumber(levelStrs[2]) or 0
    end
    self.goods = tonumber(row:getValue("goods")) or 0
    self.monsterLevelLimit = {}
    local monsterLevelLimitStrs = string.split(row:getValue("monster_level_limit") or "", "-")
    if #monsterLevelLimitStrs == 2 then
        self.level.min = tonumber(monsterLevelLimitStrs[1]) or 0
        self.level.max = tonumber(monsterLevelLimitStrs[2]) or 0
    end
    self.activeShow = tonumber(row:getValue("active_show")) == 1
    self.pveList = {}
    self.type = tonumber(row:getValue("type")) or 0
    self.type_para = tonumber(row:getValue("type_para")) or 0
    self.need_build = row:getValue("need_build") or ""
    self.server = row:getValue("server") or ""
end

local function CheckMainLevel(self)
    return DataCenter.BuildManager.MainLv >= self.base.min and
           DataCenter.BuildManager.MainLv <= self.base.max
end

local function GetOverallOrder(self)
    return self.order
end

local function CheckServer(self)
    local severId = LuaEntry.Player:GetSelfServerId()
    if self.server and self.server ~= "" then
        local str = string.split(self.server,";")
        for i = 1, #str do
            local str2 = string.split(str[i],"-")
            if str2[2] then --跨服
                if tonumber(str[1]) <= severId and severId <= tonumber(str[2]) then
                    return true
                end
            elseif tonumber(str[1]) == severId then
                return true
            end
        end
        return false
    end
    if self.server == nil or self.server == "" then
        return true
    end
end

ResLackTipsTemplate.__init = __init
ResLackTipsTemplate.__delete = __delete
ResLackTipsTemplate.InitData = InitData
ResLackTipsTemplate.CheckMainLevel = CheckMainLevel
ResLackTipsTemplate.GetOverallOrder = GetOverallOrder
ResLackTipsTemplate.CheckServer = CheckServer

return ResLackTipsTemplate
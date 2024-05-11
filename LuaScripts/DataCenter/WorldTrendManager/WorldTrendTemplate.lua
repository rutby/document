---
--- Created by zzl
--- DateTime: 
---
local WorldTrendTemplate = BaseClass("WorldTrendTemplate")
local Localization = CS.GameEntry.Localization
local function __init(self)
    self.id = 0
    self.name = 0
    self.description = 0
    self.description_tip = ""
    self.description_value = 0
    self.pic = ""
    self.show_time = ""
    self.order = ""
    self.reward_type = 0
    self.show_type = ""
end

local function __delete(self)
    self.id = nil
    self.name = nil
    self.description = nil
    self.description_tip = nil
    self.description_value = nil
    self.pic = nil
    self.show_time = nil
    self.order = nil
    self.reward_type = nil
    self.show_type = ""
end

local function InitData(self,row)
    if row ==nil then
        return
    end
    self.id = row:getValue("id")
    self.name = row:getValue("name")
    self.description = row:getValue("description")
    self.description_tip = row:getValue("description_tip")
    self.description_value = row:getValue("description_value")
    self.pic =  row:getValue("pic")
    self.show_time = row:getValue("show_time")
    self.order = row:getValue("order")
    self.reward_type = row:getValue("reward_type")
    self.show_type = row:getValue("show_type")
end

local function GetIcon(self,isNew)
    if isNew then
        return string.format(LoadPath.UIWorldTrendNew, self.pic)
    else
        return string.format(LoadPath.UIWorldTrend, self.pic)
    end
end

--任务条件标题
local function GetTitle(self)
    if self.reward_type == "" or self.reward_type == "0" then
        return Localization:GetString(302107)
    elseif self.reward_type == "1" then
        return Localization:GetString(302108)
    end
end

--任务类型是否联盟
local function QuestIsAlliance(self)
    if self.reward_type == "1" then
        return true
    end
    return false
end

--根据任务类型获取结束时dialog
local function GetQuestTypeContent(self)
    if self.reward_type == "" or self.reward_type == 0 or self.reward_type == nil then
        return Localization:GetString(302112)
    elseif self.reward_type == "1" then
        return Localization:GetString(302111)
    end
end

--名字描述
local function GetDesc(self)
    local show1 = nil
    local show2 = nil
    local show3 = nil
    
    local param = string.split(self.description_value,";")
    if #param == 1 then
        show1 = param[1]
    elseif  #param == 2 then
        show1 = param[1]
        show2 = param[2]
    elseif #param == 3 then
        show1 = param[1]
        show2 = param[2]
        show3 = param[3]
    end

    if show1 ~= nil and show2 ~= nil and show3 ~= nil then
        if self.description == 302164 or self.description == 302165 then
            show1 = string.GetFormattedSeperatorNum(show1)
            show2 = string.GetFormattedSeperatorNum(show2)
            if show3 == "1" then
                show3 = Localization:GetString(104193)
            elseif show3 == "2" then
                show3 = Localization:GetString(300602)
            end
        elseif self.description == 302713 then
            if show3 == "0" then
                show3 = Localization:GetString(302716)
            elseif show3 == "1" then
                show3 = Localization:GetString(110353)
            elseif show3 == "2" then
                show3 = Localization:GetString(110352)
            end
        end
        return Localization:GetString(self.description,show1,show2,show3)
    elseif show1 ~= nil and show2 ~= nil then
        show1 = string.GetFormattedSeperatorNum(show1)
        --策划要特殊处理
        if self.description == 302100 then
            if show2 == "1" then
                show2 = Localization:GetString(104193)
            elseif show2 == "2" then
                show2 = Localization:GetString(300602)
            end
        end
        return Localization:GetString(self.description,show1,show2)
    elseif show1 ~= nil and show1 ~= "" then
        show1 = string.GetFormattedSeperatorNum(show1)
        return Localization:GetString(self.description,show1)
    else
        return Localization:GetString(self.description)
    end
end

--遗迹任务专用获取遗迹等级
local function GetParam(self)
    local param = string.split(self.description_value,";")
    return param[2]
end

WorldTrendTemplate.__init = __init
WorldTrendTemplate.__delete = __delete
WorldTrendTemplate.InitData = InitData
WorldTrendTemplate.GetIcon = GetIcon
WorldTrendTemplate.GetTitle = GetTitle
WorldTrendTemplate.QuestIsAlliance = QuestIsAlliance
WorldTrendTemplate.GetDesc = GetDesc
WorldTrendTemplate.GetQuestTypeContent = GetQuestTypeContent
WorldTrendTemplate.GetParam = GetParam
return WorldTrendTemplate
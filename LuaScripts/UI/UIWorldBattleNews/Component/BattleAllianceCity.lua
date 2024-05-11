---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/3/28 16:23
---
local BattleAllianceCity = BaseClass("BattleAllianceCity",UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local img_path = "imgBg"
local time_txt_path = "imgBg/timeLabel"
local pos_des_path = "imgBg/cityPosDes"
local des_path= "DesText"
local function OnCreate(self)
    base.OnCreate(self)
    self.img_bg = self:AddComponent(UIImage,img_path)
    self.time_txt = self:AddComponent(UIText,time_txt_path)
    self.pos_des = self:AddComponent(UIText,pos_des_path)
    self.des = self:AddComponent(UIText,des_path)
end

local function SetData(self, data)
    self.time_txt:SetText(UITimeManager:GetInstance():TimeStampToTimeForServerMinute(data.time*1000))
    local atkAbbr = "["..data.atkAbbr.."]"
    local name = GetTableData(TableName.WorldCity, data.cityId, 'name')
    name = Localization:GetString(name)
    local cityInfo = DataCenter.WorldAllianceCityDataManager:GetAllianceCityDataByCityId(data.cityId)
    if cityInfo~=nil and cityInfo.cityName~=nil and cityInfo.cityName~="" then
        name = cityInfo.cityName
    end
    local strPos = ""
    local posStr = GetTableData(TableName.WorldCity, data.cityId, 'location')
    local tabPos = string.split(posStr, '|')
    if (table.count(tabPos) == 2) then
        strPos = " ( ".."X:"..tabPos[1] .. "," .. "Y:"..tabPos[2].." ) "
    end
    local cityLv = GetTableData(TableName.WorldCity, data.cityId, "level")
    local levelStr = "Lv."..tostring(cityLv)
    local totalName = levelStr..name
    self.pos_des:SetText(strPos..atkAbbr)
    if data.newsType == AllianceCityNewsType.OCCUPY_OCCUPIED_CITY then
        local defAbbr = "["..data.defAbbr.."]"
        self.img_bg:LoadSprite("Assets/Main/Sprites/UI/UIWorldBattle/WorldBattleNews_img_cell1.png")
        self.des:SetText(Localization:GetString("302150",atkAbbr,defAbbr,totalName))
    else
        self.img_bg:LoadSprite("Assets/Main/Sprites/UI/UIWorldBattle/WorldBattleNews_img_cell2.png")
        self.des:SetText(Localization:GetString("302149",atkAbbr,totalName))
    end
    
end
BattleAllianceCity.OnCreate = OnCreate
BattleAllianceCity.SetData = SetData
return BattleAllianceCity
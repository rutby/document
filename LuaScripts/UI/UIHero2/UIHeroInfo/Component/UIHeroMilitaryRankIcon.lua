---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zhangliheng.
--- DateTime: 2022/1/18 14:40
---

local UIHeroMilitaryRankIcon = BaseClass("UIHeroMilitaryRankIcon", UIBaseContainer)
local base = UIBaseContainer

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.imgIcon = self:AddComponent(UIImage, 'ImgIcon')
    self.textName = self:AddComponent(UITextMeshProUGUIEx, 'TextName')
    self.imgStages = {}
    for i =1, 4 do
        local stage = self:AddComponent(UIImage, 'ImgSeg' .. i)        
        table.insert(self.imgStages, stage)
    end
end

local function ComponentDestroy(self)
end

local function SetData(self, rankId, nextTip)
    self.imgIcon:LoadSprite(HeroUtils.GetMilitaryRankIcon(rankId))
    local level = GetTableData(TableName.HeroMilitaryRank, rankId, 'level')
    if level == "" then
        level = level
    end

    CS.UIGray.SetGray(self.imgIcon.transform, level == 0, false)
    self.textName:SetText("")
    self.textName:SetLocalText(HeroUtils.GetMilitaryRankName(rankId))
    local stage = tonumber(GetTableData(TableName.HeroMilitaryRank, rankId, "stage"))

    for k, v in ipairs(self.imgStages) do
        v:SetColor((nextTip and k == stage) and Color32.New(200/255, 200/255, 200/255, 1) or Color32.New(1,1,1,1))
        v:SetActive(k < stage)
    end
end

UIHeroMilitaryRankIcon.OnCreate = OnCreate
UIHeroMilitaryRankIcon.OnDestroy = OnDestroy
UIHeroMilitaryRankIcon.ComponentDefine = ComponentDefine
UIHeroMilitaryRankIcon.ComponentDestroy = ComponentDestroy

UIHeroMilitaryRankIcon.SetData = SetData


return UIHeroMilitaryRankIcon
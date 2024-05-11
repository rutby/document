---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/11/14 20:42
---DigActivityLevelPanel.lua

local DigActivityLevelPanel = BaseClass("DigActivityLevelPanel", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local superLvBg_path = "anim (1)/wallAnim/wallTop/superLvBg"
local levelTxt_path = "anim (1)/wallAnim/finalReward/levelBg/curLevel"
local blocks_path = "anim (1)/blocks/blocks/itemLayout/digBlockItem%s"

-- 创建
local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

--控件的定义
local function ComponentDefine(self)
    self.superLvBgN = self:AddComponent(UIBaseContainer, superLvBg_path)
    self.levelTxtN = self:AddComponent(UITextMeshProUGUIEx, levelTxt_path)
    self.blockImgs = {}
    for i = 1, 22 do
        local tempPath = string.format(blocks_path, i)
        local tempBlock = self:AddComponent(UIBaseContainer, tempPath)
        local tempImg = tempBlock:AddComponent(UIImage, "bg")
        table.insert(self.blockImgs, tempImg)
    end
end

--控件的销毁
local function ComponentDestroy(self)
    self.superLvBgN = nil
    self.levelTxtN = nil
    self.blockImgs = nil
end

--变量的定义
local function DataDefine(self)
    
end

--变量的销毁
local function DataDestroy(self)
    
end

local function SetPanel(self, activityId, levelNum)
    self.levelTxtN:SetText(Localization:GetString("372443", levelNum))
    local isSuperLv = DataCenter.DigActivityManager:CheckIfIsSuperLv(activityId, levelNum)
    self.superLvBgN:SetActive(isSuperLv)

    local bgImg = ""
    if isSuperLv then
        bgImg = "Assets/Main/Sprites/UI/UIDigActivity/UIactivities_xb_zhuan_03.png"
    else
        bgImg = "Assets/Main/Sprites/UI/UIDigActivity/UIactivities_xb_zhuan_01.png"
    end
    for i, v in ipairs(self.blockImgs) do
        v:LoadSprite(bgImg)
    end
end



DigActivityLevelPanel.OnCreate = OnCreate
DigActivityLevelPanel.OnDestroy = OnDestroy
DigActivityLevelPanel.ComponentDefine = ComponentDefine
DigActivityLevelPanel.ComponentDestroy = ComponentDestroy
DigActivityLevelPanel.DataDefine = DataDefine
DigActivityLevelPanel.DataDestroy = DataDestroy

DigActivityLevelPanel.SetPanel = SetPanel

return DigActivityLevelPanel
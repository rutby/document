---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/4/12 12:07
---
local BattleAbbr = BaseClass("BattleAbbr",UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local abbr_path = "text"
local icon_path = "icon"
local function OnCreate(self)
    base.OnCreate(self)
    self.abbr_txt= self:AddComponent(UITextMeshProUGUIEx,abbr_path)
    self.icon = self:AddComponent(UIImage,icon_path)
end

local function SetText(self, abbr,icon)
    self.abbr_txt:SetText(abbr)
end

BattleAbbr.OnCreate = OnCreate
BattleAbbr.SetText = SetText
return BattleAbbr
---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/11/16 21:09
---
local MainMiniMapDesItem = BaseClass("MainMiniMapDesItem",UIBaseContainer)
local base = UIBaseContainer
local name_path = "name"
local icon_path = "Image"
local function OnCreate(self)
    base.OnCreate(self)
    self.name_txt= self:AddComponent(UIText,name_path)
    self.icon = self:AddComponent(UIImage,icon_path)
end

local function SetText(self,name)
    self.name_txt:SetText(name)
end

MainMiniMapDesItem.OnCreate = OnCreate
MainMiniMapDesItem.SetText = SetText
return MainMiniMapDesItem
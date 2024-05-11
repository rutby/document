---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 
--- DateTime: 
---
local DesertScoreCell = BaseClass("DesertScoreCell",UIBaseContainer)
local base = UIBaseContainer

local Localization = CS.GameEntry.Localization
local bg_img1 = "Assets/Main/Sprites/UI/UIActivity/UIMigrationwars_bg_reward01.png"
local bg_img2 = "Assets/Main/Sprites/UI/UIActivity/UIMigrationwars_bg_reward02.png"
local function OnCreate(self)
    base.OnCreate(self)
    self._bg_img    = self:AddComponent(UIImage,"")
    self._left_txt  = self:AddComponent(UIText,"Txt_Left")
    self._right_txt = self:AddComponent(UIText,"Txt_Right")
end

local function SetScoreShow(self, data,index)
    self._left_txt:SetLocalText(372598,data.lv)
    self._right_txt:SetText("+"..data.score)
    self._bg_img:LoadSprite(index % 2 == 1 and bg_img1 or bg_img2)
end

local function OnDestroy(self)
    base.OnDestroy(self)
end
DesertScoreCell.OnCreate = OnCreate
DesertScoreCell.SetScoreShow = SetScoreShow
DesertScoreCell.OnDestroy =OnDestroy
return DesertScoreCell
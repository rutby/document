---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zhangliheng.
--- DateTime: 2022/3/8 12:15
---


local UIHeroListTitleLine = BaseClass('UIHeroListTitleLine', UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.imgIcon1 = self:AddComponent(UIImage, 'ImgIcon1')
    self.imgIcon2 = self:AddComponent(UIImage, 'ImgIcon2')
    self.textName = self:AddComponent(UITextMeshProUGUIEx, 'TextName')
    self.btnTip   = self:AddComponent(UIButton, 'BtnTip')
    self.btnTip:SetOnClick(BindCallback(self, self.OnBtnTipClick))
end

local function ComponentDestroy(self)
end

local function SetData(self, masterToInt)
    self.masterToInt = masterToInt
    
    self.imgIcon1:SetActive(masterToInt == 1)
    self.imgIcon2:SetActive(masterToInt ~= 1)
    self.textName:SetLocalText(masterToInt == 1 and 100275 or 129207) --英雄、海报
end

local function OnBtnTipClick(self)
    local UIHeroTipView = require "UI.UIHero2.UIHeroTip.View.UIHeroTipView"
    local content = Localization:GetString(self.masterToInt == 1 and 129209 or 129210)

    local scaleFactor = UIManager:GetInstance():GetScaleFactor()

    local position = self.btnTip.transform.position + Vector3.New(0, -30, 0) * scaleFactor
    local param = UIHeroTipView.Param.New()
    param.content = content
    param.dir = UIHeroTipView.Direction.BELOW
    param.defWidth = 260
    param.pivot = 0.15
    param.position = position
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, { anim = false }, param)
end


UIHeroListTitleLine.OnCreate= OnCreate
UIHeroListTitleLine.OnDestroy = OnDestroy
UIHeroListTitleLine.ComponentDefine = ComponentDefine
UIHeroListTitleLine.ComponentDestroy = ComponentDestroy
UIHeroListTitleLine.SetData = SetData
UIHeroListTitleLine.OnBtnTipClick = OnBtnTipClick


return UIHeroListTitleLine
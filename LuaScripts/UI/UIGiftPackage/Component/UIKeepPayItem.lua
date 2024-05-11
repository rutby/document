---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/1/4 11:15
---

local UIKeepPayItem = BaseClass("UIKeepPayItem", UIBaseContainer)
local base = UIBaseContainer

local bg_path = "Bg"
local circle_path = "Circle"
local box_path = "Bg/Box"
local day_path = "Bg/DayBg/DayText"

local IconPath = "Assets/Main/Sprites/UI/UIKeepPay/dailyprogress_icon_treasure" 

local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.bg_btn = self:AddComponent(UIButton, bg_path)
    self.bg_btn:SetOnClick(function()
        self:OnClick()
    end)
    self.circle_go = self:AddComponent(UIBaseContainer, circle_path)
    self.box_image = self:AddComponent(UIImage, box_path)
    self.day_text = self:AddComponent(UIText, day_path)
end

local function ComponentDestroy(self)
    self.bg_btn = nil
    self.circle_go = nil
    self.box_image = nil
    self.day_text = nil
end

local function DataDefine(self)
    self.data = nil
    self.stage = nil
    self.onClick = nil
end

local function DataDestroy(self)
    self.data = nil
    self.stage = nil
    self.onClick = nil
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)

end

local function OnRemoveListener(self)

end

local function SetData(self, data, stage)
    self.data = data
    self.stage = stage
    
    local isToday = (stage.level == data:GetTodayLevel())
    self.circle_go:SetActive(isToday)
    
    local icon = IconPath .. stage.level .. ((stage.state == 1) and "_open" or "")
    self.box_image:LoadSprite(icon)
    self.day_text:SetLocalText(320360, stage.level)
end

local function SetOnClick(self, onClick)
    self.onClick = onClick
end

local function OnClick(self)
    if self.onClick then
        self.onClick()
    end
end

UIKeepPayItem.OnCreate = OnCreate
UIKeepPayItem.OnDestroy = OnDestroy
UIKeepPayItem.ComponentDefine = ComponentDefine
UIKeepPayItem.ComponentDestroy = ComponentDestroy
UIKeepPayItem.DataDefine = DataDefine
UIKeepPayItem.DataDestroy = DataDestroy
UIKeepPayItem.OnEnable = OnEnable
UIKeepPayItem.OnDisable = OnDisable
UIKeepPayItem.OnAddListener = OnAddListener
UIKeepPayItem.OnRemoveListener = OnRemoveListener

UIKeepPayItem.SetData = SetData
UIKeepPayItem.SetOnClick = SetOnClick
UIKeepPayItem.OnClick = OnClick

return UIKeepPayItem
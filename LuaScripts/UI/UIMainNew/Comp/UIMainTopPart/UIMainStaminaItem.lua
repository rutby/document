---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/12/13 11:14
---
local UIMainStaminaItem = BaseClass("UIMainStaminaItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local this_path = ""
local slider_path = "Slider"
local val_path = "Val"
--local icon_path = "Icon"

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
    self.btn = self:AddComponent(UIButton, this_path)
    self.btn:SetOnClick(function()
        self:OnClick()
    end)
    self.slider = self:AddComponent(UISlider, slider_path)
    self.val_text = self:AddComponent(UITweenNumberText_TextMeshPro, val_path)
    self.val_text:SetSeparator(true)
    --self.icon_image = self:AddComponent(UIImage, icon_path)
end

local function ComponentDestroy(self)
    self.btn = nil
    self.slider = nil
    self.val_text = nil
    --self.icon_image = nil
    self.add_btn = nil
    self.red_effect_particle = nil
    self.onClick = nil
end

local function DataDefine(self)
    self.mathFunc = toInt
    self.refreshDuration = 1
    self.refreshDelay = 0
    self.refreshCallback = nil
    self.showMax = true
    self.onClick = nil
    self.timer = nil
end

local function DataDestroy(self)
    self.mathFunc = nil
    self.refreshDuration = nil
    self.refreshDelay = nil
    self.refreshCallback = nil
    self.showMax = nil
    if self.timer then
        self.timer:Stop()
        self.timer = nil
    end
end

local function OnEnable(self)
    base.OnEnable(self)
    self:ReInit()
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.FormationStaminaUpdate, self.OnPveStaminaUpdate)
    self:AddUIListener(EventId.EffectNumChange, self.OnEffectNumChange)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.FormationStaminaUpdate, self.OnPveStaminaUpdate)
    self:RemoveUIListener(EventId.EffectNumChange, self.OnEffectNumChange)
    base.OnRemoveListener(self)
end

local function ReInit(self)
    local max = self.mathFunc(LuaEntry.Player:GetMaxPveStamina())
    if max > 0 then
        local cur = self.mathFunc(LuaEntry.Player:GetCurPveStamina())
        self.slider:SetValue(cur / max)
        if self.showMax then
            local maxStr = string.GetFormattedSeperatorNum(max)
            self.val_text:SetSuffix("/" .. maxStr)
        else
            self.val_text:SetSuffix("")
        end
        self.val_text:SetNum(cur)
    end
    if self.timer then
        self.timer:Stop()
    end
    self.timer = TimerManager:GetInstance():GetTimer(1, self.TimerAction, self, false, false, false)
    self.timer:Start()
end

local function Refresh(self)
    local max = self.mathFunc(LuaEntry.Player:GetMaxPveStamina())
    if max > 0 then
        local cur = self.mathFunc(LuaEntry.Player:GetCurPveStamina())
        self.slider.unity_uislider:DOValue(cur / max, self.refreshDuration):SetDelay(self.refreshDelay)
        self.val_text:TweenToNum(cur, self.refreshDuration, self.refreshDelay, nil, self.refreshCallback)
    end
end

local function TimerAction(self)
    local cur = self.mathFunc(LuaEntry.Player:GetCurPveStamina())
    if cur ~= self.val_text:GetTargetNum() then
        self:Refresh()
    end
end

local function ShowRedEffect(self)
end

-- mathFunc: function(x)
local function SetMathFunc(self, mathFunc)
    self.mathFunc = mathFunc
end

local function SetRefreshDuration(self, duration)
    self.refreshDuration = duration
end

local function SetRefreshDelay(self, delay)
    self.refreshDelay = delay
end

local function SetRefreshCallback(self, callback)
    self.refreshCallback = callback
end

local function ShowMax(self, show)
    self.showMax = show
    self:ReInit()
end

local function GetIconPos(self)
    return nil--self.icon_image.transform.position
end


local function OnClick(self)
    --UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationAddStamina)
    local lackTab = {}
    local param = {}
    param.type = ResLackType.Res
    param.id = ResourceType.FORMATION_STAMINA
    local maxNum = LuaEntry.Player:GetMaxPveStamina()
    if maxNum > 0 then
        maxNum = Mathf.Floor(maxNum)
    end
    param.targetNum = maxNum
    table.insert(lackTab,param)
    GoToResLack.GoToItemResLackList(lackTab)
end

local function OnPveStaminaUpdate(self)
    self:Refresh()
end

local function OnEffectNumChange(self)
    self:Refresh()
end

UIMainStaminaItem.OnCreate= OnCreate
UIMainStaminaItem.OnDestroy = OnDestroy
UIMainStaminaItem.ComponentDefine = ComponentDefine
UIMainStaminaItem.ComponentDestroy = ComponentDestroy
UIMainStaminaItem.DataDefine = DataDefine
UIMainStaminaItem.DataDestroy = DataDestroy
UIMainStaminaItem.OnEnable = OnEnable
UIMainStaminaItem.OnDisable = OnDisable
UIMainStaminaItem.OnAddListener = OnAddListener
UIMainStaminaItem.OnRemoveListener = OnRemoveListener

UIMainStaminaItem.ReInit = ReInit
UIMainStaminaItem.Refresh = Refresh
UIMainStaminaItem.TimerAction = TimerAction
UIMainStaminaItem.ShowRedEffect = ShowRedEffect
UIMainStaminaItem.SetMathFunc = SetMathFunc
UIMainStaminaItem.SetRefreshDuration = SetRefreshDuration
UIMainStaminaItem.SetRefreshDelay = SetRefreshDelay
UIMainStaminaItem.SetRefreshCallback = SetRefreshCallback
UIMainStaminaItem.ShowMax = ShowMax
UIMainStaminaItem.GetIconPos = GetIconPos

UIMainStaminaItem.OnClick = OnClick
UIMainStaminaItem.OnPveStaminaUpdate = OnPveStaminaUpdate
UIMainStaminaItem.OnEffectNumChange = OnEffectNumChange

return UIMainStaminaItem
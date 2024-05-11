
local TouchScreenEffectView = BaseClass("TouchScreenEffectView", UIBaseView)
local base = UIBaseView
local Input = CS.UnityEngine.Input
local CSUtils = CS.CSUtils

local function OnCreate(self)
    base.OnCreate(self)
    self.particle = self.transform:Find("TouchScreenEffect"):GetComponent(typeof(CS.UnityEngine.ParticleSystem))
end

local function OnDestroy(self)
    base.OnDestroy(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.OnWorldInputPointDown, self.OnWorldInputPointDownSignal)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.OnWorldInputPointDown, self.OnWorldInputPointDownSignal)
end

local function OnWorldInputPointDownSignal(self)
    if Input.touchCount <= 1 then
        --self.transform.position = Input.mousePosition
		CSUtils.SetPositionFromInput(self.transform)
        self.particle.gameObject:SetActive(true)
        self.particle:Play();
    end
end

TouchScreenEffectView.OnCreate = OnCreate
TouchScreenEffectView.OnDestroy = OnDestroy
TouchScreenEffectView.OnAddListener = OnAddListener
TouchScreenEffectView.OnRemoveListener = OnRemoveListener
TouchScreenEffectView.OnWorldInputPointDownSignal = OnWorldInputPointDownSignal

return TouchScreenEffectView
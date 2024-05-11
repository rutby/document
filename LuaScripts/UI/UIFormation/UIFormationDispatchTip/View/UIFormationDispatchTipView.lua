---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 9/4/2024 下午3:54
---
local UIFormationDispatchTipView = BaseClass("UIFormationDispatchTipView", UIBaseView)
local base = UIBaseView

local bg_path = "Bg"
local icon_bg_path = "Bg/Pic"
local icon_path = "Bg/Pic/iconMask/imgIcon"
local desc_path = "Bg/Desc"

local PosX1 = 404
local PosX2 = 0
local MoveDuration = 0.3
local ShowDuration = 2.5

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

local function OnDestroy(self)
    self:DataDestroy()
    self:ComponentDestroy()
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
    self:ReInit()
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ComponentDefine(self)
    self.bg_image = self:AddComponent(UIImage, bg_path)
    self.icon_bg_image = self:AddComponent(UIImage, icon_bg_path)
    self.icon_image = self:AddComponent(UIImage, icon_path)
    self.desc_text = self:AddComponent(UITextMeshProUGUIEx, desc_path)
end

local function ComponentDestroy(self)

end

local function DataDefine(self)
    self.seq = nil
end

local function DataDestroy(self)
    if self.seq then
        self.seq:Kill()
        self.seq = nil
    end
end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function ReInit(self)
    self.heroUuid = self:GetUserData()
    self:Play()
end

local function TryNext(self)
end

local function Play(self)
    if self.seq then
        self.seq:Kill()
    end
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
    if heroData~=nil then
        local iconPath = HeroUtils.GetHeroIconPath(heroData.heroId)
        self.icon_image:LoadSprite(iconPath)
    end
    local k4 = LuaEntry.DataConfig:TryGetStr("dispatch_config", "k4")
    local arr =string.split(k4,";")
    if #arr>0 then
        local idx = math.random(1, #arr)
        self.desc_text:SetLocalText(arr[idx])
    end
    self.seq = DOTween.Sequence()
                      :Append(self.bg_image.rectTransform:DOAnchorPosX(PosX2, MoveDuration))
                      :AppendInterval(ShowDuration)
                      :Append(self.bg_image.rectTransform:DOAnchorPosX(PosX1, MoveDuration))
                      :AppendCallback(function()
        self.ctrl:CloseSelf()
    end)
end

UIFormationDispatchTipView.OnCreate = OnCreate
UIFormationDispatchTipView.OnDestroy = OnDestroy
UIFormationDispatchTipView.OnEnable = OnEnable
UIFormationDispatchTipView.OnDisable = OnDisable
UIFormationDispatchTipView.ComponentDefine = ComponentDefine
UIFormationDispatchTipView.ComponentDestroy = ComponentDestroy
UIFormationDispatchTipView.DataDefine = DataDefine
UIFormationDispatchTipView.DataDestroy = DataDestroy
UIFormationDispatchTipView.OnAddListener = OnAddListener
UIFormationDispatchTipView.OnRemoveListener = OnRemoveListener

UIFormationDispatchTipView.ReInit = ReInit
UIFormationDispatchTipView.TryNext = TryNext
UIFormationDispatchTipView.Play = Play

return UIFormationDispatchTipView
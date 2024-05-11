---
--- 引导 佩戴耳机提醒
--- Created by GaoFei.
--- DateTime: 2024/04/24 10:50
---
local UIGuideWearHeadphonesView = BaseClass("UIGuideWearHeadphonesView",UIBaseView)
local base = UIBaseView

--local this_path = ""
local desc_path = "Desc"
local panel_path = "UICommonPanel"

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.panel_btn = self:AddComponent(UIButton, panel_path)
    self.panel_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)


    self.desc_text = self:AddComponent(UITextMeshProUGUIEx, desc_path)
end

local function ComponentDestroy(self)

end

local function DataDefine(self)
    
end

local function DataDestroy(self)
    
end

local function OnEnable(self)
    base.OnEnable(self)
    self:ReInit()
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ReInit(self)
    self:Refresh()
end

local function Refresh(self)
    
    self.desc_text:SetLocalText(GameDialogDefine.Guide_WearHeadphones)
end




UIGuideWearHeadphonesView.OnCreate = OnCreate
UIGuideWearHeadphonesView.OnDestroy = OnDestroy
UIGuideWearHeadphonesView.ComponentDefine = ComponentDefine
UIGuideWearHeadphonesView.ComponentDestroy = ComponentDestroy
UIGuideWearHeadphonesView.DataDefine = DataDefine
UIGuideWearHeadphonesView.DataDestroy = DataDestroy
UIGuideWearHeadphonesView.OnEnable = OnEnable
UIGuideWearHeadphonesView.OnDisable = OnDisable
UIGuideWearHeadphonesView.ReInit = ReInit
UIGuideWearHeadphonesView.Refresh = Refresh

return UIGuideWearHeadphonesView
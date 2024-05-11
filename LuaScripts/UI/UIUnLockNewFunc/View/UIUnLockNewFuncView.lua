
local UIUnLockNewFuncView = BaseClass("UIUnLockNewFuncView", UIBaseView)
local base = UIBaseView
local reward_title_path = "UICommonRewardPopUp/Panel/ImgTitleBg/TextTitle"
local panel_path = "UICommonRewardPopUp/Panel"
local unlockIcon_path = "Root/UnlockIcon"
local unlockLight_path = "Root/UnlockLight"
local unlockIcon_txt_path = "Root/UnlockTxt"
local unlockIcon2_txt_path = "Root/UnlockTxt2"

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
    self.textTitle = self:AddComponent(UIText, reward_title_path)
    -- 恭喜获得
    self.panel = self:AddComponent(UIButton, panel_path)
    self.panel:SetOnClick(function()
        self:OnClick()
    end)
    self.unlockIcon_txt = self:AddComponent(UIText, unlockIcon_txt_path)
    self.unlockIcon = self:AddComponent(UIImage, unlockIcon_path)
    self.unlockLight = self:AddComponent(UIBaseContainer, unlockLight_path)
    self.unlockIcon2_txt = self:AddComponent(UIText,unlockIcon2_txt_path)
end

local function ComponentDestroy(self)
    self.textTitle = nil
    self.panel = nil
    self.unlockIcon_txt = nil
    self.unlockIcon2_txt = nil
    self.unlockIcon = nil
    self.unlockLight = nil
end

local function DataDefine(self)

end

local function DataDestroy(self)
 
end

local function OnEnable(self)
    base.OnEnable(self)
    self:InitData(self:GetUserData())
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function InitData(self)
    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Ue_Unclock)
    self.textTitle:SetLocalText(220285)
    self:SetIcon()
end

local function OnClick(self)
    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
    self.ctrl:CloseSelf()
end

local function SetIcon(self)
    self.unlockIcon_txt:SetLocalText(220287)
    self.unlockIcon2_txt:SetLocalText(220286)
end

UIUnLockNewFuncView.OnCreate= OnCreate
UIUnLockNewFuncView.OnDestroy = OnDestroy
UIUnLockNewFuncView.OnEnable = OnEnable
UIUnLockNewFuncView.OnDisable = OnDisable
UIUnLockNewFuncView.ComponentDefine = ComponentDefine
UIUnLockNewFuncView.ComponentDestroy = ComponentDestroy
UIUnLockNewFuncView.InitData = InitData
UIUnLockNewFuncView.DataDefine = DataDefine
UIUnLockNewFuncView.DataDestroy = DataDestroy
UIUnLockNewFuncView.OnClick = OnClick
UIUnLockNewFuncView.SetIcon = SetIcon

return UIUnLockNewFuncView

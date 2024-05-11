local UIUnlockBtnPanelView = BaseClass("UIUnlockBtnPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local text_path = "ani/TextTitle"
local clickText_path = "TxtClick"
local closeBtn_path = "UICommonPanel"
local text2_path = "ani/taskNameBg/name_text"
local icon_path = "ani/taskNameBg/icon"
-- local titleTxt_path = "ani/Title"

--创建
function UIUnlockBtnPanelView : OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
function UIUnlockBtnPanelView : OnDestroy()
    DataCenter.UnlockBtnManager:StartFlyUnlockBtn(self.unlockBtnType)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIUnlockBtnPanelView : ComponentDefine()
    -- self.titleTxt = self:AddComponent(UITextMeshProUGUIEx, titleTxt_path)
    self.text = self:AddComponent(UITextMeshProUGUIEx, text_path)
    self.clickText = self:AddComponent(UITextMeshProUGUIEx, clickText_path)
    self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
    self.closeBtn:SetOnClick(function()
        self:OnClickCloseBtn()
    end)
    self.text2 = self:AddComponent(UITextMeshProUGUIEx, text2_path)
    self.icon = self:AddComponent(UIImage, icon_path)
end

function UIUnlockBtnPanelView : ComponentDestroy()

end

function UIUnlockBtnPanelView : DataDefine()
    self.unlockBtnType = 0
end

function UIUnlockBtnPanelView : DataDestroy()
    self.unlockBtnType = 0
end

function UIUnlockBtnPanelView : OnEnable()
    base.OnEnable(self)
end

function UIUnlockBtnPanelView : OnDisable()
    base.OnDisable(self)
end

function UIUnlockBtnPanelView : OnAddListener()
    base.OnAddListener(self)
end

function UIUnlockBtnPanelView : OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIUnlockBtnPanelView : OnClickCloseBtn()
    self.ctrl:CloseSelf()
end

function UIUnlockBtnPanelView:ReInit()
    self.unlockBtnType = self:GetUserData()
    -- self.titleTxt:SetLocalText(123456)
    self.clickText:SetLocalText(430137)
    self.text:SetLocalText(430136)
    local name = LocalController:instance():getValue(DataCenter.UnlockBtnManager:GetTableName(), self.unlockBtnType, "name", 0)
    if name ~= 0 then
        self.text2:SetLocalText(name)
    end
    self.icon:SetLocalScale(DataCenter.UnlockBtnManager:GetIconScale(self.unlockBtnType))
    self.icon:LoadSprite(DataCenter.UnlockBtnManager:GetUnlockBtnIconName(self.unlockBtnType), nil, function()
        self.icon:SetNativeSize()
    end)
    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Ue_Unclock)
end

return UIUnlockBtnPanelView

local UITalentChooseResultView = BaseClass("UITalentChooseResultView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local panel_path = "UICommonRewardPopUp/Panel"
local title_name_path = "UICommonRewardPopUp/Panel/ImgTitleBg/TextTitle"
local skip_anim_btn_path = "SkipAnimButton"
local BgNameList = {"UIBattleBuff_bg_green","UIBattleBuff_bg_blue","UIBattleBuff_bg_purple","UIBattleBuff_bg_orange","UIBattleBuff_bg_red"}

local talent_name_path = "UITalentChooseCell/aim/Name_text"
local icon_path = "UITalentChooseCell/aim/BuffIcon"
local bg_path = "UITalentChooseCell/aim/Bg"

--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.btn = self:AddComponent(UIButton, panel_path)
    self.title_name = self:AddComponent(UITextMeshProUGUIEx, title_name_path)

    self.btn:SetOnClick(function()
        EventManager:GetInstance():Broadcast(EventId.OnRewardGetPanelClose)
        self.ctrl:CloseSelf()
    end)
    
    self.skip_anim_btn = self:AddComponent(UIButton, skip_anim_btn_path)
    self.skip_anim_btn.gameObject:SetActive(true)
    self.skip_anim_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)

    self.talent_name = self:AddComponent(UITextMeshProUGUIEx, talent_name_path)
    self.icon = self:AddComponent(UIImage, icon_path)
    self.bg = self:AddComponent(UIImage, bg_path)
end

local function ComponentDestroy(self)
    self.btn = nil
    self.title_name = nil
    self.skip_anim_btn = nil
end


local function DataDefine(self)
    self.param = nil
    self.nameText = nil
    self.cells = {}
    self.showAnim = true
end

local function DataDestroy(self)
    self.param = nil
    self.nameText = nil
    self.cells = nil
    self.showAnim = nil
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function ReInit(self)
    self.title_name:SetLocalText(128027)
    local talentId = self:GetUserData()
    local template = DataCenter.TalentTemplateManager:GetTemplate(talentId)
    local nameStr = Localization:GetString("300665", template.lv).." "..template.name
    self.talent_name:SetText(nameStr)
    self.icon:LoadSprite(template.icon)
    local color = template.color + 1
    if color > table.count(BgNameList) then
        color = table.count(BgNameList)
    end
    local bgName = BgNameList[color]
    self.bg:LoadSprite(string.format(LoadPath.UIPveBattleBuff, bgName))
end

UITalentChooseResultView.OnCreate = OnCreate
UITalentChooseResultView.OnDestroy = OnDestroy
UITalentChooseResultView.OnEnable = OnEnable
UITalentChooseResultView.OnDisable = OnDisable
UITalentChooseResultView.ComponentDefine = ComponentDefine
UITalentChooseResultView.ComponentDestroy = ComponentDestroy
UITalentChooseResultView.DataDefine = DataDefine
UITalentChooseResultView.DataDestroy = DataDestroy
UITalentChooseResultView.OnAddListener = OnAddListener
UITalentChooseResultView.OnRemoveListener = OnRemoveListener
UITalentChooseResultView.ReInit = ReInit

return UITalentChooseResultView
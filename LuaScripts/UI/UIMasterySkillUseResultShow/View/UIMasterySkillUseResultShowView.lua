--- Created by shimin
--- DateTime: 2023/4/10 18:12
--- 专精技能使用后显示结果界面

local UIMasterySkillUseResultShowView = BaseClass("UIMasterySkillUseResultShowView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local title_txt_path ="UICommonRewardPopUp/Panel/ImgTitleBg/TextTitle"
local close_btn_path = "UICommonRewardPopUp/Panel"
local icon_img_path = "layout/Icon"
local des_text_path = "layout/DesText"

function UIMasterySkillUseResultShowView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

function UIMasterySkillUseResultShowView:ComponentDefine()
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.title_txt = self:AddComponent(UIText, title_txt_path)
    self.icon_img = self:AddComponent(UIImage, icon_img_path)
    self.des_text = self:AddComponent(UIText, des_text_path)
end

function UIMasterySkillUseResultShowView:ComponentDestroy()
end

function UIMasterySkillUseResultShowView:DataDefine()
  
end

function UIMasterySkillUseResultShowView:DataDestroy()
 
end

function UIMasterySkillUseResultShowView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIMasterySkillUseResultShowView:OnEnable()
    base.OnEnable(self)
end

function UIMasterySkillUseResultShowView:OnDisable()
    base.OnDisable(self)
end

function UIMasterySkillUseResultShowView:OnAddListener()
    base.OnAddListener(self)
end

function UIMasterySkillUseResultShowView:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIMasterySkillUseResultShowView:ReInit()
    local statusId = self:GetUserData()
    local template = DataCenter.StatusTemplateManager:GetTemplate(statusId)
    if template ~= nil then
        self.title_txt:SetLocalText(template.name)
        self.des_text:SetText(template:GetDesc())
        self.icon_img:LoadSprite(string.format(LoadPath.HeroListPath, template.icon_show))
    end
end

return UIMasterySkillUseResultShowView
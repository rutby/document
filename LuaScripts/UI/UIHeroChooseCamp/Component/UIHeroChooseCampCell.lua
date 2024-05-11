--- Created by shimin
--- DateTime: 2023/9/19 10:09
--- 英雄选择阵容页面cell

local UIHeroChooseCampCell = BaseClass("UIHeroChooseCampCell", UIBaseContainer)
local base = UIBaseContainer

local this_path = ""
local select_go_path = "select_go"
local camp_icon_path = "camp_icon"
local camp_text_path = "camp_text"

function UIHeroChooseCampCell:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIHeroChooseCampCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIHeroChooseCampCell:OnEnable()
    base.OnEnable(self)
end

function UIHeroChooseCampCell:OnDisable()
    base.OnDisable(self)
end

function UIHeroChooseCampCell:ComponentDefine()
    self.btn = self:AddComponent(UIButton, this_path)
    self.btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnChooseBtnClick()
    end)
    self.select_go = self:AddComponent(UIBaseContainer, select_go_path)
    self.camp_icon = self:AddComponent(UIImage, camp_icon_path)
    self.camp_text = self:AddComponent(UIText, camp_text_path)
end

function UIHeroChooseCampCell:ComponentDestroy()
end

function UIHeroChooseCampCell:DataDefine()
    self.param = {}
end

function UIHeroChooseCampCell:DataDestroy()
    self.param = {}
end

function UIHeroChooseCampCell:OnAddListener()
    base.OnAddListener(self)
end

function UIHeroChooseCampCell:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIHeroChooseCampCell:ReInit(param)
    self.param = param
    self.camp_icon:LoadSprite(HeroUtils.GetCampIconPath(self.param.campType))
    self.camp_text:SetText(HeroUtils.GetCampNameAndDesc(self.param.campType))
    self:RefreshSelect()
end

function UIHeroChooseCampCell:Select(isSelect)
    self:RefreshSelect()
end

function UIHeroChooseCampCell:RefreshSelect()
    self.select_go:SetActive(self.param.select)
end

function UIHeroChooseCampCell:OnChooseBtnClick()
    if self.param.callback ~= nil then
        self.param.callback(self.param.index)
    end
end

return UIHeroChooseCampCell
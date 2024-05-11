--- Created by shimin
--- DateTime: 2023/5/16 16:57
--- 装饰建筑图鉴cell

local UIHeroStarCell = BaseClass("UIHeroStarCell", UIBaseContainer)
local base = UIBaseContainer

local this_path = ""
local quality_img_path = "ImgQuality"
local icon_img_path = "ItemIcon"
local lv_text_path = "LvText"
local no_own_go_path = "NoOwnGo"

local SelectLocalPos = Vector3.New(0, -2, 0)

function UIHeroStarCell:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIHeroStarCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIHeroStarCell:OnEnable()
    base.OnEnable(self)
end

function UIHeroStarCell:OnDisable()
    base.OnDisable(self)
end

function UIHeroStarCell:ComponentDefine()
    self.btn = self:AddComponent(UIButton, this_path)
    self.btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnBtnClick()
    end)
    self.quality_img = self:AddComponent(UIImage, quality_img_path)
    self.icon_img = self:AddComponent(UIImage, icon_img_path)
    self.lv_text = self:AddComponent(UIText, lv_text_path)
    self.no_own_go = self:AddComponent(UIBaseContainer, no_own_go_path)
end

function UIHeroStarCell:ComponentDestroy()

end

function UIHeroStarCell:DataDefine()
    self.param = {}
end

function UIHeroStarCell:DataDestroy()
    self.param = {}
end

function UIHeroStarCell:OnAddListener()
    base.OnAddListener(self)
end

function UIHeroStarCell:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIHeroStarCell:ReInit(param)
    self.param = param
    self:Refresh()
end

function UIHeroStarCell:Refresh()
    if self.param.visible then
        self:SetActive(true)
        if self.param.data.own then
            self.no_own_go:SetActive(false)
        else
            self.no_own_go:SetActive(true)
        end
    else
        self:SetActive(false)
    end
end

function UIHeroStarCell:OnBtnClick()
    if self.param.callback ~= nil then
        local pos = self.btn:GetPosition()
        self.param.callback(self.param.index, pos)
    end
end

function UIHeroStarCell:SetSelect(go)
    go:SetActive(true)
    go.transform:SetParent(self.icon_img.transform)
    go:SetLocalPosition(SelectLocalPos)
    go:SetLocalScale(ResetScale)
end

return UIHeroStarCell
---
--- Created by shimin.
--- DateTime: 2022/6/14 15:11
--- 英雄委托界面的cell
---

local UIHeroEntrustCell = BaseClass("UIHeroEntrustCell", UIBaseContainer)
local base = UIBaseContainer

local icon_path = "Icon"
local complete_go_path = "CompleteGo"
local own_num_text_path = "OwnNumText"
local need_num_text_path = "OwnNumText/NeedNumText"
local this_path = ""

function UIHeroEntrustCell:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
function UIHeroEntrustCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIHeroEntrustCell:ComponentDefine()
    self.icon = self:AddComponent(UIImage, icon_path)
    self.complete_go = self:AddComponent(UIBaseContainer, complete_go_path)
    self.own_num_text = self:AddComponent(UIText, own_num_text_path)
    self.need_num_text = self:AddComponent(UIText, need_num_text_path)
    self.goto_btn = self:AddComponent(UIButton, this_path)
    self.goto_btn:SetOnClick(function()
        self:OnGotoBtnClick()
    end)
end

function UIHeroEntrustCell:ComponentDestroy()
    self.icon = nil
    self.complete_go = nil
    self.own_num_text = nil
    self.need_num_text = nil
    self.goto_btn = nil
end

function UIHeroEntrustCell:DataDefine()
    self.param = {}
end

function UIHeroEntrustCell:DataDestroy()
    self.param = {}
end

function UIHeroEntrustCell:OnEnable()
    base.OnEnable(self)
end

function UIHeroEntrustCell:OnDisable()
    base.OnDisable(self)
end

function UIHeroEntrustCell:OnAddListener()
    base.OnAddListener(self)
end

function UIHeroEntrustCell:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIHeroEntrustCell:ReInit(param)
    self.param = param
    self.need_num_text:SetText("/" .. param.count)
    if param.needType == HeroEntrustNeedType.Resource then
        self.icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(param.needId))
    elseif param.needType == HeroEntrustNeedType.Goods then
        local template = DataCenter.ItemTemplateManager:GetItemTemplate(param.needId)
        if template ~= nil then
            self.icon:LoadSprite(string.format(LoadPath.ItemPath, template.icon))
        end
    end
    self:Refresh()
end

function UIHeroEntrustCell:Refresh()
    self.own_num_text:SetText(tostring(self.param.template:GetOwnCountByIndex(self.param.index)))
    local isComplete = self.param.template:HaveEnoughGoods(self.param.index)
    if isComplete then
        self.complete_go:SetActive(true)
        self.goto_btn:SetInteractable(false)
        self.own_num_text:SetColor(WhiteColor)
    else
        self.complete_go:SetActive(false)
        self.goto_btn:SetInteractable(true)
        self.own_num_text:SetColor(RedColor)
    end
end



function UIHeroEntrustCell:GetFingerObj()
    return self.icon.gameObject
end

function UIHeroEntrustCell:OnGotoBtnClick()
    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
    --前往
    if self.param.needType == HeroEntrustNeedType.Resource then
        if self.param.needId == ResourceType.Money then
            
        else
            local list = DataCenter.BuildManager:GetCanGetResourceBuildUuidByResourceType(self.param.needId)
            if list == nil then
                --一个建筑都没有应该去建造
                GoToUtil.GotoBuildListByBuildId()
            else
                GoToUtil.GotoCityByBuildUuid(list.uuid)
            end
        end
    elseif self.param.needType == HeroEntrustNeedType.Goods then
        self.view.ctrl:CloseSelf()
    end
end

return UIHeroEntrustCell
--- Created by shimin
--- DateTime: 2023/7/20 18:30
--- 英雄勋章兑换代币cell

local UIHeroMetalRedemptionMetalCell = BaseClass("UIHeroMetalRedemptionMetalCell", UIBaseContainer)
local base = UIBaseContainer

local this_path = ""
local quality_bg_img_path = "imgQuality"
local icon_img_path = "medalIcon"
local select_go_path = "select_go"
local num_text_path = "TextLevel"

function UIHeroMetalRedemptionMetalCell:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIHeroMetalRedemptionMetalCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIHeroMetalRedemptionMetalCell:OnEnable()
    base.OnEnable(self)
end

function UIHeroMetalRedemptionMetalCell:OnDisable()
    base.OnDisable(self)
end

function UIHeroMetalRedemptionMetalCell:ComponentDefine()
    self.btn = self:AddComponent(UIButton, this_path)
    self.btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnBtnClick()
    end)
    self.quality_bg_img = self:AddComponent(UIImage, quality_bg_img_path)
    self.icon_img = self:AddComponent(UIImage, icon_img_path)
    self.select_go = self:AddComponent(UIBaseContainer, select_go_path)
    self.num_text = self:AddComponent(UIText, num_text_path)
end

function UIHeroMetalRedemptionMetalCell:ComponentDestroy()

end

function UIHeroMetalRedemptionMetalCell:DataDefine()
    self.param = {}
    self.callback = function(num)
        self:OnSelectNum(num)
    end
end

function UIHeroMetalRedemptionMetalCell:DataDestroy()
    self.param = {}
end

function UIHeroMetalRedemptionMetalCell:OnAddListener()
    base.OnAddListener(self)
end

function UIHeroMetalRedemptionMetalCell:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIHeroMetalRedemptionMetalCell:ReInit(param)
    self.param = param
    self.icon_img:LoadSprite(string.format(LoadPath.ItemPath, self.param.template.icon))
    self.quality_bg_img:LoadSprite(DataCenter.ItemTemplateManager:GetToolBgByColor(self.param.template.color))
    self:RefreshNum()
end

function UIHeroMetalRedemptionMetalCell:OnBtnClick()
    if self.param.num > 0 then
        self:OnSelectNum(0)
    else
        --打开选择数量界面
        local param = {}
        param.callback = self.callback
        param.tabType = UIHeroMetalRedemptionTabType.Metal
        param.num = self.param.num
        param.count = self.param.count
        param.template = self.param.template
        param.color = self.param.template.color
        param.itemId = self.param.itemId
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroMetalRedemptionSelectCount,{ anim = true, playEffect = true}, param)
    end
end


function UIHeroMetalRedemptionMetalCell:SetSelectNum(num)
    if self.param.num ~= num then
        self.param.num = num
        self:RefreshNum()
    end
end

function UIHeroMetalRedemptionMetalCell:RefreshNum()
    if self.param.num > 0 then
        if self.param.count ~= nil then
            self.num_text:SetText(string.GetFormattedSeperatorNum(self.param.num) .. "/" .. string.GetFormattedSeperatorNum(self.param.count))
        else
            self.num_text:SetText(string.GetFormattedSeperatorNum(self.param.num))
        end
    
        if self.param.useSelect then
            self.select_go:SetActive(true)
        end
    else
        if self.param.count ~= nil then
            self.num_text:SetText(string.GetFormattedSeperatorNum(self.param.count))
        else
            self.num_text:SetText(0)
        end
     
        if self.param.useSelect then
            self.select_go:SetActive(false)
        end
    end
end

--设置数量回调
function UIHeroMetalRedemptionMetalCell:OnSelectNum(num)
    self:SetSelectNum(num)
    if self.param.callback ~= nil then
        self.param:callback()
    end
end



return UIHeroMetalRedemptionMetalCell
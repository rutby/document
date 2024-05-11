--- Created by shimin
--- DateTime: 2023/7/20 11:10
--- 英雄兑换勋章/海报/商店界面Tab

local UIHeroMetalRedemptionTab = BaseClass("UIHeroMetalRedemptionTab", UIBaseContainer)
local base = UIBaseContainer

local this_path = ""
local select_name_path = "title_text"
local red_go_path = "red_go"

local whiteColor = Color.New(1, 1, 1, 1)
local emptyColor = Color.New(1, 1, 1, 0)
local TextUnSelectColor = Color.New(213/255, 211/255, 220/255, 1)

function UIHeroMetalRedemptionTab:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIHeroMetalRedemptionTab:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIHeroMetalRedemptionTab:OnEnable()
    base.OnEnable(self)
end

function UIHeroMetalRedemptionTab:OnDisable()
    base.OnDisable(self)
end

function UIHeroMetalRedemptionTab:ComponentDefine()
    self.btn = self:AddComponent(UIButton, this_path)
    self.btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:ToggleControlBorS()
    end)
    self.select_name = self:AddComponent(UIText, select_name_path)
    self.bg_img = self:AddComponent(UIImage, this_path)
    self.red_go = self:AddComponent(UIBaseContainer, red_go_path)
end

function UIHeroMetalRedemptionTab:ComponentDestroy()

end

function UIHeroMetalRedemptionTab:DataDefine()
    self.param = {}
end

function UIHeroMetalRedemptionTab:DataDestroy()
    self.param = {}
end

function UIHeroMetalRedemptionTab:OnAddListener()
    base.OnAddListener(self)
end

function UIHeroMetalRedemptionTab:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIHeroMetalRedemptionTab:ReInit(param)
    self.param = param
    self.select_name:SetLocalText(self.param.nameDialog)
    self.red_go:SetActive(false)
    self:Refresh()
end

function UIHeroMetalRedemptionTab:Refresh()
    if self.param.visible then
        self:SetActive(true)
        self:Select(self.param.select)
    else
        self:SetActive(false)
    end
end

function UIHeroMetalRedemptionTab:ToggleControlBorS()
    if not self.param.select then
        self.view:SetSelect(self.param.tab)
    end
end

function UIHeroMetalRedemptionTab:Select(select)
    self.param.select = select
    if select then
        self.select_name:SetColor(whiteColor)
        self.bg_img:SetColor(whiteColor)
    else
        self.select_name:SetColor(TextUnSelectColor)
        self.bg_img:SetColor(emptyColor)
    end
end

return UIHeroMetalRedemptionTab
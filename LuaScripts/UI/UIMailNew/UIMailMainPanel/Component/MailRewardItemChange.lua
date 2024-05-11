--- Created by shimin.
--- DateTime: 2023/10/18 21:43
--- 通用道具改变大小类

local MailRewardItemChange = BaseClass("MailRewardItemChange",UIBaseContainer)
local MailRewardItem = require "UI.UIMailNew.UIMailMainPanel.Component.MailRewardItem"
local base = UIBaseContainer

local item_path = "UICommonItem"

function MailRewardItemChange:OnCreate()
    base.OnCreate(self)
    self.item = self:AddComponent(MailRewardItem, item_path)
end

function MailRewardItemChange:ReInit(data)
    self.item:ReInit(data)
end

function MailRewardItemChange:RefreshData(data, hideName)
    self.item:RefreshData(data, hideName)
end

function MailRewardItemChange:ShowCount(hideCount)
    self.item:ShowCount(hideCount)
end

function MailRewardItemChange:SetNameText(name)
    self.item:SetNameText(name)
end

function MailRewardItemChange:ShowFlyEff()
    self.item:ShowFlyEff()
end

return MailRewardItemChange
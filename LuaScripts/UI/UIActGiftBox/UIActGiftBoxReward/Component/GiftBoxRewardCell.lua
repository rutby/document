---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl
--- DateTime: 
---
local GiftBoxRewardCell = BaseClass("GiftBoxRewardCell", UIBaseContainer)
local base = UIBaseContainer
local UICommonItem = require "UI.UICommonItem.UICommonItem"

function GiftBoxRewardCell:OnCreate() 
    base.OnCreate(self)
    self._giftIcon_img = self:AddComponent(UIImage,"Img_GiftIcon")
    self._dailySurplus_txt = self:AddComponent(UITextMeshProUGUIEx, "Txt_DailySurplus")
    self.commonRes = self:AddComponent(UICommonItem,"Rect_Reward")
    
end

function GiftBoxRewardCell:OnDestroy()
    self._dailySurplus_txt = nil
    base.OnDestroy(self)
end


function GiftBoxRewardCell:ReInit(param,lotteryList)
    local count = param.time
    for i = 1 ,table.count(lotteryList) do
        if lotteryList[i].itemId == param.id then
            count = param.time - lotteryList[i].count
            break
        end
    end
    self._giftIcon_img:LoadSprite(string.format(LoadPath.UImystery,param.icon))
    self._dailySurplus_txt:SetLocalText(140403,count)
    self.commonRes:ReInit(param)
end

return GiftBoxRewardCell
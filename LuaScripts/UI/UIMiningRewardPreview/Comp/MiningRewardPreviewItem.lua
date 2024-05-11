local MiningRewardPreviewItem = BaseClass("MiningRewardPreviewItem", UIBaseContainer)
local base = UIBaseContainer
local UICommonItem = require "UI.UICommonItem.UICommonItem"

function MiningRewardPreviewItem:OnCreate() 
    base.OnCreate(self)
    self.img = self:AddComponent(UIImage,"img")
    self.remainNumTxt = self:AddComponent(UIText, "remainNumTxt")
    self.rewardItem = self:AddComponent(UICommonItem,"rewardItem")
    
end

function MiningRewardPreviewItem : OnDestroy()
    self.remainNumTxt = nil
    base.OnDestroy(self)
end


function MiningRewardPreviewItem : ReInit(info)
    self.img:LoadSprite(info.icon)

    if (info.showRemainNum ~= nil and info.showRemainNum == false) then
        self.remainNumTxt:SetActive(false)
    else
        self.remainNumTxt:SetActive(true)
        self.remainNumTxt:SetLocalText(140403, info.remainNum)
    end 
    self.rewardItem:ReInit(info.rewardItemInfo)
end

return MiningRewardPreviewItem
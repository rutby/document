
local UIMiningShowCarRewardView = BaseClass("UIMiningShowCarRewardView", UIBaseView)
local base = UIBaseView
local UICommonItem = require "UI.UICommonItem.UICommonItem"

local closeBtn_path = "UICommonMiniPopUpTitle/Bg_mid/CloseBtn"
local miningCarImg_path = "ImgBg/miningCarImg"
local rewardItem_path = "ImgBg/miningCarImg/rewardItem"
local titleTxt_path = "UICommonMiniPopUpTitle/Bg_mid/titleText"
local panelBtn_path = "UICommonMiniPopUpTitle/panel"

function UIMiningShowCarRewardView : OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIMiningShowCarRewardView : OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIMiningShowCarRewardView : OnEnable()
    base.OnEnable(self)
    local param = self:GetUserData()
    self.activityId = tonumber(param.activityId)
	self.carId = tonumber(param.carId)
    self.speedUpItemId = tonumber(param.speedUpItemId)

    self:RefreshView()
end

function UIMiningShowCarRewardView : DataDefine()
    
end

function UIMiningShowCarRewardView : DataDestroy()
    
end

function UIMiningShowCarRewardView : ComponentDestroy()

end

function UIMiningShowCarRewardView : ComponentDefine()
    self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
    self.closeBtn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.panelBtn = self:AddComponent(UIButton, panelBtn_path)
    self.panelBtn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.miningCarImg = self:AddComponent(UIImage, miningCarImg_path)
    self.rewardItem = self:AddComponent(UICommonItem, rewardItem_path)
    
    self.titleTxt = self:AddComponent(UITextMeshProUGUIEx, titleTxt_path)
    self.titleTxt:SetLocalText(375006)
end

function UIMiningShowCarRewardView : RefreshView()
    local lineData = LocalController:instance():getLine("activity_mining_para", self.carId)
    local icon = string.format(LoadPath.UIMiningCarImg, lineData:getValue("reward_icon"))
    self.miningCarImg:LoadSprite(icon)
    
    local goods = lineData:getValue("goods")
    local spl_goods = string.split_ss_array(goods, ";")
    local goodsId = tonumber(spl_goods[1])
    local rewardItemInfo = {}
    rewardItemInfo.rewardType = RewardType.GOODS
    rewardItemInfo.itemId = goodsId
    rewardItemInfo.count = tonumber(spl_goods[2])
    self.rewardItem:ReInit(rewardItemInfo)
end

return UIMiningShowCarRewardView
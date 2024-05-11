local UIDonateSoldierRewardCtrl = BaseClass("UIDonateSoldierRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDonateSoldierReward)
end

local function OnReceiveStageReward(self, type, idArray)
    SFSNetwork.SendMessage(MsgDefines.ReceiveDonateArmyStageReward, type, idArray)
end

local function GetRewardList(self)
    return DataCenter.ActivityDonateSoldierManager:OnGetRewardStageArr()
end

local function GetQuickPackageInfo(self)
    local useItemId = DataCenter.ActivityDonateSoldierManager:GetUseItemId()
    local str = "6;".. useItemId
    local packageTb = GiftPackageData.getShowTypeGiftPackList("6",str)
    if packageTb and #packageTb > 0 then
        return packageTb[1]
    end
end

local function BuyGift(self,info)
    DataCenter.PayManager:CallPayment(info, UIWindowNames.UIResourceBag)
end

UIDonateSoldierRewardCtrl.CloseSelf = CloseSelf
UIDonateSoldierRewardCtrl.OnReceiveStageReward = OnReceiveStageReward
UIDonateSoldierRewardCtrl.GetRewardList = GetRewardList
UIDonateSoldierRewardCtrl.GetQuickPackageInfo = GetQuickPackageInfo
UIDonateSoldierRewardCtrl.BuyGift = BuyGift
return UIDonateSoldierRewardCtrl
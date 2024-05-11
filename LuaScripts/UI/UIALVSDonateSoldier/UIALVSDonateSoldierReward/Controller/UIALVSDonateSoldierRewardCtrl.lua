local UIALVSDonateSoldierRewardCtrl = BaseClass("UIALVSDonateSoldierRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIALVSDonateSoldierReward)
end

local function OnReceiveStageReward(self, type, idArray)
    SFSNetwork.SendMessage(MsgDefines.ReceiveALVSDonateArmyStageReward, type, idArray)
end

local function GetRewardList(self)
    return DataCenter.ActivityALVSDonateSoldierManager:OnGetRewardStageArr()
end

local function GetQuickPackageInfo(self)
    local useItemId = DataCenter.ActivityALVSDonateSoldierManager:GetUseItemId()
    local str = "6;".. useItemId
    local packageTb = GiftPackageData.getShowTypeGiftPackList("6",str)
    if packageTb and #packageTb > 0 then
        return packageTb[1]
    end
end

local function BuyGift(self,info)
    DataCenter.PayManager:CallPayment(info, UIWindowNames.UIResourceBag)
end

UIALVSDonateSoldierRewardCtrl.CloseSelf = CloseSelf
UIALVSDonateSoldierRewardCtrl.OnReceiveStageReward = OnReceiveStageReward
UIALVSDonateSoldierRewardCtrl.GetRewardList = GetRewardList
UIALVSDonateSoldierRewardCtrl.GetQuickPackageInfo = GetQuickPackageInfo
UIALVSDonateSoldierRewardCtrl.BuyGift = BuyGift
return UIALVSDonateSoldierRewardCtrl
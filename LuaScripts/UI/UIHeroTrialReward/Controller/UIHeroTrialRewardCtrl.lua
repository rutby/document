local UIHeroTrialRewardCtrl = BaseClass("UIHeroTrialRewardCtrl", UIBaseCtrl)

function UIHeroTrialRewardCtrl:CloseSelf()
    UIManager.Instance:DestroyWindow(UIWindowNames.UIHeroTrialReward)
end

function UIHeroTrialRewardCtrl:Close()
    UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

function UIHeroTrialRewardCtrl:ShowReward(actId)
    local list = {}
    local activityLine = LocalController:instance():getLine(TableName.ActivityPanel, actId)
    list.strLevel = string.split(activityLine.para1,"|")
    list.strReward = string.split(activityLine.para2,"|")
    return list
end

return UIHeroTrialRewardCtrl
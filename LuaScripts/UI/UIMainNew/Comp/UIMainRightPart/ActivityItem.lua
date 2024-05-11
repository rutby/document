
local ActivityItem = BaseClass("ActivityItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local activityEnd_path = "toEnd"
local activityEndTxt_path = "toEnd/Bg/toEndTxt"
local activityRed_path = "Img_ActivityRed"
local activityRedNew_path = "NewDot"
local activityRed_Num_path = "Img_ActivityRed/DotText"
local activityTxt_path = "ActivityName"

function ActivityItem : OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function ActivityItem : OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function ActivityItem : OnEnable()
    base.OnEnable(self)
end

function ActivityItem : OnDisable()
    base.OnDisable(self)
end

function ActivityItem : ComponentDefine()
    self.btn = self:AddComponent(UIButton, "")
    self.btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Main_Activity)
        self:OnClickBtn()
    end)
    self._activityEndN = self:AddComponent(UIBaseContainer, activityEnd_path)
    self._activityEndTxtN = self:AddComponent(UITextMeshProUGUIEx, activityEndTxt_path)
    self._activityEndTxtN:SetLocalText(208255)
    self._activityRed_img = self:AddComponent(UIImage,activityRed_path)
    self._activityRedNew_img = self:AddComponent(UIImage, activityRedNew_path)
    self._activityRedNum_txt = self:AddComponent(UITextMeshProUGUIEx,activityRed_Num_path)
    self.activityName = self:AddComponent(UITextMeshProUGUIEx, activityTxt_path)
    self.activityName:SetLocalText(241034)
end

function ActivityItem : ComponentDestroy()

end

function ActivityItem : DataDefine()

end

function ActivityItem : DataDestroy()

end

function ActivityItem : OnAddListener()
    base.OnAddListener(self)
end

function ActivityItem : OnRemoveListener()
    base.OnRemoveListener(self)
end

function ActivityItem : RefreshAll()
    local unlockBtnLockType = DataCenter.UnlockBtnManager:GetShowBtnState(UnlockBtnType.Activity)
    if unlockBtnLockType == UnlockBtnLockType.Show and DataCenter.ActivityListDataManager:GetActivityOpenLv() and DataCenter.BuildManager.MainLv >= DataCenter.ActivityListDataManager:GetActivityOpenLv() then
        self.btn:SetActive(true)
    else
        self.btn:SetActive(false)
        return
    end
    
    DataCenter.ActivityListDataManager:SortActivityArr()
    local hasNew = DataCenter.ActivityListDataManager:CheckIfHasNew()
    if hasNew then
        self._activityRed_img:SetActive(false)
        self._activityEndN:SetActive(false)
        self._activityRedNew_img:SetActive(true)
    else
        self._activityRedNew_img:SetActive(false)
        local redDotCount = DataCenter.ActivityListDataManager:GetTotalRedDotCount()
        if redDotCount > 0 then
            self._activityEndN:SetActive(false)
            self._activityRed_img:SetActive(true)
            self._activityRedNum_txt:SetText(redDotCount)
        else
            self._activityRed_img:SetActive(false)
            local isToEnd = DataCenter.ActivityListDataManager:CheckIfAnyoneIsToEnd()
            if isToEnd then
                self._activityEndN:SetActive(true)
            else
                self._activityEndN:SetActive(false)
            end
        end
    end
end

function ActivityItem : OnClickBtn()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityCenterTable, { anim = true, UIMainAnim = UIMainAnimType.AllHide })
end

return ActivityItem
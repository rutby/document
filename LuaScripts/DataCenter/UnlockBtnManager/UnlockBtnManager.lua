---
--- Created by shimin.
--- DateTime: 2021/11/10 20:38
---
local UnlockBtnManager = BaseClass("UnlockBtnManager")
local Localization = CS.GameEntry.Localization

function UnlockBtnManager:__init()
    self.needUnlockBtn = {}--需要解锁的按钮（刷新性能）
    self:AddListener()
end

function UnlockBtnManager:__delete()
    self:RemoveListener()
    self.needUnlockBtn = {}--需要解锁的按钮（刷新性能）
end

function UnlockBtnManager:Startup()
 
end

function UnlockBtnManager:AddListener()
    if self.mainLvUpSignal == nil then
        self.mainLvUpSignal = function()
            self:MainLvUpSignal()
        end
        EventManager:GetInstance():AddListener(EventId.MainLvUp, self.mainLvUpSignal)
    end
    if self.questRewardSuccessSignal == nil then
        self.questRewardSuccessSignal = function(taskId)
            self:QuestRewardSuccessSignal(taskId)
        end
        EventManager:GetInstance():AddListener(EventId.QuestRewardSuccess, self.questRewardSuccessSignal)
    end
    if self.chapterTaskGetRewardSignal == nil then
        self.chapterTaskGetRewardSignal = function(taskId)
            self:ChapterTaskGetRewardSignal(taskId)
        end
        EventManager:GetInstance():AddListener(EventId.ChapterTaskGetReward, self.chapterTaskGetRewardSignal)
    end
    if self.buildUpgradeFinishSignal == nil then
        self.buildUpgradeFinishSignal = function()
            self:BuildUpgradeFinishSignal()
        end
        EventManager:GetInstance():AddListener(EventId.BuildUpgradeFinish, self.buildUpgradeFinishSignal)
    end
end

function UnlockBtnManager:RemoveListener()
    if self.mainLvUpSignal ~= nil then
        EventManager:GetInstance():RemoveListener(EventId.MainLvUp, self.mainLvUpSignal)
        self.mainLvUpSignal = nil
    end
    if self.questRewardSuccessSignal ~= nil then
        EventManager:GetInstance():RemoveListener(EventId.QuestRewardSuccess, self.questRewardSuccessSignal)
        self.questRewardSuccessSignal = nil
    end
    if self.chapterTaskGetRewardSignal ~= nil then
        EventManager:GetInstance():RemoveListener(EventId.ChapterTaskGetReward, self.chapterTaskGetRewardSignal)
        self.chapterTaskGetRewardSignal = nil
    end
    if self.buildUpgradeFinishSignal ~= nil then
        EventManager:GetInstance():RemoveListener(EventId.BuildUpgradeFinish, self.buildUpgradeFinishSignal)
        self.buildUpgradeFinishSignal = nil
    end
end

--是否可以显示按钮
function UnlockBtnManager:GetShowBtnState(btnType)
    local template = LocalController:instance():getLine(self:GetTableName(), btnType)
    if template ~= nil then
        --判断保底大本等级
        local baseLevel = template:getValue("safeguards_base_level", 0)
        if baseLevel ~= 0 then
            if CommonUtil.CheckIsBuildEnough(CommonUtil.GetBuildBaseType(baseLevel), CommonUtil.GetBuildLv(baseLevel)) then
                return UnlockBtnLockType.Show
            end
        end

        local lock_mode = template:getValue("lock_mode", 0)
        --条件是与的关系，需要全部满足
        local isShow = true
        --是否有一个条件满足
        local isOne = false
        local isOk = false
        
        --任务
        local unlockList = template:getValue("unlock_quest", {})
        if unlockList[1] ~= nil then
            isOk = true
            for k,v in ipairs(unlockList) do
                if not (DataCenter.TaskManager:IsFinishTask(tostring(v))
                        or DataCenter.ChapterTaskManager:CheckIsSuccess(v)) then
                    isShow = false
                    isOk = false
                    break
                end
            end
            if isOk then
                isOne = true
            end
        end
        if isShow or (lock_mode == UnlockBtnLockType.Normal and not isOne) then
            --章节
            unlockList = template:getValue("unlock_chapter", {})
            if unlockList[1] ~= nil then
                isOk = true
                for k,v in ipairs(unlockList) do
                    if not DataCenter.ChapterTaskManager:IsFinishChapter(v) then
                        isShow = false
                        isOk = false
                        break
                    end
                end
                if isOk then
                    isOne = true
                end
            end
        end

        if isShow or (lock_mode == UnlockBtnLockType.Normal and not isOne) then
            --建筑
            unlockList = template:getValue("unlock_building", {})
            if unlockList[1] ~= nil then
                isOk = true
                for k,v in ipairs(unlockList) do
                    if not CommonUtil.CheckIsBuildEnough(CommonUtil.GetBuildBaseType(v), CommonUtil.GetBuildLv(v)) then
                        isShow = false
                        isOk = false
                        break
                    end
                end
                if isOk then
                    isOne = true
                end
            end
        end

        if isShow or (lock_mode == UnlockBtnLockType.Normal and not isOne) then
            --引导
            unlockList = template:getValue("unlock_noviceboot", {})
            if unlockList[1] ~= nil then
                isOk = true
                for k,v in ipairs(unlockList) do
                    if not DataCenter.GuideManager:IsDoneThisGuide(v) then
                        isShow = false
                        isOk = false
                        break
                    end
                end
                if isOk then
                    isOne = true
                end
            end
        end
        if not isShow then
            if lock_mode == UnlockBtnLockType.Normal then
                if not isOne then
                    lock_mode = UnlockBtnLockType.Hide
                end
            end
            self.needUnlockBtn[btnType] = lock_mode
            return lock_mode
        end
    end
    return UnlockBtnLockType.Show
end



function UnlockBtnManager:StartUnlockBtn(btnType)
    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Ue_Unclock)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIUnlockBtnPanel, NormalPanelAnim, btnType)
end

function UnlockBtnManager:GetUnlockBtnIconName(btnType)
    local icon = GetTableData(self:GetTableName(), btnType, "icon", "")
    if icon ~= "" then
        --这里导表有问题，带/符号不能使用array，用了游戏崩
        local str = string.split_ss_array(icon, ";")
        return str[1]
    end
    
    if btnType == UnlockBtnType.Quest then
        return UIMainBtnIconName[UIMainFunctionInfo.Task]
    elseif btnType == UnlockBtnType.Story then
        return UIMainBtnIconName[UIMainFunctionInfo.Story]
    elseif btnType == UnlockBtnType.Hero then
        return UIMainBtnIconName[UIMainFunctionInfo.Hero]
    elseif btnType == UnlockBtnType.Bag then
        return UIMainBtnIconName[UIMainFunctionInfo.Goods]
    elseif btnType == UnlockBtnType.Shop then
        return UIMainBtnIconName[UIMainFunctionInfo.Store]
    elseif btnType == UnlockBtnType.Alliance then
        return UIMainBtnIconName[UIMainFunctionInfo.Alliance]
    elseif btnType == UnlockBtnType.Chat then
        return UIMainBtnIconName[UIMainFunctionInfo.Chat]
    elseif btnType == UnlockBtnType.SevenLogin then
        return UIMainBtnIconName[UIMainFunctionInfo.Activity]
    elseif btnType == UnlockBtnType.SevenActivity then
        return "Assets/Main/Sprites/UI/UIMain/UIMain_icon_7day"
    elseif btnType == UnlockBtnType.FirstPay then
        return UIMainBtnIconName[UIMainFunctionInfo.Activity]
    elseif btnType == UnlockBtnType.VIP then
        return "Assets/Main/Sprites/UI/UIMain/com_but_4"
    elseif btnType == UnlockBtnType.DiamondShop then
        return "Assets/Main/Sprites/UI/UIMain/com_jixu"
    elseif btnType == UnlockBtnType.World then
        return "Assets/Main/Sprites/UI/UIMain/but_icon_da_5_1"
    elseif btnType == UnlockBtnType.Activity then
        return UIMainBtnIconName[UIMainFunctionInfo.Activity]
    end
end

function UnlockBtnManager:GetIconScale(btnType)
    local scale = 1
    local icon = GetTableData(self:GetTableName(), btnType, "icon", "")
    if icon ~= "" then
        --这里导表有问题，带/符号不能使用array，用了游戏崩
        local str = string.split_ss_array(icon, ";")
        if str[2] ~= nil and str[2] ~= "" then
            scale = tonumber(str[2])
        end
    end
    return Vector3.New(scale, scale, scale)
end

function UnlockBtnManager:GetFlyIconScale(btnType)
    local scale = 1
    local icon = GetTableData(self:GetTableName(), btnType, "icon", "")
    if icon ~= "" then
        --这里导表有问题，带/符号不能使用array，用了游戏崩
        local str = string.split_ss_array(icon, ";")
        if str[3] ~= nil and str[3] ~= "" then
            scale = tonumber(str[3])
        end
    end
    return scale
end

function UnlockBtnManager:StartFlyUnlockBtn(btnType)
    if DataCenter.GuideManager:InGuide() then
        EventManager:GetInstance():Broadcast(EventId.UINoInput,UINoInputType.ShowNoUI)
    end
    local icon = self:GetUnlockBtnIconName(btnType)
    local srcPos = CS.SceneManager.World:WorldToScreenPoint(CS.SceneManager.World.CurTarget)
    local fly_type = GetTableData(self:GetTableName(), btnType, "fly_type", 0)
    if fly_type == 0 then
        fly_type = btnType
    end
    local destPos = self:GetUnlockBtnPosition(fly_type)
    local scale = 1
    if btnType == UnlockBtnType.Quest then
        scale = 0.48
    elseif btnType == UnlockBtnType.Story then
        scale = 0.7
    else
        scale = self:GetFlyIconScale(btnType)
    end
    UIUtil.DoFlyCustom(icon, nil, 1, srcPos, destPos, 0, 0, function()
        self.needUnlockBtn[btnType] = nil
        local template = DataCenter.GuideManager:GetCurTemplate()
        if template ~= nil and template.type == GuideType.UnlockBtn then
            DataCenter.GuideManager:DoNext()
        end
        EventManager:GetInstance():Broadcast(EventId.ShowUnlockBtn, btnType)
    end, UIAssets.FlyUnlockBtn, 0, 0, scale)
end

function UnlockBtnManager:StartFlyOnlyUnlockBtn(btnType)
    if DataCenter.GuideManager:InGuide() then
        EventManager:GetInstance():Broadcast(EventId.UINoInput,UINoInputType.ShowNoUI)
    end
    local srcPos = CS.SceneManager.World:WorldToScreenPoint(CS.SceneManager.World.CurTarget)
    local fly_type = GetTableData(self:GetTableName(), btnType, "fly_type", 0)
    if fly_type == 0 then
        fly_type = btnType
    end
    local destPos = self:GetUnlockBtnPosition(fly_type)
    DataCenter.FurnitureEffectManager:ShowOneFurnitureTrailEffect(srcPos, destPos, 0.7, function()
        self.needUnlockBtn[btnType] = nil
        local template = DataCenter.GuideManager:GetCurTemplate()
        if template ~= nil and template.type == GuideType.UnlockBtn then
            DataCenter.GuideManager:DoNext()
        end
        EventManager:GetInstance():Broadcast(EventId.ShowUnlockBtn, btnType)
    end)
end

function UnlockBtnManager:GetUnlockBtnPosition(btnType)
    local scale = UIManager:GetInstance():GetScaleFactor()
    if btnType == UnlockBtnType.Quest then
        --这里取坐标是错的，因为父类有layout，隐藏时的坐标是错的，只能写死，不能动态拿
        return Vector3.New(51 * scale, 222 * scale, 0)
    elseif btnType == UnlockBtnType.Story then
        return Vector3.New(51 * scale, 272  * scale, 0)
    elseif btnType == UnlockBtnType.Hero then
        return UIUtil.GetUIMainSavePos(UIMainSavePosType.Hero)
    elseif btnType == UnlockBtnType.Bag then
        return UIUtil.GetUIMainSavePos(UIMainSavePosType.Goods)
    elseif btnType == UnlockBtnType.Shop then
        return UIUtil.GetUIMainSavePos(UIMainSavePosType.Shop)
    elseif btnType == UnlockBtnType.Alliance then
        return Vector3.New(687 * scale, 427 * scale, 0)
    elseif btnType == UnlockBtnType.Chat then
        return UIUtil.GetUIMainSavePos(UIMainSavePosType.Chat)
    elseif btnType == UnlockBtnType.SevenLogin then
        return UIUtil.GetUIMainSavePos(UIMainSavePosType.SevenLogin)
    elseif btnType == UnlockBtnType.SevenActivity then
        return Vector3.New(693.5 * scale, Screen.height -262 * scale, 0)
    elseif btnType == UnlockBtnType.FirstPay then
        return UIUtil.GetUIMainSavePos(UIMainSavePosType.FirstPay)
    elseif btnType == UnlockBtnType.VIP then
        return UIUtil.GetUIMainSavePos(UIMainSavePosType.VIP)
    elseif btnType == UnlockBtnType.DiamondShop then
        return UIUtil.GetUIMainSavePos(UIMainSavePosType.Gold)
    elseif btnType == UnlockBtnType.World then
        return UIUtil.GetUIMainSavePos(UIMainSavePosType.World)
    elseif btnType == UnlockBtnType.PeopleCome then
        return UIUtil.GetUIMainSavePos(UIMainSavePosType.VitaMessage)
    elseif btnType == UnlockBtnType.Activity then
        return Vector3.New(693.5 * scale, Screen.height - 157.4999 * scale, 0)
    end
end

function UnlockBtnManager:GetTableName()
    return TableName.UnlockBtn
end

function UnlockBtnManager:MainLvUpSignal()
    self:CheckAllUnlockBtn()
end

function UnlockBtnManager:CheckAllUnlockBtn()
    local state = 0
    for k, v in pairs(self.needUnlockBtn) do
        state = self:GetShowBtnState(k)
        if state ~= v then
            if state == UnlockBtnLockType.Show then
                self.needUnlockBtn[k] = nil
            else
                self.needUnlockBtn[k] = state
            end
            EventManager:GetInstance():Broadcast(EventId.ShowUnlockBtn, k)
        end
    end
end

function UnlockBtnManager:MainLvUpSignal(taskId)
    self:CheckAllUnlockBtn()
end

function UnlockBtnManager:QuestRewardSuccessSignal(taskId)
    self:CheckAllUnlockBtn()
end

function UnlockBtnManager:ChapterTaskGetRewardSignal(taskId)
    self:CheckAllUnlockBtn()
end

function UnlockBtnManager:BuildUpgradeFinishSignal()
    self:CheckAllUnlockBtn()
end

return UnlockBtnManager

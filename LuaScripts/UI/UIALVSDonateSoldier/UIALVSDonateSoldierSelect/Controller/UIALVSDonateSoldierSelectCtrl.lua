local UIALVSDonateSoldierSelectCtrl = BaseClass("UIALVSDonateSoldierSelectCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIALVSDonateSoldierSelect)
end

local function OnSoldierNumberChange(self)

end

local function OnDonateBtnClick(self)
    --判断如果要是没有选择士兵 就不让捐
    local canDonate = false
    for _,v in pairs(self.armyList) do
        if v.count > 0 then
            canDonate = true
        end
    end

    if canDonate then
        local show = Setting:GetPrivateInt("SHOW_DONATE_SOLDIER_CONFIRM", 0)

        -- if show == 1 then
        --     --show为1则勾选了不再显示 直接发送请求
        --     SFSNetwork.SendMessage(MsgDefines.DonateArmy, self.armyList)
        --     self:CloseSelf()
        -- else
            UIUtil.ShowSecondMessage(
                Localization:GetString("372788"), --标题
                Localization:GetString("372789"), --内容 
                2, --按钮数量
                372788, --按钮文字1
                "", --按钮文字2
                function() --按钮1回调
                    SFSNetwork.SendMessage(MsgDefines.ALVSDonateArmy, self.armyList)
                    self:CloseSelf()
                end
            )
        -- end

    else
        --选择了0个士兵
    end
end

local function OnConfirmDonate(self)
    self:CloseSelf()
end

local function GetSoldierList(self)
    return self.armyList
end

local function InitSoldierData(self)
    self:RefreshCurrMaxSoldier(true)
end

local function RefreshCurrMaxSoldier(self, initData)
    if initData == true then
        self.armyList = {}
    end
    self.maxCanDonateScore = 0
    local currSoldierScore = 0
    local freeSoldiers = DataCenter.ArmyFormationDataManager:GetArmyUnFormationList()
    self.maxSoldiers ={}
    table.walksort(freeSoldiers,function (leftKey,rightKey)
        local aData = DataCenter.ArmyManager:FindArmy(leftKey)
        local bData = DataCenter.ArmyManager:FindArmy(rightKey)
        if aData.level ~= bData.level then
            return aData.level > bData.level
        end
        return aData.id > bData.id
    end, function (k,v)
        --判断 没有在配置里面的士兵不显示在列表里面
        local score = DataCenter.ActivityALVSDonateSoldierManager:OnGetOneScoreBySoldierId(k)
        if score == 0 or score == nil then
            return
        end
        if v>0 then
            currSoldierScore = currSoldierScore + v * score
            self.maxSoldiers[k] = v
            if initData == true then
                table.insert(self.armyList, {armyId = k, count = 0})
            end
        end
    end)

    --今天可捐献的总分数计算方式 （已捐献的分数 + 当前所有的可捐献士兵 * 每个士兵的分数）* 捐兵比例 - 已捐献的分数
    self.maxCanDonateScore = (DataCenter.ActivityALVSDonateSoldierManager:GetTodayDonateSumScore() + currSoldierScore) * DataCenter.ActivityALVSDonateSoldierManager:GetTodayDonateLimitPercent() - DataCenter.ActivityALVSDonateSoldierManager:GetTodayDonateSumScore()
end

local function GetCurrentSoldierNum(self, armyId)
    if self.armyList == nil then
        self.armyList = {}
    end
    local count = 0
    for _,v in ipairs(self.armyList) do
        if v.armyId == armyId then
            count = v.count
            break
        end
    end

    return count
end

local function IsDonateSoldierScoreReachMax(self, armyId, number)
    if self.armyList == nil then
        self.armyList = {}
    end

    for _,v in ipairs(self.armyList) do
        if v.armyId == armyId then
            v.count = number
            break
        end
    end
end

local function SetCurrentSoldierNum(self, armyId, number)
    if self.armyList == nil then
        self.armyList = {}
    end

    for _,v in ipairs(self.armyList) do
        if v.armyId == armyId then
            v.count = number
            break
        end
    end
end

-- 获取当前的等级
local function GetCurrLevelNum(self)
    local currLevel = 0
    local currSelfScore = DataCenter.ActivityALVSDonateSoldierManager:GetScoreNumberByType(0)
    local currAllianceScore = DataCenter.ActivityALVSDonateSoldierManager:GetScoreNumberByType(1)

    local stageArr = DataCenter.ActivityALVSDonateSoldierManager:OnGetRewardStageArr()
    for k, v in ipairs(stageArr) do
        if currSelfScore >= v.needUserScore and currAllianceScore >= v.needAllianceScore then
            currLevel = k
        else
            break
        end
    end

    return currLevel
end

-- 获取增加的分数和等级
local function GetAddScoreAndLevelNum(self)
    local addScore = 0
    local addLevel = 0

    local currSelfScore = DataCenter.ActivityALVSDonateSoldierManager:GetScoreNumberByType(0)
    local currAllianceScore = DataCenter.ActivityALVSDonateSoldierManager:GetScoreNumberByType(1)

    for _, v in pairs(self.armyList) do
        local soldierId = v.armyId
        local soldierCount = v.count
        local oneScore = DataCenter.ActivityALVSDonateSoldierManager:OnGetOneScoreBySoldierId(soldierId)
        addScore = addScore + oneScore * soldierCount
    end
    
    local stageArr = DataCenter.ActivityALVSDonateSoldierManager:OnGetRewardStageArr()
    for k, v in ipairs(stageArr) do
        if currSelfScore >= v.needUserScore and currAllianceScore >= v.needAllianceScore then
            -- continue
        elseif currSelfScore + addScore >= v.needUserScore and currAllianceScore + addScore >= v.needAllianceScore then
            addLevel = addLevel + 1
        end
    end

    return addScore, addLevel
end

-- 检测按照分数计算当前捐献的士兵是否已达捐献上限 如果达到上限则返回上限的数值
local function CheckCurrArmyDonateScoreReachMaxLimit(self, armyId, count)
    if self.armyList == nil then
        self.armyList = {}
    end

    local otherArmyScore = 0
    for _, v in pairs(self.armyList) do
        local soldierId = v.armyId
        if soldierId ~= armyId then
            --除了当前选择的士兵以外的所有士兵总分数
            local selectCnt = v.count
            local oneScore = DataCenter.ActivityALVSDonateSoldierManager:OnGetOneScoreBySoldierId(soldierId)
            otherArmyScore = otherArmyScore + selectCnt * oneScore
        end
    end

    --当前兵种可以捐的分数 （总限制分数-其他兵种已经选择的士兵的分数）
    local curArmyLimitScore = math.max(0, self.maxCanDonateScore - otherArmyScore)
    --当前兵种
    local curArmyOneScore = DataCenter.ActivityALVSDonateSoldierManager:OnGetOneScoreBySoldierId(armyId)
    local canDonateSoldierCount = math.floor(curArmyLimitScore / curArmyOneScore)

    if count >= canDonateSoldierCount then
        return true, canDonateSoldierCount
    else
        return false, count
    end
end

local function GetArmyData(self,armyId)
    local oneData ={}
    oneData.name =""
    oneData.armyId = armyId
    oneData.maxNum = self.maxSoldiers[armyId]
    oneData.icon =""
    oneData.level = 0
    local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(armyId)
    if template ~= nil then
        oneData.icon = string.format(LoadPath.SoldierIcons,template.icon)
        oneData.name = Localization:GetString(template.name)
        oneData.level = template.level
    end
    return oneData
end

local function CheckMax(self,armyId,num)
    --不限最大数量
    -- local oneMaxNum = self.maxSoldiers[armyId]
    -- local oneCurrentNum = self:GetCurrentSoldierNum(armyId)
    -- local currentTotalNum = self:GetTotalSoldierNum()
    -- local restNum = currentTotalNum - oneCurrentNum

    -- local checkMax = math.min(oneMaxNum,num)--滑动条最大限度
    -- local totalRest = self.maxNum - restNum -- 剩余兵空间最大限度

    -- local final =math.min(totalRest,checkMax)
    -- if final<0 then
    --     final =0
    -- end
    return num
end

UIALVSDonateSoldierSelectCtrl.CloseSelf = CloseSelf
UIALVSDonateSoldierSelectCtrl.OnSoldierNumberChange = OnSoldierNumberChange
UIALVSDonateSoldierSelectCtrl.OnDonateBtnClick = OnDonateBtnClick
UIALVSDonateSoldierSelectCtrl.GetSoldierList = GetSoldierList
UIALVSDonateSoldierSelectCtrl.GetCurrentSoldierNum = GetCurrentSoldierNum
UIALVSDonateSoldierSelectCtrl.SetCurrentSoldierNum = SetCurrentSoldierNum
UIALVSDonateSoldierSelectCtrl.GetArmyData = GetArmyData
UIALVSDonateSoldierSelectCtrl.RefreshCurrMaxSoldier = RefreshCurrMaxSoldier
UIALVSDonateSoldierSelectCtrl.CheckMax = CheckMax
UIALVSDonateSoldierSelectCtrl.InitSoldierData = InitSoldierData
UIALVSDonateSoldierSelectCtrl.GetAddScoreAndLevelNum = GetAddScoreAndLevelNum
UIALVSDonateSoldierSelectCtrl.GetCurrLevelNum = GetCurrLevelNum
UIALVSDonateSoldierSelectCtrl.OnConfirmDonate = OnConfirmDonate
UIALVSDonateSoldierSelectCtrl.IsDonateSoldierScoreReachMax = IsDonateSoldierScoreReachMax
UIALVSDonateSoldierSelectCtrl.CheckCurrArmyDonateScoreReachMaxLimit = CheckCurrArmyDonateScoreReachMaxLimit

return UIALVSDonateSoldierSelectCtrl
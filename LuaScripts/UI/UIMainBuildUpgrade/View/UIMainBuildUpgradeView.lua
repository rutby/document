local UIMainBuildUpgradeView = BaseClass("UIMainBuildUpgradeView", UIBaseView)
local base = UIBaseView
local UICommonItem = require "UI.UICommonItem.UICommonItem"
local UIMainBuildUpgradeItem = require "UI.UIMainBuildUpgrade.Component.UIMainBuildUpgradeItem"

--显示阶段节点枚举
local MainBuildUpgradeState = {
    LevelUpgrade = 1,
    RewardUpgrade = 2,
    HeroLevelUpgrade = 3,
    NewBuildUpgrade = 4,
}
local cellDelay = 0.125
local lineCount = 4

local oldLevelText_path = "Content/oldLevel"
local bg1_path = "Content/bg1"
local bg2_path = "Content/bg2"
local newLevelText1_1_path = "Content/bg1/newLevel1_1"
local newLevelText1_2_path = "Content/bg1/newLevel1_1/newLevel1_2"
local newLevelText2_1_path = "Content/bg2/newLevel2_1"
local newLevelText2_2_path = "Content/bg2/newLevel2_1/newLevel2_2"
local buildTitleText1_path = "Content/bg1/buildTitleText1"
local buildTitleText2_path = "Content/bg2/buildTitleText2"
local anni_path = "Content"
local btnNext_path = "btnNext"
local btnNextText_path = "Content/TxtClick"
-- 等级升级
local levelUpgrade_path = "Content/LevelUpgrade"
local levelEffectNode_path = "Content/LevelUpgrade/upgradeEffectNode"
-- 奖励阶段
local rewardUpgrade_path = "Content/RewardUpgrade"
local rewardScrollView_path = "Content/RewardUpgrade/rewardScrollView"
local rewardScrollContent_path = "Content/RewardUpgrade/rewardScrollView/Viewport/Content"
-- 英雄等级提升阶段
local heroLevelUpgrade_path = "Content/HeroLevelUpgrade"
local oldHeroLevelText_path = "Content/HeroLevelUpgrade/oldHeroLevel"
local newHeroLevelText_path = "Content/HeroLevelUpgrade/newHeroLevel"
--新建筑解锁阶段
local newBuildUpgrade_path = "Content/NewBuildUpgrade"
local newBuildScrollView_path = "Content/NewBuildUpgrade/newBuildScrollView"
local newBuildScrollContent_path = "Content/NewBuildUpgrade/newBuildScrollView/Viewport/NewBuildContent"
local newBuildEffectNode_path =  "Content/NewBuildUpgrade/newBuildEffectNode"

function UIMainBuildUpgradeView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self.curState = MainBuildUpgradeState.LevelUpgrade
    local buildId,mainBuildLv,rewardParam = self:GetUserData()
    self.rewardParam = rewardParam
    self.buildLevel = mainBuildLv
    self.buildId = buildId + mainBuildLv --400006--
    self:InitData()
    self:RefreshInfoByState()
end

function UIMainBuildUpgradeView:ComponentDefine()
    self.bg1 = self:AddComponent(UIBaseContainer,bg1_path)
    self.bg2 = self:AddComponent(UIBaseContainer,bg2_path)
    self.oldLevelText = self:AddComponent(UITextMeshProUGUIEx,oldLevelText_path)
    self.newLevelText1_1 = self:AddComponent(UITextMeshProUGUIEx,newLevelText1_1_path)
    self.newLevelText1_2 = self:AddComponent(UITextMeshProUGUIEx,newLevelText1_2_path)
    self.newLevelText2_1 = self:AddComponent(UITextMeshProUGUIEx,newLevelText2_1_path)
    self.newLevelText2_2 = self:AddComponent(UITextMeshProUGUIEx,newLevelText2_2_path)
    self.buildTitleText1 = self:AddComponent(UITextMeshProUGUIEx,buildTitleText1_path)
    self.buildTitleText2 = self:AddComponent(UITextMeshProUGUIEx,buildTitleText2_path)
    self.anni = self:AddComponent(UISimpleAnimation,anni_path)
    self.btnNext = self:AddComponent(UIButton,btnNext_path)
    self.btnNext:SetOnClick(function()
        self:onClickNextBtn()
    end)
    self.btnNextText = self:AddComponent(UITextMeshProUGUIEx,btnNextText_path)
    
    self.levelUpgradeNode = self:AddComponent(UIBaseContainer,levelUpgrade_path)
    self.levelEffectNode = self:AddComponent(UIBaseContainer,levelEffectNode_path)
    
    self.rewardUpgradeNode = self:AddComponent(UIBaseContainer,rewardUpgrade_path)
    self.rewardScrollView = self:AddComponent(UIScrollView,rewardScrollView_path)
    --self.rewardScrollView:SetOnItemMoveIn(function(itemObj, index)
    --    self:OnCreateCell(itemObj, index)
    --end)
    --self.rewardScrollView:SetOnItemMoveOut(function(itemObj, index)
    --    self:OnDeleteCell(itemObj, index)
    --end)
    self.rewardScrollContent = self:AddComponent(UIBaseContainer,rewardScrollContent_path)
    
    self.heroLevelUpgradeNode = self:AddComponent(UIBaseContainer,heroLevelUpgrade_path)
    self.oldHeroLevelText = self:AddComponent(UITextMeshProUGUIEx,oldHeroLevelText_path)
    self.newHeroLevelText = self:AddComponent(UITextMeshProUGUIEx,newHeroLevelText_path)
    
    self.newBuildUpgradeNode = self:AddComponent(UIBaseContainer,newBuildUpgrade_path)
    self.newBuildScrollView = self:AddComponent(UIScrollView,newBuildScrollView_path)
    self.newBuildScrollView:SetOnItemMoveIn(function(itemObj, index)
        self:OnCreateCell(itemObj, index)
    end)
    self.newBuildScrollView:SetOnItemMoveOut(function(itemObj, index)
        self:OnDeleteCell(itemObj, index)
    end)
    self.newBuildScrollContent = self:AddComponent(UIBaseContainer,newBuildScrollContent_path)
    self.newBuildEffectNode = self:AddComponent(UIBaseContainer,newBuildEffectNode_path)
end

function UIMainBuildUpgradeView:InitData()
    self.unlockData = {}
    self.oldHeroLevel = 0
    self.newHeroLevel = 0
    local info = GetTableData(DataCenter.BuildTemplateManager:GetTableName(), self.buildId,"upgrade_tips")
    if info and info ~= "" then
        local stringData = string.split(info,"|")
        for i = 1, #stringData do
            local data = string.split(stringData[i],";")
            local upGradeUpData = string.split(data[2],",")
            if tonumber(data[1]) == 1 or tonumber(data[1]) == 2 then --1 活动id 2 建筑id
                for i = 1, #upGradeUpData do
                    local temp = {
                        type = tonumber(data[1]),
                        id = tonumber(upGradeUpData[i])
                    }
                   table.insert(self.unlockData,temp) 
                end
            elseif tonumber(data[1]) == 3 then  --英雄等级数据
                self.oldHeroLevel = upGradeUpData[1]
                self.newHeroLevel = upGradeUpData[2]
            end
        end
    else 
        Logger.LogError("Building upgrade_tips content is nil  id: "..self.buildId)
    end
end

function UIMainBuildUpgradeView:RefreshInfoByState()
    self.levelUpgradeNode:SetActive(self.curState == MainBuildUpgradeState.LevelUpgrade)
    self.rewardUpgradeNode:SetActive(self.curState == MainBuildUpgradeState.RewardUpgrade)
    self.heroLevelUpgradeNode:SetActive(self.curState == MainBuildUpgradeState.HeroLevelUpgrade)
    self.newBuildUpgradeNode:SetActive(self.curState == MainBuildUpgradeState.NewBuildUpgrade)
    self.btnNext.gameObject:SetActive(false)
    self.bg1.gameObject:SetActive(false)
    self.bg2.gameObject:SetActive(true)
    self.newLevelText1_1:SetText(tostring(self.buildLevel))
    self.newLevelText1_2:SetText(tostring(self.buildLevel))
    self.newLevelText2_1:SetText(tostring(self.buildLevel))
    self.newLevelText2_2:SetText(tostring(self.buildLevel))
    if self.curState == MainBuildUpgradeState.LevelUpgrade then
        self.bg1.gameObject:SetActive(true)
        self.bg2.gameObject:SetActive(false)
        self.oldLevelText:SetText(tostring(self.buildLevel-1))
        
        -- self.newLevelText1.gameObject:SetActive(false)
        local ret,time = self.anni:PlayAnimationReturnTime("LevelUpgrade")
        self:ClearTimer()
        self.anniTimer = TimerManager:DelayInvoke(function()
            self:ClearTimer()
            --self.newLevelText.gameObject:SetActive(true)
            --self.oldLevelText.gameObject:SetActive(false)
            self.btnNext.gameObject:SetActive(true)
        end, time)
    elseif self.curState == MainBuildUpgradeState.RewardUpgrade then
        self.buildTitleText2:SetLocalText(441057)
        self:RefreshRewardInfo()
    elseif self.curState == MainBuildUpgradeState.HeroLevelUpgrade then
        self.buildTitleText2:SetLocalText(441059)
        self:RefreshHeroLevelInfo()
        self.btnNext.gameObject:SetActive(true)
    elseif self.curState == MainBuildUpgradeState.NewBuildUpgrade then
        self.buildTitleText2:SetLocalText(441060)
        self:RefreshNewBuildInfo()
        self.btnNext.gameObject:SetActive(true)
    end
end

function UIMainBuildUpgradeView:RefreshRewardInfo()
    self:SetAllRewardsDestroy()
    self.rewardModelCount =0
    local list = DataCenter.RewardManager:ReturnRewardParamForView(self.rewardParam)
    self.rewardObjList = {}
    if list~=nil and #list>0 then
        for i = 1, table.length(list) do
            --复制基础prefab，每次循环创建一次
            self.rewardModelCount= self.rewardModelCount+1
            self.rewardModels[self.rewardModelCount] = self:GameObjectInstantiateAsync(UIAssets.UICommonItemSize, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject;
                go.gameObject:SetActive(false)
                go.transform:SetParent(self.rewardScrollContent.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                local nameStr = tostring(NameCount)
                go.name = nameStr
                NameCount = NameCount + 1
                local cell = self.rewardScrollContent:AddComponent(UICommonItem,nameStr)
                cell:ReInit(list[i])
                table.insert(self.rewardItemsList,cell)
                table.insert(self.rewardObjList,go)
                if tonumber(self.rewardModelCount) == #list then
                    self:PlayRewardItem()
                end
            end)
        end
    else
        self.btnNext.gameObject:SetActive(true)
    end
end

function UIMainBuildUpgradeView:PlayRewardItem()
    self.showAnim = true
    local seq = DOTween.Sequence()
    for index = 1, #self.rewardObjList do
        seq:AppendInterval(cellDelay):AppendCallback(function()
            if self.showAnim then
                local obj = self.rewardObjList[index]
                --if index > lineCount * 2 and #self.param.rewardList > lineCount * 2 then
                --    if self.param.isUpChange then
                --        self.scroll_view_change:ScrollToCell(index - lineCount, 750)
                --    else
                --        self.scroll_view:ScrollToCell(index - lineCount, 750)
                --    end
                --end
				obj.gameObject:SetActive(true)
                if index == #self.rewardObjList then
                    --self.skip_anim_btn.gameObject:SetActive(false)
                    self.showAnim = false
					self.btnNext.gameObject:SetActive(true)
                end
            end
        end)
    end
end

function UIMainBuildUpgradeView:RefreshHeroLevelInfo()
    self.oldHeroLevelText:SetText("LV."..self.oldHeroLevel)
    self.newHeroLevelText:SetText("LV."..self.newHeroLevel)
    local ret,time = self.anni:PlayAnimationReturnTime("HeroLevelUpgrade")
    --Logger.LogError("RefreshHeroLevelInfo  "..time..tostring(ret))
    self:ClearTimer()
    self.anniTimer = TimerManager:DelayInvoke(function()
       self:ClearTimer()
        --self.newHeroLevelText.gameObject:SetActive(true)
        --self.btnNext.gameObject:SetActive(true)
    end, time)
end

function UIMainBuildUpgradeView:onClickNextBtn()
    if self.curState == MainBuildUpgradeState.LevelUpgrade then
        if self.rewardParam and next(self.rewardParam) then
            self.curState = MainBuildUpgradeState.RewardUpgrade
        else
            self.curState = MainBuildUpgradeState.HeroLevelUpgrade
        end
    elseif self.curState == MainBuildUpgradeState.RewardUpgrade then
        self.curState = MainBuildUpgradeState.HeroLevelUpgrade
    elseif self.curState == MainBuildUpgradeState.HeroLevelUpgrade then
        self.curState = MainBuildUpgradeState.NewBuildUpgrade
    elseif self.curState == MainBuildUpgradeState.NewBuildUpgrade then
        self.ctrl:CloseSelf()
        return
    end
    self:RefreshInfoByState()
end

function UIMainBuildUpgradeView:ClearTimer()
    if self.anniTimer then
        self.anniTimer:Stop()
        self.anniTimer = nil
    end
end

function UIMainBuildUpgradeView:RefreshNewBuildInfo()
    local newBuildList = self.unlockData
    self.newBuildScrollView:SetTotalCount(#newBuildList)
    self.newBuildScrollView:RefillCells()
    
end

function UIMainBuildUpgradeView:DataDefine()
    self.delayTimer = nil
    self.delay_timer_callback = function()
        self:DelayTimerCallback()
    end
end

function UIMainBuildUpgradeView:OnCreateCell(itemObj, index)
    itemObj.name = tostring(index)
    local item = self.newBuildScrollView:AddComponent(UIMainBuildUpgradeItem, itemObj)
    item:SetData(self.unlockData[index])
end

function UIMainBuildUpgradeView:OnDeleteCell(itemObj, index)
    if self.newBuildScrollView then
        self.newBuildScrollView:RemoveComponent(itemObj.name, UIMainBuildUpgradeItem)
    end
end

function UIMainBuildUpgradeView:SetCellDestroy()
    if  self.newBuildScrollView then
        self.newBuildScrollView:ClearCells()
        self.newBuildScrollView:RemoveComponents(UIMainBuildUpgradeItem)
    end
end

function UIMainBuildUpgradeView:SetAllRewardsDestroy()
    self.rewardScrollContent:RemoveComponents(UICommonItem)
    if self.rewardModels~=nil then
        for k,v in pairs(self.rewardModels) do
            if v ~= nil then
                self:GameObjectDestroy(v)
            end
        end
    end
    self.rewardModels ={}
    self.rewardItemsList = {}
end

function UIMainBuildUpgradeView:DataDestroy()
    self.rewardScrollView = nil
    self.newBuildScrollView = nil
    self:RemoveDelayTimer()
end

function UIMainBuildUpgradeView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    self:SetCellDestroy()
    base.OnDestroy(self)
end

function UIMainBuildUpgradeView:OnEnable()
    base.OnEnable(self)
end

function UIMainBuildUpgradeView:OnDisable()
    base.OnDisable(self)
end

function UIMainBuildUpgradeView:OnAddListener()
    base.OnAddListener(self)
end

function UIMainBuildUpgradeView:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIMainBuildUpgradeView:AddDelayTimer(time)
    if self.delayTimer == nil then
        self.delayTimer = TimerManager:GetInstance():GetTimer(time, self.delay_timer_callback, self, true, false, false)
        self.delayTimer:Start()
    end
end

function UIMainBuildUpgradeView:RemoveDelayTimer()
    if self.delayTimer ~= nil then
        self.delayTimer:Stop()
        self.delayTimer = nil
    end
    self:ClearTimer()
end

function UIMainBuildUpgradeView:ComponentDestroy()
    
end

return UIMainBuildUpgradeView
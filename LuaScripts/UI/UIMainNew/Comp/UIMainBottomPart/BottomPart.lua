
local BottomPart = BaseClass("BottomPart", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ChatItem = require "UI.UIMainNew.Comp.UIMainBottomPart.UIMainChatItem"
local MailItem =  require "UI.UIMainNew.Comp.UIMainBottomPart.MailItem"
local AllianceItem =  require "UI.UIMainNew.Comp.UIMainBottomPart.AllianceItem"
local BagItem =  require "UI.UIMainNew.Comp.UIMainBottomPart.BagItem"
local WorldItem =  require "UI.UIMainNew.Comp.UIMainBottomPart.WorldItem"
--local WorldGotoItem = require "UI.UIMainNew.Comp.UIMainBottomPart.WorldGotoItem"
local BottomBaseItem = require "UI.UIMainNew.Comp.UIMainBottomPart.BottomBaseItem"
local BottomPartBtnItem = require "UI.UIMainNew.Comp.UIMainBottomPart.BottomPartBtnItem"
local TaskItem = require "UI.UIMainNew.Comp.TaskItem"
local WarningItem = require "UI.UIMainNew.Comp.UIMainBottomPart.WarningItem"
local UIMainBuild = require "UI.UIMainNew.Comp.UIMainBottomPart.UIMainBuild"
local MonsterTowerItem =  require "UI.UIMainNew.Comp.UIMainBottomPart.MonsterTowerItem"

local chatItem_path  ="ChatBtn"
local mailItem_path = "layoutRight/MailBtn"
local searchItem_path = "layoutLeft/search"
local story_path = "layoutLeft/story"
local heroItem_path = "hero"
local bagItem_path = "layoutRight/BagBtn"
local allianceItem_path = "layoutRight/AllianceBtn"
local noticeItem_path = "layoutRight/notice"
local worldItem_path = "world"
local radar_path = "layoutLeft/radar"
local taskItem_path = "layoutLeft/TaskBtn"
local monster_reward_path = "layoutLeft/monster_reward"
local warning_btn_path = "layoutRight/warning_btn"
local build_path = "layoutLeft/build"
local left_layout_path = "layoutLeft"
local right_layout_path = "layoutRight"
local monsterTower_path = "monsterTower"
function BottomPart : OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

function BottomPart : OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function BottomPart : OnEnable()
    base.OnEnable(self)
end

function BottomPart : OnDisable()
    base.OnDisable(self)
end

function BottomPart : ComponentDefine()
    self.left_layout = self:AddComponent(UIBaseContainer,left_layout_path)
    self.right_layout = self:AddComponent(UIBaseContainer,right_layout_path)
    self.chatItem = self:AddComponent(ChatItem,chatItem_path)
    self.mailItem = self:AddComponent(MailItem,mailItem_path)
    self.heroItem = self:AddComponent(BottomPartBtnItem,heroItem_path)
    self.bagItem = self:AddComponent(BagItem,bagItem_path)
    self.allianceItem = self:AddComponent(AllianceItem,allianceItem_path)
    self.noticeItem = self:AddComponent(BottomBaseItem,noticeItem_path)
    self.worldItem  = self:AddComponent(WorldItem,worldItem_path)
    self.searchItem = self:AddComponent(BottomBaseItem,searchItem_path)
    self.radarItem = self:AddComponent(BottomBaseItem,radar_path)
    self.storyItem = self:AddComponent(BottomBaseItem,story_path)
    self.monster_reward = self:AddComponent(BottomBaseItem,monster_reward_path)
    self.taskItem = self:AddComponent(TaskItem, taskItem_path)
    self.warning_btn = self:AddComponent(WarningItem, warning_btn_path)
    self.build = self:AddComponent(UIMainBuild, build_path)
    self.monsterTower = self:AddComponent(MonsterTowerItem,monsterTower_path)
end

function BottomPart : ComponentDestroy()

end

function BottomPart : DataDefine()
    self.lodCache  =0
end

function BottomPart : DataDestroy()

end

function BottomPart : OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.GetAllDetectInfo, self.OnRefreshRadarObj)
    self:AddUIListener(EventId.DetectInfoChange, self.OnRefreshRadarObj)
    self:AddUIListener(EventId.MailPush,self.UpdateMailCount)
    self:AddUIListener(EventId.UpdateMainAllianceRedCount, self.RefreshAllianceRedSignal)
    self:AddUIListener(EventId.HeroStationUpdate, self.RefreshHeroRedDot)
    self:AddUIListener(EventId.MainLvUp, self.MainLvUpSignal)
    self:AddUIListener(EventId.RefreshItems, self.RefreshItemSignal)
    self:AddUIListener(EventId.RefreshNotice, self.CheckNoticeItem)
    self:AddUIListener(EventId.RefreshMonsterRewardBag, self.CheckMonsterReward)
    self:AddUIListener(EventId.ActMonTowerBossKilled, self.CheckMonsterTower)
    self:AddUIListener(EventId.ActMonTowerChoiceDiff, self.CheckMonsterTower)
end

function BottomPart : OnRemoveListener()
    self:RemoveUIListener(EventId.GetAllDetectInfo, self.OnRefreshRadarObj)
    self:RemoveUIListener(EventId.DetectInfoChange, self.OnRefreshRadarObj)
    self:RemoveUIListener(EventId.MailPush,self.UpdateMailCount)
    self:RemoveUIListener(EventId.UpdateMainAllianceRedCount, self.RefreshAllianceRedSignal)
    self:RemoveUIListener(EventId.HeroStationUpdate, self.RefreshHeroRedDot)
    self:RemoveUIListener(EventId.MainLvUp, self.MainLvUpSignal)
    self:RemoveUIListener(EventId.RefreshItems, self.RefreshItemSignal)
    self:RemoveUIListener(EventId.RefreshNotice, self.CheckNoticeItem)
    self:RemoveUIListener(EventId.RefreshMonsterRewardBag, self.CheckMonsterReward)
    self:RemoveUIListener(EventId.ActMonTowerBossKilled, self.CheckMonsterTower)
    self:RemoveUIListener(EventId.ActMonTowerChoiceDiff, self.CheckMonsterTower)
    base.OnRemoveListener(self)
end

function BottomPart : RefreshAll()
    self.chatItem:ReInit()
    self.heroItem:Refresh(UIMainFunctionInfo.Hero)
    self.bagItem:Refresh(UIMainFunctionInfo.Goods)
    self.allianceItem:Refresh(UIMainFunctionInfo.Alliance)
    self.searchItem:Refresh(UIMainFunctionInfo.Search)
    self.storyItem:Refresh(UIMainFunctionInfo.Story)
    self.radarItem:Refresh(UIMainFunctionInfo.Radar)
    self.noticeItem:Refresh(UIMainFunctionInfo.Notice)
    self.monster_reward:Refresh(UIMainFunctionInfo.MonsterReward)
    self:CheckMonsterReward()
    self:CheckRadarItem()
    self:CheckNoticeItem()
    self:RefreshSearch()
    self:RefreshBag()
    self:RefreshHero()
    self:RefreshAlliance()
    self:RefreshChat()
    self:RefreshWorld()
    self:RefreshStory()
    self.mailItem:Refresh()
    self:RefreshTask()
    self:RefreshMail()
    self.build:Refresh()
    self:CheckMonsterTower()
    --self.map
end
function BottomPart:RefreshItemSignal()
    self:RefreshHeroRedDot()
end

function BottomPart:RefreshHeroRedDot()
    self.heroItem:RefreshRedDot()
end
function BottomPart:OnRefreshRadarObj()
    self.radarItem:RefreshRedDot()
end

function BottomPart:UpdateMailCount()
    self.mailItem:RefreshRedDot()
end
function BottomPart:RefreshSearch()
    if SceneUtils.GetIsInWorld() then
        self.searchItem:SetActive(true)
    else
        self.searchItem:SetActive(false)
    end
end

function BottomPart:OnEnterWorld()
    self:RefreshSearch()
    self:RefreshStory()
    self:CheckRadarItem()
    self:CheckNoticeItem()
    self.worldItem:ResetBtnState()
    self.build:Refresh()
end
function BottomPart:OnEnterCity()
    self:RefreshSearch()
    self:RefreshStory()
    self:CheckRadarItem()
    self:CheckNoticeItem()
    self.worldItem:ResetBtnState()
    self.build:Refresh()
end


function BottomPart:GetSavePos(posType)
    local scale = UIManager:GetInstance():GetScaleFactor()
    if posType == UIMainSavePosType.Goods then
        return self.bagItem.transform.position
    elseif posType == UIMainSavePosType.Story then
        return self.storyItem.transform.position
    elseif posType == UIMainSavePosType.Hero then
        return Vector3.New(83 * scale, 95 * scale, 0)
    elseif posType == UIMainSavePosType.Alliance then
        return Vector3.New(687 * scale, 427 * scale, 0)
    elseif posType == UIMainSavePosType.Chat then
        return self.chatItem.transform.position
    elseif posType == UIMainSavePosType.World then
        return self.worldItem.transform.position
    elseif posType == UIMainSavePosType.Quest then
        return self.taskItem.transform.position
    elseif posType == UIMainSavePosType.Search then
        return Vector3.New(51 * scale, 312 * scale, 0)
    elseif posType == UIMainSavePosType.LaDar then
        return Vector3.New(51 * scale, 405 * scale, 0)
    end
end

function BottomPart:ShowUnlockBtnSignal(btnType)
    if btnType == UnlockBtnType.Story then
        self:RefreshStory()
    elseif btnType == UnlockBtnType.Bag then
        self:RefreshBag()
    elseif btnType == UnlockBtnType.Hero then
        self:RefreshHero()
    elseif btnType == UnlockBtnType.Alliance then
        self:RefreshAlliance()
    elseif btnType == UnlockBtnType.Chat then
        self:RefreshChat()
    elseif btnType == UnlockBtnType.World then
        self:RefreshWorld()
    elseif btnType == UnlockBtnType.Quest then
        self:RefreshTask()
    elseif btnType == UnlockBtnType.Mail then
        self:RefreshMail()
    end
end

function BottomPart:RefreshStory()
    if SceneUtils.GetIsInCity() then
        local unlockBtnLockType = DataCenter.UnlockBtnManager:GetShowBtnState(UnlockBtnType.Story)
        if unlockBtnLockType == UnlockBtnLockType.Show then
            self.storyItem:SetActive(true)
        else
            self.storyItem:SetActive(false)
        end
    else
        self.storyItem:SetActive(false)
    end
end

function BottomPart:RefreshBag()
    local unlockBtnLockType = DataCenter.UnlockBtnManager:GetShowBtnState(UnlockBtnType.Bag)
    if unlockBtnLockType == UnlockBtnLockType.Show then
        self.bagItem:SetActive(true)
    else
        self.bagItem:SetActive(false)
    end
end

function BottomPart:RefreshHero()
    local unlockBtnLockType = DataCenter.UnlockBtnManager:GetShowBtnState(UnlockBtnType.Hero)
    if unlockBtnLockType == UnlockBtnLockType.Show then
        self.heroItem:SetActive(true)
        self.chatItem:SetImage1(false)
    else
        self.heroItem:SetActive(false)
        self.chatItem:SetImage1(true)
    end
end

function BottomPart:RefreshAlliance()
    local unlockBtnLockType = DataCenter.UnlockBtnManager:GetShowBtnState(UnlockBtnType.Alliance)
    if unlockBtnLockType == UnlockBtnLockType.Show then
        self.allianceItem:SetActive(true)
    else
        self.allianceItem:SetActive(false)
    end
end

function BottomPart:RefreshChat()
    local unlockBtnLockType = DataCenter.UnlockBtnManager:GetShowBtnState(UnlockBtnType.Chat)
    if unlockBtnLockType == UnlockBtnLockType.Show then
        self.chatItem:SetActive(true)
        self.chatItem:ReInit()
    else
        self.chatItem:SetActive(false)
    end
end

function BottomPart:RefreshWorld()
    local unlockBtnLockType = DataCenter.UnlockBtnManager:GetShowBtnState(UnlockBtnType.World)
    if unlockBtnLockType == UnlockBtnLockType.Show or unlockBtnLockType == UnlockBtnLockType.Normal then
        self.worldItem:SetActive(true)
        self.chatItem:SetImage2(false)
    else
        self.worldItem:SetActive(false)
        self.chatItem:SetImage2(true)
    end
end

function BottomPart:RefreshMail()
    local unlockBtnLockType = DataCenter.UnlockBtnManager:GetShowBtnState(UnlockBtnType.Mail)
    if unlockBtnLockType == UnlockBtnLockType.Show then
        self.mailItem:SetActive(true)
    else
        self.mailItem:SetActive(false)
    end
end

function BottomPart:UpdateLod(lod)
    self.lodCache = lod
    self.worldItem:SetLod(lod)
    if SceneUtils.GetIsInWorld() then
        if lod>3 then
            self.left_layout:SetActive(false)
            self.right_layout:SetActive(false)
            self.chatItem:SetActive(false)
            self.heroItem:SetActive(false)
        else
            self.left_layout:SetActive(true)
            self.right_layout:SetActive(true)
            self:RefreshChat()
            self:RefreshHero()
        end
    else
        self.left_layout:SetActive(true)
        self.right_layout:SetActive(true)
        self:RefreshChat()
        self:RefreshHero()
    end
end

function BottomPart:BuildDataSignal(bUuid)
    if bUuid ~= nil then
        local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(tonumber(bUuid))
        if buildData ~= nil then
            if buildData.itemId ==  BuildingTypes.FUN_BUILD_RADAR_CENTER then
                self:CheckRadarItem()
            end
        end
    end
end

function BottomPart:CheckRadarItem()
    local build = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_RADAR_CENTER)
    if build~=nil then
        self.radarItem:SetActive(true)
    else
        self.radarItem:SetActive(false)
    end
end

function BottomPart:CheckNoticeItem()
    if SceneUtils.GetIsInCity() then
        self.noticeItem:SetActive(DataCenter.WorldNoticeManager:CheckShow())
    else
        self.noticeItem:SetActive(false)
    end
end

function BottomPart:RefreshTask()
    local unlockBtnLockType = DataCenter.UnlockBtnManager:GetShowBtnState(UnlockBtnType.Quest)
    if unlockBtnLockType == UnlockBtnLockType.Show then
        self.taskItem:SetActive(true)
        self.taskItem:Refresh()
    else
        self.taskItem:SetActive(false)
    end
end

function BottomPart:RefreshAllianceRedSignal()
    if SceneUtils.GetIsInCity() or SceneUtils.GetIsInWorld() then
        self.allianceItem:RefreshRedDot()
    end
end

function BottomPart:CheckMonsterTower()
    local isShowBtn = false
    local unlockBtnLockType = DataCenter.UnlockBtnManager:GetShowBtnState(UnlockBtnType.Activity)
    if unlockBtnLockType == UnlockBtnLockType.Show then
        local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(ActivityEnum.ActivityType.MonsterTower)
        if #dataList > 0 then
            local activityId = dataList[1].id
            local actData = DataCenter.ActMonsterTowerData:GetInfoByActId(tonumber(activityId))
            if actData and actData.challengeInfo and actData.challengeInfo.curLevel < actData.maxLevel and actData.challengeInfo and actData.challengeInfo.difficulty ~= 0 then
                isShowBtn = true
                self.monsterTower:Refresh(activityId,dataList[1])
            end
        end
    end
    self.monsterTower:SetActive(isShowBtn)
end

function BottomPart:CheckMonsterReward()
    local num = DataCenter.CollectRewardDataManager:GetRewardCount()
    if num>0 then
        self.monster_reward:SetActive(true)
        self.monster_reward:RefreshRedDot()
    else
        self.monster_reward:SetActive(false)
    end
end

function BottomPart:StoryUpdateHangupTimeSignal()
    self.storyItem:RefreshRedDot()
end

function BottomPart:RefreshWarning(warningType)
    self.warning_btn:Refresh(warningType)
end

function BottomPart:RefreshCityBuildModelSignal()
    self.build:Refresh()
end

function BottomPart:MainLvUpSignal()
    self:RefreshHeroRedDot()
    self.build:Refresh()
end


return BottomPart
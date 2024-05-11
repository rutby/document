
--
-- PVE 通关奖励界面View
--

local UIPVELevelRewardView = BaseClass("UIPVELevelRewardView",UIBaseView)
local base = UIBaseView
local UIGiftRewardCell = require "UI.UIGiftPackageRewardGet.Component.UIGiftRewardCell"
local Localization = CS.GameEntry.Localization
local UIGuidePioneerHeroExpCell = require "UI.UIPVE.UIPVEResult.Component.UIGuidePioneerHeroExpCell"

local reward_go_path = "RewardGo"
local reward_panel_path = "RewardGo/Panel"
local reward_title_path = "RewardGo/Win/WinText"
local reward_scroll_view_path = "RewardGo/Vert/CellList"
local cup_path = "RewardGo/Win/ImgWin/Image (%s)"
local continue_path = "Continue"
local confirm_btn_path = "Confirm"
local confirm_text_path = "Confirm/ConfirmText"
local next_level_btn_path = "NextLevel"
local next_level_text_path = "NextLevel/NextLevelText"
local encore_btn_path = "Encore"
local encore_text_path = "Encore/EncoreText"
local restart_btn_path = "Restart"
local restart_text_path = "Restart/RestartText"
local star_list_path = "RewardGo/StarList"
local star_path = "RewardGo/StarList/Star"
local exp_go_path = "ExpGo"
local exp_desc_path = "ExpGo/ExpDesc"
local exp_count_path = "ExpGo/ExpCount"
local hero_list_path = "RewardGo/Vert/HeroList"
local ratio_go_path = "RewardGo/RatioGo"
local ratio_desc_path = "RewardGo/RatioGo/RatioDesc"
local ratio_count_path = "RewardGo/RatioGo/RatioCount"

local STAR_COUNT = 3
local STAR_BLACK_PATH = "Assets/Main/Sprites/Guide/UIbattle_img_star01"
local STAR_YELLOW_PATH = "Assets/Main/Sprites/Guide/UIbattle_img_star02"
local HERO_CELL_PATH = "Assets/Main/Prefab_Dir/Guide/UIGuidePioneerHeroExpCell.prefab"

local State =
{
    Normal = 1,
    RewardBox = 2, -- 宝箱奖励
    BattleExp = 3, -- 经验奖励
    TimeLimited_1 = 11,
    TimeLimited_2 = 12,
}

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

local function OnDestroy(self)
    self:ClearScroll()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.reward_go = self:AddComponent(UIBaseContainer, reward_go_path)
    self.reward_title_text = self:AddComponent(UIText, reward_title_path)
    self.reward_title_text:SetLocalText(400029)
    self.reward_panel_btn = self:AddComponent(UIButton, reward_panel_path)
    self.reward_panel_btn:SetOnClick(function()
        self:OnExitClick()
    end)
    self.reward_scroll_view = self:AddComponent(UIScrollView, reward_scroll_view_path)
    self.reward_scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCreateCell(itemObj, index)
    end)
    self.reward_scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnDeleteCell(itemObj, index)
    end)
    self.cup_gos = {}
    for i = 1, 5 do
        self.cup_gos[i] = self:AddComponent(UIBaseContainer, string.format(cup_path, i))
    end
    self.continue_text = self:AddComponent(UIText, continue_path)
    self.continue_text:SetLocalText(400028)
    self.confirm_btn = self:AddComponent(UIButton, confirm_btn_path)
    self.confirm_btn:SetOnClick(function()
        self:OnConfirmClick()
    end)
    self.confirm_text = self:AddComponent(UIText, confirm_text_path)
    self.confirm_text:SetLocalText(110006)
    self.next_level_btn = self:AddComponent(UIButton, next_level_btn_path)
    self.next_level_btn:SetOnClick(function()
        self:OnExitClick()
    end)
    self.next_level_text = self:AddComponent(UIText, next_level_text_path)
    self.next_level_text:SetLocalText(302278)
    self.encore_btn = self:AddComponent(UIButton, encore_btn_path)
    self.encore_btn:SetOnClick(function()
        self:OnEncoreClick()
    end)
    self.encore_text = self:AddComponent(UIText, encore_text_path)
    self.encore_text:SetLocalText(134021)
    self.restart_btn = self:AddComponent(UIButton, restart_btn_path)
    self.restart_btn:SetOnClick(function()
        self:OnRestartClick()
    end)
    self.restart_text = self:AddComponent(UIText, restart_text_path)
    self.restart_text:SetLocalText(120952)
    self.star_list_go = self:AddComponent(UIBaseContainer, star_list_path)
    self.star_images = {}
    for i = 1, STAR_COUNT do
        self.star_images[i] = self:AddComponent(UIImage, star_path .. i)
    end
    self.exp_go = self:AddComponent(UIBaseContainer, exp_go_path)
    self.exp_desc_text = self:AddComponent(UIText, exp_desc_path)
    self.exp_count_text = self:AddComponent(UIText, exp_count_path)
    self.hero_list_go = self:AddComponent(UIBaseContainer, hero_list_path)
    self.ratio_go = self:AddComponent(UIBaseContainer, ratio_go_path)
    self.ratio_desc_text = self:AddComponent(UIText, ratio_desc_path)
    self.ratio_desc_text:SetLocalText(390003)
    self.ratio_count_text = self:AddComponent(UIText, ratio_count_path)
end

local function ComponentDestroy(self)
    self.reward_go = nil
    self.reward_title_text = nil
    self.reward_panel_btn = nil
    self.reward_scroll_view = nil
    self.cup_gos = nil
    self.continue_text = nil
    self.confirm_btn = nil
    self.confirm_text = nil
    self.restart_btn = nil
    self.restart_text = nil
    self.star_list_go = nil
    self.star_images = nil
    self.exp_go = nil
    self.exp_desc_text = nil
    self.exp_count_text = nil
    self.hero_list_go:RemoveComponents(UIGuidePioneerHeroExpCell)
    self.hero_list_go = nil
    self.ratio_go = nil
    self.ratio_desc_text = nil
    self.ratio_count_text = nil
end

local function DataDefine(self)
    self.active = false
    self.heroCells = {}
end

local function DataDestroy(self)
    self.active = nil
    self.heroCells = nil
end

local function OnEnable(self)
    base.OnEnable(self)
    self.active = true
    self:ReInit()
end

local function OnDisable(self)
    self.active = false
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.RefreshExpFromMessage, self.OnRefreshExpFromMessage)
    self:AddUIListener(EventId.HeroBeyondSuccess, self.OnHeroBeyondSuccess)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.RefreshExpFromMessage, self.OnRefreshExpFromMessage)
    self:RemoveUIListener(EventId.HeroBeyondSuccess, self.OnHeroBeyondSuccess)
    base.OnRemoveListener(self)
end

local function ReInit(self)
    local param = self:GetUserData()
    self.levelId = param.levelId
    self.pveTemplate = DataCenter.PveLevelTemplateManager:GetTemplate(self.levelId)
    self.rewardList = param.rewardList
    self.onExitClick = param.onExitClick
    self.onRestartClick = param.onRestartClick
    self.onConfirmClick = param.onConfirmClick
    self.star = param.star or 0
    self.rewardIndex = param.rewardIndex or 0
    self.heroes = param.heroes
    self.ratio = self.pveTemplate.timeRewardList[self.rewardIndex + 1] or 1
    self.exp = param.totalExp or 0
    self.totalExp = math.floor(self.exp * self.ratio)
    self.extraExp = self.totalExp - self.exp
    if #self.heroes > 0 then
        --self.eachExp = math.floor(self.totalExp // #self.heroes)
        self.eachExp = self.totalExp
    else
        self.eachExp = 0
    end
    
    if self.rewardList == nil then
        self.rewardList = {}
    end
    if #self.rewardList > 0 then
        for i = #self.rewardList, 1, -1 do
            local v = self.rewardList[i]
            if v.count ~= nil and v.count <= 0 then
                table.remove(self.rewardList, i)
            end
        end
        self:ShowCells()
    end

    if DataCenter.BattleLevel:GetLevelType() == PveLevelType.BattleExpLevel then
        self:SetState(State.BattleExp)
    elseif self.pveTemplate:IsTimeLimited() then
        self:SetState(State.TimeLimited_1)
    elseif param.rewardBox then
        self:SetState(State.RewardBox)
    else
        self:SetState(State.Normal)
    end

    self.backupInfos = {}
    for _, heroUuid in pairs(self.heroes) do
        local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
        local backupInfo = {}
        backupInfo["oldLevel"] = heroData.level
        backupInfo["oldExp"] = heroData.exp
        self.backupInfos[heroUuid] = backupInfo
    end

    if DataCenter.BattleLevel:GetLevelType() == PveLevelType.HeroExpLevel then
        if self.eachExp > 0 then
            for _, heroUuid in pairs(self.heroes) do
                local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
                local heroExpInfo = {}
                heroExpInfo["heroUuid"] = heroUuid
                heroExpInfo["level"] = heroData.level
                heroExpInfo["nowExp"] = heroData.exp
                heroExpInfo["expAdd"] = self.eachExp
                self:AddHeroExpObj(heroExpInfo, self.backupInfos[heroUuid])
            end
            self.hero_list_go:SetActive(true)
        else
            self.hero_list_go:SetActive(false)
        end
    end

    if DataCenter.BattleLevel:GetLevelType() == PveLevelType.HeroExpLevel and
       DataCenter.BattleLevel:IsAutoPlay() then
        self.encore_btn:SetActive(true)
    else
        self.encore_btn:SetActive(false)
    end
end

local function SetState(self, state)
    self.state = state
    if state == State.Normal then
        self:ShowCup(true)
        self.reward_panel_btn:SetInteractable(true)
        self.reward_scroll_view:SetActive(true)
        self.continue_text:SetActive(true)
        self.confirm_btn:SetActive(false)
        self.next_level_btn:SetActive(false)
        self.restart_btn:SetActive(false)
        self.star_list_go:SetActive(false)
        self.exp_go:SetActive(false)
        self.hero_list_go:SetActive(false)
        self.ratio_go:SetActive(false)
        self.reward_title_text:SetLocalText(400029)
    elseif state == State.RewardBox then
        self:ShowCup(true)
        self.reward_scroll_view:SetActive(true)
        self.continue_text:SetActive(false)
        self.confirm_btn:SetActive(true)
        self.next_level_btn:SetActive(false)
        self.restart_btn:SetActive(false)
        self.star_list_go:SetActive(false)
        self.exp_go:SetActive(false)
        self.hero_list_go:SetActive(false)
        self.ratio_go:SetActive(false)
        self.reward_title_text:SetLocalText(400067)
        self.confirm_text:SetLocalText(110107)
    elseif state == State.TimeLimited_1 then
        self:ShowCup(false)
        self.reward_panel_btn:SetInteractable(false)
        self.reward_scroll_view:SetActive(false)
        self.continue_text:SetActive(false)
        self.confirm_btn:SetActive(true)
        self.next_level_btn:SetActive(false)
        self.restart_btn:SetActive(true)
        if self.pveTemplate:IsStarLevel() then
            self.star_list_go:SetActive(true)
            for i = 1, STAR_COUNT do
                if i <= self.star then
                    self.star_images[i]:LoadSprite(STAR_YELLOW_PATH)
                else
                    self.star_images[i]:LoadSprite(STAR_BLACK_PATH)
                end
            end
        else
            self.star_list_go:SetActive(false)
        end
        self.exp_go:SetActive(true)
        self.exp_desc_text:SetLocalText(104191)
        local expStr = "+" .. string.GetFormattedSeperatorNum(self.exp)
        if self.extraExp > 0 then
            expStr = expStr .. " <color=#00FF00FF>+" .. string.GetFormattedSeperatorNum(self.extraExp) .. "</color>"
        end
        self.exp_count_text:SetText(expStr)
        self.hero_list_go:SetActive(false)
        self.ratio_go:SetActive(true)
        local ratioStr = math.floor(((self.ratio - 1) * 100)) .. "%"
        self.ratio_count_text:SetText(ratioStr)
        self.reward_title_text:SetLocalText(400029)
        self.confirm_text:SetLocalText(110006)
    elseif state == State.TimeLimited_2 then
        self.reward_panel_btn:SetInteractable(true)
        self.continue_text:SetActive(true)
        self.confirm_btn:SetActive(false)
        self.next_level_btn:SetActive(false)
        self.restart_btn:SetActive(false)
        self.exp_go:SetActive(false)
        self.hero_list_go:SetActive(true)
        self.reward_title_text:SetLocalText(400029)
    elseif state == State.BattleExp then
        self:ShowCup(true)
        self.reward_panel_btn:SetInteractable(true)
        self.reward_scroll_view:SetActive(false)
        self.continue_text:SetActive(true)
        self.confirm_btn:SetActive(false)
        self.next_level_btn:SetActive(false)
        self.restart_btn:SetActive(false)
        self.star_list_go:SetActive(false)
        self.exp_go:SetActive(true)
        self.exp_desc_text:SetLocalText(400075)
        local expStr = "+" .. string.GetFormattedSeperatorNum(self.exp)
        if self.extraExp > 0 then
            expStr = expStr .. " <color=#00FF00FF>+" .. string.GetFormattedSeperatorNum(self.extraExp) .. "</color>"
        end
        self.exp_count_text:SetText(expStr)
        self.hero_list_go:SetActive(false)
        self.ratio_go:SetActive(false)
        self.reward_title_text:SetLocalText(400029)
    end
end

local function ShowCup(self, show)
    for i = 1, 5 do
        self.cup_gos[i]:SetActive(show)
    end
end

local function ClearScroll(self)
    self.reward_scroll_view:ClearCells()
    self.reward_scroll_view:RemoveComponents(UIGiftRewardCell)
end

local function OnCreateCell(self,itemObj, index)
    itemObj.name = tostring(index)
    local cellItem = self.reward_scroll_view:AddComponent(UIGiftRewardCell, itemObj)
    local rewardParam = self.rewardList[index]
    local param = UIGiftRewardCell.Param.New()
    param.rewardType = rewardParam.rewardType
    param.itemId = rewardParam.itemId
    param.count = rewardParam.count
    param.heroUuid = rewardParam.heroUuid
    param.isHeroBox = rewardParam.isHeroBox
    cellItem:ReInit(param)
    cellItem:Show(false)
end

local function OnDeleteCell(self, itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UIGiftRewardCell)
end

local function ShowCells(self)
    self:ClearScroll()
    self.reward_scroll_view:SetTotalCount(#self.rewardList)
    self.reward_scroll_view:RefillCells()
end

local function OnExitClick(self)
    if self.onExitClick then
        self.onExitClick()
    end
    if self.active then
        self.ctrl:CloseSelf()
    end
end

local function OnRestartClick(self)
    if self.onRestartClick then
        self.onRestartClick()
    end
end

local function OnEncoreClick(self)
    
end

local function OnConfirmClick(self)
    if self.onConfirmClick then
        self.onConfirmClick()
    end

    if self.state == State.TimeLimited_1 then
        self:SetState(State.TimeLimited_2)
    end
end

local function AddHeroExpObj(self, heroExpInfo, backupInfo)
    self:GameObjectInstantiateAsync(HERO_CELL_PATH, function(request)
        if request.isError then
            return
        end
        local go = request.gameObject
        go:SetActive(true)
        go.transform:SetParent(self.hero_list_go.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.transform:SetAsLastSibling()
        go.name = tostring(heroExpInfo.heroUuid)
        local itemObj = self.hero_list_go:AddComponent(UIGuidePioneerHeroExpCell, go.name)
        itemObj:InitData(heroExpInfo, backupInfo)
        self.heroCells[heroExpInfo.heroUuid] = itemObj
    end)
end

local function OnRefreshExpFromMessage(self, heroExpInfos)
    for _, heroExpInfo in ipairs(heroExpInfos) do
        local backupInfo = self.backupInfos[heroExpInfo.heroUuid]
        self:AddHeroExpObj(heroExpInfo, backupInfo)
    end
end

local function OnHeroBeyondSuccess(self, heroUuid)
    local cell = self.heroCells[heroUuid]
    if cell then
        cell:OnHeroBeyond()
    end
end

local function OnKeyEscape(self)
    self:OnExitClick()
end

UIPVELevelRewardView.OnCreate = OnCreate
UIPVELevelRewardView.OnDestroy = OnDestroy
UIPVELevelRewardView.OnEnable = OnEnable
UIPVELevelRewardView.OnDisable = OnDisable
UIPVELevelRewardView.OnAddListener = OnAddListener
UIPVELevelRewardView.OnRemoveListener = OnRemoveListener
UIPVELevelRewardView.ComponentDefine = ComponentDefine
UIPVELevelRewardView.ComponentDestroy = ComponentDestroy
UIPVELevelRewardView.DataDefine = DataDefine
UIPVELevelRewardView.DataDestroy = DataDestroy

UIPVELevelRewardView.ReInit = ReInit
UIPVELevelRewardView.SetState = SetState
UIPVELevelRewardView.OnDeleteCell = OnDeleteCell
UIPVELevelRewardView.ShowCells = ShowCells
UIPVELevelRewardView.OnCreateCell = OnCreateCell
UIPVELevelRewardView.ClearScroll = ClearScroll
UIPVELevelRewardView.ShowCup = ShowCup
UIPVELevelRewardView.OnExitClick = OnExitClick
UIPVELevelRewardView.OnRestartClick = OnRestartClick
UIPVELevelRewardView.OnEncoreClick = OnEncoreClick
UIPVELevelRewardView.OnConfirmClick = OnConfirmClick
UIPVELevelRewardView.AddHeroExpObj = AddHeroExpObj
UIPVELevelRewardView.OnRefreshExpFromMessage = OnRefreshExpFromMessage
UIPVELevelRewardView.OnHeroBeyondSuccess = OnHeroBeyondSuccess
UIPVELevelRewardView.OnKeyEscape = OnKeyEscape

return UIPVELevelRewardView

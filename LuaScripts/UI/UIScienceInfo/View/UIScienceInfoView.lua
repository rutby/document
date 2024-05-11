--- Created by shimin.
--- DateTime: 2020/7/14 17:28
--- 科技详情界面

local UIScienceInfoView = BaseClass("UIScienceInfoView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray

local UIDesCell = require "UI.UIBuildCreate.Component.UIDesCell"
local UITrainNeedResCell = require "UI.UITrain.Component.UITrainNeedResCell"
local UIScienceInfoPreCell = require "UI.UIScienceInfo.Component.UIScienceInfoPreCell"

local panel_path = "UICommonMidPopUpTitle/panel"
local mid_go_path = "UICommonMidPopUpTitle/bg_mid"
local close_btn_path = "UICommonMidPopUpTitle/bg_mid/CloseBtn"
local title_text_path = "UICommonMidPopUpTitle/bg_mid/titleText"
local details_btn_path = "UICommonMidPopUpTitle/bg_mid/detail_btn"
local science_icon_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/Icon_go/icon_bg/science_icon"
local level_text_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/Icon_go/icon_bg/text_bg/level_text"
local des_text_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/Icon_go/des_text"
local level_name_text_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/level_go/level_name_text"
local cur_level_text_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/level_go/cur_level_text"
local level_arrow_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/level_go/level_arrow"
local next_level_text_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/level_go/next_level_text"
local attr_go_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/attr_go"
local need_go_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/need_go"
local need_text_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/need_go/need_text"
local need_content_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/need_go/need_content"
local max_go_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/max_go"
local max_text_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/max_go/max_text"
local upgrading_go_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/upgrading_go"
local slider_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/upgrading_go/slider"
local slider_text_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/upgrading_go/slider/slider_text"
local btn_go_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/btn_go"
local yellow_btn_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/btn_go/yellow_btn"
local yellow_btn_text_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/btn_go/yellow_btn/GameObject/yellow_btn_text"
local yellow_btn_cost_text_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/btn_go/yellow_btn/GameObject/ImmediatelyValue"
local yellow_btn_cost_icon_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/btn_go/yellow_btn/GameObject/icon_go/ImmediatelyIcon"
local blue_btn_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/btn_go/blue_btn"
local blue_btn_text_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/btn_go/blue_btn/blue_btn_text"
local blue_upgrade_name_text_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/btn_go/blue_btn/GameObject/upgrade_name_text"
local blue_cost_time_text_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/btn_go/blue_btn/GameObject/cost_time_text"
local blue_cost_icon_go_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/btn_go/blue_btn/GameObject/icon_go"
local origin_time_btn_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/btn_go/blue_btn/origin_time_btn"
local origin_time_text_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/btn_go/blue_btn/origin_time_btn/origin_time_text"
local pre_go_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/pre_go"
local pre_content_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/pre_go/scroll_view/Viewport/pre_content"
local pre_time_text_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/pre_go/pre_time_text"
local gold_btn_path = "fullTop/gold_btn"
local gold_num_text_path = "fullTop/gold_btn/gold_num_text"
local origin_time_icon_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/btn_go/blue_btn/origin_time_btn/origin_time_text/Common_btn_info"

local SliderLength = 510
local SizeType =
{
    Pre = Vector2.New(716, 1065),
    Normal = Vector2.New(716, 970),
}

local State =
{
    Pre = 1,--缺少前置，
    Researching = 2,--正在研究
    Normal = 3,--正常可升级状态
    Max = 4,--最大等级状态
}

local NormalColor = Color.New(1, 1, 1, 1)
local MaxColor = Color.New(0.9686275,0.882353,0.3843138,1)

--创建
function UIScienceInfoView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
function UIScienceInfoView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIScienceInfoView:ComponentDefine()
    self.btn = self:AddComponent(UIButton, panel_path)
    self.btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
    self.details_btn = self:AddComponent(UIButton, details_btn_path)
    self.details_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnDetailsBtnClick()
    end)
    self.science_icon = self:AddComponent(UIImage, science_icon_path)
    self.level_text = self:AddComponent(UITextMeshProUGUIEx, level_text_path)
    self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
    self.level_name_text = self:AddComponent(UITextMeshProUGUIEx, level_name_text_path)
    self.cur_level_text = self:AddComponent(UITextMeshProUGUIEx, cur_level_text_path)
    self.level_arrow = self:AddComponent(UITextMeshProUGUIEx, level_arrow_path)
    self.next_level_text = self:AddComponent(UITextMeshProUGUIEx, next_level_text_path)
    self.attr_go = self:AddComponent(UIBaseContainer, attr_go_path)
    self.need_go = self:AddComponent(UIBaseContainer, need_go_path)
    self.need_text = self:AddComponent(UITextMeshProUGUIEx, need_text_path)
    self.need_content = self:AddComponent(UIBaseContainer, need_content_path)
    self.max_go = self:AddComponent(UIBaseContainer, max_go_path)
    self.max_text = self:AddComponent(UITextMeshProUGUIEx, max_text_path)
    self.upgrading_go = self:AddComponent(UIBaseContainer, upgrading_go_path)
    self.slider = self:AddComponent(UISlider, slider_path)
    self.slider_text = self:AddComponent(UITextMeshProUGUIEx, slider_text_path)
    self.btn_go = self:AddComponent(UIBaseContainer, btn_go_path)
    self.yellow_btn = self:AddComponent(UIButton, yellow_btn_path)
    self.yellow_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnYellowBtnClick()
    end)
    self.yellow_btn_text = self:AddComponent(UITextMeshProUGUIEx, yellow_btn_text_path)
    self.yellow_btn_cost_text = self:AddComponent(UITextMeshProUGUIEx, yellow_btn_cost_text_path)
    self.yellow_btn_cost_icon = self:AddComponent(UIImage, yellow_btn_cost_icon_path)
    self.blue_btn = self:AddComponent(UIButton, blue_btn_path)
    self.blue_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnBlueBtnClick()
    end)
    self.blue_btn_text = self:AddComponent(UITextMeshProUGUIEx, blue_btn_text_path)
    self.blue_upgrade_name_text = self:AddComponent(UITextMeshProUGUIEx, blue_upgrade_name_text_path)
    self.blue_cost_time_text = self:AddComponent(UITextMeshProUGUIEx, blue_cost_time_text_path)
    self.blue_cost_icon_go = self:AddComponent(UIBaseContainer, blue_cost_icon_go_path)
    self.origin_time_btn = self:AddComponent(UIButton, origin_time_btn_path)
    self.origin_time_btn:SetOnClick(function()
        self:OnOriginTimeBtnClick()
    end)
    self.origin_time_text = self:AddComponent(UITextMeshProUGUIEx, origin_time_text_path)
    self.pre_go = self:AddComponent(UIBaseContainer, pre_go_path)
    self.pre_content = self:AddComponent(UIBaseContainer, pre_content_path)
    self.pre_time_text = self:AddComponent(UITextMeshProUGUIEx, pre_time_text_path)
    self.gold_btn = self:AddComponent(UIButton, gold_btn_path)
    self.gold_btn:SetOnClick(function()
        self:OnGoldBtnClick()
    end)
    self.gold_num_text = self:AddComponent(UITextMeshProUGUIEx, gold_num_text_path)
    self.mid_go = self:AddComponent(UIBaseContainer, mid_go_path)
    self.origin_time_icon = self:AddComponent(UIBaseContainer, origin_time_icon_path)
end

function UIScienceInfoView:ComponentDestroy()
end

function UIScienceInfoView:DataDefine()
    self.isSendFinish = false
    self.scienceId = 0
    self.bUuid = 0
    self.queue = nil
    self.state = State.Normal
    self.needPreList = {}
    self.needPreCells = {}
    self.desList = {}
    self.desCells = {}
    self.needList = {}
    self.lackList = {}
    self.needCells = {}
    self.canShowDiamond = true
    self.lastCurTime = 0
    self.spendGold = 0
    self.lastTime = 0
    self.showBtnTime = 0
    self.isFree = false
    self.immediatelyBtnSpendColor = nil
    self.waitHelp = false
end

function UIScienceInfoView:DataDestroy()
end

function UIScienceInfoView:OnEnable()
    base.OnEnable(self)
end

function UIScienceInfoView:OnDisable()
    base.OnDisable(self)
end

function UIScienceInfoView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.UPDATE_SCIENCE_DATA, self.UpdateScienceSignal)
    self:AddUIListener(EventId.OnScienceQueueFinish, self.UpdateScienceSignal)
    self:AddUIListener(EventId.RefreshItems, self.UpdateItemSignal)
    self:AddUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
    self:AddUIListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildDataSignal)
    self:AddUIListener(EventId.ResourceUpdated, self.UpdateResourceSignal)
    self:AddUIListener(EventId.OnScienceQueueResearch, self.OnScienceSearchingSignal)
    self:AddUIListener(EventId.AllianceQueueHelpNew, self.AllianceQueueHelpNewSignal)
end


function UIScienceInfoView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.UPDATE_SCIENCE_DATA, self.UpdateScienceSignal)
    self:RemoveUIListener(EventId.OnScienceQueueFinish, self.UpdateScienceSignal)
    self:RemoveUIListener(EventId.RefreshItems, self.UpdateItemSignal)
    self:RemoveUIListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildDataSignal)
    self:RemoveUIListener(EventId.ResourceUpdated, self.UpdateResourceSignal)
    self:RemoveUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
    self:RemoveUIListener(EventId.OnScienceQueueResearch, self.OnScienceSearchingSignal)
    self:RemoveUIListener(EventId.AllianceQueueHelpNew, self.AllianceQueueHelpNewSignal)
end

function UIScienceInfoView:ReInit()
    local scienceId, bUuid = self:GetUserData()
    self.scienceId = scienceId
    self.bUuid = bUuid
    self.isSendFinish = false
    self.queue = DataCenter.ScienceManager:GetScienceQueueByScienceId(tostring(self.scienceId))
    self:ShowPanel()
    self:RefreshGold()
end

function UIScienceInfoView:ShowPanel()
    local curLevel = DataCenter.ScienceManager:GetScienceLevel(self.scienceId)
    local maxLevel = DataCenter.ScienceManager:GetScienceMaxLevel(self.scienceId)
    if self.queue ~= nil and self.queue:GetQueueState() == NewQueueState.Work and tostring(self.scienceId) == self.queue.itemId then
        self.state = State.Researching
    else
        if curLevel >= maxLevel then
            self.state = State.Max
        else
            self:GetNeedPreList()
            if self.needPreList[1] ~= nil then
                self.state = State.Pre
            else
                self.state = State.Normal
            end
        end
    end

    local curTemplate = DataCenter.ScienceTemplateManager:GetScienceTemplate(self.scienceId, curLevel)
    if curTemplate ~= nil then
        self.title_text:SetLocalText(curTemplate.name)
        self.des_text:SetLocalText(curTemplate.description)
        self.science_icon:LoadSprite(string.format(LoadPath.ScienceIcons, curTemplate.icon))
        self.level_name_text:SetLocalText(GameDialogDefine.LEVEL)
        self.cur_level_text:SetText(curLevel)
        if maxLevel <= curLevel then
            self.level_text:SetLocalText(GameDialogDefine.MAX)
            self.level_text:SetColor(MaxColor)
        else
            self.level_text:SetLocalText(GameDialogDefine.SPLIT, curLevel, maxLevel)
            self.level_text:SetColor(NormalColor)
            self.next_level_text:SetText(curLevel + 1)
        end
    end
    self:ShowDesCells()
    self:RefreshState()
end

function UIScienceInfoView:RefreshState()
    if self.state == State.Max then
        self.level_arrow:SetActive(false)
        self.next_level_text:SetActive(false)
        self.mid_go.rectTransform:Set_sizeDelta(SizeType.Normal.x, SizeType.Normal.y)
        self.need_go:SetActive(false)
        self.max_go:SetActive(true)
        self.max_text:SetLocalText(GameDialogDefine.LEVEL_MAX)
        self.upgrading_go:SetActive(false)
        self.btn_go:SetActive(false)
        self.pre_go:SetActive(false)
        self.canShowDiamond = false
    else
        self.level_arrow:SetActive(true)
        self.next_level_text:SetActive(true)
        if self.state == State.Pre then
            self.mid_go.rectTransform:Set_sizeDelta(SizeType.Pre.x, SizeType.Pre.y)
            self.need_go:SetActive(true)
            self.need_text:SetLocalText(GameDialogDefine.NEED)
            self:ShowNeedCells()
            self.max_go:SetActive(false)
            self.upgrading_go:SetActive(false)
            self.btn_go:SetActive(false)
            self.pre_go:SetActive(true)
            self:ShowNeedPreCells()
            local curLevel = DataCenter.ScienceManager:GetScienceLevel(self.scienceId)
            local nextTemplate = DataCenter.ScienceTemplateManager:GetScienceTemplate(self.scienceId, curLevel + 1)
            if nextTemplate ~= nil then
                local nTime = nextTemplate:GetScienceTime()
                self.pre_time_text:SetLocalText(GameDialogDefine.RESEARCH_TIME_With, UITimeManager:GetInstance():SecondToFmtString(nTime))
            end
            self.canShowDiamond = false
        elseif self.state == State.Normal then
            self.mid_go.rectTransform:Set_sizeDelta(SizeType.Normal.x, SizeType.Normal.y)
            self.need_go:SetActive(true)
            self.need_text:SetLocalText(GameDialogDefine.NEED)
            self:ShowNeedCells()
            self.max_go:SetActive(false)
            self.upgrading_go:SetActive(false)
            self.btn_go:SetActive(true)
            self:ShowBtn()

            local effectId = EffectDefine.SCIENCE_SPEED_ADD
            local buildSpeedValue = LuaEntry.Effect:GetGameEffect(effectId)
            if DataCenter.BuildManager:CanShowPower() and LuaEntry.DataConfig:CheckSwitch("update_detail") and buildSpeedValue ~= nil and buildSpeedValue > 0 then
                local curLevel = DataCenter.ScienceManager:GetScienceLevel(self.scienceId)
                local nextTemplate = DataCenter.ScienceTemplateManager:GetScienceTemplate(self.scienceId, curLevel + 1)
                if nextTemplate ~= nil and nextTemplate.time > 0 then
                    self.origin_time_btn:SetActive(true)
                    self.origin_time_text:SetLocalText(GameDialogDefine.ORIGINAL_TIME, UITimeManager:GetInstance():SecondToFmtString(nextTemplate.time))
                else
                    self.origin_time_btn:SetActive(false)
                end
            else
                self.origin_time_btn:SetActive(false)
            end
            self.pre_go:SetActive(false)
        elseif self.state == State.Researching then
            self.mid_go.rectTransform:Set_sizeDelta(SizeType.Normal.x, SizeType.Normal.y)
            self.need_go:SetActive(false)
            self.max_go:SetActive(false)
            self.upgrading_go:SetActive(true)
            self.btn_go:SetActive(true)
            self:ShowBtn()
            self:UpdateLeftTime()
            self.origin_time_btn:SetActive(false)
            self.pre_go:SetActive(false)
        end
    end
end

function UIScienceInfoView:ShowBtn()
    if self.state == State.Researching then
        self.blue_upgrade_name_text:SetActive(false)
        self.blue_cost_time_text:SetActive(false)
        self.blue_cost_icon_go:SetActive(false)
        self.blue_btn:SetActive(true)
        self.blue_btn_text:SetActive(true)
        self.waitHelp = false
        if self:IsUseHeroFreeAddTime() then
            self.blue_btn_text:SetLocalText(GameDialogDefine.FREE)
        else
            if LuaEntry.Player:IsInAlliance() and self.queue ~= nil and self.queue:GetQueueState() == NewQueueState.Work and self.queue.isHelped == 0 then
                self.blue_btn_text:SetLocalText(GameDialogDefine.ALLIANCE_HELP)
            else
                self.blue_btn_text:SetLocalText(GameDialogDefine.ADD_SPEED)
            end
        end
        
        UIGray.SetGray(self.blue_btn.transform, false, true)

        self.yellow_btn:SetActive(true)
        self.yellow_btn_text:SetLocalText(GameDialogDefine.IMMEDIATELY_ADD_SPEED)
        self.canShowDiamond = true
        self:RefreshImmediatelyGold()
    elseif self.state == State.Normal then
        local curLevel = DataCenter.ScienceManager:GetScienceLevel(self.scienceId)
        local nextTemplate = DataCenter.ScienceTemplateManager:GetScienceTemplate(self.scienceId, curLevel + 1)
        if nextTemplate ~= nil then
            local needTime = nextTemplate:GetScienceTime()
            self.showBtnTime = needTime
            local freeTime = LuaEntry.Effect:GetGameEffect(EffectDefine.RESEARCH_TIME_REDUCE)
            if freeTime > 0 and freeTime >= needTime then
                if self.lackList[1] ~= nil then
                    self.isFree = false
                else
                    self.isFree = true
                end
            else
                self.isFree = false
            end

            if self.isFree then
                self.spendGold = 0
                self.yellow_btn:SetActive(false)
                self.blue_upgrade_name_text:SetActive(false)
                self.blue_cost_time_text:SetActive(false)
                self.blue_cost_icon_go:SetActive(false)
                self.blue_btn_text:SetActive(true)
                self.blue_btn_text:SetLocalText(GameDialogDefine.FREE)
                self.canShowDiamond = false
            else
                self.blue_upgrade_name_text:SetActive(true)
                self.blue_cost_time_text:SetActive(true)
                self.blue_cost_icon_go:SetActive(true)
                self.blue_btn_text:SetActive(false)
                self.blue_upgrade_name_text:SetLocalText(GameDialogDefine.RESEARCHING)
                self.blue_cost_time_text:SetText(UITimeManager:GetInstance():SecondToFmtString(needTime))
                if DataCenter.BuildManager:IsShowDiamond() then
                    self.canShowDiamond = true
                    self.yellow_btn:SetActive(true)
                    self.yellow_btn_text:SetLocalText(GameDialogDefine.IMMEDIATELY_RESEARCHING)
                    self.spendGold = CommonUtil.GetTimeDiamondCost(math.floor((needTime - freeTime)))
                    local grayBtn = false
                    for k, v in ipairs(self.lackList) do
                        if v.cellType == CommonCostNeedType.Resource then
                            self.spendGold = self.spendGold + CommonUtil.GetResGoldByType(v.resourceType, v.count - LuaEntry.Resource:GetCntByResType(v.resourceType))
                        elseif v.cellType == CommonCostNeedType.Goods then
                            local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(v.itemId)
                            if itemTemplate == nil or itemTemplate.price <= 0 then
                                grayBtn = true
                            else
                                self.spendGold = self.spendGold + CommonUtil.GetItemGoldByItemId(v.itemId,v.count - DataCenter.ItemData:GetItemCount(v.itemId))
                            end
                        end
                    end
                    self:RefreshImmediatelyGold()
                    if grayBtn then
                        UIGray.SetGray(self.yellow_btn.transform, true, false)
                    else
                        UIGray.SetGray(self.yellow_btn.transform, false, true)
                    end
                else
                    self.canShowDiamond = false
                    self.yellow_btn:SetActive(false)
                end
            end
        end

        local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.bUuid)
        if buildData ~= nil and buildData:IsUpgrading() then
            UIGray.SetGray(self.blue_btn.transform, true, true)
        else
            local queue = DataCenter.QueueDataManager:GetQueueByBuildUuidForScience(self.bUuid)
            if queue ~= nil and queue:GetQueueState() == NewQueueState.Free then
                UIGray.SetGray(self.blue_btn.transform, false, true)
            else
                UIGray.SetGray(self.blue_btn.transform, true, true)
            end
        end
    end
end

function UIScienceInfoView:RefreshGoldColor()
    local gold = LuaEntry.Player.gold
    if gold < self.spendGold then
        self:SetImmediatelyBtnSpendColor(ButtonRedTextColor)
    else
        self:SetImmediatelyBtnSpendColor(WhiteColor)
    end
end

function UIScienceInfoView:UpdateBuildDataSignal(uuid)
    if self.state == State.Pre then
        self:ShowPanel()
    end
end

function UIScienceInfoView:UpdateResourceSignal()
    self:RefreshResourceOrItem()
end

function UIScienceInfoView:UpdateGoldSignal()
    self:RefreshGoldColor()
    self:RefreshGold()
end

function UIScienceInfoView:UpdateItemSignal()
    self:RefreshResourceOrItem()
end

function UIScienceInfoView:RefreshResourceOrItem()
    if self.state == State.Pre then
        self:ShowNeedCells()
    elseif self.state == State.Normal then
        self:ShowNeedCells()
        self:ShowBtn()
    end
end

function UIScienceInfoView:UpdateScienceSignal(scienceId)
    self.isSendFinish = false
    self:ShowPanel()
end

function UIScienceInfoView:OnScienceSearchingSignal()
    self:ShowPanel()
end

function UIScienceInfoView:AllianceQueueHelpNewSignal()
    if self.state == State.Researching then
        self:ShowBtn()
    end
end

function UIScienceInfoView:ShowNeedPreCells()
    local count = #self.needPreList
    for k,v in ipairs(self.needPreList) do
        if self.needPreCells[k] == nil then
            self.needPreCells[k] = v
            v.visible = true
            v.req = self:GameObjectInstantiateAsync(UIAssets.UIScienceInfoPreCell, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject
                go:SetActive(true)
                go.transform:SetParent(self.pre_content.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                go.transform:SetAsLastSibling()
                local nameStr = tostring(NameCount)
                go.name = nameStr
                NameCount = NameCount + 1
                local model = self.pre_content:AddComponent(UIScienceInfoPreCell, nameStr)
                model:ReInit(self.needPreCells[k])
                self.needPreCells[k].model = model
            end)
        else
            v.req = self.needPreCells[k].req
            v.model = self.needPreCells[k].model
            self.needPreCells[k] = v
            v.visible = true
            if v.model ~= nil then
                v.model:ReInit(v)
            end
        end
    end
    local cellCount = #self.needPreCells
    if cellCount > count then
        for i = count + 1, cellCount, 1 do
            local cell = self.needPreCells[i]
            if cell ~= nil then
                cell.visible = false
                if cell.model ~= nil then
                    cell.model:Refresh()
                end
            end
        end
    end
end

--获取前置条件（建筑和科技）
function UIScienceInfoView:GetNeedPreList()
    self.needPreList = {}
    local curLevel = DataCenter.ScienceManager:GetScienceLevel(self.scienceId)
    local nextTemplate = DataCenter.ScienceTemplateManager:GetScienceTemplate(self.scienceId, curLevel + 1)
    if nextTemplate ~= nil then
        local count = 0
        local list = nextTemplate:GetNeedBuild()
        if list ~= nil and list[1] ~= nil then
            for _, v in ipairs(list) do
                local buildId = v.buildId
                if v.buildId == BuildingTypes.FUN_BUILD_SCIENE then
                    local buildInfo = DataCenter.BuildManager:GetBuildingDataByUuid(self.bUuid)
                    if buildInfo ~= nil then
                        buildId = buildInfo.itemId
                    end
                end
                if not DataCenter.BuildManager:IsExistBuildByTypeLv(buildId, v.level) then
                    local param = {}
                    param.cellType = CommonCostNeedType.Build
                    param.buildId = buildId
                    param.level = v.level
                    count = count + 1
                    param.showLine = count % 2 == 1
                    table.insert(self.needPreList, param)
                end
            end
        end
        
        list = nextTemplate.science_condition
        if list ~= nil and list[1] ~= nil then
            for _, v in ipairs(list) do
                local scienceId = CommonUtil.GetScienceBaseType(v)
                local level = CommonUtil.GetScienceLv(v)
                if not DataCenter.ScienceManager:HasScienceByIdAndLevel(scienceId, level) then
                    local param = {}
                    param.cellType = CommonCostNeedType.Science
                    param.scienceId = scienceId
                    param.level = level
                    count = count + 1
                    param.showLine = count % 2 == 1
                    table.insert(self.needPreList, param)
                end
            end
        end
    end
end

function UIScienceInfoView:ShowDesCells()
    self:GetDesList()
    local count = #self.desList
    if count > 0 then
        for k, v in ipairs(self.desList) do
            if self.desCells[k] == nil then
                local param = {}
                self.desCells[k] = param
                param.visible = true
                param.param = v
                param.req = self:GameObjectInstantiateAsync(UIAssets.UIScienceInfoDesCell, function(request)
                    if request.isError then
                        return
                    end
                    local go = request.gameObject
                    go:SetActive(true)
                    go.transform:SetParent(self.attr_go.transform)
                    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                    go.transform:SetAsLastSibling()
                    local nameStr = tostring(NameCount)
                    go.name = nameStr
                    NameCount = NameCount + 1
                    local model = self.attr_go:AddComponent(UIDesCell, nameStr)
                    model:ReInit(self.desCells[k])
                    param.model = model
                end)
            else
                self.desCells[k].visible = true
                self.desCells[k].param = v
                if self.desCells[k].model ~= nil then
                    self.desCells[k].model:Refresh()
                end
            end
        end
    end
    local cellCount = #self.desCells
    if cellCount > count then
        for i = count + 1, cellCount, 1 do
            local cell = self.desCells[i]
            if cell ~= nil then
                cell.visible = false
                if cell.model ~= nil then
                    cell.model:Refresh()
                end
            end
        end
    end
end

function UIScienceInfoView:GetDesList()
    self.desList = {}
    local curLevel = DataCenter.ScienceManager:GetScienceLevel(self.scienceId)
    local maxLevel = DataCenter.ScienceManager:GetScienceMaxLevel(self.scienceId)
    local curTemplate = nil
    local nextTemplate = nil
    local maxCount = 0
    if curLevel < maxLevel then
        nextTemplate = DataCenter.ScienceTemplateManager:GetScienceTemplate(self.scienceId, curLevel + 1)
        if nextTemplate ~= nil then
            maxCount = #nextTemplate.show
        end
    end
    if curLevel > 0 then
        curTemplate = DataCenter.ScienceTemplateManager:GetScienceTemplate(self.scienceId, curLevel)
        if curTemplate ~= nil then
            if curTemplate.show[maxCount] == nil then
                maxCount = #curTemplate.show
            end
        end
    end

    if maxCount > 0 then
        for i = 1, maxCount, 1 do
            if nextTemplate ~= nil then
                if nextTemplate.show[i] ~= nil then
                    local param = {}
                    param.name = Localization:GetString(nextTemplate.show[i][1])
                    local type = tonumber(nextTemplate.show[i][2])
                    if type == EffectLocalType.Dialog then
                        param.addValue = DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(nextTemplate.show[i][3], type)
                    else
                        local cur = 0
                        if curTemplate ~= nil and curTemplate.show[i] ~= nil then
                            cur = tonumber(curTemplate.show[i][3]) or 0
                            if cur ~= 0 then
                                param.curValue = DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(cur, type)
                            else
                                param.curValue = cur
                            end
                        end
                        local add = tonumber(nextTemplate.show[i][3]) - cur
                        if curTemplate == nil then
                            if add > 0 then
                                param.addValue = DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(add, type)
                            elseif add < 0 then
                                param.addValue = DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(-add, type)
                            end
                        else
                            if add > 0 then
                                param.addValue = " + " .. DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(add, type)
                            elseif add < 0 then
                                param.addValue = " - " .. DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(-add, type)
                            end
                        end
                    end
                    if param.addValue ~= nil or param.addValue ~= "" then
                        table.insert(self.desList, param)
                    end
                end
            elseif curTemplate ~= nil and curTemplate.show[i] ~= nil then
                local param = {}
                param.name = Localization:GetString(curTemplate.show[i][1])
                local type = tonumber(curTemplate.show[i][2])
                if type == EffectLocalType.Dialog then
                    param.curValue = DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(curTemplate.show[i][3], type)
                else
                    local cur = tonumber(curTemplate.show[i][3]) or 0
                    if cur ~= 0 then
                        param.curValue = DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(cur, type)
                    else
                        param.curValue = cur
                    end
                end
                table.insert(self.desList, param)
            end
        end
    else
        --show字段是空的 在判断effect显示的字段
        if nextTemplate ~= nil and nextTemplate.effect ~= nil then
            maxCount = #nextTemplate.effect
        end
        if curTemplate ~= nil and curTemplate.effect ~= nil then
            if curTemplate.effect[maxCount] == nil then
                maxCount = #curTemplate.effect
            end
        end
        if maxCount > 0 then
            for i = 1, maxCount, 1 do
                if nextTemplate ~= nil then
                    if nextTemplate.effect[i] ~= nil then
                        local param = {}
                        local effectId = nextTemplate.effect[i][1]
                        local value = nextTemplate.effect[i][2]
                        local nameStr = GetTableData(TableName.EffectNumDesc, effectId, 'des')
                        param.name = Localization:GetString(nameStr)--加成类型
                        local type = toInt(GetTableData(TableName.EffectNumDesc, effectId, 'type'))
                        local cur = 0
                        if curTemplate ~= nil and curTemplate.effect ~= nil and curTemplate.effect[i] ~= nil then
                            cur = tonumber(curTemplate.effect[i][2]) or 0
                            if cur ~= 0 then
                                param.curValue = UIUtil.GetEffectNumByType(cur, type)
                            else
                                param.curValue = cur
                            end
                        end
                        local add = value - cur
                        if curTemplate == nil then
                            if add > 0 then
                                param.addValue = UIUtil.GetEffectNumByType(add, type)
                            elseif add < 0 then
                                param.addValue = UIUtil.GetEffectNumByType(-add, type)
                            end
                        else
                            if add > 0 then
                                param.addValue = " + " .. UIUtil.GetEffectNumByType(add, type)
                            elseif add < 0 then
                                param.addValue = " - " .. UIUtil.GetEffectNumByType(-add, type)
                            end
                        end
                        if param.addValue ~= nil or param.addValue ~= "" then
                            table.insert(self.desList, param)
                        end
                    end
                elseif curTemplate ~= nil and curTemplate.effect ~= nil and curTemplate.effect[i] ~= nil then
                    local param = {}
                    local effectId = curTemplate.effect[i][1]
                    local value = curTemplate.effect[i][2]
                    local nameStr = GetTableData(TableName.EffectNumDesc, effectId, 'des')
                    param.name = Localization:GetString(nameStr)--加成类型
                    local type = toInt(GetTableData(TableName.EffectNumDesc, effectId, 'type'))
                    local cur = value or 0
                    if cur ~= 0 then
                        param.curValue = UIUtil.GetEffectNumByType(cur, type)
                    else
                        param.curValue = cur
                    end
                    table.insert(self.desList, param)
                end
            end
        end
    end
    if DataCenter.BuildManager:CanShowPower() then
        local param = {}
        param.name = Localization:GetString(GameDialogDefine.POWER)
        local cur = 0
        local add = 0
        if curTemplate ~= nil then
            cur = curTemplate.power
            param.curValue = string.GetFormattedSeperatorNum(cur) 
        end
        if nextTemplate ~= nil then
            add = nextTemplate.power - cur
            if curTemplate == nil then
                param.addValue = string.GetFormattedSeperatorNum(add)
            else
                param.addValue = " + " .. string.GetFormattedSeperatorNum(add)
            end

        end
        if add ~= 0 or (nextTemplate == nil and cur ~= 0) then
            table.insert(self.desList, param)
        end
    end
end


function UIScienceInfoView:ShowNeedCells()
    self:GetNeedList()
    local count = #self.needList
    for k,v in ipairs(self.needList) do
        if self.needCells[k] == nil then
            self.needCells[k] = v
            v.visible = true
            v.req = self:GameObjectInstantiateAsync(UIAssets.UIScienceNeedResCell, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject
                go:SetActive(true)
                go.transform:SetParent(self.need_content.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                go.transform:SetAsLastSibling()
                local nameStr = tostring(NameCount)
                go.name = nameStr
                NameCount = NameCount + 1
                local model = self.need_content:AddComponent(UITrainNeedResCell, nameStr)
                model:ReInit(self.needCells[k])
                self.needCells[k].model = model
            end)
        else
            v.req = self.needCells[k].req
            v.model = self.needCells[k].model
            self.needCells[k] = v
            v.visible = true
            if v.model ~= nil then
                v.model:ReInit(v)
            end
        end
    end
    local cellCount = #self.needCells
    if cellCount > count then
        for i = count + 1, cellCount, 1 do
            local cell = self.needCells[i]
            if cell ~= nil then
                cell.visible = false
                if cell.model ~= nil then
                    cell.model:Refresh()
                end
            end
        end
    end
end

function UIScienceInfoView:GetNeedList()
    self.needList = {}
    self.lackList = {}
    local curLevel = DataCenter.ScienceManager:GetScienceLevel(self.scienceId)
    local nextTemplate = DataCenter.ScienceTemplateManager:GetScienceTemplate(self.scienceId, curLevel + 1)
    if nextTemplate ~= nil then
        local list = nextTemplate:GetNeedResource()
        if list ~= nil and list[1] ~= nil then
            for _, v in ipairs(list) do
                local param = {}
                param.cellType = CommonCostNeedType.Resource
                param.resourceType = v.resourceType
                param.count = v.count
                param.own = LuaEntry.Resource:GetCntByResType(v.resourceType)
                if param.own < param.count then
                    param.isRed = true
                    table.insert(self.lackList, param)
                else
                    param.isRed = false
                end
                table.insert(self.needList, param)
            end
        end

        list = nextTemplate:GetNeedItem()
        if list ~= nil and list[1] ~= nil then
            for _, v in ipairs(list) do
                local param = {}
                param.cellType = CommonCostNeedType.Goods
                param.itemId = v.itemId
                param.count = v.count
                param.own = DataCenter.ItemData:GetItemCount(param.itemId)
                if param.own < param.count then
                    param.isRed = true
                    table.insert(self.lackList, param)
                else
                    param.isRed = false
                end
                table.insert(self.needList, param)
            end
        end
    end
end


function UIScienceInfoView:Update()
    if self.queue ~= nil then
        if self.state == State.Researching then
            self:UpdateLeftTime()
        end
    end
end

function UIScienceInfoView:UpdateLeftTime()
    if self.state == State.Researching then
        local state = self.queue:GetQueueState()
        if state == NewQueueState.Finish then
            --在界面里自动领取
            if not self.isSendFinish then
                if DataCenter.ScienceManager:CheckResearchFinishByBuildUuid(tonumber(self.queue.funcUuid)) then
                    self.isSendFinish = true
                end
            end
        end
        
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local changeTime = self.queue.endTime - curTime
        local maxTime = self.queue.endTime - self.queue.startTime
        if changeTime < maxTime and changeTime > 0 then
            local tempTimeSec = math.ceil(changeTime / 1000)
            if tempTimeSec ~= self.lastTime then
                self.lastTime = tempTimeSec
                local tempTimeValue = UITimeManager:GetInstance():MilliSecondToFmtString(changeTime)
                self.slider_text:SetText(tempTimeValue)
                --刷新钻石
                if self.canShowDiamond then
                    self.spendGold = CommonUtil.GetTimeDiamondCost(math.ceil(tempTimeSec))
                    self:RefreshImmediatelyGold()
                end
            end

            if maxTime > 0 then
                local tempValue = 1 - changeTime / maxTime
                if TimeBarUtil.CheckIsNeedChangeBar(changeTime, self.queue.endTime - self.lastCurTime,maxTime,SliderLength) then
                    self.lastCurTime = curTime
                    self.slider:SetValue(tempValue)
                end
            end
        else
            self.lastTime = 0
            self.slider:SetValue(1)
            self.slider_text:SetText("")
        end
    end
end


function UIScienceInfoView:RefreshImmediatelyGold()
    if self.canShowDiamond then
        self.yellow_btn_cost_text:SetText(string.GetFormattedSeperatorNum(self.spendGold))
        self:RefreshGoldColor()
    end
end

function UIScienceInfoView:RefreshGold()
    self.gold_num_text:SetText(string.GetFormattedSeperatorNum(LuaEntry.Player.gold))
end

function UIScienceInfoView:OnDetailsBtnClick()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIScienceDetail, NormalBlurPanelAnim, self.scienceId)
end

function UIScienceInfoView:OnYellowBtnClick()
    if self.immediatelyBtnSpendColor == RedColor then
        GoToUtil.GotoPayTips()
    else
        UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.UpgradeUseDiamond, Localization:GetString(GameDialogDefine.USE_GOLF_TIP_DES),
                2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL,function()
                    if self.state == State.Researching then
                        SFSNetwork.SendMessage(MsgDefines.QueueCcdMNew, { qUUID = self.queue.uuid, itemIDs = "",isGold = IsGold.UseGold })
                    else
                        SFSNetwork.SendMessage(MsgDefines.ScienceResearchNew, { itemId = self.scienceId,useGold = ScienceResearchUseGold.UseGold,bUuid = self.bUuid })
                        local heroData = DataCenter.HeroDataManager:GetFreeAddTimeHero(EffectDefine.RESEARCH_TIME_REDUCE)
                        if heroData then
                            local heroConfig = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), heroData.heroId)
                            local name = Localization:GetString(heroConfig["name"])
                            local freeTime = Mathf.Ceil(LuaEntry.Effect:GetGameEffect(EffectDefine.RESEARCH_TIME_REDUCE)/60)
                            if freeTime == 0 then
                                return
                            end
                            local time
                            if self.showBtnTime then
                                if self.showBtnTime < LuaEntry.Effect:GetGameEffect(EffectDefine.RESEARCH_TIME_REDUCE) then
                                    if self.showBtnTime > 60 then
                                        local min = Mathf.Floor(self.showBtnTime/60)
                                        time = min..Localization:GetString("100165")
                                    else
                                        time = Localization:GetString("130076",self.showBtnTime)
                                    end
                                else
                                    time = freeTime..Localization:GetString("100165")
                                end
                            else
                                time = freeTime..Localization:GetString("100165")
                            end
                            local str = Localization:GetString("110201",name,time,Localization:GetString("100025"))
                            TimerManager:GetInstance():DelayInvoke(function()
                                UIUtil.ShowTips(str,nil,nil,heroData)
                            end, 1)
                        end
                    end
                end, function()
                end)
    end
end

function UIScienceInfoView:OnBlueBtnClick()
    --建筑生在升级不能
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.bUuid)
    if buildData ~= nil and buildData:IsUpgrading() then
        UIUtil.ShowTips(Localization:GetString(GameDialogDefine.THIS_UPGRADING,
                Localization:GetString(GetTableData(DataCenter.BuildTemplateManager:GetTableName(),
                        buildData.itemId + buildData.level,"name"))))
    else
        if self.queue ~= nil and self.queue:GetQueueState() == NewQueueState.Work then
            if self.queue.itemId ~= nil then
                if self:IsUseHeroFreeAddTime() then
                    SFSNetwork.SendMessage(MsgDefines.QueueCcdMNew, { qUUID = self.queue.uuid,itemIDs = "",isGold = IsGold.NoUseGold })
                else
                    if (not self.waitHelp) and LuaEntry.Player:IsInAlliance() and self.queue ~= nil and self.queue:GetQueueState() == NewQueueState.Work and self.queue.isHelped == 0 then
                        --联盟帮助
                        self.waitHelp = true
                        SFSNetwork.SendMessage(MsgDefines.AllianceCallHelp,self.queue.uuid,AllianceHelpType.Queue,NewQueueType.Science,self.queue.itemId)
                        if self:IsUseHeroFreeAddTime() then
                            self.blue_btn_text:SetLocalText(GameDialogDefine.FREE)
                        else
                            self.blue_btn_text:SetLocalText(GameDialogDefine.ADD_SPEED)
                        end
                    else
                        --打开加速界面
                        UIManager:GetInstance():OpenWindow(UIWindowNames.UISpeed, NormalBlurPanelAnim, ItemSpdMenu.ItemSpdMenu_Science, self.queue.uuid)
                    end
                end
            else
                UIUtil.ShowTipsId(129107)
            end
        else
            local queue = DataCenter.QueueDataManager:GetQueueByBuildUuidForScience(self.bUuid)
            if queue ~= nil and queue:GetQueueState() == NewQueueState.Free then
                if self.lackList[1] ~= nil then
                    local lackTab = {}
                    for k, v in ipairs(self.lackList) do
                        if v.cellType == CommonCostNeedType.Resource then
                            local param = {}
                            param.type = ResLackType.Res
                            param.id = v.resourceType
                            param.targetNum = v.count
                            table.insert(lackTab,param)
                        elseif v.cellType == CommonCostNeedType.Goods then
                            local param = {}
                            param.type = ResLackType.Item
                            param.id = v.itemId
                            param.targetNum = v.count
                            table.insert(lackTab,param)
                        end
                    end
                    GoToResLack.GoToItemResLackList(lackTab)
                else
                    if self.isFree then
                        SFSNetwork.SendMessage(MsgDefines.ScienceResearchNew, { itemId = self.scienceId,useGold = ScienceResearchUseGold.Free,bUuid = self.bUuid })
                        local heroData = DataCenter.HeroDataManager:GetFreeAddTimeHero(EffectDefine.RESEARCH_TIME_REDUCE)
                        if heroData ~= nil then
                            local heroConfig = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), heroData.heroId)
                            local name = Localization:GetString(heroConfig["name"])
                            local freeTime = Mathf.Ceil(LuaEntry.Effect:GetGameEffect(EffectDefine.RESEARCH_TIME_REDUCE)/60)
                            local time
                            if self.showBtnTime then
                                if self.showBtnTime < LuaEntry.Effect:GetGameEffect(EffectDefine.RESEARCH_TIME_REDUCE) then
                                    if self.showBtnTime > 60 then
                                        local min = Mathf.Floor(self.showBtnTime/60)
                                        time = min..Localization:GetString("100165")
                                    else
                                        time = Localization:GetString("130076",self.showBtnTime)
                                    end
                                else
                                    time = freeTime..Localization:GetString("100165")
                                end
                            else
                                time = freeTime..Localization:GetString("100165")
                            end
                            local str = Localization:GetString("110201",name,time,Localization:GetString("310148"))
                            TimerManager:GetInstance():DelayInvoke(function()
                                UIUtil.ShowTips(str,nil,nil,heroData)
                            end, 1)
                        end
                    else
                        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Click_Science_Research)
                        SFSNetwork.SendMessage(MsgDefines.ScienceResearchNew, { itemId = self.scienceId, useGold = ScienceResearchUseGold.NoUseGold, bUuid = self.bUuid })
                        self.ctrl:CloseSelf()
                    end
                end
            else
                UIUtil.ShowTipsId(129107)
            end
        end
    end
end

function UIScienceInfoView:OnGoldBtnClick()
end

function UIScienceInfoView:OnOriginTimeBtnClick()
    local effectId = EffectDefine.SCIENCE_SPEED_ADD
    local buildSpeedValue = LuaEntry.Effect:GetGameEffect(effectId)
    local throneSpeedValue = LuaEntry.Effect:GetGameEffect(EffectDefine.THRONE_EFFECT_35311)
    local param = {}
    param.pos = self.origin_time_icon:GetPosition()
    param.totalDes =  Localization:GetString(GameDialogDefine.REASON_SCIENCE_SPEED_ADD)
    local totalValue = buildSpeedValue-throneSpeedValue
    param.totalValue = string.GetReasonPercent(totalValue)
    param.cellParams = {}
    local effectValue = nil
    effectValue = LuaEntry.Effect:GetReasonEffectValue(effectId,EffectReasonType.Science)
    if effectValue ~= nil and effectValue > 0 then
        local paramDes = {}
        paramDes.leftDes = Localization:GetString(GameDialogDefine.SCIENCE)
        paramDes.rightDes = string.GetReasonPercent(effectValue)
        table.insert(param.cellParams,paramDes)
    end

    effectValue = DataCenter.AllianceScienceDataManager:GetAllianceScienceEffectById(effectId)
    if effectValue ~= nil and effectValue > 0 then
        local paramDes = {}
        paramDes.leftDes = Localization:GetString(GameDialogDefine.ALLIANCE_SCIENCE)
        paramDes.rightDes = string.GetReasonPercent(effectValue)
        table.insert(param.cellParams,paramDes)
    end

    effectValue = LuaEntry.Effect:GetReasonEffectValue(effectId,EffectReasonType.Building)
    if effectValue ~= nil and effectValue > 0 then
        local paramDes = {}
        paramDes.leftDes = Localization:GetString(GameDialogDefine.REASON_SCIENCE_CENTER)
        paramDes.rightDes = string.GetReasonPercent(effectValue)
        table.insert(param.cellParams,paramDes)
    end

    effectValue = LuaEntry.Effect:GetReasonEffectValue(effectId,EffectReasonType.Hero)
    if effectValue ~= nil and effectValue > 0 then
        local paramDes = {}
        paramDes.leftDes = Localization:GetString(GameDialogDefine.REASON_HERO)
        paramDes.rightDes = string.GetReasonPercent(effectValue)
        table.insert(param.cellParams,paramDes)
    end

    effectValue = LuaEntry.Effect:GetReasonEffectValue(effectId,EffectReasonType.VIP)
    if effectValue ~= nil and effectValue > 0 then
        local paramDes = {}
        paramDes.leftDes = Localization:GetString(GameDialogDefine.REASON_VIP)
        paramDes.rightDes = string.GetReasonPercent(effectValue)
        table.insert(param.cellParams,paramDes)
    end

    effectValue = DataCenter.WorldAllianceCityDataManager:GetAllianceCityEffectById(effectId)
    if effectValue ~= nil and effectValue > 0 then
        local paramDes = {}
        paramDes.leftDes = Localization:GetString(GameDialogDefine.REASON_ALLIANCE)
        paramDes.rightDes = string.GetReasonPercent(effectValue)
        table.insert(param.cellParams,paramDes)
    end

    effectValue = LuaEntry.Effect:GetReasonEffectValue(effectId,EffectReasonType.Career)
    if effectValue ~= nil and effectValue > 0 then
        local paramDes = {}
        paramDes.leftDes = Localization:GetString(GameDialogDefine.PLAYER_CAREER)
        paramDes.rightDes = string.GetReasonPercent(effectValue)
        table.insert(param.cellParams,paramDes)
    end

    effectValue = LuaEntry.Effect:GetReasonEffectValue(effectId,EffectReasonType.Alliance_Career)
    if effectValue ~= nil and effectValue > 0 then
        local paramDes = {}
        paramDes.leftDes = Localization:GetString(GameDialogDefine.ALLIANCE_CAREER)
        paramDes.rightDes = string.GetReasonPercent(effectValue)
        table.insert(param.cellParams,paramDes)
    end
    if throneSpeedValue~=nil and throneSpeedValue>0 then
        local paramDes = {}
        paramDes.leftDes = Localization:GetString("250005")
        paramDes.rightDes = string.GetReasonPercent(effectValue)
        table.insert(param.cellParams,paramDes)
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIShowReason, {anim = true}, param)
end

function UIScienceInfoView:SetImmediatelyBtnSpendColor(value)
    if self.immediatelyBtnSpendColor ~= value then
        self.immediatelyBtnSpendColor = value
        self.yellow_btn_cost_text:SetColor(value)
    end
end

function UIScienceInfoView:GotoScience(scienceId)
    self.scienceId = scienceId
    self.queue = DataCenter.ScienceManager:GetScienceQueueByScienceId(tostring(self.scienceId))
    self:ShowPanel()
end


function UIScienceInfoView:IsUseHeroFreeAddTime()
    local isUseFreeTime = DataCenter.HeroDataManager:GetFreeAddTimeHero(ItemSpdMenu.ItemSpdMenu_Science)
    local freeTime = LuaEntry.Effect:GetGameEffect(EffectDefine.RESEARCH_TIME_REDUCE)
    if isUseFreeTime or freeTime > 0 then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        if self.queue.endTime - curTime <= freeTime*SecToMilSec then
            return true
        end
    end
    return false
end


return UIScienceInfoView
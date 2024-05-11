--- Created by shimin.
--- DateTime: 2024/1/9 22:42
--- 联盟科技详情界面

local UIAllianceScienceInfoView = BaseClass("UIAllianceScienceInfoView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UIHeroTipView = require "UI.UIHero2.UIHeroTip.View.UIHeroTipView"

local UIDesCell = require "UI.UIBuildCreate.Component.UIDesCell"
local UITrainNeedResCell = require "UI.UITrain.Component.UITrainNeedResCell"
local UIAllianceScienceInfoPreCell = require "UI.UIAlliance.UIAllianceScienceInfo.Component.UIAllianceScienceInfoPreCell"
local UIAllianceScienceInfoRewardCell = require "UI.UIAlliance.UIAllianceScienceInfo.Component.UIAllianceScienceInfoRewardCell"
local UINumHitEffect = require "UI.UIEffect.UINumHitEffect"

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
local upgrade_slider_des_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/upgrading_go/upgrade_slider_des"
local slider_text_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/upgrading_go/slider/slider_text"
local btn_go_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/btn_go"
local yellow_btn_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/btn_go/yellow_btn"
local yellow_btn_text_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/btn_go/yellow_btn/GameObject/yellow_btn_text"
local yellow_btn_cost_text_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/btn_go/yellow_btn/GameObject/ImmediatelyValue"
local yellow_btn_cost_icon_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/btn_go/yellow_btn/GameObject/icon_go/ImmediatelyIcon"
local yellow_btn_top_text_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/btn_go/yellow_btn/yellow_btn_top_text"
local blue_btn_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/btn_go/blue_btn"
local blue_upgrade_name_text_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/btn_go/blue_btn/GameObject/upgrade_name_text"
local blue_cost_time_text_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/btn_go/blue_btn/GameObject/cost_time_text"
local blue_btn_icon_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/btn_go/blue_btn/GameObject/icon_go/blue_btn_icon"
local blue_btn_top_text_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/btn_go/blue_btn/blue_btn_top_text"

local pre_go_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/pre_go"
local pre_content_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/pre_go/scroll_view/Viewport/pre_content"
local gold_num_text_path = "fullTop/gold_btn/gold_num_text"
local exp_slider_go_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/exp_slider_go"
local exp_slider_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/exp_slider_go/exp_slider"
local exp_slider_text_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/exp_slider_go/exp_slider/exp_slider_text"
local exp_icon_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/exp_slider_go/exp_slider/exp_icon"
local exp_detail_btn_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/exp_slider_go/exp_detail_btn"
local reward_go_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/reward_go"
local reward_text_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/reward_go/reward_text"
local reward_content_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/reward_go/reward_content"
local restore_time_text_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/btn_go/yellow_btn/restore_time_text"
local score_num_text_path = "fullTop/score_go/score_num_text"
local score_icon_path = "fullTop/score_go/score_icon"
local consume_num_text_path = "fullTop/consume/consume_num_text"
local consume_icon_path = "fullTop/consume/consume_icon"

local recommend_on_bg_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/Icon_go/neirong/guide_rect_dont_destroy"
local recommend_on_btn_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/Icon_go/neirong/OnBtn"
local recommend_off_btn_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/Icon_go/neirong/OffBtn"
local recommend_go_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/Icon_go/neirong"
local science_icon_recommend_path = "UICommonMidPopUpTitle/bg_mid/BuildInfo/Icon_go/icon_bg/recommend_icon"

local SliderLength = 510
local SizeType =
{
    Big = Vector2.New(716, 956),
    Small = Vector2.New(716, 956),
}

local State =
{
    Pre = 1,--缺少前置，
    Researching = 2,--正在研究
    Normal = 3,--正常可捐献状态
    Max = 4,--最大等级状态
    CanUpgrade = 5,--正常可点击升级状态
}

local NormalColor = Color.New(1, 1, 1, 1)
local MaxColor = Color.New(0.9686275,0.882353,0.3843138,1)
local Exp_Icon = "Assets/Main/Sprites/UI/UIAlliance/alliance_icon_distilling.png"
local SHOP_Icon = "Assets/Main/Sprites/UI/UIAlliance/UIAlliance_icon_acc.png"

--创建
function UIAllianceScienceInfoView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
function UIAllianceScienceInfoView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIAllianceScienceInfoView:ComponentDefine()
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
    self.upgrade_slider_des = self:AddComponent(UITextMeshProUGUIEx, upgrade_slider_des_path)
    self.upgrade_slider_des:SetLocalText(100238)
    self.slider = self:AddComponent(UISlider, slider_path)
    self.slider_text = self:AddComponent(UITextMeshProUGUIEx, slider_text_path)
    self.btn_go = self:AddComponent(UIBaseContainer, btn_go_path)
    self.yellow_btn = self:AddComponent(UIButton, yellow_btn_path)
    self.yellow_btn:SetOnClick(function()
        self:OnYellowBtnClick()
    end)
    self.yellow_btn_text = self:AddComponent(UITextMeshProUGUIEx, yellow_btn_text_path)
    self.yellow_btn_cost_text = self:AddComponent(UITextMeshProUGUIEx, yellow_btn_cost_text_path)
    self.yellow_btn_cost_icon = self:AddComponent(UIImage, yellow_btn_cost_icon_path)
    self.blue_btn = self:AddComponent(UIButton, blue_btn_path)
    self.blue_btn:SetOnClick(function()
        self:OnBlueBtnClick()
    end)
    self.blue_upgrade_name_text = self:AddComponent(UITextMeshProUGUIEx, blue_upgrade_name_text_path)
    self.blue_cost_time_text = self:AddComponent(UITextMeshProUGUIEx, blue_cost_time_text_path)

    self.pre_go = self:AddComponent(UIBaseContainer, pre_go_path)
    self.pre_content = self:AddComponent(UIBaseContainer, pre_content_path)
    self.gold_num_text = self:AddComponent(UITextMeshProUGUIEx, gold_num_text_path)
    self.mid_go = self:AddComponent(UIBaseContainer, mid_go_path)

    self.exp_slider_go = self:AddComponent(UIBaseContainer, exp_slider_go_path)
    self.exp_slider = self:AddComponent(UISlider, exp_slider_path)
    self.exp_slider_text = self:AddComponent(UITextMeshProUGUIEx, exp_slider_text_path)
    self.exp_icon = self:AddComponent(UIImage, exp_icon_path)
    self.exp_detail_btn = self:AddComponent(UIButton, exp_detail_btn_path)
    self.exp_detail_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnExpDetailBtnClick()
    end)
    self.reward_go = self:AddComponent(UIBaseContainer, reward_go_path)
    self.reward_text = self:AddComponent(UITextMeshProUGUIEx, reward_text_path)
    self.reward_content = self:AddComponent(UIBaseContainer, reward_content_path)
    self.yellow_btn_top_text = self:AddComponent(UITextMeshProUGUIEx, yellow_btn_top_text_path)
    self.blue_btn_top_text = self:AddComponent(UITextMeshProUGUIEx, blue_btn_top_text_path)
    self.blue_btn_icon = self:AddComponent(UIImage, blue_btn_icon_path)
    self.restore_time_text = self:AddComponent(UITextMeshProUGUIEx, restore_time_text_path)
    self.score_num_text = self:AddComponent(UITextMeshProUGUIEx, score_num_text_path)
    self.score_icon = self:AddComponent(UIImage, score_icon_path)
    self.consume_num_text = self:AddComponent(UITextMeshProUGUIEx, consume_num_text_path)
    self.consume_icon = self:AddComponent(UIImage, consume_icon_path)
    self.recommend_on_bg = self:AddComponent(UIImage, recommend_on_bg_path)
    self.recommend_on_btn = self:AddComponent(UIButton, recommend_on_btn_path)
    self.recommend_on_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnRecommendOnBtnClick()
    end)
    self.recommend_off_btn = self:AddComponent(UIButton, recommend_off_btn_path)
    self.recommend_off_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnRecommendOffBtnClick()
    end)
    self.recommend_go = self:AddComponent(UIBaseContainer, recommend_go_path)
    self.science_icon_recommend = self:AddComponent(UIBaseContainer, science_icon_recommend_path)
end

function UIAllianceScienceInfoView:ComponentDestroy()
end

function UIAllianceScienceInfoView:DataDefine()
    self.scienceId = 0
    self.bUuid = 0
    self.state = State.Normal
    self.needPreList = {}
    self.needPreCells = {}
    self.desList = {}
    self.desCells = {}
    self.needList = {}
    self.lackList = {}
    self.needCells = {}
    self.lastChangeTime = 0
    self.spendGold = 0
    self.lastTime = 0
    self.immediatelyBtnSpendColor = nil
    self.scienceData = nil
    self.needWaitRefresh = false
    self.rewardList = {}
    self.rewardCells = {}
end

function UIAllianceScienceInfoView:DataDestroy()
end

function UIAllianceScienceInfoView:OnEnable()
    base.OnEnable(self)
end

function UIAllianceScienceInfoView:OnDisable()
    base.OnDisable(self)
end

function UIAllianceScienceInfoView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.AllianceTechnology, self.AllianceTechnologySignal)
    self:AddUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
    self:AddUIListener(EventId.OnAlScienceRecommendChange, self.OnAlScienceRecommendChangeSignal)
    self:AddUIListener(EventId.ResourceUpdated, self.UpdateResourceSignal)
    self:AddUIListener(EventId.ShowAlScienceCriticalHitRatio, self.ShowAlScienceCriticalHitRatioSignal)
end

function UIAllianceScienceInfoView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.AllianceTechnology, self.AllianceTechnologySignal)
    self:RemoveUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
    self:RemoveUIListener(EventId.OnAlScienceRecommendChange, self.OnAlScienceRecommendChangeSignal)
    self:RemoveUIListener(EventId.ResourceUpdated, self.UpdateResourceSignal)
    self:RemoveUIListener(EventId.ShowAlScienceCriticalHitRatio, self.ShowAlScienceCriticalHitRatioSignal)
end

function UIAllianceScienceInfoView:ReInit()
    self.scienceId = self:GetUserData()
    self:Refresh()
    self:RefreshGold()
    self:RefreshScore()
end

function UIAllianceScienceInfoView:Refresh()
    SFSNetwork.SendMessage(MsgDefines.AlScienceNumFresh, self.scienceId)
    SFSNetwork.SendMessage(MsgDefines.AlScienceFresh, self.scienceId)
    self.scienceData = DataCenter.AllianceScienceDataManager:GetOneAllianceScienceById(self.scienceId)
    self.title_text:SetLocalText(GetTableData(TableName.AlScienceTab, self.scienceId,"name"))
    self.science_icon:LoadSprite(string.format(LoadPath.ScienceIcons, GetTableData(TableName.AlScienceTab, self.scienceId,"icon")))
    self.des_text:SetLocalText(GetTableData(TableName.AlScienceTab, self.scienceId,"description"))
    self.level_name_text:SetLocalText(GameDialogDefine.LEVEL)
    self.reward_text:SetLocalText(GameDialogDefine.DONATE_REWARD)

    local curLevel = DataCenter.AllianceScienceDataManager:GetScienceLevel(self.scienceId)
    local maxLevel = GetTableData(TableName.AlScienceTab, self.scienceId,"max_lv")
    self.cur_level_text:SetText(curLevel)
    if maxLevel <= curLevel then
        self.level_text:SetLocalText(GameDialogDefine.MAX)
        self.level_text:SetColor(MaxColor)
    else
        self.level_text:SetLocalText(GameDialogDefine.SPLIT, curLevel, maxLevel)
        self.level_text:SetColor(NormalColor)
        self.next_level_text:SetText(curLevel + 1)
    end
    self:ShowDesCells()
    self:ShowPanel()
end

function UIAllianceScienceInfoView:ShowPanel()
    local curLevel = DataCenter.AllianceScienceDataManager:GetScienceLevel(self.scienceId)
    local maxLevel = GetTableData(TableName.AlScienceTab, self.scienceId,"max_lv")
    if self.scienceData ~= nil then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        if self.scienceData.finishTime > curTime then
            self.state = State.Researching
        else
            if curLevel >= maxLevel then
                self.state = State.Max
            else
                self:GetNeedPreList()
                if self.needPreList[1] ~= nil then
                    self.state = State.Pre
                else
                    if self.scienceData.currentPro >= self.scienceData.needPro then
                        self.state = State.CanUpgrade
                    else
                        self.state = State.Normal
                    end
                end
            end
        end
    end
    self:RefreshState()
    self:RefreshRecommend()
end

function UIAllianceScienceInfoView:RefreshState()
    if self.state == State.Max then
        self.level_arrow:SetActive(false)
        self.next_level_text:SetActive(false)
        self.mid_go.rectTransform:Set_sizeDelta(SizeType.Small.x, SizeType.Small.y)
        self.need_go:SetActive(false)
        self.max_go:SetActive(true)
        self.max_text:SetLocalText(GameDialogDefine.LEVEL_MAX)
        self.exp_slider_go:SetActive(false)
        self.upgrading_go:SetActive(false)
        self.btn_go:SetActive(false)
        self.pre_go:SetActive(false)
        self.reward_go:SetActive(false)
    else
        self.level_arrow:SetActive(true)
        self.next_level_text:SetActive(true)
        if self.state == State.Pre then
            self.mid_go.rectTransform:Set_sizeDelta(SizeType.Small.x, SizeType.Small.y)
            self.need_go:SetActive(false)
            self.exp_slider_go:SetActive(false)
            self.max_go:SetActive(false)
            self.upgrading_go:SetActive(false)
            self.btn_go:SetActive(false)
            self.pre_go:SetActive(true)
            self.reward_go:SetActive(false)
            self:ShowNeedPreCells()
        elseif self.state == State.Normal then
            self.mid_go.rectTransform:Set_sizeDelta(SizeType.Big.x, SizeType.Big.y)
            self.need_go:SetActive(false)
            self.max_go:SetActive(false)
            self.upgrading_go:SetActive(false)
            self.btn_go:SetActive(true)
            self:ShowBtn()
            self.exp_slider_go:SetActive(true)
            self.pre_go:SetActive(false)
            self.reward_go:SetActive(true)
            self:ShowRewardCells()
        elseif self.state == State.CanUpgrade then
            self.mid_go.rectTransform:Set_sizeDelta(SizeType.Small.x, SizeType.Small.y)
            self.need_go:SetActive(true)
            self.need_text:SetLocalText(GameDialogDefine.NEED)
            self:ShowNeedCells()
            self.max_go:SetActive(false)
            self.upgrading_go:SetActive(false)
            self.btn_go:SetActive(true)
            self:ShowBtn()
            self.exp_slider_go:SetActive(false)
            self.pre_go:SetActive(false)
            self.reward_go:SetActive(false)
        elseif self.state == State.Researching then
            self.mid_go.rectTransform:Set_sizeDelta(SizeType.Small.x, SizeType.Small.y)
            self.need_go:SetActive(false)
            self.max_go:SetActive(false)
            self.upgrading_go:SetActive(true)
            self.exp_slider_go:SetActive(false)
            self.btn_go:SetActive(false)
            self:UpdateLeftTime()
            self.pre_go:SetActive(false)
            self.reward_go:SetActive(false)
        end
    end
end

function UIAllianceScienceInfoView:ShowBtn()
    if self.state == State.Normal then
        self.blue_upgrade_name_text:SetLocalText(GameDialogDefine.DONATE)
        self:RefreshResource()
        self.blue_btn_top_text:SetActive(true)
        local restNum = DataCenter.AllianceScienceDataManager:GetResDonateRestCount()
        self.blue_btn_top_text:SetLocalText(GameDialogDefine.TIME_WITH, restNum .. "/" .. DataCenter.AllianceScienceDataManager:GetResDonateMaxCount())
        self.blue_btn_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(self.scienceData.res))
        
        self.yellow_btn:SetActive(true)
        self.yellow_btn_text:SetLocalText(GameDialogDefine.DONATE)
        self.yellow_btn_top_text:SetLocalText(GameDialogDefine.TIME_WITH, Localization:GetString(GameDialogDefine.INFINITE))
        self.yellow_btn_cost_text:SetText(string.GetFormattedSeperatorNum(self.scienceData.goldNum))
        self.spendGold = self.scienceData.goldNum
        self:RefreshImmediatelyGold()
        self.consume_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(self.scienceData.res))
        local product = LuaEntry.Resource:GetCntByResType(self.scienceData.res)
        self.consume_num_text:SetText(string.GetFormattedStr(product))
        if restNum > 0 then
            UIGray.SetGray(self.blue_btn.transform, false, true)
        else
            UIGray.SetGray(self.blue_btn.transform, true, true)
        end

        if restNum == DataCenter.AllianceScienceDataManager:GetResDonateMaxCount() then
            self.restore_time_text:SetActive(false)
        else
            self.restore_time_text:SetActive(true)
        end
        
        self:RefreshExp()
    elseif self.state == State.CanUpgrade then
        self.blue_upgrade_name_text:SetLocalText(GameDialogDefine.RESEARCHING)
        self.blue_cost_time_text:SetText(UITimeManager:GetInstance():SecondToFmtString(self.scienceData.time))
        self.blue_btn_icon:LoadSprite("Assets/Main/Sprites/UI/Common/New/Common_icon_rocketTime")
        self.blue_btn_top_text:SetActive(false)

        self.yellow_btn:SetActive(false)
        UIGray.SetGray(self.blue_btn.transform, false, true)
    end
end

function UIAllianceScienceInfoView:RefreshGoldColor()
    local gold = LuaEntry.Player.gold
    if gold < self.spendGold then
        self:SetImmediatelyBtnSpendColor(ButtonRedTextColor)
    else
        self:SetImmediatelyBtnSpendColor(WhiteColor)
    end
end

function UIAllianceScienceInfoView:UpdateGoldSignal()
    self:RefreshGoldColor()
    self:RefreshGold()
end

function UIAllianceScienceInfoView:ShowNeedPreCells()
    local count = #self.needPreList
    for k,v in ipairs(self.needPreList) do
        if self.needPreCells[k] == nil then
            self.needPreCells[k] = v
            v.visible = true
            v.req = self:GameObjectInstantiateAsync(UIAssets.UIAllianceScienceInfoPreCell, function(request)
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
                local model = self.pre_content:AddComponent(UIAllianceScienceInfoPreCell, nameStr)
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

--获取前置条件（科技）
function UIAllianceScienceInfoView:GetNeedPreList()
    self.needPreList = {}
    local data = DataCenter.AllianceScienceDataManager:GetOneAllianceScienceById(self.scienceId)
    if data ~= nil then
        local count = 0
        local needScience = data.science_condition
        if needScience ~= nil and needScience[1] ~= nil then
            for k,v in ipairs(needScience) do
                if not DataCenter.AllianceScienceDataManager:HasScienceByIdAndLevel(v.scienceId, v.level) then
                    local param = {}
                    param.cellType = CommonCostNeedType.Science
                    param.scienceId = v.scienceId
                    param.level = v.level
                    count = count + 1
                    param.showLine = count % 2 == 1
                    table.insert(self.needPreList, param)
                end
            end
        end
    end
end

function UIAllianceScienceInfoView:ShowDesCells()
    self:GetDesList()
    local count = #self.desList
    if count > 0 then
        for k, v in ipairs(self.desList) do
            if self.desCells[k] == nil then
                local param = {}
                self.desCells[k] = param
                param.visible = true
                param.param = v
                param.req = self:GameObjectInstantiateAsync(UIAssets.UIAllianceScienceInfoDesCell, function(request)
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

function UIAllianceScienceInfoView:GetDesList()
    self.desList = {}
    local curLevel = DataCenter.AllianceScienceDataManager:GetScienceLevel(self.scienceId)
    local curInfo = GetTableData(TableName.AlScienceTab, self.scienceId,"info")
    if curInfo ~= nil then
        local param = {}
        param.name = Localization:GetString(GetTableData(TableName.AlScienceTab, self.scienceId,"description_tip"))
        param.curValue = nil
        param.addValue = nil
        local strCur = tostring(curLevel)
        local strNext = tostring(curLevel + 1)
        for k,v in ipairs(curInfo) do
            if v[2] ~= nil then
                if v[1] == strCur then
                    param.curValue = v[2]
                elseif v[1] == strNext then
                    param.addValue = v[2]
                end
            end
        end
        table.insert(self.desList, param)
    end
end


function UIAllianceScienceInfoView:ShowNeedCells()
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

function UIAllianceScienceInfoView:GetNeedList()
    self.needList = {}

    local consumeNum = self.scienceData.research_consume
    local effectNum = LuaEntry.Effect:GetGameEffect(EffectDefine.ALLIANCE_SCIENCE_RESEARCH_CONSUME)
    consumeNum = math.floor(consumeNum * (1 - effectNum / 100) + 0.5)
    local param = {}
    param.cellType = CommonCostNeedType.AllianceScienceConsume
    param.count = consumeNum
    param.own = DataCenter.AllianceStorageManager:GetResCountByRewardType(RewardType.SAPPHIRE)
    if param.own < param.count then
        param.isRed = true
    else
        param.isRed = false
    end
    table.insert(self.needList, param)
end


function UIAllianceScienceInfoView:Update()
    if self.state == State.Researching then
        self:UpdateLeftTime()
    elseif self.state == State.Normal then
        self:UpdateRestoreTime()
    end
end

function UIAllianceScienceInfoView:UpdateLeftTime()
    if self.state == State.Researching then
        if self.scienceData ~= nil then
            local curTime = UITimeManager:GetInstance():GetServerTime()
            local changeTime = self.scienceData.finishTime - curTime
            local maxTime = self.scienceData.finishTime - self.scienceData.startTime
            if changeTime < maxTime and changeTime > 0 then
                local tempTimeSec = math.ceil(changeTime / 1000)
                if tempTimeSec ~= self.laseTime then
                    self.laseTime = tempTimeSec
                    local tempTimeValue = UITimeManager:GetInstance():MilliSecondToFmtString(changeTime)
                    self.slider_text:SetText(tempTimeValue)
                end

                if maxTime > 0 then
                    local tempValue = 1 - changeTime / maxTime
                    if TimeBarUtil.CheckIsNeedChangeBar(changeTime,self.lastChangeTime,maxTime,SliderLength) then
                        self.lastChangeTime = changeTime
                        self.slider:SetValue(tempValue)
                    end
                end
            else
                self.laseTime = 0
                self.slider:SetValue(1)
                self.slider_text:SetText("")
                self.scienceData = nil
                self.ctrl:CloseSelf()
            end
        end
    end
end


function UIAllianceScienceInfoView:RefreshImmediatelyGold()
    self.yellow_btn_cost_text:SetText(string.GetFormattedSeperatorNum(self.spendGold))
    self:RefreshGoldColor()
end

function UIAllianceScienceInfoView:RefreshGold()
    self.gold_num_text:SetText(string.GetFormattedSeperatorNum(LuaEntry.Player.gold))
end

function UIAllianceScienceInfoView:OnDetailsBtnClick()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceScienceDetail, NormalBlurPanelAnim, self.scienceId)
end

function UIAllianceScienceInfoView:OnYellowBtnClick()
    if self.immediatelyBtnSpendColor == RedColor then
        GoToUtil.GotoPayTips()
    else
        UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.UpgradeUseDiamond, Localization:GetString(450048),
                2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL,function()
                    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Alliance_Science_Donate)
                    SFSNetwork.SendMessage(MsgDefines.AlScienceGoldDonate, self.scienceId)
                end)
    end
end

function UIAllianceScienceInfoView:OnBlueBtnClick()
    if self.state == State.Normal then
        if DataCenter.AllianceScienceDataManager:GetResDonateRestCount() > 0 then
            local cnt = LuaEntry.Resource:GetCntByResType(self.scienceData.res)
            if self.scienceData.resNum > cnt then
                UIUtil.ShowTipsId(120020)
                local lackTab = {}
                local param = {}
                param.type = ResLackType.Res
                param.id = self.scienceData.res
                param.targetNum = self.scienceData.resNum
                table.insert(lackTab,param)
                GoToResLack.GoToItemResLackList(lackTab)
            else
                SoundUtil.PlayEffect(SoundAssets.Music_Effect_Alliance_Science_Donate)
                SFSNetwork.SendMessage(MsgDefines.AlScienceDonate, self.scienceId, 1)
            end
        else
            UIUtil.ShowTipsId(GameDialogDefine.NO_DONATE_TIME_TIPS)
        end
    elseif self.state == State.CanUpgrade then
        if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
            UIUtil.ShowTipsId(143598)
        else
            local scienceName = Localization:GetString(GetTableData(TableName.AlScienceTab, self.scienceId,"name"))
            UIUtil.ShowMessage(Localization:GetString("391089", scienceName), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL,function()
                local consumeNum = self.scienceData.research_consume
                local effectNum = LuaEntry.Effect:GetGameEffect(EffectDefine.ALLIANCE_SCIENCE_RESEARCH_CONSUME)
                consumeNum = math.floor(consumeNum * (1 - effectNum / 100) + 0.5)
                local ownNum = DataCenter.AllianceStorageManager:GetResCountByRewardType(RewardType.SAPPHIRE)
                if ownNum < consumeNum then
                    UIUtil.ShowTipsId(391090)
                    --local strLack = Localization:GetString("391090")
                    --UIUtil.ShowMessage(strLack, 2, GameDialogDefine.CONFIRM, "110088",function()
                    --
                    --end, function()
                    --    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceCity, 2)
                    --end)
                else
                    local Researching = DataCenter.AllianceScienceDataManager:GetCurrentSearchScience()
                    if Researching ~= nil then
                        UIUtil.ShowTipsId(390462)
                    else
                        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Click_Science_Research)
                        SFSNetwork.SendMessage(MsgDefines.AlScienceResearch, self.scienceId)
                        self.ctrl:CloseSelf()
                    end
                end
            end, function()
            end)
        end
    end
end

function UIAllianceScienceInfoView:SetImmediatelyBtnSpendColor(value)
    if self.immediatelyBtnSpendColor ~= value then
        self.immediatelyBtnSpendColor = value
        self.yellow_btn_cost_text:SetColor(value)
    end
end

function UIAllianceScienceInfoView:GotoScience(scienceId)
    self.scienceId = scienceId
    self:Refresh()
end

function UIAllianceScienceInfoView:AllianceTechnologySignal()
    self.needWaitRefresh = false
    self:ShowPanel()
    self:RefreshScore()
end

function UIAllianceScienceInfoView:OnAlScienceRecommendChangeSignal()
    self:RefreshRecommend()
end

function UIAllianceScienceInfoView:OnExpDetailBtnClick()
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local position = self.exp_detail_btn.transform.position - Vector3.New(0, 40, 0) * scaleFactor
    local param = UIHeroTipView.Param.New()
    param.content = Localization:GetString(450046)
    param.dir = UIHeroTipView.Direction.BELOW
    param.defWidth = 350
    param.pivot = 0.9
    param.position = position
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, { anim = false }, param)
end

function UIAllianceScienceInfoView:UpdateRestoreTime()
    if self.scienceData ~= nil and not (self.needWaitRefresh) and 
            DataCenter.AllianceScienceDataManager:GetResDonateRestCount() ~= DataCenter.AllianceScienceDataManager:GetResDonateMaxCount() then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local deltaTime = DataCenter.AllianceScienceDataManager:GetTimePoint() + DataCenter.AllianceScienceDataManager:GetRefreshTimeBlock() - curTime
        if deltaTime < 0 then
            self.needWaitRefresh = true
            SFSNetwork.SendMessage(MsgDefines.AlScienceNumFresh, self.scienceData.scienceId)
            self.restore_time_text:SetLocalText(GameDialogDefine.RESTORE_TIME_WITH, UITimeManager:GetInstance():MilliSecondToFmtString(0))
        else
            self.restore_time_text:SetLocalText(GameDialogDefine.RESTORE_TIME_WITH, UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
        end
    end
end

function UIAllianceScienceInfoView:RefreshExp()
    self.exp_slider:SetValue(self.scienceData.currentPro / self.scienceData.needPro)
    self.exp_slider_text:SetLocalText(GameDialogDefine.SPLIT, 
            string.GetFormattedSeperatorNum(self.scienceData.currentPro), string.GetFormattedSeperatorNum(self.scienceData.needPro))
    self.exp_icon:LoadSprite(Exp_Icon)
end


function UIAllianceScienceInfoView:ShowRewardCells()
    self:GetRewardList()
    local count = #self.rewardList
    for k,v in ipairs(self.rewardList) do
        if self.rewardCells[k] == nil then
            self.rewardCells[k] = v
            v.visible = true
            v.req = self:GameObjectInstantiateAsync(UIAssets.UIAllianceScienceInfoRewardCell, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject
                go:SetActive(true)
                go.transform:SetParent(self.reward_content.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                go.transform:SetAsLastSibling()
                local nameStr = tostring(NameCount)
                go.name = nameStr
                NameCount = NameCount + 1
                local model = self.reward_content:AddComponent(UIAllianceScienceInfoRewardCell, nameStr)
                model:ReInit(self.rewardCells[k])
                self.rewardCells[k].model = model
            end)
        else
            v.req = self.rewardCells[k].req
            v.model = self.rewardCells[k].model
            self.rewardCells[k] = v
            v.visible = true
            if v.model ~= nil then
                v.model:ReInit(v)
            end
        end
    end
    local cellCount = #self.rewardCells
    if cellCount > count then
        for i = count + 1, cellCount, 1 do
            local cell = self.rewardCells[i]
            if cell ~= nil then
                cell.visible = false
                if cell.model ~= nil then
                    cell.model:Refresh()
                end
            end
        end
    end
end

--获取前置条件（科技）
function UIAllianceScienceInfoView:GetRewardList()
    self.rewardList = {}

    local param = {}
    param.icon = Exp_Icon
    param.num = self.scienceData.lowProgress
    param.des = Localization:GetString(450047)
    param.flyTargetPos = self.exp_slider:GetPosition()
    table.insert(self.rewardList, param)

    local param1 = {}
    param1.icon = SHOP_Icon
    param1.num = self.scienceData.lowContribute
    param1.des = Localization:GetString(391085)
    param1.flyTargetPos = self.score_icon:GetPosition()
    table.insert(self.rewardList, param1)
end

function UIAllianceScienceInfoView:UpdateResourceSignal()
    if self.state == State.Normal then
        self:RefreshResource()
    end
end

function UIAllianceScienceInfoView:RefreshResource()
    local cnt = LuaEntry.Resource:GetCntByResType(self.scienceData.res)
    if self.scienceData.resNum > cnt then
        self.blue_cost_time_text:SetText(string.format(TextColorStr, TextColorRed, string.GetFormattedSeperatorNum(self.scienceData.resNum)))
    else
        self.blue_cost_time_text:SetText(string.GetFormattedSeperatorNum(self.scienceData.resNum))
    end
end

function UIAllianceScienceInfoView:ShowAlScienceCriticalHitRatioSignal(data)
    self:GameObjectInstantiateAsync(UIAssets.UINumHitEffect, function(request)
        if request.isError then
            return
        end
        local go = request.gameObject
        go:SetActive(true)
        go.transform:SetParent(self.exp_slider_go.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.transform:SetAsLastSibling()
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local model = self.exp_slider_go:AddComponent(UINumHitEffect, nameStr)
        local param = {}
        param.num = data.ratio
        param.pos = self.exp_slider_go:GetPosition() + Vector3.New(0, -20, 0)
        model:ReInit(param)
    end)
    local flyNum = 3
    if data.ratio == 2 then
        flyNum = 3
    elseif data.ratio == 5 then
        flyNum = 4
    elseif data.ratio == 10 then
        flyNum = 5
    end

    for k, v in ipairs(self.rewardCells) do
        if v.model ~= nil then
            UIUtil.DoFly(7, flyNum, v.icon, v.model:GetFlyPos(), v.flyTargetPos, 45, 45)
        end
    end
end

function UIAllianceScienceInfoView:RefreshScore()
    local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if data ~= nil then
        self.score_num_text:SetText(string.GetFormattedSeperatorNum(data.accPoint))
    end
end

function UIAllianceScienceInfoView:OnRecommendOnBtnClick()
    self:SetRecommend(AllianceScienceRecommendState.No)
    SFSNetwork.SendMessage(MsgDefines.AlScienceRecommend, self.scienceId, AllianceScienceRecommendState.No)
end

function UIAllianceScienceInfoView:OnRecommendOffBtnClick()
    self:SetRecommend(AllianceScienceRecommendState.Yes)
    SFSNetwork.SendMessage(MsgDefines.AlScienceRecommend, self.scienceId, AllianceScienceRecommendState.Yes)
end

function UIAllianceScienceInfoView:SetRecommend(stateType)
    if stateType == AllianceScienceRecommendState.Yes then
        self.recommend_on_btn:SetActive(true)
        self.recommend_off_btn:SetActive(false)
        self.recommend_on_bg:LoadSprite(string.format(LoadPath.CommonPath, "bonfire_img_on"))
    else
        self.recommend_on_btn:SetActive(false)
        self.recommend_off_btn:SetActive(true)
        self.recommend_on_bg:LoadSprite(string.format(LoadPath.CommonPath, "bonfire_img_off"))
    end
end

function UIAllianceScienceInfoView:RefreshRecommend()
    local isR4orR5 = DataCenter.AllianceBaseDataManager:IsR4orR5()
    if isR4orR5 and self.state ~= State.Pre and self.state ~= State.Max then
        self.recommend_go:SetActive(true)
        self:SetRecommend(self.scienceData.state)
    else
        self.recommend_go:SetActive(false)
    end

    if self.scienceData.state == AllianceScienceRecommendState.Yes then
        self.science_icon_recommend:SetActive(true)
    else
        self.science_icon_recommend:SetActive(false)
    end
end


return UIAllianceScienceInfoView
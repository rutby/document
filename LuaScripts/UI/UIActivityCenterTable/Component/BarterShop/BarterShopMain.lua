---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/1/13 11:44
---

local BarterShopMain = BaseClass("BarterShopMain", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local BarterShopItem = require "UI.UIActivityCenterTable.Component.BarterShop.BarterShopItem"
local BarterShopMoreBtn = require "UI.UIActivityCenterTable.Component.BarterShop.BarterShopMoreBtn"
local UIHeroTipView = require "UI.UIHero2.UIHeroTip.View.UIHeroTipView"
local EffectDesc = require "UI.UIDecoration.UIDecorationMain.Component.EffectDesc1"

local title_path = "RightView/Top/title"
local subTitle_path = "RightView/Top/subTitle"
local activtyTime_path = "RightView/Top/actTime"
local remainTime_path = "RightView/Top/remainTime"
local time_icon_path = "RightView/Top/TimeIcon"

local rightView_path = "RightView"

local svBarter_path = "RightView/Rect_Bottom/ScrollView"
local content_path = "RightView/Rect_Bottom/ScrollView/Content"
local template_path = "templates(inactive)/BarterShopItem"
local costRes_path = "topRes/Res%s"
local redSwitchTog_path = "RightView/Top/redSwitch"
local redSwitchTxt_path = "RightView/Top/redSwitch/redSwitchTxt"
local infoBtn_path = "RightView/Top/infoBtn"
local decoration_btn_path = "Effect/Decoration_Btn"
local decoration_btn_text_path = "Effect/Decoration_Btn/Decoration_Icon/Decoration_Text"

local decoration_effect_path = "Effect"
local effect2_rect = "RightView/Rect_Bottom/Effect2"
local effect21_txt = "RightView/Rect_Bottom/Effect2/Txt_TipsEffect21"
local effect22_txt = "RightView/Rect_Bottom/Effect2/Txt_TipsEffect22"

local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:ClearItemCell()
    self:DelCountDownTimer()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.titleN = self:AddComponent(UIText, title_path)
    self.subTitleN = self:AddComponent(UIText, subTitle_path)
    self.activityTimeN = self:AddComponent(UIText, activtyTime_path)
    self.remainTimeN = self:AddComponent(UIText, remainTime_path)
    self.time_icon = self:AddComponent(UIImage, time_icon_path)
    --self.svBarterN = self:AddComponent(UIScrollView, svBarter_path)
    --self.svBarterN:SetOnItemMoveIn(function(itemObj, index)
    --    self:OnBarterItemMoveIn(itemObj, index)
    --end)
    --self.svBarterN:SetOnItemMoveOut(function(itemObj, index)
    --    self:OnBarterItemMoveOut(itemObj, index)
    --end)
    self.costResN = {}
    for i = 1, 2 do
        local tempRes = self:AddComponent(UIBaseContainer, string.format(costRes_path, i))
        local newRes = {}
        newRes.resType = nil--
        newRes.resId = nil
        newRes.resN = tempRes
        newRes.iconN = tempRes:AddComponent(UIImage, string.format("resIcon%s", i))
        newRes.numN = tempRes:AddComponent(UIText, string.format("resNum%s", i))
        table.insert(self.costResN, newRes)
    end
    self.redSwitchTogN = self:AddComponent(UIToggle, redSwitchTog_path)
    local showRed = self:GetRedSwitchSetting()
    self.redSwitchTogN:SetIsOn(showRed)
    self.redSwitchTogN:SetOnValueChanged(function(isShow)
        self:SetRedSwitchSetting(isShow)
    end)
    
    self.redSwitchTxtN = self:AddComponent(UIText, redSwitchTxt_path)
    self.redSwitchTxtN:SetLocalText(302086)
    self.infoBtnN = self:AddComponent(UIButton, infoBtn_path)
    self.infoBtnN:SetOnClick(function()
        self:OnClickInfoBtn()
    end)
    self:ShowNeedRes()
    --self.contentN = self:AddComponent(UIBaseContainer, content_path)
    --self.templateN = self:AddComponent(UIBaseContainer, template_path)
    --self.templateN.gameObject:GameObjectCreatePool()

    self.svBarterN = self:AddComponent(UIBaseContainer, svBarter_path)
    self.contentN = self:AddComponent(GridInfinityScrollView, content_path)
    local bindFunc1 = BindCallback(self, self.OnInitScroll)
    local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
    local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
    self.contentN:Init(bindFunc1,bindFunc2, bindFunc3)
    
    self._rightView_rect = self:AddComponent(UIBaseContainer,rightView_path)
    self.more_btn_Model = self:GameObjectInstantiateAsync(UIAssets.UIMoreBtn, function(request)
        if request.isError then
            return
        end
        local go = request.gameObject;
        go.transform:SetParent(self._rightView_rect.transform)
        go.transform:Set_localScale(1, 1, 1)
        go.name = "MoreBtn"
        local tempEff = self._rightView_rect:AddComponent(BarterShopMoreBtn, go.name)
        tempEff:SetActive(false)
        tempEff:InitData()
        self.more_btn_go = tempEff
    end)
end

local function ComponentDestroy(self)
    if self.more_btn_go then
        self.more_btn_go.transform:SetParent(self.transform)
        self.more_btn_go:SetActive(false)
    end
    if self.more_btn_Model then
        self:GameObjectDestroy(self.more_btn_Model)
        self.more_btn_Model = nil
    end
    self:HideDecorationEffect()
    self.decorationEffect = nil
    self.Effect2 = nil
    self.titleN = nil
    self.subTitleN = nil
    self.activityTimeN = nil
    self.remainTimeN = nil
    self.costResN = nil
    self.costResIconN = nil
    self.costResNumN = nil
    self.redSwitchTogN = nil
    self.redSwitchTxtN = nil
    self.infoBtnN = nil
    --self.contentN = nil
    --self.templateN = nil
end

local function DataDefine(self)
    self.activityId = nil
    self.activityData = nil
    self.CountDownTimerAction = nil
    self.countDownTimer = nil
    self.BarterList = {}
    self.resList = {}
    self.listGO = {}
    self.more_btn_go = nil
end

local function DataDestroy(self)
    self.activityId = nil
    self.activityData = nil
    self.CountDownTimerAction = nil
    self.countDownTimer = nil
    self.BarterList = nil
    self.resList = nil
    self.listGO = nil
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.OnClaimRewardEffFinish, self.RefreshNeedResNum)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.OnClaimRewardEffFinish, self.RefreshNeedResNum)
    base.OnRemoveListener(self)
end

local function SetData(self, activityId)
    self.activityId = activityId
    if not self.activityId then
        return
    end
    if self.more_btn_go then
        self.more_btn_go:SetActive(false)
        self.more_btn_go:InitData()
    end
    DataCenter.ActivityListDataManager:SetActivityVisitedEndTime(tostring(self.activityId))
    
    self.activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
    self.BarterList = {}
    LocalController:instance():visitTable("activity_barter",function(id,lineData)
        if lineData.activity_id == tonumber(self.activityId) then
            local tempData = DeepCopy(lineData)
            table.insert(self.BarterList, tempData)
        end
    end)
    self:UpdateResList()
    self:RefreshAll()
    self:ShowDecorationEffect()
end

local function UpdateResList(self)
    self.resList = {}
    for i, v in ipairs(self.BarterList) do
        local tempNeeds = self.view.ctrl:GetBarterItemsList(v.item1, true)
        for m, param in ipairs(tempNeeds) do
            if param.rewardType == RewardType.GOLD or param.rewardType == RewardType.METAL or param.rewardType == RewardType.WATER
                    or param.rewardType == RewardType.MONEY or param.rewardType == RewardType.ELECTRICITY or param.rewardType == RewardType.GOODS then
                local isExist = false
                for _, oneItem in ipairs(self.resList) do
                    if oneItem.rewardType == param.rewardType and oneItem.itemId == param.itemId then
                        isExist = true
                        break
                    end
                end
                if not isExist then
                    table.insert(self.resList, param)
                end
            end
        end
    end
end

local function RefreshAll(self)
    self.titleN:SetText(Localization:GetString(self.activityData.name))
    self.subTitleN:SetText(Localization:GetString(self.activityData.desc_info))
    if self.activityData.sub_type ~= ActivityEnum.ActivitySubType.ActivitySubType_1 then
        local startT = UITimeManager:GetInstance():TimeStampToDayForLocal(self.activityData.startTime)
        local endT = UITimeManager:GetInstance():TimeStampToDayForLocal(self.activityData.endTime - 1000)
        self.activityTimeN:SetText(startT .. "-" .. endT)
        self.time_icon:SetActive(true)
        self:AddCountDownTimer()
        self:RefreshRemainTime()
        self.redSwitchTogN:SetActive(true)
    else
        self.activityTimeN:SetText("")
        self.time_icon:SetActive(false)
        self.remainTimeN:SetText("")
        self:DelCountDownTimer()
        self.redSwitchTogN:SetActive(false)
    end
    self:ShowNeedRes()
    self:ShowTasks()
end 

local function ShowNeedRes(self)
    for i, v in ipairs(self.costResN) do
        if i <= #self.resList then
            self.costResN[i].resN:SetActive(true)
            self.costResN[i].resType = self.resList[i].rewardType
            self.costResN[i].resId = self.resList[i].itemId

            local tempIcon = nil
            if self.resList[i].rewardType ~= RewardType.GOODS then
                tempIcon = DataCenter.RewardManager:GetPicByType(self.resList[i].rewardType)
            else
                tempIcon = DataCenter.ItemTemplateManager:GetIconPath(self.resList[i].itemId)
            end
            self.costResN[i].iconN:LoadSprite(tempIcon)
        else
            self.costResN[i].resN:SetActive(false)
        end
    end
    self:RefreshNeedResNum()
end

local function RefreshNeedResNum(self)
    if self.more_btn_go then
        self.more_btn_go:RefreshEnterState(false)
    end
    for i, v in ipairs(self.costResN) do
        if v.resType then
            local tempCount = 0
            if v.resType == RewardType.GOODS then
                tempCount = DataCenter.ItemData:GetItemCount(v.resId)
            else
                local resType = RewardToResType[v.resType]
                if resType == ResourceType.Gold then
                    tempCount = LuaEntry.Player.gold
                else 
                    tempCount = LuaEntry.Resource:GetCntByResType(resType)
                end
            end
            v.numN:SetText(string.GetFormattedSeperatorNum(tempCount))
        end
    end
end

local function ShowTasks(self)
    self:ResortBarterList()
    self.contentN:SetItemCount(#self.BarterList)
    --self.svBarterN:SetTotalCount(#self.BarterList)
    --self.svBarterN:RefillCells()
end

local function ResortBarterList(self)
    local recordDic = self.activityData:GetExchangeRecords()
    table.sort(self.BarterList, function(a, b)
        local remainA = a.times - (recordDic[a.id] or 0)
        local remainB = b.times - (recordDic[b.id] or 0)
        if remainA <= 0 then
            if remainB <= 0 then
                return a.id < b.id
            else
                return false
            end
        else
            if remainB <= 0 then
                return true
            else
                return a.id < b.id
            end
        end
    end)
end

local function AddCountDownTimer(self)
    self.CountDownTimerAction = function()
        self:RefreshRemainTime()
    end

    if self.countDownTimer == nil then
        self.countDownTimer = TimerManager:GetInstance():GetTimer(1, self.CountDownTimerAction , self, false,false,false)
    end
    self.countDownTimer:Start()
end

local function RefreshRemainTime(self)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.activityData.endTime - curTime
    if remainTime > 0 then
        self.remainTimeN:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
        self.remainTimeN:SetText("")
        self:DelCountDownTimer()
    end
end

local function DelCountDownTimer(self)
    if self.countDownTimer ~= nil then
        self.countDownTimer:Stop()
        self.countDownTimer = nil
    end
end

local function OnInitScroll(self,go,index)
    local item = self.svBarterN:AddComponent(BarterShopItem, go)
    self.listGO[go] = item
end

local function OnUpdateScroll(self,go,index)
    go.name = index + 1
    local cellItem = self.listGO[go]
    if not cellItem then
        return
    end
    local barterInfo = self.BarterList[index + 1]
    cellItem:SetItem(barterInfo, self.activityData, self.activityData.sub_type == ActivityEnum.ActivitySubType.ActivitySubType_1,self.activityData.activity_pic == "shangjinshangdian",
    function(pos,data,cost,key) self:CheckIsShowMore(pos,data,cost,key) end,index + 1)
    if self.more_btn_go then
        self.more_btn_go:ClearParent()
        self.more_btn_go:SetActive(false)
    end
end

local function OnDestroyScrollItem(self,go, index)

end

local function ClearItemCell(self)
    self.svBarterN:RemoveComponents(BarterShopItem)
    self.contentN:DestroyChildNode()
end

local function GetRedSwitchSetting(self)
    local key = "BarterShowRedSwitch_" .. LuaEntry.Player.uid
    return CS.GameEntry.Setting:GetBool(key, true)
end

local function SetRedSwitchSetting(self, status)
    local temp = status and true or false
    local key = "BarterShowRedSwitch_" .. LuaEntry.Player.uid
    CS.GameEntry.Setting:SetBool(key, temp)
    EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
end

local function OnClickInfoBtn(self)
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local position = self.blueScoreBtn.transform.position + Vector3.New(-50, 0, 0) * scaleFactor

    local param = UIHeroTipView.Param.New()
    param.title = Localization:GetString("361018")
    param.content = Localization:GetString("361067")
    param.dir = UIHeroTipView.Direction.LEFT
    param.defWidth = 180
    param.pivot = 0.5
    param.position = position
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, { anim = false }, param)
end

local function OnDecorationClick(self,index)
    if self.activityData == nil then
        return
    end
    local str = string.split(self.activityData.para2,";")
    local decorationId = toInt(str[index])
    local decorationTemplate = DataCenter.DecorationTemplateManager:GetTemplate(decorationId)
    if decorationTemplate then
        DecorationUtil.OpenDecorationPanel(decorationTemplate.type, decorationTemplate.id, self.activityId)
    end
end

local function ShowDecorationEffect(self)
    if self.activityData == nil then
        return 
    end
    local str = string.split(self.activityData.para2,";")
    local decorationId = toInt(str[1])
    local decorationConfig = DataCenter.DecorationTemplateManager:GetTemplate(decorationId)
    if decorationConfig ~= nil then
        if self.decorationEffect == nil then
            self.decorationEffect = self:AddComponent(EffectDesc, decoration_effect_path)
            self.decoration_btn = self:AddComponent(UIButton, decoration_btn_path)
            self.decoration_btn:SetOnClick(function()
                self:OnDecorationClick(1)
            end)
            self.decoration_btn_text = self:AddComponent(UIText, decoration_btn_text_path)
            self.decoration_btn_text:SetLocalText(110036)
        end
        self.decorationEffect:SetActive(true)
        local effectData = DecorationUtil.GetEffectDesc(decorationId)
        self.decorationEffect:ReInit(effectData)
        if str[2] then
            if self.Effect2 == nil then
                self.Effect2 = self:AddComponent(UIButton, effect2_rect)
                self.Effect2:SetOnClick(function()
                    self:OnDecorationClick(2)
                end)
                self._effect21_txt = self:AddComponent(UIText, effect21_txt)
                local effect2Data = DecorationUtil.GetEffectDesc(toInt(str[2]))
                self._effect21_txt:SetText(effect2Data.name)
                self._effect22_txt = self:AddComponent(UIText, effect22_txt)
                self._effect22_txt:SetLocalText(321267)
            end
            self.Effect2:SetActive(true)
        end
    end
end

local function HideDecorationEffect(self)
    if self.decorationEffect ~= nil then
        self.decorationEffect:SetActive(false)
    end
    if self.Effect2 ~= nil then
        self.Effect2:SetActive(false)
    end
end

--{{{兑换多个
---@param costInfo table costInfo.count 当前拥有的  costInfo.cost需要消耗的
local function CheckIsShowMore(self,pos,data,costInfo,index)
    if self.more_btn_go == nil then
        return
    end
    self.isClick = true
    local itemSuccess = false
    local item1Success = false
    local item2Success = false
    local exchangeNum = 0   --可兑换次数
    for i = 1, table.count(costInfo) do
        if i == 1 then
            local nextNum1 = costInfo[i].count - costInfo[i].cost  --兑换完下一次还拥有的总数量
            item1Success = nextNum1 > costInfo[i].cost
            local exchangeNum1 = math.floor( nextNum1 / costInfo[i].cost)   --道具1可兑换次数
            exchangeNum = exchangeNum1
            if costInfo[i + 1] then
                local nextNum2 = costInfo[i + 1].count - costInfo[i + 1].cost
                item2Success = nextNum2 > costInfo[i + 1 ].cost
                itemSuccess = item1Success and item2Success
                local exchangeNum2 = math.floor( nextNum2 / costInfo[i + 1].cost)   --道具2可兑换次数
                if exchangeNum > exchangeNum2 then
                    exchangeNum = exchangeNum2
                end
            else
                itemSuccess = item1Success
            end
            break
        end
    end
    local nextGetNum = self.activityData:GetExchangedNum(data.id) + 1   --当前已兑换次数
    if itemSuccess and nextGetNum < data.times then
        self.more_btn_go:SetActive(true)
        self.more_btn_go:SetMaxBtnState(true)
        self.more_btn_go:ShowMoreBtn(pos)
        self:ShowMoreBtnName(data.times - nextGetNum,exchangeNum,index)
    else
        self.more_btn_go:HideMoreBtn(self._rightView_rect.transform)
    end
end

local function ShowMoreBtnName(self,times,exchangeNum,index)
    local count = exchangeNum
    if count > 0 then
        --最大兑换次数是设定上限
        if count > times then
            count = times
        end
        if count > 5 then
            self.more_btn_go:SetUseBtnState(true)
            local str = "x"..5
            self.more_btn_go:SetUseBtnTxt(str)
        else
            self.more_btn_go:SetUseBtnState(false)
        end
        local str = "x"..count
        self.more_btn_go:SetMaxBtnTxt(str)
        self.more_btn_go:SetBtnParam(index,count,self.BarterList)
    else
        self.more_btn_go:SetActive(false)
    end
end
--}}}

BarterShopMain.OnCreate = OnCreate
BarterShopMain.OnDestroy = OnDestroy
BarterShopMain.ComponentDefine = ComponentDefine
BarterShopMain.ComponentDestroy = ComponentDestroy
BarterShopMain.DataDefine = DataDefine
BarterShopMain.DataDestroy = DataDestroy
BarterShopMain.OnAddListener = OnAddListener
BarterShopMain.OnRemoveListener = OnRemoveListener
BarterShopMain.ShowDecorationEffect = ShowDecorationEffect
BarterShopMain.HideDecorationEffect = HideDecorationEffect
BarterShopMain.SetData = SetData
BarterShopMain.RefreshAll = RefreshAll
BarterShopMain.ShowTasks = ShowTasks
BarterShopMain.ResortBarterList = ResortBarterList
BarterShopMain.UpdateResList = UpdateResList
BarterShopMain.ShowNeedRes = ShowNeedRes
BarterShopMain.RefreshNeedResNum = RefreshNeedResNum
BarterShopMain.AddCountDownTimer = AddCountDownTimer
BarterShopMain.RefreshRemainTime = RefreshRemainTime
BarterShopMain.DelCountDownTimer = DelCountDownTimer
BarterShopMain.OnInitScroll = OnInitScroll
BarterShopMain.OnUpdateScroll = OnUpdateScroll
BarterShopMain.ClearItemCell = ClearItemCell
BarterShopMain.OnDestroyScrollItem = OnDestroyScrollItem
BarterShopMain.GetRedSwitchSetting = GetRedSwitchSetting
BarterShopMain.SetRedSwitchSetting = SetRedSwitchSetting
BarterShopMain.OnClickInfoBtn = OnClickInfoBtn
BarterShopMain.OnDecorationClick = OnDecorationClick
BarterShopMain.ScrollValueChange = ScrollValueChange
BarterShopMain.CheckIsShowMore = CheckIsShowMore
BarterShopMain.ShowMoreBtnName = ShowMoreBtnName

return BarterShopMain
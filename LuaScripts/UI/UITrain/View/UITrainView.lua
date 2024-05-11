--- Created by shimin.
--- DateTime: 2020/8/5 17:54
--- 训练界面

local UITrainView = BaseClass("UITrainView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray

local UITrainNeedResCell = require "UI.UITrain.Component.UITrainNeedResCell"
local UISoldierCell = require "UI.UITrain.Component.UISoldierCell"
local UITrainUpgradeIconCell = require "UI.UITrain.Component.UITrainUpgradeIconCell"
local UITrainDetailCell = require "UI.UITrain.Component.UITrainDetailCell"

local close_btn_path = "UICommonFullTop/CloseBtn"
local title_text_path = "UICommonFullTop/imgTitle/Common_img_title/titleText"
local select_go_path = "UISoldier_img_choose"
local body_icon_path = "safeArea/body_icon"
local details_btn_path = "safeArea/detail_btn"
local detail_btn_icon_path = "safeArea/detail_btn/detail_btn_icon"
local upgrade_btn_path = "safeArea/upgrade_btn"
local scroll_view_path = "safeArea/IconScrollView"
local stats_go_path = "safeArea/stats_go"
local stats_text_path = "safeArea/stats_go/stats_text"
local stats_content_path = "safeArea/stats_go/stats_content"
local upgrade_go_path = "safeArea/upgrade_go"
local upgrade_left_cell_path = "safeArea/upgrade_go/left_cell"
local upgrade_right_cell_path = "safeArea/upgrade_go/right_cell"
local need_res_content_path = "safeArea/NeedResContent"
local select_count_go_path = "safeArea/CountSliderGo"
local select_slider_path = "safeArea/CountSliderGo/SelectSlider"
local select_input_field_path = "safeArea/CountSliderGo/SelectInputField"
local lock_des_go_path = "safeArea/lock_des_go"
local lock_des_text_path = "safeArea/lock_des_go/lock_des_text"
local training_go_path = "safeArea/training_go"
local training_slider_path = "safeArea/training_go/training_slider"
local train_slider_left_time_path = "safeArea/training_go/training_slider/train_slider_left_time"
local train_num_path = "safeArea/training_go/training_slider/train_num"
local train_icon_path = "safeArea/training_go/training_slider/train_icon"
local training_icon_level_path = "safeArea/training_go/training_slider/train_icon/UISoldier_img_levelbg/training_icon_level"
local training_title_path = "safeArea/training_go/training_slider/training_title"
local btn_go_path = "safeArea/btn_go"
local yellow_btn_path = "safeArea/btn_go/yellow_btn"
local yellow_btn_text_path = "safeArea/btn_go/yellow_btn/GameObject/yellow_btn_text"
local yellow_btn_cost_text_path = "safeArea/btn_go/yellow_btn/GameObject/ImmediatelyValue"
local yellow_btn_cost_icon_path = "safeArea/btn_go/yellow_btn/GameObject/icon_go/ImmediatelyIcon"
local blue_btn_path = "safeArea/btn_go/blue_btn"
local blue_btn_text_path = "safeArea/btn_go/blue_btn/blue_btn_text"
local blue_upgrade_name_text_path = "safeArea/btn_go/blue_btn/GameObject/upgrade_name_text"
local blue_cost_time_text_path = "safeArea/btn_go/blue_btn/GameObject/cost_time_text"
local blue_cost_icon_go_path = "safeArea/btn_go/blue_btn/GameObject/icon_go"

local SliderLength = 500
local ScreenCell = 5
local DetailBtnName =
{
    Detail = "Assets/Main/Sprites/UI/Common/Common_btn_info",
    Return = "Assets/Main/Sprites/UI/Common/Common_btn_back",
}

--创建
function UITrainView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
function UITrainView:OnDestroy()
    self:DataDestroy()
    self:ComponentDestroy()
    base.OnDestroy(self)
end

function UITrainView:ComponentDefine()
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnCloseBtnClick()
    end)
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
    self.select_go = self:AddComponent(UIBaseContainer, select_go_path)
    self.body_icon = self:AddComponent(UIImage, body_icon_path)
    self.details_btn = self:AddComponent(UIButton, details_btn_path)
    self.details_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnDetailsBtnClick()
    end)
    self.detail_btn_icon = self:AddComponent(UIImage, detail_btn_icon_path)
    self.upgrade_btn = self:AddComponent(UIButton, upgrade_btn_path)
    self.upgrade_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnUpgradeBtnClick()
    end)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCreateCell(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnDeleteCell(itemObj, index)
    end)
    self.stats_go = self:AddComponent(UIBaseContainer, stats_go_path)
    self.stats_text = self:AddComponent(UITextMeshProUGUIEx, stats_text_path)
    self.stats_content = self:AddComponent(UIBaseContainer, stats_content_path)
    self.upgrade_go = self:AddComponent(UIBaseContainer, upgrade_go_path)
    self.upgrade_left_cell = self:AddComponent(UITrainUpgradeIconCell, upgrade_left_cell_path)
    self.upgrade_right_cell = self:AddComponent(UITrainUpgradeIconCell, upgrade_right_cell_path)
    self.need_res_content = self:AddComponent(UIBaseContainer, need_res_content_path)
    self.select_count_go = self:AddComponent(UIBaseContainer, select_count_go_path)
    self.select_slider = self:AddComponent(UISlider, select_slider_path)
    self.select_slider:SetOnValueChanged(function (value)
        self:OnValueChange(value)
    end)
    self.select_input_field = self:AddComponent(UITMPInput, select_input_field_path)
    self.select_input_field:SetOnEndEdit(function (value)
        self:InputListener(value)
    end)
    self.lock_des_go = self:AddComponent(UIBaseContainer, lock_des_go_path)
    self.training_go = self:AddComponent(UIBaseContainer, training_go_path)
    self.training_slider = self:AddComponent(UISlider, training_slider_path)
    self.train_slider_left_time = self:AddComponent(UITextMeshProUGUIEx, train_slider_left_time_path)
    self.train_num = self:AddComponent(UITextMeshProUGUIEx, train_num_path)
    self.train_icon = self:AddComponent(UIImage, train_icon_path)
    self.training_title = self:AddComponent(UITextMeshProUGUIEx, training_title_path)
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
    self.training_icon_level = self:AddComponent(UITextMeshProUGUIEx, training_icon_level_path)
    self.btn_go = self:AddComponent(UIBaseContainer, btn_go_path)
    self.lock_des_text = self:AddComponent(UITextMeshProUGUIEx, lock_des_text_path)
end

function UITrainView:ComponentDestroy()
end

function UITrainView:DataDefine()
    self.buildId = 0
    self.showType = 0
    self.isFreeSpeed = false
    self.queue = nil
    self.list = {}
    self.cells = {}
    self.curSelectIndex = 1
    self.cell_callback = function(clickIndex) 
        self:CellsCallBack(clickIndex) 
    end
    self.curArmyTemplate = nil
    self.state = UITrainState.Select
    self.lastTime = 0
    self.spendGold = 0
    self.perTime = 0
    self.inputCount = 0
    self.immediatelyBtnSpendText = nil
    self.immediatelyBtnSpendColor = nil
    self.lastCurTime = 0
    self.canShowDiamond = true
    self.maxTrain = 1
    self.minTrain = 1
    self.selectSliderValue = nil
    self.needList = {}
    self.lackList = {}
    self.needCells = {}
    self.trainSpendTimeText = nil
    self.statsList = {}
    self.statsCells = {}
    self.noChangeSlider = false
end

function UITrainView:DataDestroy()
    self:SetSelect()
end

function UITrainView:OnEnable()
    base.OnEnable(self)
end

function UITrainView:OnDisable()
    base.OnDisable(self)
end

function UITrainView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.RefreshItems, self.UpdateItemSignal)
    self:AddUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
    self:AddUIListener(EventId.ResourceUpdated, self.UpdateResourceSignal)
    self:AddUIListener(EventId.TrainingArmy, self.TrainingArmySignal)
    self:AddUIListener(EventId.TrainingArmyFinish, self.UpdateArmySignal)
    self:AddUIListener(EventId.TrainArmyData, self.UpdateArmySignal)
    self:AddUIListener(EventId.AddSpeedSuccess, self.UpdateArmySignal)
    self:AddUIListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildSignal)
    self:AddUIListener(EventId.GuideChangeFreeSpeedBtn, self.GuideChangeFreeSpeedBtnSignal)
end

function UITrainView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.RefreshItems, self.UpdateItemSignal)
    self:RemoveUIListener(EventId.ResourceUpdated, self.UpdateResourceSignal)
    self:RemoveUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
    self:RemoveUIListener(EventId.TrainingArmy, self.TrainingArmySignal)
    self:RemoveUIListener(EventId.TrainArmyData, self.UpdateArmySignal)
    self:RemoveUIListener(EventId.TrainingArmyFinish, self.UpdateArmySignal)
    self:RemoveUIListener(EventId.AddSpeedSuccess, self.UpdateArmySignal)
    self:RemoveUIListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildSignal)
    self:RemoveUIListener(EventId.GuideChangeFreeSpeedBtn, self.GuideChangeFreeSpeedBtnSignal)
end

function UITrainView:ReInit()
    local temp, showType = self:GetUserData()
    self.buildId = tonumber(temp)
    self.showType = 0
    if showType~=nil then
        self.showType = tonumber(showType)
    end
    self.isFreeSpeed = false
    local queueType = DataCenter.ArmyManager:GetArmyQueueTypeByBuildId(self.buildId)
    self.queue = DataCenter.ArmyManager:GetArmyQueue(queueType)
    self.list = DataCenter.ArmyManager:GetArmyList(self.buildId)
    self:GetCurSelectId()
    if self.showType > 0 then
        self.curSelectIndex = self.curSelectIndex + 1
    end
    self:ShowCells()
    self:RefreshSelect()
    self:CheckShowUnlock()
    self.title_text:SetLocalText(self.curArmyTemplate.name)
end

function UITrainView:OnCloseBtnClick()
    if self.state == UITrainState.Upgrade then
        self.state = UITrainState.Select
        self:RefreshSelect()
    else
        self.ctrl:CloseSelf()
    end
end

function UITrainView:OnDetailsBtnClick()
    if self.state == UITrainState.Info then
        self.state = UITrainState.Select
        self:RefreshSelect()
    else
        self.state = UITrainState.Info
        self:RefreshState()
    end
end

function UITrainView:OnUpgradeBtnClick()
    self.state = UITrainState.Upgrade
    self:RefreshState()
end

function UITrainView:OnYellowBtnClick()
    if self.state == UITrainState.Training then
        UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.UpgradeUseDiamond,Localization:GetString(GameDialogDefine.USE_GOLF_TIP_DES), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL,function()
            DataCenter.ArmyManager:SendSpeedFinishQueue(self.queue.uuid)
        end, function()
        end)
    else
        local currentTotalNum = DataCenter.ArmyManager:GetTotalArmyNum(self.curArmyTemplate.arm)
        local max = DataCenter.ArmyManager:GetArmyNumMax(self.curArmyTemplate.arm)
        local left = max - currentTotalNum

        local reserveMax = DataCenter.ArmyManager:GetReserveArmyMax()
        local currentReserveNum = DataCenter.ArmyManager:GetReserveArmyNum()
        local reserveLeft = reserveMax - currentReserveNum
        if left <= 0 and reserveLeft <= 0 then
            self:DoWhenMoreThenLimit()
            return
        end
        if left > 0 then
            if self.inputCount > left then
                self:DoWhenMoreThenLimit()
                return
            end
        else
            if self.inputCount > reserveLeft then
                self:DoWhenMoreThenLimit()
                return
            end
        end
        if self.immediatelyBtnSpendColor == RedColor then
            GoToUtil.GotoPayTips()
        elseif self.state == UITrainState.Select then
            local doTrain = function(prepareType)
                UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.UpgradeUseDiamond,Localization:GetString(GameDialogDefine.USE_GOLF_TIP_DES), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL,function()
                    SFSNetwork.SendMessage(MsgDefines.ArmyAdd, { id = self.list[self.curSelectIndex],gold = true,num = self.inputCount,prepare = prepareType})
                end, function()
                end)
            end
            if left > 0 then
                doTrain(ArmyTrainType.ArmyTrainType_Normal)
            elseif self.inputCount <= reserveLeft and DataCenter.ArmyManager:IsReserveSystemOpen() then
                local needShow = DataCenter.SecondConfirmManager:GetCanShowSecondConfirm(NoSecondConfirmType.ProductReserve1)
                if needShow then
                    UIUtil.ShowSecondMessage("", Localization:GetString("111021"), 2, "111022", GameDialogDefine.CANCEL, function()
                        doTrain(ArmyTrainType.ArmyTrainType_Reserve)
                    end, function(needSellConfirm)
                        DataCenter.SecondConfirmManager:SetNoShowSecondConfirm(NoSecondConfirmType.ProductReserve1, not needSellConfirm)
                    end, nil,function()
                    end,nil,Localization:GetString(GameDialogDefine.NO_SHOW), nil, nil, nil)
                else
                    doTrain(ArmyTrainType.ArmyTrainType_Reserve)
                end
            end
        elseif self.state == UITrainState.Upgrade then
            SFSNetwork.SendMessage(MsgDefines.SoldierUp, { curArmyId = self.list[self.curSelectIndex], num = self.inputCount ,isGold = true})
        end
    end
end

function UITrainView:OnBlueBtnClick()
    --建筑生在升级不能训练
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(self.buildId)
    if buildData ~= nil and buildData:IsUpgrading() then
        UIUtil.ShowTips(Localization:GetString(GameDialogDefine.THIS_UPGRADING, 
                Localization:GetString(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), 
                        buildData.itemId + buildData.level,"name"))))
    else
        if self.state == UITrainState.Select then
            local currentTotalNum = DataCenter.ArmyManager:GetTotalArmyNum(self.curArmyTemplate.arm)
            local max = DataCenter.ArmyManager:GetArmyNumMax(self.curArmyTemplate.arm)
            local left = max - currentTotalNum
            local reserveMax = DataCenter.ArmyManager:GetReserveArmyMax()
            local currentReserveNum = DataCenter.ArmyManager:GetReserveArmyNum()
            local reserveLeft = reserveMax - currentReserveNum
            if left <= 0 and reserveLeft <= 0 then
                self:DoWhenMoreThenLimit()
                return
            end
            if left > 0 then
                if self.inputCount > left then
                    self:DoWhenMoreThenLimit()
                    return
                end
            else
                if self.inputCount > reserveLeft then
                    self:DoWhenMoreThenLimit()
                    return
                end
            end

            if self.queue ~= nil and self.queue:GetQueueState() == NewQueueState.Work then
                UIUtil.ShowTipsId(GameDialogDefine.QUEUE_FULL)
            elseif self.queue ~= nil and self.queue:GetQueueState() == NewQueueState.Free then
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
                    local doTrain = function(prepareType)
                        local isGuide = false
                        if DataCenter.GuideManager:IsTrainFreeSpeed() then
                            isGuide = true
                            DataCenter.GuideManager:SendRemoveSaveGuide(TrainFreeSpeed)
                        end
                        
                        if self.buildId == BuildingTypes.FUN_BUILD_CAR_BARRACK then
                            SoundUtil.PlayEffect(SoundAssets.Music_Effect_Start_Train_Tank)
                        elseif self.buildId == BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK then
                            SoundUtil.PlayEffect(SoundAssets.Music_Effect_Start_Train_Aircraft)
                        elseif self.buildId == BuildingTypes.FUN_BUILD_INFANTRY_BARRACK then
                            SoundUtil.PlayEffect(SoundAssets.Music_Effect_Start_Train_Soldiers)
                        end
                        SFSNetwork.SendMessage(MsgDefines.ArmyAdd, { id = self.list[self.curSelectIndex],gold = false,num = self.inputCount ,prepare = prepareType,
                                                                     isGuide = isGuide})
                    end
                    if left > 0 then
                        doTrain(ArmyTrainType.ArmyTrainType_Normal)
                    elseif self.inputCount <= reserveLeft and DataCenter.ArmyManager:IsReserveSystemOpen() then
                        local needShow = DataCenter.SecondConfirmManager:GetCanShowSecondConfirm(NoSecondConfirmType.ProductReserve1)
                        if needShow then
                            UIUtil.ShowSecondMessage("", Localization:GetString("111021"), 2, "111022", GameDialogDefine.CANCEL, function()
                                doTrain(ArmyTrainType.ArmyTrainType_Reserve)
                            end, function(needSellConfirm)
                                DataCenter.SecondConfirmManager:SetNoShowSecondConfirm(NoSecondConfirmType.ProductReserve1, not needSellConfirm)
                            end, nil,function()
                            end,nil,Localization:GetString(GameDialogDefine.NO_SHOW), nil, nil, nil)
                        else
                            doTrain(ArmyTrainType.ArmyTrainType_Reserve)
                        end
                    end
                    if self.ctrl:IsClosePanelWhenTrain() then
                        self.ctrl:CloseSelf()
                    end
                end
            end
        elseif self.state == UITrainState.Upgrade then
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
                SoundUtil.PlayEffect(SoundAssets.Music_Effect_Open_Common_Shop)
                SFSNetwork.SendMessage(MsgDefines.SoldierUp, { curArmyId = self.list[self.curSelectIndex],num = self.inputCount ,isGold = false})
                if self.view.ctrl:IsClosePanelWhenTrain() then
                    self.view.ctrl:CloseSelf()
                else
                    self:OnCloseBtnClick()
                end
            end
        elseif self.state == UITrainState.Training then
            if self.isFreeSpeed then
                if self.queue ~= nil and self.queue:GetQueueState() == NewQueueState.Work then
                    SFSNetwork.SendMessage(MsgDefines.FreeSpeedQueue,{queueList = {self.queue.uuid}})
                    self.isFreeSpeed = false
                end
            else
                UIManager:GetInstance():OpenWindow(UIWindowNames.UISpeed, {anim = true}, ItemSpdMenu.ItemSpdMenu_Soldier, self.queue.uuid)
            end
        elseif self.state == UITrainState.Lock then
            local id = self.list[self.curSelectIndex]
            local tempId, tempLv = DataCenter.ArmyManager:GetLockTrainBuild(id)
            if tempId ~= nil and tempLv ~= nil then
                GoToUtil.GotoCityByBuildId(tempId, WorldTileBtnType.City_Upgrade)
            else
                tempId,tempLv = DataCenter.ArmyManager:GetLockTrainScience(id)
                if tempId ~= nil and tempLv ~= nil then
                    GoToUtil.GotoScience(tempId)
                    self.ctrl:CloseSelf()
                end
            end
        end
    end
end

function UITrainView:ClearScroll()
    self:SetSelect()
    self.cells = {}
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(UISoldierCell)--清循环列表gameObject
end

function UITrainView:RefreshImmediatelyGold()
    if self.canShowDiamond then
        if self.state == UITrainState.Select then
            if self.perTime ~= nil and self.inputCount ~= nil then
                local x,y = math.modf(self.perTime * self.inputCount)
                self.spendGold = CommonUtil.GetTimeDiamondCost(x)
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
                if grayBtn then
                    UIGray.SetGray(self.yellow_btn.transform, true, false)
                else
                    UIGray.SetGray(self.yellow_btn.transform, false, true)
                end
                
                self:SetImmediatelyBtnSpendText(string.GetFormattedSeperatorNum(self.spendGold))
                self:RefreshGoldColor()
            end
        elseif self.state == UITrainState.Training then
            self:SetImmediatelyBtnSpendText(string.GetFormattedSeperatorNum(self.spendGold))
            self:RefreshGoldColor()
        end
    end
end

function UITrainView:RefreshGoldColor()
    if self.canShowDiamond then
        local gold = LuaEntry.Player.gold
        if gold < self.spendGold then
            self:SetImmediatelyBtnSpendColor(ButtonRedTextColor)
        else
            self:SetImmediatelyBtnSpendColor(WhiteColor)
        end
    end
end

function UITrainView:ShowNeedResource()
    self:GetNeedList()
    local count = #self.needList
    for k,v in ipairs(self.needList) do
        if self.needCells[k] == nil then
            self.needCells[k] = v
            v.visible = true
            v.req = self:GameObjectInstantiateAsync(UIAssets.UITrainNeedResCell, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject
                go:SetActive(true)
                go.transform:SetParent(self.need_res_content.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                go.transform:SetAsLastSibling()
                local nameStr = tostring(NameCount)
                go.name = nameStr
                NameCount = NameCount + 1
                local model = self.need_res_content:AddComponent(UITrainNeedResCell, nameStr)
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

function UITrainView:GetNeedList()
    self.needList = {}
    self.lackList = {}

    if self.state == UITrainState.Select then
        local list = self.curArmyTemplate:GetNeedResource()
        if list ~= nil and list[1] ~= nil then
            for _, v in ipairs(list) do
                local param = {}
                param.cellType = CommonCostNeedType.Resource
                param.resourceType = v.resourceType
                param.count = v.count * self.inputCount
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

        list = self.curArmyTemplate.needItem
        if list ~= nil and list[1] ~= nil then
            for _, v in ipairs(list) do
                local param = {}
                param.cellType = CommonCostNeedType.Goods
                param.itemId = v[1]
                param.count = v[2] * self.inputCount
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
    elseif self.state == UITrainState.Upgrade then
        local maxList = self.maxTemplate:GetNeedResource()
        local list = self.curArmyTemplate:GetNeedResource()
        if maxList ~= nil and maxList[1] ~= nil then
            for _, v in ipairs(maxList) do
                local alreadyCost = 0
                for k1, v1 in ipairs(list) do
                    if v1.resourceType == v.resourceType then
                        alreadyCost = v1.count
                        break
                    end
                end
                if v.count > alreadyCost then
                    local param = {}
                    param.cellType = CommonCostNeedType.Resource
                    param.resourceType = v.resourceType
                    param.count = (v.count - alreadyCost) * self.inputCount
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
        end
        
        maxList = self.maxTemplate.needItem
        list = self.curArmyTemplate.needItem
        if maxList ~= nil and maxList[1] ~= nil then
            for _, v in ipairs(maxList) do
                local alreadyCost = 0
                for k1, v1 in ipairs(list) do
                    if v1[1] == v[1] then
                        alreadyCost = v1[2]
                        break
                    end
                end
                if v[2] > alreadyCost then
                    local param = {}
                    param.cellType = CommonCostNeedType.Goods
                    param.itemId = v[1]
                    param.count = (v[2] - alreadyCost) * self.inputCount
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
end

function UITrainView:OnCreateCell(itemObj, index)
    local armyId = self.list[index]
    itemObj.name = armyId
    self.cells[index] = self.scroll_view:AddComponent(UISoldierCell, itemObj)
    local param = {}
    param.armyId = armyId
    param.callBack = self.cell_callback
    param.isUnLock = DataCenter.ArmyManager:IsUnLock(armyId)
    param.isToUnLock = DataCenter.ArmyManager:GetArmyUnlock(self.buildId) == armyId
    param.index = index
    param.isSelect = index == self.curSelectIndex
    param.buildId = self.buildId
    self.cells[index]:ReInit(param)
    if index == self.curSelectIndex then
        self:SetSelect(index)
    end
end

function UITrainView:OnDeleteCell(itemObj, index)
    self.cells[index] = nil
    if index == self.curSelectIndex then
        self:SetSelect()
    end
    self.scroll_view:RemoveComponent(itemObj.name, UISoldierCell)
end

function UITrainView:ShowCells()
    self:ClearScroll()
    local count = #self.list
    if count > 0 then
        self.scroll_view:SetTotalCount(count)
        --保证在最有
        local min = ScreenCell
        local max = count
        local showIndex = self.curSelectIndex
        if showIndex <= min then
            showIndex = 1
        elseif showIndex > max then
            showIndex = max
        else
            showIndex = showIndex - min + 1
        end

        self.scroll_view:RefillCells(showIndex)
    end
end

function UITrainView:SetSelect(index)
    if index == nil then
        self.select_go.transform:SetParent(self.transform)
        self.select_go:SetActive(false)
    else
        local cell = self.cells[index]
        if cell ~= nil then
            self.select_go:SetActive(true)
            self.select_go.transform:SetParent(cell:GetSelectGo())
            self.select_go.transform:SetAsFirstSibling()
            self.select_go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            self.select_go.transform.localPosition = ResetPosition
        end
    end
end

function UITrainView:CellsCallBack(index)
    if self.curSelectIndex ~= index then
        self:SetCellSelect(self.curSelectIndex,false)
        self.curSelectIndex = index
        self:SetCellSelect(self.curSelectIndex,true)
        self:SetSelect(self.curSelectIndex)
        self:RefreshSelect()
        self.title_text:SetLocalText(self.curArmyTemplate.name)
    end
end

function UITrainView:RefreshSelect()
    if self.state ~= UITrainState.Upgrade and self.state ~= UITrainState.Info then
        local id = self.list[self.curSelectIndex]
        if not DataCenter.ArmyManager:IsUnLock(id) then
            self.state = UITrainState.Lock
        elseif self.queue ~= nil and self.queue:GetQueueState() == NewQueueState.Work then
            self.state = UITrainState.Training
        else
            self.state = UITrainState.Select
        end
    end
    self:RefreshState()
end
function UITrainView:RefreshState()
    local id = self.list[self.curSelectIndex]
    self.curArmyTemplate = DataCenter.ArmyTemplateManager:GetArmyTemplate(id)
    local showUpgrade = DataCenter.ArmyManager:IsCanUpgrade(id, self.buildId)
    local unlock = DataCenter.ArmyManager:GetCanUnLockUpgrade(self.buildId)
    showUpgrade = showUpgrade and unlock
    if self.curArmyTemplate ~= nil then
        self.body_icon:LoadSprite(string.format("Assets/Main/TextureEx/UITrain/%s", self.curArmyTemplate.image))
        if self.state == UITrainState.Training then
            if showUpgrade then
                self.upgrade_btn:SetActive(true)
                UIGray.SetGray(self.upgrade_btn.transform, true, false)
            else
                self.upgrade_btn:SetActive(false)
            end
            self.detail_btn_icon:LoadSprite(DetailBtnName.Detail)
            self.scroll_view:SetActive(true)
            self.stats_go:SetActive(false)
            self.upgrade_go:SetActive(false)
            self.need_res_content:SetActive(false)
            self.select_count_go:SetActive(false)
            self.lock_des_go:SetActive(false)
            self.training_go:SetActive(true)
            local num  = 0
            local armyId = ""
            local tempList = string.split(self.queue.itemId,";")
            if tempList ~= nil and #tempList > 3 then
                --晋级 
                num = tempList[4]
                armyId = tempList[3]
            elseif tempList ~= nil and #tempList > 1 then
                --训练
                armyId = tempList[1]
                num = tempList[2]
            end
            self.train_num:SetLocalText(GameDialogDefine.TRAIN)
            local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(armyId)
            if template ~= nil then
                self.train_icon:LoadSprite(string.format(LoadPath.SoldierIcons, template.icon))
                self.training_icon_level:SetText(RomeNum[template.show_level])
                self.training_title:SetText(Localization:GetString(GameDialogDefine.TRAIN) .. " " .. 
                        string.GetFormattedSeperatorNum(num) .. " " .. Localization:GetString(template.name))
            end
            self:UpdateLeftTime()
            self.btn_go:SetActive(true)
            self.canShowDiamond = true
            if self.isFreeSpeed then
                self.yellow_btn:SetActive(false)
            else
                self.yellow_btn:SetActive(true)
                self.yellow_btn_text:SetLocalText(GameDialogDefine.IMMEDIATELY_ADD_SPEED)
            end
            self.blue_btn_text:SetActive(true)
            self.blue_cost_icon_go:SetActive(false)
            self.blue_cost_time_text:SetActive(false)
            self.blue_upgrade_name_text:SetActive(false)
            if self.isFreeSpeed then
                self.blue_btn_text:SetLocalText(GameDialogDefine.FREE)
            else
                self.blue_btn_text:SetLocalText(GameDialogDefine.ADD_SPEED)
            end
        elseif self.state == UITrainState.Select then
            if showUpgrade then
                self.upgrade_btn:SetActive(true)
                UIGray.SetGray(self.upgrade_btn.transform, false, true)
            else
                self.upgrade_btn:SetActive(false)
            end
            self.detail_btn_icon:LoadSprite(DetailBtnName.Detail)
            self.scroll_view:SetActive(true)
            self.stats_go:SetActive(false)
            self.upgrade_go:SetActive(false)
            self.need_res_content:SetActive(true)
            self.select_count_go:SetActive(true)
            self.lock_des_go:SetActive(false)
            self.training_go:SetActive(false)
            self.btn_go:SetActive(true)
            self.canShowDiamond = DataCenter.BuildManager:IsShowDiamond()
            if self.canShowDiamond then
                self.yellow_btn:SetActive(true)
                self.yellow_btn_text:SetLocalText(GameDialogDefine.IMMEDIATELY_TRAIN)
            else
                self.yellow_btn:SetActive(false)
            end
            self.blue_btn_text:SetActive(false)
            self.blue_cost_icon_go:SetActive(true)
            self.blue_cost_time_text:SetActive(true)
            self.blue_upgrade_name_text:SetActive(true)
            self.blue_upgrade_name_text:SetLocalText(GameDialogDefine.TRAIN)

            self.maxTrain = self.curArmyTemplate:GetMaxTrainValue()
            self.minTrain = 1
            local currentTotalNum = DataCenter.ArmyManager:GetTotalArmyNum(self.curArmyTemplate.arm)
            local max = DataCenter.ArmyManager:GetArmyNumMax(self.curArmyTemplate.arm)
            local left = max - currentTotalNum
            local useNum = self.maxTrain
            if left <= 0 then
                local reserveMax = DataCenter.ArmyManager:GetReserveArmyMax()
                local currentReserveNum = DataCenter.ArmyManager:GetReserveArmyNum()
                local reserveLeft = reserveMax - currentReserveNum
                if reserveLeft > 0 then
                    if reserveLeft < self.maxTrain then
                        useNum = reserveLeft
                    end
                end
            else
                if left < self.maxTrain then
                    useNum = left
                end
            end

            self:SetSelectSliderValue(useNum / self.maxTrain)
            self:SetInputText(useNum)
            self.perTime = self.curArmyTemplate:GetTrainTime()
            self:RefreshTrainCount()
        elseif self.state == UITrainState.Lock then
            self.upgrade_btn:SetActive(false)
            self.yellow_btn:SetActive(false)
            self.detail_btn_icon:LoadSprite(DetailBtnName.Detail)
            self.scroll_view:SetActive(true)
            self.stats_go:SetActive(false)
            self.upgrade_go:SetActive(false)
            self.need_res_content:SetActive(false)
            self.select_count_go:SetActive(false)
            self.lock_des_go:SetActive(true)
            self.training_go:SetActive(false)
            self.btn_go:SetActive(true)
            self.blue_btn_text:SetActive(true)
            self.blue_upgrade_name_text:SetActive(false)
            self.blue_cost_icon_go:SetActive(false)
            self.blue_cost_time_text:SetActive(false)
            self.blue_btn_text:SetLocalText(GameDialogDefine.GOTO)
            local tempId,tempLv = DataCenter.ArmyManager:GetLockTrainBuild(id)
            if tempId ~= nil and tempLv ~= nil then
                self.lock_des_text:SetText(Localization:GetString(GameDialogDefine.ARMY_UNLOCK_TIP_DES,Localization:GetString(
                        GetTableData(DataCenter.BuildTemplateManager:GetTableName(), tempId + tempLv,"name")),tempLv))
            else
                tempId,tempLv = DataCenter.ArmyManager:GetLockTrainScience(id)
                if tempId ~= nil and tempLv ~= nil then
                    local buildTemp = DataCenter.ScienceTemplateManager:GetScienceTemplate(tempId,tempLv)
                    if buildTemp ~= nil then
                        self.lock_des_text:SetText(Localization:GetString(GameDialogDefine.ARMY_UNLOCK_TIP_DES,Localization:GetString(buildTemp.name),tempLv))
                    end
                end
            end
        elseif self.state == UITrainState.Upgrade then
            self.upgrade_btn:SetActive(false)
            self.detail_btn_icon:LoadSprite(DetailBtnName.Detail)
            self.scroll_view:SetActive(false)
            self.stats_go:SetActive(false)
            self.upgrade_go:SetActive(true)
            self.need_res_content:SetActive(true)
            self.select_count_go:SetActive(true)
            self.lock_des_go:SetActive(false)
            self.training_go:SetActive(false)
            self.btn_go:SetActive(true)
            self.canShowDiamond = DataCenter.BuildManager:IsShowDiamond()
            if self.canShowDiamond then
                self.yellow_btn:SetActive(true)
                self.yellow_btn_text:SetLocalText(GameDialogDefine.COMPLETE_IMMEDIATELY)
            else
                self.yellow_btn:SetActive(false)
            end
            self.blue_btn_text:SetActive(false)
            self.blue_cost_icon_go:SetActive(true)
            self.blue_cost_time_text:SetActive(true)
            self.blue_upgrade_name_text:SetActive(true)
            self.blue_upgrade_name_text:SetLocalText(GameDialogDefine.ARMY_UPGRADE)

            self.upgrade_left_cell:ReInit(id)
            self.maxTrain = self.curArmyTemplate:GetMaxTrainValue()
            self.minTrain = 1
            local army = DataCenter.ArmyManager:FindArmy(id)
            if army == nil then
                self.maxTrain = 0
            elseif army.free < self.maxTrain then
                self.maxTrain = army.free
            end
            local armyMaxId = DataCenter.ArmyManager:GetMaxUpgradeId(id, self.buildId)
            if armyMaxId ~= nil then
                self.upgrade_right_cell:ReInit(armyMaxId)
                self.maxTemplate = DataCenter.ArmyTemplateManager:GetArmyTemplate(armyMaxId)
                if self.maxTemplate ~= nil then
                    self.perTime = self.maxTemplate:GetTrainTime() - self.curArmyTemplate:GetTrainTime()
                end
            end
            self:SetSelectSliderValue(1)
            self:SetInputText(self.maxTrain)
            self:RefreshTrainCount()
        elseif self.state == UITrainState.Info then
            if showUpgrade then
                self.upgrade_btn:SetActive(true)
                if self.queue ~= nil and self.queue:GetQueueState() == NewQueueState.Work then
                    UIGray.SetGray(self.upgrade_btn.transform, true, true)
                else
                    UIGray.SetGray(self.upgrade_btn.transform, false, true)
                end
            else
                self.upgrade_btn:SetActive(false)
            end
            self.detail_btn_icon:LoadSprite(DetailBtnName.Return)
            self.scroll_view:SetActive(true)
            self.stats_go:SetActive(true)
            self.upgrade_go:SetActive(false)
            self.need_res_content:SetActive(false)
            self.select_count_go:SetActive(false)
            self.lock_des_go:SetActive(false)
            self.training_go:SetActive(false)
            self.btn_go:SetActive(false)
            self.stats_text:SetLocalText(GameDialogDefine.HERO_PLUGIN_ATTRIBUTE_RANGE)
            self:ShowStatsCell()
        end
    end
end

function UITrainView:SetImmediatelyBtnSpendText(value)
    if self.immediatelyBtnSpendText ~= value then
        self.immediatelyBtnSpendText = value
        self.yellow_btn_cost_text:SetText(value)
    end
end

function UITrainView:SetImmediatelyBtnSpendColor(value)
    if self.immediatelyBtnSpendColor ~= value then
        self.immediatelyBtnSpendColor = value
        self.yellow_btn_cost_text:SetColor(value)
    end
end

function UITrainView:UpdateResourceSignal()
    if self.state == UITrainState.Select or self.state == UITrainState.Upgrade then
        self:ShowNeedResource()
        self:RefreshImmediatelyGold()
    end
end

function UITrainView:UpdateGoldSignal()
    if self.state == UITrainState.Select or self.state == UITrainState.Training or self.state == UITrainState.Upgrade then
        self:RefreshGoldColor()
    end
end

function UITrainView:UpdateItemSignal()
    if self.state == UITrainState.Select or self.state == UITrainState.Upgrade then
        self:ShowNeedResource()
        self:RefreshImmediatelyGold()
    end
end

function UITrainView:SetSelectSliderValue(value)
    if self.selectSliderValue ~= value then
        self.selectSliderValue = value
        self.select_slider:SetValue(value)
    end
end

function UITrainView:Update()
    if self.queue ~= nil then
        if self.state == UITrainState.Training then
            self:UpdateLeftTime()
        else
            local state = self.queue:GetQueueState()
            if state == NewQueueState.Finish then
                self.ctrl:CloseSelf()
            end
        end
    end
end

function UITrainView:UpdateLeftTime()
    if self.state == UITrainState.Training then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local changeTime = self.queue.endTime - curTime
        local maxTime = self.queue.endTime - self.queue.startTime
        if changeTime > 0 then
            local tempTimeSec = math.ceil(changeTime / 1000)
            if tempTimeSec ~= self.lastTime then
                self.lastTime = tempTimeSec
                local tempTimeValue = UITimeManager:GetInstance():MilliSecondToFmtString(changeTime)
                self.train_slider_left_time:SetText(tempTimeValue)
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
                    self.training_slider:SetValue(tempValue)
                end
            end
        else
            self.lastTime = 0
            self.training_slider:SetValue(0)
            self.train_slider_left_time:SetText("")
            self.ctrl:CloseSelf()
        end
    end
end

function UITrainView:UpdateArmySignal()
    self:ShowCells()
    self:RefreshSelect()
end

function UITrainView:GetCurSelectId()
    local unlockArmy = DataCenter.ArmyManager:GetArmyUnlock(self.buildId)
    if self.queue ~= nil and self.queue:GetQueueState() == NewQueueState.Work and string.IsNullOrEmpty(unlockArmy) then
        local curSelect = ""
        local tempList = string.split(self.queue.itemId,";")
        if tempList ~= nil and #tempList > 3 then
            curSelect = tempList[3]
        elseif tempList ~= nil and #tempList > 1 then
            curSelect = tempList[1]
        end

        for k,v in ipairs(self.list) do
            if v == curSelect then
                self.curSelectIndex = k
                return
            end
        end
    else
        --取已解锁最大等级的士兵
        local maxUnlockId = DataCenter.ArmyManager:GetMaxUnLockId(self.buildId)
        if maxUnlockId == nil then
            self.curSelectIndex = 1
        else
            self.curSelectIndex = maxUnlockId
        end

    end
end

function UITrainView:SetInputText(value)
    if self.inputCount ~= value then
        self.inputCount = value
        self.select_input_field:SetText(string.GetFormattedSeperatorNum(value))
    end
end

function UITrainView:SetTrainSpendTimeText(value)
    if self.trainSpendTimeText ~= value then
        self.trainSpendTimeText = value
        self.blue_cost_time_text:SetText(value)
    end
end

function UITrainView:RefreshTrainTime()
    if self.perTime ~= nil and  self.inputCount ~= nil then
        local x,y = math.modf(self.perTime * self.inputCount)
        if DataCenter.GuideManager:IsTrainFreeSpeed() then
            x = TrainFreeSpeedSecond
        end
        self:SetTrainSpendTimeText(UITimeManager:GetInstance():SecondToFmtString(x))
    end
end

function UITrainView:InputListener(value)
    local temp = value
    if temp ~= nil and temp ~= "" then
        local inputCount = tonumber(temp)
        if inputCount < self.minTrain then
            self.inputCount = nil
            self:SetInputText(self.minTrain)
        elseif inputCount > self.maxTrain then
            self.inputCount = nil
            self:SetInputText(self.maxTrain)
        else
            self:SetInputText(inputCount)
        end
        self.noChangeSlider = true
        self:SetSelectSliderValue(self.inputCount / self.maxTrain)
        self:RefreshTrainCount()
    else
        local sub = self.inputCount
        self.inputCount = nil
        self:SetInputText(sub)
    end
end

function UITrainView:RefreshTrainCount()
    self:ShowNeedResource()
    self:RefreshTrainTime()
    self:RefreshImmediatelyGold()
end

function UITrainView:OnValueChange(val)
    if self.noChangeSlider then
        self.noChangeSlider = false
    else
        self.selectSliderValue = val
        local inputCount = math.floor(val * self.maxTrain + 0.5)
        if inputCount < self.minTrain then
            self.inputCount = nil
            self:SetInputText(self.minTrain)
        else
            self:SetInputText(inputCount)
        end
        self:RefreshTrainCount()
    end
end
function UITrainView:SetCellSelect(index,isSelect)
    if index ~= nil then
        if self.cells[index] ~= nil then
            self.cells[index]:SetSelect(isSelect)
        end
    end
end

function UITrainView:UpdateBuildSignal()
    self:ShowCells()
    self:RefreshSelect()
end

function UITrainView:TrainingArmySignal()
    self:UpdateArmySignal()
end

function UITrainView:GuideChangeFreeSpeedBtnSignal()
    self.isFreeSpeed = true
    self.immediately_btn_big_text:SetActive(true)
    self.immediately_btn_mid:SetActive(false)
    self.immediately_btn_big_text:SetLocalText(GameDialogDefine.FREE)
end


function UITrainView:ShowStatsCell()
    self:GetStatsList()
    local count = #self.statsList
    for k,v in ipairs(self.statsList) do
        if self.statsCells[k] == nil then
            self.statsCells[k] = v
            v.visible = true
            v.req = self:GameObjectInstantiateAsync(UIAssets.UITrainDetailCell, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject
                go:SetActive(true)
                go.transform:SetParent(self.stats_content.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                go.transform:SetAsLastSibling()
                local nameStr = tostring(NameCount)
                go.name = nameStr
                NameCount = NameCount + 1
                local model = self.stats_content:AddComponent(UITrainDetailCell, nameStr)
                model:ReInit(self.statsCells[k])
                self.statsCells[k].model = model
            end)
        else
            v.req = self.statsCells[k].req
            v.model = self.statsCells[k].model
            self.statsCells[k] = v
            v.visible = true
            if v.model ~= nil then
                v.model:ReInit(v)
            end
        end
    end
    local cellCount = #self.statsCells
    if cellCount > count then
        for i = count + 1, cellCount, 1 do
            local cell = self.statsCells[i]
            if cell ~= nil then
                cell.visible = false
                if cell.model ~= nil then
                    cell.model:Refresh()
                end
            end
        end
    end
end

function UITrainView:GetStatsList()
    self.statsList = {}
    local id = self.list[#self.list]
    local maxTemplate = DataCenter.ArmyTemplateManager:GetArmyTemplate(id)
    for k, v in ipairs(UITrainDetailTypeList) do
        local param = {}
        param.detailType = v
        param.template = self.curArmyTemplate
        param.maxTemplate = maxTemplate
        table.insert(self.statsList, param)
    end
end

function UITrainView:DoWhenMoreThenLimit()
    UIUtil.ShowTipsId(GameDialogDefine.SOLDIER_NUM_MAX_LIMIT)
end

function UITrainView:CheckShowUnlock()
    local armyToUnlock = DataCenter.ArmyManager:GetArmyUnlock(self.buildId)
    if not string.IsNullOrEmpty(armyToUnlock) then
        local param = {}
        param.armyId = armyToUnlock
        param.buildId = self.buildId
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIArmyUnlock, {anim = true}, param)
    end
end

return UITrainView
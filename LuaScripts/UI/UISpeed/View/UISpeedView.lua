--- Created by shimin.
--- DateTime: 2024/1/19 10:26
--- 加速界面

local UISpeedView = BaseClass("UISpeedView", UIBaseView)
local base = UIBaseView

local UISpeedCell = require "UI.UISpeed.Component.UISpeedCell"
local UISpeedGiftCell = require "UI.UISpeed.Component.UISpeedGiftCell"
local UISpeedReplenishCell = require "UI.UISpeed.Component.UISpeedReplenishCell"
local UISpeedFinishCell = require "UI.UISpeed.Component.UISpeedFinishCell"
local UISpeedItem = require "UI.UISpeed.Component.UISpeedItem"

local Localization = CS.GameEntry.Localization

local panel_path = "UICommonPopUpTitle/panel"
local close_btn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local title_text_path = "UICommonPopUpTitle/bg_mid/titleText"
-- local icon_path = "UICommonPopUpTitle/bg_mid/BuildIcon"
local slider_path = "UICommonPopUpTitle/bg_mid/SliderGreen"
local pro_img_path = "UICommonPopUpTitle/bg_mid/SliderGreen/Fill Area/Fill"
local left_time_path = "UICommonPopUpTitle/bg_mid/SliderGreen/slider_text"
local more_btn_go_path = "MoreBtn"
local use_count_btn_path = "MoreBtn/UseCountBtn"
local use_count_btn_name_path = "MoreBtn/UseCountBtn/UseCountBtnName"
local use_max_btn_path = "MoreBtn/UseMaxBtn"
local use_max_btn_name_path = "MoreBtn/UseMaxBtn/UseMaxBtnName"
local scrollView_path = "UICommonPopUpTitle/bg_mid/NothingContent/scroll_view"
local content_path = "UICommonPopUpTitle/bg_mid/NothingContent/scroll_view/Viewport/Content"
local gift_cell_path = "UICommonPopUpTitle/bg_mid/NothingContent/scroll_view/Viewport/Content/gift_bg"
local replenish_cell_path = "UICommonPopUpTitle/bg_mid/NothingContent/scroll_view/Viewport/Content/UISpeedReplenishCell"
local finish_cell_path = "UICommonPopUpTitle/bg_mid/NothingContent/scroll_view/Viewport/Content/UISpeedFinishCell"
-- local name_text_path = "UICommonPopUpTitle/bg_mid/Name_Txt"

local NothingContent_path = "UICommonPopUpTitle/bg_mid/NothingContent"
local nothingText_path = "UICommonPopUpTitle/bg_mid/NothingContent/nothingText"
local obtain_btn_path = "UICommonPopUpTitle/bg_mid/NothingContent/obtain_btn"
local obtain_btn_name_path = "UICommonPopUpTitle/bg_mid/NothingContent/obtain_btn/obtain_btn_name"
local SpeedContent_path = "UICommonPopUpTitle/bg_mid/SpeedContent"
local item_input_path = "UICommonPopUpTitle/bg_mid/SpeedContent/InputGo/DesBg/InputField"
local item_add_btn_path = "UICommonPopUpTitle/bg_mid/SpeedContent/InputGo/DesBg/AddBtn"
local item_add_btn_active_img_path = "UICommonPopUpTitle/bg_mid/SpeedContent/InputGo/DesBg/AddBtn/AddActiveImage"
local item_add_btn_inactive_img_path = "UICommonPopUpTitle/bg_mid/SpeedContent/InputGo/DesBg/AddBtn/AddInActiveImage"
local item_dec_btn_path = "UICommonPopUpTitle/bg_mid/SpeedContent/InputGo/DesBg/DecBtn"
local item_dec_btn_active_img_path = "UICommonPopUpTitle/bg_mid/SpeedContent/InputGo/DesBg/DecBtn/DecActiveImage"
local item_dec_btn_inactive_img_path = "UICommonPopUpTitle/bg_mid/SpeedContent/InputGo/DesBg/DecBtn/DecInActiveImage"
local item_slider_path = "UICommonPopUpTitle/bg_mid/SpeedContent/InputGo/DesBg/InputSlider"
local item_input_go_path = "UICommonPopUpTitle/bg_mid/SpeedContent/InputGo"
local item_scrollView_path = "UICommonPopUpTitle/bg_mid/SpeedContent/ItemScrollView"
local item_content_path = "UICommonPopUpTitle/bg_mid/SpeedContent/ItemScrollView/Viewport/ItemContent"
local alliance_help_path = "UICommonPopUpTitle/bg_mid/AllianceHelp"
local alliance_help_text_path = "UICommonPopUpTitle/bg_mid/AllianceHelp/helpText"
local speedItemTitle_text_path = "UICommonPopUpTitle/bg_mid/SpeedContent/SpeedTitle"
local green_btn_path = "UICommonPopUpTitle/bg_mid/green_btn"
local green_btn_text_path = "UICommonPopUpTitle/bg_mid/green_btn/green_btn_name"
local use_btn_path = "UICommonPopUpTitle/bg_mid/layout/use_btn"
local use_btn_name_path = "UICommonPopUpTitle/bg_mid/layout/use_btn/use_btn_name"
local yellow_btn_path = "UICommonPopUpTitle/bg_mid/layout/yellow_btn"
local yellow_btn_text_path = "UICommonPopUpTitle/bg_mid/layout/yellow_btn/yellow_btn_go/yellow_btn_text"
local yellow_btn_num_path = "UICommonPopUpTitle/bg_mid/layout/yellow_btn/yellow_btn_go/yellow_btn_icon_text"
local speedTimeDes_path = "UICommonPopUpTitle/bg_mid/SpeedContent/speedTime/speedTimedes"
local speedTimeText_path = "UICommonPopUpTitle/bg_mid/SpeedContent/speedTime/speedTimeText"

local SliderLength = 523
local OutTime = 60000 --1分钟

--创建
function UISpeedView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self.itemSpdMenu, self.buildUUId = self:GetUserData()
    self:ReInit()
end

-- 销毁
function UISpeedView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UISpeedView:ComponentDefine()
    self.panel_btn = self:AddComponent(UIButton, panel_path)
    self.panel_btn:SetOnClick(function()
        self.close = true
        self.ctrl:CloseSelf()
    end)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.close = true
        self.ctrl:CloseSelf()
    end)
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
    -- self.icon = self:AddComponent(UIImage, icon_path)
    self.slider = self:AddComponent(UISlider, slider_path)
    self.pro_img = self:AddComponent(UIImage, pro_img_path)
    self.left_time = self:AddComponent(UITextMeshProUGUIEx, left_time_path)
    self.scrollView = self:AddComponent(UIBaseContainer,scrollView_path)
    self.content = self:AddComponent(UIBaseContainer, content_path)
    self.more_btn_go = self:AddComponent(UIAnimator, more_btn_go_path)
    self.use_count_btn = self:AddComponent(UIButton, use_count_btn_path)
    self.use_count_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:MoreBtnClick()
    end)
    self.use_count_btn_name = self:AddComponent(UITextMeshProUGUIEx, use_count_btn_name_path)
    self.use_max_btn = self:AddComponent(UIButton, use_max_btn_path)
    self.use_max_btn_name = self:AddComponent(UITextMeshProUGUIEx, use_max_btn_name_path)
    self.gift_cell = self:AddComponent(UISpeedGiftCell, gift_cell_path)
    self.replenish_cell = self:AddComponent(UISpeedReplenishCell, replenish_cell_path)
    self.finish_cell = self:AddComponent(UISpeedFinishCell, finish_cell_path)
    -- self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)

    self.NothingContent = self:AddComponent(UIBaseContainer,NothingContent_path)
    self.SpeedContent = self:AddComponent(UIBaseContainer, SpeedContent_path)
    self.itemInfoInput = self:AddComponent(UITMPInput, item_input_path)
    self.itemInfoAddBtn = self:AddComponent(UIButton, item_add_btn_path)
    self.itemInfoDecBtn = self:AddComponent(UIButton, item_dec_btn_path)
    self.itemInfoAddBtnActiveImg = self:AddComponent(UIImage, item_add_btn_active_img_path)
    self.itemInfoAddBtnInactiveImg = self:AddComponent(UIImage, item_add_btn_inactive_img_path)
    self.itemInfoDecBtnActiveImg = self:AddComponent(UIImage, item_dec_btn_active_img_path)
    self.itemInfoDecBtnInactiveImg = self:AddComponent(UIImage, item_dec_btn_inactive_img_path)
    self.itemInfoAddBtnInactiveImg:SetActive(false)
    self.itemInfoDecBtnInactiveImg:SetActive(false)
    self.itemInfoSlider = self:AddComponent(UISlider, item_slider_path)
    self.itemInfoSlider:SetOnValueChanged(function(value)
        self:OnSliderValueChange(value)
    end)
    self.itemInfoAddBtn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Add)
        self:OnAddBtnClick()
    end)

    self.itemInfoDecBtn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Dec)
        self:OnDecBtnClick()
    end)

    self.itemInfoInput:SetOnEndEdit(function (value)
        self:InputListener(value)
    end)
    self.itemInfoInputGo = self:AddComponent(UIBaseContainer, item_input_go_path)
    self.item_scrollView = self:AddComponent(UIScrollView,item_scrollView_path)
    self.item_scrollView:SetOnItemMoveIn(function(itemObj, index)
        self:OnCreateCell(itemObj, index)
    end)
    self.item_scrollView:SetOnItemMoveOut(function(itemObj, index)
        self:OnDeleteCell(itemObj, index)
    end)
    self.itemContent = self:AddComponent(UIBaseContainer, item_content_path)
    self.allianceHelp = self:AddComponent(UIBaseContainer, alliance_help_path)
    self.allianceHelpText = self:AddComponent(UITextMeshProUGUIEx,alliance_help_text_path)
    self.speedItemTitleText = self:AddComponent(UITextMeshProUGUIEx,speedItemTitle_text_path)
    self.greenBtn = self:AddComponent(UIButton,green_btn_path)
    self.greenBtn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickGreenBtnSpeed()
    end)
    self.greenBtnText = self:AddComponent(UITextMeshProUGUIEx,green_btn_text_path)
    self.useBtnName = self:AddComponent(UITextMeshProUGUIEx,use_btn_name_path)
    self.useBtn = self:AddComponent(UIButton,use_btn_path)
    self.useBtn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickUseBtn()
    end)
    self.yellowBtn = self:AddComponent(UIButton,yellow_btn_path)
    self.yellowBtn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickDiamondSpeed()
    end)
    self.yellowBtnText = self:AddComponent(UITextMeshProUGUIEx,yellow_btn_text_path)
    self.yellow_btn_cost_text = self:AddComponent(UITextMeshProUGUIEx,yellow_btn_num_path)
    self.speedTimeDes = self:AddComponent(UITextMeshProUGUIEx,speedTimeDes_path)
    self.speedTimeText = self:AddComponent(UITextMeshProUGUIEx,speedTimeText_path)
    self.nothingText = self:AddComponent(UITextMeshProUGUIEx, nothingText_path)
    self.obtain_btn = self:AddComponent(UIButton, obtain_btn_path)
    self.obtain_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickObtainBtn()
    end)
    self.obtain_btn_name = self:AddComponent(UITextMeshProUGUIEx, obtain_btn_name_path)
end

function UISpeedView:ComponentDestroy()
    if not IsNull(self.more_btn_go) then
        self.more_btn_go.transform:SetParent(self.transform)
        self.more_btn_go:SetActive(false)
    end
    self.itemInfoInput = nil
    self.itemInfoAddBtn = nil
    self.itemInfoDecBtn = nil
end

function UISpeedView:DataDefine()
    self.list = {}
    self.cells = {}
    self.newCells = {}
    self.callBack = function(param)
        self:CellsCallBack(param)
    end
    self.queue = nil
    self.speedType = nil
    self.moreBtnMax = 0
    self.buildData = nil
    self.originalEndTime = nil
    self.endTime = 0
    self.startTime = 0
    self.laseTime = 0
    self.lastChangeTime = 0
    self.sliderValue = nil
    self.leftText = nil
    self.useItem = {}
    self.moreParent = nil
    self.moreCell = nil
    self.close = false
    self.minCount = 1
    self.selectIndex = 1
    self.selectItemId = 0
    self.maxCount = 1
    self.spendGold = 0
end

function UISpeedView:DataDestroy()
    --发命令
    self:SendMsg()
end

function UISpeedView:OnEnable()
    base.OnEnable(self)
end

function UISpeedView:OnDisable()
    base.OnDisable(self)
end

function UISpeedView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildDataSignal)
    self:AddUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
    self:AddUIListener(EventId.UpdateGiftPackData, self.UpdateGiftPackDataSignal)
    self:AddUIListener(EventId.AddBuildSpeedSuccess, self.AddBuildSpeedSuccessSignal)
    self:AddUIListener(EventId.AddSpeedSuccess, self.AddSpeedSuccessSignal)
    self:AddUIListener(EventId.UpdateAllianceHelpNum, self.RefreshAllianceHelp)
end

function UISpeedView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildDataSignal)
    self:RemoveUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
    self:RemoveUIListener(EventId.UpdateGiftPackData, self.UpdateGiftPackDataSignal)
    self:RemoveUIListener(EventId.AddBuildSpeedSuccess, self.AddBuildSpeedSuccessSignal)
    self:RemoveUIListener(EventId.AddSpeedSuccess, self.AddSpeedSuccessSignal)
    self:RemoveUIListener(EventId.UpdateAllianceHelpNum, self.RefreshAllianceHelp)
end
-- 滑动条
function UISpeedView:InputListener()
    local temp = self.itemInfoInput:GetText()
    if temp ~= nil and temp ~= "" then
        local inputCount = tonumber(temp)
        if inputCount <= self.minCount then
            self:SetInputText(self.minCount)
        elseif inputCount >= self.maxCount then
            self:SetInputText(self.maxCount)
        else
            self:SetInputText(inputCount)
        end
    end
end

function UISpeedView:SetInputText(value,isGray)
    if self.maxCount < 1 then
        return 
    end
    self.itemInfoSlider:SetValue(value / self.maxCount)
    self.selectItemNum = value
    local currentText = self.itemInfoInput:GetText()
    if self.curCount ~= value or currentText ~= tostring(value) then
        self.curCount = value
        self.itemInfoInput:SetText(value)
    end
    self:SetAddAndDecBtnState(isGray)
    self:SetSelectInfo()
end

function UISpeedView:SetAddAndDecBtnState(isGray)
    self.itemInfoDecBtn:SetInteractable (self.curCount > self.minCount)
    self.itemInfoAddBtn:SetInteractable(self.curCount < self.maxCount)
    self.itemInfoAddBtnActiveImg:SetActive(self.curCount < self.maxCount)
    self.itemInfoAddBtnInactiveImg:SetActive(isGray and isGray or (self.curCount >= self.maxCount))
    self.itemInfoDecBtnActiveImg:SetActive(self.curCount > self.minCount)
    self.itemInfoDecBtnInactiveImg:SetActive(self.curCount <= self.minCount)
end

function UISpeedView:OnSliderValueChange(value)
    local num = Mathf.Round(value * self.maxCount)
    if num < self.minCount then
        num = self.minCount
    end
    self.curCount = num
    self:SetInputText(num)
end

function UISpeedView:OnAddBtnClick()
    local p = self.minCount
    if self.curCount + p <= self.maxCount then
        self:SetInputText(self.curCount + p)
    end
end

function UISpeedView:OnDecBtnClick()
    if self.curCount > self.minCount then
        self:SetInputText(self.curCount - self.minCount)
    end
end

--itemNewShow
function UISpeedView:ClearScroll()
    self.newCells = {}
    self.item_scrollView:ClearCells()--清循环列表数据
    self.item_scrollView:RemoveComponents(UISpeedItem)--清循环列表gameObject
end

function UISpeedView:OnCreateCell(itemObj, index)
    itemObj.name = tostring(index)
    local cell = self.item_scrollView:AddComponent(UISpeedItem, itemObj)
    cell:ReInit(self.list[index],index)
    self.newCells[index] = cell
end

function UISpeedView:OnDeleteCell(itemObj, index)
    self.newCells[index] = nil
    self.item_scrollView:RemoveComponent(itemObj.name, UISpeedItem)
end

function UISpeedView:RefreshCells()
    self:ClearScroll()
    local count = #self.list
    if count > 0 then
        self.item_scrollView:SetTotalCount(count)
        self.item_scrollView:RefillCells(self.selectIndex,true)
    end
end

function UISpeedView:RefreshAllianceHelp()
    local isInAlliance = LuaEntry.Player:IsInAlliance()
    local isShowHelp = false
    if isInAlliance then
        local selfList = DataCenter.AllianceHelpDataManager:GetSelfHelpList()
        if next(selfList) then
            for _, helpData in pairs(selfList) do
                if helpData.content == self.buildUUId and helpData.nowCount > 0 then
                    isShowHelp = true
                    self.allianceHelpText:SetText(helpData.nowCount.."/"..helpData.maxCount)
                end
            end
        end
    end
    self.allianceHelp:SetActive(isShowHelp)
end
-------
function UISpeedView:ReInit()
    self:RefreshTitleText()
    self.speedItemTitleText:SetLocalText(441071)
    self.speedTimeDes:SetLocalText(141146)
    self.greenBtnText:SetLocalText(GameDialogDefine.SPEED_REPLENISH_ALL)
    self.yellowBtnText:SetLocalText(GameDialogDefine.COMPLETE_IMMEDIATELY)
    self.close = false
    local speedType, uuid = self:GetUserData()
    self.speedType = tonumber(speedType)
    self.uuid = tonumber(uuid)
    if self.speedType == ItemSpdMenu.ItemSpdMenu_City then
        self.buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.uuid)
        self.queue = nil
        self.originalEndTime = self.buildData.updateTime
        self.endTime = self.buildData.updateTime
        self.startTime = self.buildData.startTime
        local curTime = UITimeManager:GetInstance():GetServerTime()
        if self.startTime > curTime then
            self.startTime = curTime
        end
    elseif self.speedType == ItemSpdMenu.ItemSpdMenu_Fix_Ruins then
        self.buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.uuid)
        self.queue = nil
        self.originalEndTime = self.buildData.destroyEndTime
        self.endTime = self.buildData.destroyEndTime
        self.startTime = self.buildData.destroyStartTime
        local curTime = UITimeManager:GetInstance():GetServerTime()
        if self.startTime > curTime then
            self.startTime = curTime
        end
    else
        self.buildData = nil
        self.queue = DataCenter.QueueDataManager:GetQueueByUuid(self.uuid)
        self.originalEndTime = self.queue.endTime
        self.endTime = self.queue.endTime
        self.startTime = self.queue.startTime
    end
    self.more_btn_go:SetActive(false)

    self:ShowImage()
    self:RefreshAllianceHelp()
    self:GetDataList()
    self:RefreshUI()
end

function UISpeedView:RefreshTitleText()
    local textId = 100159
    if self.itemSpdMenu == ItemSpdMenu.ItemSpdMenu_City then
        textId = 100159
    end
    self.title_text:SetLocalText(textId)
end

function UISpeedView:InitSelectIndex()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local leftSecondTime =  (self.endTime - curTime)/1000
    local curSpeedType = ItemSpdMenu.ItemSpdMenu_ALL
    for i = 1, #self.list do                   -- 有匹配类型的加速道具 非通用
        if self.speedType == tonumber(self.list[i].type2) then
            curSpeedType = tonumber(self.speedType)
            break
        end
    end
    local minPerNum = self.list[1].perNum
    local maxPerNum = self.list[1].perNum
    for i = 1, #self.list do
        local curItem = self.list[i]
        if tonumber(curItem.type2) == curSpeedType then
            minPerNum = Mathf.Min(curItem.perNum,minPerNum)
            maxPerNum = Mathf.Max(curItem.perNum,maxPerNum)
        end
    end
    if minPerNum >= leftSecondTime then
        self.selectIndex = 1
    elseif maxPerNum < leftSecondTime then
        local maxIndex = 1
        for i = 1, (#self.list) do
            local curItem = self.list[i]
            if tonumber(curItem.type2) == curSpeedType then
                if maxPerNum == curItem.perNum then
                    maxIndex = i
                    break
                end
            end
        end
        self.selectIndex = maxIndex
    else
        for i = 1, (#self.list - 1) do
            local firstItem = self.list[i]
            local secondItem = self.list[i+1]
            if firstItem.type2 == curSpeedType and secondItem.type2 == curSpeedType then
                if firstItem.perNum < leftSecondTime and secondItem.perNum >= leftSecondTime then
                    self.selectIndex = i
                    break
                end
            end
        end
    end
end

function UISpeedView:RefreshUI()
    local listCount = #self.list
    local mainLv = DataCenter.BuildManager.MainLv
    local oneKeyUnlock = LuaEntry.DataConfig:TryGetNum("speedup_config", "k1")
    local diamondSpeedUnlock = LuaEntry.DataConfig:TryGetNum("speedup_config", "k2")
    self.SpeedContent:SetActive(listCount > 0)
    self.NothingContent:SetActive(listCount == 0)
    self.greenBtn.gameObject:SetActive(listCount > 0 and (mainLv >= tonumber(oneKeyUnlock)))
    self.useBtn.gameObject:SetActive(listCount > 0)
    self.yellowBtn.gameObject:SetActive(mainLv >= tonumber(diamondSpeedUnlock))
    if listCount > 0 then
        self.useBtnName:SetLocalText(110046)
        self:InitSelectIndex()
        self:RefreshCells()
        if self.newCells[self.selectIndex] then
            self.newCells[self.selectIndex]:clickSelectBtn()
        end
    else
        self.nothingText:SetLocalText(320830)
        self.obtain_btn_name:SetLocalText(100547)
        --self.gift_cell:ReInit({speedType = self.speedType})
        --self:ShowCells()
        --self:EndTimeChangeRefresh()
    end
    self:OnRefreshUseDiamond()
end

--item click callback
function UISpeedView:ClickItemCallBack(selectIndex)
    if selectIndex >0 then
        local item =  self.list[selectIndex]
        if item and item.itemId ~= self.selectItemId then
            for _, cell in pairs(self.newCells) do
                cell:refreshSelectState(false)
            end
            self.selectItemId = item.itemId
            self.selectItem = item
            self:SetMaxSliderCount()
            self.newCells[selectIndex]:refreshSelectState(true)
            self:SetInputText(self.selectItemNum)
        end
    end
end

function UISpeedView:SetMaxSliderCount()
    local itemData = DataCenter.ItemData:GetItemById(self.selectItemId)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local leftSecondTime =  (self.endTime - curTime)/1000
    if leftSecondTime >= itemData.count * self.selectItem.perNum then
        self.maxCount = itemData.count
    else
        self.maxCount = Mathf.CeilToInt(leftSecondTime/self.selectItem.perNum)
    end
    self.selectItemNum = self.maxCount
end

function UISpeedView:SetSelectInfo()
    local perSpeed =  GetTableData(DataCenter.ItemTemplateManager:GetTableName(), self.selectItemId,"para3")
    self.speedTimeText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.selectItemNum * tonumber(perSpeed)*1000))
end

function UISpeedView:MoreBtnClick()
    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Speed_Button)
    local itemId = self.moreCell.param.itemId
    self:UseAddItem(itemId, self.moreBtnMax)
    DataCenter.ItemData:UseTool(tostring(itemId), self.moreBtnMax)
    local time = 0
    local para1 = GetTableData(DataCenter.ItemTemplateManager:GetTableName(), itemId,"para1", "")
    local temp = string.split_ss_array(para1, ';')
    if temp[2] ~= nil then
        time = DataCenter.ItemTemplateManager:GetShowTime(temp[1], temp[2])
        self:ReduceTime(time * self.moreBtnMax)
    end
    self.moreCell:RefreshOwnCount()
    self.more_btn_go:SetActive(false)
end

function UISpeedView:ShowImage()
    if self.speedType == ItemSpdMenu.ItemSpdMenu_Science then
        if self.queue~=nil then
            local template = DataCenter.ScienceManager:GetSearchingScienceTemplate(self.queue.uuid)
            if template ~= nil then
                -- self.icon:LoadSprite(string.format(LoadPath.ScienceIcons,template.icon))
                -- self.icon.rectTransform:Set_sizeDelta(109, 113)
                -- self.name_text:SetLocalText(template.name)
            end
        end

    elseif self.speedType == ItemSpdMenu.ItemSpdMenu_Soldier then
        local template = DataCenter.ArmyManager:GetQueueArmyTemplate(self.queue.type)
        if template ~= nil then
            -- self.icon:LoadSprite(string.format(LoadPath.SoldierIcons,template.icon))
            -- self.icon.rectTransform:Set_sizeDelta(96, 110)
            -- self.name_text:SetLocalText(template.name)
        end
    elseif self.speedType == ItemSpdMenu.ItemSpdMenu_Heal then
        -- self.icon:LoadSprite(HospitalItemImageName)
        -- self.icon.rectTransform:Set_sizeDelta(68, 89)
        -- self.name_text:SetText("")
    elseif self.speedType == ItemSpdMenu.ItemSpdMenu_City or self.speedType == ItemSpdMenu.ItemSpdMenu_Fix_Ruins then
        if self.buildData ~= nil then
            local level = 1
            if self.buildData.level > 0 then
                level = self.buildData.level
            end
            -- self.icon:LoadSprite(DataCenter.BuildManager:GetBuildIconPath(self.buildData.itemId,level))
            -- self.icon.rectTransform:Set_sizeDelta(100, 100)
            -- self.name_text:SetLocalText(GetTableData(DataCenter.BuildTemplateManager:GetTableName(),
                    -- self.buildData.itemId + level,"name"))
        end
    end
end

function UISpeedView:CellsCallBack(cell)
    self.moreCell = cell
    local itemId = cell.param.itemId
    local time = 0
    local para1 = GetTableData(DataCenter.ItemTemplateManager:GetTableName(), itemId,"para1", "")
    local temp = string.split_ss_array(para1, ';')
    if temp[2] ~= nil then
        time = DataCenter.ItemTemplateManager:GetShowTime(temp[1], temp[2])
    end
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local outTime = curTime + time - self.endTime
    if outTime >= OutTime then
        UIUtil.ShowMessage(Localization:GetString(GameDialogDefine.SPEED_TIME_PUT_TIP),2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
            self:ConfirmUse(itemId, cell, time)
            if outTime > 0 then
                SoundUtil.PlayEffect(SoundAssets.Music_Effect_Speed_Button2)
            else
                SoundUtil.PlayEffect(SoundAssets.Music_Effect_Speed_Button)
            end
        end,nil,nil,nil,nil,true)
    else
        self:ConfirmUse(itemId, cell, time)
        if outTime > 0 then
            SoundUtil.PlayEffect(SoundAssets.Music_Effect_Speed_Button2)
        else
            SoundUtil.PlayEffect(SoundAssets.Music_Effect_Speed_Button)
        end
    end
end

function UISpeedView:ConfirmUse(id,cell,time)
    self:UseAddItem(id,1)
    DataCenter.ItemData:UseTool(tostring(id), 1)
    self:ReduceTime(time)
    cell:RefreshOwnCount()
    if cell.param.item.count > 0 then
        self.more_btn_go:SetActive(true)
        self:ShowMoreBtn()
        self:ShowMoreBtnName(time, cell)
    else
        self.more_btn_go:SetActive(false)
    end
end

function UISpeedView:Update()
    if (not self.close) and self.endTime ~= 0 then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        if self.endTime <= curTime then
            self.endTime = 0
            self.close = true
            if self.ctrl ~= nil then
                self.ctrl:CloseSelf()
            end
        else
            local changeTime = self.endTime - curTime
            local maxTime = self.endTime - self.startTime
            if changeTime > 0 then
                local tempTimeSec = math.ceil(changeTime / 1000)
                if tempTimeSec ~= self.laseTime then
                    self.laseTime = tempTimeSec
                    local tempTimeValue = UITimeManager:GetInstance():MilliSecondToFmtString(changeTime)
                    self:SetLeftText(tempTimeValue)
                    --刷新钻石
                    --self.finish_cell:RefreshTime()
                    if tempTimeSec % 60 == 0 then
                        --刷新一键补充
                        self:OnRefreshUseDiamond()
                        --self.replenish_cell:RefreshTime()
                    end
                end

                if maxTime > 0 then
                    local tempValue = 1 - changeTime / maxTime
                    if TimeBarUtil.CheckIsNeedChangeBar(changeTime,self.lastChangeTime,maxTime,SliderLength) then
                        self.lastChangeTime = changeTime
                        self:SetSliderValue(tempValue)
                    end
                end
            end
        end
    end
end
-- 
function UISpeedView:OnClickGreenBtnSpeed()
    local needShow = DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(TodayNoSecondConfirmType.SpeedReplenish)
    if needShow then
        local param = {}
        param.list = self.list
        param.speedType = self.speedType
        param.uuid = self.uuid
        param.endTime = self.endTime
        param.originalEndTime = self.originalEndTime
        UIManager:GetInstance():OpenWindow(UIWindowNames.UISpeedReplenish, NormalBlurPanelAnim, param)
    else
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local leftTime = self.endTime - curTime
        local itemList = DataCenter.ItemManager:GetReplenishUseSpeedArr(leftTime, self.list)
        local itemStr = ""
        for k,v in ipairs(itemList) do
            if itemStr == "" then
                itemStr = v.itemId .. ";" .. v.count
            else
                itemStr = itemStr .. "|" .. v.itemId .. ";" .. v.count
            end
        end
        self:OnSendMessage(itemStr)
        self.ctrl:CloseSelf()
    end
end

function UISpeedView:OnSendMessage(itemStr)
    if itemStr ~= "" then
        if self.speedType == ItemSpdMenu.ItemSpdMenu_City then
            SFSNetwork.SendMessage(MsgDefines.BuildCcdMNew, { bUUID = self.uuid, itemIDs = itemStr, isFixRuins = false})
        elseif self.speedType == ItemSpdMenu.ItemSpdMenu_Fix_Ruins then
            SFSNetwork.SendMessage(MsgDefines.BuildCcdMNew, { bUUID = self.uuid, itemIDs = itemStr,isFixRuins = true})
        elseif self.speedType == ItemSpdMenu.ItemSpdMenu_Heal then
            local hType = MarchArmsType.Free
            if LuaEntry.Player.serverType == ServerType.DRAGON_BATTLE_FIGHT_SERVER then
                hType = MarchArmsType.CROSS_DRAGON
            end
            SFSNetwork.SendMessage(MsgDefines.QueueCcdMNew, { qUUID = self.uuid, itemIDs = itemStr, isGold = IsGold.NoUseGold }, nil ,hType)
        else
            SFSNetwork.SendMessage(MsgDefines.QueueCcdMNew, { qUUID = self.uuid, itemIDs = itemStr, isGold = IsGold.NoUseGold })
        end
    end
end

function UISpeedView:OnClickUseBtn()
    local itemStr =   self.selectItemId .. ";" .. self.selectItemNum
    self:OnSendMessage(itemStr)
end

function UISpeedView:OnClickObtainBtn()
    self.ctrl:CloseSelf()
    GoToResLack.GotoSpeedLackList(self.speedType)
end

function UISpeedView:OnClickDiamondSpeed()
    if LuaEntry.Player.gold < self.spendGold then
        GoToUtil.GotoPayTips()
    else
        --先发送已使用的加速，在发送使用钻石
        UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.UpgradeUseDiamond, Localization:GetString(GameDialogDefine.USE_GOLF_ADD_SPEED_TIP_DES),
                2, string.GetFormattedSeperatorNum(self.spendGold), Localization:GetString(GameDialogDefine.CANCEL),function()
                    self.view.close = true
                    self.view.ctrl:CloseSelf()
                    if self.speedType == ItemSpdMenu.ItemSpdMenu_City then
                        SFSNetwork.SendMessage(MsgDefines.BuildCcdMNew, { bUUID = self.uuid,itemIDs = "",isFixRuins = false, useGold = true})
                    else
                        local queue = DataCenter.QueueDataManager:GetQueueByUuid(self.uuid)
                        if queue ~= nil then
                            SFSNetwork.SendMessage(MsgDefines.QueueCcdMNew, { qUUID = self.uuid, itemIDs = "",isGold = IsGold.UseGold })
                        end
                    end
                end, function()
                end,nil,nil,true, DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold),nil)
    end
end

function UISpeedView:OnRefreshUseDiamond()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local leftTime = self.endTime - curTime
    local costGold = CommonUtil.GetTimeDiamondCost(math.floor(leftTime / 1000))
    if costGold ~= self.spendGold then
        self.spendGold = costGold
        self.yellow_btn_cost_text:SetText(string.GetFormattedSeperatorNum(self.spendGold))
        self:RefreshGoldColor()
    end
end

function UISpeedView:RefreshGoldColor()
    local gold = LuaEntry.Player.gold
    if gold < self.spendGold then
        self.yellow_btn_cost_text:SetColor(ButtonRedTextColor)
    else
        self.yellow_btn_cost_text:SetColor(WhiteColor)
    end
end

function UISpeedView:SetSliderValue(value)
    if self.sliderValue ~= value then
        self.sliderValue = value
        self.slider:SetValue(value)
    end
end


function UISpeedView:SetLeftText(value)
    if self.leftText ~= value then
        self.leftText = value
        self.left_time:SetText(value)
    end
end

function UISpeedView:UseAddItem(itemId,count)
    if self.useItem[itemId] == nil then
        self.useItem[itemId] = count
    else
        self.useItem[itemId] = self.useItem[itemId] + count
    end
end

function UISpeedView:ReduceTime(time)
    self.endTime = self.endTime - time
    self.startTime = self.startTime - time
    self:EndTimeChangeRefresh()
end

function UISpeedView:ShowMoreBtn()
    local moreParent = self.moreCell:GetMoreBtnParent()
    if self.moreParent ~= moreParent then
        self.moreParent = moreParent
        self.more_btn_go.transform:SetParent(moreParent)
        self.more_btn_go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
        local ret,time = self.more_btn_go:PlayAnimationReturnTime("ShowMoreBtn")
        if ret then
            self.showTimer = TimerManager:GetInstance():GetTimer(time + 0.5, function()
                if self.showTimer ~= nil then
                    self.showTimer:Stop()
                    self.showTimer = nil
                end
            end , self, true,false,false)
            self.showTimer:Start()
        end
    end
end

function UISpeedView:HideMoreBtn()
    if self.moreParent then
        self.moreParent = nil
        self.more_btn_go.transform:SetParent(self.transform)
        self.more_btn_go.transform:SetAsFirstSibling()
        self.more_btn_go:Play("CloseMoreBtn",0,0)
    end
end

function UISpeedView:ShowMoreBtnName(oneTime, item)
    if oneTime > 0 then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local endTime = self.endTime
        self.moreBtnMax = math.floor((endTime - curTime) / oneTime)
        if self.moreBtnMax > item.param.item.count then
            self.moreBtnMax = item.param.item.count
        end
        if self.moreBtnMax > 0 then
            self.use_count_btn_name:SetText("x"..self.moreBtnMax)
        else
            self.more_btn_go:SetActive(false)
        end
    end
end

function UISpeedView:SendMsg()
    local itemStr = ""
    for k,v in pairs(self.useItem) do
        if itemStr == "" then
            itemStr = k..";"..v
        else
            itemStr = itemStr.."|"..k..";"..v
        end
    end
    self.useItem = {}
    self:OnSendMessage(itemStr)
end

function UISpeedView:UpdateBuildDataSignal(uuid)
    if not self.close then
        if self.uuid == uuid then
            self:RefreshEndTime()
        end
    end
end

function UISpeedView:AddBuildSpeedSuccessSignal()
    if not self.close then
        self:RefreshEndTime()
    end
end

function UISpeedView:AddSpeedSuccessSignal()
    if not self.close then
        self:RefreshEndTime()
    end
end

function UISpeedView:RefreshEndTime()
    if self.speedType == ItemSpdMenu.ItemSpdMenu_City then
        local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.uuid)
        if buildData ~= nil then
            self.endTime = buildData.updateTime --self.endTime - self.originalEndTime + buildData.updateTime
        end
    elseif self.speedType == ItemSpdMenu.ItemSpdMenu_Fix_Ruins then
        local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.uuid)
        if buildData ~= nil then
            self.endTime = buildData.updateTime --self.endTime - self.originalEndTime + buildData.destroyEndTime
        end
    else
        local queue = DataCenter.QueueDataManager:GetQueueByUuid(self.uuid)
        if queue ~= nil then
            self.endTime = self.queue.endTime--self.endTime - self.originalEndTime + self.queue.endTime
        end
    end
    self:EndTimeChangeRefresh()
    self:GetDataList()
    self:RefreshUI()
end

function UISpeedView:UpdateGoldSignal()
    if not self.close then
        self.finish_cell:RefreshGoldColor()
        self:RefreshGoldColor()
    end
end

function UISpeedView:UpdateGiftPackDataSignal()
    --if not self.close then
    --    self.gift_cell:Refresh()
    --end
end

function UISpeedView:ShowCells()
    self.more_btn_go:SetActive(false)
    self:GetDataList()
    local count = #self.list
    for k,v in ipairs(self.list) do
        if self.cells[k] == nil then
            self.cells[k] = v
            v.visible = true
            v.req = self:GameObjectInstantiateAsync(UIAssets.UISpeedCell, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject
                go:SetActive(true)
                go.transform:SetParent(self.content.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                go.transform:SetAsLastSibling()
                local nameStr = tostring(NameCount)
                go.name = nameStr
                NameCount = NameCount + 1
                local model = self.content:AddComponent(UISpeedCell, nameStr)
                model:ReInit(self.cells[k])
                self.cells[k].model = model
            end)
        else
            v.req = self.cells[k].req
            v.model = self.cells[k].model
            self.cells[k] = v
            v.visible = true
            if v.model ~= nil then
                v.model:ReInit(v)
            end
        end
    end
    local cellCount = #self.cells
    if cellCount > count then
        for i = count + 1, cellCount, 1 do
            local cell = self.cells[i]
            if cell ~= nil then
                cell.visible = false
                if cell.model ~= nil then
                    cell.model:Refresh()
                end
            end
        end
    end
end

function UISpeedView:GetDataList()
    self.list = {}
    local list = DataCenter.ItemData:GetSpeedItem(self.speedType)
    if list ~= nil then
        for k, v in ipairs(list) do
            local param = {}
            param.item = v
            param.itemId = tonumber(v.itemId)
            param.type2 = GetTableData(DataCenter.ItemTemplateManager:GetTableName(), param.itemId,"type2", 0)
            param.order_num = GetTableData(DataCenter.ItemTemplateManager:GetTableName(), param.itemId,"order_num", 0)
            param.callBack = self.callBack
            param.perNum = tonumber(GetTableData(DataCenter.ItemTemplateManager:GetTableName(), param.itemId,"para3"))
            param.clickCallBack = function(index) self:ClickItemCallBack(index)  end
            table.insert(self.list, param)
        end
    end
    if self.list[2] ~= nil then
        table.sort(self.list, function(a, b)
            if a.type2 < b.type2 then
                return false
            elseif a.type2 > b.type2 then
                return true
            else
                if a.order_num > b.order_num then
                    return false
                elseif a.order_num < b.order_num then
                    return true
                else
                    if a.itemId > b.itemId then
                        return true
                    end
                end
            end
            return false
        end)
    end
end

function UISpeedView:EndTimeChangeRefresh()
    local param = {}
    param.list = self.list
    param.speedType = self.speedType
    param.uuid = self.uuid
    param.endTime = self.endTime
    param.originalEndTime = self.originalEndTime
    self.replenish_cell:ReInit(param)
    self.finish_cell:ReInit(param)
end

return UISpeedView

local AllianceCurShopItem = require "UI.UIAlliance.UIAllianceShop.Component.AllianceCurShopItem"
local UIAllianceShopBuyPanelView = BaseClass("UIAllianceShopBuyPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local closeBtn_path = "UICommonMidPopUpTitle/bg_mid/CloseBtn"
local panelCloseBtn_path = "UICommonMidPopUpTitle/panel"
local titleTxt_path = "UICommonMidPopUpTitle/bg_mid/titleText"

local item_path = "ItemContent"
local item_des_path = "ItemContent/ItemDesBg/Viewport/Content/ItemDes"
local input_path = "ItemContent/InputGo/InputField"
local dec_btn_path = "ItemContent/InputGo/DecBtn"
local dec_btn_active_path = "ItemContent/InputGo/DecBtn/DecActiveImage"
local dec_btn_passive_path = "ItemContent/InputGo/DecBtn/DecInActiveImage"
local add_btn_path = "ItemContent/InputGo/AddBtn"
local add_btn_active_path = "ItemContent/InputGo/AddBtn/AddActiveImage"
local add_btn_passive_path = "ItemContent/InputGo/AddBtn/AddInActiveImage"
local use_btn_path = "ItemContent/UseBtn"
local use_btn_name_path = "ItemContent/UseBtn/obj/UseBtnName"
local single_item_count_path = "ItemContent/UseBtn/obj/singleItemCount"
local buy_btn_path = "ItemContent/buyBtn"
local buy_btn_name_path = "ItemContent/buyBtn/obj/BuyBtnName"
local alliance_item_count_path = "ItemContent/buyBtn/obj/allianceItemCount"
local cur_item_obj_path = "ItemContent/UIBagCell"
local price_text_path = "ItemContent/OwnNum"
local itemNameTxt_path = "ItemContent/ItemName"
local slider_path = "ItemContent/InputGo/SliderGreenHandle"

local resIcon_path = "UICommonFullTop/gold_btn/goldIcon"
local resCount_path = "UICommonFullTop/gold_btn/gold_num_text"

function UIAllianceShopBuyPanelView : OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIAllianceShopBuyPanelView : OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIAllianceShopBuyPanelView : ComponentDefine()
    self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
    self.closeBtn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.panelCloseBtn = self:AddComponent(UIButton, panelCloseBtn_path)
    self.panelCloseBtn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.titleTxt = self:AddComponent(UITextMeshProUGUIEx, titleTxt_path)
    
    self.cur_item = self:AddComponent(AllianceCurShopItem, cur_item_obj_path)
    self.item = self:AddComponent(UITextMeshProUGUIEx, item_path)
    self.item_des = self:AddComponent(UITextMeshProUGUIEx, item_des_path)
    self.dec_btn = self:AddComponent(UIButton, dec_btn_path)
    self.dec_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Dec)
        self:OnDecClick()
    end)
    self.dec_btn_active = self:AddComponent(UIImage, dec_btn_active_path)
    self.dec_btn_passive = self:AddComponent(UIImage, dec_btn_passive_path)
    self.add_btn = self:AddComponent(UIButton, add_btn_path)
    self.add_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Add)
        self:OnAddClick()
    end)
    self.add_btn_active = self:AddComponent(UIImage, add_btn_active_path)
    self.add_btn_passive = self:AddComponent(UIImage, add_btn_passive_path)
    self.use_btn = self:AddComponent(UIButton, use_btn_path)
    self.use_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnUseClick()
    end)
    self.use_btn_name = self:AddComponent(UITextMeshProUGUIEx, use_btn_name_path)
    self.use_btn_name:SetLocalText(110029)
    self.single_item_count = self:AddComponent(UITextMeshProUGUIEx, single_item_count_path)

    self.buy_btn = self:AddComponent(UIButton, buy_btn_path)
    self.buy_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnBuyClick()
    end)
    self.buy_btn_name = self:AddComponent(UITextMeshProUGUIEx, buy_btn_name_path)
    self.buy_btn_name:SetLocalText(110029)
    self.alliance_item_count = self:AddComponent(UITextMeshProUGUIEx, alliance_item_count_path)
    self.input = self:AddComponent(UITMPInput, input_path)
    self.input:SetOnEndEdit(function(value)
        self:IptOnValueChange(value)
    end)
    --self.price_text = self:AddComponent(UITextMeshProUGUIEx, price_text_path)
    --self.price_text:SetText("")
    self.itemNameTxt = self:AddComponent(UITextMeshProUGUIEx, itemNameTxt_path)

    self.resIcon = self:AddComponent(UIImage, resIcon_path)
    self.resCount = self:AddComponent(UITextMeshProUGUIEx, resCount_path)
    
    self.slider = self:AddComponent(UISlider, slider_path)
    self.slider:SetOnValueChanged(function (value)
        self:OnSliderValueChange(value)
    end)
    
    self:RefreshAll()
end

function UIAllianceShopBuyPanelView : ComponentDestroy()

end

function UIAllianceShopBuyPanelView : DataDefine()
    self.inputValue = 1
    self.param = self:GetUserData()
    self.maxCount = self.ctrl:GetMaxCount(self.param.tabIndex, self.param.itemData.itemId)
    self.stateData = self.ctrl:GetCurButtonState(self.inputValue, self.param.tabIndex, self.param.itemData.itemId)
end

function UIAllianceShopBuyPanelView : DataDestroy()
    self.param = nil
    self.stateData = nil
    self.maxCount = -1
end

function UIAllianceShopBuyPanelView : RefreshAll()
    if self.param.tabIndex == 1 then
        self.titleTxt:SetLocalText(110029)
    else
        self.titleTxt:SetLocalText(450049)
    end
    
    local curItemData = self.param.itemData
    if curItemData.itemId ~= nil and curItemData.itemId ~= "" then
        self.item:SetActive(true)
        self.cur_item:RefreshData(curItemData)
        self.item_des:SetText(curItemData.des)
        self.itemNameTxt:SetText(curItemData.itemName)
    else
        self.item:SetActive(false)
    end
    self:SetInputValue(1)
    self:RefreshRes()
    self:CheckButtonState()
end

function UIAllianceShopBuyPanelView : RefreshRes()
    if self.param.tabIndex == 1 then
        self.resIcon:LoadSprite("Assets/Main/Sprites/UI/UIAlliance/UIAlliance_icon_acc")
        local accPoint = string.GetFormattedSeperatorNum(DataCenter.AllianceShopDataManager:GetAccPoint())
        self.resCount:SetText(accPoint)
    else
        self.resIcon:LoadSprite("Assets/Main/Sprites/UI/UIAlliance/UIAlliance_icon_alliance_point")
        local alliancePoint = string.GetFormattedSeperatorNum(DataCenter.AllianceShopDataManager:GetAlliancePoint())
        self.resCount:SetText(alliancePoint)
    end
end

function UIAllianceShopBuyPanelView : SetInputValue(value)
    value = math.min(value, self.maxCount)
    self.inputValue = value
    self.input:SetText(self.inputValue)
    if self.maxCount == 0 then
        self.slider:SetValue(0)
    else
        self.slider:SetValue((self.inputValue+0.001) / self.maxCount)
    end
end

function UIAllianceShopBuyPanelView : CheckButtonState()
    local tab =  self.param.tabIndex
    self.stateData = self.ctrl:GetCurButtonState(self.inputValue, self.param.tabIndex, self.param.itemData.itemId)
    self.dec_btn_active:SetActive(self.stateData.canDec)
    self.dec_btn_passive:SetActive(not self.stateData.canDec)
    self.add_btn_active:SetActive(self.stateData.canAdd)
    self.add_btn_passive:SetActive(not self.stateData.canAdd)
    self.buy_btn:SetActive(tab == 2)
    self.use_btn:SetActive(tab == 1)
    if tab == 1 then
        self.single_item_count:SetText(self.stateData.needAlAcc)
        if self.stateData.accLack then
            self.single_item_count:SetColor(RedColor)
        else
            self.single_item_count:SetColor(WhiteColor)
        end
    elseif tab == 2 then
        self.alliance_item_count:SetText(self.stateData.needAlPoint)
        if self.stateData.accLack then
            self.alliance_item_count:SetColor(RedColor)
        else
            self.alliance_item_count:SetColor(WhiteColor)
        end
    end
end

function UIAllianceShopBuyPanelView : OnDecClick()
    if self.inputValue <= 0 then
        return
    end
    local changeNum = self.ctrl:OnChangeSelectNumCheck(self.inputValue - 1, self.param.tabIndex, self.param.itemData.itemId)
    self:SetInputValue(changeNum)
end

function UIAllianceShopBuyPanelView : OnAddClick()
    local changeNum = self.ctrl:OnChangeSelectNumCheck(self.inputValue + 1, self.param.tabIndex, self.param.itemData.itemId)
    self:SetInputValue(changeNum)
end

function UIAllianceShopBuyPanelView : OnUseClick()
    self.ctrl:OnUseClick(self.inputValue, self.stateData, self.param.itemData.itemId)
end

function UIAllianceShopBuyPanelView : OnBuyClick()
    self.ctrl:OnBuyClick(self.inputValue, self.stateData, self.param.itemData.itemId)
end

function UIAllianceShopBuyPanelView : Update()
    local tab = self.param.tabIndex
    if tab == 1 then
        local curItemData = self.param.itemData
        if not string.IsNullOrEmpty(curItemData.itemId) then
            local goods = DataCenter.ItemTemplateManager:GetItemTemplate(curItemData.itemId)
            if goods.type == GOODS_TYPE.MIGRATE_ITEM then
                --self.price_text:SetActive(true)
                --self.price_text:SetLocalText(309048, DataCenter.AllianceShopDataManager:GetMigrateItemAllianceShopRestCount())
                return
            end
        end
        --self.price_text:SetActive(false)
        if self.inputValue == 0 then
            CS.UIGray.SetGray(self.use_btn.transform, true, false)
        else
            CS.UIGray.SetGray(self.use_btn.transform, false, true)
        end
        return
    end
    if self.stateData.allianceNum ~= nil and self.stateData.allianceNum > -1 then
        --self.price_text:SetActive(true)
        if self.stateData.allianceNum == 0 then
            local curTime = UITimeManager:GetInstance():GetServerTime()
            local timeLeft = self.stateData.nextWeekTime - curTime
            local t = "00:00:00"
            if timeLeft > 0 then
                t = UITimeManager:GetInstance():MilliSecondToFmtString(timeLeft)
            end
            local time = Localization:GetString("391040", t)
            --self.price_text:SetText(time)
        else
            local num = Localization:GetString("391039", self.stateData.allianceNum)
            --self.price_text:SetText(num)
        end
        if self.stateData.allianceNum == 0 or self.inputValue == 0 then
            CS.UIGray.SetGray(self.buy_btn.transform, true, false)
        else
            CS.UIGray.SetGray(self.buy_btn.transform, false, true)
        end
    else
        --self.price_text:SetActive(false)
        if self.inputValue == 0 then
            CS.UIGray.SetGray(self.buy_btn.transform, true, false)
        else
            CS.UIGray.SetGray(self.buy_btn.transform, false, true)
        end
    end
end

function UIAllianceShopBuyPanelView : OnAddListener()
    base.OnAddListener(self)
    --self:AddUIListener(EventId.AllianceShopShow, self.RefreshRes)
end

function UIAllianceShopBuyPanelView : OnRemoveListener()
    base.OnRemoveListener(self)
    --self:RemoveUIListener(EventId.AllianceShopShow, self.RefreshRes)
end

function UIAllianceShopBuyPanelView : IptOnValueChange(value)
    local cnt = tonumber(value)
    local changeNum = self.ctrl:OnChangeSelectNumCheck(cnt, self.param.tabIndex, self.param.itemData.itemId)
    self:SetInputValue(changeNum)
end

function UIAllianceShopBuyPanelView : OnSliderValueChange(value)
    if self.maxCount == 0 then
        self.slider:SetValue(0)
        return
    end
    local num = math.floor(self.maxCount * value)
    self.inputValue = num
    self.input:SetText(self.inputValue)
    self:CheckButtonState()
end

return UIAllianceShopBuyPanelView
--- Created by shimin
--- DateTime: 2023/10/31 15:50
--- 德雷克boss使用道具界面

local UIDrakeBossUseItemView = BaseClass("UIDrakeBossUseItemView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local UICommonItem = require "UI.UICommonItem.UICommonItem"

local title_text_path = "UICommonMidPopUpTitle/bg_mid/titleText"
local return_btn_path = "UICommonMidPopUpTitle/panel"
local close_btn_path = "UICommonMidPopUpTitle/bg_mid/CloseBtn"
local res_item_path = "Root/UICommonItem"
local name_text_path = "Root/name_text"
local des_text_path = "Root/ItemDesBg/Viewport/Content/des_text"
local own_text_path = "Root/own_text"
local exchange_btn_path = "Root/BtnExchange"
local exchange_btn_text_path = "Root/BtnExchange/TextBtnExchange"
local input_path = "Root/InputGo/InputField"
local add_btn_path = "Root/InputGo/AddBtn"
local dec_btn_path = "Root/InputGo/DecBtn"
local slider_path = "Root/InputGo/Slider"

function UIDrakeBossUseItemView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

function UIDrakeBossUseItemView:ComponentDefine()
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.return_btn:SetOnClick(function()
        CS.GameEntry.Sound:PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        CS.GameEntry.Sound:PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.res_item = self:AddComponent(UICommonItem, res_item_path)
    self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
    self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
    self.own_text = self:AddComponent(UITextMeshProUGUIEx, own_text_path)
    self.exchange_btn = self:AddComponent(UIButton, exchange_btn_path)
    self.exchange_btn:SetOnClick(function()
        CS.GameEntry.Sound:PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnExchangeBtnClick()
    end)
    self.exchange_btn_text = self:AddComponent(UITextMeshProUGUIEx, exchange_btn_text_path)
    self.input = self:AddComponent(UITMPInput, input_path)
    self.input:SetOnEndEdit(function(value)
        self:InputListener(value)
    end)
    self.add_btn = self:AddComponent(UIButton, add_btn_path)
    self.add_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Add)
        self:OnAddBtnClick()
    end)
    self.dec_btn = self:AddComponent(UIButton, dec_btn_path)
    self.dec_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Dec)
        self:OnDecBtnClick()
    end)
    self.slider = self:AddComponent(UISlider, slider_path)
    self.slider:SetOnValueChanged(function (value)
        self:OnSliderValueChange(value)
    end)
end

function UIDrakeBossUseItemView:ComponentDestroy()
end

function UIDrakeBossUseItemView:DataDefine()
    self.param = {}
    self.num = 1
    self.minCount = 1
    self.maxCount = 1
end

function UIDrakeBossUseItemView:DataDestroy()
    self.param = {}
    self.num = 1
    self.minCount = 1
    self.maxCount = 1
end

function UIDrakeBossUseItemView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIDrakeBossUseItemView:OnEnable()
    base.OnEnable(self)
end

function UIDrakeBossUseItemView:OnDisable()
    base.OnDisable(self)
end

function UIDrakeBossUseItemView:OnAddListener()
    base.OnAddListener(self)
end

function UIDrakeBossUseItemView:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIDrakeBossUseItemView:ReInit()
    self.param = self:GetUserData()
    self.title_text:SetLocalText(GameDialogDefine.REDEMPTION)
    self.num = 1
    local itemData = DataCenter.ItemData:GetItemByUuid(self.param.uuid)
    if itemData ~= nil then
        self.maxCount = itemData.count
        local itemId = itemData.itemId
        
        local param = {}
        param.rewardType = RewardType.GOODS
        param.itemId = itemId
        self.res_item:ReInit(param)

        self.name_text:SetText(DataCenter.ItemTemplateManager:GetName(itemId))
        self.des_text:SetText(DataCenter.ItemTemplateManager:GetDes(itemId))
    end

    self.own_text:SetLocalText(GameDialogDefine.OWN, self.maxCount)
    self.exchange_btn_text:SetLocalText(GameDialogDefine.REDEMPTION)
    self:RefreshShow()
end

function UIDrakeBossUseItemView : OnSliderValueChange(value)
    if self.maxCount == self.minCount then
        self.slider:SetValue(1)
        self:SetNum(1)
        return
    end
    local num = math.floor(value * self.maxCount)
    num = math.max(num, self.minCount)
    self:SetNum(num)
end

function UIDrakeBossUseItemView:InputListener(value)
    local temp = value
    if temp ~= nil and temp ~= "" then
        local inputCount = toInt(temp)
        if inputCount < self.minCount then
            inputCount = self.minCount
        elseif inputCount > self.maxCount then
            inputCount = self.maxCount
        end
        if self.num ~= inputCount then
            self:SetNum(inputCount)
        else
            self.input:SetText(self.num)
        end
    else
        self:RefreshShow()
    end
end

--计算之后要显示的数字
function UIDrakeBossUseItemView:SetNum(num)
    self.num = num
    self:RefreshShow()
end

--计算之后要显示的数字
function UIDrakeBossUseItemView:RefreshShow()
    self.input:SetText(self.num)
    self.slider:SetValue((self.num + 0.001) / self.maxCount)
    if self.num <= self.minCount then
        UIGray.SetGray(self.dec_btn.transform, true, false)
    else
        UIGray.SetGray(self.dec_btn.transform, false, true)
    end
    if self.num >= self.maxCount then
        UIGray.SetGray(self.add_btn.transform, true, false)
    else
        UIGray.SetGray(self.add_btn.transform, false, true)
    end
end

function UIDrakeBossUseItemView:OnAddBtnClick()
    if self.num < self.maxCount then
        self:SetNum(self.num + 1)
    end
end

function UIDrakeBossUseItemView:OnDecBtnClick()
    if self.num > self.minCount then
        self:SetNum(self.num - 1)
    end
end

function UIDrakeBossUseItemView:OnExchangeBtnClick()
    SFSNetwork.SendMessage(MsgDefines.ItemUse, { uuid = self.param.uuid, num = self.num, callBossUseType = CallBossUseType.GetReward})
    self.ctrl:CloseSelf()
end



return UIDrakeBossUseItemView
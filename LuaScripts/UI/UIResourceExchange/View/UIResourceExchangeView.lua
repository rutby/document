---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl
--- DateTime:
---
local UIResourceExchangeView = BaseClass("UIResourceExchangeView",UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIResourceExchangeCell = require "UI.UIResourceExchange.Component.UIResourceExchangeCell"
local title_path = "UICommonMiniPopUpTitle/Bg_mid/titleText"
local return_btn_path = "UICommonMiniPopUpTitle/panel"
local close_btn_path = "UICommonMiniPopUpTitle/Bg_mid/CloseBtn"
local btn_2_path = "UICommonMiniPopUpTitle/BtnGo/RightBtn"
local btn_2_txt_path = "UICommonMiniPopUpTitle/BtnGo/RightBtn/RightBtnName"
local icon1_path = "UICommonItem1"
local count1_text_path = "UICommonItem1/clickBtn/NumText"
local icon2_path = "UICommonItem2"
local name2_text_path = "UICommonItem2/clickBtn/NameText2"

local slider_path = "InputGo/DesBg/Slider"
local add_btn_path = "InputGo/DesBg/AddBtn"
local sub_btn_path = "InputGo/DesBg/DecBtn"
local curNum_txt_path = "InputGo/DesBg/InputField/Text"

local tips_txt_path = "UICommonMiniPopUpTitle/DesName"

local function OnCreate(self)
    base.OnCreate(self)
    self.title = self:AddComponent(UITextMeshProUGUIEx,title_path)

    self.btn_2 = self:AddComponent(UIButton, btn_2_path)
    self.btn_2_txt = self:AddComponent(UITextMeshProUGUIEx,btn_2_txt_path)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)

    self.icon = self:AddComponent(UIResourceExchangeCell, icon1_path)
    self.count_text = self:AddComponent(UITextMeshProUGUIEx, count1_text_path)

    self.name2_text = self:AddComponent(UITextMeshProUGUIEx,name2_text_path)
    
    self.exchangeIcon = self:AddComponent(UIResourceExchangeCell, icon2_path)
    
    self.slider = self:AddComponent(UISlider,slider_path)
    self.slider:SetOnValueChanged(function (value)
        self:OnValueChange(value)
    end)
    self.add_btn = self:AddComponent(UIButton,add_btn_path)
    self.add_btn:SetOnClick(function ()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Add)
        self:OnAdd()
    end)
    self.sub_btn = self:AddComponent(UIButton,sub_btn_path)
    self.sub_btn:SetOnClick(function ()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Dec)
        self:OnSub()
    end)
    
    self._curNum_txt = self:AddComponent(UITextMeshProUGUIEx,curNum_txt_path)
    
    self.tips_txt = self:AddComponent(UITextMeshProUGUIEx,tips_txt_path)
    self.tips_txt:SetText("")

    self:SetData(self:GetUserData())
end

local function OnDestroy(self)
    self.titleText =nil
    self.tipText = nil
    self.text1 =nil
    self.text2 =nil
    self.action1 = nil
    self.closeAction = nil
    self.action2 =nil
    self.title = nil
    self.btn_2 = nil
    self.btn_2_txt = nil
    self.close_btn = nil
    self.return_btn = nil
    self._curNum_txt = nil
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function SetData(self,tipText,text2,action2,closeAction,titleText,item1,item2)
    self.titleText =titleText
    self.tipText = tipText
    self.text2 =text2
    self.closeAction = closeAction
    self.action2 =action2
    self.OnCloseClick = false
    self.item = item1
    self.exchangeItem = item2
    self:RefreshData()
end

local function RefreshData(self)
    if self.titleText~=nil and self.titleText~="" then
        self.title:SetLocalText(self.titleText) 
    else
        self.title:SetLocalText(100378) 
    end
    
    if self.btn_2:GetActive() then
        if self.action2 then
            self.btn_2:SetOnClick(function ()
                self:OnCloseInTimer()
                self.action2()
            end)
        else
            self.btn_2:SetOnClick(function ()
                self:OnClickFunc()
            end)
        end
        if self.text2~=nil and self.text2~="" then
            self.btn_2_txt:SetLocalText(self.text2) 
        else
            self.btn_2_txt:SetLocalText(GameDialogDefine.CANCEL) 
        end
    end

    if self.closeAction then
        self.close_btn:SetOnClick(function ()
            self:OnCloseInTimer()
            self.closeAction()
        end)
        self.return_btn:SetOnClick(function ()
            self:OnCloseInTimer()
            self.closeAction()
        end)
    else
        self.close_btn:SetOnClick(function()  
            self.ctrl:CloseSelf()
        end)
        self.return_btn:SetOnClick(function()  
            self.ctrl:CloseSelf()
        end)
    end

    if self.item then
        self.icon:SetActive(true)
        self.icon:ReInit(self.item)
        self.exchangeIcon:ReInit(self.exchangeItem)
    else
        self.icon:SetActive(false)
    end
    self.minValue = 1
    self.isItem = false
    local item = DataCenter.ItemData:GetItemById(self.item.itemId)
    if item then
        self.maxNum = item.count
        self.isItem = true
    end
    if self.item.isUseCurCount then
        self.maxNum = self.item.curCount
    end
    self:RefreshSlider(self.item.count)
    self:SetItemName(self.item.count)
    local str = ""
    if self.isItem then
        local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(self.item.itemId)
        str = Localization:GetString(itemTemplate.name)
        if self.item.exchangeType == 1 then
            for i ,v in pairs(itemTemplate.name_value) do
                str = Localization:GetString(i,string.GetFormattedSeperatorNum(tonumber(itemTemplate.para)))
            end
        elseif self.item.exchangeType == 2 then
            str = Localization:GetString(itemTemplate.name)
        end
    end
    
    if self.exchangeItem.rewardType == RewardType.MASTERY_POINT then
        self.tips_txt:SetLocalText(111031)
    elseif self.exchangeItem.rewardType == RewardType.GOODS  then
        self.tips_txt:SetLocalText(143588,str,self.exchangeItem.name)
    else
        self.tips_txt:SetLocalText(143588,str,DataCenter.RewardManager:GetNameByType(self.exchangeItem.rewardType))
    end

    self.curNum = self.item.count
    self._curNum_txt:SetText(self.curNum)
end

local function OnValueChange(self,val)
    local cnt = math.floor(val *(self.maxNum - self.minValue) + self.minValue + 0.5)
    self._curNum_txt:SetText(cnt)
    self:SetCountText(cnt)
    self:SetItemName(cnt)
end

local function OnAdd(self)
    local value = self.slider:GetValue()
    local cnt = math.floor(value *(self.maxNum - self.minValue) + self.minValue + 0.5)
    if self:CheckChange(cnt + 1) then
       self:RefreshSlider(cnt+1)
    end
end
local function OnSub(self)
    local value = self.slider:GetValue()
    local cnt = math.floor(value *(self.maxNum - self.minValue) + self.minValue + 0.5)
    if self:CheckChange(cnt - 1) then
        self:RefreshSlider(cnt-1)
    end
end

local function CheckChange(self,willNun)
    if willNun >= self.minValue and willNun <= self.maxNum then
        return true
    end
    return false
end

--初始默认数量
local function RefreshSlider(self,num)
    local percent = (num - self.minValue) / math.max((self.maxNum - self.minValue),1)
    if num == 1 then
        if self.item.curCount and self.item.curCount == 1 then
            self.slider:SetValue(1)
        else
            self.slider:SetValue(percent)
        end
    else
        self.slider:SetValue(percent)
    end
end

local function SetItemName(self,value)
    --local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.item.itemId)
    self.curNum = value
    self.name2_text:SetText(string.GetFormattedSeperatorNum(self.exchangeItem.scale*value))
end

local function SetCountText(self,value)
    self.icon:SetItemCount(value)
end

local function OnClickFunc(self)
    if self.curNum then
        if self.isItem then
            if self.item.exchangeType == 1 then --使用背包道具
                local item = DataCenter.ItemData:GetItemById(self.item.itemId)
                if item then
                    if self.curNum == self.item.curCount and  self.item.isUseCurCount and self.item.surplus then
                        UIUtil.ShowMessage(Localization:GetString(self.item.surplusTips,self.item.surplus), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
                            SFSNetwork.SendMessage(MsgDefines.ItemUse, { uuid = item.uuid,num = self.curNum})
                            self.ctrl:CloseSelf()
                        end)
                        return
                    else
                        SFSNetwork.SendMessage(MsgDefines.ItemUse, { uuid = item.uuid,num = self.curNum})
                    end
                end
            elseif self.item.exchangeType == 3 then --使用建筑自选箱子
                SFSNetwork.SendMessage(MsgDefines.ItemUse, { uuid = self.item.uuid,num = self.curNum ,para1 = tostring(self.item.selectIndex)})
            end
        end
    end
    self.ctrl:CloseSelf()
end

local function OnCloseInTimer(self)
    self.OnCloseClick =true
    local closeTimer = TimerManager:GetInstance():GetTimer(0.1, function()
        if self.OnCloseClick and self.ctrl then
            self.ctrl:CloseSelf()
        end
    end, nil, true, false, false)

    closeTimer:Start()
end

UIResourceExchangeView.OnCreate = OnCreate
UIResourceExchangeView.OnDestroy = OnDestroy
UIResourceExchangeView.OnEnable = OnEnable
UIResourceExchangeView.OnDisable = OnDisable
UIResourceExchangeView.SetData = SetData
UIResourceExchangeView.RefreshData =RefreshData
UIResourceExchangeView.OnCloseInTimer =OnCloseInTimer
UIResourceExchangeView.SetItemName = SetItemName
UIResourceExchangeView.SetCountText = SetCountText
UIResourceExchangeView.OnValueChange = OnValueChange
UIResourceExchangeView.OnAdd = OnAdd
UIResourceExchangeView.OnSub = OnSub
UIResourceExchangeView.CheckChange = CheckChange
UIResourceExchangeView.RefreshSlider = RefreshSlider
UIResourceExchangeView.OnClickFunc = OnClickFunc
return UIResourceExchangeView
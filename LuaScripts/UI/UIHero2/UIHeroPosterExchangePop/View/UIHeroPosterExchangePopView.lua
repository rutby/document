
local UIHeroPosterExchangePopView = BaseClass("UIHeroPosterExchangePopView", UIBaseView)
local base = UIBaseView

local UIMedalCell = require "UI.UIHero2.UIHeroPosterExchangePop.Component.UIMedalCell"
local UIHeroCell = require "UI.UIHero2.Common.UIHeroCellSmall"

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    local param = self:GetUserData()
    self.param = param
    self.exchangeItemId = param.heroId
    self.targetItemId = param.exchangeMedalId
    self.exchangeRatio = param.exchangeMedalNum
    
    local have1 = param.count
    --self.itemCell1:SetData(self.exchangeItemId, have1)
    --self.itemCell1Icon:LoadSprite(self.param.icon)
    self.itemCell1Icon:InitWithConfigIdByPoster(self.param.heroId)
    self.itemCell1Num:SetText(string.GetFormattedSeperatorNum(have1))
    self.itemCell1Name:SetText(HeroUtils.GetHeroNameByConfigId(self.param.heroId))
    self.itemCell2:SetData(self.targetItemId, 0)
    
    self.exchangeItemTotal = have1

    self.exchangeNum = 0
    if have1 > 0 then
        self.exchangeNum = 1
    end
    self.slider:SetValue(self.exchangeNum / have1)
end

local function OnDestroy(self)
    self:ComponentDestroy()
    base.OnDestroy(self)

    self.callback = nil
end

local function ComponentDefine(self)
    self.textTitle = self:AddComponent(UIText, "UICommonMidPopUpTitle/bg_mid/titleText")
    self.textTitle:SetLocalText(150199) 

    local panel = self:AddComponent(UIButton, "UICommonMidPopUpTitle/panel")
    panel:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))

    local btnClose = self:AddComponent(UIButton, "UICommonMidPopUpTitle/bg_mid/CloseBtn")
    btnClose:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
    
    self.itemCell1Icon = self:AddComponent(UIHeroCell, "Root/UIHeroCellSmall")
    self.itemCell1Num = self:AddComponent(UIText, "Root/UIHeroCellSmall/NumText")
    self.itemCell1Name = self:AddComponent(UIText, "Root/UIHeroCellSmall/TextName")

    self.itemCell2 = self:AddComponent(UIMedalCell, "Root/UIItem2")

    self.slider = self:AddComponent(UISlider, 'Root/Slider')
    self.slider:SetOnValueChanged(BindCallback(self, self.OnSliderValueChanged))
    
    self.btnExchange = self:AddComponent(UIButton, 'Root/BtnExchange')
    self.btnExchange:SetOnClick(BindCallback(self, self.OnBtnExchangeClick))
    self.textBtnExchange = self:AddComponent(UIText, 'Root/BtnExchange/TextBtnExchange')
    self.textBtnExchange:SetLocalText(110029)

    self.addBtn = self:AddComponent(UIButton, 'Root/AddBtn')
    self.addBtn:SetOnClick(BindCallback(self, self.OnAddClick))

    self.subBtn = self:AddComponent(UIButton, 'Root/SubBtn')
    self.subBtn:SetOnClick(BindCallback(self, self.OnSubClick))
    
    self.maxBtn = self:AddComponent(UIButton, "Root/MaxBtn")
    self.maxBtn:SetOnClick(BindCallback(self, self.OnMaxClick))
    local maxBtnText = self:AddComponent(UIText, "Root/MaxBtn/MaxBtnText")
    
    maxBtnText:SetLocalText(110000)
end

local function OnMaxClick(self)
    local num = self.exchangeItemTotal
    if num <= 0 then
        return
    end
    num = math.min(num, self.exchangeItemTotal)
    self:SetCurExchangeNum(num)
end

local function OnAddClick(self)
    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Add)
    local curNum = self.exchangeNum + 1
    curNum = math.max(0, math.min(curNum, self.exchangeItemTotal))
    if curNum > self.exchangeNum then
        self:SetCurExchangeNum(curNum)
    end
end

local function OnSubClick(self)
    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Dec)
    local curNum = self.exchangeNum - 1
    curNum = math.max(0, math.min(curNum, self.exchangeItemTotal))
    if curNum < self.exchangeNum then
        self:SetCurExchangeNum(curNum)
    end
end

local function SetCurExchangeNum(self, curNum)
    if self.exchangeItemTotal == 0 then
        self.slider:SetValue(0)
    else
        local sliderValue = Mathf.Clamp01(curNum / self.exchangeItemTotal)
        self.slider:SetValue(sliderValue)
    end
end

local function OnShortCutBtnClick(self)

end

local function ComponentDestroy(self)
    if self.slider ~= nil then
        self.slider:SetValue(0)
    end
    self.textTitle = nil
    self.itemCell2 = nil
    self.textItemName1 = nil
    self.textItemName2 = nil
    self.slider = nil
    self.btnExchange = nil
    self.textBtnExchange = nil
end

local function OnSliderValueChanged(self, value)
    local num = Mathf.Round(self.exchangeItemTotal * value)
    self.itemCell1Num:SetText(num.."/"..self.exchangeItemTotal)
    self.itemCell2:SetNumDisplay(num * self.exchangeRatio)
    self.exchangeNum = num
    CS.UIGray.SetGray(self.btnExchange.transform, num <= 0, num > 0)
end

local function OnBtnExchangeClick(self)
    if self.exchangeNum <= 0 then
        return
    end
    local result = {}
    for i = 1, self.exchangeNum do
        table.insert(result, self.param.uuids[i])
    end
    SFSNetwork.SendMessage(MsgDefines.HeroPosterExchange, result)
    self.ctrl:CloseSelf()
end

UIHeroPosterExchangePopView.OnCreate= OnCreate
UIHeroPosterExchangePopView.OnDestroy = OnDestroy
UIHeroPosterExchangePopView.ComponentDefine = ComponentDefine
UIHeroPosterExchangePopView.ComponentDestroy = ComponentDestroy
UIHeroPosterExchangePopView.OnSliderValueChanged = OnSliderValueChanged
UIHeroPosterExchangePopView.OnBtnExchangeClick = OnBtnExchangeClick
UIHeroPosterExchangePopView.OnAddClick = OnAddClick
UIHeroPosterExchangePopView.OnSubClick = OnSubClick
UIHeroPosterExchangePopView.OnShortCutBtnClick = OnShortCutBtnClick
UIHeroPosterExchangePopView.SetCurExchangeNum = SetCurExchangeNum
UIHeroPosterExchangePopView.OnMaxClick = OnMaxClick

return UIHeroPosterExchangePopView

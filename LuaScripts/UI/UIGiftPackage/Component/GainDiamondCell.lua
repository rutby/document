--[[
    钻石购买界面cell
--]]

local GainDiamondCell = BaseClass("GainDiamondCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local this_path = ""
local icon_path = "Icon"
local extra_text_path = "ExtraImage/TxtAdd"
local diamond_num_path = "DiamondNum"
local des_path = "Des"
local money_path = "MoneyText"
local extra_path = "ExtraImage"
local first_buy_path = "ExtraImage/FirstBuy"


-- 创建
local function OnCreate(self)
    base.OnCreate(self)

    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

-- 显示
local function OnEnable(self)
    base.OnEnable(self)
end

-- 隐藏
local function OnDisable(self)
    base.OnDisable(self)
end

--控件的定义
local function ComponentDefine(self)
    self.btn = self:AddComponent(UIButton, this_path)
    self.icon = self:AddComponent(UIImage, icon_path)
    self.extra_text = self:AddComponent(UIText, extra_text_path)
    self.diamond_num = self:AddComponent(UIText, diamond_num_path)
    self.des = self:AddComponent(UIText, des_path)
    self.money = self:AddComponent(UIText, money_path)
    self.extra = self:AddComponent(UIBaseContainer, extra_path)
    self.first_buy = self:AddComponent(UIText, first_buy_path)
    
    self.btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        DataCenter.PayManager:CallPayment(self.param)
    end)
end

--控件的销毁
local function ComponentDestroy(self)
    self.btn = nil
    self.icon = nil
    self.extra_text = nil
    self.diamond_num = nil
    self.des = nil
    self.money = nil
    self.extra = nil
    self.first_buy = nil
end

--变量的定义
local function DataDefine(self)
    self.startId = 8999
    self.param = { }
    self.firstBuyText = nil
end

--变量的销毁
local function DataDestroy(self)
    self.startId = nil
    self.param = nil
    self.firstBuyText = nil
end

-- 全部刷新
local function ReInit(self,param,iconNameId)
    self.param = param
    local id = iconNameId - self.startId
    self:SetIconImage(self:GetIconName(id))
    self.money:SetText(DataCenter.PayManager:GetDollarText(param.dollar, param.product_id))
    if param.type == "2" then
        local b1,b2 = math.modf(param.price)
        self.diamond_num:SetText(string.GetFormattedSeperatorNum(tonumber(param.gold_doller) - b1))
        self.extra_text:SetText("+"..string.GetFormattedSeperatorNum(b1))
        self.extra.gameObject:SetActive(true)
        self.des:SetLocalText(320015) 
        self:SetFirstBuyText(Localization:GetString("320000"))
    elseif param.type == "3" then
        local b1,b2 = math.modf(param.price)
        self.diamond_num:SetText(string.GetFormattedSeperatorNum(tonumber(param.gold_doller) - b1))
        self.extra_text:SetText("+"..string.GetFormattedSeperatorNum(b1))
        self.extra.gameObject:SetActive(true)
        self.des:SetLocalText(320014) 
        self:SetFirstBuyText(Localization:GetString("320000"))
    else
        self.diamond_num:SetText(string.GetFormattedSeperatorNum(tonumber(param.gold_doller)))
        self.extra.gameObject:SetActive(false)
        self.des:SetText("")
    end
end

local function SetIconImage(self,imageName)
    self.icon:LoadSprite(imageName)
end

local function GetIconName(self,id)
    if id == 1 then
        return "img_iapiconItem1"
    elseif id == 2 then
        return "img_iapiconItem2"
    elseif id == 3 then
        return "img_iapiconItem3"
    elseif id == 4 then
        return "img_iapiconItem4"
    elseif id == 5 then
        return "img_iapiconItem6"
    end
end

local function SetFirstBuyText(self,value)
    if self.firstBuyText ~= value then
        self.firstBuyText = value
        self.first_buy:SetText(value)
    end
end

GainDiamondCell.OnCreate = OnCreate
GainDiamondCell.OnDestroy = OnDestroy
GainDiamondCell.OnDisable = OnDisable
GainDiamondCell.ReInit = ReInit
GainDiamondCell.ComponentDefine = ComponentDefine
GainDiamondCell.DataDefine = DataDefine
GainDiamondCell.ComponentDestroy = ComponentDestroy
GainDiamondCell.DataDestroy = DataDestroy
GainDiamondCell.OnEnable = OnEnable
GainDiamondCell.SetIconImage = SetIconImage
GainDiamondCell.GetIconName = GetIconName
GainDiamondCell.SetFirstBuyText = SetFirstBuyText

return GainDiamondCell
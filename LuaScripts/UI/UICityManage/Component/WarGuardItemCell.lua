--- Created by shimin.
--- DateTime: 2021/7/29 3:59
--- 迁城界面

local WarGuardItemCell = BaseClass("WarGuardItemCell", UIBaseContainer)
local base = UIBaseContainer


local Localization = CS.GameEntry.Localization



local item_icon_path = "UICommonItem/clickBtn/ItemIcon"
local title_txt_path = "Text_title"
local des_txt_Path = "Text_des"
local count_txt_Path = "Text_count"
local itemPrice_txt_Path = "BtnPurchase/btnTxtObj/txt2"
local itemSure_txt_Path = "BtnPurchase/btnTxtObj/txt1"

local buy_btn_path = "BtnPurchase"
local use_btn_path = "UseBtn"
local use_btn_txt_path = "UseBtn/UseBtnName"

TabType =
{
    
}

--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
   -- self:ReInit()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)

    self.item_icon = self:AddComponent(UIImage,item_icon_path)
    self.title_txt = self:AddComponent(UITextMeshProUGUIEx, title_txt_path)
    self.des_txt = self:AddComponent(UITextMeshProUGUIEx, des_txt_Path)
    self.count_txt = self:AddComponent(UITextMeshProUGUIEx, count_txt_Path)
    self.price_txt = self:AddComponent(UITextMeshProUGUIEx, itemPrice_txt_Path)
    self.itemSure_txt = self:AddComponent(UITextMeshProUGUIEx, itemSure_txt_Path)
    self.use_btn_txt = self:AddComponent(UITextMeshProUGUIEx, use_btn_txt_path)

    self.buy_btn = self:AddComponent(UIButton, buy_btn_path)
    self.use_btn = self:AddComponent(UIButton, use_btn_path)

    self.buy_btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnBuyBtnClick()
    end)

    self.use_btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnUseBtnClick()
    end)

end

local function ComponentDestroy(self)

    self.item_icon = nil
    self.title_txt = nil
    self.des_txt = nil
    self.count_txt = nil
    self.price_txt = nil
    self.itemSure_txt = nil
    self.use_btn_txt = nil

end


local function DataDefine(self)
    self.itemSure_txt:SetLocalText(110001) 
    self.use_btn_txt:SetLocalText(110046) 
end

local function DataDestroy(self)

end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)

end


local function OnRemoveListener(self)
    base.OnRemoveListener(self)

end

local function ReInit(self,param)
    self.param = param
    if self.param ~=nil then
        
        self.title_txt:SetText(self.param.name)
        self.des_txt:SetLocalText(self.param.description) 
        self.price_txt :SetText( self.param.price)
        self.item_icon:LoadSprite(string.format(LoadPath.ItemPath, self.param.icon))
        self.count_txt:SetLocalText(GameDialogDefine.OWN_WITH, string.GetFormattedSeperatorNum(self.param.count))
        if self.param.count > 0 then
            self.buy_btn.gameObject:SetActive(false)
            self.use_btn.gameObject:SetActive(true)
        else
            self.buy_btn.gameObject:SetActive(true)
            self.use_btn.gameObject:SetActive(false)
        end
        
    end
    
end

local function OnBuyBtnClick(self)
    if self.param.callBack ~= nil then
   --     Logger.LogError(" index  warGuardItemCell " .. self.param.index)
        self.param.callBack(self.param.index)
    end
end

local function OnUseBtnClick(self)
    if self.param.callBack ~= nil then
     --   Logger.LogError(" index  warGuardItemCell " .. self.param.index)
        self.param.callBack(self.param.index)
    end
end




WarGuardItemCell.OnCreate = OnCreate
WarGuardItemCell.OnDestroy = OnDestroy
WarGuardItemCell.OnEnable = OnEnable
WarGuardItemCell.OnDisable = OnDisable
WarGuardItemCell.ComponentDefine = ComponentDefine
WarGuardItemCell.ComponentDestroy = ComponentDestroy
WarGuardItemCell.DataDefine = DataDefine
WarGuardItemCell.DataDestroy = DataDestroy
WarGuardItemCell.OnAddListener = OnAddListener
WarGuardItemCell.OnRemoveListener = OnRemoveListener
WarGuardItemCell.ReInit = ReInit
WarGuardItemCell.OnUseBtnClick = OnUseBtnClick
WarGuardItemCell.OnBuyBtnClick = OnBuyBtnClick

return WarGuardItemCell
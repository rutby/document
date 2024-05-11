---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zhangliheng.
--- DateTime: 6/29/21 12:16 PM
---



local UIItemCell = BaseClass("UIItemCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local icon_path = "UICommonItem/clickBtn/ItemIcon"
local extra_text_path = "UICommonItem/clickBtn/FlagGo/FlagText"
local quality_path = "UICommonItem/clickBtn/ImgQuality"
local name_text_path = "NameText"
local des_text_path = "layout/DesText"
local own_text_path = "UICommonItem/clickBtn/NumText"

local buy_btn_path = "BuyBtn"
local buy_btn_name_path = "BuyBtn/BuyBtnLabel/BuyBtnName"
local buy_btn_count_path = "BuyBtn/BuyBtnLabel/BuyBtnValue"
local buy_btn_icon_path = "BuyBtn/BuyBtnLabel/BuyBtnValue/SpendIcon"

local use_btn_path = "UseBtn"
local use_btn_name_path = "UseBtn/UseBtnName"

local node_more_btn_path = "UseBtn/NodeBtnMore"
local btn_more_path = "UseBtn/NodeBtnMore/UseCountBtn"
local text_btn_more_path = "UseBtn/NodeBtnMore/UseCountBtn/UseCountBtnName"


local Param = DataClass("Param", ParamData)
local ParamData =  {
    callBack,
    index,
    template,
    count,
    addNum,
    id,
}


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
    self.nodeBtnMore.transform:Set_localScale(0, 1, 1)
end

-- 隐藏
local function OnDisable(self)
    base.OnDisable(self)
end


--控件的定义
local function ComponentDefine(self)
    self.imgQuality = self:AddComponent(UIImage, quality_path)
    --self.icon = self:AddComponent(UIImage, icon_path)
    self.extra_text = self:AddComponent(UITextMeshProUGUIEx, extra_text_path)
    self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
    self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
    self.own_text = self:AddComponent(UITextMeshProUGUIEx, own_text_path)
    self.buy_btn = self:AddComponent(UIButton, buy_btn_path)
    self.buy_btn_name = self:AddComponent(UITextMeshProUGUIEx, buy_btn_name_path)
    self.buy_btn_count = self:AddComponent(UITextMeshProUGUIEx, buy_btn_count_path)
    self.buy_btn_icon = self:AddComponent(UIImage, buy_btn_icon_path)
    self.use_btn = self:AddComponent(UIButton, use_btn_path)
    self.use_btn_name = self:AddComponent(UITextMeshProUGUIEx, use_btn_name_path)
    
    self.nodeBtnMore = self:AddComponent(UIAnimator, node_more_btn_path)
    self.btnMore = self:AddComponent(UIButton, btn_more_path)
    self.textBtnMore = self:AddComponent(UITextMeshProUGUIEx, text_btn_more_path)
    self.icon = self:AddComponent(UIImage, icon_path)
    self.buy_btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnBuyBtnClick()
    end)

    self.use_btn:SetOnClick(function()
        self:OnUseBtnClick()
    end)
    
    self.btnMore:SetOnClick(BindCallback(self, self.OnBtnMoreClick))
end

--控件的销毁
local function ComponentDestroy(self)
    self.icon = nil
    self.extra_text = nil
    self.name_text = nil
    self.des_text = nil
    self.own_text = nil
    self.buy_btn = nil
    self.buy_btn_name = nil
    self.buy_btn_count = nil
    self.buy_btn_icon = nil
    self.use_btn = nil
    self.use_btn_name = nil

    self.nodeBtnMore = nil
    self.btnMore = nil
    self.textBtnMore = nil
end

--变量的定义
local function DataDefine(self)
    self.param = {}
end

--变量的销毁
local function DataDestroy(self)
    self.param = nil
end

-- 全部刷新
local function ReInit(self,param)
    self.param = param
    if param.template ~= nil then
        self.imgQuality:LoadSprite(DataCenter.ItemTemplateManager:GetToolBgByColor(param.template.color))
        self.extra_text:SetText(string.GetFormattedStr(param.addNum))
        self.name_text:SetText(DataCenter.ItemTemplateManager:GetName(param.id))
        self.des_text:SetText(DataCenter.ItemTemplateManager:GetDes(param.id))
        self.own_text:SetText(param.count)
        self.use_btn_name:SetLocalText(110046)
        self.icon:LoadSprite(DataCenter.ItemTemplateManager:GetIconPath(param.template.id))
    end
end

local function OnUseBtnClick(self)
    if self.param.callBack ~= nil then
        self.param.callBack(self.param.index)
    end
end

local function RefreshOwnCount(self,count)
    self.param.count = count
    self.own_text:SetText(count)
end

local function ToggleMoreBtn(self, visible, ani, number)
    --if ani then
    --    self.nodeBtnMore:Play(visible and "ShowMoreBtn" or "CloseMoreBtn", 0, 0)
    --else
    --    self.nodeBtnMore.transform.localScale = Vector3.New(visible and 1 or 0, 1, 1)
    --end
    
    self.nodeBtnMore:SetActive(visible)
    if visible then
        self.nodeBtnMore:Play("ShowMoreBtn", 0, 0)
        self.textBtnMore:SetText("x"..number)
    end
end

local function OnBtnMoreClick(self)
    self.view:MoreBtnClick()
end

UIItemCell.OnCreate = OnCreate
UIItemCell.OnDestroy = OnDestroy
UIItemCell.Param = Param
UIItemCell.OnEnable = OnEnable
UIItemCell.OnDisable = OnDisable
UIItemCell.ComponentDefine = ComponentDefine
UIItemCell.ComponentDestroy = ComponentDestroy
UIItemCell.DataDefine = DataDefine
UIItemCell.DataDestroy = DataDestroy
UIItemCell.ReInit = ReInit
UIItemCell.OnUseBtnClick = OnUseBtnClick
UIItemCell.RefreshOwnCount = RefreshOwnCount

UIItemCell.OnBtnMoreClick = OnBtnMoreClick
UIItemCell.ToggleMoreBtn = ToggleMoreBtn

return UIItemCell
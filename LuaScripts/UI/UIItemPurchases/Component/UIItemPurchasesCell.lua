local UIItemPurchasesCell = BaseClass("UIItemPurchasesCell", UIBaseContainer)
local base = UIBaseContainer

local icon_path = "UICommonItem/clickBtn/ItemIcon"
local extra_text_path = "UICommonItem/clickBtn/FlagGo/FlagText"
local extra_path = "UICommonItem/clickBtn/FlagGo"
local item_quality_path = "UICommonItem/clickBtn/ImgQuality"
local name_text_path = "NameText"
local des_text_path = "layout/DesText"

local buy_btn_path = "BuyBtn"
local buy_btn_name_path = "BuyBtn/BuyBtnLabel/BuyBtnName"
local buy_btn_count_path = "BuyBtn/BuyBtnLabel/BuyBtnValue"
local buy_btn_icon_path = "BuyBtn/BuyBtnLabel/BuyBtnValue/SpendIcon"

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
	self.icon = self:AddComponent(UIImage, icon_path)
	self.extra_text = self:AddComponent(UIText, extra_text_path)
	self.extra = self:AddComponent(UIBaseContainer, extra_path)
	self.name_text = self:AddComponent(UIText, name_text_path)
	self.des_text = self:AddComponent(UIText, des_text_path)
	self.buy_btn = self:AddComponent(UIButton, buy_btn_path)
	self.buy_btn_name = self:AddComponent(UIText, buy_btn_name_path)
	self.buy_btn_count = self:AddComponent(UIText, buy_btn_count_path)
	self.buy_btn_icon = self:AddComponent(UIImage, buy_btn_icon_path)
	self.item_quality_img = self:AddComponent(UIImage, item_quality_path)
	self.buy_btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self:OnBuyBtnClick()
	end)
end

--控件的销毁
local function ComponentDestroy(self)
	self.icon = nil
	self.extra_text = nil
	self.extra = nil
	self.name_text = nil
	self.des_text = nil
	self.buy_btn = nil
	self.buy_btn_name = nil
	self.buy_btn_count = nil
	self.buy_btn_icon = nil
	self.use_btn = nil
	self.use_btn_name = nil
	self.more_btn_go = nil
	self.item_quality_img = nil
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
		if param.template.para ~= nil and param.template.para ~= "" then
			local para = tonumber(param.template.para)
			if para > 0 then
				self.extra:SetActive(true)
				self.extra_text:SetText(string.GetFormattedStr(para))
			else
				self.extra:SetActive(false)
			end
		else
			self.extra:SetActive(false)
		end
		self.icon:LoadSprite(string.format(LoadPath.ItemPath,param.template.icon))
		if param.count > 1 then
			self.name_text:SetText(DataCenter.ItemTemplateManager:GetName(param.template.id) .. " *" .. param.count)
		else
			self.name_text:SetText(DataCenter.ItemTemplateManager:GetName(param.template.id))
		end
		self.des_text:SetText(DataCenter.ItemTemplateManager:GetDes(param.template.id))
		self.item_quality_img:LoadSprite(DataCenter.ItemTemplateManager:GetToolBgByColor(param.template.color))

		self.buy_btn_name:SetLocalText(GameDialogDefine.BUY)
		self.buy_btn_icon:LoadSprite(param.goldImage)
		self.buy_btn_count:SetText(string.GetFormattedSeperatorNum(param.price))
		CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.buy_btn.rectTransform)
		self:RefreshColor(LuaEntry.Player.gold)
	end
end

local function OnBuyBtnClick(self)
	if self.param.callBack ~= nil then
		self.param.callBack(self.param.index,self.buy_btn_icon.transform.position)
	end
end

local function RefreshColor(self,gold)
	if gold < self.param.price then
		self.buy_btn_count:SetColor(RedColor)
	else
		self.buy_btn_count:SetColor(WhiteColor)
	end
end
UIItemPurchasesCell.OnCreate = OnCreate
UIItemPurchasesCell.OnDestroy = OnDestroy
UIItemPurchasesCell.OnEnable = OnEnable
UIItemPurchasesCell.OnDisable = OnDisable
UIItemPurchasesCell.ComponentDefine = ComponentDefine
UIItemPurchasesCell.ComponentDestroy = ComponentDestroy
UIItemPurchasesCell.DataDefine = DataDefine
UIItemPurchasesCell.DataDestroy = DataDestroy
UIItemPurchasesCell.ReInit = ReInit
UIItemPurchasesCell.OnBuyBtnClick = OnBuyBtnClick
UIItemPurchasesCell.RefreshColor = RefreshColor

return UIItemPurchasesCell
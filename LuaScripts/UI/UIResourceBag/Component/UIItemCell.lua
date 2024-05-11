local UIItemCell = BaseClass("UIItemCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization


local icon_path = "UICommonItem/clickBtn/ItemIcon"
local extra_text_path = "UICommonItem/clickBtn/FlagGo/FlagText"
local extra_path = "UICommonItem/clickBtn/FlagGo"
local item_quality_path = "UICommonItem/clickBtn/ImgQuality"
local item_bg_path = "UICommonItem/clickBtn/item_bg"
local num_txt_path = "UICommonItem/clickBtn/NumText"
local name_text_path = "NameText"
local des_text_path = "layout/DesText"
local own_text_path = "layout/OwnText"

local buy_btn_path = "BuyBtn"
local buy_btn_name_path = "BuyBtn/BuyBtnLabel/BuyBtnName"
local buy_btn_count_path = "BuyBtn/BuyBtnLabel/BuyBtnValue"
local buy_btn_icon_path = "BuyBtn/BuyBtnLabel/icon_go/SpendIcon"
local use_btn_path = "UseBtn"
local use_btn_name_path = "UseBtn/UseBtnName"
local more_btn_go_path = "MoreBtnGo"
local buy_tips_path = "BuyBtn/PercentBg"

local Param = DataClass("Param", ParamData)
local ParamData =  {
	callBack,
	index,
	template,
	btnType,
	count,
	goldImage,
	resourceType,
	uuid,
	buildId,
	itemId,--虚拟id
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
end

-- 隐藏
local function OnDisable(self)
	base.OnDisable(self)
end


--控件的定义
local function ComponentDefine(self)
	self.icon = self:AddComponent(UIImage, icon_path)
	self.extra_text = self:AddComponent(UIText, extra_text_path)
	self.extra = self:AddComponent(UIText, extra_path)
	self.name_text = self:AddComponent(UIText, name_text_path)
	self.des_text = self:AddComponent(UIText, des_text_path)
	self.own_text = self:AddComponent(UIText, own_text_path)
	self.buy_btn = self:AddComponent(UIButton, buy_btn_path)
	self.buy_btn_name = self:AddComponent(UIText, buy_btn_name_path)
	self.buy_btn_count = self:AddComponent(UIText, buy_btn_count_path)
	self.buy_btn_icon = self:AddComponent(UIImage, buy_btn_icon_path)
	self.use_btn = self:AddComponent(UIButton, use_btn_path)
	self.use_btn_name = self:AddComponent(UIText, use_btn_name_path)
	self.more_btn_go = self:AddComponent(UIBaseContainer, more_btn_go_path)
	self.item_quality_img = self:AddComponent(UIImage, item_quality_path)
	self.item_bg = self:AddComponent(UIImage, item_bg_path)
	self.num_txt = self:AddComponent(UIText,num_txt_path)
	self.buy_btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self:OnBuyBtnClick()
	end)

	self.use_btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self:OnUseBtnClick()
	end)
	self.buy_tips = self:AddComponent(UIBaseContainer,buy_tips_path)
end

--控件的销毁
local function ComponentDestroy(self)
	self.icon = nil
	self.extra_text = nil
	self.extra = nil
	self.name_text = nil
	self.des_text = nil
	self.own_text = nil
	self.num_txt = nil
	self.buy_btn = nil
	self.buy_btn_name = nil
	self.buy_btn_count = nil
	self.buy_btn_icon = nil
	self.use_btn = nil
	self.use_btn_name = nil
	self.more_btn_go = nil
	self.item_quality_img = nil
	self.item_bg = nil
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
	self.buy_tips:SetActive(false)
	if param.btnType == UIResourceBagBtnType.Buy or param.btnType == UIResourceBagBtnType.Use then
		self.item_quality_img.gameObject:SetActive(true)
		self.item_bg.gameObject:SetActive(true)
		self.icon.rectTransform:Set_sizeDelta(118, 118)
		self.use_btn:LoadSprite("Assets/Main/Sprites/UI/Common/New/Common_btn_green101")
		if param.template ~= nil then
			if param.template.para ~= nil and param.template.para ~= "" then
				local para = tonumber(param.template.para)
				if para > 0 then
					self.extra:SetActive(true)
					self.extra_text:SetText(string.GetFormattedStr(para))
				else
					self.extra:SetActive(false)
				end
			end
			self.icon:SetActive(true)
			self.icon:LoadSprite(string.format(LoadPath.ItemPath,param.template.icon))
			self.name_text:SetText(DataCenter.ItemTemplateManager:GetName(param.template.id))
			self.des_text:SetText(DataCenter.ItemTemplateManager:GetDes(param.template.id))
			self.item_quality_img:LoadSprite(DataCenter.ItemTemplateManager:GetToolBgByColor(param.template.color))

			if param.btnType == UIResourceBagBtnType.Use then
				self.own_text:SetActive(false)
				--self.own_text:SetText(Localization:GetString(GameDialogDefine.OWN_NUM)..param.count)
				self.num_txt:SetActive(true)
				self.num_txt:SetText(param.count)
				self.buy_btn:SetActive(false)
				self.use_btn:SetActive(true)
				self.use_btn_name:SetLocalText(GameDialogDefine.USE)
			elseif param.btnType == UIResourceBagBtnType.Buy then
				self.own_text:SetActive(false)
				self.num_txt:SetActive(false)
				self.buy_btn:SetActive(true)
				self.use_btn:SetActive(false)
				self.buy_btn_name:SetLocalText(GameDialogDefine.BUY_AND_USE)
				self.buy_btn_icon:LoadSprite(param.goldImage)
				if param.resourceType == ResourceType.Metal or param.resourceType == ResourceType.Wood then
					self.buy_btn_count:SetText(string.GetFormattedSeperatorNum(param.template.price_hot))
				else
					self.buy_btn_count:SetText(string.GetFormattedSeperatorNum(param.template.price))
				end
				CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.buy_btn.rectTransform)
				self:RefreshColor(LuaEntry.Player.gold)
			end
		else
			if param.itemId == "GolloesExplorer" then
				self.icon:LoadSprite("Assets/Main/Sprites/UI/UIGolloesCamp/UI_dispatch_icon_02")--string.format(LoadPath.ItemPath,"item2003"))
				self.name_text:SetLocalText(320213)
				self.des_text:SetLocalText(320217)
				self.item_quality_img:LoadSprite(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.BLUE))
				self.use_btn:LoadSprite("Assets/Main/Sprites/UI/Common/New/Common_btn_yellow101")
				self.own_text:SetActive(false)
				self.num_txt:SetActive(false)
				--if param.count > 0 then
				--	self.own_text:SetText(Localization:GetString("100238") .. UITimeManager:GetInstance():MilliSecondToFmtString(param.count))
				--	self.use_btn_name:SetLocalText(110046)
				--else
				--	self.use_btn_name:SetLocalText(110003)
				--	self.own_text:SetLocalText(140042)
				--end
				self.buy_btn:SetActive(false)
				self.use_btn:SetActive(true)
				self.use_btn_name:SetLocalText(110003)

				self.extra:SetActive(false)
			end
			
		end
	else
		self.extra:SetActive(false)
		self.item_quality_img.gameObject:SetActive(false)
		self.item_bg.gameObject:SetActive(false)
		self.icon.rectTransform:Set_sizeDelta(105, 139)
		if (param.buildId ~= nil) then
			self.icon:SetActive(true)
			self.icon:LoadSprite(DataCenter.BuildManager:GetBuildIconPath(param.buildId,1))
			
		end
		self.own_text:SetActive(false)
		self.num_txt:SetActive(false)
		self.buy_btn:SetActive(false)
		self.use_btn:SetActive(true)
		if param.btnType == UIResourceBagBtnType.LackResMode then
			if (param.template ~= nil) then
				local width = 118
				local height = 118
				local template = param.template
				local name = template:GetName()
				local desc = template:GetDesc()
				self.name_text:SetText(name)
				self.des_text:SetText(desc)
				local pic = template:GetIcon()
				if (string.contains(pic, "pic412000_2_free")) then
					width = 105
					height = 139
				end
				self.icon.rectTransform:Set_sizeDelta(width, height)
				if (string.IsNullOrEmpty(pic)) then
					self.icon:SetActive(false)
				else
					self.icon:SetActive(true)
					self.icon:LoadSprite(template:GetIcon())
				end
				self.use_btn_name:SetLocalText(GameDialogDefine.GOTO) 
			end
		end
	end
end


local function OnBuyBtnClick(self)
	if self.param.callBack ~= nil then
		local isBuy = true
		self.param.callBack(self.param.index,self.param.template,self.buy_btn.transform.position,isBuy)
	end
end

local function OnUseBtnClick(self)
	if self.param.itemId == "GolloesExplorer" then
		if DataCenter.MonthCardNewManager:CheckIfMonthCardActive() then
			GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_GROCERY_STORE, WorldTileBtnType.GolloesCamp)
		else
			GoToUtil.GoToMonthCard()
		end
		return
	else
		if self.param.callBack ~= nil then
			local isBuy = false
			self.param.callBack(self.param.index,self.param.template,self.use_btn.transform.position,isBuy)
		end
	end
end

local function RefreshOwnCount(self,count)
	self.param.count = count
	--self.own_text:SetText(Localization:GetString(GameDialogDefine.OWN_NUM)..count)
	self.num_txt:SetText(count)
end

local function RefreshColor(self,gold)
	if self.param.btnType == UIResourceBagBtnType.Buy then
		local price = self.param.template.price
		if self.param.resourceType == ResourceType.Metal or self.param.resourceType == ResourceType.Wood then
			price = self.param.template.price_hot
		end
		if gold < price then
			self.buy_btn_count:SetColor(RedColor)
		else
			self.buy_btn_count:SetColor(WhiteColor)
		end
	end
end

local function GetBtnPosition(self) 
	return self.use_btn_name.transform.position
end

local function GetMoreBtnParent(self)
	return self.more_btn_go.transform
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
UIItemCell.OnBuyBtnClick = OnBuyBtnClick
UIItemCell.OnUseBtnClick = OnUseBtnClick
UIItemCell.RefreshOwnCount = RefreshOwnCount
UIItemCell.RefreshColor = RefreshColor
UIItemCell.GetBtnPosition = GetBtnPosition
UIItemCell.GetMoreBtnParent = GetMoreBtnParent

return UIItemCell
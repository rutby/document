local UIItemCell = BaseClass("UIItemCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray

local icon_path = "UICommonItem/clickBtn/ItemIcon"
local extra_path = "UICommonItem/clickBtn/FlagGo"
local item_quality_path = "UICommonItem/clickBtn/ImgQuality"
local item_bg_path = "UICommonItem/clickBtn/item_bg"
local num_txt_path = "UICommonItem/clickBtn/NumText"
local name_text_path = "NameText"
local des_text_path = "layout/DesText"
local buy_btn_path = "BuyBtn"
local buy_btn_name_path = "BuyBtn/BuyBtnName"
local use_btn_path = "UseBtn"
local use_btn_name_path = "UseBtn/UseBtnName"
local cdTime_txt_path = "Txt_CDTime"

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
	self.extra = self:AddComponent(UIText, extra_path)
	self.name_text = self:AddComponent(UIText, name_text_path)
	self.des_text = self:AddComponent(UIText, des_text_path)
	self.buy_btn = self:AddComponent(UIButton, buy_btn_path)
	self.use_btn = self:AddComponent(UIButton, use_btn_path)
	self.use_btn_name = self:AddComponent(UIText, use_btn_name_path)
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
	self.buy_btn_name = self:AddComponent(UIText,buy_btn_name_path)

	self.cdTime_txt = self:AddComponent(UIText,cdTime_txt_path)
end

--控件的销毁
local function ComponentDestroy(self)
	self.icon = nil
	self.extra = nil
	self.name_text = nil
	self.des_text = nil
	self.num_txt = nil
	self.buy_btn = nil
	self.use_btn = nil
	self.use_btn_name = nil
	self.item_quality_img = nil
	self.item_bg = nil
end

--变量的定义
local function DataDefine(self)
	self.param = {}
	self.timer = nil
	self.timer_action = function(temp)
		self:RefreshTime()
	end
end

--变量的销毁
local function DataDestroy(self)
	self.param = nil
	self.timer_action = nil
	self:DeleteTimer()
end

-- 全部刷新
local function ReInit(self,param)
	self.param = param
	UIGray.SetGray(self.use_btn.transform, false, true)
	UIGray.SetGray(self.buy_btn.transform, false, true)
	self.item_quality_img.gameObject:SetActive(true)
	self.item_bg.gameObject:SetActive(true)
	self.cdTime_txt:SetActive(false)
	self.icon.rectTransform:Set_sizeDelta(118, 118)
	self.use_btn:LoadSprite("Assets/Main/Sprites/UI/Common/New/Common_btn_green101")
	self.use_btn_name:SetActive(true)
	self.buy_btn_name:SetActive(true)
	self.extra:SetActive(false)
	self.icon:SetActive(true)
	self.icon:LoadSprite(string.format(LoadPath.ItemPath,param.template.icon))
	self.name_text:SetText(DataCenter.ItemTemplateManager:GetName(param.template.id))
	self.des_text:SetText(DataCenter.ItemTemplateManager:GetDes(param.template.id))
	self.item_quality_img:LoadSprite(DataCenter.ItemTemplateManager:GetToolBgByColor(param.template.color))
	if param.btnType == UIResourceBagBtnType.Use then
		self.num_txt:SetActive(true)
		self.num_txt:SetText(param.count)
		self.buy_btn:SetActive(false)
		self.use_btn:SetActive(true)
		self.use_btn_name:SetLocalText(GameDialogDefine.USE)
	elseif param.btnType == UIResourceBagBtnType.Buy then
		self.num_txt:SetActive(false)
		self.buy_btn:SetActive(true)
		self.use_btn:SetActive(false)
		self.buy_btn_name:SetLocalText(GameDialogDefine.BUY)
		CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.buy_btn.rectTransform)
	end
	
	self:CheckStatus(param)
end

local function CheckStatus(self,param)
	--检查冷却时间
	if param.template.para4 and param.template.para4 ~= "" then
		self.endTime = DataCenter.MasteryManager:GetStatusDict(tonumber(param.template.para4))
		if self.endTime and self.endTime ~= 0 then
			local curTime = UITimeManager:GetInstance():GetServerTime()
			if self.endTime > curTime then
				if self.param.btnType == UIResourceBagBtnType.Use then
					self.use_btn_name:SetActive(false)
				elseif self.param.btnType == UIResourceBagBtnType.Buy then
					self.buy_btn_name:SetActive(false)
				end
				self:RefreshTime()
				self:AddTimer()
				self.cdTime_txt:SetActive(true)
			end
		end
	end
end

local function AddTimer(self)
	if self.timer == nil then
		self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action , self, false,false,false)
	end
	self.timer:Start()
end

--刷新事件
local function RefreshTime(self)
	local curTime = UITimeManager:GetInstance():GetServerTime()
	if self.endTime < curTime then
		self:DeleteTimer()
		self.cdTime_txt:SetActive(false)
		if self.param.btnType == UIResourceBagBtnType.Use then
			self.use_btn_name:SetActive(true)
			UIGray.SetGray(self.use_btn.transform, false, true)
		elseif self.param.btnType == UIResourceBagBtnType.Buy then
			UIGray.SetGray(self.buy_btn.transform, false, true)
			self.buy_btn_name:SetActive(true)
		end
	else
		if self.param.btnType == UIResourceBagBtnType.Use then
			UIGray.SetGray(self.use_btn.transform, true, false)
		elseif self.param.btnType == UIResourceBagBtnType.Buy then
			UIGray.SetGray(self.buy_btn.transform, true, false)
		end
		self.cdTime_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.endTime - curTime))
	end
end

local function DeleteTimer(self)
	if self.timer ~= nil then
		self.timer:Stop()
		self.timer = nil
	end
end

local function OnBuyBtnClick(self)
	--跳转商城
	local packageTb = GiftPackageData.GetGivenPacks(tonumber(self.param.template.id))
	if packageTb and #packageTb > 0 then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIScrollPack, {anim = true}, packageTb[1])
	end
end

local function OnUseBtnClick(self)
	if self.param.callBack ~= nil then
		local isBuy = false
		self.param.callBack(self.param.index,self.param.template,self.use_btn.transform.position,isBuy)
	end
end

local function RefreshOwnCount(self,count)
	self.param.count = count
	self.num_txt:SetText(count)
end

UIItemCell.OnCreate = OnCreate
UIItemCell.OnDestroy = OnDestroy
UIItemCell.OnEnable = OnEnable
UIItemCell.OnDisable = OnDisable
UIItemCell.ComponentDefine = ComponentDefine
UIItemCell.ComponentDestroy = ComponentDestroy
UIItemCell.DataDefine = DataDefine
UIItemCell.DataDestroy = DataDestroy
UIItemCell.ReInit = ReInit
UIItemCell.CheckStatus = CheckStatus
UIItemCell.AddTimer = AddTimer
UIItemCell.RefreshTime = RefreshTime
UIItemCell.DeleteTimer = DeleteTimer
UIItemCell.OnBuyBtnClick = OnBuyBtnClick
UIItemCell.OnUseBtnClick = OnUseBtnClick
UIItemCell.RefreshOwnCount = RefreshOwnCount

return UIItemCell
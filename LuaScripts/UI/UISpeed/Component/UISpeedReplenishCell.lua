--- Created by shimin.
--- DateTime: 2024/1/19 16:05
--- 加速界面一键补充cell

local UISpeedReplenishCell = BaseClass("UISpeedReplenishCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local name_text_path = "name_text"
local des_text_path = "layout/des_text"
local use_btn_path = "use_btn"
local use_btn_text_path = "use_btn/green_btn_name"

function UISpeedReplenishCell:OnCreate()
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
end

function UISpeedReplenishCell:OnDestroy()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

function UISpeedReplenishCell:OnEnable()
	base.OnEnable(self)
end

function UISpeedReplenishCell:OnDisable()
	base.OnDisable(self)
end

function UISpeedReplenishCell:ComponentDefine()
	self.use_btn = self:AddComponent(UIButton, use_btn_path)
	self.use_btn:SetOnClick(function()
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self:OnUseBtnClick()
	end)
	self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
	self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
	self.use_btn_text = self:AddComponent(UITextMeshProUGUIEx, use_btn_text_path)
end

function UISpeedReplenishCell:ComponentDestroy()
end

function UISpeedReplenishCell:DataDefine()
	self.param = {}
	self.visible = true
end

function UISpeedReplenishCell:DataDestroy()
end

function UISpeedReplenishCell:ReInit(param)
	self.param = param
	self:Refresh()
end

function UISpeedReplenishCell:Refresh()
	if self.param.list[1] == nil then
		self.visible = false
		self:SetActive(false)
	else
		local have = false
		for k,v in ipairs(self.param.list) do
			if v.item.count > 0 then
				have = true
				break
			end
		end
		if have then
			self.visible = true
			self:SetActive(true)
			self.name_text:SetLocalText(GameDialogDefine.SPEED_REPLENISH_ALL)
			self.use_btn_text:SetLocalText(GameDialogDefine.SPEED_REPLENISH_ALL)
			self:RefreshTime()
		else
			self.visible = false
			self:SetActive(false)
		end
	end
end

--父类驱动一分钟刷一次（秒为0）
function UISpeedReplenishCell:RefreshTime()
	if self.visible then
		local curTime = UITimeManager:GetInstance():GetServerTime()
		local leftTime = self.param.endTime - curTime
		local list = DataCenter.ItemManager:GetReplenishUseSpeedArr(leftTime, self.param.list)
		local time = 0
		for k,v in ipairs(list) do
			time = time + v.per * v.count
		end
		if leftTime > time then
			--红色
			self.des_text:SetLocalText(GameDialogDefine.USE_ITEM_SPEED_WITH,
					string.format(TextColorStr, TextColorRed, UITimeManager:GetInstance():MilliSecondToFmtString(time)))
		else
			--绿色
			self.des_text:SetLocalText(GameDialogDefine.USE_ITEM_SPEED_WITH,
					string.format(TextColorStr, TextColorGreen, UITimeManager:GetInstance():MilliSecondToFmtString(time)))
		end
	end
end

function UISpeedReplenishCell:OnUseBtnClick()
	UIManager:GetInstance():OpenWindow(UIWindowNames.UISpeedReplenish, NormalBlurPanelAnim, self.param)
end

return UISpeedReplenishCell
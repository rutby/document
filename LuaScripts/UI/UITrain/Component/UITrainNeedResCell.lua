local UITrainNeedResCell = BaseClass("UITrainNeedResCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local this_path = ""
local item_icon_path = "Common_icon_cp"
local num_text_path = "content_ui_new"

-- 创建
function UITrainNeedResCell:OnCreate()
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
end

-- 销毁
function UITrainNeedResCell:OnDestroy()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

-- 显示
function UITrainNeedResCell:OnEnable()
	base.OnEnable(self)
end

-- 隐藏
function UITrainNeedResCell:OnDisable()
	base.OnDisable(self)
end

--控件的定义
function UITrainNeedResCell:ComponentDefine()
	self.item_icon = self:AddComponent(UIImage, item_icon_path)
	self.num_text = self:AddComponent(UITextMeshProUGUIEx, num_text_path)
	self.btn = self:AddComponent(UIButton, this_path)
	self.btn:SetOnClick(function()
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self:OnBtnClick()
	end)
end

--控件的销毁
function UITrainNeedResCell:ComponentDestroy()
end

--变量的定义
function UITrainNeedResCell:DataDefine()
	self.param = {}
end

--变量的销毁
function UITrainNeedResCell:DataDestroy()
	self.param = {}
end

-- 全部刷新
function UITrainNeedResCell:ReInit(param)
	self.param = param
	self:Refresh()
end

function UITrainNeedResCell:Refresh()
	if self.param.visible then
		self:SetActive(true)
		if self.param.cellType == CommonCostNeedType.Resource then
			self.item_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(self.param.resourceType))
		elseif self.param.cellType == CommonCostNeedType.Goods then
			local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.param.itemId)
			if goods ~= nil then
				self.item_icon:LoadSprite(string.format(LoadPath.ItemPath,goods.icon))
			end
		elseif self.param.cellType == CommonCostNeedType.AllianceScienceConsume then
			self.item_icon:LoadSprite(string.format(LoadPath.ItemPath, "allianceResource"))
		end
		if self.param.isRed then
			self.num_text:SetLocalText(GameDialogDefine.SPLIT, string.format(TextColorStr, TextColorRed,
					string.GetFormattedSpecial(self.param.own)), string.GetFormattedSpecial(self.param.count))
			self.btn:SetInteractable(true)
		else
			self.num_text:SetLocalText(GameDialogDefine.SPLIT, string.GetFormattedSpecial(self.param.own),
					string.GetFormattedSpecial(self.param.count))
			self.btn:SetInteractable(false)
		end
	else
		self:SetActive(false)
	end
end

function UITrainNeedResCell:OnBtnClick()
	if self.param.cellType == CommonCostNeedType.Resource then
		local lackTab = {}
		local param = {}
		param.type = ResLackType.Res
		param.id = self.param.resourceType
		param.targetNum = self.param.count
		table.insert(lackTab,param)
		GoToResLack.GoToItemResLackList(lackTab)
	elseif self.param.cellType == CommonCostNeedType.Goods then
		local lackTab = {}
		local param = {}
		param.type = ResLackType.Item
		param.id = self.param.itemId
		param.targetNum = self.param.count
		table.insert(lackTab,param)
		GoToResLack.GoToItemResLackList(lackTab)
	elseif self.param.cellType == CommonCostNeedType.AllianceScienceConsume then
		UIUtil.ShowTipsId(391090)
		--local strLack = Localization:GetString("391090")
		--UIUtil.ShowMessage(strLack, 2, GameDialogDefine.CONFIRM, "110088",function()
		--
		--end, function()
		--	UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceCity, 2)
		--end)
	end
end

return UITrainNeedResCell
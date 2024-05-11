--- Created by shimin.
--- DateTime: 2024/1/19 10:26
--- 加速界面cell

local UISpeedCell = BaseClass("UISpeedCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local icon_path = "UICommonItemSize/clickBtn/ItemIcon"
local item_quality_path = "UICommonItemSize/clickBtn/ImgQuality"
local extra_text_path = "UICommonItemSize/clickBtn/FlagGo/FlagText"
local num_txt_path = "UICommonItemSize/clickBtn/NumText"
local name_text_path = "name_text"
local des_text_path = "layout/des_text"
local use_btn_path = "use_btn"
local use_btn_name_path = "use_btn/blue_btn_name"
local more_btn_go_path = "more_btn_go"

-- 创建
function UISpeedCell:OnCreate()
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
end

-- 销毁
function UISpeedCell:OnDestroy()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

-- 显示
function UISpeedCell:OnEnable()
	base.OnEnable(self)
end

-- 隐藏
function UISpeedCell:OnDisable()
	base.OnDisable(self)
end

--控件的定义
function UISpeedCell:ComponentDefine()
	self.icon = self:AddComponent(UIImage, icon_path)
	self.extra_text = self:AddComponent(UITextMeshProUGUIEx, extra_text_path)
	self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
	self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
	self.use_btn = self:AddComponent(UIButton, use_btn_path)
	self.use_btn:SetOnClick(function()
		self:OnUseBtnClick()
	end)
	self.use_btn_name = self:AddComponent(UITextMeshProUGUIEx, use_btn_name_path)
	self.more_btn_go = self:AddComponent(UIBaseContainer, more_btn_go_path)
	self.item_quality_img = self:AddComponent(UIImage, item_quality_path)
	self.num_txt = self:AddComponent(UITextMeshProUGUIEx,num_txt_path)
end

--控件的销毁
function UISpeedCell:ComponentDestroy()
end

--变量的定义
function UISpeedCell:DataDefine()
	self.param = {}
end

--变量的销毁
function UISpeedCell:DataDestroy()
	self.param = {}
end

-- 全部刷新
function UISpeedCell:ReInit(param)
	self.param = param
	local para1 = GetTableData(DataCenter.ItemTemplateManager:GetTableName(), self.param.itemId,"para1", "")
	local temp = string.split_ss_array(para1, ';')
	if temp[2] ~= nil then
		self.extra_text:SetText(temp[1]..temp[2])
	end
	self.icon:LoadSprite(string.format(LoadPath.ItemPath, GetTableData(DataCenter.ItemTemplateManager:GetTableName(), self.param.itemId,"icon", "")))
	self.name_text:SetText(DataCenter.ItemTemplateManager:GetName(self.param.itemId))
	self.des_text:SetText(DataCenter.ItemTemplateManager:GetDes(self.param.itemId))
	self.item_quality_img:LoadSprite(DataCenter.ItemTemplateManager:GetToolBgByColor(
			GetTableData(DataCenter.ItemTemplateManager:GetTableName(), self.param.itemId,"color", "")))
	self.num_txt:SetText(string.GetFormattedSeperatorNum(self.param.item.count))
	self.use_btn_name:SetLocalText(GameDialogDefine.USE)
end

function UISpeedCell:OnUseBtnClick()
	if self.param.callBack ~= nil then
		self.param.callBack(self)
	end
end

function UISpeedCell:RefreshOwnCount()
	if self.param.item.count > 0 then
		self.num_txt:SetText(string.GetFormattedSeperatorNum(self.param.item.count))
	else
		self:SetActive(false)
	end
end

function UISpeedCell:GetMoreBtnParent()
	return self.more_btn_go.transform
end

return UISpeedCell
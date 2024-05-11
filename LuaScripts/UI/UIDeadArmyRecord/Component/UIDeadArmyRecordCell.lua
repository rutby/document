--- 查看死亡士兵记录界面每一行cell
--- Created by shimin.
--- DateTime: 2023/1/31 21:05
---
local UIDeadArmyRecordCell = BaseClass("UIDeadArmyRecordCell", UIBaseContainer)
local base = UIBaseContainer
local UIDeadArmyRecordIconCell = require "UI.UIDeadArmyRecord.Component.UIDeadArmyRecordIconCell"

local left_text_path = "LeftText"
local right_icon_go_path = "RightIconGo"
local line_go_path = "Common_img_line"
local dead_reason_text_path = "DeadReasonText"

-- 创建
function UIDeadArmyRecordCell:OnCreate()
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
end

-- 销毁
function UIDeadArmyRecordCell:OnDestroy()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

-- 显示
function UIDeadArmyRecordCell:OnEnable()
	base.OnEnable(self)
end

-- 隐藏
function UIDeadArmyRecordCell:OnDisable()
	base.OnDisable(self)
end

--控件的定义
function UIDeadArmyRecordCell:ComponentDefine()
	self.left_text = self:AddComponent(UITextMeshProUGUIEx, left_text_path)
	self.right_icon_go = self:AddComponent(UIBaseContainer, right_icon_go_path)
	self.line_go = self:AddComponent(UIBaseContainer, line_go_path)
	self.dead_reason_text = self:AddComponent(UITextMeshProUGUIEx, dead_reason_text_path)
end

--控件的销毁
function UIDeadArmyRecordCell:ComponentDestroy()
end

--变量的定义
function UIDeadArmyRecordCell:DataDefine()
	self.param = {}
	self.cells = {}
end

--变量的销毁
function UIDeadArmyRecordCell:DataDestroy()
	self.param = {}
	self:ClearCells()
end

-- 全部刷新
function UIDeadArmyRecordCell:ReInit(param)
	self.param = param
	self.left_text:SetText(self.param.leftName)
	self.line_go:SetActive(self.param.showLine)
	self:LoadCells()
	if self.param.deadType == ArmyDeadType.Hospital then
		self.dead_reason_text:SetActive(true)
		self.dead_reason_text:SetLocalText(GameDialogDefine.HOSPITAL_OUT)
	elseif self.param.deadType == ArmyDeadType.Fight then
		self.dead_reason_text:SetActive(true)
		self.dead_reason_text:SetLocalText(GameDialogDefine.FIGHT_DEAD)
	else
		self.dead_reason_text:SetActive(false)
	end
end

function UIDeadArmyRecordCell:LoadCells()
	self:ClearCells()
	for k, v in ipairs(self.param.list) do
		local param = {}
		self.cells[k] = param
		param.armyId = v.armyId
		param.count = v.count
		param.req = self:GameObjectInstantiateAsync(UIAssets.UIDeadArmyRecordIconCell, function(request)
			if request.isError then
				return
			end
			local go = request.gameObject
			go:SetActive(true)
			go.transform:SetParent(self.right_icon_go.transform)
			go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
			go.transform:SetAsLastSibling()
			local nameStr = tostring(NameCount)
			go.name = nameStr
			NameCount = NameCount + 1
			local model = self.right_icon_go:AddComponent(UIDeadArmyRecordIconCell, nameStr)
			model:ReInit(param)
			param.model = model
		end)
	end
end

function UIDeadArmyRecordCell:ClearCells()
	for k,v in pairs(self.cells) do
		if v.req ~= nil then
			v.req:Destroy()
		end
	end
	self.cells = {}
end



return UIDeadArmyRecordCell
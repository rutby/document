--- Created by shimin.
--- DateTime: 2023/11/7 10:36
--- 升级界面家具升级
local UIFurnitureUpgradeFurniture = BaseClass("UIFurnitureUpgradeFurniture", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UIFurnitureUpgradeFurnitureCell = require "UI.UIFurnitureUpgrade.Component.UIFurnitureUpgradeFurnitureCell"
local UIFurnitureUpgradeAttrCell = require "UI.UIFurnitureUpgrade.Component.UIFurnitureUpgradeAttrCell"

local scroll_content_path = "scroll_view/Viewport/Content"
local attr_go_path = "attr_go"
local furniture_icon_path = "furniture_info_go/furniture_bg/furniture_icon"
local furniture_name_text_path = "furniture_info_go/furniture_name_text"
local furniture_des_text_path = "furniture_info_go/furniture_des_text"
local furniture_upgrade_btn_path = "furniture_info_go/furniture_upgrade_btn"
local furniture_upgrade_text_path = "furniture_info_go/furniture_upgrade_btn/GameObject/furniture_upgrade_text"
local furniture_upgrade_cost_text_path = "furniture_info_go/furniture_upgrade_btn/GameObject/furniture_upgrade_cost_text"
local furniture_upgrade_cost_icon_path = "furniture_info_go/furniture_upgrade_btn/GameObject/icon_go/furniture_upgrade_cost_icon"
local select_go_path = "select_go"
local furniture_upgrade_next_text_path = "furniture_info_go/furniture_upgrade_btn/furniture_upgrade_next_text"
local furniture_bg_path = "furniture_info_go/furniture_bg"

local FurnitureBtnState =
{
	Build = 1,
	Upgrade = 2,
	Next = 3,--下一个
}


local ClickEffectTime = 0.1
local DestroyEffectTime = 2
local DestroyCanAffExpEffectTime = 1


local CellSizeType =
{
	Long = Vector2.New(700, 44),
	Short = Vector2.New(345, 44),
}

-- 创建
function UIFurnitureUpgradeFurniture:OnCreate()
	base.OnCreate(self)
	self:DataDefine()
end

-- 销毁
function UIFurnitureUpgradeFurniture:OnDestroy()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

-- 显示
function UIFurnitureUpgradeFurniture:OnEnable()
	base.OnEnable(self)
end

-- 隐藏
function UIFurnitureUpgradeFurniture:OnDisable()
	base.OnDisable(self)
end


--控件的定义
function UIFurnitureUpgradeFurniture:ComponentDefine()
	if not self.initComponent then
		self.initComponent = true
		self.attr_go = self:AddComponent(UIGridLayoutGroup, attr_go_path)
		self.scroll_content = self:AddComponent(UIBaseContainer, scroll_content_path)
		self.furniture_icon = self:AddComponent(UIImage, furniture_icon_path)
		self.furniture_name_text = self:AddComponent(UITextMeshProUGUIEx, furniture_name_text_path)
		self.furniture_des_text = self:AddComponent(UITextMeshProUGUIEx, furniture_des_text_path)
		self.furniture_upgrade_btn = self:AddComponent(UIButton, furniture_upgrade_btn_path)
		self.furniture_upgrade_btn:SetOnClick(function()
			SoundUtil.PlayEffect(SoundAssets.Music_Effect_Upgrade_Furniture_Click)
			self:OnFurnitureUpgradeBtnClick()
		end)
		self.furniture_upgrade_text = self:AddComponent(UITextMeshProUGUIEx, furniture_upgrade_text_path)
		self.furniture_upgrade_cost_text = self:AddComponent(UITextMeshProUGUIEx, furniture_upgrade_cost_text_path)
		self.furniture_upgrade_cost_icon = self:AddComponent(UIImage, furniture_upgrade_cost_icon_path)
		self.select_go = self:AddComponent(UIBaseContainer, select_go_path)
		self.furniture_upgrade_next_text = self:AddComponent(UITextMeshProUGUIEx, furniture_upgrade_next_text_path)
		self.furniture_bg = self:AddComponent(UIBaseContainer, furniture_bg_path)
	end
end

--控件的销毁
function UIFurnitureUpgradeFurniture:ComponentDestroy()
	if self.initComponent then
		self.initComponent = false--是否初始化过控件
		self:ResetSelectGo()
		DataCenter.FurnitureObjectManager:CancelSelectObject()
		DataCenter.FurnitureObjectManager:DestroyOneFakeObj()
	end
end

--变量的定义
function UIFurnitureUpgradeFurniture:DataDefine()
	self.param = {}
	self.list = {}
	self.cells = {}
	self.on_cell_click_callback = function(index) 
		self:OnCellClickCallBack(index)
	end
	self.selectIndex = 1
	self.costParam = nil
	self.state = FurnitureBtnState.Upgrade
	self.isClick = false
	self.attrList = {}
	self.attrCells = {}
	self.enterSelect = false
	self.canShowNext = false--只有点击升级之后才能显示下一个
	self.click_timer = nil
	self.click_timer_callback = function() 
		self:OnClickTimerCallBack()
	end
	self.effectReqList = {}
	self.icon_effect_timer_callback = function() 
		self:OnIconEffectTimerCallBack()
	end
	self.needWaitSelectObj = false
	self.fIndexDict = {} -- Dict<fUuid, index>
	self.isBtnGray = false
	self.canAddExpEffectReqList = {}
	self.can_add_exp_effect_timer_callback = function() 
		self:OnCanAddExpEffectTimerCallBack()
	end
end

--变量的销毁
function UIFurnitureUpgradeFurniture:DataDestroy()
	self:RemoveClickTimer()
	self:RemoveIconEffectTimer()
	self:RemoveCanAddExpEffectTimer()
	self.list = {}
	self.cells = {}
	self.selectIndex = 1
	self.costParam = nil
	self.state = FurnitureBtnState.Upgrade
	self.isClick = false
	self.attrList = {}
	self.attrCells = {}
	self.enterSelect = false
	self.canShowNext = false--只有点击升级之后才能显示下一个
	self.effectReqList = {}
	self.needWaitSelectObj = false
	self.fIndexDict = {} -- Dict<fUuid, index>
	self.isBtnGray = false
end

-- 全部刷新
function UIFurnitureUpgradeFurniture:ReInit(param, enter)
	self:ComponentDefine()
	self.param = param
	self.selectIndex = 1
	self:Refresh()
	self:MoveFurnitureCamera(enter)
end

function UIFurnitureUpgradeFurniture:Refresh()
	self.isClick = false
	self:ShowCells()
	self:RefreshSelect()
	if self.needWaitSelectObj then
		self:RefreshObjEffect()
	end
end

function UIFurnitureUpgradeFurniture:GetDataList()
	self.list = {}
	local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.buildUuid)
	if buildData ~= nil then
		local template = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, buildData.level)
		if template ~= nil then
			local lastTemplate = nil
			if buildData.level > 1 then
				lastTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, buildData.level - 1)
			end
			
			local list = template:GetFurnitureList()
			local furnitureIdCountDict = {}
			for k, v in ipairs(list) do
				if furnitureIdCountDict[v] == nil then
					furnitureIdCountDict[v] = FurnitureIndex
				else
					furnitureIdCountDict[v] = furnitureIdCountDict[v] + 1
				end
				local fIndex = furnitureIdCountDict[v]--第几个fid
				local param = {}
				param.buildUuid = self.param.buildUuid
				param.furnitureId = v
				param.index = k
				param.fIndex = fIndex
				if lastTemplate == nil then
					param.isNew = true
				else
					param.isNew = not lastTemplate:HaveFurniture(v, param.fIndex)
				end
				param.isNew = false
				param.callback = self.on_cell_click_callback
				local data = DataCenter.FurnitureManager:GetFurnitureByBuildUuid(param.buildUuid, param.furnitureId, param.fIndex)
				if data == nil then
					param.lv = 0
				else
					param.lv = data.lv
					local furnitureTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(param.furnitureId, data.lv)
					if furnitureTemplate ~= nil then
						if buildData.level >= furnitureTemplate:GetFurnitureNeedMainLevel() then
							param.canUpgrade = true
						end
					end
				end
				local furnitureInfo = DataCenter.FurnitureManager:GetFurnitureByBuildUuid(self.param.buildUuid, v, fIndex)
				if furnitureInfo then
					self.fIndexDict[furnitureInfo.uuid] = k
				end
				table.insert(self.list, param)
			end
		end
	end
end

function UIFurnitureUpgradeFurniture:OnCellClickCallBack(index)
	if self.selectIndex ~= index then
		local cell = self.cells[self.selectIndex].model
		if cell ~= nil then
			cell:SetUnSelect()
		end
		self.selectIndex = index
		self.canShowNext = false
		self:RefreshSelect()
		self:MoveFurnitureCamera()
	end
end

function UIFurnitureUpgradeFurniture:RefreshSelect()
	self.isBtnGray = false
	local cellParam = self.cells[self.selectIndex]
	if cellParam ~= nil then
		local cell = cellParam.model
		if cell ~= nil then
			cell:SetSelect(self.select_go)
		end
	end
	local param = self.list[self.selectIndex]
	if param ~= nil then
		local level = 0
		local data = DataCenter.FurnitureManager:GetFurnitureByBuildUuid(param.buildUuid, param.furnitureId, param.fIndex)
		if data == nil then
			--建造
			self.state = FurnitureBtnState.Build
			self.furniture_upgrade_btn:SetActive(true)
			UIGray.SetGray(self.furniture_upgrade_btn.transform, false, true)
			self.furniture_upgrade_next_text:SetActive(false)
			self.furniture_upgrade_text:SetActive(true)
			self.furniture_upgrade_cost_text:SetActive(true)
			self.furniture_upgrade_cost_icon:SetActive(true)
			self.furniture_upgrade_text:SetLocalText(GameDialogDefine.BUILD)
			local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(param.furnitureId, 0)
			if levelTemplate ~= nil then
				local cost = levelTemplate:GetNeedResource()
				if cost[1] == nil then
					cost = levelTemplate:GetNeedItem()
				end
				self.costParam = cost[1]
				self:RefreshResourceCount()
			end
		else
			--升级
			self.state = FurnitureBtnState.Upgrade
			level = data.lv
			local desTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(param.furnitureId)
			if desTemplate ~= nil then
				if desTemplate:GetBuildMaxLevel() <= data.lv then
					self.furniture_upgrade_btn:SetActive(false)
				else
					local template = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(param.furnitureId, data.lv)
					if template ~= nil then
						local isGray = false
						local needMainLevel = template:GetFurnitureNeedMainLevel()
						if needMainLevel > 0 then
							local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.buildUuid)
							if buildData ~= nil then
								if buildData.level < needMainLevel then
									local index = self:GetNextCanUpgradeIndex()
									if index ~= 0 then
										if self.canShowNext then
											self.state = FurnitureBtnState.Next
										else
											isGray = true
											self.isBtnGray = true
										end
									else
										isGray = true
										self.isBtnGray = true
									end
								end
							end
						end
						self.furniture_upgrade_btn:SetActive(true)
						if isGray then
							UIGray.SetGray(self.furniture_upgrade_btn.transform, true, true)
						else
							UIGray.SetGray(self.furniture_upgrade_btn.transform, false, true)
						end
						if self.state == FurnitureBtnState.Upgrade then
							self.furniture_upgrade_text:SetLocalText(GameDialogDefine.UPGRADE)
							self.furniture_upgrade_next_text:SetActive(false)
							self.furniture_upgrade_text:SetActive(true)
							self.furniture_upgrade_cost_text:SetActive(true)
							self.furniture_upgrade_cost_icon:SetActive(true)
							local cost = template:GetNeedResource()
							if cost[1] == nil then
								cost = template:GetNeedItem()
							end
							self.costParam = cost[1]
							self:RefreshResourceCount()
						elseif self.state == FurnitureBtnState.Next then
							self.furniture_upgrade_next_text:SetActive(true)
							self.furniture_upgrade_text:SetActive(false)
							self.furniture_upgrade_cost_text:SetActive(false)
							self.furniture_upgrade_cost_icon:SetActive(false)
							self.furniture_upgrade_next_text:SetLocalText(GameDialogDefine.CONTINUE)
						end
					end
				end
			end
		end

		local id = param.furnitureId + level
		self.furniture_name_text:SetLocalText(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), id,"name"))
		self.furniture_des_text:SetLocalText(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), id,"description"))
		self.furniture_icon:LoadSprite(string.format(LoadPath.Furniture, GetTableData(DataCenter.BuildTemplateManager:GetTableName(), id,"pic")))
		self:ShowAttrCells()
	end
end

function UIFurnitureUpgradeFurniture:ResetSelectGo()
	self.select_go:SetActive(false)
	self.select_go.transform:SetParent(self.transform)
end

function UIFurnitureUpgradeFurniture:RefreshResourceCount()
	if self.costParam ~= nil then
		local own = 0
		local useCount = 0
		if self.costParam.resourceType ~= nil then
			self.furniture_upgrade_cost_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(self.costParam.resourceType))
			own = LuaEntry.Resource:GetCntByResType(self.costParam.resourceType)
			useCount = self.costParam.count
		else
			self.furniture_upgrade_cost_icon:LoadSprite(DataCenter.ItemTemplateManager:GetIconPath(self.costParam[1]))
			own = DataCenter.ItemData:GetItemCount(self.costParam[1])
			useCount = self.costParam[2]
		end
		if own >= useCount then
			--绿色
			self.furniture_upgrade_cost_text:SetLocalText(GameDialogDefine.SPLIT, string.GetFormattedStr(own), string.GetFormattedStr(useCount))
		else
			--红色
			self.furniture_upgrade_cost_text:SetLocalText(GameDialogDefine.SPLIT, string.format(TextColorStr, 
					TextBtnColorRed, string.GetFormattedStr(own)), string.GetFormattedStr(useCount))
		end
	end
end

function UIFurnitureUpgradeFurniture:OnFurnitureUpgradeBtnClick()
	if not self.isClick and self.click_timer == nil then
		local param = self.list[self.selectIndex]
		if param ~= nil then
			if self.state == FurnitureBtnState.Next then
				local index = self:GetNextCanUpgradeIndex()
				if index ~= 0 then
					self:OnCellClickCallBack(index)
				end
			else
				local isBuild = false
				local needResource = {}
				local data = DataCenter.FurnitureManager:GetFurnitureByBuildUuid(param.buildUuid, param.furnitureId, param.fIndex)
				if data == nil then
					--建造
					isBuild = true
					local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(param.furnitureId, 0)
					if levelTemplate ~= nil then
						needResource = levelTemplate:GetNeedResource()
						if needResource[1] == nil then
							needResource = levelTemplate:GetNeedItem()
						end
					end
				else
					--升级
					local template = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(param.furnitureId, data.lv)
					if template ~= nil then
						needResource = template:GetNeedResource()
						if needResource[1] == nil then
							needResource = template:GetNeedItem()
						end
						local needMainLevel = template:GetFurnitureNeedMainLevel()
						if needMainLevel > 0 then
							local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.buildUuid)
							if buildData ~= nil then
								if buildData.level < needMainLevel then
									UIUtil.ShowTips(Localization:GetString(GameDialogDefine.NEED_UPGRADE_WITH
									, Localization:GetString(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), buildData.itemId + needMainLevel,"name"))))
									self.view:AddOneUpgradeBtnEffect()
									return
								end
							end
						end
					end
				end
				for _, v in ipairs(needResource) do
					if v.resourceType ~= nil then
						local need = v.count
						local own = LuaEntry.Resource:GetCntByResType(v.resourceType)
						if own < need then
							local lackTab = {}
							local lackParam = {}
							lackParam.type = ResLackType.Res
							lackParam.id = v.resourceType
							lackParam.targetNum = need
							table.insert(lackTab, lackParam)
							UIUtil.ShowTipsId(GameDialogDefine.RESOURCE_ITEM_NOT_ENOUGH)
							GoToResLack.GoToItemResLackList(lackTab)
							return
						end
					else
						local need = v[2]
						local own = DataCenter.ItemData:GetItemCount(v[1])
						if own < need then
							local lackTab = {}
							local lackParam = {}
							lackParam.type = ResLackType.Item
							lackParam.id = v[1]
							lackParam.targetNum = need
							table.insert(lackTab, lackParam)
							UIUtil.ShowTipsId(GameDialogDefine.RESOURCE_ITEM_NOT_ENOUGH)
							GoToResLack.GoToItemResLackList(lackTab)
							return
						end
					end
				end
				
				if self.state == FurnitureBtnState.Build then
					self.isClick = true
					self.canShowNext = true
					SoundUtil.PlayEffect(SoundAssets.Music_Effect_Furniture_Upgrade)
					DataCenter.FurnitureManager:SendUserBuildFurniture(param.buildUuid, param.furnitureId, param.fIndex)
					self:ShowEffect()
				elseif self.state == FurnitureBtnState.Upgrade then
					if data ~= nil then
						self.isClick = true
						self.canShowNext = true
						SoundUtil.PlayEffect(SoundAssets.Music_Effect_Furniture_Upgrade)
						DataCenter.FurnitureManager:SendUserLevelUpFurniture(data.uuid)
						self:ShowEffect()
					end
				end
			end
		end
	end
end


function UIFurnitureUpgradeFurniture:ShowAttrCells()
	self:GetAttrList()
	local count = #self.attrList
	if count > 3 then
		self.attr_go:SetCellSize(CellSizeType.Short)
	else
		self.attr_go:SetCellSize(CellSizeType.Long)
	end
	for k, v in ipairs(self.attrList) do
		if self.attrCells[k] == nil then
			self.attrCells[k] = v
			v.visible = true
			v.req = self:GameObjectInstantiateAsync(UIAssets.UIFurnitureUpgradeAttrCell, function(request)
				if request.isError then
					return
				end
				local go = request.gameObject
				go:SetActive(true)
				go.transform:SetParent(self.attr_go.transform)
				go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
				go.transform:SetAsLastSibling()
				local nameStr = tostring(NameCount)
				go.name = nameStr
				NameCount = NameCount + 1
				local model = self.attr_go:AddComponent(UIFurnitureUpgradeAttrCell, nameStr)
				model:ReInit(self.attrCells[k])
				self.attrCells[k].model = model
			end)
		else
			v.req = self.attrCells[k].req
			v.model = self.attrCells[k].model
			self.attrCells[k] = v
			v.visible = true
			if v.model ~= nil then
				v.model:ReInit(v)
			end
		end
	end
	local cellCount = #self.attrCells
	if cellCount > count then
		for i = count + 1, cellCount, 1 do
			local cell = self.attrCells[i]
			if cell ~= nil then
				cell.visible = false
				if cell.model ~= nil then
					cell.model:Refresh()
				end
			end
		end
	end
end

function UIFurnitureUpgradeFurniture:GetAttrList()
	self.attrList = {}
	local param = self.list[self.selectIndex]
	if param ~= nil then
		local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(param.furnitureId)
		if template ~= nil then
			local nextTemplate = nil
			local curTemplate = nil
			local data = DataCenter.FurnitureManager:GetFurnitureByBuildUuid(param.buildUuid, param.furnitureId, param.fIndex)
			if data == nil then
				nextTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(param.furnitureId, 1)
			elseif template:GetBuildMaxLevel() <= data.lv then
				curTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(param.furnitureId, data.lv)
			else
				nextTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(param.furnitureId, data.lv + 1)
				curTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(param.furnitureId, data.lv)
			end
			local curNums = {}
			if curTemplate ~= nil  then
				curNums = curTemplate.local_num
			end
			local nextNums = {}
			if nextTemplate ~= nil then
				nextNums = nextTemplate.local_num
			end
			local maxCount = #nextNums
			if maxCount == 0 then
				maxCount = #curNums
			end
			local diaCount = #template.effect_local
			if maxCount > diaCount then
				maxCount = diaCount
			end
			if maxCount > 0 then
				local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(param.furnitureId, 0)
				for i = 1, maxCount, 1 do
					local showParam = template:GetShowLocalEffect(i)
					if showParam ~= nil then
						local listParam = {}
						--这里特殊显示 全部写死
						listParam.name = Localization:GetString(showParam[1])
						local needAdd = true
						if showParam[2] == EffectLocalType.Dialog then
							local val = ""
							if nextNums[i] ~= nil then
								val = DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(nextNums[i], showParam[2])
							else
								val = DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(curNums[i], showParam[2])
							end
							if val == nil or val == "" then
								needAdd = false
							end
							listParam.curValue = ""
							listParam.addValue = val
						else
							local cur = curNums[i] or 0
							listParam.curValue = DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(cur, showParam[2])
							if curNums[i] == nextNums[i] then
								listParam.addValue = ""
							else
								if nextNums[i] ~= nil then
									local add = Mathf.Round((tonumber(nextNums[i]) - tonumber(cur)) * 100) / 100 
									if add >= 0 then
										listParam.addValue = "+ " .. DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(add, showParam[2])
									else
										listParam.addValue = "- " .. DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(-add, showParam[2])
									end
								end
							end
						end
						local effectId = 0
						if nextTemplate ~= nil then
							for k,v in pairs(nextTemplate.building_effect) do
								effectId = k
								break
							end
							for k,v in pairs(nextTemplate.only_room_effect) do
								effectId = k
								break
							end
						elseif curTemplate ~= nil then
							for k,v in pairs(curTemplate.building_effect) do
								effectId = k
								break
							end
							for k,v in pairs(curTemplate.only_room_effect) do
								effectId = k
								break
							end
						end
						
						
						if needAdd then
							table.insert(self.attrList, listParam)
						end
						local attrParam = DataCenter.FurnitureManager:GetAttrParam(showParam[1], levelTemplate.para1, effectId, levelTemplate.para4)
						if attrParam ~= nil and attrParam.name ~= nil then
							listParam.clickName = attrParam.name
							listParam.clickDes = attrParam.des
							listParam.icon = attrParam.icon
							listParam.special = attrParam.special
							if attrParam.special == FurnitureSpecialType.Dining then
								local listParam2 = {}
								listParam2.name = Localization:GetString(GameDialogDefine.FOOD_COST)

								local config = DataCenter.VitaManager:GetCurSelectFoodParam()
								if config ~= nil then
									local own = LuaEntry.Resource:GetCntByResType(ResourceType.Food)
									listParam2.curValue = Localization:GetString(GameDialogDefine.SPLIT, string.GetFormattedStr(own), config.foodCost)
								end

								listParam2.addValue = ""
								listParam2.clickName = Localization:GetString(GameDialogDefine.FOOD_VALUE)
								listParam2.clickDes = Localization:GetString(GameDialogDefine.FOOD_VALUE_DES)
								listParam2.icon = string.format(LoadPath.CommonPath, "UIRes_icon_meat")
								table.insert(self.attrList, listParam2)

								local listParam3 = {}
								listParam3.name = Localization:GetString(FurnitureAttrDialogType.Attr)
								if config ~= nil then
									listParam3.curValue = config.addHunger
								end
								listParam3.addValue = ""
								listParam3.clickName = Localization:GetString(GameDialogDefine.HEALTH_VALUE)
								listParam3.clickDes = Localization:GetString(GameDialogDefine.HEALTH_VALUE_DES)
								listParam3.icon = string.format(LoadPath.UIVita, "survivor_icon_healthy06")
								table.insert(self.attrList, listParam3)
							else
								if param.furnitureId == 541000 then
									if i == 1 then
										listParam.name = Localization:GetString(GameDialogDefine.CURE_VALUE)
										listParam.clickName = Localization:GetString(GameDialogDefine.CURE_VALUE)
										listParam.clickDes = Localization:GetString(GameDialogDefine.CURE_VALUE_DES)
										listParam.icon = string.format(LoadPath.UIMain, "icon_sceneView_hospital")
									elseif i == 3 then
										listParam.name = Localization:GetString(GameDialogDefine.HEALTH_VALUE)
										listParam.clickName = Localization:GetString(GameDialogDefine.HEALTH_VALUE)
										listParam.clickDes = Localization:GetString(GameDialogDefine.HEALTH_VALUE_DES)
										listParam.icon = string.format(LoadPath.UIVita, "UItemperature_icon_healthy")
									end
								end

								if showParam[1] == FurnitureAttrDialogType.Product then
									if data ~= nil then
										listParam.fUuid = data.uuid
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

function UIFurnitureUpgradeFurniture:UpdateResourceSignal()
	self:RefreshResourceCount()
end

function UIFurnitureUpgradeFurniture:RefreshItemsSignal()
	self:RefreshResourceCount()
end

function UIFurnitureUpgradeFurniture:RefreshFurnitureSignal()
	self:Refresh()
end

function UIFurnitureUpgradeFurniture:MoveFurnitureCamera(enter)
	self:RefreshObjEffect()
	local param = self.list[self.selectIndex]
	if param ~= nil then
		local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.buildUuid)
		if buildData ~= nil then
			local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildData.itemId)
			if template ~= nil then
				local centerPos = template:GetPosition()
				local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, 0)
				local index = levelTemplate:GetFurnitureModelIndex(param.furnitureId, param.fIndex)
				local willPos = DataCenter.FurnitureObjectManager:GetWorldPositionByBuildUuidAndIndex(self.param.buildUuid, index)
				local camParam = DataCenter.FurnitureManager:GetCameraParamByTiles(willPos, 0)
				if camParam ~= nil then
					CS.SceneManager.World:SetCameraMinHeight(camParam.zoom)
					local time = camParam.time
					if enter then
						time = camParam.time
						self.view:AddEnterTimer(time * BuildAutoMoveEnterTime)
					else
						time = BuildEnterTime
					end
					local pos = Vector3.New((willPos.x - centerPos.x) * camParam.delta + centerPos.x, 0,
							(willPos.z - centerPos.z) * camParam.delta + centerPos.z + camParam.constDeltaPosY)
					GoToUtil.GotoCityPos(pos, camParam.zoom, time)
				end
			end
		end
	end
end
function UIFurnitureUpgradeFurniture:GetUpgradeBtnPosition()
	self:ComponentDefine()
	return self.furniture_upgrade_btn:GetPosition()
end

function UIFurnitureUpgradeFurniture:GetNextCanUpgradeIndex()
	local curIndex = self.selectIndex
	local allCount = #self.list
	if allCount > 1 then
		local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.buildUuid)
		if buildData ~= nil then
			for i = 1, allCount - 1, 1 do
				local index = curIndex + i
				if index > allCount then
					index = index - allCount
				end
				local param = self.list[index]
				if param ~= nil then
					local desTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(param.furnitureId)
					if desTemplate ~= nil and desTemplate:GetBuildMaxLevel() > param.lv then
						if param.lv == 0 then
							return index
						end
						local template = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(param.furnitureId, param.lv)
						if template ~= nil then
							local needMainLevel = template:GetFurnitureNeedMainLevel()
							if needMainLevel > 0 then
								if buildData.level >= needMainLevel then
									return index
								end
							else
								return index
							end
						end
					end
				end
			end
		end
	end
	return 0
end

function UIFurnitureUpgradeFurniture:SetEnterIndex()
	if (not self.enterSelect) then
		self.enterSelect = true
		local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.buildUuid)
		local index = nil
		if self.param.fUuid ~= nil then
			index = self.fIndexDict[self.param.fUuid]
		end
		if index ~= nil then
			self.selectIndex = index
		elseif self.param.furnitureId ~= nil then
			local furnitureIndex = self.param.furnitureIndex or 1
			local curIndex = 0
			for k,v in ipairs(self.list) do
				if v.furnitureId == self.param.furnitureId then
					curIndex = curIndex + 1
					if furnitureIndex == curIndex then
						local desTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(v.furnitureId)
						if desTemplate ~= nil and desTemplate:GetBuildMaxLevel() > v.lv then
							local template = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(v.furnitureId, v.lv)
							if template ~= nil then
								local needMainLevel = template:GetFurnitureNeedMainLevel()
								if needMainLevel > 0 then
									if buildData.level >= needMainLevel then
										self.selectIndex = k
										break
									end
								else
									self.selectIndex = k
									break
								end
							end
						end
					end
				end
			end
		else
			if buildData ~= nil then
				for k, v in ipairs(self.list) do
					local desTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(v.furnitureId)
					if desTemplate ~= nil and desTemplate:GetBuildMaxLevel() > v.lv then
						if v.lv == 0 then
							self.selectIndex = k
							break
						end
						local template = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(v.furnitureId, v.lv)
						if template ~= nil then
							local needMainLevel = template:GetFurnitureNeedMainLevel()
							if needMainLevel > 0 then
								if buildData.level >= needMainLevel then
									self.selectIndex = k
									break
								end
							else
								self.selectIndex = k
								break
							end
						end
					end
				end
			end
		end
	end
end


function UIFurnitureUpgradeFurniture:AddClickTimer()
	if self.click_timer == nil then
		self.click_timer = TimerManager:GetInstance():GetTimer(ClickEffectTime, self.click_timer_callback, self, true, false, false)
		self.click_timer:Start()
	end
end

function UIFurnitureUpgradeFurniture:RemoveClickTimer()
	if self.click_timer ~= nil then
		self.click_timer:Stop()
		self.click_timer = nil
	end
end

function UIFurnitureUpgradeFurniture:OnClickTimerCallBack()
	self:RemoveClickTimer()
end

function UIFurnitureUpgradeFurniture:AddOneIconEffect()
	self:OnIconEffectTimerCallBack()
	local req = self:GameObjectInstantiateAsync(UIAssets.UIFurnitureUpgradeIconEffect, function(request)
		if request.isError then
			return
		end
		local go = request.gameObject
		go:SetActive(true)
		go.transform:SetParent(self.furniture_bg.transform)
		go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
		go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
	end)
	table.insert(self.effectReqList, req)
	self:AddIconEffectTimer()
end


function UIFurnitureUpgradeFurniture:AddIconEffectTimer()
	if self.icon_effect_timer == nil then
		self.icon_effect_timer = TimerManager:GetInstance():GetTimer(DestroyEffectTime, self.icon_effect_timer_callback, self, true, false, false)
		self.icon_effect_timer:Start()
	end
end

function UIFurnitureUpgradeFurniture:RemoveIconEffectTimer()
	if self.icon_effect_timer ~= nil then
		self.icon_effect_timer:Stop()
		self.icon_effect_timer = nil
	end
end

function UIFurnitureUpgradeFurniture:OnIconEffectTimerCallBack()
	self:RemoveIconEffectTimer()
	if self.effectReqList[1] ~= nil then
		local req = table.remove(self.effectReqList, 1)
		if req ~= nil then
			req:Destroy()
		end
	end
end

function UIFurnitureUpgradeFurniture:ShowEffect()
	self:AddClickTimer()
	local baseFurnitureTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.list[self.selectIndex].furnitureId, 1)
	if baseFurnitureTemplate ~= nil then
		if baseFurnitureTemplate.building_exp ~= 0 then
			self.view:ShowEffect(self.cells[self.selectIndex].model:GetIconPosition())
		end
	end
	self:AddOneIconEffect()
end

function UIFurnitureUpgradeFurniture:ShowCells()
	self:GetDataList()
	self:SetEnterIndex()
	local count = #self.list
	for k,v in ipairs(self.list) do
		if self.cells[k] == nil then
			local param = {}
			self.cells[k] = param
			param.visible = true
			param.param = v
			param.req = self:GameObjectInstantiateAsync(UIAssets.UIFurnitureUpgradeFurnitureCell, function(request)
				if request.isError then
					return
				end
				local go = request.gameObject
				go:SetActive(true)
				go.transform:SetParent(self.scroll_content.transform)
				go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
				go.transform:SetAsLastSibling()
				local nameStr = tostring(k)
				go.name = nameStr
				local model = self.scroll_content:AddComponent(UIFurnitureUpgradeFurnitureCell, nameStr)
				model:ReInit(param)
				param.model = model
				if self.selectIndex == k then
					model:SetSelect(self.select_go)
					self:RefreshSelect()
				end
			end)
		else
			self.cells[k].visible = true
			self.cells[k].param = v
			if self.cells[k].model ~= nil then
				self.cells[k].model:Refresh()
			end
		end
	end
	local cellCount = #self.cells
	if cellCount > count then
		for i = count + 1, cellCount, 1 do
			local cell = self.cells[i]
			if cell ~= nil then
				cell.visible = false
				if cell.model ~= nil then
					cell.model:Refresh()
				end
			end
		end
	end
end

function UIFurnitureUpgradeFurniture:VitaDataUpdateSignal()
	self:ShowAttrCells()
end

function UIFurnitureUpgradeFurniture:RefreshObjEffect()
	local param = self.list[self.selectIndex]
	if param ~= nil then
		local data = DataCenter.FurnitureManager:GetFurnitureByBuildUuid(param.buildUuid, param.furnitureId, param.fIndex)
		if data == nil then
			self.needWaitSelectObj = true
			DataCenter.FurnitureObjectManager:CancelSelectObject()
			--待建造模型
			DataCenter.FurnitureObjectManager:AddOneFakeObj(param.buildUuid, param.furnitureId, param.fIndex)
		else
			self.needWaitSelectObj = false
			--闪动效果
			DataCenter.FurnitureObjectManager:SelectObject(data.uuid)
			DataCenter.FurnitureObjectManager:DestroyOneFakeObj()
		end
	end
end

function UIFurnitureUpgradeFurniture:AddCanAddExpEffect()
	--本次升级的家具显示特效（building_exp不为空并且当前可升级）
	self:OnCanAddExpEffectTimerCallBack()
	local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.buildUuid)
	if buildData ~= nil then
		for k,v in pairs(self.cells) do
			if v.model ~= nil then
				local baseFurnitureTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(v.param.furnitureId, 1)
				local furnitureTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(v.param.furnitureId, v.param.lv)
				if baseFurnitureTemplate ~= nil and furnitureTemplate ~= nil then
					if baseFurnitureTemplate.building_exp ~= 0 and buildData.level >= furnitureTemplate:GetFurnitureNeedMainLevel() then
						local req = self:GameObjectInstantiateAsync(UIAssets.UIFurnitureCanAddExpEffect, function(request)
							if request.isError then
								return
							end
							local go = request.gameObject
							go:SetActive(true)
							go.transform:SetParent(v.model.transform)
							go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
							go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
						end)
						table.insert(self.canAddExpEffectReqList, req)
					end
				end
			end
		end
	end
	
	self:AddCanAddExpEffectTimer()
end

function UIFurnitureUpgradeFurniture:AddCanAddExpEffectTimer()
	if self.can_add_exp_effect_timer == nil then
		self.can_add_exp_effect_timer = TimerManager:GetInstance():GetTimer(DestroyCanAffExpEffectTime, self.can_add_exp_effect_timer_callback, self, true, false, false)
		self.can_add_exp_effect_timer:Start()
	end
end

function UIFurnitureUpgradeFurniture:RemoveCanAddExpEffectTimer()
	if self.can_add_exp_effect_timer ~= nil then
		self.can_add_exp_effect_timer:Stop()
		self.can_add_exp_effect_timer = nil
	end
end

function UIFurnitureUpgradeFurniture:OnCanAddExpEffectTimerCallBack()
	self:RemoveCanAddExpEffectTimer()
	if self.canAddExpEffectReqList[1] ~= nil then
		for k,v in ipairs(self.canAddExpEffectReqList) do
			v:Destroy()
		end
		self.canAddExpEffectReqList = {}
	end
end

function UIFurnitureUpgradeFurniture:RefreshFurnitureProductSignal(fUuid)
	if self.fIndexDict[fUuid] == self.selectIndex then
		for k,v in ipairs(self.attrCells) do
			if v.model ~= nil then
				v.model:RefreshTime()
			end
		end
	end
end

return UIFurnitureUpgradeFurniture
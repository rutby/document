---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl
--- DateTime: 2023/4/23 17:35
---

local UIMasteryPage = BaseClass("UIMasteryPage", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local MasteryPage = require "UI.UIMastery.Component.MasteryPage"

function UIMasteryPage:OnCreate()
	base.OnCreate(self)
	self:DataDefine()
	self:ComponentDefine()
end

function UIMasteryPage:OnDestroy()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

function UIMasteryPage:ComponentDefine()

	self._masteryIconBg_rect = self:AddComponent(UIBaseContainer,"Rect_MasteryIconBg")
	self._masteryIcon_rect = self:AddComponent(UIBaseContainer,"Rect_MasteryIcon")

	self.info_btn = self:AddComponent(UIButton, "")
	self.info_btn:SetOnClick(function()
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self:OnInfoClick()
	end)

	self._page_txt = self:AddComponent(UIText,"Txt_Page")
	self._page_txt:SetLocalText(111034)

	self.Arrow_rect = self:AddComponent(UIBaseContainer,"Rect_MasteryArrow")
	self.Arrow2_rect = self:AddComponent(UIBaseContainer,"Rect_MasteryArrow2")
	self._masteryPage_rect = self:AddComponent(UIBaseContainer,"Rect_MasteryPage")


	self._change_btn = self:AddComponent(UIButton,"Rect_MasteryPage/Btn_Change")
	self._change_txt = self:AddComponent(UIText,"Rect_MasteryPage/Btn_Change/Btn_ChangeText")
	self._change_txt:SetLocalText(111035)
	self._change_btn:SetOnClick(function()
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self:OnChangeClick()
	end)
	self._change_btn:SetActive(false)
end

function UIMasteryPage:ComponentDestroy()
	self.level_text = nil
	self.info_btn = nil
	self.slider = nil
	self.exp_text = nil
	self.add_text = nil
end

function UIMasteryPage:DataDefine()
	self.lastMaxPage = 0
end

function UIMasteryPage:DataDestroy()

end

function UIMasteryPage:OnEnable()
	base.OnEnable(self)
end

function UIMasteryPage:OnDisable()
	base.OnDisable(self)
end

function UIMasteryPage:OnAddListener()
	base.OnAddListener(self)
end

function UIMasteryPage:OnRemoveListener()
	base.OnRemoveListener(self)
end

function UIMasteryPage:Refresh(refreshType)
	local maxPage = DataCenter.MasteryManager:GetMasteryMaxPage()

	if not refreshType or refreshType ~= 1 then
		local tempPlanIndex =  DataCenter.MasteryManager:GetTempPlanIndex()
		if tempPlanIndex and tempPlanIndex == 0  then
			self._change_btn:SetActive(false)
		else
			self.pageView = false
			self:OnInfoClick()
		end
	end

	--礼包在说明没解锁
	local packs = GiftPackManager.get("230509001")
	if packs  then --and packs:isBought() and packs:isTimeValid()
		self.packs = packs
		maxPage = maxPage + 1
	else
		self.packs = nil
	end

	if self.lastMaxPage ~= maxPage then
		self.lastMaxPage = maxPage
		self:SetAllNeedCellDestroy()
		for i = 1 ,maxPage do
			--复制基础prefab，每次循环创建一次
			self.rewardModels[i] = self:GameObjectInstantiateAsync(UIAssets.UIMasteryPageCell, function(request)
				if request.isError then
					return
				end
				local go = request.gameObject;
				go.gameObject:SetActive(true)
				go.transform:SetParent(self._masteryPage_rect.transform)
				go.transform.localScale = Vector3.New(1, 1, 1)
				local nameStr = "pageCell_"..i
				go.name = nameStr
				local cell = self._masteryPage_rect:AddComponent(MasteryPage,nameStr)
				local isPack = (i == maxPage) and packs
				cell:Refresh(i,function(index) self:CellsCallBack(index)  end,isPack)
				self.cells[i] = cell
			end)
		end
	else
		self:RefreshView()
	end
end

function UIMasteryPage:RefreshView()
	if self.cells then
		for i = 1 ,table.count(self.cells) do
			local isPack = (i == table.count(self.cells)) and self.packs
			self.cells[i]:RefreshView(i,isPack)
		end
	end
end

function UIMasteryPage:UpdateLv()
	local packs = GiftPackManager.get("230509001")
	if packs  then --and packs:isBought() and packs:isTimeValid()
		self.packs = packs
	else
		self.packs = nil
	end
	if self.cells then
		for i = 1 ,table.count(self.cells) do
			local isPack = (i == table.count(self.cells)) and self.packs
			self.cells[i]:UpdateLv(i,isPack)
		end
	end
end

function UIMasteryPage:SetAllNeedCellDestroy()
	self._masteryPage_rect:RemoveComponents(MasteryPage)
	if self.rewardModels~=nil then
		for k,v in pairs(self.rewardModels) do
			if v ~= nil then
				self:GameObjectDestroy(v)
			end
		end
	end
	self.rewardModels = {}
	self.cells = {}
end

--选中页签回调
function UIMasteryPage:CellsCallBack(index)
	DataCenter.MasteryManager:SetMasteryTempPage(index)
	for i = 1 ,table.count(self.cells) do
		self.cells[i]:RefreshSetTempPage(i)
	end
	local curPlanIndex =  DataCenter.MasteryManager:GetCurPlanIndex()
	if index == curPlanIndex then
		self._change_btn:SetActive(false)
	else
		self._change_btn:SetActive(true)
	end
	EventManager:GetInstance():Broadcast(EventId.MasteryChangePlan,1)
end

--展开天赋页
function UIMasteryPage:OnInfoClick()
	self._masteryPage_rect:SetActive(not self.pageView)
	self.Arrow2_rect:SetActive(not self.pageView)
	self.Arrow_rect:SetActive(self.pageView)
	self._masteryIconBg_rect:SetActive(self.pageView)
	self._masteryIcon_rect:SetActive(self.pageView)
	if self.pageView then
		self.pageView = false
	else
		self.pageView = true
	end
end

function UIMasteryPage:OnHide()
	self.pageView = true
	self._masteryPage_rect:SetActive(not self.pageView)
	self.Arrow2_rect:SetActive(not self.pageView)
	self.Arrow_rect:SetActive(self.pageView)
	self._masteryIconBg_rect:SetActive(self.pageView)
	self._masteryIcon_rect:SetActive(self.pageView)
	if self.pageView then
		self.pageView = false
	else
		self.pageView = true
	end
end

--确定切换页
function UIMasteryPage:OnChangeClick()
	--先检查当前页是否使用过点数
	local data = DataCenter.MasteryManager:GetPlan(DataCenter.MasteryManager:GetCurPlanIndex())
	local num = data:GetUsePoint()
	if num == 0 then
		local index = DataCenter.MasteryManager:GetTempPlanIndex()
		DataCenter.MasteryManager:SendChangePlan(index)
		return
	end
	local buyItems,itemss = DataCenter.ItemData:GetMasteryPointItem()
	local items = table.mergeArray(buyItems,itemss)
	table.sort(items,function(a,b)
		local aId = a.itemId and a.itemId or a.id
		local bId = b.itemId and b.itemId or b.id
		if tonumber(aId) < tonumber(bId) then
			return true
		end
		return false
	end)
	local itemId = nil
	local count = 0
	for i = 1 ,table.count(items) do
		local isItem = true
		local template = nil
		itemId = items[i].itemId
		if items[i].count then
			count = items[i].count
			template = DataCenter.ItemTemplateManager:GetItemTemplate(items[i].itemId)
		else
			template = DataCenter.ItemTemplateManager:GetItemTemplate(items[i].id)
		end
		if template then
			--检查道具是否有冷却期
			if template.para4 and template.para4 ~= "" then
				local endTime = DataCenter.MasteryManager:GetStatusDict(tonumber(template.para4))
				if endTime and endTime ~= 0 then
					local curTime = UITimeManager:GetInstance():GetServerTime()
					if endTime > curTime then
						itemId = nil
						isItem = false
					end
				end
			else
				if not items[i].count then
					local packageTb = GiftPackageData.GetGivenPacks(tonumber(template.id))
					if not packageTb or #packageTb < 1 then
						itemId = nil
						isItem = false
					end
				end
			end
		end
		if isItem then
			if itemId ~= nil and count ~= 0 and items[i].count then
				break
			end
			itemId = items[i].id and items[i].id or items[i].itemId
			count = items[i].count and items[i].count or 0
			break
		end
	end
	if itemId and count > 0 then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIMasteryChange, itemId,count)
	else
		if itemId then
			local packageTb = GiftPackageData.GetGivenPacks(tonumber(itemId))
			if packageTb and #packageTb > 0 then
				UIManager:GetInstance():OpenWindow(UIWindowNames.UIScrollPack, {anim = true}, packageTb[1])
			else
				UIUtil.ShowTipsId(120021)
			end
		else
			UIUtil.ShowTipsId(120021)
		end
	end
end

function UIMasteryPage:UpdateName()
	for i = 1 ,table.count(self.cells) do
		self.cells[i]:UpdateName(i)
	end
end

function UIMasteryPage:OnAddClick()
	local data = DataCenter.MasteryManager:GetData()
	GoToResLack.GotoMasteryPoint(data.needExp,1)
end

return UIMasteryPage
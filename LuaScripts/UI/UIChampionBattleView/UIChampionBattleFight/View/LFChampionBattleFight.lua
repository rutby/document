
local LFChampionBattleFight = BaseClass("LFChampionBattleFight", UIBaseView)
local base = UIBaseView
local ChampionBattleFightItem = require "UI.UIChampionBattleView.UIChampionBattleFight.Component.ChampionBattleFightItem"

local close_btn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local title_path = "UICommonPopUpTitle/bg_mid/titleText"
local maskBgBtn_path = "UICommonPopUpTitle/panel"
local scroll_path = "bg/CellList"

local function OnCreate(self)
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
	self:RefreshView()
end

local function OnDestroy(self)
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

local function ComponentDefine(self)
	self.close_btn = self:AddComponent(UIButton, close_btn_path)
	self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
	self.maskBgBtn = self:AddComponent(UIButton, maskBgBtn_path)
	self.title:SetLocalText(302028)
	self.close_btn:SetOnClick(function()
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self.ctrl:CloseSelf()
	end)
	self.maskBgBtn:SetOnClick(function()
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self.ctrl:CloseSelf()
	end)
	self.scroll_view = self:AddComponent(UIScrollView, scroll_path)

	self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
		self:OnResourceItemMoveIn(itemObj, index)
	end)
	self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
		self:OnResourceItemMoveOut(itemObj, index)
	end)
end

local function DataDefine(self)
	
end

local function DataDestroy(self)
	
end

local function ComponentDestroy(self)
	self.close_btn = nil
	self.title = nil
	self.maskBgBtn = nil
	self.scroll_view = nil
end

local function SetAllCellsDestroy(self)
	self:ClearScroll()
end

local function RefreshView(self)
	self:ClearScroll()

	self.reportData = DataCenter.ActChampionBattleManager:GetChampionBattleReportList()
	if self.reportData == nil then
		return
	end
	local count = self.reportData:GetBattleReportCount();
	if count == 0 then
		return
	end
	self.scroll_view:SetTotalCount(count)
	self.scroll_view:RefillCells()
end

local function ClearScroll(self)
	self.cells = {}
	self.scroll_view:ClearCells()
	self.scroll_view:RemoveComponents(ChampionBattleFightItem)
end

local function OnResourceItemMoveIn(self, itemObj, index)
	itemObj.name = tostring(index)
	local cellItem = self.scroll_view:AddComponent(ChampionBattleFightItem, itemObj)

	--local param = self.items[index]
	--local param = UIItemCell.Param.New()
	--param.count =  self.items[index].item.count
	--param.template = self.items[index].template
	--param.addNum = self.items[index].addNum
	--param.id = tostring(self.items[index].id)
	--param.callBack = function(index) self:CellsCallBack(index) end
	--param.index = index
	--cellItem:ReInit(param)
	cellItem:SetData(self.reportData.fightResult[index], self.reportData.fightersInfo);
end

local function OnResourceItemMoveOut(self, itemObj, index)
	self.scroll_view:RemoveComponent(itemObj.name, ChampionBattleFightItem)
end
--------------------------------------------------
LFChampionBattleFight.OnCreate = OnCreate
LFChampionBattleFight.OnDestroy = OnDestroy
LFChampionBattleFight.ComponentDefine = ComponentDefine
LFChampionBattleFight.ComponentDestroy = ComponentDestroy
LFChampionBattleFight.DataDefine = DataDefine
LFChampionBattleFight.DataDestroy = DataDestroy

LFChampionBattleFight.OnDestroy = OnDestroy
LFChampionBattleFight.OnResourceItemMoveIn = OnResourceItemMoveIn
LFChampionBattleFight.OnResourceItemMoveOut = OnResourceItemMoveOut
LFChampionBattleFight.ClearScroll = ClearScroll
LFChampionBattleFight.SetAllCellsDestroy = SetAllCellsDestroy
LFChampionBattleFight.RefreshView = RefreshView

return LFChampionBattleFight
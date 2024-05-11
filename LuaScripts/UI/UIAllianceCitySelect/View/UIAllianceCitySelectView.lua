--- Created by shimin.
--- DateTime: 2020/8/17 15:18
--- UIAllianceCitySelectView.lua

local UIAllianceCitySelectView = BaseClass("UIAllianceCitySelectView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local AllianceCitySelectItem = require "UI.UIAllianceCitySelect.Component.AllianceCitySelectItem"

local title_path = "UICommonMidPopUpTitle/bg_mid/titleText"
local closeBtn_path = "UICommonMidPopUpTitle/bg_mid/CloseBtn"
local bgBtn_path = "UICommonMidPopUpTitle/panel"
local tip_path = "offset/cities/Top/desc"
local scrollRect_path = "offset/cities/ScrollView"
local content_path = "offset/cities/ScrollView/Content"

--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
    self:InitData()
end

-- 销毁
local function OnDestroy(self)
    self:ClearItemCell()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.titleN = self:AddComponent(UITextMeshProUGUIEx, title_path)
    self.titleN:SetLocalText(390876)
    self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
    self.closeBtnN:SetOnClick(function()
        self:OnClickCloseBtn()
    end)
    self.bgBtnN = self:AddComponent(UIButton, bgBtn_path)
    self.bgBtnN:SetOnClick(function()
        self:OnClickCloseBtn()
    end)
    self.tipN = self:AddComponent(UIText, tip_path)
    self.scrollRectN = self:AddComponent(UIBaseContainer, scrollRect_path)
    self.contentN = self:AddComponent(GridInfinityScrollView, content_path)
    local bindFunc1 = BindCallback(self, self.OnInitScroll)
    local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
    local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
    self.contentN:Init(bindFunc1,bindFunc2, bindFunc3)
end

local function ComponentDestroy(self)
    self.titleN = nil
    self.closeBtnN = nil
    self.bgBtnN = nil
    self.tipN = nil
    self.scrollRectN = nil
    self.contentN = nil
end


local function DataDefine(self)
    self.allianceMineId = nil
    self.cityItems = {}
    self.allianceCityList = {}
end

local function DataDestroy(self)
    self.allianceMineId = nil
    self.cityItems = nil
    self.allianceCityList = nil
end

--local function OnEnable(self)
--    base.OnEnable(self)
--end
--
--local function OnDisable(self)
--    base.OnDisable(self)
--end

--local function OnAddListener(self)
--    base.OnAddListener(self)
--    self:AddUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
--end
--
--local function OnRemoveListener(self)
--    base.OnRemoveListener(self)
--    self:RemoveUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
--end

local function InitData(self)
    self.allianceMineId = self:GetUserData()
    if not self.allianceMineId then
        return
    end
    self:RefreshAll()
end

local function RefreshAll(self)
    local mineTemplate = DataCenter.AllianceMineManager:GetAllianceMineTemplate(self.allianceMineId)
    self.tipN:SetText(Localization:GetString(300773, Localization:GetString(mineTemplate.name)))
    
    self.allianceCityList = DataCenter.WorldAllianceCityDataManager:GetCitiesByAlId(LuaEntry.Player.allianceId)
    self.contentN:SetItemCount(#self.allianceCityList)
end

local function OnInitScroll(self,go,index)
    local item = self.scrollRectN:AddComponent(AllianceCitySelectItem, go)
    self.cityItems[go] = item
end

local function OnUpdateScroll(self,go,index)
    index = index + 1
    local cityId = self.allianceCityList[index]
    go.name = cityId
    local cellItem = self.cityItems[go]
    if not cellItem then
        return
    end
    cellItem:SetItem(cityId)
end

local function OnDestroyScrollItem(self,go, index)

end

local function ClearItemCell(self)
    self.scrollRectN:RemoveComponents(AllianceCitySelectItem)
    self.contentN:DestroyChildNode()
end


local function OnClickCloseBtn(self)
    self.ctrl:CloseSelf()
end

local function OnSelectRuin(self, cityId)
    local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId)
    local pointId = SceneUtils.TilePosToIndex(cityTemplate.pos, ForceChangeScene.World)
    local mineId = self.allianceMineId
    GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World),nil,0.02,function()
        --CS.SceneManager.World.CurTarget
        UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
        BuildingUtils.ShowPutAllianceBuild(mineId, 0, pointId, PlaceBuildType.Build)
    end,LuaEntry.Player:GetSelfServerId())
end

UIAllianceCitySelectView.OnCreate = OnCreate
UIAllianceCitySelectView.OnDestroy = OnDestroy
UIAllianceCitySelectView.OnEnable = OnEnable
UIAllianceCitySelectView.OnDisable = OnDisable
UIAllianceCitySelectView.ComponentDefine = ComponentDefine
UIAllianceCitySelectView.ComponentDestroy = ComponentDestroy
UIAllianceCitySelectView.DataDefine = DataDefine
UIAllianceCitySelectView.DataDestroy = DataDestroy
--UIAllianceCitySelectView.OnAddListener = OnAddListener
--UIAllianceCitySelectView.OnRemoveListener = OnRemoveListener
UIAllianceCitySelectView.InitData = InitData
UIAllianceCitySelectView.RefreshAll = RefreshAll
UIAllianceCitySelectView.OnInitScroll = OnInitScroll
UIAllianceCitySelectView.OnUpdateScroll = OnUpdateScroll
UIAllianceCitySelectView.OnDestroyScrollItem = OnDestroyScrollItem
UIAllianceCitySelectView.ClearItemCell = ClearItemCell
UIAllianceCitySelectView.OnSelectRuin = OnSelectRuin
UIAllianceCitySelectView.OnClickCloseBtn = OnClickCloseBtn

return UIAllianceCitySelectView
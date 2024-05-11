---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by w.
--- DateTime: 2022/12/12 14:47
---

local base = UIBaseView--Variable
local UIParkourMapView = BaseClass("UIParkourMapView", base)--Variable
local Localization = CS.GameEntry.Localization

local stageItemPrefab = "Assets/Main/Prefabs/UI/ParkourBattle/ParkourStageItem.prefab"
local UIParkourStageItemCell = require "UI.UIParkour.MapUI.View.UIParkourStageItemCell"
local UIParkourStageInfoView = require "UI.UIParkour.MapUI.View.UIParkourStageInfoView"

local userData = {
    guidStageId = 1 -- 指引箭头
}

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:InitUI()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    self:DisposeView()
    base.OnDestroy(self)
    DataCenter.ArrowManager:RemoveArrow()
end

local function ComponentDefine(self)
    self.closeBtn = self:AddComponent(UIButton, "CloseBtn")
    self.closeBtn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    
   
    self.title = self:AddComponent(UIText, "Title")
    self.itemRoot = self:AddComponent(UIBaseContainer, "Items")
    self.topInfoView = self:AddComponent(UIParkourStageInfoView,"ItemsInfo/TopStageInfo")
    self.topInfoView:SetActive(false)
    self.topInfoView.host = self
    --self.bottomHeroList = self:AddComponent(UIBaseContainer, "ItemsInfo/BottomHeroList")
    --self.bottomHeroList:SetActive(false)

    self.nextBtn = self:AddComponent(UIButton, "NextBtn")
    self.nextBtn:SetOnClick(function()
        self:NextPageClick()
    end)

    self.previousBtn = self:AddComponent(UIButton, "PreviousBtn")
    self.previousBtn:SetOnClick(function()
        self:PreviousPageClick()
    end)
    self.closeBtn:SetActive(true)
end

local function ComponentDestroy(self)
    self.closeBtn = nil
    self.nextBtn = nil
end

local function DataDefine(self)
    self.stageGroupMeta = self:GetUserData()
    local maxPage = 1
    while self:CheckHasPage(maxPage+1) do
        maxPage = maxPage+1
    end
    self.currPage = maxPage
end

local function DataDestroy(self)
    self.stageGroupMeta = nil
end

local itemPos = {
    [1] = Vector3.New(-152,-377,0),
    [2] = Vector3.New(59,-329,0),
    [3] = Vector3.New(273,-213,0),
    [4] = Vector3.New(216,22,0),
    [5] = Vector3.New(39,-94,0),
    [6] = Vector3.New(-215,-41,0),
    [7] = Vector3.New(-222,240,0),
    [8] = Vector3.New(17,201,0),
    [9] = Vector3.New(238,257,0),
    [10] = Vector3.New(44,405,0),
}

local function InitUI(self)
    self.stageCells = {}
    self.stageCellReqs = {}
    self:RefreshView()
end
local function DisposeView(self)
    if self.stageCellReqs ~= nil then
        for _, req in ipairs(self.stageCellReqs) do
            req:Destroy()
        end
    end
    self.stageCells = nil
end

local function ShowStageDetail(self,cell)
    self.topInfoView:SetActive(true)
    self.topInfoView:RefreshData(cell)
end

local function CheckHasPage(self,PageId)
    if DataCenter.ParkourManager.GMUnlock then
        local maxOrder = 0
        LocalController:instance():visitTable(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), function(id, lineData)
            maxOrder = math.max(maxOrder, lineData.order)
         end)
        
        return PageId>0 and ((maxOrder-1)//#itemPos + 1) >= PageId 
    else
        local curOrder = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature),DataCenter.ParkourManager.curStageId).order
        return PageId>0 and ((curOrder-1)//#itemPos + 1) >= PageId 
    end
end

local function NextPageClick(self)
    local nextChapterId = self.currPage + 1
    local hasNext = self:CheckHasPage(nextChapterId)

    if hasNext then
        self.currPage = nextChapterId
        self:RefreshView()
    end
end

local function PreviousPageClick(self)
    local previousChapterId = self.currPage - 1
    local hasPrevious = self:CheckHasPage(previousChapterId)
    if hasPrevious then
        self.currPage = previousChapterId
        self:RefreshView()
    end
end

local function RefreshView(self)
    self.panelData = {}
    self.panelData.allStage = {}
    local curOrder = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature),DataCenter.ParkourManager.curStageId).order
    local pageMax = math.min(curOrder,self.currPage*#itemPos)
    if DataCenter.ParkourManager.GMUnlock then
        pageMax = self.currPage*#itemPos
    end
    local pageMin = (self.currPage-1)*#itemPos+1
    LocalController:instance():visitTable(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), function(id, lineData)
       if pageMax>=lineData.order and pageMin<=lineData.order then table.insert(self.panelData.allStage,lineData.id) end
    end)

    table.sort(self.panelData.allStage,function(a,b)
        return a < b
    end)
    
    self.title:SetText("")
    
    self.nextBtn.gameObject:SetActive(self:CheckHasPage(self.currPage + 1))
    self.previousBtn.gameObject:SetActive(self:CheckHasPage(self.currPage - 1))

    if self.stageCellReqs ~= nil then
        for _, req in ipairs(self.stageCellReqs) do
            req:Destroy()
        end
    end
    
    local index = 1
    for _, stageId in ipairs(self.panelData.allStage) do
        local pos = itemPos[index]
        local id = index
        index = index + 1
        local existCell = self.stageCells[id]
        if not existCell then
            if self.stageCellReqs == nil then
                self.stageCellReqs = {}
            end
            local req = self:GameObjectInstantiateAsync(stageItemPrefab, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject;
                go.transform:SetParent(self.itemRoot.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                go.transform.localPosition = pos

                local nameStr = tostring(id)
                go.name = nameStr

                local cell = self.itemRoot:AddComponent(UIParkourStageItemCell,nameStr)
                local cfg = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature),stageId)
                cell:RefreshData(self,cfg)
                self.stageCells[id] = cell
                self.stageCellReqs[id] = nil
            end)
            self.stageCellReqs[index] = req
        else
            existCell:SetActive(true)
            existCell.transform.localPosition = pos
            local cfg = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature),stageId)
            existCell:RefreshData(self,cfg)
        end

        if self.stageGroupMeta and self.stageGroupMeta.guidStageId and stageId == self.stageGroupMeta.guidStageId  then
            self:ShowGuid(pos)
        end
    end

    for id, cell in ipairs(self.stageCells) do
        if(id >= index) then
            cell:SetActive(false)
        end
    end
end

local function ShowGuid(self, pos)
    local param = {
        position = self.transform:TransformPoint(pos),
        positionType = PositionType.Screen,
        clickClose = true
    }
    DataCenter.ArrowManager:ShowArrow(param)
end

UIParkourMapView.OnCreate = OnCreate
UIParkourMapView.OnDestroy = OnDestroy
UIParkourMapView.ComponentDefine = ComponentDefine
UIParkourMapView.ComponentDestroy = ComponentDestroy
UIParkourMapView.DataDefine = DataDefine
UIParkourMapView.DataDestroy = DataDestroy
UIParkourMapView.InitUI = InitUI
UIParkourMapView.DisposeView = DisposeView
UIParkourMapView.ShowStageDetail = ShowStageDetail
UIParkourMapView.RefreshView = RefreshView
UIParkourMapView.CheckHasPage = CheckHasPage
UIParkourMapView.NextPageClick = NextPageClick
UIParkourMapView.PreviousPageClick = PreviousPageClick
UIParkourMapView.ShowGuid = ShowGuid


return UIParkourMapView
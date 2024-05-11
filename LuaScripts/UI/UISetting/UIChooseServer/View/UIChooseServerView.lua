---
--- 选择服务器
--- Created by zzl.
--- DateTime: 
---
local UIServerAreaCell = require "UI.UISetting.UIChooseServer.Component.UIServerAreaCell"
local UIServerItemCell = require "UI.UISetting.UIChooseServer.Component.UIServerItemCell"
local UIChooseServerView = BaseClass("UIChooseServerView",UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local txt_title_path ="UICommonMidPopUpTitle/bg_mid/titleText"
local close_btn_path = "UICommonMidPopUpTitle/bg_mid/CloseBtn"
local goback_btn_path = "UICommonMidPopUpTitle/Btn_GoBack"
local return_btn_path = "UICommonMidPopUpTitle/panel"
local scrollArea_view_path = "ScrollViewArea"
local scrollList_view_path = "ScrollViewList"
local state1_txt_path = "Rect_StateLIst/State1/Txt_State1"
local state2_txt_path = "Rect_StateLIst/State2/Txt_State2"
--local state3_txt_path = "Rect_StateLIst/State3/Txt_State3"

--创建
function UIChooseServerView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
function UIChooseServerView:OnDestroy()
    self:SetAllCellsDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIChooseServerView:ComponentDefine()
    self.txt_title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.goback_btn = self:AddComponent(UIButton, goback_btn_path)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.scrollArea_view = self:AddComponent(UIScrollView, scrollArea_view_path)
    self.scrollArea_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCellMoveInArea(itemObj, index)
    end)
    self.scrollArea_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnCellMoveOutArea(itemObj, index)
    end)
    
    self.scrollList_view = self:AddComponent(UIScrollView, scrollList_view_path)
    self.scrollList_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCellMoveInList(itemObj, index)
    end)
    self.scrollList_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnCellMoveOutList(itemObj, index)
    end)

    self.close_btn:SetOnClick(function()  
        self.ctrl:CloseSelf()
    end)
    self.goback_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.return_btn:SetOnClick(function()  
        self.ctrl:CloseSelf()
    end)
    
    self._state1_txt = self:AddComponent(UITextMeshProUGUIEx,state1_txt_path)
    self._state2_txt = self:AddComponent(UITextMeshProUGUIEx,state2_txt_path)
    self.requestList = {}
    --self._state3_txt = self:AddComponent(UIText,state3_txt_path)
end

function UIChooseServerView:ComponentDestroy()
    self.txt_title = nil
    self.close_btn = nil
    self.return_btn = nil
    self.scrollArea_view = nil
    self._state1_txt = nil
    self._state2_txt = nil
    self.requestList = nil
    --self._state3_txt = nil
end

function UIChooseServerView:DataDefine()
    self.list = {}
    SFSNetwork.SendMessage(MsgDefines.AccountGetAllServer,0,-1)
end

function UIChooseServerView:DataDestroy()
    self.list = nil
end

function UIChooseServerView:OnEnable()
    base.OnEnable(self)
end

function UIChooseServerView:OnDisable()
    base.OnDisable(self)
end

function UIChooseServerView:ReInit()
    self.txt_title:SetLocalText(208230)
    self._state1_txt:SetLocalText(208231)
    self._state2_txt:SetLocalText(208232)
    --self._state3_txt:SetLocalText(208233)
end

-- 表现销毁
function UIChooseServerView:SetAllCellsDestroy()
    self:ClearScroll()
end

function UIChooseServerView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.ServerListRefresh, self.ShowCells)
end

function UIChooseServerView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.ServerListRefresh, self.ShowCells)
end

function UIChooseServerView:ShowCells()
    if self.selectIndex == nil then
        self:ClearScroll()
        self.list = DataCenter.AccountManager:GetServerTabData()
        if next(self.list) then
            local tempCount = table.count(self.list)
            if tempCount > 0 then
                self.scrollArea_view:SetTotalCount(tempCount)
                self.scrollArea_view:RefillCells()
                self:OnClickArea(-1)
            end
        end
    else
        self:OnClickArea(self.selectIndex) 
    end
    
end

--{{{Area
function UIChooseServerView:OnCellMoveInArea(itemObj, index)
    local tempType = self.list[index]
    itemObj.name = NameCount
    NameCount = NameCount + 1
    local cellItem = self.scrollArea_view:AddComponent(UIServerAreaCell, itemObj)
    local callback = function(t)
        self:OnClickArea(t)
    end
    cellItem:ReInit(tempType,index,callback)
    cellItem:SetActive(true)
end

function UIChooseServerView:OnCellMoveOutArea(itemObj, index)
    self.scrollArea_view:RemoveComponent(itemObj.name, UIServerAreaCell)
end

function UIChooseServerView:OnClickArea(index)
    self.selectIndex = index
    self.areaList = DataCenter.AccountManager:GetServerListByIndex(index)
    table.sort(self.areaList,function(a, b) 
        return a.id > b.id
    end)
    self.scrollList_view:ClearCells()
    self.scrollList_view:RemoveComponents(UIServerItemCell)
    if next(self.areaList) then
        local tempCount = table.count(self.areaList)
        if tempCount > 0 then
            self.scrollList_view:SetTotalCount(tempCount)
            self.scrollList_view:RefillCells()
        end
    else
        if index>=0 and self.requestList[index]==nil then
            SFSNetwork.SendMessage(MsgDefines.AccountGetAllServer,1,index)
            self.requestList[index] = true
        end
    end
    EventManager:GetInstance():Broadcast(EventId.OnSelectAccountServer)
end

--}}}
--{{{List
function UIChooseServerView:OnCellMoveInList(itemObj, index)
    local tempType = self.areaList[index]
    itemObj.name = NameCount
    NameCount = NameCount + 1
    local cellItem = self.scrollList_view:AddComponent(UIServerItemCell, itemObj)
    cellItem:ReInit(tempType)
    cellItem:SetActive(true)
end

function UIChooseServerView:OnCellMoveOutList(itemObj, index)
    self.scrollList_view:RemoveComponent(itemObj.name, UIServerItemCell)
end
--}}}
function UIChooseServerView:ClearScroll()
    self.scrollArea_view:ClearCells()--清循环列表数据
    self.scrollArea_view:RemoveComponents(UIServerAreaCell)--清循环列表gameObject
    self.scrollList_view:ClearCells()
    self.scrollList_view:RemoveComponents(UIServerItemCell)
end

return UIChooseServerView
---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2021/8/27 12:12
---

local WorldBookmarkItemCell = require "UI.UISearch.Component.WorldBookmarkItemCell"
local WorldBookmarkItem = BaseClass("WorldBookmarkItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Screen = CS.UnityEngine.Screen

local scroll_path = "ScrollView"
local content_path = "ScrollView/Viewport/Content"
local empty_txt_path = "TxtEmpty"
local panel_bg_path = ""
local panel_arrow_path = "Bookmark_Arrow"
local this_path = ""
local btn_returnTop_path = "Btn_ReturnTop"

local itemCellH = 89

local function OnCreate(self)
    base.OnCreate(self)
    self.empty_txt = self:AddComponent(UITextMeshProUGUIEx, empty_txt_path)
    self.panel_bg = self:AddComponent(UIImage, panel_bg_path)
    self.panel_arrow = self:AddComponent(UIImage, panel_arrow_path)

    self.ScrollView = self:AddComponent(UIScrollView, scroll_path)
    self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
        self:OnItemMoveIn(itemObj, index)
    end)
    self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
        self:OnItemMoveOut(itemObj, index)
    end)
    self.content = self:AddComponent(UIBaseContainer,content_path)
    
    self.list ={}
    self._returnTop_btn = self:AddComponent(UIButton,btn_returnTop_path)
    self._returnTop_btn:SetOnClick(function()
       self:OnClickReturnTop()
    end)
end

local function OnDestroy(self)
    self.empty_txt = nil
    self.ScrollView = nil
    self.content = nil
    self.list = nil
    self.panel_bg = nil
    self.panel_arrow = nil
    self.animator = nil
    self.sign = nil
    base.OnDestroy(self)
end

local function RefreshMarkList(self)
    self.sign = 0
    --self._returnTop_btn:SetActive(false)
    self:ClearScroll()
    self.list = self.view.ctrl:GetMarkListByTab(self.curTab)
    local deltaY = 0
    local itemNum = 2
    if #self.list > 0 then
        self.empty_txt:SetText("")
        --if #self.list > 4 then
        --    deltaY = 475
        --else
        --    if #self.list > 2 then
        --        itemNum = #self.list
        --    end
        --    deltaY = itemNum*itemCellH + 60 + #self.list * 8
        --end
        --self.sign = 5/#self.list
    else
        self.empty_txt:SetLocalText(128007) 
        --deltaY = itemNum*itemCellH + 76
    end
    --self.panel_bg:SetSizeDelta(Vector2(self.panel_bg:GetSizeDelta().x,deltaY))
    self.ScrollView:SetTotalCount(#self.list)
    if #self.list > 0 then
        self.ScrollView:RefillCells()
    end
    --CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    self:ClearScroll()
    base.OnDisable(self)
end

local function ReInit(self, tab, posX)
    self.curTab = tab
    self:RefreshMarkList()
    self:ResetPosition(posX)
   
end

local function ResetPosition(self, posX)
    local arrowPosX = posX
    local arrowPosY = self.panel_arrow.transform.position.y
    --local panelPosX = posX
    --local panelPosY = self.panel_bg.transform.position.y
    --local rect = self.panel_bg.rectTransform.rect
    --local scale = Screen.height/750
    --local screenWidth = Screen.width
    --local halfRectWidth = rect.width / 2 * scale
    --local maxX = screenWidth - halfRectWidth - 30
    --panelPosX = math.min(panelPosX, maxX)
    self.panel_arrow.transform.position = Vector3.New(arrowPosX, arrowPosY, 0)
    --self.panel_bg.transform.position = Vector3.New(panelPosX, panelPosY, 0)
end

local function OnItemMoveIn(self,itemObj, index)
    itemObj.name = tostring(index)
    local cellItem = self.ScrollView:AddComponent(WorldBookmarkItemCell, itemObj)
    cellItem:SetItemShow(self.list[index])
end

local function OnItemMoveOut(self, itemObj, index)
    self.ScrollView:RemoveComponent(itemObj.name, WorldBookmarkItemCell)
end


local function OnClickReturnTop(self)
    self.view:OnSearchClick(UISearchType.Monster)
    --self._returnTop_btn:SetActive(false)
    --self.ScrollView:ScrollToCell(1, 10000)
end

local function ClearScroll(self)
    self.ScrollView:ClearCells()
    self.ScrollView:RemoveComponents(WorldBookmarkItemCell)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.RefreshBookmark, self.RefreshMarkList)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.RefreshBookmark, self.RefreshMarkList)
end


WorldBookmarkItem.OnCreate= OnCreate
WorldBookmarkItem.OnDestroy = OnDestroy
WorldBookmarkItem.RefreshMarkList = RefreshMarkList
WorldBookmarkItem.OnEnable = OnEnable
WorldBookmarkItem.OnDisable = OnDisable
WorldBookmarkItem.OnItemMoveIn = OnItemMoveIn
WorldBookmarkItem.OnItemMoveOut = OnItemMoveOut
WorldBookmarkItem.ClearScroll = ClearScroll
WorldBookmarkItem.OnAddListener = OnAddListener
WorldBookmarkItem.OnRemoveListener = OnRemoveListener
WorldBookmarkItem.ReInit = ReInit
WorldBookmarkItem.ResetPosition = ResetPosition
WorldBookmarkItem.OnClickReturnTop = OnClickReturnTop

return WorldBookmarkItem
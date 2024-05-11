---
--- 荣耀之战联赛分组
--- Created by shimin.
--- DateTime: 2023/2/28 18:56
---

local UIGloryGroupView = BaseClass("UIGloryGroupView", UIBaseView)
local base = UIBaseView
local UIGloryGroupCell = require "UI.UIGlory.UIGloryGroup.Component.UIGloryGroupCell"

local title_text_path = "UICommonMidPopUpTitle/bg_mid/titleText"
local return_btn_path = "UICommonMidPopUpTitle/panel"
local close_btn_path = "UICommonMidPopUpTitle/bg_mid/CloseBtn"
local scroll_view_path = "ScrollView"

function UIGloryGroupView:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
    self:ReInit()
end

function UIGloryGroupView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIGloryGroupView:OnEnable()
    base.OnEnable(self)
end

function UIGloryGroupView:OnDisable()
    base.OnDisable(self)
end

function UIGloryGroupView:ComponentDefine()
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.return_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCellMoveIn(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnCellMoveOut(itemObj, index)
    end)
end

function UIGloryGroupView:ComponentDestroy()
  
end

function UIGloryGroupView:DataDefine()
    self.list = {}
end

function UIGloryGroupView:DataDestroy()
    self.list = {}
end

function UIGloryGroupView:OnAddListener()
    base.OnAddListener(self)
end

function UIGloryGroupView:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIGloryGroupView:ReInit()
    self.title_text:SetLocalText(GameDialogDefine.GLORY_GROUP)
    self:ShowCells()
end

function UIGloryGroupView:ShowCells()
    self:ClearScroll()
    self:GetDataList()
    local count = table.count(self.list)
    if count > 0 then
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    end
end

function UIGloryGroupView:ClearScroll()
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(UIGloryGroupCell)--清循环列表gameObject
end

function UIGloryGroupView:OnCellMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scroll_view:AddComponent(UIGloryGroupCell, itemObj)
    item:ReInit(self.list[index])
end

function UIGloryGroupView:OnCellMoveOut(itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UIGloryGroupCell)
end

function UIGloryGroupView:GetDataList()
    self.list = {}
    local groupId = self:GetUserData() or 0
    local template = DataCenter.SeasonGroupManager:GetTemplateById(groupId)
    if template ~= nil then
        local selfServerId = LuaEntry.Player.serverId
        local opponentServerId = 0
        local opponent = DataCenter.GloryManager:GetOpponentData()
        if opponent ~= nil then
            opponentServerId = opponent.serverId
        end
        for k,v in ipairs(template.serverIds) do
            local param = {}
            param.serverId = v
            if v == selfServerId then
                param.serverType = GlorySeverType.Self
            elseif v == opponentServerId then
                param.serverType = GlorySeverType.Opponent
            else
                param.serverType = GlorySeverType.Other
            end
            table.insert(self.list, param)
        end
    end
end


return UIGloryGroupView
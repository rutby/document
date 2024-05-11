---
--- 黑骑士战报组
--- Created by shimin.
--- DateTime: 2023/3/9 16:01
---
local MailBlackKnightGroup = BaseClass("MailBlackKnightGroup", UIBaseContainer)
local base = UIBaseContainer
local MailBlackKnightGroupCell = require "UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.MailBlackKnightGroupCell"
local scroll_view_path = "ScrollView"
local main_text_path = "UIMailBlackKnightDetailTitle/txtMainTitle"
local time_text_path = "UIMailBlackKnightDetailTitle/txtTime"

function MailBlackKnightGroup:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
    self:ReInit()
end

function MailBlackKnightGroup:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function MailBlackKnightGroup:OnEnable()
    base.OnEnable(self)
end

function MailBlackKnightGroup:OnDisable()
    base.OnDisable(self)
end

function MailBlackKnightGroup:ComponentDefine()
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCellMoveIn(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnCellMoveOut(itemObj, index)
    end)
    self.main_text = self:AddComponent(UITextMeshProUGUIEx, main_text_path)
    self.time_text = self:AddComponent(UITextMeshProUGUIEx, time_text_path)
end

function MailBlackKnightGroup:ComponentDestroy()

end

function MailBlackKnightGroup:DataDefine()
    self.list = {}
    self.mailData = nil
end

function MailBlackKnightGroup:DataDestroy()
    self.list = {}
    self.mailData = nil
end

function MailBlackKnightGroup:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.MailGetMore, self.MailGetMoreSignal)
end

function MailBlackKnightGroup:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.MailGetMore, self.MailGetMoreSignal)
end

function MailBlackKnightGroup:ReInit()
  
end

function MailBlackKnightGroup:Refresh()
    local mainTitle = MailShowHelper.GetMainTitle(self.mailData)
    self.main_text:SetText(mainTitle)
    
    local createTime = MailShowHelper.GetAbstractCreateTime(self.mailData)
    self.time_text:SetText(createTime)
    self:ShowCells()
end

function MailBlackKnightGroup:ShowCells()
    self:ClearScroll()
    self:GetDataList()
    local count = table.count(self.list)
    if count > 0 then
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    end
end

function MailBlackKnightGroup:ClearScroll()
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(MailBlackKnightGroupCell)--清循环列表gameObject
end

function MailBlackKnightGroup:OnCellMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scroll_view:AddComponent(MailBlackKnightGroupCell, itemObj)
    item:ReInit(self.list[index])
    if index == #self.list then
        self:GetMoreMail()
    end
end

function MailBlackKnightGroup:OnCellMoveOut(itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, MailBlackKnightGroupCell)
end

function MailBlackKnightGroup:GetDataList()
    if self.mailData ~= nil then
        if self.mailData.type == MailType.NEW_FIGHT_EXPEDITIONARY_DUEL then
            self.list = DataCenter.MailDataManager:GetGroupMailList(MailInternalGroup.MAIL_IN_expeditionaryDuel)
        elseif self.mailData.type == MailType.NEW_FIGHT_BLACK_KNIGHT then
            self.list = DataCenter.MailDataManager:GetGroupMailList(MailInternalGroup.MAIL_IN_blackKnight)
        end
        if self.list[2] ~= nil then
            table.sort(self.list, function(a,b)  
                return b.createTime < a.createTime
            end)
        end
    end
end

function MailBlackKnightGroup:setData( mailData ,showReplay, jumpType)
    self.mailData = mailData
    self:Refresh()
end

function MailBlackKnightGroup:MailGetMoreSignal()
    self:GetDataList()
    local count = table.count(self.list)
    if count > 0 then
        self.scroll_view:SetTotalCount(count)
    end
end

function MailBlackKnightGroup:GetMoreMail()
    local groupType = 0
    if self.mailData.type == MailType.NEW_FIGHT_EXPEDITIONARY_DUEL then
        groupType = MailInternalGroup.MAIL_IN_expeditionaryDuel
    elseif self.mailData.type == MailType.NEW_FIGHT_BLACK_KNIGHT then
        groupType = MailInternalGroup.MAIL_IN_blackKnight
    end
    DataCenter.MailDataManager:ReqMore(groupType, function ()
        
    end)
end

return MailBlackKnightGroup
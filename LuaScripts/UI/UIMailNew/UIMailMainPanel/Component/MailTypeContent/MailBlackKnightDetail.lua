---
--- 黑骑士战报
--- Created by shimin.
--- DateTime: 2023/3/8 19:07
---
local MailBlackKnightDetail = BaseClass("MailBlackKnightDetail",UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local MailBlackKnightDetailTitle = require "UI.UIMailNew.UIMailMainPanel.Component.MailBlackKnightDetailTitle"
local MailPlayerReport = require "UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.BattleTypeNew.MailPlayerReport"
local MailPlayerReportTotal = require "UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.BattleTypeNew.MailPlayerReportTotal"
local _cp_looplistview = "ScrollView"
local _cp_looplistview_content = "ScrollView/Viewport/Content"

local eConfigType = {
    eContentTitle = 1,      -- 标题
    eBattleTotal = 2,    -- 伤害汇总信息
    eBattleTeamItem = 3,    -- 双方队伍信息
    --eBattleTopUserInfo = 3, -- 个人信息简述
    --eBattleTotalSummary = 4 -- 自己这一方的信息汇总
}

local eConfig = {
    [eConfigType.eContentTitle] = {
        ["Prefab"] = "UIMailBlackKnightDetailTitle",
        ["Script"] = MailBlackKnightDetailTitle    
    },
    [eConfigType.eBattleTotal] = {
        ["Prefab"] = "MailPlayerReportTotal",
        ["Script"] = MailPlayerReportTotal
    },
    [eConfigType.eBattleTeamItem] = {
        ["Prefab"] = "MailPlayerReport",
        ["Script"] = MailPlayerReport
    },
}


function MailBlackKnightDetail:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.Event_ShowBattleReportDetail, self.ShowBattleReportDetail)

end

function MailBlackKnightDetail:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.Event_ShowBattleReportDetail,self.ShowBattleReportDetail)
end

function MailBlackKnightDetail:ShowBattleReportDetail( message )
    if (table.IsNullOrEmpty(message)) then
        return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIMailDetailReportView,{anim = false}, message)
end

function MailBlackKnightDetail:OnCreate()
    base.OnCreate(self)
    self._totalItemCnt = 0
    self.showTotalMessage = false --是否需要显示汇总信息
    self._cellList = {}
    self._looplistview = self:AddComponent(UILoopListView2, _cp_looplistview)
    self._looplistview_content = self:AddComponent(UIBaseContainer, _cp_looplistview_content)
    
    self._looplistview:InitListView(0, function (listview, index)
        return self:GetScrollItem(listview, index)
    end)
end

function MailBlackKnightDetail:OnDestroy()
    self._cellList = {}
    for _, config in pairs(eConfig) do
        local component = config["Script"]
        self._looplistview_content:RemoveComponents(component)
    end
    self._looplistview:ClearAllItems()
end

function MailBlackKnightDetail:OnDisable()
    base.OnDisable(self)
end

function MailBlackKnightDetail:GetConfigByIndex( index )
    if (index == 1) then
        return eConfig[eConfigType.eContentTitle]
    elseif self.showTotalMessage == true and index == 2 then
        return eConfig[eConfigType.eBattleTotal]
    --elseif index == 3 then
    --    return eConfig[eConfigType.eBattleTotalSummary]
    else
        return eConfig[eConfigType.eBattleTeamItem]
    end
end


function MailBlackKnightDetail:GetScrollItem( listview, index)
    index = index + 1
    if (index < 1 or index > self._totalItemCnt) then
        return nil
    end
    local config_data = self:GetConfigByIndex(index)
    local item = listview:NewListViewItem(config_data["Prefab"])
    --pcall(function ()
    --    
    --end)
    if (self._cellList[item] == nil) then
        NameCount = NameCount + 1
        local nameStr = tostring(NameCount)
        item.gameObject.name = nameStr
        local mailItem = self._looplistview_content:AddComponent(config_data["Script"], nameStr)
        self._cellList[item] = mailItem
    end
    xpcall(function ()
        self:SetItemData(self._cellList[item], index)
    end, function ()
        Logger.LogError(" 大BUG.群里发一下吧！！！ ")
    end)
    return item
end

function MailBlackKnightDetail:SetItemData(handler, index)
    if (index == 1) then
        self:SetItemData_CommonTitle(handler)
    --elseif (index == 2) then
    --    handler:SetData(self._maildata)
    else
        if self.showTotalMessage == true then
            handler:SetData(self._maildata, index-2,self.needShowReplay,self.jumpType)
        else
            handler:SetData(self._maildata, index-1,self.needShowReplay,self.jumpType)
        end
        
    end
end

function MailBlackKnightDetail:SetItemData_CommonTitle(handler)
    local param = {}
    param["showShare"] = false
    param["main"] = MailShowHelper.GetMainTitle(self._maildata)
    param["score"] = MailShowHelper.GetScore(self._maildata, LuaEntry.Player.uid)
    param["sub"] = MailShowHelper.GetMailSummary(self._maildata, nil, self._maildata.senderUid)
    param["time"] = MailShowHelper.GetAbstractCreateTime(self._maildata)
    param["mailInfo"] = self._maildata
    handler:SetData(param)
end

function MailBlackKnightDetail:setData( maildata ,showReplay,jumpType)
    self._maildata = maildata
    self.needShowReplay = showReplay
    self.jumpType = jumpType
    -- 这个地方封一个临时数据  1 表示邮件标题  2 玩家信息  3+ 表示回合数[这个地方有个需要注意的,如果普通的进攻一轮是一个,如果是集结这种的则是多个]
    maildata:GetMailExt():SortRound()
    local roundCount = maildata:GetMailExt():GetTotalRoundCnt()
    if roundCount>1 and maildata.type ~= MailType.ELITE_FIGHT_MAIL then
        self.showTotalMessage = true
        self._totalItemCnt = maildata:GetMailExt():GetTotalRoundCnt() + 2  -- 3表示上面的这些信息
    else
        self.showTotalMessage = false
        self._totalItemCnt = maildata:GetMailExt():GetTotalRoundCnt() + 1  -- 2表示上面的这些信息
    end
    self._looplistview:SetListItemCount(self._totalItemCnt, true, true)
    self._looplistview:RefreshAllShownItem()
end


return MailBlackKnightDetail
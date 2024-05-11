---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mac.
--- DateTime: 8/11/21 9:13 PM
---
local Localization = CS.GameEntry.Localization
local ItemObj = require "UI.UIMailNew.UIMailDetailReportView.Component.UIMailDetailReportItemTitleObj"
local ContentObj = require "UI.UIMailNew.UIMailDetailReportView.Component.UIMailDetailReportItemContentObj"
local ReportParseHelper = require "DataCenter.MailData.MailDetailModule.MailDetailReportParseHelper"
local UIMailDetailReportView = BaseClass("UIMailDetailReportView",UIBaseView)
local base = UIBaseView

local _cp_btnClose = "UICommonPopUpTitle/bg_mid/CloseBtn"
local _cp_txtTitle = "UICommonPopUpTitle/bg_mid/titleText"
local _cp_looplistview = "ScrollView"
local _cp_looplistview_content = "ScrollView/Viewport/Content"
local _cp_txtBattleTime = "objTopTitle/txtBattleTime"
local _cp_txtCloseAllRound = "objTopTitle/txtCloseAllRound"
local _cp_btnCloseAllRound = "objTopTitle/btnCloseAllRound"


local eConfigType = {
    eTitle = 1,      -- 标题
    eContent = 2,    -- 内容
}

local eConfig = {
    [eConfigType.eTitle] = {
        ["Prefab"] = "ObjDetailItemTitle",
        ["Script"] = ItemObj
    },
    [eConfigType.eContent] = {
        ["Prefab"] = "ObjDetailItemContent",
        ["Script"] = ContentObj
    },
}

--[[
local _cp_btnBattlePos = "objTopTitle/btnBattlePos"
local _cp_txtBattlePos = "objTopTitle/txtBattlePos"
local _cp_txtBattleTime = "objTopTitle/txtBattleTime"
local _cp_txtCloseAllRound = "objTopTitle/txtCloseAllRound"
local _cp_btnCloseAllRound = "objTopTitle/btnCloseAllRound"
]]
function UIMailDetailReportView:OnCreate()
    base.OnCreate(self)
    self.ctrl:InitData()
    self._curShowIdxList = {} -- 这个以idx作为key
    self._cellList = {}
    self._showAllInfo = false
    
    
    self._txtBattleTime = self:AddComponent(UITextMeshProUGUI, _cp_txtBattleTime)
    self._txtCloseAllRound = self:AddComponent(UITextMeshProUGUI, _cp_txtCloseAllRound)
    
    self._btnCloseAllRound = self:AddComponent(UIButton, _cp_btnCloseAllRound)
    self._btnCloseAllRound:SetOnClick(BindCallback(self, self.OnClickBtnCloseAllRound))
    
    self._btnClose = self:AddComponent(UIButton, _cp_btnClose)
    self._btnClose:SetOnClick(BindCallback(self, self.OnClickBtnClose))
    self._txtTitle = self:AddComponent(UITextMeshProUGUI, _cp_txtTitle)
    self._looplistview = self:AddComponent(UILoopListView2, _cp_looplistview)
    self._looplistview_content = self:AddComponent(UIBaseContainer, _cp_looplistview_content)

    self._looplistview:InitListView(0, function (listview, index)
        return self:GetScrollItem(listview, index)
    end)
end


function UIMailDetailReportView:OnClickBtnCloseAllRound()
    self._showAllInfo = not self._showAllInfo
    self.ctrl:SetAllRoundDetailStatus(self._showAllInfo)
    self:SetShowAllStausText()
    --self._looplistview:SetListItemCount(self.ctrl:GetRoundCnt(), false, false)
    self._looplistview:RefreshAllShownItem()
end

function UIMailDetailReportView:SetShowAllStausText()
    if (self._showAllInfo) then
        self._txtCloseAllRound:SetLocalText(310155) 
    else
        self._txtCloseAllRound:SetLocalText(310154) 
    end
end

function UIMailDetailReportView:OnClickBtnClose()
    self.ctrl:CloseSelf()
end

-- return self, other
function UIMailDetailReportView:GetHealth(mailId, roundIdx)
    local mailData = self.mailInfo--DataCenter.MailDataManager:GetMailInfoById(mailId)
    if (mailData == nil) then
        return 0, 0
    end
    local roundFight = mailData:GetMailExt():GetFightReportByRoundIndex(roundIdx)
    if (roundFight == nil) then
        return
    end
    local selfHealth = roundFight:GetTroopHealth(true)
    local otherHealth = roundFight:GetTroopHealth(false)
    return selfHealth, otherHealth
    
end

function UIMailDetailReportView:GetHeroSpecialSkill(mailId,roundIdx)
    local mailData = self.mailInfo--DataCenter.MailDataManager:GetMailInfoById(mailId)
    if (mailData == nil) then
        return {}, {}
    end
    local roundFight = mailData:GetMailExt():GetFightReportByRoundIndex(roundIdx)
    if (roundFight == nil) then
        return {}, {}
    end
    local selfSkillList = roundFight:GetHeroSpecialSkillList(true)
    local otherSkillList = roundFight:GetHeroSpecialSkillList(false)
    return selfSkillList, otherSkillList
end

function UIMailDetailReportView:OnEnable()
    base.OnEnable(self)
    self._txtTitle:SetLocalText(311047) 
    local param = self:GetUserData()
    local strBase64 = param["contents"]
    local mailId = param["mailId"]
    local roundIdx = param["roundIdx"]
    self.mailInfo = param["mailInfo"]

    local selfHealth, otherHealth = self:GetHealth(mailId, roundIdx)
    local selfSpSkillList,otherSpSkillList = self:GetHeroSpecialSkill(mailId,roundIdx)
    local tableData = PBController.ParsePb1(strBase64, ".protobuf.BattleDetailInfo")
    ReportParseHelper:ParseData(tableData, selfHealth, otherHealth,selfSpSkillList,otherSpSkillList)

    local rMinIndex = ReportParseHelper:GetMinIndex()
    local rMaxIndex = ReportParseHelper:GetMaxIndex()
    
    self:InitView(mailId, rMinIndex)
    
    local tmpParam = {["mailId"] = mailId, ["roundIdx"] = roundIdx}
    -- 插入标题 战斗简介
    self.ctrl:AddItemInfoToList(eMailDetailItemType.Title_Summary, tmpParam)
    ---- 插入标题 己方
    self.ctrl:AddItemInfoToList(eMailDetailItemType.Title_Self, tmpParam)
    ---- 插入标题 对方
    self.ctrl:AddItemInfoToList(eMailDetailItemType.Title_Other, tmpParam)
    
    
    for i = rMinIndex, rMaxIndex do
        tmpParam = {["mailId"] = mailId, ["roundIdx"] = roundIdx}
        tmpParam["index"] = i
        tmpParam["show"] = false
        self.ctrl:AddItemInfoToList(eMailDetailItemType.Content, tmpParam)
    end
    ---- 插入结算
    self.ctrl:AddItemInfoToList(eMailDetailItemType.Title_Result, tmpParam)
    local cnt = self.ctrl:GetRoundCnt()
    self._looplistview:SetListItemCount(self.ctrl:GetRoundCnt(), false, false)
    --self._looplistview:RefreshAllShownItem()
end

function UIMailDetailReportView:InitView(mailId, roundIdx)
    local mailData = DataCenter.MailDataManager:GetMailInfoById(mailId)
    if (mailData == nil) then
        return
    end
    
    local startRound = mailData:GetMailExt():GetStartRound()
    local mailTime = mailData.createTime + roundIdx - startRound
    local strTime = UITimeManager:GetInstance():TimeStampToTimeForLocal(mailTime)
    self._txtBattleTime:SetText(strTime)
    
    self:SetShowAllStausText()
end

-- 事件监听
function UIMailDetailReportView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.MailDetailReport_ClickItem, self.OnClickTitle)
end

function UIMailDetailReportView:OnRemoveListener()
    self:RemoveUIListener(EventId.MailDetailReport_ClickItem, self.OnClickTitle)
    base.OnRemoveListener(self)
end

function UIMailDetailReportView:OnClickTitle( param )
    local rIndex = param["index"]
    local action = param["action"]
    if (action == true) then
        self.ctrl:ShowContent(rIndex)
    elseif action == false then
        self.ctrl:CloseContent(rIndex)
    end
    --self._looplistview:SetListItemCount(self.ctrl:GetRoundCnt(), false, false)
    self._looplistview:RefreshAllShownItem()
end

function UIMailDetailReportView:OnDestroy()
    self._cellList = {}
    self._looplistview_content:RemoveComponents(ItemObj)
    self._looplistview:ClearAllItems()
    base.OnDestroy(self)
end

function UIMailDetailReportView:OnDisable()
    base.OnDisable(self)
end


-- 这个index是从0开始的
function UIMailDetailReportView:GetScrollItem( listview, index)
    index = index + 1
    if (index < 1 or index > self.ctrl:GetRoundCnt()) then
        return nil
    end
    local item_data = self.ctrl:GetItemByIndex(index) or {}
    local item_type = item_data["type"]
    local config_type = nil
    if (item_type == eMailDetailItemType.Title_Result or item_type == eMailDetailItemType.Title_Summary or item_type == eMailDetailItemType.Title_Self or item_type == eMailDetailItemType.Title_Other) then
        config_type = eConfigType.eTitle
    else
        config_type = eConfigType.eContent
    end
    local item = listview:NewListViewItem(eConfig[config_type]["Prefab"])
    if (self._cellList[item] == nil) then
        NameCount = NameCount + 1
        local nameStr = tostring(NameCount)
        item.gameObject.name = nameStr
        local mailItem = self._looplistview_content:AddComponent(eConfig[config_type]["Script"], nameStr)
        self._cellList[item] = mailItem
    else
        NameCount = NameCount + 1
        local nameStr = tostring(NameCount)
        item.gameObject.name = nameStr
    end
    self._cellList[item]:SetData(item_data)
    return item
end


return UIMailDetailReportView
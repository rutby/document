---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mac.
--- DateTime: 1/17/22 9:26 PM
---ChatItemMailReportContentShare.lua
local IChatItem = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatItemMailReportContentShare = BaseClass("ChatItemMailReportContentShare", IChatItem)
local base = IChatItem
local Localization = CS.GameEntry.Localization
local ChatHead = require("UI.UIChatNew.Component.ChatHead")
local ChatUserName = require "UI.UIChatNew.Component.ChatItem.ChatUserName"
local rapidjson = require "rapidjson"
local MailInfo = require "DataCenter.MailData.MailInfo"
 
local _cp_chatHead = "ChatHead"
local _cp_ShareTitle = "ChatShareNode/Image/ShareTitle";
local _cp_shareMsg = "ChatShareNode/ShareIconNode/ShareMsg/ShareMsg"
local _cp_shareNode = "ChatShareNode";
local _cp_chatNameLayout = "ChatNameLayout"

local Const_Min_ShareNodeHeight = 120
local Const_OneLineHeight = 26



function ChatItemMailReportContentShare:ComponentDefine()
    self._chatHead = self:AddComponent(ChatHead, _cp_chatHead)
    self._shareTitle = self:AddComponent(UITextMeshProUGUIEx, _cp_ShareTitle)
    self._shareMsg = self:AddComponent(UITextMeshProUGUIEx, _cp_shareMsg)
    self._shareNode = self:AddComponent(UIButton, _cp_shareNode)
    self._shareNode:SetOnClick(BindCallback(self, self.OnClickBg) )
    self._chatNameLayout = self:AddComponent(ChatUserName, _cp_chatNameLayout)
end

function ChatItemMailReportContentShare:OnClickBg()
    if not SceneUtils.CheckCanGotoWorld() then
        return UIUtil.ShowTipsId(120018)
    end
    local mailExt = self.mailReportInfo:GetMailExt()
    local version = mailExt:GetVersion()
    if version==nil or version<=0 then
        UIUtil.ShowTipsId(390843)
        return
    end
    if mailExt.showRoundList == nil or table.count(mailExt.showRoundList) == 0 then
        UIUtil.ShowTipsId(390508)
        return
    end
    if self.mailReportInfo ~= nil then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIShareMail, NormalBlurPanelAnim,self.mailReportInfo)
    end
end

function ChatItemMailReportContentShare:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
end

function ChatItemMailReportContentShare:UpdateItem( chatdata, index )
    base.UpdateItem(self, chatdata, index)
    if (chatdata == nil) then
        return
    end
    local senderUid = chatdata["senderUid"]

    local attachInfo = chatdata:getMessageParam(false)
    local mailInfo = MailInfo.New()
    local attachmentId = chatdata["attachmentId"] or ""
    local strContent = rapidjson.decode(attachmentId) or {}
    local message = {}
    local reportContent = strContent.reportContent or ""
    message.contents = "{\"b\":{},\"obj\":{\"battleContent\":\""..reportContent.."\"}}"
    message.type = strContent.mailType or MailType.NEW_FIGHT
    message.title = "{\"h\":{}}"
    message.uid = 0
    if strContent.createTime ~= nil and strContent.createTime > 0 then
        message.createTime = strContent.createTime
    else
        local pb_BattleReport = {}
        local ok, err = pcall(function()
            if message.type == MailType.ELITE_FIGHT_MAIL then
                pb_BattleReport = PBController.ParsePb1(reportContent, "protobuf.DeliteReport") or {}
            elseif message.type == MailType.NEW_FIGHT or message.type == MailType.SHORT_KEEP_FIGHT_MAIL then
                pb_BattleReport = PBController.ParsePb1(reportContent, "protobuf.BattleReport") or {}
            end
        end)
        if not ok then
            return
        end
        message.createTime = pb_BattleReport.startTime or 0
    end
    mailInfo:ParseBaseData(message)
    self.mailReportInfo = mailInfo
    self.mailReportInfo.senderUid = senderUid
    self.mailReportInfo.isChat = true
    
    local title =  MailShowHelper.GetMainTitle(self.mailReportInfo, senderUid)
    self._shareTitle:SetText(title)
    local str = MailShowHelper.GetMailSummary(self.mailReportInfo, true, senderUid)
    self._shareMsg:SetText(str)
    
    --local tabParam = tabAttachment["para"] or {}
    --self.mailId = tabParam["mailId"]
    --local title = tabParam["title"]
    --if (title) then
    --    self._shareTitle:SetLocalText(title)
    --end
    
    --local str = chatdata:getMessageWithExtra(false)
    --self._shareMsg:SetText(str)
    
    local _userInfo = ChatManager2:GetInstance().User:getChatUserInfo(senderUid, true)
    if (self._chatNameLayout) then
        self._chatNameLayout:UpdateName(_userInfo, chatdata)
    end
    
    -- 获取文本的高度,最小高度是120,之前预留了一行的高度,所以在获取真实高度的时候,需要将之前一行的高度给减去
    -- 给分享框设置尺寸
    local height = self._shareMsg:GetHeight()
    local curHeight = Const_Min_ShareNodeHeight+height-Const_OneLineHeight
    height = Mathf.Max(Const_Min_ShareNodeHeight, curHeight)
    local size_x, size_y = self._shareNode.rectTransform:Get_sizeDelta()
    self._shareNode.rectTransform:Set_sizeDelta(size_x, height)
    
    -- 给当前节点设置尺寸
    local r_x, _ = self.rectTransform:Get_sizeDelta()
    self.rectTransform:Set_sizeDelta(r_x, height+40)

    -- 设置胜利失败的颜色
    local battleResult = self.mailReportInfo:GetMailExt():GetBattleResultStatus(senderUid)
    if battleResult == FightResult.SELF_WIN then
        self._shareTitle:SetColor(Const_Color_Green)
    elseif battleResult == FightResult.DRAW then
        self._shareTitle:SetColor(WhiteColor)
    else
        self._shareTitle:SetColor(Const_Color_Red)
    end
    
    self:UpdateTopOffset()
end

-- override
function ChatItemMailReportContentShare:GetTopOffset()
    if self._chatNameLayout then
        return self._chatNameLayout:GetTopOffset()
    else
        return 0
    end
end

-- override
function ChatItemMailReportContentShare:UpdateTopOffset()
    local initOffset = 40
    local topOffset = self:GetTopOffset()
    local sizeX, sizeY = self.rectTransform:Get_sizeDelta()
    self.rectTransform:Set_sizeDelta(sizeX, sizeY + topOffset)
    self:SetTransPosY(self._shareNode.rectTransform, - (initOffset + topOffset))
end

return ChatItemMailReportContentShare
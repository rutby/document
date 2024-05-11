---
--- 黑骑士标题
--- Created by shimin.
--- DateTime: 2023/3/8 19:07
---
local MailBlackKnightDetailTitle = BaseClass("MailBlackKnightDetailTitle",UIBaseContainer)
local base = UIBaseContainer
local base64 = require "Framework.Common.base64"
local rapidjson = require "rapidjson"

local _cp_txtMainTitle = "txtMainTitle"
local _cp_txtSubTitle = "txtSubTitle"
local _cp_txtSubTitle_Fight = "txtSubTitle_Fight"
local _cp_txtTime = "txtTime"
local _cp_txtMainTitle_Fight = "txtMainTitle_Fight"
local _cp_btnShare = "shareBtn"
local _cp_txtScore = "txtScore"

function MailBlackKnightDetailTitle:OnCreate()
    base.OnCreate(self)
    self._txtMainTitle_Fight = self:AddComponent(UITextMeshProUGUIEx, _cp_txtMainTitle_Fight)
    self._txtMainTitle = self:AddComponent(UITextMeshProUGUIEx, _cp_txtMainTitle)
    self._txtSubTitle = self:AddComponent(UITextMeshProUGUIEx, _cp_txtSubTitle)
    self._txtTime = self:AddComponent(UITextMeshProUGUIEx, _cp_txtTime)
    self._txtSubTitle_Fight = self:AddComponent(UITextMeshProUGUIEx, _cp_txtSubTitle_Fight)
    self._txtSubTitle_Fight:OnPointerClick(function (eventData)
        self:OnPointerClick(eventData.position)
    end)
    self.shareBtnN = self:AddComponent(UIButton, _cp_btnShare)
    self.shareBtnN:SetOnClick(function()
        self:OnClickShareBtn()
    end)
    self._txtScore = self:AddComponent(UITextMeshProUGUIEx, _cp_txtScore)
end

function MailBlackKnightDetailTitle:OnPointerClick( clickPos )
    if (self._txtSubTitle_Fight == nil) then
        return
    end
    local pos = clickPos
    local x = pos.x
    local y = pos.y
    local vec3 = Vector3.New(x, y, 0)
    local linkIndex = CS.TMPro.TMP_TextUtilities.FindIntersectingLink(self._txtSubTitle_Fight.unity_tmpro, vec3, nil);
    if (linkIndex == -1) then
        return
    end
    local linkInfo = self._txtSubTitle_Fight:GetLinkInfo()
    if (linkInfo == nil) then
        return
    end
    local linkItem = linkInfo[linkIndex]
    local linkId = linkItem:GetLinkID()
    if (string.IsNullOrEmpty(linkId)) then
        return
    end
    local linkMsg = base64.decode(linkId)
    linkMsg = rapidjson.decode(linkMsg)
    self:OnHandleLink(linkMsg)
end

function MailBlackKnightDetailTitle:OnClickShareBtn()
    if self.view.TryShareMail then
        self.view:TryShareMail()
    end
    --local maildata = self.view:GetCurrentMail()
    --MailShowHelper.TryShareMail(maildata)
end

function MailBlackKnightDetailTitle:OnHandleLink(linkMsg)
    if (linkMsg["action"] == "Jump") then
        self:OnMoveToPos(linkMsg)
    end
end

function MailBlackKnightDetailTitle:OnMoveToPos(linkMsg)
    local pointId = tonumber(linkMsg["pointId"]) or 1
    local serverId = linkMsg["server"] or LuaEntry.Player:GetCurServerId()
    local worldId = linkMsg["worldId"] or 0
    self.view.ctrl:OnClickPosBtn(pointId,serverId,worldId)
end


function MailBlackKnightDetailTitle:SetData( titledata )
    -- 设置数据
    local mainTitle = titledata["main"]
    local subTitle = titledata["sub"]
    local time = titledata["time"]
    local mailData = titledata["mailInfo"]
    local showShare = titledata["showShare"]
    local score = titledata["score"]
    self._txtScore:SetLocalText(GameDialogDefine.GET_SCORE_WITH, string.GetFormattedSeperatorNum(score))
    self.shareBtnN:SetActive(showShare)
    self._txtMainTitle:SetText(mainTitle)
    self._txtSubTitle:SetText("")
    self._txtSubTitle_Fight:SetActive(true)
    self._txtSubTitle_Fight:SetText(subTitle)
    self._txtTime:SetText(time)
    self._txtMainTitle_Fight:SetText(mainTitle)
    -- 检测邮件类型和胜负状态
    -- 检测邮件类型和胜负来显示主标题
    if mailData~=nil and (mailData.type == MailType.NEW_FIGHT or mailData.type == MailType.SHORT_KEEP_FIGHT_MAIL or mailData.type == MailType.NEW_FIGHT_ARENA or mailData.type == MailType.NEW_FIGHT_MINECAVE or mailData.type == MailType.MARCH_DESTROY_MAIL)then
        self._txtMainTitle_Fight:SetActive(true)
        self._txtMainTitle:SetActive(false)
        local resultState = mailData:GetMailExt():GetBattleResultStatus()
        if resultState == FightResult.SELF_WIN then
            self._txtMainTitle_Fight:SetColor(Const_Color_Green)
        elseif resultState == FightResult.OTHER_WIN then
            self._txtMainTitle_Fight:SetColor(WhiteColor)
        else
            self._txtMainTitle_Fight:SetColor(Const_Color_Red)
        end
    else
        self._txtMainTitle_Fight:SetActive(false)
        self._txtMainTitle:SetActive(true)
    end
end

return MailBlackKnightDetailTitle
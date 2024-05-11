---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/3/22 18:32
---
local MailPlayerReportTotal = BaseClass("MailPlayerReportTotal",UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting

local txt_name_left = "Left/txtNameLeft"
local txt_name_right = "Right/txtNameRight"
local txt_kill_left = "Left/txtKillLeft"
local txt_kill_num_left = "Left/txtKillNumLeft"
local txt_kill_right = "Right/txtKillRight"
local txt_kill_num_right = "Right/txtKillNumRight"


function MailPlayerReportTotal:OnCreate()
    base.OnCreate(self)
    self.txt_name_left = self:AddComponent(UITextMeshProUGUIEx, txt_name_left)
    self.txt_name_right = self:AddComponent(UITextMeshProUGUIEx, txt_name_right)
    self.txt_kill_left = self:AddComponent(UITextMeshProUGUIEx, txt_kill_left)
    self.txt_kill_num_left = self:AddComponent(UITextMeshProUGUIEx, txt_kill_num_left)
    self.txt_kill_right = self:AddComponent(UITextMeshProUGUIEx, txt_kill_right)
    self.txt_kill_num_right = self:AddComponent(UITextMeshProUGUIEx, txt_kill_num_right)
end

function MailPlayerReportTotal:OnEnable()
    base.OnEnable(self)
    self:InitDialog()
end

function MailPlayerReportTotal:InitDialog()
    self.txt_name_left:SetLocalText(310164)
    self.txt_name_right:SetLocalText(310165)
    self.txt_kill_left:SetLocalText(310176)
    self.txt_kill_right:SetLocalText(310176)
end

function MailPlayerReportTotal:OnDisable()
    base.OnDisable(self)
end

function MailPlayerReportTotal:SetData(maildata)
    self._mailId = maildata["uid"]
    local totalCount = maildata:GetMailExt():GetTotalRoundCnt()
    local totalLeftHurt = 0
    local totalRightHurt = 0
    for i=1,totalCount do
        local _showData = maildata:GetMailExt():GetShowRoundListDataByIndex(i)
        if (_showData ~= nil) then
            totalLeftHurt = totalLeftHurt+_showData.leftHurt
            totalRightHurt  = totalRightHurt +_showData.rightHurt
        end
    end
    self.txt_kill_num_left:SetText(string.GetFormattedSeperatorNum(math.floor(totalLeftHurt)))
    self.txt_kill_num_right:SetText(string.GetFormattedSeperatorNum(math.floor(totalRightHurt)))
end


return MailPlayerReportTotal
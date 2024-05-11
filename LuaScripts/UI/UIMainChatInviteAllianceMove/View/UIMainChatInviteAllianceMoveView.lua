--- Created by shimin
--- DateTime: 2023/8/15 21:51
--- 主界面聊天联盟邀请迁城Tip

local UIMainChatInviteAllianceMoveView = BaseClass("UIMainChatInviteAllianceMoveView", UIBaseView)
local base = UIBaseView
local AllianceFlagItem = require "UI.UIAlliance.UIAllianceFlag.Component.AllianceFlagItem"

local alFlag_path = "chatBubble/AllianceFlag"
local tipTxt_path = "chatBubble/tipTxt"
local redDot_path = "chatBubble/RedDot"
local redCount_path = "chatBubble/RedDot/redCount"
local jumpBtn_path = "chatBubble/Bg"

function UIMainChatInviteAllianceMoveView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

function UIMainChatInviteAllianceMoveView:ComponentDefine()
    self.alFlagN = self:AddComponent(AllianceFlagItem, alFlag_path)
    self.tipTxtN = self:AddComponent(UIText, tipTxt_path)
    self.tipTxtN:SetLocalText(391077)
    self.redDotN = self:AddComponent(UIBaseContainer, redDot_path)
    self.redDotN:SetActive(true)
    self.redCountN = self:AddComponent(UIText, redCount_path)
    self.redCountN:SetText(1)
    self.jumpBtnN = self:AddComponent(UIButton, jumpBtn_path)
    self.jumpBtnN:SetOnClick(function()
        self:OnClickJumpBtn()
    end)
end

function UIMainChatInviteAllianceMoveView:ComponentDestroy()
end

function UIMainChatInviteAllianceMoveView:DataDefine()
    self.delayTimer = nil
    self.delay_timer_callback = function()  
        self:DelayTimerCallback()
    end
end

function UIMainChatInviteAllianceMoveView:DataDestroy()
    self:RemoveDelayTimer()
end

function UIMainChatInviteAllianceMoveView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIMainChatInviteAllianceMoveView:OnEnable()
    base.OnEnable(self)
end

function UIMainChatInviteAllianceMoveView:OnDisable()
    base.OnDisable(self)
end

function UIMainChatInviteAllianceMoveView:OnAddListener()
    base.OnAddListener(self)
end

function UIMainChatInviteAllianceMoveView:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIMainChatInviteAllianceMoveView:ReInit()
    local delayT = LuaEntry.DataConfig:TryGetNum("union_move", "k5")
    delayT = delayT == 0 and 5 or delayT
    self:AddDelayTimer(delayT)
end

function UIMainChatInviteAllianceMoveView:OnClickJumpBtn()
    local param = {}
    param["roomId"] = ChatInterface.getRoomMgr():GetAllianceRoomId()
    self.ctrl:CloseSelf()
    GoToUtil.GotoOpenView(UIWindowNames.UIChatNew, {anim = false}, param)
end

function UIMainChatInviteAllianceMoveView:AddDelayTimer(time)
    if self.delayTimer == nil then
        self.delayTimer = TimerManager:GetInstance():GetTimer(time, self.delay_timer_callback, self, true, false, false)
        self.delayTimer:Start()
    end
end

function UIMainChatInviteAllianceMoveView:RemoveDelayTimer()
    if self.delayTimer ~= nil then
        self.delayTimer:Stop()
        self.delayTimer = nil
    end
end

function UIMainChatInviteAllianceMoveView:DelayTimerCallback()
    self:RemoveDelayTimer()
    self.ctrl:CloseSelf()
end

return UIMainChatInviteAllianceMoveView
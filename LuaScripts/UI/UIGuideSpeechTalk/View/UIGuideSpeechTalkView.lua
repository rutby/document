--- Created by shimin.
--- DateTime: 2023/11/28 14:45
--- 引导多组对话界面

local UIGuideSpeechTalkView = BaseClass("UIGuideSpeechTalkView", UIBaseView)
local base = UIBaseView
local UIGuideSpeechTalkCell = require "UI.UIGuideSpeechTalk.Component.UIGuideSpeechTalkCell"

local next_btn_path = "next_btn"
local content_path = "BG/Scroll View/Viewport/Content"

local ShowType =
{
    Left = 1,--左边
    Right = 2,--右边
}

--创建
function UIGuideSpeechTalkView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
function UIGuideSpeechTalkView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()      
    base.OnDestroy(self)
end

function UIGuideSpeechTalkView:ComponentDefine()
    self.next_btn = self:AddComponent(UIButton, next_btn_path)
    self.next_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnNextBtnClick()
    end)
    self.content = self:AddComponent(UIBaseContainer, content_path)
end

function UIGuideSpeechTalkView:ComponentDestroy()
end

function UIGuideSpeechTalkView:DataDefine()
    self.param = {}
    self.auto_to_do_next_timer_action = function()
        self:AutoDoNextTimerAction()
    end
    self.index = 1
end

function UIGuideSpeechTalkView:DataDestroy()
    self:DeleteAutoDoNextTimer()
    self.param = {}
    self.index = 1
end

function UIGuideSpeechTalkView:OnEnable()
    base.OnEnable(self)
    self:ReInit()
end

function UIGuideSpeechTalkView:OnDisable()
    base.OnDisable(self)
end

function UIGuideSpeechTalkView:ReInit()
    self.param = self:GetUserData()
    self:Refresh()
end

function UIGuideSpeechTalkView:OnAddListener()
    base.OnAddListener(self)
end

function UIGuideSpeechTalkView:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIGuideSpeechTalkView:AddAutoDoNextTimer(time)
    self:DeleteAutoDoNextTimer()
    self.autoDoNextTimer = TimerManager:GetInstance():GetTimer(time, self.auto_to_do_next_timer_action , self, true,false,false)
    self.autoDoNextTimer:Start()
end

function UIGuideSpeechTalkView:AutoDoNextTimerAction()
    self:DeleteAutoDoNextTimer()
    self.ctrl:CloseSelf()
end

function UIGuideSpeechTalkView:DeleteAutoDoNextTimer()
    if self.autoDoNextTimer then
        self.autoDoNextTimer:Stop()
        self.autoDoNextTimer = nil
    end
end

function UIGuideSpeechTalkView:Refresh()
    local cellParam = self.param.list[self.index]
    if cellParam ~= nil then
        local prefabName
        if cellParam.showType == ShowType.Right then
            prefabName = UIAssets.UIGuideSpeechTalkRightCell
        else
            prefabName = UIAssets.UIGuideSpeechTalkLeftCell
        end
        self:GameObjectInstantiateAsync(prefabName, function(request)
            if request.isError then
                return
            end
            local go = request.gameObject
            SoundUtil.PlayEffect(SoundAssets.Music_Effect_Guide_Talk)
            go:SetActive(true)
            go.transform:SetParent(self.content.transform)
            go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            go.transform:SetAsLastSibling()
            local nameStr = tostring(NameCount)
            go.name = nameStr
            NameCount = NameCount + 1
            local model = self.content:AddComponent(UIGuideSpeechTalkCell, nameStr)
            model:ReInit(cellParam)
        end)
    end
end

function UIGuideSpeechTalkView:OnNextBtnClick()
    self.index = self.index + 1
    if self.param.list[self.index] == nil then
        local callback = self.param.callback
        self.ctrl:CloseSelf()
        if callback ~= nil then
            callback()
        end
    else
        self:Refresh()
    end
end

return UIGuideSpeechTalkView
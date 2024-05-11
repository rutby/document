--- Created by shimin.
--- DateTime: 2023/11/28 14:45
--- 引导多组对话界面

local UIGuideSpeechTalkCtrl = BaseClass("UIGuideSpeechTalkCtrl", UIBaseCtrl)

function UIGuideSpeechTalkCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGuideSpeechTalk, { anim = true , playEffect = false})
end

return UIGuideSpeechTalkCtrl
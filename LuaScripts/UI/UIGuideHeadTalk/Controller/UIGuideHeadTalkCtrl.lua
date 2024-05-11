---
--- Created by shimin.
--- DateTime: 2021/11/10 12:28
--- 引导头像Tip对话界面
---

local UIGuideHeadTalkCtrl = BaseClass("UIGuideHeadTalkCtrl", UIBaseCtrl)

function UIGuideHeadTalkCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGuideHeadTalk,{ anim = true , playEffect = false})
end

return UIGuideHeadTalkCtrl
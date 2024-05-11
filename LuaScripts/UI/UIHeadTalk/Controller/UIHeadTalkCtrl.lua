---
--- 头像对话界面
--- Created by shimin.
--- DateTime: 2022/9/2 15:08
---

local UIHeadTalkCtrl = BaseClass("UIHeadTalkCtrl", UIBaseCtrl)

function UIHeadTalkCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeadTalk,{ anim = true , playEffect = false})
end

return UIHeadTalkCtrl
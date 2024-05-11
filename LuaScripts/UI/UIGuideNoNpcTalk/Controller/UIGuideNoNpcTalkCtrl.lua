---
--- Created by shimin.
--- DateTime: 2022/6/20 21:54
--  引导旁白对话
---

local UIGuideNoNpcTalkCtrl = BaseClass("UIGuideNoNpcTalkCtrl", UIBaseCtrl)

function UIGuideNoNpcTalkCtrl:CloseSelf()
    UIManager.Instance:DestroyWindow(UIWindowNames.UIGuideNoNpcTalk)
end

return UIGuideNoNpcTalkCtrl
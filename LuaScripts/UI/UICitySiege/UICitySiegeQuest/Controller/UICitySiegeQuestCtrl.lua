---
--- Created by Beef
--- DateTime: 2024/4/2 11:20
---

local UICitySiegeQuestCtrl = BaseClass("UICitySiegeQuestCtrl", UIBaseCtrl)

function UICitySiegeQuestCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UICitySiegeQuest)
end

return UICitySiegeQuestCtrl
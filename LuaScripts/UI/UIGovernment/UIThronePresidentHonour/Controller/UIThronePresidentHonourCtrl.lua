--- Created by shimin
--- DateTime: 2023/3/21 15:09
--- 王座荣耀殿堂界面

local UIThronePresidentHonourCtrl = BaseClass("UIThronePresidentHonourCtrl", UIBaseCtrl)

function UIThronePresidentHonourCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIThronePresidentHonour)
end

return UIThronePresidentHonourCtrl
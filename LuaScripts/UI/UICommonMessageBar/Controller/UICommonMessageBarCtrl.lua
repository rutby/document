---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/11/9 17:30
---
local UICommonMessageBarCtrl = BaseClass("UICommonMessageBarCtrl", UIBaseCtrl)
local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonMessageBar,{anim = true,playEffect = false})
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end


UICommonMessageBarCtrl.CloseSelf =CloseSelf
UICommonMessageBarCtrl.Close =Close

return UICommonMessageBarCtrl
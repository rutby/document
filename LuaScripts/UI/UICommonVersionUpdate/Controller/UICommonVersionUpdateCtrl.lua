---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl.
--- DateTime:
---
local UICommonVersionUpdateCtrl = BaseClass("UICommonVersionUpdateCtrl", UIBaseCtrl)
function UICommonVersionUpdateCtrl:CloseSelf(isNoDoAnim)
    if noPlayCloseEffect then
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonVersionUpdate,{anim = true,playEffect = false})
    else
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonVersionUpdate)
    end
end

function UICommonVersionUpdateCtrl:Close()
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end
return UICommonVersionUpdateCtrl
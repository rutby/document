---
--- Created by shimin.
--- DateTime: 2020/10/19 17:04
---

local UIChangeMailCtrl = BaseClass("UIChangeMailCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization
local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChangeMail)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

--检验密码
local function CheckPwd(self,pwd1)
    if pwd1 == nil or pwd1 == "" then
        UIUtil.ShowTipsId(280121) 
        return false
    else
        local num = string.len(pwd1)
        if num < 8 or num > 15 then
            UIUtil.ShowTipsId(280119) 
            return false
        end
    end
    return true
end



UIChangeMailCtrl.CloseSelf = CloseSelf
UIChangeMailCtrl.Close = Close
UIChangeMailCtrl.CheckPwd = CheckPwd

return UIChangeMailCtrl
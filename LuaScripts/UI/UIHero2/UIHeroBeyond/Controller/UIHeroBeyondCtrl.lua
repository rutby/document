---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zhangliheng.
--- DateTime: 2021/10/14 下午6:48
---



local UIHeroBeyondCtrl = BaseClass("UIHeroBeyondCtrl", UIBaseCtrl)

local function CloseSelf(self)
    if self.callback then
        self.callback()
    end
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroBeyond)
end

UIHeroBeyondCtrl.CloseSelf = CloseSelf

return UIHeroBeyondCtrl
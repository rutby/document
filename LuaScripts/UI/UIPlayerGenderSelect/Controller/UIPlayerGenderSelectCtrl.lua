--- 修改性别界面
--- Created by shimin.
--- DateTime: 2023/1/12 18:21

local UIPlayerGenderSelectCtrl = BaseClass("UIPlayerGenderSelectCtrl", UIBaseCtrl)

function UIPlayerGenderSelectCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPlayerGenderSelect)
end

return UIPlayerGenderSelectCtrl
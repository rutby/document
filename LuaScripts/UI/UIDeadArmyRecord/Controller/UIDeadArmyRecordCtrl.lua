--- 查看死亡士兵记录界面
--- Created by shimin.
--- DateTime: 2023/1/31 18:46

local UIDeadArmyRecordCtrl = BaseClass("UIDeadArmyRecordCtrl", UIBaseCtrl)

function UIDeadArmyRecordCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDeadArmyRecord)
end

return UIDeadArmyRecordCtrl
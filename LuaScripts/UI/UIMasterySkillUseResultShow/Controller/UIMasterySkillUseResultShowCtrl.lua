--- Created by shimin
--- DateTime: 2023/4/10 18:12
--- 专精技能使用后显示结果界面

local UIMasterySkillUseResultShowCtrl = BaseClass("UIMasterySkillUseResultShowCtrl", UIBaseCtrl)

function UIMasterySkillUseResultShowCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMasterySkillUseResultShow)
end

return UIMasterySkillUseResultShowCtrl
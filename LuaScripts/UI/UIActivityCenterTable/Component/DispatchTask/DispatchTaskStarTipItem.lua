
---@class DispatchTaskStarTipItem : UIBaseContainer
local DispatchTaskStarTipItem = BaseClass("DispatchTaskStarTipItem",UIBaseContainer)
local base = UIBaseContainer

local star11_path = "star/starList/star11"
local star12_path = "star/starList/star12"
local star13_path = "star/starList/star13"
local star14_path = "star/starList/star14"
local star15_path = "star/starList/star15"
local task_rate_path = "taskRate"
local task_level_path = "taskLevel"

function DispatchTaskStarTipItem:OnCreate()
    base.OnCreate(self)
    self.star1 = self:AddComponent(UIImage, star11_path)
    self.star2 = self:AddComponent(UIImage, star12_path)
    self.star3 = self:AddComponent(UIImage, star13_path)
    self.star4 = self:AddComponent(UIImage, star14_path)
    self.star5 = self:AddComponent(UIImage, star15_path)
    self.task_rate = self:AddComponent(UITextMeshProUGUIEx, task_rate_path)
    self.task_level = self:AddComponent(UITextMeshProUGUIEx, task_level_path)
    self.roateTxt = self:AddComponent(UITextMeshProUGUIEx,"roateTxt")
    self.roateTxt:SetLocalText(461019)
    self.level_txt = self:AddComponent(UITextMeshProUGUIEx,"levelTxt")
    self.level_txt:SetLocalText(461020)
end

function DispatchTaskStarTipItem:OnDestroy()
    base.OnDestroy(self)
end

function DispatchTaskStarTipItem:ReInit(starLevel)
    self.star1:SetActive(starLevel >= 1)
    self.star2:SetActive(starLevel >= 2)
    self.star3:SetActive(starLevel >= 3)
    self.star4:SetActive(starLevel >= 4)
    self.star5:SetActive(starLevel >= 5)
    -- k2=探索星级和橙色任务出现概率的对应关系，星级;概率|星级;概率
    local rate = DataCenter.ActDispatchTaskDataManager:GetTaskRateWithStarLevel(starLevel)
    self.task_rate:SetText(rate)
    -- k3=探索星级和任务等级的对应关系，星级;等级|星级;等级
    local level = DataCenter.ActDispatchTaskDataManager:GetTaskLevelWithStarLevel(starLevel)
    self.task_level:SetText(level)
end

return DispatchTaskStarTipItem

local UIHeroPVPArena3V3Container = BaseClass("UIHeroPVPArena3V3Container", UIBaseContainer)
local base = UIBaseContainer

local Localization = CS.GameEntry.Localization

-- 创建
function UIHeroPVPArena3V3Container:OnCreate(isDef)
    base.OnCreate(self)
    self:ComponentDefine()
    self.isDef = isDef
    if not isDef then
        self.isDef = true
    end
end

-- 销毁
function UIHeroPVPArena3V3Container:OnDestroy()
    self:ComponentDestroy()
    base.OnDestroy(self)
end

function UIHeroPVPArena3V3Container:ComponentDefine()
    
    local pageTogglePath = "Pages/PageToggle%d"
    local pageToggleSelectedPath = "Pages/PageToggle%d/Selected%d"
    local pageToggleUnselectedPath = "Pages/PageToggle%d/Unselected%d"

    self.pageToggles = {}
    self.pageToggleSelecteds = {}
    self.pageToggleUnselecteds = {}
    for i=1,3 do
        self.pageToggles[i] = self:AddComponent(UIBaseContainer, string.format(pageTogglePath, i))
        self.pageToggleSelecteds[i] = self:AddComponent(UIBaseContainer, string.format(pageToggleSelectedPath, i,i))
        self.pageToggleUnselecteds[i] = self:AddComponent(UIButton, string.format(pageToggleUnselectedPath, i,i))
        self.pageToggleUnselecteds[i]:SetOnClick(function()
            self.view:ChangeSquadIndex(i)
        end)
    end

    self.orderBtn = self:AddComponent(UIButton, "OrderBtn")
    self.orderBtn:SetOnClick(function()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWArena3V3DefenseTeamOrder)
    end)
    self.saveBtn = self:AddComponent(UIButton, "SaveBtn")
    self.saveBtn:SetOnClick(function()
        self.view:OnSaveBtnClick()
    end)
end

function UIHeroPVPArena3V3Container:ComponentDestroy()

end

function UIHeroPVPArena3V3Container:RefreshShow(squadIndex)
    self.squadIndex = squadIndex
    if not self.squadIndex then
        return
    end
    for i=1,3 do
        self.pageToggleSelecteds[i]:SetActive(self.squadIndex == i)
        self.pageToggleUnselecteds[i]:SetActive(self.squadIndex ~= i)
    end
end

return UIHeroPVPArena3V3Container
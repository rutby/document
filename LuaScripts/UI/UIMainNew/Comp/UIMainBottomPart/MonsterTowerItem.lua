---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by admin.
--- DateTime: 2024/3/21 14:44
---
local MonsterTowerItem = BaseClass("WarningItem", UIBaseContainer)
local base = UIBaseContainer

local btn_path = ""
local red_go_path = "RedDot"
local red_num_path = "RedDot/DotText"

function MonsterTowerItem:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self.timer_action = function()
        self:RefreshTime()
    end
end

function MonsterTowerItem:OnDestroy()
    self:ComponentDestroy()
    base.OnDestroy(self)
end

function MonsterTowerItem:OnEnable()
    base.OnEnable(self)
    self:AddTimer()
end

function MonsterTowerItem:OnDisable()
    self:DeleteTimer()
    base.OnDisable(self)
end

function MonsterTowerItem:ComponentDefine()
    self.btn = self:AddComponent(UIButton, btn_path)
    self.btn:SetOnClick(function ()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickBtn()
    end)
    self.red_go = self:AddComponent(UIBaseContainer, red_go_path)
    self.red_num = self:AddComponent(UITextMeshProUGUIEx, red_num_path)
end

function MonsterTowerItem:ComponentDestroy()

end

function MonsterTowerItem:AddTimer()
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action , self, false,false,false)
    end
    self.timer:Start()
end

function MonsterTowerItem:DeleteTimer()
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

function MonsterTowerItem:RefreshTime()
    local deltaTime = self.endTime - UITimeManager:GetInstance():GetServerTime()
    if deltaTime <= 0 then
        self:SetActive(false)
    end
end

function MonsterTowerItem:OnClickBtn()
    GoToUtil.GoActWindowByType(tonumber(ActivityEnum.ActivityType.MonsterTower))
end

function MonsterTowerItem:Refresh(activityId,actData)
    self.activityId = activityId
    self.monsterTowerData = DataCenter.ActMonsterTowerData:GetInfoByActId(tonumber(activityId))
    self.endTime = actData.endTime
    --if monsterTowerType == WarningType.AllianceAttack then
    --    self.red_go:SetActive(true)
    --    local warCount = DataCenter.AllianceWarDataManager:GetAllianceWarCount()
    --    warCount = warCount + DataCenter.AllianceAlertDataManager:GetAlertNum()
    --    self.red_num:SetText(warCount)
    --else
    --    self.red_go:SetActive(false)
    --end
end

return MonsterTowerItem


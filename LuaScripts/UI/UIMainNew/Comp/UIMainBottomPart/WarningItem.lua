--- Created by shimin.
--- DateTime: 2024/2/20 14:35
--- 警报
local WarningItem = BaseClass("WarningItem", UIBaseContainer)
local base = UIBaseContainer

local btn_path = ""
local warning_img_path = "warning_img"
local red_go_path = "RedDot"
local red_num_path = "RedDot/DotText"

function WarningItem:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self.timer_action = function(temp)
        self:RefreshTime()
    end
end

function WarningItem:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function WarningItem:OnEnable()
    base.OnEnable(self)
    self:AddTimer()
end

function WarningItem:OnDisable()
    self:DeleteTimer()
    base.OnDisable(self)
end

function WarningItem:ComponentDefine()
    self.btn = self:AddComponent(UIButton, btn_path)
    self.btn:SetOnClick(function ()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickBtn()
    end)
    self.warning_img = self:AddComponent(UIImage, warning_img_path)
    self.red_go = self:AddComponent(UIBaseContainer, red_go_path)
    self.red_num = self:AddComponent(UITextMeshProUGUIEx, red_num_path)
    self.time_txt = self:AddComponent(UITextMeshProUGUIEx,"time_txt")
end

function WarningItem:ComponentDestroy()

end

function WarningItem:DataDefine()
    self.warningType = nil
    self.img_callback = function()
        self.warning_img:SetNativeSize()
    end
end

function WarningItem:DataDestroy()

end

function WarningItem:OnClickBtn()
    if self.warningType == WarningType.AllianceAttack then
        if DataCenter.AllianceWarDataManager:GetLastRedNum() > 0 or DataCenter.AllianceAlertDataManager:GetLastRedNum() > 0 then    --这里要拿准确的数量
            DataCenter.AllianceWarDataManager:SetLastNumClickView(true)
            DataCenter.AllianceAlertDataManager:SetLastNumClickView(true)
            EventManager:GetInstance():Broadcast(EventId.RefreshAlertUI)
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceWarMainTable,{ anim = true, hideTop = true },3)
        else
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceWarMainTable,{ anim = true, hideTop = true },2)
        end
    else
        GoToUtil.GotoOpenView(UIWindowNames.UIAllianceWarPersonalList, NormalBlurPanelAnim)
    end
end

function WarningItem:ReInit()
    self:Refresh()
end

function WarningItem:Refresh(warningType)
    self.warningType = warningType
    if warningType == nil then
        self:SetActive(false)
    else
        self:SetActive(true)
        local icon = nil
        if warningType == WarningType.Attack then
            icon = string.format(LoadPath.UIMain, "UIMain_icon_junqing_attack")
        elseif warningType == WarningType.Scout then
            icon = string.format(LoadPath.UIMain, "UIMain_icon_junqing_zhencha")
        elseif warningType == WarningType.AllianceAttack then
            icon = string.format(LoadPath.UIMain, "UIMain_icon_rally")
        else
            icon = string.format(LoadPath.UIMain, "UIMain_icon_junqing_attack")
        end
        
        self.warning_img:LoadSprite(icon, nil, self.img_callback)
        
        if warningType == WarningType.AllianceAttack then
            self.red_go:SetActive(true)
            local warCount = DataCenter.AllianceWarDataManager:GetAllianceWarCount()
            warCount = warCount + DataCenter.AllianceAlertDataManager:GetAlertNum()
            self.red_num:SetText(warCount)
        else
            self.red_go:SetActive(false)
        end
        self:RefreshRallyTime()
    end
end

function WarningItem:AddTimer()
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action , self, false,false,false)
    end
    self.timer:Start()
end

function WarningItem:DeleteTimer()
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end
function WarningItem:RefreshTime()
    if self.isUpdate == true then
        if self.endTime >0 then
            local deltaTime = self.endTime-UITimeManager:GetInstance():GetServerTime()
            if deltaTime>0 then
                self.time_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
            else
                self.isUpdate = false
                self:RefreshRallyTime()
            end
        end
    end
end

function WarningItem:RefreshRallyTime()
    self.isUpdate = false
    self.endTime = 0
    self.time_txt:SetText("")
    if self.warningType == WarningType.AllianceAttack then
        local data = DataCenter.AllianceWarDataManager:GetOldestCanJoinRallyData()
        if data~=nil then
            if data.waitTime~=nil and data.waitTime >UITimeManager:GetInstance():GetServerTime() then
                self.endTime = data.waitTime
                self.isUpdate = true
                self:RefreshTime()
            end
        end
    end
end
return WarningItem

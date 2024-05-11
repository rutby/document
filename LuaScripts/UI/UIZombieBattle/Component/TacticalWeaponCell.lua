--- Author: tengxichen
--- DateTime: 2023/2/16
--- Des: 推图战术武器头像UIComponent
---@class UI.UIZombieBattle.Component.TacticalWeaponCell
local TacticalWeaponCell = BaseClass("TacticalWeaponCell", UIBaseContainer)
local base = UIBaseContainer

local Screen = CS.UnityEngine.Screen
local NORMAL_SCALE = 0.8
local BIG_SCALE = 0.95
local TANK_HEIGHT = Vector3.New(0,80,0)


function TacticalWeaponCell:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

function TacticalWeaponCell:OnDestroy()
    self:DataDestroy()
    self:ComponentDestroy()
    base.OnDestroy(self)
end

function TacticalWeaponCell:ComponentDefine()
    self.btn = self:AddComponent(UIButton, "")
    self.icon = self:AddComponent(UIImage, "TacticalWeaponIcon")
    self.btn:SetOnClick(function()
        if self.member then
            local selfEquips = DataCenter.TacticalWeaponManager:GetAllSelfWearingEquips()
            UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTacticalWeaponTip,{ anim = true},self.member.weaponData,selfEquips,self.icon)
        end
    end)
    self.animator = self:AddComponent(UIAnimator, "")
    self.animator:Play("Eff_ui_jinengshifang_default",0,0)--重置一下
    self.mask = self:AddComponent(UIImage, "TacticalWeaponCoolDownMask")
    self.levelNumberText = self:AddComponent(UIText, "TacticalWeaponLevelNumberText")
    self.skillBubble = self:AddComponent(UIAnimator, "Eff_UI_jinengshifang")
    self.skillBubble:SetActive(false)
    self.skillImg2 = self:AddComponent(UIImage, "Eff_UI_jinengshifang/Image/Image")
end

function TacticalWeaponCell:ComponentDestroy()
    self.btn = nil
    self.icon = nil
    self.animator = nil
    self.mask = nil
    self.levelNumberText = nil
    self.skillBubble = nil
    self.skillImg2 = nil
end

function TacticalWeaponCell:DataDefine()
    self.timeStopDuration=0
    self.skillCD=1
end

function TacticalWeaponCell:DataDestroy()
    if self.loopAnim then
        self.loopAnim:Stop()
        self.loopAnim=nil
    end
    if self.updateTimer ~= nil then
        UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
        self.updateTimer = nil
    end
    self.member=nil
    self.skill=nil
end

function TacticalWeaponCell:OnZombieBattleDestroy()
    if self.updateTimer ~= nil then
        UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
        self.updateTimer = nil
    end
end

function TacticalWeaponCell:OnUpdate()
    -- local curHP,maxHP=self.member:GetCurAndMaxHp()
    -- self.hpImg:SetFillAmount(curHP/maxHP)
    -- if curHP<=0 then
    --     CS.UIGray.SetGray(self.icon.transform, true, true)
    --     self.cdImg:SetFillAmount(0)
    --     self.cdText:SetText("")
    --     self.animator:Play("Eff_ui_jinengshifang_default",0,0)
    --     self.skillBubble:SetActive(false)
    --     self:DataDestroy()
    --     return
    -- end
    
    if self.skill then
        local curCD,maxCD=self.skill:GetCurAndMaxCD()
        
        if curCD>0.4 then
            self.mask:SetFillAmount(curCD/maxCD)
            -- self.cdText:SetText(string.format("%.1fs", curCD))
        elseif curCD>0 then--curCD在(0，0.4]区间内，马上cd转好
            self.mask:SetFillAmount(curCD/maxCD)
            -- self.cdText:SetText(string.format("%.1fs", curCD))

            if self.skillCD>0.4 then
                self.animator:Play("Eff_ui_jinengshifang_tubiaojineng_daiji",0,0)
                self.loopAnim = TimerManager:GetInstance():DelayInvoke(function()
                    self.animator:Play("Eff_ui_jinengshifang_tubiao_kuang_daiji",0,0)
                end, 0.5)
            end
            
        else--curCD<=0
            self.mask:SetFillAmount(0)
            -- self.cdText:SetText("")

            if self.member:UltimateIsReady() then
                self:OnClick()
            end
        end
        self.skillCD=curCD
        
        if self.timeStopDuration>0 then
            self.timeStopDuration = self.timeStopDuration - Time.deltaTime
            self:SetBubblePos()
        end
    end

end


function TacticalWeaponCell:OnEnable()
    base.OnEnable(self)
end

function TacticalWeaponCell:OnDisable()
    base.OnDisable(self)
    if self.updateTimer ~= nil then
        UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
        self.updateTimer = nil
    end
end

function TacticalWeaponCell:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.ZombieBattleDestroy, self.OnZombieBattleDestroy)
end

function TacticalWeaponCell:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.ZombieBattleDestroy, self.OnZombieBattleDestroy)
end

function TacticalWeaponCell:SetData(member)
    if member then
        self:SetActive(true)
        self.levelNumberText:SetText(string.format("Lv.%d", member.weaponData.level))
        self.member=member---@type Scene.LWBattle.BarrageBattle.Unit.TacticalWeaponMember
        self.skill=member.skillManager:GetUltimateSkill()
        -- self.icon:SetData(member.hero.uuid,function() self:OnClick() end)
        -- self.bg:SetLocalScaleXYZ(NORMAL_SCALE,NORMAL_SCALE,NORMAL_SCALE)
        self.mask:SetFillAmount(0)
        -- self.cdText:SetText("")
        if self.skill then
            -- self.skillImg:LoadSprite(self.skill.meta.icon)
            self.skillImg2:LoadSprite(self.skill.meta.icon)
        end

        if not self.updateTimer then
            self.updateTimer = function() self:OnUpdate() end
            UpdateManager:GetInstance():AddUpdate(self.updateTimer)
        end
    else
        self:SetActive(false)
    end
end


function TacticalWeaponCell:OnClick()
    --if self.view:IsTimeStopCD() then
    --    return
    --end
    if not self.member then
        return
    end
    
    --下达指令：施放大招
    local success = self.member:HandleInput(MemberCommand.Ultimate)

    if success then
        if self.loopAnim then
            self.loopAnim:Stop()
            self.loopAnim=nil
        end
        self.animator:Play("Eff_ui_jinengshifang_tubiaojineng",0,0)
        -- DataCenter.LWSoundManager:PlaySound(10016)
        --self.skillNode:SetActive(true)
        --self.bg:SetLocalScaleXYZ(NORMAL_SCALE,NORMAL_SCALE,NORMAL_SCALE)
        --self.ring:SetActive(false)

        --local screenPos = CS.UnityEngine.Camera.main:WorldToScreenPoint(worldPos)
        --local x = screenPos.x/Screen.width
        --local y = screenPos.y/Screen.height
        --worldPos.y=worldPos.y+5

        self.timeStopDuration=self.member:GetUltimateTimeStopDuration()
        -- self.view:Spot(self.member,self.timeStopDuration)
        --self:SetBubblePos()
        --self.skillBubble:SetActive(true)
        --self.skillBubble:SetLocalScaleXYZ(0.4,0.4,0.4)
        --self.skillBubble:Play("Eff_ui_jinengshifang_show",0,0)
        --self.view:Spot(2,2,1,skillWorldPos,skill.meta.icon)
        --self.view:SetTimeStopCD()
    end
end

function TacticalWeaponCell:SetBubblePos()
    local worldPos = self.member:GetPosition()
    local skillWorldPos = CS.CSUtils.WorldPositionToUISpacePosition(worldPos) + TANK_HEIGHT
    self.skillBubble:SetPosition(skillWorldPos)
end

return TacticalWeaponCell

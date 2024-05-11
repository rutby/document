--- Created by shimin
--- DateTime: 2023/5/29 21:50
--- 装饰建筑抽奖概率界面cell

local UIHeroPluginDesRandomWithCell = BaseClass("UIHeroPluginDesRandomWithCell", UIBaseContainer)
local base = UIBaseContainer
local UIHeroTipsView = require "UI.UIHeroTips.View.UIHeroTipsView"

local show_text_path = "LeftLayoutGo/show_text"
local show_special_text_path = "LeftLayoutGo/show_special_text"
local lock_img_path = "LeftLayoutGo/SelectGo/SelectBtn/LockImg"
local lock_text_path = "RightLayoutGo/lock_text"
local text_btn_path = "LeftLayoutGo"
local select_go_path = "LeftLayoutGo/SelectGo"
local lock_btn_path = "LeftLayoutGo/SelectGo/SelectBtn"
local info_btn_path = "RightLayoutGo/Common_btn_info"
local rhombus_go_path = "LeftLayoutGo/rhombus_go"
local rhombus_img_path = "LeftLayoutGo/rhombus_go/rhombus_img"
local max_go_path = "RightLayoutGo/max_go"
local this_path = ""
local effect_go_path = "LeftLayoutGo/EffectGo"

local LockIconName = "UI_cj_suo"
local UnlockIconName = "UI_cj_meisuo"

function UIHeroPluginDesRandomWithCell:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIHeroPluginDesRandomWithCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIHeroPluginDesRandomWithCell:OnEnable()
    base.OnEnable(self)
end

function UIHeroPluginDesRandomWithCell:OnDisable()
    base.OnDisable(self)
end

function UIHeroPluginDesRandomWithCell:ComponentDefine()
    self.select_btn = self:AddComponent(UIButton, lock_btn_path)
    self.select_btn:SetOnClick(function()
        self:OnSelectBtnClick()
    end)
    self.select_go = self:AddComponent(UIBaseContainer, select_go_path)
    self.info_btn = self:AddComponent(UIButton, info_btn_path)
    self.info_btn:SetOnClick(function()
        self:OnInfoBtnClick()
    end)
    self.show_text = self:AddComponent(UIText, show_text_path)
    self.show_special_text = self:AddComponent(UIText, show_special_text_path)
    self.lock_img = self:AddComponent(UIImage, lock_img_path)
    self.lock_text = self:AddComponent(UIText, lock_text_path)
    self.text_btn = self:AddComponent(UIButton, text_btn_path)
    self.text_btn:SetOnClick(function()
        self:OnTextBtnClick()
    end)
    self.rhombus_go = self:AddComponent(UIBaseContainer, rhombus_go_path)
    self.rhombus_img = self:AddComponent(UIImage, rhombus_img_path)
    self.max_go = self:AddComponent(UIBaseContainer, max_go_path)
    self.anim = self:AddComponent(UIAnimator, this_path)
    self.effect_go = self:AddComponent(UIBaseContainer, effect_go_path)
end

function UIHeroPluginDesRandomWithCell:ComponentDestroy()
end

function UIHeroPluginDesRandomWithCell:DataDefine()
    self.param = {}
    self.noClick = false
    self.delay_timer_callback = function()  
        self:DelayTimerCallback()
    end
    self.max_delay_timer_callback = function()
        self:MaxDelayTimerCallback()
    end
    self.effect = nil
end

function UIHeroPluginDesRandomWithCell:DataDestroy()
    self:RemoveEffect()
    self:RemoveDelayTimer()
    self:RemoveMaxDelayTimer()
    self.param = {}
    self.noClick = false
    self.effect = nil
end

function UIHeroPluginDesRandomWithCell:OnAddListener()
    base.OnAddListener(self)
end

function UIHeroPluginDesRandomWithCell:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIHeroPluginDesRandomWithCell:ReInit(param)
    self.param = param
    self:Refresh()
end

function UIHeroPluginDesRandomWithCell:Refresh()
    self:RemoveDelayTimer()
    self:RemoveMaxDelayTimer()
    self.noClick = false
    if self.param.visible then
        self:SetActive(true)
        if self.param.data ~= nil then
            if self.param.data.needUnlock then
                self.lock_text:SetActive(true)
                self.lock_text:SetText(self.param.data.showValue)
            else
                self.lock_text:SetActive(false)
            end
            local showStr = ""
            if self.param.data.isSpecial then
                self.show_text:SetActive(false)
                self.show_special_text:SetActive(true)
                self.show_special_text:SetText(self.param.data.showName)
                showStr = self.show_special_text:GetText()
                self.rhombus_go:SetActive(true)
                self.rhombus_img:LoadSprite(DataCenter.HeroPluginManager:GetRhombusNameByQuality(self.param.data.quality), nil, function()
                    self.rhombus_img:SetNativeSize()
                end)
            else
                self.show_text:SetActive(true)
                self.show_text:SetText(self.param.data.showName)
                self.show_special_text:SetActive(false)
                showStr = self.show_text:GetText()
                if self.param.data.useSelect then
                    self.rhombus_go:SetActive(false)
                else
                    self.rhombus_go:SetActive(true)
                    self.rhombus_img:LoadSprite(DataCenter.HeroPluginManager:GetRhombusNameByQuality(self.param.data.quality), nil, function()
                        self.rhombus_img:SetNativeSize()
                    end)
                end
            end
            
            if string.contains(showStr, UseOmitBtnStr) then
                self.text_btn:SetInteractable(true)
            else
                self.text_btn:SetInteractable(false)
            end
            if self.param.data.useSelect then
                self.select_go:SetActive(true)
                self:RefreshSelect()
            else
                self.select_go:SetActive(false)
            end

            if self.param.data.isMax and self.param.data.maxTime ~= nil and self.param.data.maxTime > 0 then
                self.max_go:SetActive(false)
                self.info_btn:SetActive(false)
                self:AddMaxDelayTimer(self.param.data.maxTime)
            elseif self.param.data.isMax then
                self.max_go:SetActive(true)
                self.info_btn:SetActive(false)
            else
                self.max_go:SetActive(false)
                if self.param.data.infoText ~= nil then
                    self.info_btn:SetActive(true)
                else
                    self.info_btn:SetActive(false)
                end
            end
            
            if self.param.data.delayTime ~= nil and self.param.data.delayTime ~= 0 then
                self:PlayAnim(HeroPluginUpgradeAnimName.Hide)
                self:AddEffect()
                self:AddDelayTimer(self.param.data.delayTime)
            end
        end
    else
        self:SetActive(false)
    end
end

function UIHeroPluginDesRandomWithCell:OnSelectBtnClick()
    if not self.noClick then
        if DataCenter.HeroPluginManager:IsUnlockLock(self.param.data.camp, self.param.data.heroUuid) then
            if DataCenter.HeroPluginManager:CanSetLock(self.param.data.heroUuid, not self.param.data.select) then
                self.noClick = true
                self.param.data.select = not self.param.data.select
                self:RefreshSelect()
                if self.param.data.select then
                    DataCenter.HeroPluginManager:SendLockHeroPlugin(self.param.data.heroUuid, self.param.data.index)
                else
                    DataCenter.HeroPluginManager:SendUnlockHeroPlugin(self.param.data.heroUuid, self.param.data.index)
                end
            else
                UIUtil.ShowTipsId(GameDialogDefine.HERO_PLUGIN_LOCK_FUNCTION_REACH_MAX)
            end
        else
            UIUtil.ShowTipsId(GameDialogDefine.HERO_PLUGIN_LOCK_FUNCTION_NEED)
        end
    end
end

function UIHeroPluginDesRandomWithCell:Select(select)
    self.param.data.select = select
    self:RefreshSelect()
end

function UIHeroPluginDesRandomWithCell:RefreshSelect()
    if self.param.data.select then
        self.lock_img:LoadSprite(string.format(LoadPath.HeroAdvancePath, LockIconName))
    else
        self.lock_img:LoadSprite(string.format(LoadPath.HeroAdvancePath, UnlockIconName))
    end
end

function UIHeroPluginDesRandomWithCell:OnInfoBtnClick()
    local param = UIHeroTipsView.Param.New()
    param.content = self.param.data.infoText
    param.dir = UIHeroTipsView.Direction.ABOVE
    param.defWidth = 500
    param.pivot = 0.5
    param.position = self.info_btn.transform.position + Vector3.New(0, 20, 0)
    param.bindObject = self.info_btn.gameObject
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTips, { anim = false }, param)
end


function UIHeroPluginDesRandomWithCell:OnTextBtnClick()
    local param = UIHeroTipsView.Param.New()
    param.content = self.param.data.showName
    param.dir = UIHeroTipsView.Direction.ABOVE
    param.defWidth = 500
    param.pivot = 0.5
    param.position = self.transform.position + Vector3.New(0, 20, 0)
    param.bindObject = self.text_btn.gameObject
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTips, { anim = false }, param)
end

function UIHeroPluginDesRandomWithCell:PlayAnim(nameAnim)
    if self.anim ~= nil then
        self.anim:Play(nameAnim, 0, 0)
    end
end

function UIHeroPluginDesRandomWithCell:AddDelayTimer(time)
    if self.delayTimer == nil then
        self.delayTimer = TimerManager:GetInstance():GetTimer(time, self.delay_timer_callback, self, true, false, false)
    end
    self.delayTimer:Start()
end

function UIHeroPluginDesRandomWithCell:DelayTimerCallback()
    self:RemoveDelayTimer()
    self:PlayAnim(HeroPluginUpgradeAnimName.Show)
    if self.param ~= nil and  self.param.data ~= nil then
        DataCenter.HeroPluginManager:PlayShowSound(self.param.data.quality)
        
    end
end

function UIHeroPluginDesRandomWithCell:RemoveDelayTimer()
    if self.delayTimer ~= nil then
        self.delayTimer:Stop()
        self.delayTimer = nil
    end
end

function UIHeroPluginDesRandomWithCell:AddEffect()
    self:RemoveEffect()
    if self.param.data.effectName ~= nil then
        self.effect = self:GameObjectInstantiateAsync(self.param.data.effectName, function(request)
            if request.isError then
                return
            end
            local go = request.gameObject
            go:SetActive(true)
            go.transform:SetParent(self.effect_go.transform)
            go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
            go.transform:SetAsLastSibling()
        end)
    end
end

function UIHeroPluginDesRandomWithCell:RemoveEffect()
    if self.effect ~= nil then
        self.effect:Destroy()
        self.effect = nil
    end
end

function UIHeroPluginDesRandomWithCell:AddMaxDelayTimer(time)
    if self.maxDelayTimer == nil then
        self.maxDelayTimer = TimerManager:GetInstance():GetTimer(time, self.max_delay_timer_callback, self, true, false, false)
    end
    self.maxDelayTimer:Start()
end

function UIHeroPluginDesRandomWithCell:MaxDelayTimerCallback()
    self:RemoveMaxDelayTimer()
    self.max_go:SetActive(true)
end

function UIHeroPluginDesRandomWithCell:RemoveMaxDelayTimer()
    if self.maxDelayTimer ~= nil then
        self.maxDelayTimer:Stop()
        self.maxDelayTimer = nil
    end
end

return UIHeroPluginDesRandomWithCell
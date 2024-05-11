--- Created by shimin.
--- DateTime: 2020/9/8 18:58
--- 气泡

local BuildBubbleTip = BaseClass("BuildBubbleTip")
local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local bg_path = "Go/Bg"
local trigger_path = "Go/Trigger"
local icon_path = "Go/Bg/Icon"
local icon_go_path = "Go"
local obj_path = ""

local FixNormalAnimTime = 0.1 --这里有个BUG，现象是拖远拖近后气泡做出现动画时会闪一下，除了这个方法目前解决不了，先这么处理一下 --shimin 2022.3.29
local ClickDuringTime = 0.5 
local fullEffectPath="Assets/_Art/Effect/prefab/ui/VFX_ziyuanshouqu_glow_loop.prefab"
local AnimName = 
{
    Enter = "EnterBubble",
    Hide = "HideBubble",
    Normal = "NormalBubble",
    Default = "Default",
}

--创建
function BuildBubbleTip:OnCreate(go)
    if go ~= nil then
        self.request = go
        self.gameObject = go.gameObject
        self.transform = go.gameObject.transform
    end
    self:DataDefine()
end

-- 销毁
function BuildBubbleTip:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
end

function BuildBubbleTip:ComponentDefine()
    if not self.defend then
        if self.param.model == UIAssets.BuildStateIcon then
           
        elseif self.param.model == UIAssets.BuildStateIcon4 then
            self.icon_Circle = self.transform:Find(icon_go_path):GetComponent(typeof(CS.ChangeSceneCircleSlider))
        end
        
        self.icon_go = self.transform:Find(icon_go_path):GetComponent(typeof(CS.SimpleAnimation))
        self.icon_sprite = self.transform:Find(icon_path):GetComponent(typeof(CS.SpriteMeshRenderer))
        self.bg_color = self.transform:Find(bg_path):GetComponent(typeof(CS.SpriteMeshRenderer))
        self.bg = self.transform:Find(trigger_path):GetComponent(typeof(CS.TouchObjectEventTrigger))
        self.bg_color:Set_color_a(1.0)
        self.icon_sprite:Set_color_a(1.0)
        self.obj = self.transform:Find(obj_path):GetComponent(typeof(typeof(CS.UnityEngine.Transform)))
        self.bg.onPointerClick = function()
            self:OnClick()
        end
        self.bg.onPointerDoubleClick = function()
            self:OnDoubleClick()
        end
        self.bg.onPointerDown = function()
            self:OnPointerDown()
        end
        self.bg.onPointerUp = function()
            self:OnPointerUp()
        end
        self.defend = true
    end
end

function BuildBubbleTip:ComponentDestroy()
	self.tweenAnimations=nil
    self.bg.onPointerClick = nil
    self.bg.onPointerDoubleClick = nil
    self.bg.onPointerDown = nil
    self.bg.onPointerUp = nil
    self.bg = nil
    self.icon_sprite = nil
    self.gameObject = nil
    self.transform = nil
    self.model_go = nil
    self.bg_color = nil
    self.icon_go = nil
    self.obj = nil
end

function BuildBubbleTip:DataDefine()
    self.param = nil
    self.defend = nil
    self.animationAlreadyShow = false
    self.isShow = false
    self.cdTimer = nil
    self.oldParam = nil
    self.tween = nil
    self.fix_bug_timer_action = function(temp)
        self:FixBugTimeCallBack()
    end
    self.click_cd_timer_callback = function(temp)
        self:ClickCdTimerCallBack()
    end
    self.heightDeltaPos = Vector3.New(0, 0,0)

    self.state = nil
end

function BuildBubbleTip:DataDestroy()
    self:ClearAllEffectAndTimer()
    self.isShow = nil
    self.param = nil
    self.defend = nil
    self.animationAlreadyShow = nil
    self.cdTimer = nil
    self.oldParam = nil
    self.fix_bug_timer_action = nil
    self.tween = nil
    
    self.state = nil
end

function BuildBubbleTip:ReInit(param)
    self.oldParam = self.param
    self.param = param
    self:ComponentDefine()
    self:ShowPanel()
	self:ShowResFullEffect()
end

function BuildBubbleTip:ShowResFullEffect()
    if self.param.resourceType~=nil then
        local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.uuid);
        local percent= buildingData:GetResourcePercent()
        if percent >=1 then
            self:ShowFullEffect()
            EventManager:GetInstance():Broadcast(EventId.ResourceFull, self.param.resourceType)
        else
            self:ClearFullEffect()
        end
    else
		if self.param.buildBubbleType == BuildBubbleType.HeroFreeScienceAddTime or self.param.buildBubbleType == BuildBubbleType.HeroFreeBuildAddTime then
			self:ShowFullEffect()
		else
			self:ClearFullEffect()
		end
    end
end
function BuildBubbleTip:ShowPanel()
    self.state = nil
    if self.param.model == UIAssets.BuildStateIcon then
        if self.upgrade_effect_go ~= nil then
            self.upgrade_effect_go:SetActive(false)
        end
    end
    
    if self.oldParam == nil or self.param.bgName ~= self.oldParam.bgName then
        if self.param.bgName ~= nil then
            self.bg_color.gameObject:SetActive(true)
            self.bg_color:LoadSprite(self.param.bgName)
        else
            self.bg_color.gameObject:SetActive(false)
        end
    end

    if self.oldParam == nil or self.param.iconName ~= self.oldParam.iconName then
		if self.param.iconName ~= nil then
			self.icon_sprite.gameObject:SetActive(true)
			self.icon_sprite:LoadSprite(self.param.iconName)
		else
			self.icon_sprite.gameObject:SetActive(false)
		end
    end
    if self.oldParam == nil or self.param.bgScale ~= self.oldParam.bgScale then
        if self.param.bgScale ~= nil and self.bg_color ~= nil then
            local v = self.param.bgScale
            self.bg_color.transform:Set_localScale(v.x, v.y, v.z)
        end
    end

    if self.oldParam == nil or self.param.iconScale ~= self.oldParam.iconScale then
        if self.param.iconScale ~= nil and self.icon_sprite ~= nil then
            local v = self.param.iconScale
            self.icon_sprite.transform:Set_localScale(v.x, v.y, v.z)
        end
    end

    if self.oldParam == nil or self.param.worldPos ~= self.oldParam.worldPos then
        if self.param.worldPos ~= nil then
            self:UpdateWorldPosition(self.param.worldPos)
        end
    else
        if self.oldParam == nil or self.param.pos ~= self.oldParam.pos or self.oldParam.modelHeight ~= self.param.modelHeight then
            if self.param.pos ~= nil then
                self:UpdatePosition(self.param.pos)
            end
        end
    end
    
	if self.param.buildBubbleType == BuildBubbleType.HeroFreeScienceAddTime or self.param.buildBubbleType == BuildBubbleType.HeroFreeBuildAddTime then
		self.icon_sprite.gameObject:SetActive(true)
        local desc = self.transform:Find("Go/Bg/desc"):GetComponent(typeof(CS.SuperTextMesh))
        if desc ~= nil then
            desc.text = Localization:GetString("130126")
        end
	end

    if self.param.buildBubbleType == BuildBubbleType.BuildCanUpgrade then
        self.icon_sprite.gameObject:SetActive(false)
        if self.upgrade_effect_go ~= nil then
            self.upgrade_effect_go:SetActive(true)
        end
    end

    if self.param.buildBubbleType == BuildBubbleType.BuildingLv0Ruins then
        self.icon_sprite.gameObject:SetActive(false)
        self.bg_color:LoadSprite(string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BuildingLv0RuinsYellow))
        local topAnim = self.transform:Find("Go/Bg/Top"):GetComponent(typeof(CS.UnityEngine.Animator))
        if topAnim ~= nil then
            topAnim:Play("V_chuizi_play", 0, 0)
        end
        self.bg_color.gameObject:SetActive(true)
    end
    if self.param.buildBubbleType == BuildBubbleType.WormHoleSub or self.param.buildBubbleType == BuildBubbleType.CrossWormHoleSub then
        self.icon_Circle:Init(self.param.startTime,self.param.endTime)
    end
    self:RefreshState()
    self:AddFixBugTimer()
end

--更新位置
function BuildBubbleTip:UpdatePosition(index)
    self.heightDeltaPos.y = self.param.modelHeight
    self:SetPosition(BuildingUtils.GetBuildModelCenterVec(index, self.param.tiles) + self.heightDeltaPos)
end

function BuildBubbleTip:UpdateWorldPosition(worldPos)
    self:SetPosition(worldPos)
end



function BuildBubbleTip:SetPosition(value)
	self.transform:Set_position(value.x, value.y, value.z)
end

function BuildBubbleTip:OnClick()
    if self.cdTimer ~= nil then
        return
    end
    if not CS.SceneManager.World:CanUseInput() then
        return
    end
    if self.param.callBack ~= nil then
        self.param.callBack(self.param)
        if not self.param.allowContinuousClick then
            self:AddClickCdTimer()
        end
    end
end

function BuildBubbleTip:OnDoubleClick()
    if self.param.allowContinuousClick then
        self:OnClick()
    end
end

function BuildBubbleTip:OnPointerDown()
    if self.tween ~= nil then
        self.tween:Kill()
    end
    self.tween = self.transform:DOScale(ResetScale * 0.8, 0.1)
end

function BuildBubbleTip:OnPointerUp()
    if self.tween ~= nil then
        self.tween:Kill()
    end
    self.tween = self.transform:DOScale(ResetScale, 0.1)
end

function BuildBubbleTip:RefreshState()
    if self.oldParam == nil or self.param.state ~= self.oldParam.state then
        if self.param.buildBubbleType == BuildBubbleType.GetResource then
            if self.state ~= self.param.state then
                self.state = self.param.state
                if self.param.state == BuildGetResourceState.Full then
                    self.bg_color.gameObject:SetActive(true)
                    self.param.bgName = string.format(LoadPath.UIBuildBubble,BuildBubbleIconName.BgSelect)
                    self.bg_color:LoadSprite(string.format(LoadPath.UIBuildBubble,BuildBubbleIconName.BgSelect))
                elseif self.param.state == BuildGetResourceState.Add then
                    self.bg_color.gameObject:SetActive(true)
                    self.param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
                    self.bg_color:LoadSprite(string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect))
                end
            end
        end
    end
end

--获取气泡位置
function BuildBubbleTip:GetBubblePosition()
    if self.icon_sprite ~= nil then
        return self.icon_sprite.transform.position
    elseif self.bg ~= nil then
        return self.bg.transform.position
    end
    return ResetPosition
end

--获取引导气泡对象
function BuildBubbleTip:GetBubbleObj(isIgnore)
    if isIgnore then
        return self.obj
    end
    if self.bg ~= nil then
        return self.bg
    elseif self.icon_sprite ~= nil then
        return self.icon_sprite
    end
    return self.icon_go
end

function BuildBubbleTip:ShowFullEffect()
    if self.fullEffect == nil then
        self.fullEffect = ResourceManager:InstantiateAsync(fullEffectPath)
        self.fullEffect:completed('+', function()
            if self.fullEffect.isError then
                return
            end
            self.fullEffect.gameObject:SetActive(true)
			local go_rt = self.fullEffect.gameObject.transform
            go_rt:SetParent(self.bg_color.gameObject.transform, false)
			go_rt:Set_localScale(1.5,1.5,1.5)
			go_rt:Set_localPosition(0, 0, 0)
        end)
    end
end

function BuildBubbleTip:ClearFullEffect()
    if self.fullEffect ~= nil then
        self.fullEffect:Destroy()
        self.fullEffect = nil
    end
end

function BuildBubbleTip:Show()
    if self.icon_go ~= nil then
        if self.isShow == true then
            self.icon_go:Play(AnimName.Normal)
        else
            self.icon_go:Play(AnimName.Enter)
            self.icon_go:PlayQueued(AnimName.Normal)
            self.isShow = true
        end
    end
end

function BuildBubbleTip:Hide()
    if self.isShow == false then
        return
    end

    if self.icon_go ~= nil then
        self.icon_go:Play(AnimName.Hide)
    end
    self.isShow = false
end

function BuildBubbleTip:ToFree()
    if self.icon_go ~= nil then
        self.icon_go:Play(AnimName.Default)
    end
    self.oldParam = self.param
    self.animationAlreadyShow = false
    --清除特效
    self:ClearAllEffectAndTimer()
end

function BuildBubbleTip:AddFixBugTimer()
    if self.fixBugTimer == nil then
        self.fixBugTimer = TimerManager:GetInstance():GetTimer(FixNormalAnimTime, self.fix_bug_timer_action , self, true,false,false)
    end
    self.fixBugTimer:Start()
end

function BuildBubbleTip:DeleteFixBugTimer()
    if self.fixBugTimer ~= nil then
        self.fixBugTimer:Stop()
        self.fixBugTimer = nil
    end
end

function BuildBubbleTip:FixBugTimeCallBack()
    self:DeleteFixBugTimer()
    self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    if self.icon_go ~= nil then
        if self.animationAlreadyShow == false then
            self.animationAlreadyShow = true
            self.icon_go:Play(AnimName.Enter)
            self.icon_go:PlayQueued(AnimName.Normal)
        end
    end
end

function BuildBubbleTip:AddClickCdTimer()
    if self.cdTimer == nil then
        self.cdTimer = TimerManager:GetInstance():GetTimer(ClickDuringTime, self.click_cd_timer_callback , self, true, false, false)
    end
    self.cdTimer:Start()
end

function BuildBubbleTip:DeleteClickCdTimer()
    if self.cdTimer ~= nil then
        self.cdTimer:Stop()
        self.cdTimer = nil
    end
end

function BuildBubbleTip:ClickCdTimerCallBack()
    self:DeleteClickCdTimer()
end

function BuildBubbleTip:ClearAllEffectAndTimer()
    self:DeleteClickCdTimer()
    self:DeleteFixBugTimer()
    self:ClearFullEffect()
end

return BuildBubbleTip
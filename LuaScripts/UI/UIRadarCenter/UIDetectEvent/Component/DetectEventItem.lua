---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2021/8/2 14:08
---
local DetectEventItem = BaseClass("DetectEventItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local this_path = ""
local quality_img_path = "Root/Item_All/Detect_Event_Quality_Img"
local detect_event_point_path = "Root/Detect_event_point"
local complete_img_path = "Root/Item_All/Detect_Event_Select_Img"
local event_img_path = "Root/Item_All/Detect_Event_Img"
local event_monster_img_path = "Root/Item_All/Detect_Event_Monster_Img"
local red_dot_path = "Root/Item_All/Detect_Event_Red_Dot"
local vfx_radar_scan_path = "Root/VFX_leida_shijian"
local vfx_special_event_effect_path = "Root/Item_All/VFX_special_event_effect"
local vfx_special_event_effect1_path = "Root/Item_All/VFX_special_event_effect_01"
local item_all_path = "Root/Item_All"
local root_path = "Root"

local head_node_path = "Root/Item_All/Head"
local head_path = "Root/Item_All/Head/UIPlayerHead/HeadIcon"
local head_name_path = "Root/Item_All/Head/Name"

local particle_show_time = 1000.0

local bg_pos_1 = 0
local bg_pos_2 = 10

local function OnCreate(self)
    base.OnCreate(self)

    self:DataDefine()
    self:ComponentDefine()
end

local function ComponentDefine(self)
    self.event_trigger = self:AddComponent(UIEventTrigger, this_path)
    self.event_trigger:OnPointerDown(function(eventData)
        self:OnPointerDown(eventData)
    end)
    self.root = self:AddComponent(UIBaseContainer, root_path)
    self.quality_img = self:AddComponent(UIImage, quality_img_path)
    --self.select_img = self:AddComponent(UIImage, select_img_path)
    self.event_img = self:AddComponent(UIImage, event_img_path)
    self.event_monster_img = self:AddComponent(UIImage, event_monster_img_path)
    self.red_dot = self:AddComponent(UIImage, red_dot_path)
    self.complete_img = self:AddComponent(UIImage, complete_img_path)
    --self.vfx_radar_scan = self:AddComponent(UIBaseContainer, vfx_radar_scan_path)
    --self.vfx_radar_scan:SetActive(false)
    --self.vfx_special_event_effect = self:AddComponent(UIBaseContainer, vfx_special_event_effect_path)
    --self.vfx_special_event_effect:SetActive(false)
    --self.vfx_special_event_effect1 = self:AddComponent(UIBaseContainer, vfx_special_event_effect1_path)
    --self.vfx_special_event_effect1:SetActive(false)
    self.item_all = self:AddComponent(UIBaseContainer, item_all_path)
    self.detect_event_point = self:AddComponent(UIImage, detect_event_point_path)
    DOTween.Rewind(self.gameObject)
    local delayTime = 1.0 * math.random(0, 100) / 150.0
    self:DelayInvoke(function ()
        self:PlayShowAnimation()
    end, delayTime);
    DOTween.Rewind(self.item_all.gameObject)
    --self.item_all.transform:DOLocalMove(Vector3.zero, 0.3)

    self.headNode = self:AddComponent(UIBaseContainer, head_node_path)
    self.headNode:SetActive(false)
    self.playerHead = self:AddComponent(UIPlayerHead, head_path)
    self.headName = self:AddComponent(UITextMeshProUGUI, head_name_path)
end

local function DelayInvoke(self, callback, delayTime)
    local param = {}
    param.timer = TimerManager:GetInstance():GetTimer(delayTime, function()
        if param.timer ~= nil then
            param.timer:Stop()
            param.timer = nil
        end
        param = nilDelayInvoke
        callback()
    end , self, true,false,false)
    param.timer:Start()
end

local function PlayShowAnimation(self)
    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Radar_Item_Appear)
    DOTween.Play(self.gameObject)
end

local function DataDefine(self)
    self.lastPlayEffectTime = 0
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    
    base.OnDestroy(self)
end

local function ComponentDestroy(self)
    self.event_trigger = nil
    self.quality_img = nil
    self.select_img = nil
    self.event_img = nil
    self.event_monster_img = nil
    self.red_dot = nil
    self.vfx_radar_scan = nil
    self.complete_img = nil
    self.vfx_special_event_effect = nil
    self.item_all = nil
    self.detect_event_point = nil
end

local function DataDestroy(self)
    self.lastPlayEffectTime = nil
end

local function SetUuid(self, param, selectUuid) 
    self.param = param
    self.selectUuid = selectUuid
    self:Refresh()
end

local function setSelectUuid(self, selectUuid)
    self.selectUuid = selectUuid
    self:Refresh()

    if self.param.uuid == self.selectUuid then
        DOTween.Restart(self.item_all.gameObject)
        self.item_all.transform:DOLocalMove(Vector3.New(0, 20, 0), 0.25)
    end
end

local function OnPointerDown(self, eventData)
    if self.param.fromType == DetectEventFromType.RadarBoss then
        self.view:SetCurrentSelectItemId(self.param.uuid)
    elseif self.param.uuid ~= nil then
        local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(self.param.uuid)
        if data ~= nil and data.state == DetectEventState.DETECT_EVENT_STATE_FINISHED then
            if self.view.ctrl:GetReward(data) then
                self.view:SetCurrentSelectItemId(nil)
            end
        else
            if self.param.type == DetectEventType.PLOT then
                self.view:SetPlotEventUuid(self.param.uuid)
                if not DataCenter.GuideManager:InGuide() then
                    DataCenter.GuideManager:SetCurGuideId(self.param.noviceBootId)
                    DataCenter.GuideManager:DoGuide()
                end
                return
            else
                self.view:SetCurrentSelectItemId(self.param.uuid)
            end
        end
    end
    DataCenter.GuideManager:HasClick(self:GetGuideObject())
end

local function Refresh(self)
    if self.param.fromType == DetectEventFromType.RadarBoss then
        local template = DataCenter.ActivityPuzzleMonsterTemplateManager:GetTemplateByMonsterId(self.param.id)
        if template ~= nil then
            self.red_dot:SetActive(false)
            self.complete_img:SetActive(false)
            local quality = DetectEventColor.DETECT_EVENT_PURPLE
            self.quality_img:LoadSprite(DetectEvenColorImage[quality], nil, function()
                self.quality_img:SetNativeSize()
            end)
            self.quality_img.transform:Set_localPosition(0, bg_pos_1, 0)
            self:CheckAndHideRadarScanEffect()
            --self.vfx_special_event_effect:SetActive(false)
            --self.vfx_special_event_effect1:SetActive(false)
            self.event_img:SetActive(true)
            self.event_monster_img:SetActive(false)
            self.event_img:LoadSprite(string.format(LoadPath.RadarCenterPath, "icon_radar_boss"))
            if self.param.uuid ~= self.selectUuid then
                DOTween.Rewind(self.item_all.gameObject)
                self.item_all.transform:DOLocalMove(Vector3.zero, 0.25)
            end
            self.quality_img:SetColor(WhiteColor)
            self.event_img:SetColor(WhiteColor)
            self.detect_event_point:SetColor(WhiteColor)
            local scale = self:GetItemScale(quality)
            self.root.transform:Set_localScale(scale, scale, 1)
        end
    else
        local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(self.param.eventId)
        if template == nil then
            return
        end
        self.headNode:SetActive(false)
        self.red_dot:SetActive(self.param.state == DetectEventState.DETECT_EVENT_STATE_FINISHED)
        self.complete_img:SetActive(self.param.state == DetectEventState.DETECT_EVENT_STATE_FINISHED)
        local iconName = ""
        local type = template:getValue("type")
        if type == DetectEventType.SPECIAL_OPS then
            iconName = DetectEvenColorSpecialImage[template:getValue("quality")]
            if self.param.state == DetectEventState.DETECT_EVENT_STATE_FINISHED then
                self.complete_img:LoadSprite(string.format(LoadPath.RadarCenterPath, "Detect_spec_select"))
                self.complete_img.transform:Set_localPosition(0, bg_pos_2-5, 0)
            end
            self.quality_img.transform:Set_localPosition(0, bg_pos_2, 0)
        elseif type == DetectEventType.HELP then
            self.headNode:SetActive(true)
            self.playerHead:SetData(self.param.helpInfo.uid, self.param.helpInfo.pic, self.param.helpInfo.picVer)
            self.headName:SetText(self.param.helpInfo.name)
        else
            iconName = DetectEvenColorImage[template:getValue("quality")]
            self.quality_img.transform:Set_localPosition(0, bg_pos_1, 0)
            if self.param.state == DetectEventState.DETECT_EVENT_STATE_FINISHED then
                self.complete_img:LoadSprite(string.format(LoadPath.RadarCenterPath, "UIDetectEvent_img_event_select"))
                self.complete_img.transform:Set_localPosition(0, bg_pos_1-5, 0)
            end
        end
        self.quality_img:LoadSprite(iconName, nil, function()
            self.quality_img:SetNativeSize()
        end)

        self:CheckAndHideRadarScanEffect()
        --self.vfx_special_event_effect:SetActive(template.type == DetectEventType.DetectEventTypeSpecial)
        --self.vfx_special_event_effect1:SetActive(template.type == DetectEventType.SPECIAL_OPS)
        if template:getValue("type") == DetectEventType.DetectEventRadarRally then
            self.event_img:SetActive(false)
            self.event_monster_img:SetActive(true)
            self.event_monster_img:LoadSprite(string.format(LoadPath.RadarCenterPath, template:getValue("icon")))
        else
            self.event_img:SetActive(true)
            self.event_monster_img:SetActive(false)
            self.event_img:LoadSprite(string.format(LoadPath.RadarCenterPath, template:getValue("icon")))
        end

        if self.param.uuid ~= self.selectUuid then
            DOTween.Rewind(self.item_all.gameObject)
            self.item_all.transform:DOLocalMove(Vector3.zero, 0.25)
        end

        local isGoto = DataCenter.RadarCenterDataManager:IsDetectEventDoing(self.param.uuid)
        if isGoto then
            self.quality_img:SetColor(Color.New(1,1,1,0.3))
            self.event_img:SetColor(Color.New(1,1,1,0.3))
            self.detect_event_point:SetColor(Color.New(1,1,1,0.3))
        else
            self.quality_img:SetColor(WhiteColor)
            self.event_img:SetColor(WhiteColor)
            self.detect_event_point:SetColor(WhiteColor)
        end

        local scale = self:GetItemScale(template:getValue("quality"))
        self.root.transform:Set_localScale(scale, scale, 1)
    end
end

local function CheckAndHideRadarScanEffect(self)
    if self.lastPlayEffectTime > 0 and UITimeManager:GetInstance():GetServerTime() - self.lastPlayEffectTime > particle_show_time then
        --self.vfx_radar_scan:SetActive(false)
    end
end

local function ShowRadarScanEffect(self)
    self.lastPlayEffectTime = UITimeManager:GetInstance():GetServerTime()
    --self.vfx_radar_scan:SetActive(false)
    --self.vfx_radar_scan:SetActive(true)
end

local function GetGuideObject(self) 
    return self.quality_img.gameObject
end

local function GetItemScale(self, quality)
    if quality == DetectEventColor.DETECT_EVENT_WHITE or quality == DetectEventColor.DETECT_EVENT_GREEN then
        return 1
    elseif quality == DetectEventColor.DETECT_EVENT_BLUE then
        return 1
    elseif quality == DetectEventColor.DETECT_EVENT_PURPLE then
        return 1
    elseif quality == DetectEventColor.DETECT_EVENT_ORANGE then
        return 1.1
    end
    return 1
end

DetectEventItem.OnCreate = OnCreate
DetectEventItem.OnDestroy = OnDestroy
DetectEventItem.ComponentDefine = ComponentDefine
DetectEventItem.ComponentDestroy = ComponentDestroy
DetectEventItem.SetUuid = SetUuid
DetectEventItem.DataDefine = DataDefine
DetectEventItem.DataDestroy = DataDestroy
DetectEventItem.Refresh = Refresh
DetectEventItem.OnPointerDown = OnPointerDown
DetectEventItem.PlayShowAnimation = PlayShowAnimation
DetectEventItem.DelayInvoke = DelayInvoke
DetectEventItem.ShowRadarScanEffect = ShowRadarScanEffect
DetectEventItem.CheckAndHideRadarScanEffect = CheckAndHideRadarScanEffect
DetectEventItem.setSelectUuid = setSelectUuid
DetectEventItem.GetGuideObject = GetGuideObject
DetectEventItem.GetItemScale = GetItemScale

return DetectEventItem
---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2023/1/3 11:59
---

local DetectEventBubble = BaseClass("DetectEventBubble")

local bg_path = "Transform/Detect_event_quality_icon"
local icon_path = "Transform/Detect_event_icon"
--创建
local function OnCreate(self, go)
    if go ~= nil then
        self.request = go
        self.gameObject = go.gameObject
        self.transform = go.gameObject.transform
    end
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
end

local function ComponentDefine(self)
    if not self.defend then
        self.icon_sprite = self.transform:Find(icon_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
        self.bg_sprite = self.transform:Find(bg_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
        --self.bg = self.transform:Find(trigger_path):GetComponent(typeof(CS.TouchObjectEventTrigger))
        --self.bg.onPointerClick = function()
        --    self:OnClick()
        --end

        self.defend = true
    end
end

local function ComponentDestroy(self)
    --if self.bg ~= nil and self.bg.gameObject ~= nil and self.bg.onPointerClick ~= nil then
    --    self.bg.onPointerClick = nil
    --end
    --self.bg = nil
    self.icon_sprite = nil
    self.bg_sprite = nil
end

local function DataDefine(self)

end

local function DataDestroy(self)
    self.defend = nil
end

local function OnClick(self)
    --local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(self.uuid)
    --if data then
    --    UIUtil.OnClickWorld(data.pointId, data.type)
    --end
end

local function SetUuid(self, uuid) 
    self.uuid = uuid
    local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(self.uuid)
    if data then
        local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(data.eventId)
        if template then
            self.icon_sprite:LoadSprite(string.format(LoadPath.RadarCenterPath, template:getValue("icon")))
            self.bg_sprite:LoadSprite(DetectEvenColorImage[template:getValue("quality")])
        end
    end
end

DetectEventBubble.OnCreate = OnCreate
DetectEventBubble.OnDestroy = OnDestroy
DetectEventBubble.ComponentDefine = ComponentDefine
DetectEventBubble.ComponentDestroy = ComponentDestroy
DetectEventBubble.DataDefine = DataDefine
DetectEventBubble.DataDestroy = DataDestroy
DetectEventBubble.OnClick = OnClick
DetectEventBubble.SetUuid = SetUuid

return DetectEventBubble
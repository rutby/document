--- Created by shimin.
--- DateTime: 2023/12/14 14:26
---

local base = require "UI.UICityHud.Component.UICityHudBase"
local UICityHudIconAndSlider = BaseClass("UICityHudIconAndSlider", base)

local slider_path = "Root/Slider"
local slider_text_oath = "Root/Slider/slider_text"
local icon_path = "Root/Icon"
local icon_bg_path = "Root/icon_bg"

local SliderLength = 211

function UICityHudIconAndSlider:ComponentDefine()
    base.ComponentDefine(self)
    self.slider = self:AddComponent(UISlider, slider_path)
    self.slider_text = self:AddComponent(UITextMeshProUGUIEx, slider_text_oath)
    self.icon_image = self:AddComponent(UIImage, icon_path)
    self.icon_bg = self:AddComponent(UIImage, icon_bg_path)
end

function UICityHudIconAndSlider:DataDefine()
    base.DataDefine(self)
    self.lastTime = 0
    self.lastCurTime = 0
end

function UICityHudIconAndSlider:SetParam(param)
    base.SetParam(self, param)
    self.root_go.transform.localPosition = self.param.offset or Vector3.zero
    self.icon_image.transform:Set_localScale(self.param.iconScale.x, self.param.iconScale.y, self.param.iconScale.z)
    self.icon_image:LoadSprite(self.param.icon, nil, function()
        self.icon_image:SetNativeSize()
    end)
    if self.param.bg == nil then
        self.icon_bg:SetActive(false)
    else
        self.icon_bg.transform:Set_localScale(self.param.bgScale.x, self.param.bgScale.y, self.param.bgScale.z)
        self.icon_bg:LoadSprite(self.param.bg, nil, function()
            self.icon_bg:SetActive(true)
            self.icon_bg:SetNativeSize()
        end)
    end
end

function UICityHudIconAndSlider:Update()
    if not self.active then
        return
    end
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local changeTime = self.param.endTime - curTime
    local maxTime = self.param.endTime - self.param.startTime
    if changeTime < maxTime and changeTime > 0 then
        local tempTimeSec = math.ceil(changeTime / 1000)
        if tempTimeSec ~= self.lastTime then
            self.lastTime = tempTimeSec
            local tempTimeValue = UITimeManager:GetInstance():MilliSecondToFmtString(changeTime)
            self.slider_text:SetText(tempTimeValue)
        end

        if maxTime > 0 then
            local tempValue = 1 - changeTime / maxTime
            if TimeBarUtil.CheckIsNeedChangeBar(changeTime, self.param.endTime - self.lastCurTime, maxTime, SliderLength) then
                self.lastCurTime = curTime
                self.slider:SetValue(tempValue)
            end
        end
    else
        if self.lastTime ~= 0 then
            self.lastTime = 0
            self.slider:SetValue(1)
            self.slider_text:SetText("")
        end
    end
end

return UICityHudIconAndSlider
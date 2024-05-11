--- Created by shimin.
--- DateTime: 2024/3/4 18:33
--- 动态表情

local base = require "UI.UICityHud.Component.UICityHudBase"
local UICityHudAnimEmoji = BaseClass("UICityHudAnimEmoji", base)

local bg_path = "Root/bg"
local bg_icon_path = "Root/bg/bg_icon"
local icon_img_path = "Root/icon_img"
local content_path = "Root/content"

function UICityHudAnimEmoji:ComponentDefine()
    base.ComponentDefine(self)
    self.bg = self:AddComponent(UIImage, bg_path)
    self.bg_icon = self:AddComponent(UIImage, bg_icon_path)
    self.icon_img = self:AddComponent(UIImage, icon_img_path)
    self.content = self:AddComponent(UIBaseContainer, content_path)
end

function UICityHudAnimEmoji:ComponentDestroy()
    base.ComponentDestroy(self)
end


function UICityHudAnimEmoji:DataDefine()
    base.DataDefine(self)
    self.lodMax = 3
    self.timer_callback = function() 
        self:OnTimerCallBack()
    end
    self.animReq = nil
end

function UICityHudAnimEmoji:DataDestroy()
    base.DataDestroy(self)
    self:RemoveOneTime()
    self:DestroyReq()
end

function UICityHudAnimEmoji:SetParam(param)
    base.SetParam(self, param)
    self.root_go.transform.localPosition = param.offset or Vector3.zero
    if self.param.emojiType == GuideResidentEmojiType.Img then
        self.bg:SetActive(false)
        self.icon_img:SetActive(true)
        self.content:SetActive(false)
        self.icon_img:LoadSprite(string.format(LoadPath.UIAnimEmoji, self.param.emojiPara[1]))
    elseif self.param.emojiType == GuideResidentEmojiType.BgImg then
        self.bg:SetActive(true)
        self.icon_img:SetActive(false)
        self.content:SetActive(false)
        self.bg_icon:LoadSprite(string.format(LoadPath.UIAnimEmoji, self.param.emojiPara[1]), nil, function()
            self.bg_icon:SetNativeSize()
        end)
    elseif self.param.emojiType == GuideResidentEmojiType.Anim then
        self.bg:SetActive(false)
        self.icon_img:SetActive(false)
        self.content:SetActive(true)
        self:DestroyReq()
        self.animReq = self:GameObjectInstantiateAsync(string.format(UIAssets.UIAnimEmoji, self.param.emojiPara[1]), function(request)
            if request.isError then
                return
            end
            local go = request.gameObject
            go:SetActive(true)
            go.transform:SetParent(self.content.transform)
            go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
        end)
    end
    
    self:AddOneTime(param.duration)
    self:PlayEffect(param.effectId)
end


function UICityHudAnimEmoji:PlayEffect(name)
    if name ~= nil and name ~= "" then
        SoundUtil.PlayEffect(name)
    end
end

function UICityHudAnimEmoji:AddOneTime(time)
    self:RemoveOneTime()
    if time ~= nil and time > 0 then
        self.timer = TimerManager:GetInstance():GetTimer(time, self.timer_callback, nil, true, false, false)
        self.timer:Start()
    end
end

function UICityHudAnimEmoji:RemoveOneTime()
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

function UICityHudAnimEmoji:OnTimerCallBack()
    self:RemoveOneTime()
    if self.active then
        DataCenter.CityHudManager:Destroy(self.param.uuid, CityHudType.AnimEmoji)
    end
end

function UICityHudAnimEmoji:DestroyReq()
    if self.animReq ~= nil then
        self.animReq:Destroy()
        self.animReq = nil
    end
end

return UICityHudAnimEmoji
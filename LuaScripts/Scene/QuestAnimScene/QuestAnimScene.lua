--- Created by shimin.
--- DateTime: 2024/11/44 14:26
--- 任务翻页场景

local QuestAnimScene = BaseClass("QuestAnimScene")
local Resource = CS.GameEntry.Resource

local anim_path = "A_build_jiazi_01/A_build@benjiazi_01_skin"
local front_go_path = "front_quest_go/Canvas"
local after_go_path = "after_quest_go/Canvas"
local camera_path = "BookCamera"

local FlipAnimName = "flip"
local FrontPosition = Vector3.New(2, 5, 0)
local AfterPosition = Vector3.New(2, -7, 0)
local WorldPosition = Vector3.New(-100, -100, -100)

function QuestAnimScene:__init()
    self:DataDefine()
end

function QuestAnimScene:__delete()
    
end

function QuestAnimScene:Destroy()
    self:ComponentDestroy()
    self:DataDestroy()
end

function QuestAnimScene:DataDefine()
    self.param = {}
    self.gameObject = nil
    self.transform = nil
    self.req = nil
    self.loadCallback = nil
    self.flipCallback = nil
    self.frontGo = nil
    self.afterGo = nil
    self.show_time_callback = function() 
        self:ShowTimeCallBack()
    end
end

function QuestAnimScene:DataDestroy()
    self:DestroyReq()
    self:DeleteShowTimer()
end

function QuestAnimScene:DestroyReq()
    if self.req ~= nil then
        self.req:Destroy()
        self.req = nil

        self.gameObject = nil
        self.transform = nil
    end
end

function QuestAnimScene:ComponentDefine()
    self.anim = self.transform:Find(anim_path):GetComponent(typeof(CS.SimpleAnimation))
    self.front_go = self.transform:Find(front_go_path).transform
    self.after_go = self.transform:Find(after_go_path).transform
    self.camera = self.transform:Find(camera_path):GetComponent(typeof(CS.UnityEngine.Camera))
end

function QuestAnimScene:ComponentDestroy()
end

function QuestAnimScene:ReInit(param)
    self.param = param
end

function QuestAnimScene:Create()
    if self.req == nil then
        self.req = Resource:InstantiateAsync(UIAssets.QuestAnimScene)
        self.req:completed('+', function()
            self.gameObject = self.req.gameObject
            self.transform = self.req.gameObject.transform
            self.transform.position = WorldPosition
            self:ComponentDefine()
            self:Refresh()
        end)
    elseif self.gameObject ~= nil then
        self:Refresh()
    end
end

function QuestAnimScene:Refresh()
    if self.frontGo ~= nil then
        self.frontGo.transform:SetParent(self.front_go)
        self.frontGo:SetLocalScale(ResetScale)
        self.frontGo.transform:Set_anchoredPosition3D(FrontPosition.x, FrontPosition.y, FrontPosition.z)
    end
    if self.afterGo ~= nil then
        self.afterGo.transform:SetParent(self.after_go)
        self.afterGo:SetLocalScale(ResetScale)
        self.afterGo.transform:Set_anchoredPosition3D(AfterPosition.x, AfterPosition.y, AfterPosition.z)
    end
    
    if self.loadCallback ~= nil then
        self.loadCallback()
        self.loadCallback = nil
    end
	local scaleFactor = CS.UnityEngine.Screen.width/ CS.UnityEngine.Screen.height
    self.camera.orthographicSize =1.89/(scaleFactor/(750/1334)) 
    local time = self.anim:GetClipLength(FlipAnimName)
    if time > 0 then
        self.anim:Play(FlipAnimName)
        self:AddShowTimer(time)
    end
end

function QuestAnimScene:DoFlipAnim(loadCallback, flipCallback, frontGo, afterGo)
    self.loadCallback = loadCallback
    self.flipCallback = flipCallback
    self.frontGo = frontGo
    self.afterGo = afterGo
    self:Create()
    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Chapter_Flip)
end

function QuestAnimScene:AddShowTimer(time)
    if self.showTimer == nil then
        self.showTimer = TimerManager:GetInstance():GetTimer(time, self.show_time_callback, self, true, false, false)
        self.showTimer:Start()
    end
end

function QuestAnimScene:DeleteShowTimer()
    if self.showTimer ~= nil then
        self.showTimer:Stop()
        self.showTimer = nil
    end
end

function QuestAnimScene:ShowTimeCallBack()
    self:DeleteShowTimer()
    if self.flipCallback ~= nil then
        self.flipCallback()
        self.flipCallback = nil
    end
end

return QuestAnimScene
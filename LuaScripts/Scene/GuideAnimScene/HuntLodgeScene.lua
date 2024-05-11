--- Created by shimin.
--- DateTime: 2024/3/4 10:57
--- 猎人小屋表演

local HuntLodgeScene = BaseClass("HuntLodgeScene")
local Resource = CS.GameEntry.Resource

local all_timeline_path = "Lierenxiaowu_TimelineA"
local npc_path = "Lierenxiaowu_TimelineA/RoleA/NPC_Daiweide/NPC_Daiweide_skin/To_unity/DeformationSystem/Root/Root_M"
local monster_path = "Lierenxiaowu_TimelineA/Role/A_Monster_new_sangshi01/A_Monster@new_sangshi01_skin/To_unity/DeformationSystem/Root/RooM"
local camera_path = "Lierenxiaowu_TimelineA/Camera"

local BubbleUuid = -10
local BubbleTime = 2.3

local StateType =
{
    Show = 1,--
    ShowBubble = 2,--显示气泡
}

function HuntLodgeScene:__init()
    self:DataDefine()
end

function HuntLodgeScene:__delete()
    
end

function HuntLodgeScene:Destroy()
    self:ComponentDestroy()
    self:DataDestroy()
end

function HuntLodgeScene:DataDefine()
    self.param = {}
    self.obj = {}
    DataCenter.GuideManager:SetNoShowUIMain(GuideSetUIMainAnim.Hide)
    DataCenter.BuildBubbleManager:HideBubbleNode()
    DataCenter.CityHudManager:SetVisible(false)
    DataCenter.CityHudManager:SetLayerVisible(CityHudLayer.Speak, true)
    DataCenter.GuideManager:SetShowRandomZombie(false)-- 僵尸生成
    DataCenter.FogManager:Hide()
    self.gameObject = nil
    self.transform = nil
    self.req = nil
    self.on_time_callback = function() 
        self:OnTimeCallback()
    end
    self.needPauseSound = {}
end

function HuntLodgeScene:DataDestroy()
    self:OnTimeCallback()
    self:ClearSound()
    DataCenter.FogManager:Show()
    if self.camera ~= nil then
        DataCenter.GuideCityAnimManager:SetMainCameraPositionAndRotation(self.camera.transform.position, self.camera.transform.rotation)
    end
    DataCenter.GuideManager:SetNoShowUIMain(GuideSetUIMainAnim.Show)
    DataCenter.BuildBubbleManager:ShowBubbleNode()
    DataCenter.CityHudManager:SetVisible(true)
    DataCenter.CityResidentManager:SetActiveAll(true)
    DataCenter.GuideManager:SetShowRandomZombie(true)-- 僵尸生成
    
    DataCenter.LandManager:SetShowBlockEffect(true) -- 显示地块特效
    DataCenter.LandManager:RefreshAllObjects()
    
    self:DestroyReq()
end

function HuntLodgeScene:DestroyReq()
    if self.req ~= nil then
        self.req:Destroy()
        self.req = nil

        self.gameObject = nil
        self.transform = nil
    end
end

function HuntLodgeScene:ComponentDefine()
    self.director = self.transform:Find(all_timeline_path):GetComponent(typeof(CS.UnityEngine.Playables.PlayableDirector))
    self.obj[1] = self.transform:Find(npc_path).gameObject
    self.obj[2] = self.transform:Find(monster_path).gameObject
    self.camera = self.transform:Find(camera_path):GetComponent(typeof(CS.UnityEngine.Camera))
    DataCenter.CityHudManager:SetCamera(self.camera)
end

function HuntLodgeScene:ComponentDestroy()
    DataCenter.CityHudManager:SetCamera(nil)
end

function HuntLodgeScene:ReInit(param)
    self.param = param
    self:Create()
end

function HuntLodgeScene:Create()
    if self.req == nil then
        self.req = Resource:InstantiateAsync(UIAssets.HuntLodgeScene)
        self.req:completed('+', function()
            self.gameObject = self.req.gameObject
            self.transform = self.req.gameObject.transform
            self:ComponentDefine()
            self:Refresh()
            local id = SoundUtil.PlayEffect(SoundAssets.Music_Effect_Guide_Hunt_lodge_Timeline)
            table.insert(self.needPauseSound, id)
        end)
    elseif self.gameObject ~= nil then
        self:Refresh()
    end
end

function HuntLodgeScene:Refresh()
    if self.param.state == StateType.Show then
        DataCenter.CityResidentManager:SetActiveAll(false)
    elseif self.param.state == StateType.ShowBubble then
        self:ShowBubble()
    else
        DataCenter.CityResidentManager:SetActiveAll(false)
    end
end

function HuntLodgeScene:Pause()
    self.director:Pause()
    self:PauseSound()
end

function HuntLodgeScene:Resume()
    self.director:Resume()
    self:ResumeSound()
end

function HuntLodgeScene:GetGuideTalkObject(id)
    return self.obj[id]
end

function HuntLodgeScene:GotoTime(time)
    self.director.time = time
end

function HuntLodgeScene:ShowBubble()
    local hudParam = {}
    hudParam.uuid = BubbleUuid
    hudParam.type = CityHudType.ProductSlider
    hudParam.pos = self.obj[1].transform.position
    hudParam.icon = string.format(LoadPath.CommonPath, "UIRes_icon_meat")
    hudParam.offset = Vector3.New(0, 80, 0)
    hudParam.scale = 0.8
    hudParam.duration = BubbleTime
    hudParam.location = CityHudLocation.World
    DataCenter.CityHudManager:Create(hudParam)
    DataCenter.WaitTimeManager:AddOneWait(BubbleTime, self.on_time_callback)
end

function HuntLodgeScene:OnTimeCallback()
    DataCenter.CityHudManager:Destroy(BubbleUuid, CityHudType.ProductSlider)
    DataCenter.WaitTimeManager:DeleteOneTimer(self.on_time_callback)
end

function HuntLodgeScene:PauseSound()
    for k,v in ipairs(self.needPauseSound) do
        SoundUtil.PauseSound(v)
    end
end

function HuntLodgeScene:ResumeSound()
    for k,v in ipairs(self.needPauseSound) do
        SoundUtil.ResumeSound(v)
    end
end

function HuntLodgeScene:ClearSound()
    for k,v in ipairs(self.needPauseSound) do
        SoundUtil.StopSound(v)
    end
end

return HuntLodgeScene
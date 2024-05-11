--- Created by shimin.
--- DateTime: 2024/3/7 14:26
--- 引导开始小人进村Timeline

local ResidentEnterCityScene = BaseClass("ResidentEnterCityScene")
local Resource = CS.GameEntry.Resource

local all_timeline_path = "piantou_Timeline"
local npc1_path = "piantou_Timeline/npc/NPC_Zuoyi/NPC_Zuoyi_skin/To_unity/DeformationSystem/Root/Root_M"
local npc2_path = "piantou_Timeline/npc/NPC_Emily/NPC_Emily_skin/To_unity/DeformationSystem/Root/Root_M"
local npc3_path = "piantou_Timeline/npc/NPC_Daiweide/NPC_Daiweide_skin/To_unity/DeformationSystem/Root/Root_M"
local npc4_path = "piantou_Timeline/npc/NPC_Ethan/NPC_Ethan_skin/To_unity/DeformationSystem/Root/Root_M"
local camera_path = "piantou_Timeline/Camera"

local StateType =
{
    Show = 1,
    PlayFireEffect = 2,--播放音效
    PlayZombieEffect = 3,--播放丧尸音效
    StopZombieEffect = 4,--暂停丧尸音效
    ShowFireLight = 5,--显示火焰
}

function ResidentEnterCityScene:__init()
    self:DataDefine()
end

function ResidentEnterCityScene:__delete()
    
end

function ResidentEnterCityScene:Destroy()
    self:ComponentDestroy()
    self:DataDestroy()
end

function ResidentEnterCityScene:DataDefine()
    self.param = {}
    self.obj = {}
    self.gameObject = nil
    self.transform = nil
    self.req = nil
    self.soundEffectId = nil
    self.needPauseSound = {}
    DataCenter.GuideManager:AddOneTempFlag(GuideTempFlagType.NoShowFireLight, {})
end

function ResidentEnterCityScene:DataDestroy()
    DataCenter.GuideCityAnimManager:SetMainCameraPositionAndRotation(self.camera.transform.position, self.camera.transform.rotation)
    self:ClearSound()
    self:DestroyReq()
    self.needPauseSound = {}
    DataCenter.CityHudManager:SetCamera(nil)
    DataCenter.CityResidentManager:SetActiveAll(true)
end

function ResidentEnterCityScene:DestroyReq()
    if self.req ~= nil then
        self.req:Destroy()
        self.req = nil

        self.gameObject = nil
        self.transform = nil
    end
end

function ResidentEnterCityScene:ComponentDefine()
    self.director = self.transform:Find(all_timeline_path):GetComponent(typeof(CS.UnityEngine.Playables.PlayableDirector))
    self.obj[1] = self.transform:Find(npc1_path).gameObject
    self.obj[2] = self.transform:Find(npc2_path).gameObject
    self.obj[3] = self.transform:Find(npc3_path).gameObject
    self.obj[4] = self.transform:Find(npc4_path).gameObject
    self.camera = self.transform:Find(camera_path):GetComponent(typeof(CS.UnityEngine.Camera))
    DataCenter.CityHudManager:SetCamera(self.camera)
end

function ResidentEnterCityScene:ComponentDestroy()
end

function ResidentEnterCityScene:ReInit(param)
    self.param = param
    self:Create()
end

function ResidentEnterCityScene:Create()
    if self.req == nil then
        self.req = Resource:InstantiateAsync(UIAssets.ResidentEnterCityScene)
        self.req:completed('+', function()
            self.gameObject = self.req.gameObject
            self.transform = self.req.gameObject.transform
            self:ComponentDefine()
            self:Refresh()
            local id = SoundUtil.PlayEffect(SoundAssets.Music_Effect_Guide_Start_Timeline)
            table.insert(self.needPauseSound, id)
        end)
    elseif self.gameObject ~= nil then
        self:Refresh()
    end
end

function ResidentEnterCityScene:Refresh()
    if self.param.state == StateType.Show then
        DataCenter.CityResidentManager:SetActiveAll(false)
    elseif self.param.state == StateType.PlayFireEffect then
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Guide_Start_Fire_Light)
    elseif self.param.state == StateType.PlayZombieEffect then
        self.soundEffectId = SoundUtil.PlayEffect(SoundAssets.Music_Effect_Guide_Start_Zombie_Roar)
    elseif self.param.state == StateType.StopZombieEffect then
        self:ClearSound()
    elseif self.param.state == StateType.ShowFireLight then
        DataCenter.GuideManager:RemoveOneTempFlag(GuideTempFlagType.NoShowFireLight)
        EventManager:GetInstance():Broadcast(EventId.VitaFireStateChange)
        EventManager:GetInstance():Broadcast(EventId.VitaDataUpdate)
    else
        DataCenter.CityResidentManager:SetActiveAll(false)
    end
end

function ResidentEnterCityScene:Pause()
    self.director:Pause()
    DataCenter.GuideCityAnimManager:SetMainCameraPositionAndRotation(self.camera.transform.position, self.camera.transform.rotation)
    self:PauseSound()
end

function ResidentEnterCityScene:Resume()
    self.director:Resume()
    self:ResumeSound()
end

function ResidentEnterCityScene:GetGuideTalkObject(id)
    return self.obj[id]
end

function ResidentEnterCityScene:GotoTime(time)
    self.director.time = time
end

function ResidentEnterCityScene:ClearSound()
    if self.soundEffectId ~= nil then
        SoundUtil.StopSound(self.soundEffectId)
        self.soundEffectId = nil
    end
end

function ResidentEnterCityScene:PauseSound()
    for k,v in ipairs(self.needPauseSound) do
        SoundUtil.PauseSound(v)
    end
end

function ResidentEnterCityScene:ResumeSound()
    for k,v in ipairs(self.needPauseSound) do
        SoundUtil.ResumeSound(v)
    end
end


return ResidentEnterCityScene
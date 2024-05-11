--- Created by shimin.
--- DateTime: 2024/3/19 21:20
--- 餐厅Timeline

local ResidentScene = BaseClass("ResidentScene")
local Resource = CS.GameEntry.Resource

local all_timeline_path = "canting_Timeline"
local npc1_path = "canting_Timeline/NPC_Zuoyi/NPC_Zuoyi_skin/To_unity/DeformationSystem/Root/Root_M"
local npc2_path = "canting_Timeline/NPC_Emily/NPC_Emily_skin/To_unity/DeformationSystem/Root/Root_M"
local npc3_path = "canting_Timeline/NPC_Daiweide/NPC_Daiweide_skin/To_unity/DeformationSystem/Root/Root_M"
local npc4_path = "canting_Timeline/NPC_Ethan/NPC_Ethan_skin/To_unity/DeformationSystem/Root/Root_M"
local camera_path = "canting_Timeline/Camera"

local StateType =
{
    Show = 1,
    CancelCamera = 2,--隐藏镜头
}

function ResidentScene:__init()
    self:DataDefine()
end

function ResidentScene:__delete()
    
end

function ResidentScene:Destroy()
    self:ComponentDestroy()
    self:DataDestroy()
end

function ResidentScene:DataDefine()
    self.param = {}
    self.obj = {}
    self.gameObject = nil
    self.transform = nil
    self.req = nil
    self.needPauseSound = {}
end

function ResidentScene:DataDestroy()
    self:ClearSound()
    self:DestroyReq()
    DataCenter.CityResidentManager:SetActiveAll(true)
    if self.camera ~= nil then
        DataCenter.CityHudManager:SetCamera(nil)
        self.camera = nil
    end
    self.needPauseSound = {}
end

function ResidentScene:DestroyReq()
    if self.req ~= nil then
        self.req:Destroy()
        self.req = nil

        self.gameObject = nil
        self.transform = nil
    end
end

function ResidentScene:ComponentDefine()
    self.director = self.transform:Find(all_timeline_path):GetComponent(typeof(CS.UnityEngine.Playables.PlayableDirector))
    self.obj[1] = self.transform:Find(npc1_path).gameObject
    self.obj[2] = self.transform:Find(npc2_path).gameObject
    self.obj[3] = self.transform:Find(npc3_path).gameObject
    self.obj[4] = self.transform:Find(npc4_path).gameObject
    self.camera = self.transform:Find(camera_path):GetComponent(typeof(CS.UnityEngine.Camera))
    DataCenter.CityHudManager:SetCamera(self.camera)
end

function ResidentScene:ComponentDestroy()
end

function ResidentScene:ReInit(param)
    self.param = param
    self:Create()
end

function ResidentScene:Create()
    if self.req == nil then
        self.req = Resource:InstantiateAsync(UIAssets.ResidentScene)
        self.req:completed('+', function()
            self.gameObject = self.req.gameObject
            self.transform = self.req.gameObject.transform
            self:ComponentDefine()
            self:Refresh()
            local id = SoundUtil.PlayEffect(SoundAssets.Music_Effect_Guide_Resident_Timeline)
            table.insert(self.needPauseSound, id)
        end)
    elseif self.gameObject ~= nil then
        self:Refresh()
    end
end

function ResidentScene:Refresh()
    if self.param.state == StateType.Show then
        DataCenter.CityResidentManager:SetActiveAll(false)
    elseif self.param.state == StateType.CancelCamera then
        self.camera.gameObject:SetActive(true)
        DataCenter.GuideCityAnimManager:SetMainCameraPositionAndRotation(self.camera.transform.position, self.camera.transform.rotation)
        DataCenter.CityHudManager:SetCamera(nil)
        self.camera = nil
    else
        DataCenter.CityResidentManager:SetActiveAll(false)
    end
  
end

function ResidentScene:Pause()
    self.director:Pause()
    self:PauseSound()
end

function ResidentScene:Resume()
    self.director:Resume()
    self:ResumeSound()
end

function ResidentScene:GetGuideTalkObject(id)
    return self.obj[id]
end

function ResidentScene:GotoTime(time)
    self.director.time = time
end

function ResidentScene:PauseSound()
    for k,v in ipairs(self.needPauseSound) do
        SoundUtil.PauseSound(v)
    end
end

function ResidentScene:ResumeSound()
    for k,v in ipairs(self.needPauseSound) do
        SoundUtil.ResumeSound(v)
    end
end

function ResidentScene:ClearSound()
    for k,v in ipairs(self.needPauseSound) do
        SoundUtil.StopSound(v)
    end
end

return ResidentScene
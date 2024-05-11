--- Created by shimin.
--- DateTime: 2024/3/7 15:15
--- 工程师到来Timeline

local ResidentComeScene = BaseClass("ResidentComeScene")
local Resource = CS.GameEntry.Resource

local all_timeline_path = "Gongchengshidaolai_timeline"
local npc1_path = "Gongchengshidaolai_timeline/Role/Hero_RedShirt_Man/Hero_RedShirt_Man_skin/RedShirt_Man"
local npc2_path = "Gongchengshidaolai_timeline/Role/NPC_FarmerManA/NPC_FarmerManA_skin/NPC_FarmerManA"
local npc3_path = "Gongchengshidaolai_timeline/Role/NPC_FarmerManC/NPC_FarmerManC_skin/NPC_FarmerManC"
local camera_path = "Gongchengshidaolai_timeline/Camera"

function ResidentComeScene:__init()
    self:DataDefine()
end

function ResidentComeScene:__delete()
    
end

function ResidentComeScene:Destroy()
    self:ComponentDestroy()
    self:DataDestroy()
end

function ResidentComeScene:DataDefine()
    self.param = {}
    self.obj = {}
    self.gameObject = nil
    self.transform = nil
    self.req = nil
end

function ResidentComeScene:DataDestroy()
    if self.camera ~= nil then
        DataCenter.GuideCityAnimManager:SetMainCameraPositionAndRotation(self.camera.transform.position, self.camera.transform.rotation)
        DataCenter.CityHudManager:SetCamera(nil)
    end
   
    self:DestroyReq()
    DataCenter.CityResidentManager:SetActiveAll(true)
end

function ResidentComeScene:DestroyReq()
    if self.req ~= nil then
        self.req:Destroy()
        self.req = nil

        self.gameObject = nil
        self.transform = nil
    end
end

function ResidentComeScene:ComponentDefine()
    self.director = self.transform:Find(all_timeline_path):GetComponent(typeof(CS.UnityEngine.Playables.PlayableDirector))
    self.obj[1] = self.transform:Find(npc1_path).gameObject
    self.obj[2] = self.transform:Find(npc2_path).gameObject
    self.obj[3] = self.transform:Find(npc3_path).gameObject
    self.camera = self.transform:Find(camera_path):GetComponent(typeof(CS.UnityEngine.Camera))
    DataCenter.CityHudManager:SetCamera(self.camera)
end

function ResidentComeScene:ComponentDestroy()
end

function ResidentComeScene:ReInit(param)
    self.param = param
    self:Create()
end

function ResidentComeScene:Create()
    if self.req == nil then
        self.req = Resource:InstantiateAsync(UIAssets.ResidentComeScene)
        self.req:completed('+', function()
            self.gameObject = self.req.gameObject
            self.transform = self.req.gameObject.transform
            self:ComponentDefine()
            self:Refresh()
        end)
    elseif self.gameObject ~= nil then
        self:Refresh()
    end
end

function ResidentComeScene:Refresh()
    DataCenter.CityResidentManager:SetActiveAll(false)
end

function ResidentComeScene:Pause()
    self.director:Pause()
end

function ResidentComeScene:Resume()
    self.director:Resume()
end

function ResidentComeScene:GetGuideTalkObject(id)
    return self.obj[id]
end

function ResidentComeScene:GotoTime(time)
    self.director.time = time
end

return ResidentComeScene
--- Created by shimin.
--- DateTime: 2024/3/4 10:57
--- 第二天晚上，丧尸跑过来咬死一个变成丧尸表演

local SecondNightScene = BaseClass("SecondNightScene")
local Resource = CS.GameEntry.Resource

local all_timeline_path = "Dierye_Timeline_A"
local npc_path = "Dierye_Timeline_A/Dierye/Role/NPC_Daiweide/NPC_Daiweide_skin/To_unity/DeformationSystem/Root/Root_M"
local camera_path = "Dierye_Timeline_A/Dierye/Camera"

local StateType =
{
    Show = 1,
    CancelCamera = 2,--隐藏镜头
}

function SecondNightScene:__init()
    self:DataDefine()
end

function SecondNightScene:__delete()
    
end

function SecondNightScene:Destroy()
    self:ComponentDestroy()
    self:DataDestroy()
end

function SecondNightScene:DataDefine()
    self.param = {}
    self.obj = {}
    DataCenter.GuideManager:SetNoShowUIMain(GuideSetUIMainAnim.Hide)
    DataCenter.BuildBubbleManager:HideBubbleNode()
    DataCenter.CityHudManager:SetVisible(false)
    DataCenter.CityHudManager:SetLayerVisible(CityHudLayer.Speak, true)
    DataCenter.GuideManager:SetShowRandomZombie(false)-- 僵尸生成
    self.gameObject = nil
    self.transform = nil
    self.req = nil
end

function SecondNightScene:DataDestroy()
    if self.camera ~= nil then
        DataCenter.CityHudManager:SetCamera(nil)
        self.camera = nil
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

function SecondNightScene:DestroyReq()
    if self.req ~= nil then
        self.req:Destroy()
        self.req = nil

        self.gameObject = nil
        self.transform = nil
    end
end

function SecondNightScene:ComponentDefine()
    self.director = self.transform:Find(all_timeline_path):GetComponent(typeof(CS.UnityEngine.Playables.PlayableDirector))
    self.obj[1] = self.transform:Find(npc_path).gameObject
    self.camera = self.transform:Find(camera_path):GetComponent(typeof(CS.UnityEngine.Camera))
    self.camera.gameObject:SetActive(false)
    --DataCenter.CityHudManager:SetCamera(self.camera)
end

function SecondNightScene:ComponentDestroy()
end

function SecondNightScene:ReInit(param)
    self.param = param
    self:Create()
end

function SecondNightScene:Create()
    if self.req == nil then
        self.req = Resource:InstantiateAsync(UIAssets.SecondNightScene)
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

function SecondNightScene:Refresh()
    if self.param.state == StateType.Show then
        self.camera.gameObject:SetActive(true)
        DataCenter.CityHudManager:SetCamera(self.camera)
        DataCenter.CityResidentManager:SetActiveAll(false)
    elseif self.param.state == StateType.CancelCamera then
        DataCenter.GuideCityAnimManager:SetMainCameraPositionAndRotation(self.camera.transform.position, self.camera.transform.rotation)
        self.camera.gameObject:SetActive(false)
        self.camera = nil
        DataCenter.CityHudManager:SetCamera(nil)
    else
        DataCenter.CityResidentManager:SetActiveAll(false)
    end
end

function SecondNightScene:Pause()
    self.director:Pause()
end

function SecondNightScene:Resume()
    self.director:Resume()
end

function SecondNightScene:GetGuideTalkObject(id)
    return self.obj[id]
end

function SecondNightScene:GotoTime(time)
    self.director.time = time
end

return SecondNightScene
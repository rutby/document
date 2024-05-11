--- Created by shimin.
--- DateTime: 2024/3/26 15:51
--- 第二天晚上B段

local SecondNightBScene = BaseClass("SecondNightBScene")
local Resource = CS.GameEntry.Resource

local all_timeline_path = "Dierye_Timeline_B"
local camera_path = "Dierye_Timeline_B/Camera"

local StateType =
{
    HideCamera = 1,--隐藏镜头
    ShowCamera = 2,--显示镜头
    CancelCamera = 3,--隐藏镜头，并改变主镜头值
}

function SecondNightBScene:__init()
    self:DataDefine()
end

function SecondNightBScene:__delete()
    
end

function SecondNightBScene:Destroy()
    self:ComponentDestroy()
    self:DataDestroy()
end

function SecondNightBScene:DataDefine()
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
    self.zombie = nil
end

function SecondNightBScene:DataDestroy()
    DataCenter.GuideManager:SetNoShowUIMain(GuideSetUIMainAnim.Show)
    DataCenter.BuildBubbleManager:ShowBubbleNode()
    DataCenter.CityHudManager:SetVisible(true)
    DataCenter.CityResidentManager:SetActiveAll(true)
    DataCenter.GuideManager:SetShowRandomZombie(true)-- 僵尸生成

    DataCenter.LandManager:SetShowBlockEffect(true) -- 显示地块特效
    DataCenter.LandManager:RefreshAllObjects()
    if self.zombie ~= nil then
        self.zombie:SetPos(Vector3.New(97.065, 0.2, 102.008))
        self.zombie = nil
    end
    self:DestroyReq()
    if self.camera ~= nil then
        DataCenter.CityHudManager:SetCamera(nil)
        self.camera = nil
    end
end

function SecondNightBScene:DestroyReq()
    if self.req ~= nil then
        self.req:Destroy()
        self.req = nil

        self.gameObject = nil
        self.transform = nil
    end
end

function SecondNightBScene:ComponentDefine()
    self.director = self.transform:Find(all_timeline_path):GetComponent(typeof(CS.UnityEngine.Playables.PlayableDirector))
    self.camera = self.transform:Find(camera_path):GetComponent(typeof(CS.UnityEngine.Camera))
    DataCenter.CityHudManager:SetCamera(self.camera)
end

function SecondNightBScene:ComponentDestroy()
end

function SecondNightBScene:ReInit(param)
    self.param = param
    self:Create()
end

function SecondNightBScene:Create()
    if self.req == nil then
        self.req = Resource:InstantiateAsync(UIAssets.SecondNightBScene)
        self.req:completed('+', function()
            self.gameObject = self.req.gameObject
            self.transform = self.req.gameObject.transform
            self:ComponentDefine()
            self:LoadZombie()
            self:Refresh()
        end)
    elseif self.gameObject ~= nil then
        self:Refresh()
    end
end

function SecondNightBScene:Refresh()
    if self.param.state == StateType.HideCamera then
        self.camera.gameObject:SetActive(false)
    elseif self.param.state == StateType.ShowCamera then
        self.camera.gameObject:SetActive(true)
    elseif self.param.state == StateType.CancelCamera then
        self.camera.gameObject:SetActive(true)
        DataCenter.GuideCityAnimManager:SetMainCameraPositionAndRotation(self.camera.transform.position, self.camera.transform.rotation)
        DataCenter.CityHudManager:SetCamera(nil)
        self.camera = nil
    else
        DataCenter.CityResidentManager:SetActiveAll(false)
    end
end

function SecondNightBScene:Pause()
    self.director:Pause()
end

function SecondNightBScene:Resume()
    self.director:Resume()
end

function SecondNightBScene:GetGuideTalkObject(id)
    return self.obj[id]
end

function SecondNightBScene:LoadZombie()
    local zombieUuid = DataCenter.CityResidentManager:GetNextZombieUuid()
    local zombieParam = {}
    zombieParam.prefabPath = "Assets/Main/Prefab_Dir/Home/Zombie/A_Zombie_Home_2.prefab"
    DataCenter.CityResidentManager:AddData(zombieUuid, CityResidentDefines.Type.Zombie, zombieParam, function()
        local zombieData = DataCenter.CityResidentManager:GetData(zombieUuid)
        self.zombie = zombieData
        zombieData:SetGuideControl(true)
        zombieData:Idle()
        zombieData:SetPos(Vector3.New(0, 0, 0))
        zombieData:SetRot(Quaternion.Euler(0, -60, 180))
        zombieData:PlayAnim(CityResidentDefines.AnimName.Dead1)
        DataCenter.CityResidentManager:AddFireBody(zombieUuid)
        zombieData.isInvincible = true
    end)
end

function SecondNightBScene:GotoTime(time)
    self.director.time = time
end

return SecondNightBScene
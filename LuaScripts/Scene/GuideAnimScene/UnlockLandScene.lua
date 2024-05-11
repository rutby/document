--- Created by shimin.
--- DateTime: 2024/1/24 17:10
--- 开启地块表演

local UnlockLandScene = BaseClass("UnlockLandScene")
local Resource = CS.GameEntry.Resource

local all_timeline_path = "Dafuweng_Timeline"
local camera_path = "Dafuweng_Timeline/Camera"

function UnlockLandScene:__init()
    self:DataDefine()
end

function UnlockLandScene:__delete()
    
end

function UnlockLandScene:Destroy()
    self:ComponentDestroy()
    self:DataDestroy()
end

function UnlockLandScene:DataDefine()
    self.param = {}
    DataCenter.GuideManager:SetNoShowUIMain(GuideSetUIMainAnim.Hide)
    DataCenter.BuildBubbleManager:HideBubbleNode()
    DataCenter.CityHudManager:SetVisible(false)
    DataCenter.CityResidentManager:DestroyAll()-- 包括小人、僵尸、主城英雄
    DataCenter.GuideManager:SetShowRandomZombie(false)-- 僵尸生成
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_DEFENCE_CENTER_NEW)
    if buildData ~= nil then
        local pointId = buildData.pointId
        local build = CS.SceneManager.World:GetObjectByPointId(pointId)
        if build ~= nil then
            build:SetIsVisible(false)
        end
    end
    self.gameObject = nil
    self.transform = nil
    self.req = nil
end

function UnlockLandScene:DataDestroy()
    if self.camera ~= nil then
        DataCenter.GuideCityAnimManager:SetMainCameraPositionAndRotation(self.camera.transform.position, self.camera.transform.rotation)
    end
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_DEFENCE_CENTER_NEW)
    if buildData ~= nil then
        local pointId = buildData.pointId
        local build = CS.SceneManager.World:GetObjectByPointId(pointId)
        if build ~= nil then
            build:SetIsVisible(true)
        end
    end
    DataCenter.CityHudManager:SetCamera(nil)
    DataCenter.GuideManager:SetNoShowUIMain(GuideSetUIMainAnim.Show)
    DataCenter.BuildBubbleManager:ShowBubbleNode()
    DataCenter.CityHudManager:SetVisible(true)
    DataCenter.CityResidentManager:CreateAll()-- 包括小人、僵尸、主城英雄
    DataCenter.GuideManager:SetShowRandomZombie(true)-- 僵尸生成
    
    DataCenter.LandManager:SetShowBlockEffect(true) -- 显示地块特效
    DataCenter.LandManager:RefreshAllObjects()
    
    self:DestroyReq()
end

function UnlockLandScene:DestroyReq()
    if self.req ~= nil then
        self.req:Destroy()
        self.req = nil

        self.gameObject = nil
        self.transform = nil
    end
end

function UnlockLandScene:ComponentDefine()
    self.director = self.transform:Find(all_timeline_path):GetComponent(typeof(CS.UnityEngine.Playables.PlayableDirector))
    self.camera = self.transform:Find(camera_path):GetComponent(typeof(CS.UnityEngine.Camera))
    DataCenter.CityHudManager:SetCamera(self.camera)
end

function UnlockLandScene:ComponentDestroy()
   
end

function UnlockLandScene:ReInit(param)
    self.param = param
    self:Create()
end

function UnlockLandScene:Create()
    if self.req == nil then
        self.req = Resource:InstantiateAsync(UIAssets.UnlockLandScene)
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

function UnlockLandScene:Refresh()
    
end

function UnlockLandScene:Pause()
    self.director:Pause()
end

function UnlockLandScene:Resume()
    self.director:Resume()
end

function UnlockLandScene:GotoTime(time)
    self.director.time = time
end



return UnlockLandScene
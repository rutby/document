---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/12/26 11:08
---
--(100,0,132)

local Sound3DEffectManager = BaseClass("Sound3DEffectManager", Singleton)
local ResourceManager = CS.GameEntry.Resource
local objPath = "Assets/Main/Prefab_Dir/3DSound/SoundObj.prefab"

local  Sound3DTable = 
{
    ["zombie"] = {id = "zombie",pos = {x = 100,y=0,z=132},sound = "Effect_zombie_round"},
    ["fire"] = {id = "fire",pos = {x = 101,y=0,z=101},sound = "Effect_fireplace"},
}
local function __init(self)
    self.allSounds = {}
    self.OnCreateSounds ={}
    self.isInCity = true
    self:AddListener()
end

local function __delete(self)
    self.isInCity = true
    self:RemoveListener()
end

local function AddListener(self)
    EventManager:GetInstance():AddListener(EventId.OnEnterWorld, self.OnEnterWorld)
    EventManager:GetInstance():AddListener(EventId.OnEnterCity, self.OnEnterCity)
    EventManager:GetInstance():AddListener(EventId.VitaFireStateChange, self.RefreshFire)
    EventManager:GetInstance():AddListener(EventId.WORLD_CAMERA_CHANGE_POINT, self.OnCameraChange)
    EventManager:GetInstance():AddListener(EventId.PveLevelBeforeEnter, self.RemoveAllTips)
    EventManager:GetInstance():AddListener(EventId.OpenUI, self.RefreshFire)--打开UI
    EventManager:GetInstance():AddListener(EventId.CloseUI, self.RefreshFire)
end

local function RemoveListener(self)
    EventManager:GetInstance():RemoveListener(EventId.PveLevelBeforeEnter, self.RemoveAllTips)
    EventManager:GetInstance():RemoveListener(EventId.OnEnterWorld, self.OnEnterWorld)
    EventManager:GetInstance():RemoveListener(EventId.OnEnterCity, self.OnEnterCity)
    EventManager:GetInstance():RemoveListener(EventId.VitaFireStateChange, self.RefreshFire)
    EventManager:GetInstance():RemoveListener(EventId.WORLD_CAMERA_CHANGE_POINT, self.OnCameraChange)
    EventManager:GetInstance():RemoveListener(EventId.OpenUI, self.RefreshFire)--打开UI
    EventManager:GetInstance():RemoveListener(EventId.CloseUI, self.RefreshFire)
end


local function RemoveAllTips(data)
    Sound3DEffectManager:GetInstance():SetIsInCity(false)
    Sound3DEffectManager:GetInstance():RemoveAllEffect()
end
local function OnEnterWorld(data)
    Sound3DEffectManager:GetInstance():SetIsInCity(false)
    Sound3DEffectManager:GetInstance():RemoveAllEffect()
end
local function OnEnterCity(data)
    Sound3DEffectManager:GetInstance():SetIsInCity(true)
    Sound3DEffectManager:GetInstance():TryAdd3DSoundItem()
end

function Sound3DEffectManager:SetIsInCity(value)
    self.isInCity = value
end

function Sound3DEffectManager:GetIsInCity()
    return self.isInCity
end
local function OnCameraChange(data)
    if SceneUtils.GetIsInCity() and Sound3DEffectManager:GetInstance():GetIsInCity() then
        local worldPos = CS.SceneManager.World.CurTarget
        local zoom = CS.SceneManager.World.Zoom
        SoundUtil.SyncListenerPos(worldPos.x, zoom * 0.25, worldPos.z)
    end
end
local function RefreshFire(data)
    if SceneUtils.GetIsInCity() and Sound3DEffectManager:GetInstance():GetIsInCity() then
        local state = DataCenter.VitaManager:GetFurnaceState()
        if  state ~= VitaDefines.FurnaceState.Close and UIManager:GetInstance():CheckIfIsMainUIOpenOnly(true, {UIWindowNames.UIGuideTalk})  then
            Sound3DEffectManager:GetInstance():ShowFireSound()
        else
            Sound3DEffectManager:GetInstance():CloseFireSound()
        end
    end
end

local function ShowFireSound(self)
    local soundSet = Sound3DTable["fire"]
    if soundSet~=nil then
        self:Add3DSoundItem(soundSet.id,soundSet.sound,soundSet.pos)
    end
end
local function CloseFireSound(self)
    self:Remove3DSoundItem("fire")
end
local function TryAdd3DSoundItem(self)
    if SceneUtils.GetIsInCity() and Sound3DEffectManager:GetInstance():GetIsInCity() then
        self.isInCity = true
        for k,v in pairs(Sound3DTable) do
            if v.id~= "fire" then
                self:Add3DSoundItem(v.id,v.sound,v.pos)
            end
        end
        self:RefreshFire()
    end
end

local function Add3DSoundItem(self,id,effectPath,pos)
    if self.allSounds[id] ==nil and self.OnCreateSounds[id] == nil then
        local request = ResourceManager:InstantiateAsync(objPath)
        self.OnCreateSounds[id] = request
        request:completed('+', function()
            self.OnCreateSounds[id] =nil
            if request.isError then
                return
            end
            request.gameObject:SetActive(true)
            request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
            request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            request.gameObject.transform:Set_position(pos.x, pos.y, pos.z)
            self.allSounds[id] = {obj = request.gameObject,req = request}
            SoundUtil.Play3DSound(request.gameObject,effectPath)
        end)
    end
end

local function Remove3DSoundItem(self,id)
    local value = self.allSounds[id]
    if value~=nil then
        SoundUtil.Stop3DSound(value.obj)
        value.req:Destroy()
        self.allSounds[id] = nil
    end
    local valueInst = self.OnCreateSounds[id]
    if valueInst~=nil then
        valueInst:Destroy()
        self.OnCreateSounds[id]= nil
    end
end

local function RemoveAllEffect(self)
    
    SoundUtil.Remove3DSoundAll()
    if self.allSounds~=nil then
        for k,v in pairs(self.allSounds) do
            SoundUtil.Stop3DSound(v.obj)
            local req = v.req
            req:Destroy()
        end
        self.allSounds = {}
    end
    if self.OnCreateSounds~=nil then
        for k,v in pairs(self.OnCreateSounds) do
            v:Destroy()
        end
        self.OnCreateSounds ={}
    end

end


Sound3DEffectManager.OnEnterWorld = OnEnterWorld
Sound3DEffectManager.OnEnterCity = OnEnterCity
Sound3DEffectManager.__init = __init
Sound3DEffectManager.__delete = __delete
Sound3DEffectManager.AddListener = AddListener
Sound3DEffectManager.RemoveListener = RemoveListener
Sound3DEffectManager.RemoveAllTips =RemoveAllTips
Sound3DEffectManager.RemoveAllEffect = RemoveAllEffect
Sound3DEffectManager.TryAdd3DSoundItem =TryAdd3DSoundItem
Sound3DEffectManager.Remove3DSoundItem =Remove3DSoundItem
Sound3DEffectManager.Add3DSoundItem =Add3DSoundItem
Sound3DEffectManager.CloseFireSound =CloseFireSound
Sound3DEffectManager.ShowFireSound =ShowFireSound
Sound3DEffectManager.RefreshFire =RefreshFire
Sound3DEffectManager.OnCameraChange =OnCameraChange
return Sound3DEffectManager
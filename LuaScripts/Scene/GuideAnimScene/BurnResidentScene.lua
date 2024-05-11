--- Created by shimin.
--- DateTime: 2024/3/6 17:32
--- 烧小人场景

local BurnResidentScene = BaseClass("BurnResidentScene")
local Resource = CS.GameEntry.Resource

local StateType =
{
    Show = 1,--显示3个尸体
    Burn = 2,--烧尸体
}

local ResidentPos =
{
    [-100] = {pos = Vector3.New(99.1, 0, 98), angle = 30, prefab = "Assets/Main/Prefab_Dir/Home/Resident/A_Resident_Male_3.prefab"},
    [-101] = {pos = Vector3.New(101.62, 0, 97), angle = 170, prefab = "Assets/Main/Prefab_Dir/Home/Resident/A_Resident_Male_4.prefab"},
    [-102] = {pos = Vector3.New(103.2, 0, 98), angle = 90, prefab = "Assets/Main/Prefab_Dir/Home/Resident/A_Resident_Female_5.prefab"},
}

local HeroIndex = 1

function BurnResidentScene:__init()
    self:DataDefine()
end

function BurnResidentScene:__delete()
    
end

function BurnResidentScene:Destroy()
    self:ComponentDestroy()
    self:DataDestroy()
end

function BurnResidentScene:DataDefine()
    self.param = {}
    self.isBurning = false
    self.waitBurn = {}
    self.allFake = {}
end

function BurnResidentScene:DataDestroy()
    if self.waitBurn[1] == nil and table.count(self.allFake) > 0 then
        for k,v in pairs(self.allFake) do
            DataCenter.CityResidentManager:RemoveData(k)
        end
        self.allFake = {}
    end
end

function BurnResidentScene:DestroyReq()
end

function BurnResidentScene:ComponentDefine()
end

function BurnResidentScene:ComponentDestroy()
end

function BurnResidentScene:ReInit(param)
    self.param = param
    self:Create()
end

function BurnResidentScene:Create()
    if self.param.state == StateType.Show then
        self:Show()
    elseif self.param.state == StateType.Burn then
        table.insert(self.waitBurn, self.param.id)
        self:Burn()
    end
end

function BurnResidentScene:Refresh()
    
end

function BurnResidentScene:Pause()
    
end

function BurnResidentScene:Resume()
  
end

function BurnResidentScene:Show()
    for k,v in pairs(ResidentPos) do
        local param = {}
        param.uuid = k
        param.id = k
        param.prefabPath = v.prefab
        DataCenter.CityResidentManager:AddData(param.uuid, CityResidentDefines.Type.Resident, param, function()
            local data = DataCenter.CityResidentManager:GetData(param.uuid)
            if data ~= nil then
                -- 指定动作
                data:SetGuideControl(true)
                data.atBUuid = 0
                data:Idle()
                data:SetPos(v.pos)
                data:PlayAnim(CityResidentDefines.AnimName.Die)
                data:SetRot(Quaternion.Euler(0, v.angle, 0))
            end
        end)
        self.allFake[k] = true
    end
end


function BurnResidentScene:Burn()
    if not self.isBurning and self.waitBurn[1] ~= nil then
        self.isBurning = true
        local id = table.remove(self.waitBurn, 1)
        local data = DataCenter.CityResidentManager:GetDataByIndex(CityResidentDefines.Type.Hero, HeroIndex)
        local zombieData = DataCenter.CityResidentManager:GetData(id)
        if zombieData ~= nil and data ~= nil then
            local dir = Vector3.Normalize(zombieData:GetPos() - data:GetPos())
            local pos = zombieData:GetPos() - dir * 0.4
            data:PlayAnim(CityResidentDefines.AnimName.RunHold)
            data:SetSpeed(CityResidentDefines.SpeedHeroFire)
            data:ShowHeroTorch()
            data:GoToCityPos(pos)
            data.onFinish = function()
                data:LookAt(zombieData:GetPos())
                data:ShowHeroTorch()
                data:Idle()
                data:PlayAnim(CityResidentDefines.AnimName.Ignite)
                data:WaitForFinish(1)
                data.onFinish = function()
                    data.onFinish = nil
                    zombieData:Idle()
                    zombieData:WaitForFinish(2)
                    DataCenter.CityResidentManager:ShowEffect("Assets/Main/Prefab_Dir/Home/Effect/Common/sence_effect_fire.prefab", nil, zombieData:GetPos(), 2)
                    zombieData.onFinish = function()
                        data:PlayAnim(CityResidentDefines.AnimName.Idle)
                        zombieData.onFinish = nil
                        self.allFake[zombieData.uuid] = nil
                        DataCenter.CityResidentManager:RemoveData(zombieData.uuid)
                        self.isBurning = false
                        if self.waitBurn[1] == nil then
                            if table.count(self.allFake) == 0 then
                                DataCenter.CityResidentMovieManager:Play(CityResidentDefines.Movie.ReleaseResident)
                            end
                        else
                            self:Burn()
                        end
                    end
                end
            end
        end
    end
end

return BurnResidentScene
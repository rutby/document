--- Created by shimin
--- DateTime: 2023/4/17 17:17
--- 大本被攻击后盟友援助表现

local AllianceHelpVirtualMarch = BaseClass("AllianceHelpVirtualMarch")
local Resource = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization

local troop_name_text_path = "WorldTroopName/Transform/name"
local troop_anim_path = "WorldTroop/Model/A_vehicle_ybc_prefab"

local RunAnimName = "run"
local ReachDistance = 1

function AllianceHelpVirtualMarch:__init()
    self.req = nil
    self.gameObject = nil
    self.transform = nil
    self.param = nil
    self.troopLineReq = nil
    self.troopLine = nil
    self.pos = Vector3.New(0,0,0)
    self.realName = ""
    self.isReached = false
end

function AllianceHelpVirtualMarch:Destroy()
    self:DestroyTroopLine()
    self:DestroyModel()
    self.param = nil
    self.pos = Vector3.New(0,0,0)
    self.realName = ""
    self.isReached = false
end

function AllianceHelpVirtualMarch:Create()
    if self.req == nil then
        self.req = Resource:InstantiateAsync(UIAssets.AllianceHelpVirtualMarch)
        self.req:completed('+', function()
            self.gameObject = self.req.gameObject
            self.transform = self.req.gameObject.transform
            self:InitComponent()
            self.gameObject:SetActive(true)
            self.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
            self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            self.gameObject.name = self.param.memberInfo.name
            self:Refresh()
        end)
    else
        self:Refresh()
    end
end

function AllianceHelpVirtualMarch:InitComponent()
    self.troop_name_text = self.transform:Find(troop_name_text_path):GetComponent(typeof(CS.SuperTextMesh))
    self.troop_anim = self.transform:Find(troop_anim_path):GetComponent(typeof(CS.GPUSkinningAnimator))
end

function AllianceHelpVirtualMarch:ReInit(param)
    self.param = param
    self.realName = "[" .. self.param.memberInfo.alAbbr .. "]" .. self.param.memberInfo.name
    self.pos = self.param.startPointV3
    self:SetVirtualMarchVisible(self.param.visible)
end

function AllianceHelpVirtualMarch:Refresh()
    self.troop_name_text.text = self.realName
    self.troop_name_text.color32 = WorldBlueColor32
    self:RefreshPos()
    self.transform.rotation = Quaternion.LookRotation(self.param.dir, Vector3.up)
    self.troop_anim:Play(RunAnimName)
    self:CreateTroopLine()
end

function AllianceHelpVirtualMarch:RefreshPosition(deltaTime)
    if not self.isReached then
        self.pos.x = self.pos.x + self.param.speed * self.param.dir.x * deltaTime
        self.pos.z = self.pos.z + self.param.speed * self.param.dir.z * deltaTime
        self:RefreshPos()
        if Vector3.Distance(self.pos, self.param.endPointV3) < ReachDistance then
            self.isReached = true
            self:DestroyTroopLine()
            self:DestroyModel()
        end
    end
end

function AllianceHelpVirtualMarch:CreateTroopLine()
    if self.troopLineReq == nil then
        self.troopLineReq = Resource:InstantiateAsync(UIAssets.TroopLine)
        self.troopLineReq:completed('+', function()
            self.troopLineReq.gameObject:SetActive(true)
            self.troopLineReq.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
            self.troopLine = self.troopLineReq.gameObject:GetComponent(typeof(CS.WorldTroopLine))
            if self.troopLine ~= nil then
                self.troopLine:SetColor(Color.New(0.39, 0.58, 0.94,1))
                self:RefreshLinePos()
            end
        end)
    else
        self:RefreshLinePos()
    end
end

function AllianceHelpVirtualMarch:RefreshPos()
    if self.transform ~= nil then
        self.transform.position = self.pos
        self:RefreshLinePos()
    end
end

function AllianceHelpVirtualMarch:RefreshLinePos()
    if self.troopLine ~= nil then
        self.troopLine:SetStraightMovePath(self.pos, self.param.endPointV3)
    end
end

function AllianceHelpVirtualMarch:DestroyTroopLine()
    if self.troopLineReq ~= nil then
        self.troopLineReq:Destroy()
        self.troopLineReq = nil
    end
    self.troopLine = nil
end

function AllianceHelpVirtualMarch:GetVirtualMemberShowParam()
    if not self.isReached then
        local result = {}
        local distance = Vector3.Distance(self.pos, self.param.endPointV3)
        result.endTime = UITimeManager:GetInstance():GetServerTime() + distance / self.param.speed * 1000
        result.isVirtual = true
        result.leftName = self.realName
        result.rightName = Localization:GetString(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), 
                BuildingTypes.FUN_BUILD_MAIN,"name"))
        return result
    end
    return nil
end

function AllianceHelpVirtualMarch:SetVirtualMarchVisible(visible)
    self.param.visible = visible
    if visible and (not self.isReached)then
        self:Create()
    else
        self:DestroyTroopLine()
        self:DestroyModel()
    end
end

function AllianceHelpVirtualMarch:DestroyModel()
    if self.req ~= nil then
        self.req:Destroy()
        self.req = nil
    end
    self.gameObject = nil
    self.transform = nil
end


return AllianceHelpVirtualMarch
--[[
UIMainCenter
--]]


local UIMainCenter = BaseClass("UIMainCenter", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local world_world_center_back_btn_path = "WorldCenterBackBtn"
local world_world_center_back_arrow_path = "WorldCenterBackBtn/WorldCenterBackArrow"
local world_world_center_back_name_path = "WorldCenterBackBtn/WorldCenterBackBtnName"

--local UIUtil = CS.UIUtils

local leftPadding = 120
local topPadding = 120
local NamePosDelta = Vector3.New(0,0,0)
local BgRotationDelta = Vector3.New(0,0,180)
local BackBtnShowDistance = 8

-- 创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

-- 显示
local function OnEnable(self)
    base.OnEnable(self)
    self:ReInit()
end

-- 隐藏
local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
end


local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end


--控件的定义
local function ComponentDefine(self)
    self.lossyScale = UIManager:GetInstance():GetScaleFactor()
    self.world_world_center_back_btn = self:AddComponent(UIButton, world_world_center_back_btn_path)
    self.world_world_center_back_arrow = self:AddComponent(UIBaseContainer, world_world_center_back_arrow_path)
    self.world_world_center_back_name = self:AddComponent(UITextMeshProUGUIEx, world_world_center_back_name_path)
    self.world_world_center_back_btn:SetOnClick(function()
        local finalPos = self.ConstructPos
        self.view.ctrl:OnClickBackHomeBtn(finalPos)
    end)
end

--控件的销毁
local function ComponentDestroy(self)
    self.world_world_center_back_btn = nil
    self.world_world_center_back_arrow = nil
    self.world_world_center_back_name = nil
end

--变量的定义
local function DataDefine(self)
	local x, y = self.transform:Get_lossyScale()
    self.lossyScale = y
    self.mileDist = 0;
    self.position = Vector3.New(self.transform:Get_position())
    self.isVisible = true
    self.worldWorldCenterActive = nil
    self.worldWorldCenterBackBtnRotation = nil
    self.worldWorldCenterBackBtnPositionX = nil
	self.worldWorldCenterBackBtnPositionY = nil
    self.disText = Localization:GetString(GameDialogDefine.KILOMETRE)
end

--变量的销毁
local function DataDestroy(self)
    self.lossyScale = nil
    self.mileDist = nil
    self.position = nil
    self.isVisible = nil
    self.worldWorldCenterActive = nil
    self.worldWorldCenterBackBtnRotation = nil
    self.worldWorldCenterBackBtnPositionX = nil
	self.worldWorldCenterBackBtnPositionY = nil
    self.disText = nil
end



-- 全部刷新
local function ReInit(self)
    self:ShowVisible()
    self.ConstructPos = nil
    self:UpdateMilePointer(false)
end


local function GetCenterPointCanMoveRange(self,direction)
    return self.centerRange[direction] or {}
end
local function SetVisible(self,isVisible)
    if self.isVisible ~= isVisible then
        self.isVisible = isVisible
        self:ShowVisible()
    end
end

local function ShowVisible(self)
    if self.isVisible then
        self.transform:Set_position(self.position.x, self.position.y, self.position.z)
    else
        self.transform:Set_position(FalseVisiblePos.x, FalseVisiblePos.y, FalseVisiblePos.z)
    end
end

local function UpdateConstructPos(self, tempPos)
    self.ConstructPos = tempPos
end

local function UpdateMilePointer(self,isShow)
    if isShow then
        local show, dist, refDistance, refDist
		local pos_x, pos_y, eulerAngles_z

        if SceneUtils.GetIsInCity() then
            show = false
        else--通过大本和相机位置计算距离信息
            local curWorldPos = Vector3.zero
            local world = CS.SceneManager.World
            if world ~= nil then
                curWorldPos = world.CurTarget
            end
            if self.ConstructPos == nil then
                refDistance = BackBtnShowDistance
                show, dist, pos_x, pos_y, eulerAngles_z = UIUtil.CalcMilePointer(leftPadding * self.lossyScale,topPadding * self.lossyScale)
            else
                refDistance = 0
                show, dist, pos_x, pos_y, eulerAngles_z = UIUtil.CalcConstructMilePointer(leftPadding * self.lossyScale,topPadding * self.lossyScale, self.ConstructPos,CS.SceneManager.World.CurTarget)
            end
            
            refDist = dist
        end
        
        if show and dist > refDistance then
            self:SetWorldWorldCenterActive(true)
            self:SetWorldWorldCenterBackBtnRotation(eulerAngles_z)
            self:SetWorldWorldCenterBackBtnPosition(pos_x, pos_y)
            self:SetWorldWorldCenterBackName(refDist .. self.disText)
        else
            self:SetWorldWorldCenterActive(false)
        end
    else
        self:SetWorldWorldCenterActive(false)
    end
end

local function SetWorldWorldCenterActive(self,value)
    if self.worldWorldCenterActive ~= value then
        self.worldWorldCenterActive = value
        self.world_world_center_back_btn:SetActive(value)
        self.world_world_center_back_name:SetActive(value)
    end
end

local function SetWorldWorldCenterBackBtnPosition(self, x, y)
    if self.worldWorldCenterBackBtnPositionX == x and 
		self.worldWorldCenterBackBtnPositionY == y then
		return 
	end
	
    self.worldWorldCenterBackBtnPositionX = x
	self.worldWorldCenterBackBtnPositionY = y
    self.world_world_center_back_btn:SetPositionXYZ(x, y, 0)
    self.world_world_center_back_name:SetPositionXYZ(x + NamePosDelta.x * self.lossyScale, y + NamePosDelta.y * self.lossyScale, 0)

end

local function SetWorldWorldCenterBackBtnRotation(self,value)
    if self.worldWorldCenterBackBtnRotation ~= value then
        self.worldWorldCenterBackBtnRotation = value
        self.world_world_center_back_arrow:SetEulerAnglesXYZ(0, 0, BgRotationDelta.z + value)
    end
end

local function SetWorldWorldCenterBackName(self,value)
    if self.worldWorldCenterBackName ~= value then
        self.worldWorldCenterBackName = value
        self.world_world_center_back_name:SetText(value)
    end
end

UIMainCenter.OnCreate = OnCreate
UIMainCenter.OnDisable = OnDisable
UIMainCenter.OnDestroy = OnDestroy
UIMainCenter.ReInit = ReInit
UIMainCenter.ComponentDefine = ComponentDefine
UIMainCenter.DataDefine = DataDefine
UIMainCenter.ComponentDestroy = ComponentDestroy
UIMainCenter.DataDestroy = DataDestroy
UIMainCenter.OnEnable = OnEnable
UIMainCenter.SetVisible = SetVisible
UIMainCenter.ShowVisible = ShowVisible
UIMainCenter.OnAddListener = OnAddListener
UIMainCenter.OnRemoveListener = OnRemoveListener
UIMainCenter.UpdateMilePointer = UpdateMilePointer
UIMainCenter.SetWorldWorldCenterActive = SetWorldWorldCenterActive
UIMainCenter.SetWorldWorldCenterBackBtnPosition = SetWorldWorldCenterBackBtnPosition
UIMainCenter.SetWorldWorldCenterBackBtnRotation = SetWorldWorldCenterBackBtnRotation
UIMainCenter.SetWorldWorldCenterBackName = SetWorldWorldCenterBackName
UIMainCenter.UpdateConstructPos = UpdateConstructPos
UIMainCenter.InitCenterRange =InitCenterRange
UIMainCenter.GetCenterPointCanMoveRange = GetCenterPointCanMoveRange
return UIMainCenter
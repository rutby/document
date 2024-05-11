

local UIUpPowerView = BaseClass("UIUpPowerView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIUpPowerItem = require("UI.UIUpPower.Comp.UIUpPowerItem")

local panelBtn_path = "UICommonMidPopUpTitle/panel"
local buildingItem_path = "Main/ScrollView/Viewport/Content/UIUpPowerItem_building"
local heroItem_path = "Main/ScrollView/Viewport/Content/UIUpPowerItem_hero"
local soldierItem_path = "Main/ScrollView/Viewport/Content/UIUpPowerItem_soldier"
local yunbingcheItem_path = "Main/ScrollView/Viewport/Content/UIUpPowerItem_yunbingche"
local techItem_path = "Main/ScrollView/Viewport/Content/UIUpPowerItem_tech"
local closeBtn_path = "UICommonMidPopUpTitle/bg_mid/CloseBtn"
local titleText_path = "UICommonMidPopUpTitle/bg_mid/titleText"
local suggestTxt_path = "Main/suggestTxt"
local curTxt_path = "Main/curTxt"

function UIUpPowerView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

function UIUpPowerView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIUpPowerView:OnEnable()
    base.OnEnable(self)
    self:RefreshAll()
end

function UIUpPowerView:OnDisable()
    base.OnDisable(self)
end

function UIUpPowerView:ComponentDefine()
    self.buildingItem = self:AddComponent(UIUpPowerItem, buildingItem_path)
    self.buildingItem:InitItemType(1)
    self.heroItem = self:AddComponent(UIUpPowerItem, heroItem_path)
    self.heroItem:InitItemType(2)
    self.soldierItem = self:AddComponent(UIUpPowerItem, soldierItem_path)
    self.soldierItem:InitItemType(3)
    self.yunbingcheItem = self:AddComponent(UIUpPowerItem, yunbingcheItem_path)
    self.yunbingcheItem:InitItemType(4)
    self.techItem = self:AddComponent(UIUpPowerItem, techItem_path)
    self.techItem:InitItemType(5)
    
    self.CloseBtn = self:AddComponent(UIButton, closeBtn_path)
    self.CloseBtn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.panelBtn = self:AddComponent(UIButton, panelBtn_path)
    self.panelBtn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.suggestTxt = self:AddComponent(UITextMeshProUGUIEx, suggestTxt_path)
    self.suggestTxt:SetLocalText(110334)
    self.curTxt = self:AddComponent(UITextMeshProUGUIEx, curTxt_path)
    self.curTxt:SetLocalText(372190)
    self.titleText = self:AddComponent(UITextMeshProUGUIEx, titleText_path)
    self.titleText:SetLocalText(321008)
end

function UIUpPowerView:ComponentDestroy()

end

function UIUpPowerView:DataDefine()

end

function UIUpPowerView:DataDestroy()

end


function UIUpPowerView:RefreshAll()
    local level = DataCenter.BuildManager.MainLv
    local data = DataCenter.QuestTemplateManager:GetUpPowerData(level).data
    local percent = DataCenter.QuestTemplateManager:GetUpPowerData(level).percent / 100
    
    local priority2ItemDic = {}
    local priority2Per = {}
    --建筑战力
    local data1 = string.split(data[2], ",")
    local sg1 = toInt(data1[1])
    local priority1 = toInt(data1[2])
    priority2ItemDic[priority1] = self.buildingItem
    priority2Per[priority1] = (sg1 - LuaEntry.Player.buildingPower)/LuaEntry.Player.buildingPower
    if true then
        self.buildingItem:SetActive(true)
        self.buildingItem:Refresh(sg1, LuaEntry.Player.buildingPower)
    else
        self.buildingItem:SetActive(false)
    end
    --英雄战力
    local data2 = string.split(data[3], ",")
    local sg2 = toInt(data2[1])
    local priority2 = toInt(data2[2])
    priority2ItemDic[priority2] = self.heroItem
    priority2Per[priority2] = (sg2 - LuaEntry.Player.heroPower)/LuaEntry.Player.heroPower
    if true then
        self.heroItem:SetActive(true)
        self.heroItem:Refresh(sg2, LuaEntry.Player.heroPower)
    else
        self.heroItem:SetActive(false)
    end
    --士兵战力
    local data3 = string.split(data[4], ",")
    local sg3 = toInt(data3[1])
    local priority3 = toInt(data3[2])
    priority2ItemDic[priority3] = self.soldierItem
    priority2Per[priority3] = (sg3 - LuaEntry.Player.armyPower)/LuaEntry.Player.armyPower
    if self:CheckHasBuild(BuildingTypes.FUN_BUILD_CAR_BARRACK) or self:CheckHasBuild(BuildingTypes.FUN_BUILD_INFANTRY_BARRACK) or self:CheckHasBuild(BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK) then
        self.soldierItem:SetActive(true)
        self.soldierItem:Refresh(sg3, LuaEntry.Player.armyPower)
    else
        self.soldierItem:SetActive(false)
    end
    --运兵车战力
    local yunbingchePower = 0
    for _, buildId in ipairs(GarageBuildIds) do
        local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
        local refitData = DataCenter.GarageRefitManager:GetGarageRefitDataCopy(buildId)
        if buildData and buildData.level > 0 then
            local temp = DataCenter.GarageRefitManager:GetModifyTemplate(buildId, refitData.level)
            yunbingchePower = yunbingchePower + temp:getValue("power")
        end
    end
    local data4 = string.split(data[5], ",")
    local sg4 = toInt(data4[1])
    local priority4 = toInt(data4[2])
    priority2ItemDic[priority4] = self.yunbingcheItem
    priority2Per[priority4] = (sg4 - yunbingchePower)/yunbingchePower
    local lockLevel = LuaEntry.DataConfig:TryGetNum("car_modify", "k4")
    if (self:CheckHasBuild(BuildingTypes.FUN_BUILD_TRAINFIELD_1) or self:CheckHasBuild(BuildingTypes.FUN_BUILD_TRAINFIELD_2) or self:CheckHasBuild(BuildingTypes.FUN_BUILD_TRAINFIELD_3))
     and level >= lockLevel then
        self.yunbingcheItem:SetActive(true)
        self.yunbingcheItem:Refresh(sg4, yunbingchePower)
    else
        self.yunbingcheItem:SetActive(false)
    end
    --科技战力（需要减去运兵车战力）
    if data[6] then
        local data5 = string.split(data[6], ",")
        local sg5 = toInt(data5[1])
        local priority5 = toInt(data5[2])
        local techPower = tonumber(LuaEntry.Player.sciencePower) - yunbingchePower
        priority2ItemDic[priority5] = self.techItem
        priority2Per[priority5] = (sg5 - techPower)/techPower
        if self:CheckHasBuild(BuildingTypes.FUN_BUILD_SCIENE) then
            self.techItem:SetActive(true)
            self.techItem:Refresh(sg5, techPower)
        else
            self.techItem:SetActive(false)
        end
    else
        self.techItem:SetActive(false)
    end

    --推荐优先提升
    local sgPriority = -1
    local curPer = -1
    for k,v in pairs(priority2Per) do
        if sgPriority == -1 and v > 0 then
            sgPriority = k
            curPer = v
        else
            if curPer >= percent then
                if k > sgPriority and v >= percent then
                    sgPriority = k
                    curPer = v
                end
            else
                if k > sgPriority then
                    sgPriority = k
                    curPer = v
                end
            end
        end
    end
    if sgPriority > 0 then
        priority2ItemDic[sgPriority]:ShowSuggest()
    end
end

function UIUpPowerView:OnAddListener()
    base.OnAddListener(self)
end

function UIUpPowerView:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIUpPowerView:CheckHasBuild(id)
    local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(id)
    if buildList~=nil and table.count(buildList)>0 and buildList[1] ~=nil then
        return true
    else
        return false
    end
end

return UIUpPowerView
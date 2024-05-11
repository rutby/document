
local UIUpPowerItem = BaseClass("UIUpPowerItem", UIBaseContainer)
local base = UIBaseContainer

local suggestPowerTxt_path = "suggestPowerTxt"
local curPowerTxt_path = "curPowerTxt"
local goToBtn_path = "goToBtn"
local suggestImg_path = "suggestImg"
local typeTxt_path = "typeTxt"

function UIUpPowerItem:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
end

function UIUpPowerItem:OnDestroy()
    self:ComponentDestroy()
    base.OnDestroy(self)
end

function UIUpPowerItem:ComponentDefine()
    self.suggestPowerTxt = self:AddComponent(UITextMeshProUGUIEx, suggestPowerTxt_path)
    self.curPowerTxt = self:AddComponent(UITextMeshProUGUIEx, curPowerTxt_path)
    self.goToBtn = self:AddComponent(UIButton, goToBtn_path)
    self.goToBtn:SetOnClick(function()
        self:OnClickGoToBtn()
    end)
    self.suggestImg = self:AddComponent(UIBaseContainer, suggestImg_path)
    self.typeTxt = self:AddComponent(UITextMeshProUGUIEx, typeTxt_path)
end

function UIUpPowerItem:ComponentDestroy()

end

function UIUpPowerItem:OnClickGoToBtn()
    self.view.ctrl:Close()
    if self.type == 1 then
        self:GoToBuilding()
    elseif self.type == 2 then
        self:GoToHero()
    elseif self.type == 3 then
        self:GoToSoldier()
    elseif self.type == 4 then
        self:GoToYunbingche()
    elseif self.type == 5 then
        self:GoToTech()
    end
end

function UIUpPowerItem:GoToBuilding()
    GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_MAIN,WorldTileBtnType.City_Upgrade)
    local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_MAIN)
    --UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, buildList[1].uuid)
end

function UIUpPowerItem:GoToHero()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroList, { anim = false, UIMainAnim = UIMainAnimType.AllHide })
end

function UIUpPowerItem:GoToSoldier()
    local buildList1 = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_CAR_BARRACK)
    local buildList2 = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_INFANTRY_BARRACK)
    local buildList3 = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK)
    local level1 = -1
    local level2 = -1
    local level3 = -1
    if buildList1~=nil and table.count(buildList1)>0 and buildList1[1] ~=nil then
        level1 = buildList1[1].level
    end
    if buildList2~=nil and table.count(buildList2)>0 and buildList2[1] ~=nil then
        level2 = buildList2[1].level
    end
    if buildList3~=nil and table.count(buildList3)>0 and buildList3[1] ~=nil then
        level3 = buildList3[1].level
    end
    local param1 = nil
    local param2 = nil
    if level1 >= level2 and level1 >= level3 then
        param1 = BuildingTypes.FUN_BUILD_INFANTRY_BARRACK
        param2 = WorldTileBtnType.City_TrainingInfantry
    elseif level2 >= level1 and level1 >= level3 then
        param1 = BuildingTypes.FUN_BUILD_CAR_BARRACK
        param2 = WorldTileBtnType.City_TrainingTank
    else
        param1 = BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK
        param2 = WorldTileBtnType.City_TrainingAircraft
    end
    GoToUtil.GotoCityByBuildId(param1,param2)
    --UIManager:GetInstance():OpenWindow(UIWindowNames.UITrain, param)
end

function UIUpPowerItem:GoToYunbingche()
    GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_TRAINFIELD_1,WorldTileBtnType.GarageRefit)
    --UIManager:GetInstance():OpenWindow(UIWindowNames.UIGarageRefit, BuildingTypes.FUN_BUILD_TRAINFIELD_1)
end

function UIUpPowerItem:GoToTech()
    GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_SCIENE, WorldTileBtnType.City_Science)
    local data = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_SCIENE)
    local uuid = data.uuid
    --GoToUtil.GotoScience(nil, nil,uuid, false)
end

function UIUpPowerItem:InitItemType(type)
    self.type = type
    if self.type == 1 then
        self.typeTxt:SetLocalText(310148)
    elseif self.type == 2 then
        self.typeTxt:SetLocalText(100275)
    elseif self.type == 3 then
        self.typeTxt:SetLocalText(150128)
    elseif self.type == 4 then
        self.typeTxt:SetLocalText(140323)
    elseif self.type == 5 then
        self.typeTxt:SetLocalText(100025)
    end
end

function UIUpPowerItem:Refresh(suggestPower, curPower)
    self.suggestImg:SetActive(false)
    self.suggestPowerTxt:SetText(string.GetFormattedSeperatorNum(suggestPower))
    self.curPowerTxt:SetText(string.GetFormattedSeperatorNum(curPower))
    if suggestPower > curPower then
        self.curPowerTxt:SetColorRGBA(0.91, 0.26, 0.26, 1)
    else
        self.curPowerTxt:SetColorRGBA(86/255,60/255,55/255,1)
    end
end

function UIUpPowerItem:ShowSuggest()
    self.suggestImg:SetActive(true)
end

return UIUpPowerItem
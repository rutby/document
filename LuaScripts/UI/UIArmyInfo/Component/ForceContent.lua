--前三个页签不能用循环列表（内部高度可变化，会出现少一个的情况）
local ForceContent = BaseClass("ForceContent", UIBaseContainer)
local base = UIBaseContainer
local UITabButton = require "UI.UIMoreInformation.Component.UITabButton"
local UIHeroTipView = require "UI.UIHero2.UIHeroTip.View.UIHeroTipView"
local TotalDetailItem = require("UI.UIArmyInfo.Component.TotalDetailItem")
local TroopItem = require("UI.UIArmyInfo.Component.TroopItem")
local ReserveItem = require("UI.UIArmyInfo.Component.ReserveItem")

local Localization = CS.GameEntry.Localization

--Total 可用兵力
local total_freeSolider_scrollView_path = "LayerGo/TotalScrollView"
local total_reserve_scrollView_path = "LayerGo/ReserveScrollView"
local total_Troop_scrollView_path = "LayerGo/TroopScrollView"
local total_freeSolider_content_path = "LayerGo/TotalScrollView/Viewport/TotalContent"
local total_Troop_content_path = "LayerGo/TroopScrollView/Viewport/TroopContent"

--local tabUnSelect_shadow= Color.New(255/255,255/255,255/255,0)

-- TotalDes
local totalSolider_path = "LayerGo/TotalScrollView/Slider/TotalNum"
-- local totalSolider_des_path = "LayerGo/TotalScrollView/TotalDes"
local solider_path = "LayerGo/TotalScrollView/Slider"
local solider_progress_path = "LayerGo/TotalScrollView/Slider/Fill Area/Fill"
local solider_full_path = "LayerGo/TotalScrollView/Slider/Full"
local convert_btn_path = "LayerGo/TotalScrollView/Slider/btn_covert"

local empty_txt_path = "EmptyText"

local solider_info_btn_path = "LayerGo/TotalScrollView/Viewport/TotalContent/Rect_Mercenary/Rect_MercenaryTitle/btn_detail"
local solider_des_path =  "LayerGo/TotalScrollView/Viewport/TotalContent/Rect_Mercenary/Rect_MercenaryTitle/armyDes"
local content_normal_path =  "LayerGo/TotalScrollView/Viewport/TotalContent/Rect_Normal"
local content_mercenary_path =  "LayerGo/TotalScrollView/Viewport/TotalContent/Rect_Mercenary/Rect_ContentMercenary"

--reserve
local reserve_num_path = "LayerGo/ReserveScrollView/ReserveDes/ReserveSlider/ReserveNum"
local reserve_des_path = "LayerGo/ReserveScrollView/ReserveDes"
local reserve_slider_path = "LayerGo/ReserveScrollView/ReserveDes/ReserveSlider"
local reserve_slider_progress_path = "LayerGo/ReserveScrollView/ReserveDes/ReserveSlider/Fill Area/ReserveFill"
local reserve_solider_full_path = "LayerGo/ReserveScrollView/ReserveDes/ReserveSlider/ReserveFull"
local reserve_info_btn_path = "LayerGo/ReserveScrollView/ReserveDes/btn_reserve_info"
local goto_btn_path = "LayerGo/ReserveScrollView/Goto_Btn"
local goto_btn_text_path = "LayerGo/ReserveScrollView/Goto_Btn/Goto_Btn_Text"

local table_btn_content_path = "ToggleGroupBg/ToggleGroup/UIMoreInformationTab_"

local TabParamList =
{
    {tabType = TroopType.Total, nameStr = 130068},
    {tabType = TroopType.Inside, nameStr = GameDialogDefine.DEFENCE_FORMATION},
    {tabType = TroopType.Outside, nameStr = 300057},
    --{tabType = TroopType.Turret, nameStr = 111024},
}

--创建
function ForceContent:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
function ForceContent:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function ForceContent:ComponentDefine()
    self.slider = self:AddComponent(UISlider, solider_path)
    self.solider_progress = self:AddComponent(UIImage, solider_progress_path)
    self.solider_full = self:AddComponent(UIImage, solider_full_path)
    self.solider_des = self:AddComponent(UITextMeshProUGUIEx, solider_des_path)
    self.totalSolider =  self:AddComponent(UITextMeshProUGUIEx, totalSolider_path)
    -- self.totalSolider_des =  self:AddComponent(UITextMeshProUGUIEx, totalSolider_des_path)
    self.empty_txt = self:AddComponent(UITextMeshProUGUIEx, empty_txt_path)
   
    
    self.total_scrollView = self:AddComponent(UIBaseContainer,total_freeSolider_scrollView_path)
    self.troop_scrollView = self:AddComponent(UIBaseContainer,total_Troop_scrollView_path)
    self.total_freeSolider_content = self:AddComponent(UIBaseContainer, total_freeSolider_content_path)
    self.total_Troop_content = self:AddComponent(UIBaseContainer, total_Troop_content_path)
    self.reserve_scrollView = self:AddComponent(UIScrollView,total_reserve_scrollView_path)
    self.reserve_scrollView:SetOnItemMoveIn(function(itemObj, index)
        self:OnReserveItemMoveIn(itemObj, index)
    end)
    self.reserve_scrollView:SetOnItemMoveOut(function(itemObj, index)
        self:OnReserveItemMoveIn(itemObj, index)
    end)
    self.content_normal = self:AddComponent(UIBaseContainer,content_normal_path)
    self.content_mercenary = self:AddComponent(UIBaseContainer,content_mercenary_path)
    self.detail_btn = self:AddComponent(UIButton,solider_info_btn_path)
    self.detail_btn:SetOnClick(function()
        self:OnDetailClick()
    end)
    
    self.reserve_num = self:AddComponent(UITextMeshProUGUIEx, reserve_num_path)
    self.reserve_des = self:AddComponent(UITextMeshProUGUIEx, reserve_des_path)
    self.reserve_slider = self:AddComponent(UISlider, reserve_slider_path)
    self.reserve_slider_progress = self:AddComponent(UIImage, reserve_slider_progress_path)
    self.reserve_solider_full = self:AddComponent(UIImage, reserve_solider_full_path)
    self.reserve_info_btn = self:AddComponent(UIButton, reserve_info_btn_path)
    self.reserve_info_btn:SetOnClick(function()
        self:OnReserveInfoClick()
    end)
    self.reserve_goto_btn = self:AddComponent(UIButton, goto_btn_path)
    self.reserve_goto_btn:SetOnClick(function()
        self:OnReserveGotoClick()
    end)
    self.reserve_goto_btn_text = self:AddComponent(UITextMeshProUGUIEx, goto_btn_text_path)
    self.reserve_goto_btn_text:SetLocalText(111040)
    
    self.convert_btn = self:AddComponent(UIButton, convert_btn_path)
    self.convert_btn:SetActive(DataCenter.ArmyManager:IsReserveSystemOpen())
    self.convert_btn:SetOnClick(function()
        self:OnConvertClick()
    end)

    self.tab_btns = {}
    for i = 1, #TabParamList, 1 do
        local tab = self:AddComponent(UITabButton, table_btn_content_path..i)
        table.insert(self.tab_btns, tab)
    end
end

function ForceContent:ComponentDestroy()
end

function ForceContent:DataDefine()
    self.total_n_req = {}
    self.total_m_req = {}
    self.troopType = TroopType.Total
    self.inside_req = {}
    self.tab_callback = function(tabType)
        self:OnTabClick(tabType)
    end
end

function ForceContent:DataDestroy()
    self.total_n_req = {}
    self.total_m_req = {}
    self.troopType = TroopType.Total
    self.inside_req = {}
end

function ForceContent:OnEnable()
    base.OnEnable(self)
end

function ForceContent:OnDisable()
    base.OnDisable(self)
end

function ForceContent:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.TrainArmyData, self.OnArmyChange)
end

function ForceContent:OnRemoveListener()
    self:RemoveUIListener(EventId.TrainArmyData, self.OnArmyChange)
    base.OnRemoveListener(self)
end

function ForceContent:ReInit()
    self.troopType = TroopType.Total
    for k,v in ipairs(self.tab_btns) do
        local data = TabParamList[k]
        if data then
            local param = {}
            param.nameStr = data.nameStr
            param.tabType = data.tabType
            param.callBack = self.tab_callback
            param.isSelect = self.troopType == param.tabType
            v:SetActive(true)
            v:ReInit(param)
        else
            v:SetActive(false)
        end
    end
   
    self:Refresh()
end

function ForceContent:ShowTotalCells(itemList, mercenaryList)
    self:ClearTotalCells()
    local itemCount = itemList ~= nil and #itemList or 0
    local mercenaryCount = mercenaryList ~= nil and #mercenaryList or 0
    if itemCount > 0 or mercenaryCount > 0 then
        self.empty_txt:SetActive(false)
        if itemCount > 0 then
            for k, v in ipairs(itemList) do
                self.total_n_req[k] = self:GameObjectInstantiateAsync(UIAssets.AllianceWarPlayerSoliderItem, function(request)
                    if request.isError then
                        return
                    end
                    local go = request.gameObject
                    go.gameObject:SetActive(true)
                    go.transform:SetParent(self.content_normal.transform)
                    go.transform.localScale = ResetScale
                    local nameStr = tostring(NameCount)
                    go.name = nameStr
                    NameCount = NameCount + 1
                    local cell = self.content_normal:AddComponent(TotalDetailItem, nameStr)
                    local param = {}
                    param.key = v.key
                    param.value = v.value
                    param.index = k
                    param.troopType = self.troopType
                    cell:ReInit(param)
                end)
            end
        end

        if mercenaryCount > 0 then
            for k, v in ipairs(mercenaryList) do
                self.total_m_req[k] = self:GameObjectInstantiateAsync(UIAssets.AllianceWarPlayerSoliderItem, function(request)
                    if request.isError then
                        return
                    end
                    local go = request.gameObject
                    go.gameObject:SetActive(true)
                    go.transform:SetParent(self.content_mercenary.transform)
                    go.transform.localScale = ResetScale
                    local nameStr = tostring(NameCount)
                    go.name = nameStr
                    NameCount = NameCount + 1
                    local cell = self.content_mercenary:AddComponent(TotalDetailItem, nameStr)
                    local param = {}
                    param.key = v.key
                    param.value = v.value
                    param.index = k
                    param.troopType = self.troopType
                    cell:ReInit(param)
                end)
            end
        end
    else
        self.empty_txt:SetActive(true)
        self.empty_txt:SetLocalText(129070)
    end
end

function ForceContent:ClearTotalCells()
    self.content_normal:RemoveComponents(TotalDetailItem)
    self.content_mercenary:RemoveComponents(TotalDetailItem)
    for k, v in pairs(self.total_n_req) do
        v:Destroy()
    end
    for k, v in pairs(self.total_m_req) do
        v:Destroy()
    end
    self.total_n_req = {}
    self.total_m_req = {}
end

function ForceContent:Refresh()
    if self.troopType == TroopType.Total then
        self.total_scrollView :SetActive(true)
        self.reserve_scrollView :SetActive(false)
        self.troop_scrollView :SetActive(false)
        local itemList,mercenaryNum,mercenary = self:GetTotalSolider()
        if mercenaryNum>0 then
            local str = Localization:GetString("163385").." ( "..string.GetFormattedSeperatorNum(math.floor(mercenaryNum)).." ) "
            self.solider_des:SetText(str)
            self.detail_btn:SetActive(true)
        else
            self.detail_btn:SetActive(false)
        end
        self:ShowTotalCells(itemList, mercenary)
    elseif self.troopType == TroopType.Inside then
        self.total_scrollView :SetActive(false)
        self.reserve_scrollView :SetActive(false)
        self.troop_scrollView :SetActive(true)
        self:ShowInsideCells(self:GetFormationList())
    elseif self.troopType == TroopType.Outside then
        self.total_scrollView :SetActive(false)
        self.reserve_scrollView :SetActive(false)
        self.troop_scrollView :SetActive(true)
        self:ShowInsideCells(self:GetOutsideFormation())
    elseif self.troopType == TroopType.Reserve then
        self.total_scrollView :SetActive(false)
        self.reserve_scrollView :SetActive(true)
        self.troop_scrollView :SetActive(false)
        self:ShowReserveCells()
    end
end

function ForceContent:ShowInsideCells(itemList)
    self:ClearInsideCells()
    local count = itemList ~= nil and #itemList or 0
    if count > 0 then
        self.empty_txt:SetActive(false)
        for k, v in ipairs(itemList) do
            self.inside_req[k] = self:GameObjectInstantiateAsync(UIAssets.UIArmyInfoTroopItem, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject
                go.gameObject:SetActive(true)
                go.transform:SetParent(self.total_Troop_content.transform)
                go.transform.localScale = ResetScale
                local nameStr = tostring(NameCount)
                go.name = nameStr
                NameCount = NameCount + 1
                local cell = self.total_Troop_content:AddComponent(TroopItem, nameStr)
                local param = {}
                param.key = v.key
                param.value = v.value
                param.titleText = v.titleText
                param.descText = v.descText
                param.index = k
                param.troopType = self.troopType
                cell:ReInit(param)
            end)
        end
    else
        self.empty_txt:SetActive(true)
        self.empty_txt:SetLocalText(129068)
    end
end

function ForceContent:ClearInsideCells()
    self.total_Troop_content:RemoveComponents(TroopItem)
    for k, v in pairs(self.inside_req) do
        v:Destroy()
    end
    self.inside_req = {}
end

function ForceContent:ShowReserveCells()
    self:ClearReserveScroll()
    self.reserveList = self:GetReserveData()
    local count = self.reserveList ~= nil and #self.reserveList or 0
    if count > 0 then
        self.reserve_scrollView:SetTotalCount(count)
        self.reserve_scrollView:RefillCells()
        self.empty_txt:SetActive(false)
    else
        self.empty_txt:SetActive(true)
        self.empty_txt:SetLocalText(111032)
    end
  
    local hasBuilding = DataCenter.BuildManager:HasBuilding(BuildingTypes.FUN_BUILD_Reserve)
    self.reserve_goto_btn:SetActive(not hasBuilding)
end

function ForceContent:ClearReserveScroll()
    self.reserve_cells = {}
    self.reserve_scrollView:ClearCells()
    self.reserve_scrollView:RemoveComponents(ReserveItem)
end

function ForceContent:OnReserveItemMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local cell = self.reserve_scrollView:AddComponent(ReserveItem, itemObj)
    local param = self.reserveList[index]
    param.index = index
    param.troopType = self.troopType
    cell:ReInit(param)
end

function ForceContent:OnReserveItemMoveOut(itemObj, index)
    self.scrollView:RemoveComponent(itemObj.name, ReserveItem)
end

--出征+空闲
function ForceContent:GetTotalSolider()
    local mercenaryNum = 0
    local totalSoldiers =  DataCenter.ArmyManager:GetTotalMarchAndFreeArmyNum()
    local maxSoldiers ={}
    local mercenary = {}
    local soliderNum = self.view.ctrl:GetTotalArmyNum()
    table.walk(totalSoldiers,function (k,v)
        if v>0 then
            local param = {}
            param.key = k
            param.value = v
            local isMercenary = false
            local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(k)
            if template ~= nil then
                if template.mercenary ~=nil and template.mercenary>0 and template.arm ~= ArmType.Trap then
                    isMercenary = true
                    mercenaryNum = mercenaryNum+v
                end
            end
            if isMercenary then
                table.insert(mercenary, param)
            else
                table.insert(maxSoldiers, param)
            end
        end
    end)
    table.sort(mercenary, function(a,b)
        local aData = DataCenter.ArmyTemplateManager:GetArmyTemplate(a.key)
        local bData = DataCenter.ArmyTemplateManager:GetArmyTemplate(b.key)
        if aData.level > bData.level then
            return true
        elseif aData.level == bData.level then
            if aData.arm > bData.arm then
                return true
            end
            return false
        end
    end)
    table.sort(maxSoldiers, function(a,b)
        local aData = DataCenter.ArmyTemplateManager:GetArmyTemplate(a.key)
        local bData = DataCenter.ArmyTemplateManager:GetArmyTemplate(b.key)
        if aData.level > bData.level then
            return true
        elseif aData.level == bData.level then
            if aData.arm > bData.arm then
                return true
            end
            return false
        end
    end)
    
    --训练+晋级
    local trainNum = 0
    local armyBuilds = BarracksBuild
    for k, v in pairs(armyBuilds) do
        local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(k)
        if template and template.arm ~= ArmType.Trap then
            trainNum = trainNum + DataCenter.ArmyManager:GetQueueArmyNum(v)
        end
    end
    if trainNum > 0 then
        local param = {}
        param.key = ForceTypeTrainAndUpgrade
        param.value = trainNum
        table.insert(maxSoldiers, param)
    end
    --重伤+治疗
    local injured = DataCenter.HospitalManager:GetHospitalCount()
    if injured > 0 then
        local param = {}
        param.key = ForceTypeInjured
        param.value = injured
        table.insert(maxSoldiers, param)
    end

    self.slider.gameObject:SetActive(true)
    local max = DataCenter.ArmyManager:GetArmyNumMax()

    
    self.totalSolider:SetText(string.GetFormattedSeperatorNum(soliderNum).."/"..string.GetFormattedSeperatorNum(max))
    -- self.totalSolider_des:SetLocalText(130068)

    local percent = 1.0 * soliderNum / max
    percent = math.min(1.0, math.max(0, percent))
    self.slider:SetValue(percent)
    self.solider_full:SetActive(soliderNum >= max)
    self.solider_progress:SetActive(soliderNum < max)
    --end
    return maxSoldiers,mercenaryNum,mercenary
end

--得到可用兵力
function ForceContent:GetfreeSolider()
    --空闲
    local freeSoldiers =  DataCenter.ArmyFormationDataManager:GetArmyUnFormationList(true)
    local maxSoldiers ={}
    local soliderNum = self.view.ctrl:GetTotalArmyNum()
    table.walk(freeSoldiers,function (k,v)
        if v>0 then
            local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(k)
            if template then
                local param = {}
                param.key = k
                param.value = v
                table.insert(maxSoldiers,param)
            end
        end
    end)

    table.sort(maxSoldiers, function(a,b) 
        local aData = DataCenter.ArmyTemplateManager:GetArmyTemplate(a.key)
        local bData = DataCenter.ArmyTemplateManager:GetArmyTemplate(b.key)
        if aData.level > bData.level then
            return true
        elseif aData.level == bData.level then
            if aData.arm > bData.arm then
                return true
            end
            return false
        end
    end)
    self.slider.gameObject:SetActive(true)
    local max = DataCenter.ArmyManager:GetArmyNumMax()

    self.totalSolider:SetText(string.GetFormattedSeperatorNum(soliderNum).."/"..string.GetFormattedSeperatorNum(max))
    -- self.totalSolider_des:SetLocalText(130068)

    local percent = 1.0 * soliderNum / max
    percent = math.min(1.0, math.max(0, percent))
    self.slider:SetValue(percent)
    self.solider_full:SetActive(soliderNum >= max)
    self.solider_progress:SetActive(soliderNum < max)
    --end
    return maxSoldiers
end


-- 城内编队
function ForceContent:GetFormationList()
    local allMarch ={}
    --得到所有空闲的英雄
    local freeHeroList = self:GetFreeHeroListExceptFormation()
    --遍历编队将出征英雄移除，并补位空闲英雄
    local formation =  DataCenter.ArmyFormationDataManager:GetAllDefenceArmyFormationData()

    local usedHeroes = {}
    local freeSoldiers = self:GetfreeSolider()
    local maxDefenceFormationNum = DataCenter.DefenceWallDataManager:GetMaxDefenceNum()

    table.walksort(formation,function (leftKey,rightKey)
        return formation[leftKey].index < formation[rightKey].index
    end, function (k,v)
        -- 得到编队的最大值
        if v.index > maxDefenceFormationNum then
            return
        end
        local maxHeroNum = MarchUtil.GetMaxHeroValueByDefendFormationIndex(v.index)
        local formationHeroes = {}
        local formationSoliders = {}
        --得到编队空闲英雄并添加
        table.walk(v.heroes,function(a,b)
            local heroData = DataCenter.HeroDataManager:GetHeroByUuid(a)
            if heroData ~= nil and  heroData.state == ArmyFormationState.Free then
                --有出征英雄时，heroID相同时不可参加防御编队
                formationHeroes[heroData.heroId] = heroData
            end
        end)
    
        -- 将编队英雄补齐
       local curHeroNum = table.count(formationHeroes)
        for i = curHeroNum, maxHeroNum-1 do
            for k1, v1 in pairs(freeHeroList) do
                local heroData = v1
                if heroData ~= nil and  formationHeroes[heroData.heroId] == nil and usedHeroes[heroData.heroId]== nil then
                    formationHeroes[heroData.heroId]= heroData
                    usedHeroes[heroData.heroId]= heroData
                    break
                end
            end
        end
        
        local temp = {}
        if next(formationHeroes) then
            for p,q in pairs(formationHeroes) do
                temp[q.uuid] = p
            end
        end
        --兵力分配
        --local maxSoliderNum = MarchUtil.GetDefenceFormationMaxCanAddSoldierNum(temp)
        local totalNum = 0
        local soldiers = {}
        for a,b in pairs(freeSoldiers) do
            if b.value ~= 0 then
                local army = DataCenter.ArmyTemplateManager:GetArmyTemplate(b.key)
                if army and army.arm ~= ArmType.Trap then
                    soldiers[b.key] = math.floor(b.value)
                    totalNum = totalNum + math.floor(b.value)
                    b.value = 0
                end
            end
        end
        local tempFormation = {}
        tempFormation.heroes = formationHeroes
        tempFormation.maxSoliderNum = math.floor(totalNum)
        tempFormation.soldiers = soldiers
       
        local param = {}
        param.key = k
        param.value = tempFormation
        param.titleText = Localization:GetString("300059")
        param.descText = Localization:GetString("130068")
        table.insert(allMarch,param)
        
        -- 陷阱
        totalNum = 0
        soldiers = {}
        for a,b in pairs(freeSoldiers) do
            if b.value ~= 0 then
                local army = DataCenter.ArmyTemplateManager:GetArmyTemplate(b.key)
                if army and army.arm == ArmType.Trap then
                    soldiers[b.key] = math.floor(b.value)
                    totalNum = totalNum + math.floor(b.value)
                    b.value = 0
                end
            end
        end
        if totalNum > 0 then
            tempFormation = {}
            tempFormation.heroes = {}
            tempFormation.maxSoliderNum = math.floor(totalNum)
            tempFormation.soldiers = soldiers

            param = {}
            param.key = k
            param.value = tempFormation
            param.titleText = Localization:GetString("104337")
            param.descText = Localization:GetString("104337")
            table.insert(allMarch,param)
        end
    end)
    return  allMarch
end

--得到城外兵
function ForceContent:GetOutsideFormation()
    local allMarch = {}
    local allianceId = LuaEntry.Player.allianceId
    local selfMarch = DataCenter.WorldMarchDataManager:GetOwnerMarches(LuaEntry.Player.uid, allianceId)
    if selfMarch~=nil then
        table.walk(selfMarch,function (k,v)
            local param = {}
            param.key = k
            param.value = v:GetFirstArmyInfo()
            table.insert(allMarch,param)
        end)
    end
    return allMarch
end


-- 得到炮台信息
function ForceContent:GetArrowTowerData()
    local allTowerData = {}
    local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_ARROW_TOWER)
    for k,v in pairs(list) do
        local param = {}
        param.key = v.uuid
        param.value = v
        table.insert(allTowerData,param)
    end
    return allTowerData
end


-- 得到除去编队里的英雄(不包含在编队中的)
function ForceContent:GetFreeHeroListExceptFormation()
    local allFreeHeroes = DataCenter.HeroDataManager:GetHeroSortList()
    local formation = DataCenter.ArmyFormationDataManager:GetAllDefenceArmyFormationData()
    local heroesInFormation = {}
    local freeHeroes = {}
    for k,v in pairs(formation) do
        for a,b in pairs(v.heroes) do
            local heroData = DataCenter.HeroDataManager:GetHeroByUuid(a)
            if   heroData ~= nil and heroesInFormation [heroData.heroId] == nil  and  heroData.state == ArmyFormationState.Free   then
                heroesInFormation[heroData.heroId] = a
            end
        end
    end
    for k,v in ipairs(allFreeHeroes) do
        if v.state == ArmyFormationState.Free then
            if heroesInFormation[v.uuid] == nil then
                table.insert(freeHeroes, v)
            end
        end
    end
    return freeHeroes
end

function ForceContent:OnDetailClick()
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local position = self.detail_btn.gameObject.transform.position + Vector3.New(0, -20, 0) * scaleFactor

    local param = UIHeroTipView.Param.New()
    param.content = Localization:GetString("163383")
    param.dir = UIHeroTipView.Direction.BELOW
    param.defWidth = 340
    param.pivot = 0.5
    param.position = position
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, { anim = false }, param)
end

function ForceContent:GetReserveData()
    local maxSoldiers ={}
    local totalSoldiers = DataCenter.ArmyManager:GetAllReserveArmy()
    if totalSoldiers ~= nil then
        for k, v in pairs(totalSoldiers) do
            if v > 0 then
                local param = {}
                param.key = k
                param.value = v
                local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(k)
                if template ~= nil then
                    param.level = template.level
                    param.arm = template.arm
                end
                table.insert(maxSoldiers, param)
            end
        end
    end
    if maxSoldiers[2] ~= nil then
        table.sort(maxSoldiers, function(a, b)
            if a.level ~= b.level then
                return b.level < a.level
            end
            return b.arm < a.arm
        end)
    end

    --训练
    local trainNum = 0
    for _, v in ipairs(BarracksBuild) do
        trainNum = trainNum + DataCenter.ArmyManager:GetReserveQueueArmyNum(v)
    end
    if trainNum > 0 then
        local param = {}
        param.key = ForceTypeTrainAndUpgrade
        param.value = trainNum
        table.insert(maxSoldiers, param)
    end

    local soliderNum = self.view.ctrl:GetTotalReserveArmyNum()
    local showMax = DataCenter.ArmyManager:GetReserveArmyMax()
    local max = math.max(showMax, 1)
    self.reserve_num:SetText(string.GetFormattedSeperatorNum(soliderNum).."/"..string.GetFormattedSeperatorNum(showMax))
    self.reserve_des:SetLocalText(111025)
   
    local percent = soliderNum / max
    self.reserve_slider:SetValue(percent)
    self.reserve_solider_full:SetActive(soliderNum >= max)
    self.reserve_slider_progress:SetActive(soliderNum < max)
    --end
    return maxSoldiers
end

function ForceContent:OnReserveInfoClick()
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local position = self.reserve_info_btn.gameObject.transform.position + Vector3.New(0, -20, 0) * scaleFactor

    local param = UIHeroTipView.Param.New()
    param.content = Localization:GetString("111026")
    param.dir = UIHeroTipView.Direction.BELOW
    param.defWidth = 340
    param.pivot = 0.5
    param.position = position
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, { anim = false }, param)
end

function ForceContent:OnConvertClick()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIReServeToSoldier, {anim = true})
end

function ForceContent:OnArmyChange()
    self:Refresh()
end

function ForceContent:OnReserveGotoClick()
    self.view.ctrl:CloseSelf()
end

function ForceContent:OnTabClick(tabIndex)
    if self.troopType ~= tabIndex then
        self:RefreshTabSelect(self.troopType, false)
        self.troopType = tabIndex
        self:RefreshTabSelect(self.troopType, true)
        self:Refresh()
    end
end

function ForceContent:RefreshTabSelect(tabType, select)
    for k,v in ipairs(self.tab_btns) do
        if v.param.tabType == tabType then
            v:SetSelect(select)
            break
        end
    end
end

return ForceContent

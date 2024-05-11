local ForceContent = BaseClass("ForceContent", UIBaseContainer)
local base = UIBaseContainer

local TotalDetailItem = require("UI.UIForcesDetail.Component.TotalDetailItem")
local TroopItem = require("UI.UIForcesDetail.Component.TroopItem")
local TurrentItem = require("UI.UIForcesDetail.Component.TurrentItem")


local cell = ""
local title_txt_path = "title_txt"
local content_path = "Content"

--Total 可用兵力
local total_freeSolider_title_path = "LayerGo/TotalContent/Viewport/Content/Total/AvailableTroops/Maintitlebg/Text_Available"
local total_freeSolider_scrollView_path = "LayerGo/TotalContent"
local total_turrent_scrollView_path = "LayerGo/TurretContent"
local total_Troop_scrollView_path = "LayerGo/TroopContent"

--tab 
local tabTotal_path = "Tab/TabTotal"
local tabInside_path = "Tab/TabInside"
local tabOutside_path = "Tab/TabOutside"
local tabTurret_path = "Tab/TabTurret"

local tabTotal_txt_path = "Tab/TabTotal/Text_Total"
local tabInside_txt_path = "Tab/TabInside/Text_Inside"
local tabOutside_txt_path = "Tab/TabOutside/Text_Outside"
local tabTurret_txt_path = "Tab/TabTurret/Text_Turret"


local tabSelect_img = "Assets/Main/Sprites/UI/Common/New/Common_btn_tab_open.png"
local tabUnSelect_img = "Assets/Main/Sprites/UI/Common/New/Common_btn_tab_close.png"


-- TotalDes
local totalSolider_path = "LayerGo/TotalContent/TotalDes/TotalNum"
local totalSolider_des_path = "LayerGo/TotalContent/TotalDes/"

local empty_txt_path = "EmptyText"

--创建
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

local function ComponentDefine(self)

   -- self.total_freeSolider_title = self:AddComponent(UIText, total_freeSolider_title_path)
   -- self.title_txt = self:AddComponent(UIText,title_txt_path)
    self.tabTotal_btn = self:AddComponent(UIButton, tabTotal_path)
    self.tabInside_btn =  self:AddComponent(UIButton, tabInside_path)
    self.tabOutside_btn =  self:AddComponent(UIButton, tabOutside_path)
    self.tabTurret_btn =  self:AddComponent(UIButton, tabTurret_path)
    self.tabTotal_img = self:AddComponent(UIImage, tabTotal_path)
    self.tabInside_img =  self:AddComponent(UIImage, tabInside_path)
    self.tabOutside_img =  self:AddComponent(UIImage, tabOutside_path)
    self.tabTurret_img =  self:AddComponent(UIImage, tabTurret_path)
    self.tabTotal_txt = self:AddComponent(UITextMeshProUGUIEx, tabTotal_txt_path)
    self.tabInside_txt =  self:AddComponent(UITextMeshProUGUIEx, tabInside_txt_path)
    self.tabOutside_txt =  self:AddComponent(UITextMeshProUGUIEx, tabOutside_txt_path)
    self.tabTurret_txt =  self:AddComponent(UITextMeshProUGUIEx, tabTurret_txt_path)

    self.totalSolider =  self:AddComponent(UITextMeshProUGUIEx, totalSolider_path)
    self.totalSolider_des =  self:AddComponent(UITextMeshProUGUIEx, totalSolider_des_path)
    self.empty_txt = self:AddComponent(UITextMeshProUGUIEx, empty_txt_path)
    
    
    self.total_scrollView = self:AddComponent(UIScrollView,total_freeSolider_scrollView_path)
    self.turrent_scrollView = self:AddComponent(UIScrollView,total_turrent_scrollView_path)
    self.troop_scrollView = self:AddComponent(UIScrollView,total_Troop_scrollView_path)

    self.total_scrollView:SetOnItemMoveIn(function(itemObj, index)
        self:OnItemMoveIn(itemObj, index)
    end)
    self.total_scrollView:SetOnItemMoveOut(function(itemObj, index)
        self:OnItemMoveOut(itemObj, index)
    end)
    self.turrent_scrollView:SetOnItemMoveIn(function(itemObj, index)
        self:OnItemMoveIn(itemObj, index)
    end)
    self.turrent_scrollView:SetOnItemMoveOut(function(itemObj, index)
        self:OnItemMoveOut(itemObj, index)
    end)
    self.troop_scrollView:SetOnItemMoveIn(function(itemObj, index)
        self:OnItemMoveIn(itemObj, index)
    end)
    self.troop_scrollView:SetOnItemMoveOut(function(itemObj, index)
        self:OnItemMoveOut(itemObj, index)
    end)
    
    self.tabTotal_btn :SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:TabClick(TroopType.Total)
    end)
    self.tabInside_btn :SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:TabClick(TroopType.Inside)
    end)
    self.tabOutside_btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:TabClick(TroopType.Outside)
    end)
    self.tabTurret_btn :SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:TabClick(TroopType.Turret)
    end)

end



local function ComponentDestroy(self)
    self.total_freeSolider_title = nil
    self.itemList =nil
    self.cells = nil
    self.scrollView = nil
    self.total_content = nil
    self.turrent_content = nil
    self.troop_content = nil
end


local function DataDefine(self)
    self.cellList = {}
    self.item = nil
    self.troopType = TroopType.Total
end

local function DataDestroy(self)
    self.cellList = nil
    self.item = nil
    self.troopType = nil
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)

end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)

end

local function ReInit(self,param)
    self:TabClick(TroopType.Total)
    self.tabTotal_txt:SetLocalText(130068) 
    self.tabInside_txt:SetLocalText(100643) 
    self.tabOutside_txt:SetLocalText(100642) 
    self.tabTurret_txt:SetLocalText(300626) 
  --  self.title_txt:SetLocalText(310141) 
    
end


local function InitFreeSolider(self ,itemList)
   -- self.itemList = itemList -- DataCenter.ArmyFormationDataManager:GetfreeSolider()
    self:ClearScroll()
  --  Logger.Table(#self.itemList,"itemlist Count")
    if #self.itemList>0 then
        self.scrollView:SetTotalCount(#itemList)
        self.scrollView:RefillCells()
        self.empty_txt:SetText("")
    else
        if self.troopType == TroopType.Turret then
            self.empty_txt:SetLocalText(129069) 
        elseif self.troopType == TroopType.Total then
            self.empty_txt:SetLocalText(129070) 
        else
            self.empty_txt:SetLocalText(129068) 
        end
    end
end

local function ClearScroll(self)
    self.cells = {}
    self.scrollView:ClearCells()
    self.scrollView:RemoveComponents(self.item)
end

local function OnItemMoveIn(self,itemObj, index)
    itemObj.name = tostring(index)
    self.cells[index] = self.scrollView:AddComponent(self.item, itemObj)
    local param = {}
    param.key = self.itemList[index].key
    param.value = self.itemList[index].value
    param.index = index
    param.troopType = self.troopType
    self.cells[index]:ReInit(param)
end

local function OnItemMoveOut(self, itemObj, index)
    self.cells[index] = nil
    self.scrollView:RemoveComponent(itemObj.name, self.item)
end

local function TabClick(self,troopType)

    if troopType == TroopType.Total then
        self.troopType = TroopType.Total
        self.tabTotal_img:LoadSprite(tabSelect_img)
        self.tabInside_img:LoadSprite(tabUnSelect_img)
        self.tabOutside_img:LoadSprite(tabUnSelect_img)
        self.tabTurret_img:LoadSprite(tabUnSelect_img)
        self.total_scrollView :SetActive(true)
        self.turrent_scrollView :SetActive(false)
        self.troop_scrollView :SetActive(false)
        
        self.scrollView = self.total_scrollView
        self.item = TotalDetailItem
        self.cells = nil
        self.cellList = {}
      --  self:ResetScrollView(self.total_scrollView)

        self.itemList = self:GetfreeSolider()
        self:InitFreeSolider(self.itemList)


        
        
    elseif troopType == TroopType.Inside then
        self.troopType = TroopType.Inside
        self.tabTotal_img:LoadSprite(tabUnSelect_img)
        self.tabInside_img:LoadSprite(tabSelect_img)
        self.tabOutside_img:LoadSprite(tabUnSelect_img)
        self.tabTurret_img:LoadSprite(tabUnSelect_img)
        self.total_scrollView :SetActive(false)
        self.turrent_scrollView :SetActive(false)
        self.troop_scrollView :SetActive(true)

        self.scrollView = self.troop_scrollView
        self.item = TroopItem
        self.cells = nil
        self.cellList = {}


        self.itemList = self:GetFormationList()
        self:InitFreeSolider(self.itemList)
        
        
    elseif troopType == TroopType.Outside then
        self.troopType = TroopType.Outside
        self.tabTotal_img:LoadSprite(tabUnSelect_img)
        self.tabInside_img:LoadSprite(tabUnSelect_img)
        self.tabOutside_img:LoadSprite(tabSelect_img)
        self.tabTurret_img:LoadSprite(tabUnSelect_img)
        self.total_scrollView :SetActive(false)
        self.turrent_scrollView :SetActive(false)
        self.troop_scrollView :SetActive(true)
        
        self.scrollView =  self.troop_scrollView
        self.item = TroopItem
        self.cells = nil
        self.cellList = {}
       -- self:ResetScrollView(self.troop_scrollView)

        self.itemList = self:GetOutsideFormation()
        self:InitFreeSolider(self.itemList)
        
    elseif troopType == TroopType.Turret then
        self.troopType = TroopType.Turret
        self.tabTotal_img:LoadSprite(tabUnSelect_img)
        self.tabInside_img:LoadSprite(tabUnSelect_img)
        self.tabOutside_img:LoadSprite(tabUnSelect_img)
        self.tabTurret_img:LoadSprite(tabSelect_img)
        self.total_scrollView :SetActive(false)
        self.turrent_scrollView :SetActive(true)
        self.troop_scrollView :SetActive(false)

        self.scrollView = self.turrent_scrollView
        self.item = TurrentItem
        self.cells = nil
        self.cellList = {}
      --  self:ResetScrollView(self.turrent_scrollView)
      --
        self.itemList = self:GetArrowTowerData()
        self:InitFreeSolider(self.itemList)
    end
    
end




--得到可用兵力
local function GetfreeSolider(self)
    local freeSoldiers =  DataCenter.ArmyFormationDataManager:GetArmyUnFormationList()
    local maxSoldiers ={}
    local soliderNum = 0
    table.walk(freeSoldiers,function (k,v)
        if v>0 then
            local param = {}
            param.key = k
            param.value = v
            soliderNum = soliderNum + v
            table.insert(maxSoldiers,param)
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
    if soliderNum <=0 then
        self.totalSolider_des.gameObject:SetActive(false)
    else
        self.totalSolider_des.gameObject:SetActive(true)
        self.totalSolider :SetText(soliderNum)
        self.totalSolider_des:SetLocalText(130068)   
    end
    return maxSoldiers
end


-- 城内编队
local function GetFormationList(self)
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
        local maxSoliderNum = MarchUtil.GetDefenceFormationMaxCanAddSoldierNum(temp)
        local totalNum = 0
        local soldiers = {}
        for a,b in pairs(freeSoldiers) do
            if b.value ~= 0 then
                if b.value >= maxSoliderNum then
                    soldiers[b.key] = math.floor(maxSoliderNum)
                    b.value = b.value - maxSoliderNum
                    totalNum = totalNum + math.floor(maxSoliderNum)
                    maxSoliderNum = 0
                    break
                else
                    soldiers[b.key] = math.floor(b.value)
                    totalNum = totalNum + math.floor(b.value)
                    maxSoliderNum = maxSoliderNum - b.value
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
        table.insert(allMarch,param)
    end)
    return  allMarch
end

--得到城外兵
local function GetOutsideFormation(self)
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
local function GetArrowTowerData(self)
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
local function GetFreeHeroListExceptFormation(self)
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
    local allFreeHeroes = DataCenter.HeroDataManager:GetAllHeroBySort()
    table.walk(allFreeHeroes,function(k,v)
        if v.state == ArmyFormationState.Free then
            if heroesInFormation[k] == nil then
                table.insert(freeHeroes,v)
            end
        end
    end)
    local campA = nil
    local campB = nil
    table.sort(freeHeroes,function(heroA,heroB)
        if heroA.level ~= heroB.level then
            return heroA.level > heroB.level
        end

        if heroA.quality ~= heroB.quality then
            return heroA.quality > heroB.quality
        end
        campA = heroA:GetCamp()
        campB = heroB:GetCamp()
        if campA ~= campB then
            return campA < campB
        end
        return heroA.heroId < heroB.heroId
    end)
    --[[    Logger.Table(table.count(allFreeHeroes) ,"所有空闲的英雄")
        Logger.Table(table.count(heroesInFormation),"在编队里的英雄")
        Logger.Table(table.count(freeHeroes),"不在编队里的空闲英雄")]]
    return freeHeroes
end


ForceContent.OnCreate = OnCreate
ForceContent.OnDestroy = OnDestroy
ForceContent.OnDisable = OnDisable
ForceContent.ComponentDefine = ComponentDefine
ForceContent.ComponentDestroy = ComponentDestroy
ForceContent.DataDefine = DataDefine
ForceContent.DataDestroy = DataDestroy
ForceContent.OnAddListener = OnAddListener
ForceContent.OnRemoveListener = OnRemoveListener
ForceContent.ReInit = ReInit
ForceContent.ShowTotalContent = ShowTotalContent
ForceContent.ClearScroll = ClearScroll
ForceContent.OnItemMoveIn = OnItemMoveIn
ForceContent.OnItemMoveOut = OnItemMoveOut
ForceContent.InitFreeSolider = InitFreeSolider
ForceContent.TabClick = TabClick
ForceContent.GetFormationList = GetFormationList
ForceContent.GetOutsideFormation = GetOutsideFormation
ForceContent.GetfreeSolider = GetfreeSolider
ForceContent.GetArrowTowerData = GetArrowTowerData
ForceContent.GetFreeHeroListExceptFormation = GetFreeHeroListExceptFormation


return ForceContent

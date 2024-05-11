local TroopItem = BaseClass("TroopItem", UIBaseContainer)
local base = UIBaseContainer

local UIHeroCell  = require "UI.UIHero2.Common.UIHeroCellSmall"
local TotalDetailItem = require("UI.UIForcesDetail.Component.TotalDetailItem")


local title_txt_path = "Top/Text_title"
local solider_path = "Top/Text_forces"
local solider_des_path = "Top/Text_des"
local hero_content_path = "Top/HeroContent"
local cell_btn_path = "Top/bg"
local solider_content_path="Soliders"
local normal_path = "Top/ListcloseBtn/Img_Normal"
local select_path = "Top/ListcloseBtn/Img_Select"

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

    self.title_txt = self:AddComponent(UITextMeshProUGUIEx, title_txt_path)
    self.solider_txt = self:AddComponent(UITextMeshProUGUIEx, solider_path)
    self.solider_des = self:AddComponent(UITextMeshProUGUIEx, solider_des_path)
    self.hero_content = self:AddComponent(UIBaseContainer,hero_content_path)
    self.cell_btn = self:AddComponent(UIButton,cell_btn_path)
    
    self.cell_btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnItemClick()
    end)

    self._normal_img = self:AddComponent(UIImage,normal_path)
    self._select_img = self:AddComponent(UIImage,select_path)
    
    self.solider_content =  self:AddComponent(UIBaseContainer,solider_content_path)
    
end

local function ComponentDestroy(self)
  --  self.title_txt = nil
end


local function DataDefine(self)
  --  self.cellList = {}
    self.siliderTotal = 0
end

local function DataDestroy(self)
  --  self.cellList = nil
    self.siliderTotal = nil 
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
    self.param = param
    if self.param ~= nil then
      --  Logger.Table(self.param," param ")
        self.title_txt:SetLocalText(GameDialogDefine.DEFENCE_FORMATION) 
        self.solider_des:SetLocalText(130068) 
        self.solider_content:SetActive(false)
        self.solider_txt:SetText(0)
        self._normal_img:SetActive(true)
        self._select_img:SetActive(false)
        if self.param.value ~= nil then
            local heroes = {}
            local soliders = {}
            -- 城内
            if self.param.troopType == TroopType.Inside then
                self.solider_txt:SetText(self.param.value.maxSoliderNum)
                heroes = self.param.value.heroes
                soliders = self.param.value.soldiers
                local sort = {}
                if soliders ~= nil then
                    for k,v in pairs(soliders) do
                        local parm = {}
                        parm.key = tonumber(k)
                        parm.value = v
                        table.insert(sort,parm)
                    end
                    table.sort(sort, function(a,b)
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
                end
                if heroes ~= nil then
                    table.walk(heroes,function(a,b)
                        -- local heroData = b -- DataCenter.HeroDataManager:GetHeroByUuid(a)
                        if b~=nil then
                            local heroData = {}
                            heroData.heroId = b.heroId
                            heroData.heroQuality = b.quality
                            heroData.heroLevel = b.level
                            self:InstanteHeroCell(heroData)
                        end
                    end)
                end
                if sort ~= nil then
                    table.walk(sort,function(a,b)
                        local solider = {}
                        solider.key = b.key
                        solider.value = b.value
                        self:InstanteSoliderCell(solider)
                    end)
                end
            elseif self.param.troopType == TroopType.Outside then
                heroes = self.param.value.HeroInfos
                for i = 0, heroes.Count - 1 do
                    if heroes[i] ~= nil then
                        local heroData = {}
                        heroData.heroId = heroes[i].heroId
                        heroData.heroQuality = heroes[i].heroQuality
                        heroData.heroLevel = heroes[i].heroLevel
                        self:InstanteHeroCell(heroData)
                    end
                end
                local soliderNum = 0
                soliders = self.param.value.Soldiers
                local sort = {}
                if soliders ~= nil then
                    for i = 0, soliders.Count - 1 do
                        if soliders[i] ~= nil then
                            local parm = {}
                            parm.key = tonumber(soliders[i].armsId)
                            parm.value = soliders[i].total
                            table.insert(sort,parm)
                        end
                    end
                    table.sort(sort, function(a,b)
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
                end
                if next(sort) then
                    table.walk(sort,function(a,b)
                        local solider = {}
                        solider.key = b.key
                        solider.value = b.value
                        self:InstanteSoliderCell(solider)
                        soliderNum = b.value + soliderNum
                        self.solider_txt:SetText(soliderNum)
                    end)
                end
            end
        end
  
    end
end

local function InstanteHeroCell(self,heroData)
    self:GameObjectInstantiateAsync(UIAssets.UIHeroCellSmall, function(request)
        if request.isError then
            return
        end
        local go = request.gameObject;
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.hero_content.transform)
        go.transform:Set_localScale(0.6, 0.6, 0.6)
        go.name = "item" .. heroData.heroId
        local cell = self.hero_content:AddComponent(UIHeroCell, go.name)
        cell:InitWithConfigId(heroData.heroId, heroData.heroQuality, heroData.heroLevel, nil, nil, nil, nil, nil, HeroUtils.GetCamp(heroData))
    end)
end 

local function InstanteSoliderCell(self,solider)
    self:GameObjectInstantiateAsync(UIAssets.TurretDetailItem, function(request)
        if request.isError then
            return
        end
        local go = request.gameObject;
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.solider_content.transform)
        go.transform:Set_localScale(1 ,1, 1)
        go.name = "item" .. solider.key
        local cell = self.solider_content:AddComponent(TotalDetailItem, go.name)
        cell:ReInit(solider)
    end)
end

local isSpead = false
local function OnItemClick(self)

    if isSpead == false then
        self.solider_content:SetActive(true)
        self._normal_img:SetActive(false)
        self._select_img:SetActive(true)
        isSpead = true
    else
        self.solider_content:SetActive(false)
        self._normal_img:SetActive(true)
        self._select_img:SetActive(false)
        isSpead = false
    end
  
end

TroopItem.OnCreate = OnCreate
TroopItem.OnDestroy = OnDestroy
TroopItem.OnEnable = OnEnable
TroopItem.OnDisable = OnDisable
TroopItem.ComponentDefine = ComponentDefine
TroopItem.ComponentDestroy = ComponentDestroy
TroopItem.DataDefine = DataDefine
TroopItem.DataDestroy = DataDestroy
TroopItem.OnAddListener = OnAddListener
TroopItem.OnRemoveListener = OnRemoveListener
TroopItem.ReInit = ReInit
TroopItem.OnItemClick = OnItemClick
TroopItem.InstanteHeroCell = InstanteHeroCell
TroopItem.InstanteSoliderCell = InstanteSoliderCell




return TroopItem

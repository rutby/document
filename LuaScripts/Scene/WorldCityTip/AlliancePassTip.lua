---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/7/19 21:55
---
local AlliancePassTip = BaseClass("AlliancePassTip")
local SpriteRenderer = CS.UnityEngine.SpriteRenderer
local SuperTextMesh = CS.SuperTextMesh
local TouchObjectEventTrigger = CS.TouchObjectEventTrigger
local Localization = CS.GameEntry.Localization

local nameLabel_path = "NameLabel"
local nameText_path = "NameLabel/NameText"
--local allianceText_path = "NameLabel/allianceText"
local levelLabel_path = "LevelLabel"
local levelText_path = "LevelLabel/LevelText"
local highLevelText_path = "HighLevelLabel/HighLevelText"
local collider1_path = "Collider1"
local image_path = "Image"
local declareWar_path = "DecObj/DeclareWar"
local declareWarBtn_path = "DecObj/DeclareWar/DeclareWarBtn"
local declareWarList_path = "DecObj/DeclareWar/DeclareList"
local posOffset = Vector3.New(-4, 0, -6)
local namePadding = 0.6
local colliderPadding = 0.6
local levelOffset = 0.3

local function OnCreate(self, request)
    self.request = request
    self.gameObject = request.gameObject
    self.transform = request.gameObject.transform
    self.name_spr = self.transform:Find(nameLabel_path):GetComponent(typeof(SpriteRenderer))
    self.name_text = self.transform:Find(nameText_path):GetComponent(typeof(SuperTextMesh))
    self.image = self.transform:Find(image_path):GetComponent(typeof(SpriteRenderer))
    self.level_spr = self.transform:Find(levelLabel_path):GetComponent(typeof(SpriteRenderer))
    self.level_text = self.transform:Find(levelText_path):GetComponent(typeof(SuperTextMesh))
    self.high_level_text = self.transform:Find(highLevelText_path):GetComponent(typeof(SuperTextMesh))
    self.collider1 = self.transform:Find(collider1_path):GetComponent(typeof(TouchObjectEventTrigger))
    self.collider1.onPointerClick = function()
        self:OnClick()
    end
    self.cacheLod = 1
    self.declareWar = self.transform:Find(declareWar_path):GetComponent(typeof(SpriteRenderer))
    self.declareWarList = self.transform:Find(declareWarList_path):GetComponent(typeof(SpriteRenderer))
    self.declareWarBtn = self.transform:Find(declareWarBtn_path):GetComponent(typeof(TouchObjectEventTrigger))
    self.declareWarBtn.onPointerClick = function()
        self:OnClickDeclare()
    end
end


local function OnDestroy(self)
    self.data = nil
    self.name_spr = nil
    self.name_text = nil
    self.level_spr = nil
    self.level_text = nil
    self.collider1.onPointerClick = nil
    self.collider1 = nil
    self.declareWar = nil
    self.declareWarList = nil
end

local function OnClick(self)
    GoToUtil.GotoWorldPos(self.transform.position, 23, 0.3,nil,LuaEntry.Player:GetCurServerId())
end

local function SetData(self, data)
    self.data = data
    self:SetAllianceColor(data.id)
    self:SetName(data.id)
    self:SetLevel(data.level)
    self:SetTilePos(data.pos)
    self:CheckCityDeclare()
end

local function SetAllianceColor(self,cityId)
    local pic = "Assets/Main/Sprites/LodIcon/UIEdenPass_white.png"
    local color = WorldWhiteColor32
    local cityData = DataCenter.WorldAllianceCityDataManager:GetAlliancePassDataByCityId(cityId)
    if cityData~=nil then
        if cityData.allianceId~=nil and cityData.allianceId~="" then
            if cityData.allianceId == LuaEntry.Player.allianceId then
                pic = "Assets/Main/Sprites/LodIcon/UIEdenPass_blue.png"
                color = WorldBlueColor32
            elseif DataCenter.GloryManager:IsSameCampByAllianceId(cityData.allianceId) ==true then
                pic = "Assets/Main/Sprites/LodIcon/UIEdenPass_yellow.png"
                color = WorldYellowColor32
            else
                pic = "Assets/Main/Sprites/LodIcon/UIEdenPass_red.png"
                color = WorldRedColor32
            end
        end
    end
    self.name_text.color32 = color
    self.image:LoadSprite(pic)
end

local function SetName(self,cityId)
    if self.data == nil then
        return
    end
    local name = Localization:GetString(self.data.name)
    local cityInfo = DataCenter.WorldAllianceCityDataManager:GetAlliancePassDataByCityId(cityId)
    if cityInfo~=nil and cityInfo.cityName~=nil and cityInfo.cityName~="" then
        name = cityInfo.cityName
    end
    if cityInfo~=nil and cityInfo.abbr~=nil and cityInfo.abbr~=""then
        local abbr = "["..cityInfo.abbr.."]"
        name = abbr..name
    end
    -- 名字文本
    self.name_text.text = name
    
end

local function SetLevel(self, level)
    self.level_text.text = level
    self.high_level_text.text = level
end

local function SetTilePos(self, tilePos)
    --local pos = SceneUtils.TileToWorld(tilePos.x, tilePos.y)
    local pos = SceneUtils.TileToWorld(tilePos)
    self:SetPos(pos)
end

local function SetPos(self, pos)
    local t = pos + posOffset
    self.transform:Set_position(t.x, t.y, t.z)
    --self.transform.position = pos + posOffset
end

local function SetNameBg(self, path)
    self.name_spr:LoadSprite(path)
end


local function CheckCityDeclare(self)
    if self.data == nil or CrossServerUtil:GetIsCrossServer() then
        self.declareWar.gameObject:SetActive(false)
        return
    end
    local data  = DataCenter.AllianceDeclareWarManager:GetWarDataByCityId(self.data.id)
    --if data and tonumber(data.content) == cityId then
    if next(data) then
        local isSelfAlliance = false
        local isSameCamp = false
        local selfAlliance = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
        for i = 1 ,#data do
            if selfAlliance and data[i].aId == selfAlliance.uid then
                isSelfAlliance = true
            elseif LuaEntry.Player.serverType == ServerType.EDEN_SERVER and DataCenter.GloryManager:IsSameCampByAllianceId(data[i].aId) ==true then
                isSameCamp = true
            end
        end
        if isSelfAlliance then
            local pic = string.format(LoadPath.LodIcon,"UImap_img_declare-war_blue")
            self.declareWar:LoadSprite(pic)
        elseif isSameCamp then
            local pic = string.format(LoadPath.LodIcon,"UImap_img_declare-war_yellow")
            self.declareWar:LoadSprite(pic)
        else
            local pic = string.format(LoadPath.LodIcon,"UImap_img_declare-war_red")
            self.declareWar:LoadSprite(pic)
        end
        self.declareWar.gameObject:SetActive(true)
        if table.count(data) > 1 then
            self.declareWarList.gameObject:SetActive(true)
        else
            self.declareWarList.gameObject:SetActive(false)
        end
    else
        self.declareWar.gameObject:SetActive(false)
    end
end

local function OnClickDeclare(self)
    if self.data == nil then
        return
    end
    local data  = DataCenter.AllianceDeclareWarManager:GetWarDataByCityId(self.data.id)
    if next(data) and self.lodCache >= 4 then
        if table.count(data) >= 1 then
            CS.SceneManager.World:SetUseInput(false)
            GoToUtil.GotoOpenView(UIWindowNames.UIWorldDeclareList,SceneUtils.TilePosToIndex(self.data.pos),self.data.id)
        end
    end
end

local function SetLod(self,lod)
    if self.lodCache ~=lod then
        self.lodCache =lod
    end
end


AlliancePassTip.OnCreate = OnCreate
AlliancePassTip.OnDestroy = OnDestroy
AlliancePassTip.OnClick = OnClick
AlliancePassTip.SetData = SetData
AlliancePassTip.SetName = SetName
AlliancePassTip.SetLevel = SetLevel
AlliancePassTip.SetTilePos = SetTilePos
AlliancePassTip.SetPos = SetPos
AlliancePassTip.SetNameBg = SetNameBg
AlliancePassTip.SetAllianceColor = SetAllianceColor
AlliancePassTip.CheckCityDeclare = CheckCityDeclare
AlliancePassTip.OnClickDeclare = OnClickDeclare
AlliancePassTip.SetLod =SetLod
return AlliancePassTip
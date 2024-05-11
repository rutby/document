local PlayerContent = BaseClass("PlayerContent", UIBaseContainer)
local base = UIBaseContainer

local ContentSizeFitter = CS.UnityEngine.UI.ContentSizeFitter
local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization

local scrollView_path = "ScrollView/Viewport/Content/"
--head
local head_icon_path = "Head/UIPlayerHead/HeadIcon"
local head_Name_txt_path = "Head/Head_Name"
local head_forceDes_txt_path = "Head/layout/powerDi/ForceDes"
local head_force_txt_path = "Head/layout/powerDi/Force"
local head_killDes_txt_path = "Head/layout/KillDi/KillDes"
local head_kill_txt_path = "Head/layout/KillDi/Kill"
--Froce
local force_title_txt_path =  scrollView_path .. "Force/Force_title"
local force_building_txt_path = scrollView_path .. "Force/Content/Text_Building"
local force_buildingDes_txt_path = scrollView_path .. "Force/Content/Text_BuildingDes"
local force_scientific_txt_path = scrollView_path .. "Force/Content/Text_Scientific"
local force_scientificDes_txt_path = scrollView_path .. "Force/Content/Text_ScientificDes"
local force_troops_txt_path = scrollView_path .. "Force/Content/Text_Troops"
local force_troopsDes_txt_path = scrollView_path .. "Force/Content/Text_TroopsDes"
local force_commander_txt_path = scrollView_path .. "Force/Content/Text_Commander"
local force_commanderDes_txt_path = scrollView_path .. "Force/Content/Text_CommanderDes"

--BattleStatistics
local BattleStatistics_title_txt_path = scrollView_path .. "BattleStatistics/BattleStatistics_title"
local BattleStatistics_historyWarfare_txt_path = scrollView_path .. "BattleStatistics/Content/Text_HistoryWarfare"
local BattleStatistics_historyWarfareDes_txt_path = scrollView_path .. "BattleStatistics/Content/Text_HistoryWarfareDes"
local BattleStatistics_victory_txt_path = scrollView_path .. "BattleStatistics/Content/Text_Victory"
local BattleStatistics_victoryDes_txt_path = scrollView_path .. "BattleStatistics/Content/Text_VictoryDes"
local BattleStatistics_investigate_txt_path = scrollView_path .. "BattleStatistics/Content/Text_Investigation"
local BattleStatistics_investigateDes_txt_path = scrollView_path .. "BattleStatistics/Content/Text_InvestigationDes"
local BattleStatistics_Defeat_txt_path = scrollView_path .. "BattleStatistics/Content/Text_Defeat"
local BattleStatistics_DefeatDes_txt_path = scrollView_path .. "BattleStatistics/Content/Text_DefeatDes"
local BattleStatistics_AramyDead_txt_path  = scrollView_path .. "BattleStatistics/Content/Text_ArmyDead"
local BattleStatistics_AramyDeadDes_txt_path = scrollView_path .."BattleStatistics/Content/Text_ArmyDeadDes"

local force_content_path = scrollView_path .. "Force"

--emptyText
local playerEmpty_txt_path = "PlayerEmptyText"
local head_content_path = "Head"
local scrollView_content_path = "ScrollView"

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
    self.head_icon = self:AddComponent(UIPlayerHead, head_icon_path)
    self.head_Name_txt = self:AddComponent(UITextMeshProUGUIEx, head_Name_txt_path)
    self.head_forceDes_txt = self:AddComponent(UITextMeshProUGUIEx, head_forceDes_txt_path)
    
    -- self.sizeFitter = self.head_forceDes_txt.rectTransform:GetComponent(typeof(ContentSizeFitter))
    -- local isOn = Setting:GetPrivateBool("UseContentSizeFitter",true)
    -- if isOn then
    --     self.sizeFitter.horizontalFit = ContentSizeFitter.FitMode.PreferredSize
    -- else
    --     self.sizeFitter.horizontalFit = ContentSizeFitter.FitMode.Unconstrained
    --     self.head_forceDes_txt.rectTransform.sizeDelta.x = 0
    -- end
    local tempX = self.head_forceDes_txt.rectTransform.sizeDelta.x
    
    self.head_force_txt = self:AddComponent(UITextMeshProUGUIEx, head_force_txt_path)
    self.head_killDes_txt = self:AddComponent(UITextMeshProUGUIEx, head_killDes_txt_path)
    self.head_kill_txt= self:AddComponent(UITextMeshProUGUIEx, head_kill_txt_path)
    --Froce
    self.force_title_txt= self:AddComponent(UITextMeshProUGUIEx, force_title_txt_path)
    self.force_building_txt= self:AddComponent(UITextMeshProUGUIEx, force_building_txt_path)
    self.force_buildingDes_txt= self:AddComponent(UITextMeshProUGUIEx, force_buildingDes_txt_path)
    self.force_scientific_txt= self:AddComponent(UITextMeshProUGUIEx, force_scientific_txt_path)
    self.force_scientificDes_txt= self:AddComponent(UITextMeshProUGUIEx, force_scientificDes_txt_path)
    self.force_troops_txt=self:AddComponent(UITextMeshProUGUIEx, force_troops_txt_path)
    self.force_troopsDes_txt= self:AddComponent(UITextMeshProUGUIEx, force_troopsDes_txt_path)
    self.force_commander_txt=self:AddComponent(UITextMeshProUGUIEx, force_commander_txt_path)
    self.force_commanderDes_txt= self:AddComponent(UITextMeshProUGUIEx, force_commanderDes_txt_path)

    --BattleStatistics
    self.BattleStatistics_title_txt=self:AddComponent(UITextMeshProUGUIEx, BattleStatistics_title_txt_path)
    self.BattleStatistics_historyWarfare_txt= self:AddComponent(UITextMeshProUGUIEx, BattleStatistics_historyWarfare_txt_path)
    self.BattleStatistics_historyWarfareDes_txt= self:AddComponent(UITextMeshProUGUIEx, BattleStatistics_historyWarfareDes_txt_path)
    self.BattleStatistics_victory_txt= self:AddComponent(UITextMeshProUGUIEx, BattleStatistics_victory_txt_path)
    self.BattleStatistics_victoryDes_txt= self:AddComponent(UITextMeshProUGUIEx, BattleStatistics_victoryDes_txt_path)
    self.BattleStatistics_investigate_txt=self:AddComponent(UITextMeshProUGUIEx, BattleStatistics_investigate_txt_path)
    self.BattleStatistics_investigateDes_txt= self:AddComponent(UITextMeshProUGUIEx, BattleStatistics_investigateDes_txt_path)
    self.BattleStatistics_Defeat_txt= self:AddComponent(UITextMeshProUGUIEx, BattleStatistics_Defeat_txt_path)
    self.BattleStatistics_DefeatDes_txt= self:AddComponent(UITextMeshProUGUIEx, BattleStatistics_DefeatDes_txt_path)
    self.BattleStatistics_AramyDead_txt= self:AddComponent(UITextMeshProUGUIEx, BattleStatistics_AramyDead_txt_path)
    self.BattleStatistics_AramyDeadDes_txt= self:AddComponent(UITextMeshProUGUIEx, BattleStatistics_AramyDeadDes_txt_path)
    
    
    self.force_content = self:AddComponent(UIBaseContainer,force_content_path)
    
    self.playerEmpty_txt = self:AddComponent(UITextMeshProUGUIEx,playerEmpty_txt_path)
    self.head_content = self:AddComponent(UIBaseContainer,head_content_path)
    self.scrollView_content = self:AddComponent(UIBaseContainer,scrollView_content_path)
    
    
end

local function ComponentDestroy(self)
    self.title_txt = nil
end


local function DataDefine(self)
    self.cellList = {}
end

local function DataDestroy(self)
    self.cellList = nil
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ReInit(self,param)
    self.param = param
    if self.param ~= nil then
        local info =  DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(self.param)
        if info ~= nil then
          --  EventManager:GetInstance():Broadcast(EventId.PlayerMessageInfo)
          self:OnPlayerDataCallBack()
        else
            SFSNetwork.SendMessage(MsgDefines.GetNewUserInfo, self.param)
            self.playerEmpty_txt.gameObject:SetActive(true)
            self.head_content.gameObject:SetActive(false)
            self.scrollView_content.gameObject:SetActive(false)
            self.playerEmpty_txt:SetText(Localization:GetString("140042")..Localization:GetString("300036"))
        end
    end
end

local function  OnPlayerDataCallBack(self)
    local info = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(self.param)
    if info ~= nil then
        local isSelf = self.param == LuaEntry.Player.uid
        local forceTotal = info.buildingPower + info.sciencePower + info.armyPower + info.heroPower
        local uid = self.param--LuaEntry.Player:GetUid()
        local pic = info.pic
        local picVer = info.picVer
        self.head_icon:SetData(uid, pic, picVer)
        self.head_Name_txt:SetText(info.name)
        self.head_forceDes_txt:SetLocalText(100644)
        self.head_force_txt:SetText(info.power)
        self.head_killDes_txt:SetLocalText(100196) 
        self.head_kill_txt:SetText(info.armyKill)
        --Froce
        if isSelf == true then
            self.force_content.gameObject:SetActive(true)
            self.force_title_txt:SetLocalText(100644)
            self.force_building_txt:SetText(info.buildingPower)
            self.force_buildingDes_txt:SetLocalText(110155) 
            self.force_scientific_txt:SetText(info.sciencePower)
            self.force_scientificDes_txt:SetLocalText(110156) 
            self.force_troops_txt:SetText(info.armyPower)
            self.force_troopsDes_txt:SetLocalText(110157) 
            self.force_commander_txt:SetText(info.heroPower)
            self.force_commanderDes_txt:SetLocalText(110158) 
        else
            self.force_content.gameObject:SetActive(false)
        end

        --BattleStatistics
        self.BattleStatistics_title_txt:SetLocalText(129067) 
        self.BattleStatistics_historyWarfare_txt:SetText(info.playerMaxPower)
        self.BattleStatistics_historyWarfareDes_txt:SetLocalText(110159) 
        self.BattleStatistics_victory_txt:SetText(info.battleWin)
        self.BattleStatistics_victoryDes_txt:SetLocalText(390186) 
        self.BattleStatistics_Defeat_txt:SetText(info.battleLose)
        self.BattleStatistics_DefeatDes_txt:SetLocalText(390187) 
        self.BattleStatistics_AramyDead_txt:SetText(info.armyDead)
        self.BattleStatistics_AramyDeadDes_txt:SetLocalText(310131) 
        self.BattleStatistics_investigate_txt:SetText(info.scoutCount)
        self.BattleStatistics_investigateDes_txt:SetLocalText(110160) 
        self.playerEmpty_txt.gameObject:SetActive(false)
        self.head_content.gameObject:SetActive(true)
        self.scrollView_content.gameObject:SetActive(true)
    else
        self.playerEmpty_txt.gameObject:SetActive(true)
        self.head_content.gameObject:SetActive(false)
        self.scrollView_content.gameObject:SetActive(false)
        self.playerEmpty_txt:SetText(Localization:GetString("140042")..Localization:GetString("300036"))
    end
end



PlayerContent.OnCreate = OnCreate
PlayerContent.OnDestroy = OnDestroy
PlayerContent.OnEnable = OnEnable
PlayerContent.OnDisable = OnDisable
PlayerContent.ComponentDefine = ComponentDefine
PlayerContent.ComponentDestroy = ComponentDestroy
PlayerContent.DataDefine = DataDefine
PlayerContent.DataDestroy = DataDestroy
PlayerContent.ReInit = ReInit
PlayerContent.OnPlayerDataCallBack = OnPlayerDataCallBack



return PlayerContent

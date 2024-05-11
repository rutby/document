---
--- PVE 场景UI
--- 2024/1/10 11:15 重构
---

local UIPVESceneView = BaseClass("UIPVESceneView", UIBaseView)
local base = UIBaseView
local Const = require "Scene.BattlePveModule.Const"
local UIPVEHeroHead = require "UI.UIPVE.UIPVEScene.Component.UIPVEHeroHead"
local UIPVEHeroHp = require "UI.UIPVE.UIPVEScene.Component.UIPVEHeroHp"
local UIPVEUseSkillItem = require "UI.UIPVE.UIPVEScene.Component.UIPVEUseSkillItem"
local PVEHeroSelectList = require "UI.UIPVE.UIPVEScene.Component.PVEHeroSelectList"
local PveBuffCell = require "UI.UIPVE.UIPVEScene.Component.PveBuffCell"
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray

local head_list_path = "Root/Bottom/HeadList"
local head_path = "Root/Bottom/HeadList/Head_%s"
local hero_list_path = "Root/Bottom/HeroList"
local home_btn_path = 'Root/Bottom/Home'
local speed_path = "Root/Bottom/Speed"
local speed_x1_path = "Root/Bottom/Speed/SpeedX1"
local speed_x2_path = "Root/Bottom/Speed/SpeedX2"
local speed_x2_vx_path = "Root/Bottom/Speed/SpeedX2VX"
local speed_x4_path = "Root/Bottom/Speed/SpeedX4"
local speed_red_path = "Root/Bottom/Speed/SpeedRed"
local skip_path = "Root/Bottom/Skip"
local start_path = "Root/Bottom/Start"
local start_text_path = "Root/Bottom/Start/StartText"
local hero_btn_path = "Root/Bottom/HeroBtn"
local hero_red_path = "Root/Bottom/HeroBtn/HeroRed"
local hero_btn_text_path = "Root/Bottom/HeroBtn/HeroBtnText"
local save_path = "Root/Bottom/Save"
local save_text_path = "Root/Bottom/Save/SaveText"
local left_path = "Root/Top/Left"
local left_player_head_path = "Root/Top/Left/LeftPlayerHead"
local left_buff_path = "Root/Top/Left/LeftBuff"
local right_path = "Root/Top/Right"
local right_player_head_path = "Root/Top/Right/RightPlayerHead"
local right_buff_path = "Root/Top/Right/RightBuff"
local left_power_path = "Root/Top/Left/LeftPower"
local right_power_path = "Root/Top/Right/RightPower"
local level_bg_path = "Root/Top/LevelBg"
local level_path = "Root/Top/Level"
local center_path = "Root/Center"
local hp_path = "Root/Center/Hps/Hp_%s"

local Speed1 = 1
local Speed2 = 2
local Speed4 = 4
local HeadCount = 5
local HpCount = 10
local PowerTweenDuration = 0.3

local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.head_list = self:AddComponent(UIBaseContainer, head_list_path)
    self.head_list:SetActive(false)
    self.heads = {}
    for i = 1, HeadCount do
        self.heads[i] = self:AddComponent(UIPVEHeroHead, string.format(head_path, i))
    end
    self.hero_list = self:AddComponent(PVEHeroSelectList, hero_list_path)
    self.hero_list:SetActive(true)
    self.speed_go = self:AddComponent(UIBaseContainer, speed_path)
    self.speed_go:SetActive(false)
    self.speed_x1_btn = self:AddComponent(UIButton, speed_x1_path)
    self.speed_x1_btn:SetOnClick(function()
        self:OnSpeedClick(Speed1)
    end)
    self.speed_x2_btn = self:AddComponent(UIButton, speed_x2_path)
    self.speed_x2_btn:SetOnClick(function()
        self:OnSpeedClick(Speed2)
    end)
    self.speed_x2_vx_go = self:AddComponent(UIBaseContainer, speed_x2_vx_path)
    self.speed_x2_vx_go:SetActive(false)
    self.speed_x4_btn = self:AddComponent(UIButton, speed_x4_path)
    self.speed_x4_btn:SetOnClick(function()
        self:OnSpeedClick(Speed4)
    end)
    self.speed_red_go = self:AddComponent(UIBaseContainer, speed_red_path)
    self.skip_btn = self:AddComponent(UIButton, skip_path)
    self.skip_btn:SetActive(false)
    self.skip_btn:SetOnClick(function()
        self:OnSkipClick()
    end)
    self.home_btn = self:AddComponent(UIButton, home_btn_path)
    self.home_btn:SetActive(true)
    self.home_btn:SetOnClick(function()
        self:OnHomeClick()
    end)
    self.start_btn = self:AddComponent(UIButton, start_path)
    self.start_btn:SetActive(true)
    self.start_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_enter_pve)
        self:OnStartClick()
    end)
    self.start_text = self:AddComponent(UITextMeshProUGUIEx, start_text_path)
    self.start_text:SetLocalText(400006)
    self.hero_btn = self:AddComponent(UIButton, hero_btn_path)
    self.hero_btn:SetOnClick(function()
        self:OnHeroBtnClick()
    end)
    self.hero_red_go = self:AddComponent(UIBaseContainer, hero_red_path)
    self.hero_btn_text = self:AddComponent(UITextMeshProUGUIEx, hero_btn_text_path)
    self.hero_btn_text:SetLocalText(100275)
    self.save_btn = self:AddComponent(UIButton, save_path)
    self.save_btn:SetOnClick(function()
        self:OnSaveClick()
    end)
    self.save_btn:SetActive(false)
    self.save_text = self:AddComponent(UITextMeshProUGUIEx, save_text_path)
    self.save_text:SetLocalText(300055)
    self.left_go = self:AddComponent(UIBaseContainer, left_path)
    self.left_player_head = self:AddComponent(UIPlayerHead, left_player_head_path)
    self.left_player_head_image = self:AddComponent(CircleImage, left_player_head_path)
    self.left_buff_go = self:AddComponent(UIBaseContainer, left_buff_path)
    self.left_buff_go:SetActive(false)
    self.right_go = self:AddComponent(UIBaseContainer, right_path)
    self.right_player_head = self:AddComponent(UIPlayerHead, right_player_head_path)
    self.right_player_head_image = self:AddComponent(CircleImage, right_player_head_path)
    self.right_buff_go = self:AddComponent(UIBaseContainer, right_buff_path)
    self.right_buff_go:SetActive(false)
    self.left_power_text = self:AddComponent(UITweenNumberText_TextMeshPro, left_power_path)
    self.left_power_text:SetSeparator(true)
    self.right_power_text = self:AddComponent(UITweenNumberText_TextMeshPro, right_power_path)
    self.right_power_text:SetSeparator(true)
    self.level_bg = self:AddComponent(UIBaseContainer,level_bg_path)
    self.level_text = self:AddComponent(UITextMeshProUGUIEx, level_path)
    self.center_go = self:AddComponent(UIBaseContainer, center_path)
    self.hps = {}
    for i = 1, HpCount do
        self.hps[i] = self:AddComponent(UIPVEHeroHp, string.format(hp_path, i))
    end
end

local function ComponentDestroy(self)
    self:ClearLeftBuff()
    self:ClearRightBuff()
end

local function DataDefine(self)
    local entranceType = DataCenter.BattleLevel:GetEntranceType()
    if entranceType == PveEntrance.BattlePlayBack then
        self.ctrl:InitData(false, entranceType)
    else
        self.ctrl:InitData(true, entranceType)
    end
    
    self.leftBuffReqs = {}
    self.rightBuffReqs = {}
    self.leftBuffCells = {}
    self.rightBuffCells = {}
    
    self.monsterId = 0
    self.leftPower = 0
    self.rightPower = 0
    self.selectBuffId = nil
    self.isLeftBuffId = nil
    self.isShowLineup = false
    self.useSkillReqs = {}
    self.useSkillItems = {}
    self.useSkillIndex = 0
end

local function DataDestroy(self)
    self.center_go:RemoveComponents(UIPVEUseSkillItem)
    for _, req in pairs(self.useSkillReqs) do
        req:Destroy()
    end
    self.useSkillItems = {}
end

local function OnEnable(self)
    base.OnEnable(self)
    self.active = true
    self:ReInit()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UITutorialAnimation)
end

local function OnDisable(self)
    self.active = false
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroTips)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.PVE_TotalHp_Changed, self.OnTotalHpChanged)
    self:AddUIListener(EventId.PVE_Lineup_Init_End, self.OnLineupInitEnd)
    self:AddUIListener(EventId.PVEBattleSetLeftBuffData, self.SetLeftBuffData)
    self:AddUIListener(EventId.PVEBattleSetRightBuffData, self.SetRightBuffData)
    self:AddUIListener(EventId.PVEBattleShowLeftBuff, self.ShowLeftBuff)
    self:AddUIListener(EventId.PVEBattleShowRightBuff, self.ShowRightBuff)
    self:AddUIListener(EventId.PveMineCaveInfoUpdate, self.OnPveMineCaveInfoUpdate)
    self:AddUIListener(EventId.CloseUI, self.OnCloseUI)
    self:AddUIListener(EventId.OnPveHeroCancel, self.OnPveHeroCancel)
    self:AddUIListener(EventId.HeroBeyondSuccess, self.RefreshHeroBtn)
    self:AddUIListener(EventId.HeroLvUpSuccess, self.RefreshHeroBtn)
    self:AddUIListener(EventId.SkillUpgradeEnd, self.RefreshHeroBtn)
    self:AddUIListener(EventId.HeroMedalExchanged, self.RefreshHeroBtn)
    self:AddUIListener(EventId.HeroAdvanceSuccess, self.RefreshHeroBtn)
    self:AddUIListener(EventId.ArenaCampEffectUpdate,self.RefreshArenaRightArmy)
    self:AddUIListener(EventId.PveHeroHpUpdate,self.OnPveHeroHpUpdate)
    self:AddUIListener(EventId.PveHeroAngerUpdate, self.OnPveHeroAngerUpdate)
    self:AddUIListener(EventId.PveHeroUseSkill, self.OnPveHeroUseSkill)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.PVE_TotalHp_Changed, self.OnTotalHpChanged)
    self:RemoveUIListener(EventId.PVE_Lineup_Init_End, self.OnLineupInitEnd)
    self:RemoveUIListener(EventId.PVEBattleSetLeftBuffData, self.SetLeftBuffData)
    self:RemoveUIListener(EventId.PVEBattleSetRightBuffData, self.SetRightBuffData)
    self:RemoveUIListener(EventId.PVEBattleShowLeftBuff, self.ShowLeftBuff)
    self:RemoveUIListener(EventId.PVEBattleShowRightBuff, self.ShowRightBuff)
    self:RemoveUIListener(EventId.PveMineCaveInfoUpdate, self.OnPveMineCaveInfoUpdate)
    self:RemoveUIListener(EventId.CloseUI, self.OnCloseUI)
    self:RemoveUIListener(EventId.OnPveHeroCancel, self.OnPveHeroCancel)
    self:RemoveUIListener(EventId.HeroBeyondSuccess, self.RefreshHeroBtn)
    self:RemoveUIListener(EventId.HeroLvUpSuccess, self.RefreshHeroBtn)
    self:RemoveUIListener(EventId.SkillUpgradeEnd, self.RefreshHeroBtn)
    self:RemoveUIListener(EventId.HeroMedalExchanged, self.RefreshHeroBtn)
    self:RemoveUIListener(EventId.HeroAdvanceSuccess, self.RefreshHeroBtn)
    self:RemoveUIListener(EventId.ArenaCampEffectUpdate,self.RefreshArenaRightArmy)
    self:RemoveUIListener(EventId.PveHeroHpUpdate, self.OnPveHeroHpUpdate)
    self:RemoveUIListener(EventId.PveHeroAngerUpdate, self.OnPveHeroAngerUpdate)
    self:RemoveUIListener(EventId.PveHeroUseSkill, self.OnPveHeroUseSkill)
    base.OnRemoveListener(self)
end


local function ReInit(self)
    self.levelParam = self:GetUserData()
    self:InitSpeed()
    self:RefreshPlayerHead()
    self.level_bg:SetActive(false)
    self.level_text:SetText("VS")
    for i = 1, HpCount do
        self.hps[i]:SetActive(false)
    end

    local entranceType = DataCenter.BattleLevel:GetEntranceType()
    if entranceType == PveEntrance.BattlePlayBack then
        self.hero_btn:SetActive(false)
        self.hero_list:SetActive(false)
        self.start_btn:SetActive(false)
        self.home_btn:SetActive(true)
        self.isShowLineup = true
        self:RefreshPlayBackLeftArmy()
        self:RefreshPlayBackRightArmy()
    elseif entranceType == PveEntrance.Story then
        self.level_bg:SetActive(true)
        self.level_text:SetText(DataCenter.BattleLevel.levelParam.storyLevel)
        self.monsterId = tonumber(GetTableData(TableName.Pve, self.levelParam.levelId, "monster"))
        self.hero_btn:SetActive(true)
        self.right_go:SetActive(true)
        self:RefreshHeroBtn()
        self:RefreshRightArmy()
    elseif entranceType == PveEntrance.LandBlock then
        self.level_bg:SetActive(true)
        local config = DataCenter.LandManager:GetConfig(LandObjectType.Block, DataCenter.BattleLevel.levelParam.blockId)
        self.level_text:SetText(config.order)
        self.monsterId = tonumber(GetTableData(TableName.Pve, self.levelParam.levelId, "monster"))
        self.hero_btn:SetActive(true)
        self.right_go:SetActive(true)
        self:RefreshHeroBtn()
        self:RefreshRightArmy()
    elseif entranceType == PveEntrance.MineCave then
        if DataCenter.MineCaveManager:CheckIfNeedPreloadEnemy() then
            self.right_go:SetActive(true)
            self.right_power_text:SetActive(true)
        else
            self.right_go:SetActive(false)
            self.right_power_text:SetActive(false)
        end
        self.hero_btn:SetActive(false)
        self:RefreshRightArmy()
    elseif entranceType == PveEntrance.ArenaSetting then
        self.right_go:SetActive(false)
        self.start_btn:SetActive(false)
        --self.save_btn:SetActive(true)
        self.home_btn:SetActive(true)
        self.hero_btn:SetActive(false)
    elseif entranceType == PveEntrance.ArenaBattle then
        self.hero_btn:SetActive(false)
        self:RefreshRightArmy()
        PveActorMgr:GetInstance():SendArenaGetEnemyCampEffect()
    else
        self.monsterId = tonumber(GetTableData(TableName.Pve, self.levelParam.levelId, "monster"))
        self.hero_btn:SetActive(true)
        self.right_go:SetActive(true)
        self:RefreshHeroBtn()
        self:RefreshRightArmy()
    end
    
    if PveActorMgr:GetInstance():IsLineupLoadOK() then
        self:ShowLineup()
    end
end

local function GetHeroObjByHeroId(self, heroId)
    return self.hero_list:GetHeroObjByHeroId(heroId)
end

local function InitSpeed(self)
    self.speed2Open = false
    self.speed4Open = false
    local entranceType = DataCenter.BattleLevel:GetEntranceType()
    if entranceType == PveEntrance.BattlePlayBack then
        self.speed2Open = true
        self.speed4Open = true
    else
        local mainLv = DataCenter.BuildManager.MainLv
        local configStr = LuaEntry.DataConfig:TryGetStr("aps_pve_config", "k8")
        local configArr = string.split(configStr, ";")
        if #configArr >= 2 then
            local s2Lv = tonumber(configArr[1])
            local s4Lv = tonumber(configArr[2])
            self.speed2Open = (mainLv >= s2Lv)
            self.speed4Open = (mainLv >= s4Lv)
        end
    end
    self:RefreshSpeed()
end

local function RefreshSpeed(self)
    local speed = Setting:GetPrivateInt(SettingKeys.PVE_SPEED_OFFSET, Speed1)
    if speed == Speed4 and not self.speed4Open then
        speed = Speed2
    end
    if speed == Speed2 and not self.speed2Open then
        speed = Speed1
    end
    self.speed_x1_btn:SetActive(speed == Speed1 and (self.speed2Open or self.speed4Open))
    self.speed_x2_btn:SetActive(speed == Speed2 and self.speed2Open)
    self.speed_x4_btn:SetActive(speed == Speed4 and self.speed4Open)
    PveActorMgr:GetInstance():SetSpeedOffset(speed)
    self:RefreshSpeedRed()
end

local function RefreshSpeedRed(self)
    if self.speed2Open or self.speed4Open then
        local showRed = false
        local show = Setting:GetPrivateInt(SettingKeys.PVE_SPEED_SHOW_RED_DOT, Speed1)
        if show < Speed2 then
            local speed = PveActorMgr:GetInstance():GetSpeedOffset()
            if speed == Speed1 then
                showRed = true
            elseif speed == Speed2 then
                if self.speed4Open then
                    showRed = true
                else
                    Setting:SetPrivateInt(SettingKeys.PVE_SPEED_SHOW_RED_DOT, Speed2)
                end
            elseif speed == Speed4 then
                Setting:SetPrivateInt(SettingKeys.PVE_SPEED_SHOW_RED_DOT, Speed4)
            end
        elseif show < Speed4 then
            local speedOffset = PveActorMgr:GetInstance():GetSpeedOffset()
            if self.speed4Open then
                if speedOffset < Speed4 then
                    showRed = true
                else
                    Setting:SetPrivateInt(SettingKeys.PVE_SPEED_SHOW_RED_DOT, Speed4)
                end
            end
        end
        self.speed_red_go:SetActive(showRed)
        if self.speed2Open and showRed then
            self.speed_x2_vx_go:SetActive(true)
        end
    else
        self.speed_red_go:SetActive(false)
    end
end

local function RefreshHeroBtn(self)
    local show = DataCenter.HeroDataManager:ShowHeroRed()
    self.hero_red_go:SetActive(show)
end

local function RefreshPlayerHead(self)
    local leftParam = PveActorMgr:GetInstance():GetLeftHeadParam()
    if not string.IsNullOrEmpty(leftParam.uid) then
        self.left_player_head:SetData(leftParam.uid, leftParam.pic, leftParam.picVer)
    else
        self.left_player_head_image:LoadSprite("Assets/Main/Sprites/UI/UIHeadIcon/player_head_2")
    end
    local rightParam = PveActorMgr:GetInstance():GetRightHeadParam()
    if not string.IsNullOrEmpty(rightParam.uid) then
        self.right_player_head:SetData(rightParam.uid, rightParam.pic, rightParam.picVer)
    elseif not string.IsNullOrEmpty(rightParam.monsterPic) then
        self.right_player_head_image:LoadSprite(rightParam.monsterPic)
    else
        self.right_player_head_image:LoadSprite("Assets/Main/Sprites/UI/UIHeadIcon/player_head_2")
    end
end

local function ShowLeftBuff(self,data)
    local str = tostring(data)
    local arr = string.split(str,"|")
    if #arr<2 then
        return
    end
    local k = tonumber(arr[1])
    local level  =tonumber(arr[2])
    if level==nil or level<=0 then
        level = 1
    end
    self.left_buff_go:SetActive(true)
    if self.leftBuffReqs[k]==nil then
        self.leftBuffReqs[k] = self:GameObjectInstantiateAsync(UIAssets.UIPVESceneBuffCell, function(request)
            if request.isError then
                return
            end
            local go = request.gameObject
            go:SetActive(true)
            go.transform:SetParent(self.left_buff_go.transform)
            go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            local nameStr = tostring(NameCount)
            go.name = nameStr
            NameCount = NameCount + 1
            local cell = self.left_buff_go:AddComponent(PveBuffCell,nameStr)
            cell:InitData(k,nameStr,true,level)
            self.leftBuffCells[k] = cell
        end)
    end
end

local function ShowRightBuff(self,data)
    local str = tostring(data)
    local arr = string.split(str,"|")
    if #arr<2 then
        return
    end
    local k = tonumber(arr[1])
    local level  =tonumber(arr[2])
    if level==nil or level<=0 then
        level = 1
    end
    self.right_buff_go:SetActive(true)
    if self.rightBuffReqs[k]==nil then
        self.rightBuffReqs[k] = self:GameObjectInstantiateAsync(UIAssets.UIPVESceneBuffCell, function(request)
            if request.isError then
                return
            end
            local go = request.gameObject
            go:SetActive(true)
            go.transform:SetParent(self.right_buff_go.transform)
            go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            local nameStr = tostring(NameCount)
            go.name = nameStr
            NameCount = NameCount + 1
            local cell = self.right_buff_go:AddComponent(PveBuffCell,nameStr)
            cell:InitData(k,nameStr,false,level)
            self.rightBuffCells[k] = cell
        end)
    end
end

local function ClearLeftBuff(self)
    for k,v in pairs(self.leftBuffReqs) do
        if v~=nil then
            v:Destroy()
        end
    end
    self.left_buff_go:RemoveComponents(PveBuffCell)
    self.leftBuffReqs = {}
    self.leftBuffCells = {}
end

local function ClearRightBuff(self)
    for k,v in pairs(self.rightBuffReqs) do
        if v~=nil then
            v:Destroy()
        end
    end
    self.right_buff_go:RemoveComponents(PveBuffCell)
    self.rightBuffReqs = {}
    self.rightBuffCells = {}
end

local function SetLeftBuffData(self, data)
    if data~=nil and table.count(data)>0 then
        for k,v in pairs(data) do
            if self.cacheleftBuffCells~=nil and self.cacheleftBuffCells[k]~=nil then
                self.cacheleftBuffCells[k] = nil
            end
        end
        if self.cacheleftBuffCells~=nil then
            for k,v in pairs(self.cacheleftBuffCells) do
                if self.leftBuffCells[k]~=nil then
                    local nameStr = self.leftBuffCells[k].objName
                    self.left_buff_go:RemoveComponent(nameStr,PveBuffCell)
                    self.leftBuffCells[k] = nil
                end
                if self.leftBuffReqs[k]~=nil then
                    self.leftBuffReqs[k]:Destroy()
                    self.leftBuffReqs[k] = nil
                end
                self:CheckRemoveTipsByBuffId(k,true)
            end
        end
    else
        self:CheckRemoveTipsByBuffId(self.selectBuffId,true)
        self:ClearLeftBuff()
        self.left_buff_go:SetActive(false)
    end
    self.cacheleftBuffCells = data
end

local function SetRightBuffData(self, data)
    if data~=nil and table.count(data)>0 then
        for k,v in pairs(data) do
            if self.cacherightBuffCells~=nil and self.cacherightBuffCells[k]~=nil then
                self.cacherightBuffCells[k] = nil
            end
        end
        if self.cacherightBuffCells~=nil then
            for k,v in pairs(self.cacherightBuffCells) do
                if self.rightBuffCells[k]~=nil then
                    local nameStr = self.rightBuffCells[k].objName
                    self.right_buff_go:RemoveComponent(nameStr,PveBuffCell)
                    self.rightBuffCells[k] = nil
                end
                if self.rightBuffReqs[k]~=nil then
                    self.rightBuffReqs[k]:Destroy()
                    self.rightBuffReqs[k] = nil
                end
                self:CheckRemoveTipsByBuffId(k,false)
            end
        end
    else
        self:ClearRightBuff()
        self.right_buff_go:SetActive(false)
        self:CheckRemoveTipsByBuffId(self.selectBuffId,false)
    end
    self.cacherightBuffCells = data
end

local function SetSelectBuff(self,buffId,isLeft)
    self.selectBuffId = buffId
    self.isLeftBuffId = isLeft
end

local function CheckRemoveTipsByBuffId(self,buffId,isLeft)
    if self.selectBuffId == buffId and self.isLeftBuffId == isLeft then
        self.selectBuffId = nil
        self.isLeftBuffId = nil
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroTip)
    end
end

local function RefreshLeftArmy(self)
    self.hasArmy = false
    local num = 0
    local list = self.ctrl:GetCurSoldierList()
    if list~=nil then
        local armyDatas = {}
        for k,v in pairs(list) do
            if v>0 then
                num = num + v
                armyDatas[k] = v
            end
        end
        PveActorMgr:GetInstance():SetArmys(armyDatas)
    end
    self.leftNum = num
    if num > 0 then
        self.hasArmy = true
    end
    local pPower, pHp = PveActorMgr:GetInstance():GetEmBattleTotalPowerAndHp(true)
    self.leftPower = pPower
    self.left_power_text:TweenToNum(math.floor(pPower), PowerTweenDuration)
end

local function RefreshRightArmy(self)
    local num = 0

    local list = PveActorMgr:GetInstance():GetEmArmyList()
    if list ~= nil and table.count(list) > 0 then
        table.walk(list,function (k, v)
            num = num + (v.soldierNum or 0)
        end)
    end
    self.rightNum = num
    local ePower, pHp = PveActorMgr:GetInstance():GetEmBattleTotalPowerAndHp(false)
    self.rightPower  = ePower
    self.right_power_text:TweenToNum(math.floor(ePower), PowerTweenDuration)
end



local function RefreshPlayBackLeftArmy(self)
    local num = 0
    local army = PveActorMgr:GetInstance():GetArmys()
    table.walk(army,function (k, v)
        if v>0 then
            num = num + v
        end
    end)
    self.leftNum = num
    local pPower, pHp = PveActorMgr:GetInstance():GetEmBattleTotalPowerAndHp(true)
    self.leftPower  = pPower
    self.left_power_text:TweenToNum(math.floor(pPower), PowerTweenDuration)
end

local function RefreshPlayBackRightArmy(self)
    local num = 0
    local list = PveActorMgr:GetInstance():GetEmArmyList()
    if list ~= nil and table.count(list) > 0 then
        table.walk(list,function (k, v)
            num = num + (v.soldierNum or 0)
        end)
    end
    self.rightNum = num
    local ePower, pHp = PveActorMgr:GetInstance():GetEmBattleTotalPowerAndHp(false)
    self.rightPower  = ePower
    self.right_power_text:TweenToNum(math.floor(ePower), PowerTweenDuration)
end

local function RefreshArenaRightArmy(self)
    local entranceType = DataCenter.BattleLevel:GetEntranceType()
    if entranceType == PveEntrance.ArenaBattle then
        self:RefreshRightArmy()
    end
end

local function RefreshPveBattleScene(self)
    local heroUuids = {}

    -- remove
    for i = #self.ctrl.curHeroes, 1, -1 do
        local heroUuid = self.ctrl.curHeroes[i]
        local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
        if heroData then
            table.insert(heroUuids, 1, heroUuid)
        end
        self.ctrl:OnDeleteHeroByIndex(i)
        PveActorMgr:GetInstance():RemoveModelObj(Const.CampType.Player, i)
    end
    -- add
    for _, heroUuid in ipairs(heroUuids) do
        self.ctrl:SelectHeroByUuid(heroUuid)
        local data = self.ctrl:GetHeroDataByUuid(heroUuid)
        self:OnSelectHeroFinish(data, true)
    end

    self.ctrl.curHeroes = heroUuids
    self.hero_list:ResetHeroList()
    PveActorMgr:GetInstance():SetHeros(heroUuids)
end

local function ShowLineup(self)
    if self.isShowLineup then
        return
    end
    self.isShowLineup = true

    local heroes = {}
    local entranceType = DataCenter.BattleLevel:GetEntranceType()
    if entranceType == PveEntrance.MineCave then
        self:RefreshLeftArmy()
    else
        heroes = DataCenter.BattleLevel:GetHeroSelectHistory()
        local hireHeroData = DataCenter.HeroDataManager:GetHeroByUuid(HireHeroUuid)
        if hireHeroData then
            self.ctrl:SelectHeroByUuid(HireHeroUuid)
            local data = self.ctrl:GetHeroDataByUuid(HireHeroUuid)
            if data.index > 0 then
                self:OnSelectHeroFinish(data, true)
            end
        end
        if not table.IsNullOrEmpty(heroes) then
            for _, uuid in ipairs(heroes) do
                self.ctrl:SelectHeroByUuid(uuid)
                local data = self.ctrl:GetHeroDataByUuid(uuid)
                if data.index > 0 then
                    self:OnSelectHeroFinish(data, true)
                end
            end
        else
            self:RefreshLeftArmy()
        end
    end

    if entranceType == PveEntrance.Story then
        if DataCenter.StoryManager.autoNext then
            self:OnStartClick()
        end
    end
end

local function Start(self)
    local heroes = PveActorMgr:GetInstance():GetHeros()
    self.hero_list:SetActive(false)
    self.hero_btn:SetActive(false)
    self.start_btn:SetActive(false)
    self.home_btn:SetActive(true)
    self.head_list:SetActive(true)
    self.speed_go:SetActive(true)
    for i = 1, HeadCount do
        local found = false
        for _, v in pairs(heroes) do
            if i == v.index then
                local heroData = DataCenter.HeroDataManager:GetHeroByUuid(v.uuid)
                self.heads[i]:SetHeroId(heroData.heroId)
                found = true
                break
            end
        end
        self.heads[i]:SetActive(found)
    end

    local msgHeroes = {}
    for _, v in pairs(heroes) do
        if v.uuid > 0 then
            table.insert(msgHeroes, v)
        end
    end
    local entranceType = DataCenter.BattleLevel:GetEntranceType()
    if entranceType == PveEntrance.Test then
        local formations = PveActorMgr:GetInstance():GetArmys()
        SFSNetwork.SendMessage(MsgDefines.TestPveLevel, self.levelParam.levelId, msgHeroes, formations)
    elseif entranceType == PveEntrance.Story then
        local formations = PveActorMgr:GetInstance():GetArmys()
        DataCenter.StoryManager:SendPveBattle(self.levelParam.storyLevel, msgHeroes, formations)
    elseif entranceType == PveEntrance.DetectEventPve then
        local formations = PveActorMgr:GetInstance():GetArmys()
        DataCenter.RadarCenterDataManager:StartDetectEventPve(self.levelParam.uuid, msgHeroes, formations)
    elseif entranceType == PveEntrance.LandBlock then
        local formations = PveActorMgr:GetInstance():GetArmys()
        DataCenter.LandManager:SendStartPve(self.levelParam.blockId, self.levelParam.levelId, msgHeroes, formations)
    elseif entranceType == PveEntrance.MineCave then
        self.skip_btn:SetActive(true)
        PveActorMgr:GetInstance():SendCaveBattleCmd()
    elseif entranceType == PveEntrance.ArenaBattle then
        self.skip_btn:SetActive(true)
        PveActorMgr:GetInstance():SendArenaBattle()
    elseif entranceType == PveEntrance.SiegeBoss then
        DataCenter.CitySiegeManager:SendFinishZombie(self.levelParam.zombieId, msgHeroes, 0)
    else
        PveActorMgr:GetInstance():SendBattleCmd(101001)
    end
    -- 额
end

local function Update(self)
    if not self.active then
        return
    end
    local indexDict = {}
    local objs = PveActorMgr:GetInstance():GetAllHeroObjects()
    for _, obj in ipairs(objs) do
        local info = obj.info
        local isSelf = (info:GetCampType() == Const.CampType.Player)
        
        local hpIndex = info:GetStandIndex()
        if not isSelf then
            hpIndex = hpIndex + 5
        end
        indexDict[hpIndex] = true
        
        local hp = self.hps[hpIndex]
        hp:SetSelf(isSelf)
        hp:SetHp(info:GetCurBlood(), info:GetMaxBlood())
        
        local pos = DataCenter.BattleLevel.pveCamera:WorldToScreenPoint(obj:GetPosition())
        pos.y = pos.y + 100
        hp.transform.position = pos
    end
    for i = 1, HpCount do
        if not indexDict[i] then
            self.hps[i]:SetActive(false)
        end
    end
end

local function OnSpeedClick(self, speed)
    if speed == Speed1 then
        speed = self.speed2Open and Speed2 or Speed1
    elseif speed == Speed2 then
        speed = self.speed4Open and Speed4 or Speed1
    elseif speed == Speed4 then
        speed = Speed1
    end
    Setting:SetPrivateInt(SettingKeys.PVE_SPEED_OFFSET, speed)
    self:RefreshSpeed()
end

local function OnSkipClick(self)
    PveActorMgr:GetInstance():Skip()
end

local function OnHomeClick(self)
    local entranceType = DataCenter.BattleLevel:GetEntranceType()
    if entranceType == PveEntrance.ArenaSetting then
        local curHeroCount = self.ctrl:GetCurHeroNum()
        local maxHeroCount = self.ctrl:GetMaxHeroNum()
        -- 检查空位
        PveUtil.CheckHeroSlotEmpty(curHeroCount, maxHeroCount, function()
            -- 检查更高品质
            PveUtil.CheckHeroesRarity(self.ctrl.curHeroes, function()
                -- 检查突破
                PveUtil.CheckHeroesBreak(self.ctrl.curHeroes, function()
                    -- 检查满级
                    PveUtil.CheckHeroesMaxed(self.ctrl.curHeroes, function()
                        -- 保存
                        if entranceType == PveEntrance.ArenaSetting then
                            if not PveActorMgr:GetInstance():SendArenaSetDefenseArmy() then
                                UIUtil.ShowTipsId(372259)
                            else
                                UIUtil.ShowTipsId(120094)
                                DataCenter.BattleLevel:Exit()
                            end
                        else
                            DataCenter.BattleLevel:Exit()
                        end
                    end)
                end)
            end)
        end)
        return
    end

    DataCenter.BattleLevel:Exit()
end

local function OnKeyEscape(self)
    --self:OnHomeClick()
end

local function OnStartClick(self)
    -- 检查英雄
    local curHeroCount = self.ctrl:GetCurHeroNum()
    if curHeroCount == 0 then
        UIUtil.ShowTipsId(121007)
        return
    end

    -- 检查是否上兵
    if not self.hasArmy then
        UIUtil.ShowMessage(Localization:GetString("400008"), 2, "110003", "110106", function()
            self:OnHomeClick()
            GoToUtil.GotoOpenView(UIWindowNames.UIHospital, { anim = false, UIMainAnim = UIMainAnimType.AllHide, hideTop = true }, CurScene.PVEScene)
        end)
        return
    end

    local maxHeroCount = self.ctrl:GetMaxHeroNum()
    -- 检查空位
    PveUtil.CheckHeroSlotEmpty(curHeroCount, maxHeroCount, function()
        -- 检查更高品质
        PveUtil.CheckHeroesRarity(self.ctrl.curHeroes, function()
            -- 检查突破
            PveUtil.CheckHeroesBreak(self.ctrl.curHeroes, function()
                -- 检查满级
                PveUtil.CheckHeroesMaxed(self.ctrl.curHeroes, function()
                    -- 开始
                    self:Start()
                end)
            end)
        end)
    end)
end

local function OnHeroBtnClick(self)
    if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIHeroList) then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroList, { anim = false })
        if DataCenter.HeroDataManager:GetHeroRedNum() > 0 then
            DataCenter.HeroDataManager:MarkHeroRedPoint()
        end
    end
end

local function OnSaveClick(self)
    local curHeroCount = self.ctrl:GetCurHeroNum()
    local maxHeroCount = self.ctrl:GetMaxHeroNum()
    -- 检查空位
    PveUtil.CheckHeroSlotEmpty(curHeroCount, maxHeroCount, function()
        -- 检查更高品质
        PveUtil.CheckHeroesRarity(self.ctrl.curHeroes, function()
            -- 检查突破
            PveUtil.CheckHeroesBreak(self.ctrl.curHeroes, function()
                -- 检查满级
                PveUtil.CheckHeroesMaxed(self.ctrl.curHeroes, function()
                    -- 保存
                    local entranceType = DataCenter.BattleLevel:GetEntranceType()
                    if entranceType == PveEntrance.ArenaSetting then
                        if not PveActorMgr:GetInstance():SendArenaSetDefenseArmy() then
                            UIUtil.ShowTipsId(372259)
                        else
                            DataCenter.BattleLevel:Exit()
                        end
                    else
                        DataCenter.BattleLevel:Exit()
                    end
                end)
            end)
        end)
    end)
end

local function OnLineupInitEnd(self)
    self:ShowLineup()
end

local function OnSelectHeroFinish(self, data, isAdd, pos)
    local index = data.index
    local heroId = data.heroId
    local heroUuid = data.heroUuid
    local heroLv = data.level
    local heroQuality = data.qualityIndex
    local rarity = data.rarity
    local rankId = data.rankId
    self:RefreshLeftArmy()
    local power = PveActorMgr:GetInstance():GetInitPowerByHeroUuid(heroUuid)
    power = Mathf.Ceil(power)
    if isAdd then
        PveActorMgr:GetInstance():LoadPlayer(index, heroId, power,heroLv,heroQuality,rarity,heroUuid,rankId,self.ctrl.curHeroes)
    else
        PveActorMgr:GetInstance():RemoveModelObj(Const.CampType.Player, index, heroId,self.ctrl.curHeroes)
    end

    PveActorMgr:GetInstance():RefreshHeroSigns()
end

local function OnPveHeroCancel(self,heroUuid)
    if heroUuid then
        self.hero_list:OnPveHeroCancel(heroUuid)
    end
end

local function OnTotalHpChanged(self, isAtk)
    if not PveActorMgr:GetInstance().isHeroesBattleInit then
        return
    end
    if isAtk then
        local maxBlood = PveActorMgr:GetInstance():GetAtkTotalMaxHp()
        local curBlood = PveActorMgr:GetInstance():GetAtkTotalCurHp()
        local percent = math.min((curBlood / math.max(1, maxBlood)), 1)
        local curPower = self.leftPower * percent
        self.left_power_text:TweenToNum(math.floor(curPower), PowerTweenDuration)
    else
        local maxBlood = PveActorMgr:GetInstance():GetDefTotalMaxHp()
        local curBlood = PveActorMgr:GetInstance():GetDefTotalCurHp()
        local percent = math.min((curBlood/math.max(1,maxBlood)),1)
        local curPower = self.rightPower*percent
        self.right_power_text:TweenToNum(math.floor(curPower), PowerTweenDuration)
    end
end

local function OnPveMineCaveInfoUpdate(self)
    self.home_btn:SetActive(false)
    if self.levelParam~=nil and self.levelParam.pveEntrance == PveEntrance.BattlePlayBack then
    else
        self:RefreshRightArmy()
        self.right_power_text:SetActive(true)
        self.right_go:SetActive(true)
    end
end

local function OnPveHeroHpUpdate(self, info)
    for i = 1, HeadCount do
        if self.heads[i].heroId == info:GetHeroId() then
            self.heads[i]:SetHp(info:GetCurBlood(), info:GetMaxBlood())
        end
    end
end

local function OnPveHeroAngerUpdate(self, info)
    for i = 1, HeadCount do
        if self.heads[i].heroId == info.heroId then
            self.heads[i]:AddAnger(info.addAnger)
        end
    end
end

local function OnPveHeroUseSkill(self, info)
    for i = 1, HeadCount do
        if self.heads[i].heroId == info.heroId then
            self.heads[i]:UseSkill(info.skillId)
        end
    end
    
    self.useSkillIndex = self.useSkillIndex + 1
    local index = self.useSkillIndex
    self.useSkillReqs[index] = self:GameObjectInstantiateAsync(UIAssets.UIPVEUseSkillItem, function(req)
        local go = req.gameObject
        go.name = tostring(index)
        local tf = go.transform
        tf:SetParent(self.center_go.transform)
        local item = self.center_go:AddComponent(UIPVEUseSkillItem, tostring(index))
        item:SetData(info)
        self.useSkillItems[index] = item
        TimerManager:GetInstance():DelayInvoke(function()
            if self.active and self.useSkillItems[index] then
                self.useSkillItems[index] = nil
                self.center_go:RemoveComponent(tostring(index), UIPVEUseSkillItem)
                req:Destroy()
            end
        end, 4)
    end)
end

local function OnCloseUI(self, windowName)
    if windowName == UIWindowNames.UIHeroList or
       windowName == UIWindowNames.UIHeroRecruitReward or
       windowName == UIWindowNames.UIHeroRecruitRewardNew then
        self:RefreshPveBattleScene()
        self:RefreshHeroBtn()
    end
end

UIPVESceneView.OnCreate = OnCreate
UIPVESceneView.OnDestroy = OnDestroy
UIPVESceneView.ComponentDefine = ComponentDefine
UIPVESceneView.ComponentDestroy = ComponentDestroy
UIPVESceneView.DataDefine = DataDefine
UIPVESceneView.DataDestroy = DataDestroy
UIPVESceneView.OnEnable = OnEnable
UIPVESceneView.OnDisable = OnDisable
UIPVESceneView.OnAddListener = OnAddListener
UIPVESceneView.OnRemoveListener = OnRemoveListener

UIPVESceneView.ReInit = ReInit
UIPVESceneView.GetHeroObjByHeroId = GetHeroObjByHeroId
UIPVESceneView.InitSpeed = InitSpeed
UIPVESceneView.RefreshSpeed = RefreshSpeed
UIPVESceneView.RefreshSpeedRed = RefreshSpeedRed
UIPVESceneView.RefreshHeroBtn = RefreshHeroBtn
UIPVESceneView.RefreshPlayerHead = RefreshPlayerHead
UIPVESceneView.ShowLeftBuff = ShowLeftBuff
UIPVESceneView.ShowRightBuff = ShowRightBuff
UIPVESceneView.ClearLeftBuff = ClearLeftBuff
UIPVESceneView.ClearRightBuff = ClearRightBuff
UIPVESceneView.SetRightBuffData = SetRightBuffData
UIPVESceneView.SetLeftBuffData = SetLeftBuffData
UIPVESceneView.SetSelectBuff = SetSelectBuff
UIPVESceneView.CheckRemoveTipsByBuffId = CheckRemoveTipsByBuffId
UIPVESceneView.RefreshLeftArmy = RefreshLeftArmy
UIPVESceneView.RefreshRightArmy = RefreshRightArmy
UIPVESceneView.RefreshPlayBackLeftArmy = RefreshPlayBackLeftArmy
UIPVESceneView.RefreshPlayBackRightArmy = RefreshPlayBackRightArmy
UIPVESceneView.RefreshArenaRightArmy = RefreshArenaRightArmy
UIPVESceneView.RefreshPveBattleScene = RefreshPveBattleScene
UIPVESceneView.ShowLineup = ShowLineup
UIPVESceneView.Start = Start
UIPVESceneView.Update = Update

UIPVESceneView.OnSpeedClick = OnSpeedClick
UIPVESceneView.OnSkipClick = OnSkipClick
UIPVESceneView.OnHomeClick = OnHomeClick
UIPVESceneView.OnKeyEscape = OnKeyEscape
UIPVESceneView.OnStartClick = OnStartClick
UIPVESceneView.OnHeroBtnClick = OnHeroBtnClick
UIPVESceneView.OnSaveClick = OnSaveClick
UIPVESceneView.OnLineupInitEnd = OnLineupInitEnd
UIPVESceneView.OnSelectHeroFinish = OnSelectHeroFinish
UIPVESceneView.OnPveHeroCancel = OnPveHeroCancel
UIPVESceneView.OnTotalHpChanged = OnTotalHpChanged
UIPVESceneView.OnPveMineCaveInfoUpdate = OnPveMineCaveInfoUpdate
UIPVESceneView.OnPveHeroHpUpdate = OnPveHeroHpUpdate
UIPVESceneView.OnPveHeroAngerUpdate = OnPveHeroAngerUpdate
UIPVESceneView.OnPveHeroUseSkill = OnPveHeroUseSkill
UIPVESceneView.OnCloseUI = OnCloseUI

return UIPVESceneView


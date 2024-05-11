---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2021/8/13 16:46
---
local WorldMarchTileUIManager = BaseClass("WorldMarchTileUIManager", Singleton)
local WorldMarchTileUI = require "Scene.WorldMarchTileUI.WorldMarchTileUI"
local WorldMarchEmotionCommand = require "Scene.WorldMarchEmotion.WorldMarchEmotionCommand"
local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local function __init(self)
    self.marchTileUI = nil
    self.isOnCreate = false
    self:AddListener()
end

local function __delete(self)
    self:RemoveListener()
    self.marchTileUI = nil
end
local function AddListener(self)
    EventManager:GetInstance():AddListener(EventId.ArmyFormatUpdate, self.OnUpdateMarchSignal)
    EventManager:GetInstance():AddListener(EventId.UpdateMarchItem, self.OnUpdateMarchSignal)
    EventManager:GetInstance():AddListener(EventId.WorldTroopGameObjectCreateFinish, self.OnWorldTroopCreate)
end

local function RemoveListener(self)
    EventManager:GetInstance():RemoveListener(EventId.ArmyFormatUpdate, self.OnUpdateMarchSignal)
    EventManager:GetInstance():RemoveListener(EventId.UpdateMarchItem, self.OnUpdateMarchSignal)
    EventManager:GetInstance():RemoveListener(EventId.WorldTroopGameObjectCreateFinish, self.OnWorldTroopCreate)
end

local function RefreshTroop(self,marchUuid)
    local troop = WorldTroopManager:GetInstance():GetTroop(marchUuid)
    if troop==nil then
        return
    end
    local worldMarch = DataCenter.WorldMarchDataManager:GetMarch(marchUuid)
    if worldMarch==nil then
        return
    end
    if worldMarch.ownerUid == LuaEntry.Player.uid and LuaEntry.Player.serverType == ServerType.EDEN_SERVER and worldMarch:GetMarchType() == NewMarchType.NORMAL then
        local showGuide = DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.EnterSeasonOpenIntro,tostring(SeasonIntroType.Morality))
    end
    if worldMarch:GetMarchType() ~= NewMarchType.RESOURCE_HELP then
        TroopNameLabelManager:GetInstance():RemoveOneEffect(marchUuid)
        if troop:IsBattle() then
            TroopHeadUIManager:GetInstance():ShowSelectCircle(marchUuid)
        else
            TroopHeadUIManager:GetInstance():ShowHeadUI(marchUuid,false)
        end
        WorldTroopAttackBuildIconManager:GetInstance():RemoveOneEffect(marchUuid)
    end
    if self.marchTileUI ==nil and self.isOnCreate ==false then
        local request = ResourceManager:InstantiateAsync(UIAssets.WorldMarchTileUI)
        self.isOnCreate = true
        request:completed('+', function()
            self.isOnCreate = false
            if request.isError then
                return
            end
            troop = WorldTroopManager:GetInstance():GetTroop(marchUuid)
            if troop==nil then
                request:Destroy()
                return
            end
            local transform = troop:GetTransform()
            if transform==nil then
                request:Destroy()
                return
            end
            request.gameObject:SetActive(true)
            request.gameObject.transform:SetParent(transform)
            request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            request.gameObject.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
            local tileUI = WorldMarchTileUI.New()
            tileUI:OnCreate(request)
            self.marchTileUI = tileUI
            self.marchTileUI:RefreshTroop(marchUuid)
            SoundUtil.PlayEffect(SoundAssets.Music_Effect_Click_Army1)
            worldMarch = DataCenter.WorldMarchDataManager:GetMarch(marchUuid)
            if worldMarch ~= nil and (worldMarch:GetMarchType() == NewMarchType.GOLLOES_EXPLORE or worldMarch:GetMarchType() == NewMarchType.GOLLOES_TRADE) then
                request.gameObject:SetActive(false)--咕噜探索隐藏弧形按钮栏
            end
        end)
    else
        if self.marchTileUI~=nil then
            local oldMarchUuid = self.marchTileUI:GetMarchUuid()
            if oldMarchUuid~=nil and oldMarchUuid~= marchUuid then
                local oldTroop = WorldTroopManager:GetInstance():GetTroop(oldMarchUuid)
                if oldTroop~=nil then
                    if oldTroop:IsBattle()==true then
                        TroopHeadUIManager:GetInstance():HideSelectCircle(oldMarchUuid)
                    elseif oldTroop:IsBattle()==false then
                        TroopHeadUIManager:GetInstance():HideHeadUI(oldMarchUuid)
                    end
                    TroopNameLabelManager:GetInstance():CheckShowEffect(oldMarchUuid)
                    WorldTroopAttackBuildIconManager:GetInstance():CheckShowEffect(oldMarchUuid)
                    troop = WorldTroopManager:GetInstance():GetTroop(marchUuid)
                    local request = self.marchTileUI.request
                    if request==nil then
                        return
                    end
                    if troop==nil then
                        self.marchTileUI:ComponentDestroy()
                        if request~=nil then
                            request:Destroy()
                        end
                        self.marchTileUI = nil
                        return
                    end
                    local transform = troop:GetTransform()
                    if transform==nil then
                        self.marchTileUI:ComponentDestroy()
                        if request~=nil then
                            request:Destroy()
                        end
                        self.marchTileUI = nil
                        return
                    end
                    request.gameObject:SetActive(true)
                    request.gameObject.transform:SetParent(transform)
                    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                    request.gameObject.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
                end
            end
            self.marchTileUI:RefreshTroop(marchUuid)
        end
    end
    EventManager:GetInstance():Broadcast(EventId.ShowFormationSelect,marchUuid)
end

local function ShowTroop(self,marchUuid)
    self:RefreshTroop(marchUuid)
end

local function RemoveTroop(self)
    if self.marchTileUI~=nil then
        if CS.WorldScene.selectMarchUuid == 0 then
            CS.WorldScene.selectMarchUuid = 0
            CS.SceneManager.World.marchUuid = 0
            DataCenter.WorldMarchDataManager:TrackMarch(0)
        end
        
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Close)
        EventManager:GetInstance():Broadcast(EventId.HideFormationSelect,self.marchTileUI.marchUuid)
        local troop = WorldTroopManager:GetInstance():GetTroop(self.marchTileUI.marchUuid)
        if troop~=nil and troop:IsBattle()==true then
            TroopHeadUIManager:GetInstance():HideSelectCircle(self.marchTileUI.marchUuid)
        elseif troop~=nil and troop:IsBattle()==false then
            TroopHeadUIManager:GetInstance():HideHeadUI(self.marchTileUI.marchUuid)
        end
        TroopNameLabelManager:GetInstance():CheckShowEffect(self.marchTileUI.marchUuid)
        WorldTroopAttackBuildIconManager:GetInstance():CheckShowEffect(self.marchTileUI.marchUuid)
        local request = self.marchTileUI.request
        self.marchTileUI:ComponentDestroy()
        if request~=nil then
            request:Destroy()
        end
        self.marchTileUI = nil
        
    end
end

local function RemoveTroopByUuid(self,marchUuid)
    if self.marchTileUI~=nil then
        if self.marchTileUI.marchUuid == marchUuid then
            self:RemoveTroop()
        end
    end
end

local function OnUpdateMarchSignal()
    WorldMarchTileUIManager:GetInstance():UpdateMarch()
end

local function UpdateMarch(self)
    if self.marchTileUI~=nil then
        self.marchTileUI:OnMarchUpdate()
    end
end

local function OnBtnClick(self,type,marchUuid)
    local info = DataCenter.WorldMarchDataManager:GetMarch(marchUuid)
    if info~=nil then
        if info:GetIsBroken() then
            UIUtil.ShowTipsId(120004) 
        else
            if type == WorldMarchTileBtnType.March_Attack or type == WorldMarchTileBtnType.March_Scout then
                if  SeasonUtil.IsInSeasonDesertMode() and CrossServerUtil:GetIsCrossServer() then
                    local state,dialog = CrossServerUtil.CheckCanUseInDeclareWarTarget(MarchTargetType.ATTACK_ARMY)
                    if state ==false then
                        UIUtil.ShowTipsId(dialog)
                        return
                    end
                end
                if CrossServerUtil:GetIsCrossServer() then
                    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.WORM_HOLE_CROSS)
                    if buildData==nil then
                        UIUtil.ShowTipsId(104279)
                        TimerManager:GetInstance():DelayInvoke(function()
                            EventManager:GetInstance():Broadcast(EventId.ShowCreateCrossWormHole)
                        end, 1.5)
                        return
                    end
                end
            end
            if type == WorldMarchTileBtnType.March_Attack then
                
                local army = WorldTroopManager:GetInstance():GetTroop(marchUuid)
                if army~=nil then
                    local pointId = SceneUtils.WorldToTileIndex(army:GetPosition())
                    MarchUtil.OnClickStartMarch(MarchTargetType.ATTACK_ARMY, pointId,marchUuid)
                end

            elseif type == WorldMarchTileBtnType.March_ViewTroop then
                if info.ownerUid == LuaEntry.Player.uid then
                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationTableNew,info.ownerFormationUuid,-1,-1,0,-1,1,0,nil,0,nil,nil,1)
                else
                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIOtherPlayerInfo,info.ownerUid);
                end
                

            elseif type == WorldMarchTileBtnType.March_Rally then

            elseif type == WorldMarchTileBtnType.March_Operate then
                local worldMarch = DataCenter.WorldMarchDataManager:GetMarch(marchUuid)
                if worldMarch~=nil then
                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDesertOperate, { anim = true, UIMainAnim = UIMainAnimType.AllHide },worldMarch.ownerFormationUuid)
                end
            
            elseif type == WorldMarchTileBtnType.March_Callback then
                
                local hasSecret = false
                local showWarning = false
                local worldMarch = DataCenter.WorldMarchDataManager:GetMarch(marchUuid)
                if worldMarch~=nil then
                    if worldMarch.secretKey~=nil and worldMarch.secretKey>0 then
                        hasSecret = true
                    end
                    local oriSpeed = worldMarch.oriSpeed
                    local newSpeed = worldMarch.speed
                    if oriSpeed~=nil and newSpeed~=nil and oriSpeed>0 and newSpeed>0 and oriSpeed~= newSpeed then
                        if worldMarch:GetMarchStatus() == MarchStatus.CHASING or worldMarch:GetMarchStatus() == MarchStatus.MOVING or worldMarch:GetMarchStatus() == MarchStatus.BACK_HOME then
                            showWarning = true
                        end
                    end
                end
                if hasSecret ==false then
                    if showWarning ==true then
                        UIUtil.ShowMessage(Localization:GetString("320823"),2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
                            MarchUtil.OnBackHome(marchUuid)
                        end)
                    else
                        MarchUtil.OnBackHome(marchUuid)
                    end
                else
                    MarchUtil.OnSendSecretKeyToCamp(marchUuid)
                end
            elseif type == WorldMarchTileBtnType.March_Stop then
                --local army = CS.SceneManager.World.TroopManager:GetTroop(marchUuid)
                --if army~=nil then
                --    local pointId = SceneUtils.WorldToTileIndex(army:GetPosition())
                --    MarchUtil.OnStation(marchUuid,pointId)
                --end
            elseif type == WorldMarchTileBtnType.March_Scout then
                local army = WorldTroopManager:GetInstance():GetTroop(marchUuid)
                if not army then
                    return
                end
                local pointId = SceneUtils.WorldToTileIndex(army:GetPosition())
                
                -- 判断是否弹框
                local needConfirm,status, title , content,needBreakProtect = DataCenter.StatusManager:ShowTipForWarFever()
                if needBreakProtect ==  true then
                    UIUtil.ShowMessage(Localization:GetString("120016"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL,function()
                        UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationSelectListNew,{ anim = true, UIMainAnim = UIMainAnimType.AllHide }, 2, MarchTargetType.SCOUT_TROOP, pointId, marchUuid)
                    end, function()
                    end)
                else
                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationSelectListNew,{ anim = true, UIMainAnim = UIMainAnimType.AllHide }, 2, MarchTargetType.SCOUT_TROOP, pointId, marchUuid)
                end

            elseif type == WorldMarchTileBtnType.March_Speed then
                local canUse = false
                if info:GetMarchStatus() == MarchStatus.CHASING or info:GetMarchStatus() == MarchStatus.MOVING or info:GetMarchStatus() == MarchStatus.BACK_HOME then
                    canUse = true
                end
                if canUse ==false then
                    UIUtil.ShowTipsId(320824)
                else
                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIMarchAddSpeed,info.uuid)
                end
            elseif type == WorldMarchTileBtnType.March_Emotion then
                local command = WorldMarchEmotionCommand.New()
                command.uuid = marchUuid
                command.type = WorldMarchEmotionCommandType.ShowBtns
                command.targetType = WorldMarchEmotionTargetType.March
                WorldMarchEmotionManager:GetInstance():Command(command)
            end
        end
        
    end
    
    self:RemoveTroop()
end

local function OnWorldTroopCreate(data)
    local marchUuid = tonumber(data)
    local marchInfo = DataCenter.WorldMarchDataManager:GetMarch(marchUuid)
    if marchInfo ~= nil and CS.SceneManager.World.marchUuid == marchUuid then
        WorldMarchTileUIManager:GetInstance():ShowTroop(marchUuid)
    end
    if marchInfo ~= nil and marchInfo.isCameraFollow then
        DataCenter.WorldMarchDataManager:TrackMarch(marchInfo.uuid)
        WorldMarchTileUIManager:GetInstance():ShowTroop(marchUuid)
    end
end

WorldMarchTileUIManager.__init = __init
WorldMarchTileUIManager.__delete = __delete
WorldMarchTileUIManager.ShowTroop =ShowTroop
WorldMarchTileUIManager.RemoveTroop = RemoveTroop
WorldMarchTileUIManager.UpdateMarch =UpdateMarch
WorldMarchTileUIManager.OnUpdateMarchSignal =OnUpdateMarchSignal
WorldMarchTileUIManager.AddListener =AddListener
WorldMarchTileUIManager.RemoveListener =RemoveListener
WorldMarchTileUIManager.OnBtnClick = OnBtnClick
WorldMarchTileUIManager.RemoveTroopByUuid = RemoveTroopByUuid
WorldMarchTileUIManager.RefreshTroop = RefreshTroop
WorldMarchTileUIManager.OnWorldTroopCreate = OnWorldTroopCreate
return WorldMarchTileUIManager
---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/8/8 16:29
---
local UICheckServerView = BaseClass("UICheckServerView",UIBaseView)
local ServerConditionItem = require "UI.UICheckServer.Component.ServerConditionItem"
local ServerConditionTip = require "UI.UICheckServer.Component.ServerConditionTip"
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local txt_title_path ="UICommonMidPopUpTitle/bg_mid/titleText"
local close_btn_path = "UICommonMidPopUpTitle/bg_mid/CloseBtn"
local return_btn_path = "UICommonMidPopUpTitle/panel"
local item1_path = "ImgBg/Content/item1"
local item2_path = "ImgBg/Content/item2"
local item3_path = "ImgBg/Content/item3"
local item4_path = "ImgBg/Content/item4"
local item5_path = "ImgBg/Content/item5"
local item6_path = "ImgBg/Content/item6"
local goto_btn_path = "ImgBg/layout/checkBtn"
local goto_txt_path = "ImgBg/layout/checkBtn/btnCheckTxt"
local move_btn_path = "ImgBg/layout/moveBtn"
local move_txt_path = "ImgBg/layout/moveBtn/btnMoveText"
local txt_condition_path = "ImgBg/TxtCondition"
local condition_detail_path = "ImgBg/TxtCondition/ButtonDetail"
local tips_obj_path = "ImgBg/tips"
--创建
function UICheckServerView:OnCreate()
    base.OnCreate(self)
    local serverId,canMigrate = self:GetUserData()
    self.serverId = tonumber(serverId)
    self.canMigrate = canMigrate or false
    if self.canMigrate then
        SFSNetwork.SendMessage(MsgDefines.GetMigrateItem,self.serverId)
    end
    self:ComponentDefine()
    self:DataDefine()
    self.data = nil
    self.endTime = 0
    self.timer_action = function(temp)
        self:UpdateTime()
    end
    self.isColdDown = false
end

-- 销毁
function UICheckServerView:OnDestroy()
    self:ComponentDestroy()
    self:DeleteTimer()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UICheckServerView:ComponentDefine()
    self.txt_title = self:AddComponent(UIText, txt_title_path)
    self.txt_title:SetLocalText(104272)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.return_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.goto_btn = self:AddComponent(UIButton, goto_btn_path)
    self.goto_txt = self:AddComponent(UIText, goto_txt_path)
    self.goto_txt:SetLocalText(110036)
    self.goto_btn:SetOnClick(function()
        self:OnGotoClick()
    end)
    
    self.item1 = self:AddComponent(ServerConditionItem,item1_path)
    self.item2 = self:AddComponent(ServerConditionItem,item2_path)
    self.item3 = self:AddComponent(ServerConditionItem,item3_path)
    self.item4 = self:AddComponent(ServerConditionItem,item4_path)
    self.item5 = self:AddComponent(ServerConditionItem,item5_path)
    self.item6 = self:AddComponent(ServerConditionItem,item6_path)
    self.move_btn = self:AddComponent(UIButton, move_btn_path)
    self.move_txt = self:AddComponent(UIText, move_txt_path)
    self.move_txt:SetLocalText(250329)
    self.move_btn:SetOnClick(function()
        self:OnMoveBtnClick()
    end)
    self.txt_condition = self:AddComponent(UIText, txt_condition_path)
    self.condition_detail = self:AddComponent(UIButton, condition_detail_path)
    self.condition_detail:SetOnClick(function()
        self:OnMoveDetailClick()
    end)
    self.tips_obj = self:AddComponent(ServerConditionTip,tips_obj_path)
    self.tips_obj:SetActive(false)
    if self.canMigrate then
        self.move_btn:SetActive(true)
        self.item5:SetActive(true)
        self.item6:SetActive(true)
        self.item2:SetActive(false)
        self.txt_condition:SetActive(true)
        self.move_btn:SetActive(true)
    else
        self.item5:SetActive(false)
        self.item6:SetActive(false)
        self.item2:SetActive(false)
        self.txt_condition:SetActive(false)
        self.move_btn:SetActive(false)
    end
    
end

function UICheckServerView:ComponentDestroy()
end

function UICheckServerView:DataDefine()
    self.item1:InitData(MigrateShowItem.ServerName)
    self.item2:InitData(MigrateShowItem.ServerOpenTime)
    self.item3:InitData(MigrateShowItem.ServerSeason)
    self.item4:InitData(MigrateShowItem.ServerState)
    self.item5:InitData(MigrateShowItem.ServerPower)
    self.item6:InitData(MigrateShowItem.ServerPresident)
end

function UICheckServerView:DataDestroy()
    self.list = nil
end

function UICheckServerView:OnEnable()
    base.OnEnable(self)
    self:RefreshData()
end

function UICheckServerView:OnDisable()
    base.OnDisable(self)
end


function UICheckServerView:OnGotoClick()
    local v2 = {}
    v2.x = math.floor(WorldTileCount/2)
    v2.y = math.floor(WorldTileCount/2)
    GoToUtil.GotoWorldPos(SceneUtils.TileToWorld(v2),CS.SceneManager.World.InitZoom,nil,nil,self.serverId)
    GoToUtil.CloseAllWindows()
end

function UICheckServerView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.GetMigrateServerDetail, self.RefreshMigrateData)
end

function UICheckServerView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.GetMigrateServerDetail, self.RefreshMigrateData)
end

function UICheckServerView:RefreshData(data)
    self.item1:SetData(Localization:GetString("208236",self.serverId),true)
    local season = DataCenter.AccountManager:GetSeasonNumByServerId(self.serverId)
    local des = Localization:GetString("250302",(season+1))
    self.item3:SetData(des,true)
    self.item4:SetData(Localization:GetString("250378"),true,RedColor)
end

function UICheckServerView:RefreshMigrateData(serverId)
    if self.serverId == serverId then
        local data = DataCenter.MigrateDataManager:OnGetServerDetailDataByServerId(self.serverId)
        self.item1:SetData(Localization:GetString("208236",self.serverId),true)
        self.data = data
        self.endTime = 0
        if data~=nil then
            local curTime = UITimeManager:GetInstance():GetServerTime()
            local deltaTime = curTime - data.targetOpenTime
            self.item2:SetData(UITimeManager:GetInstance():SecondToFmtStringForCountdownByDialog(deltaTime/1000),true)
            local des = Localization:GetString("250302",(data.season+1))
            self.item3:SetData(des,true)
            self.item4:SetData(Localization:GetString("250377"),true,BlueColor)
            local targetPower = data.targetPowerLimit
            local selfPower = data.maxPower
            if selfPower<=targetPower then
                self.item5:SetData(string.GetFormattedSeperatorNum(targetPower),false,BlueColor)
            else
                self.item5:SetData(string.GetFormattedSeperatorNum(targetPower),false,RedColor)
            end
            if data.kingName~=nil and data.kingName~="" then
                self.item6:SetData(data.kingName,true)
            else
                self.item6:SetData(Localization:GetString("100206"),true)
            end
            self.fitState = self.tips_obj:RefreshCondition(data)
            local applyData = DataCenter.MigrateDataManager:OnGetMigrateApplyDataByServerId(self.serverId)
            self.isColdDown = false
            if applyData~=nil then
                local applyState = applyData.state
                if applyState == MigrateApplyType.AGREE then
                    local overTime = LuaEntry.DataConfig:TryGetNum("aps_migrate_server", "k5")
                    local endTime = applyData.approveTime+(overTime*1000*60)
                    if endTime> curTime then
                        self.endTime = endTime
                        self:AddTimer()
                        self:UpdateTime()
                    end
                elseif applyState == MigrateApplyType.MIGRATE then
                    local endTime = data.lastMigrateServerTime+data.cd*1000
                    if endTime> curTime then
                        self.endTime = endTime
                        self.isColdDown = true
                        self:AddTimer()
                        self:UpdateTime()
                    end
                end
            else
                local endTime = data.lastMigrateServerTime+data.cd*1000
                if endTime> curTime then
                    self.endTime = endTime
                    self.isColdDown = true
                    self:AddTimer()
                    self:UpdateTime()
                end
            end
            if self.fitState and self.isColdDown ==false then
                if self.endTime<=0 then
                    self.txt_condition:SetText(Localization:GetString("250306",Localization:GetString("250308")))
                end
                
                CS.UIGray.SetGray(self.move_btn.transform, false, true)
            else
                if self.endTime<=0 then
                    self.txt_condition:SetText(Localization:GetString("250306",Localization:GetString("250307")))
                end
                CS.UIGray.SetGray(self.move_btn.transform, true, false)
            end
            
        else
            self.item1:SetData(Localization:GetString("208236",self.serverId),true)
            local season = DataCenter.AccountManager:GetSeasonNumByServerId(self.serverId)
            local des = Localization:GetString("250302",(season+1))
            self.item3:SetData(des,true)
            self.item4:SetData(Localization:GetString("250378"),true,RedColor)
            self.item5:SetActive(false)
            self.item6:SetActive(false)
            self.item2:SetActive(false)
            self.txt_condition:SetActive(false)
            self.move_btn:SetActive(false)
        end
    end
    
end

function UICheckServerView:OnMoveDetailClick()
    self.tips_obj:SetActive(true)
    self.tips_obj:OnSetPos(self.condition_detail.transform.position)
end

function UICheckServerView:HideTips()
    self.tips_obj:SetActive(false)
end

function UICheckServerView:OnMoveBtnClick()
    if self.fitState and self.data~=nil then
        if DataCenter.GovernmentManager:IsSelfPresident() then
            UIUtil.ShowMessage(Localization:GetString("309044"), 2, "309045", GameDialogDefine.CANCEL, function()
                UIManager:GetInstance():OpenWindow(UIWindowNames.UITransferKing, { anim = true })
            end)
            return
        end
        local isAllFree = DataCenter.ArmyFormationDataManager:IsAllFormationFree()
        if isAllFree == false then
            UIUtil.ShowTipsId(250317)
            return
        end
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local lastTime = self.data.lastMigrateServerTime
        local deltaTime = curTime -lastTime
        if deltaTime<(self.data.cd*1000) then
            UIUtil.ShowTipsId(100381)
            return
        end
        local str = nil
        local actData = nil
        local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(ActivityEnum.ActivityType.ActNoOne)
        if table.count(dataList) > 0 then
            actData = dataList[1]
        end
        if actData then
            if actData.startTime < curTime and curTime < actData.endTime  then
                if actData.normalStartTime<curTime and curTime<actData.normalEndTime then
                    if LuaEntry.Player:IsInAlliance() ==true then
                        str = Localization:GetString("250390")
                    end
                else
                    str = Localization:GetString("250403")
                    if LuaEntry.Player:IsInAlliance() ==true then
                        str = str.."\n"..Localization:GetString("250390")
                    end
                end
            end

        end
        if str~=nil then
            local needItemId = self.data.needItemId
            local needItemNum = self.data.needItemNum
            local serverId = self.data.serverId
            UIUtil.ShowMessage(str, 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIMigrateServer,needItemId,needItemNum,serverId)
            end)
        else
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIMigrateServer,self.data.needItemId,self.data.needItemNum,self.serverId)
        end
    end
end

function UICheckServerView:AddTimer()
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action , self, false,false,false)
    end
    self.timer:Start()
end

function UICheckServerView:DeleteTimer()
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

function UICheckServerView:UpdateTime()
    if self.endTime>0 then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local deltaTime = self.endTime - curTime
        if deltaTime > 0 then
            if self.isColdDown ==false then
                self.txt_condition:SetText(Localization:GetString("250381", UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)))
            else
                self.txt_condition:SetText(Localization:GetString("250323", UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)))
            end
        else
            self:DeleteTimer()
            self:RefreshMigrateData(self.serverId)
        end
    end
end

return UICheckServerView
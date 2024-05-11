---
--- 联盟个人情报拆出来的单独界面
--- Created by shimin.
--- DateTime: 2023/3/3 17:14
---
local UIAllianceWarPersonalListView = BaseClass("UIAllianceWarPersonalListView",UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIPersonalWarning = require "UI.UIAlliance.UIAllianceWarPersonalList.Component.UIPersonalWarning"

local txt_title_path ="UICommonFullTop/imgTitle/Common_img_title/titleText"
local close_btn_path = "UICommonFullTop/CloseBtn"
local scroll_view_path = "UICommonFullTop/Bg2/ScrollView"
local OneKeyIgnore_txt_path =  "UICommonFullTop/Bg2/BigBtnBlue/btnText"
local OneKeyIgnore_btn_path =  "UICommonFullTop/Bg2/BigBtnBlue"
local contentBg_path =  "UICommonFullTop/Bg2/ImageBg"
local contentTxt_path = "UICommonFullTop/Bg2/ImageBg/TxtContect"

--创建
function UIAllianceWarPersonalListView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
function UIAllianceWarPersonalListView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIAllianceWarPersonalListView:ComponentDefine()
    self.title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.contentBg =  self:AddComponent(UIBaseContainer, contentBg_path)
    self.contentTxt =  self:AddComponent(UITextMeshProUGUIEx, contentTxt_path)
    self.OneKeyIgnore_txt = self:AddComponent(UITextMeshProUGUIEx, OneKeyIgnore_txt_path)
    self.OneKeyIgnore_btn = self:AddComponent(UIButton, OneKeyIgnore_btn_path)
    self.OneKeyIgnore_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnHideWarning()
    end)
    
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCreateCell(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnDeleteCell(itemObj, index)
    end)
end

function UIAllianceWarPersonalListView:ComponentDestroy()
end

function UIAllianceWarPersonalListView:DataDefine()
    self.list = {}
    self.cells = {}
end

function UIAllianceWarPersonalListView:DataDestroy()
    self.list = {}
    self.cells = {}
end
function UIAllianceWarPersonalListView:OnEnable()
    base.OnEnable(self)
end

function UIAllianceWarPersonalListView:OnDisable()
    base.OnDisable(self)
end

function UIAllianceWarPersonalListView:ReInit()
    self.title:SetLocalText(141023)
    self.contentTxt:SetLocalText(141025)
    self:ShowCells()
end

function UIAllianceWarPersonalListView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.RefreshAlarm, self.OnRefreshSignal)
    self:AddUIListener(EventId.UpdateAlertData, self.OnRefreshSignal)
    self:AddUIListener(EventId.BlackKnightWarning, self.BlackKnightWarningSignal)
end

function UIAllianceWarPersonalListView:OnRemoveListener()
    self:RemoveUIListener(EventId.RefreshAlarm, self.OnRefreshSignal)
    self:RemoveUIListener(EventId.UpdateAlertData, self.OnRefreshSignal)
    self:RemoveUIListener(EventId.BlackKnightWarning, self.BlackKnightWarningSignal)
    base.OnRemoveListener(self)
end

function UIAllianceWarPersonalListView:ShowCells()
    self:ClearScroll()
    self:GetDataList()
    local count = #self.list
    if count > 0 then
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
        self.OneKeyIgnore_btn:SetActive(true)
        self.OneKeyIgnore_txt:SetLocalText(141040)
        self.contentBg:SetActive(false)
    else
        self.OneKeyIgnore_btn:SetActive(false)
        self.contentBg:SetActive(true)
    end
end

function UIAllianceWarPersonalListView:ClearScroll()
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(UIPersonalWarning)--清循环列表gameObject
end

function UIAllianceWarPersonalListView:OnCreateCell(itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scroll_view:AddComponent(UIPersonalWarning, itemObj)
    item:SetData(self.list[index])
    item:RefreshData()
    self.cells[index] = item
end

function UIAllianceWarPersonalListView:OnDeleteCell(itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UIPersonalWarning)
    self.cells[index] = nil
end

function UIAllianceWarPersonalListView:OnRefreshSignal()
    self:ShowCells()
end


function UIAllianceWarPersonalListView:OnHideWarning()
    for k,v in ipairs(self.list) do
        if type(v) == "number" then
            DataCenter.AllianceWarDataManager:SetIgnoreList(v, 2)
        elseif v.isNpc then
            DataCenter.GuideNeedLoadManager:SetFakeNpcMarchHide(true)
        elseif v:GetMarchType() == NewMarchType.MONSTER_SIEGE then
            --黑骑士有专属活动屏蔽按钮
            DataCenter.ActBlackKnightManager:CloseWarning()
            DataCenter.RadarAlarmDataManager:AddToCancelList(v.uuid, true)
        else
            DataCenter.RadarAlarmDataManager:AddToCancelList(v.uuid, true)
        end
    end
    EventManager:GetInstance():Broadcast(EventId.IgnoreTargetForMineMarch,false)
    for k, v in pairs(self.cells) do
        v:SetRelieve()
    end
    UIUtil.ShowTipsId(141026)
end

function UIAllianceWarPersonalListView:GetDataList()
    self.list = {}
    --local fakeNpcMarch = DataCenter.GuideNeedLoadManager:GetFakeNpcMarch()
    --if fakeNpcMarch ~= nil then
    --    --假数据
    --    local oneData = {}
    --    oneData.isNpc = true
    --    oneData.leftName = Localization:GetString(GameDialogDefine.ATTACK_NPC_NAME)
    --    oneData.rightName = ""
    --    oneData.rightName = Localization:GetString(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), BuildingTypes.FUN_BUILD_MAIN + 0,"name"))
    --    oneData.rightPointId = LuaEntry.Player:GetMainWorldPos()
    --    local pos, angle, needTimer = DataCenter.GuideNeedLoadManager:GetFakeNpcMarchPosAndAngle()
    --    oneData.leftPointId = SceneUtils.WorldToTileIndex(pos, ForceChangeScene.World)
    --    oneData.serverId = LuaEntry.Player.serverId
    --    table.insert(self.list, oneData)
    --end

    local virtualAllianceMemberList = DataCenter.AllianceHelpVirtualMarchManager:GetVirtualMemberList()
    if virtualAllianceMemberList ~= nil and virtualAllianceMemberList[1] ~= nil then
        for i =1, #virtualAllianceMemberList, 1 do
            table.insert(self.list, virtualAllianceMemberList[i])
        end
    end

    --个人警报
    local mySeverId = LuaEntry.Player:GetCurServerId()
    local cross = false
    local personalList = DataCenter.RadarAlarmDataManager:GetAllMarches()
    local ownAllianceUid = LuaEntry.Player:GetAllianceUid()
    for _, v in pairs(personalList) do
        if v.allianceUid ~= ownAllianceUid then
            if v.serverId == mySeverId then
                table.insert(self.list, v)
            elseif not cross then
                cross = true
                local param = {}
                param.isCross = true
                if v.server == nil then
                    param.alarm = v
                    param.serverId = v.serverId
                else
                    param.serverId = v.server
                    param.pointId = v.point
                end
                table.insert(self.list, param)
            end
        end
    end
end

function UIAllianceWarPersonalListView:GetPersonalItemData(ownerFormationUuid)
    local data = nil
    for i, v in ipairs(self.list) do
        if type(v) ~= "number" then
            if v.ownerFormationUuid == ownerFormationUuid then
                data = v
                break
            end
        end
    end
    if not data then
        return
    end
    local oneData = {}
    data.allianceAbbr = data.allianceAbbr or ""
    if data.allianceAbbr == "" then
        oneData.leftName = data.ownerName
    else
        oneData.leftName = "[".. data.allianceAbbr .."]"..data.ownerName
    end
    oneData.serverId = data.serverId
    oneData.worldId = data.worldId
    oneData.attackUid = data.ownerUid
    oneData.attackIcon = data.pic
    oneData.ownerIconVer = data.picVer
    oneData.rightPointId = data.targetPos
    oneData.leftPointId = data.startPos

    local marchTargetType = data:GetMarchTargetType()
    if marchTargetType == MarchTargetType.RALLY_FOR_BUILDING or marchTargetType == MarchTargetType.ATTACK_BUILDING or marchTargetType == MarchTargetType.ATTACK_CITY or marchTargetType == MarchTargetType.DIRECT_ATTACK_CITY
            or marchTargetType == MarchTargetType.SCOUT_BUILDING or marchTargetType == MarchTargetType.ASSISTANCE_CITY or marchTargetType == MarchTargetType.ASSISTANCE_BUILD or marchTargetType == MarchTargetType.SCOUT_CITY 
            or marchTargetType == MarchTargetType.RALLY_FOR_CITY then
        local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(data.targetUuid)
        if buildingData ~= nil then
            oneData.rightName = Localization:GetString(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), buildingData.itemId + buildingData.level,"name"))
        end
    elseif marchTargetType == MarchTargetType.ATTACK_ARMY or marchTargetType == MarchTargetType.ATTACK_ARMY_COLLECT or marchTargetType == MarchTargetType.SCOUT_TROOP then
        oneData.rightName = Localization:GetString("110020")
    elseif marchTargetType == MarchTargetType.ATTACK_DESERT then
        oneData.rightName = Localization:GetString("110371")
    end
    oneData.uuid = data.uuid
    oneData.endTime = data.endTime
    if marchTargetType ==  MarchTargetType.SCOUT_BUILDING or  marchTargetType ==  MarchTargetType.SCOUT_CITY  or  marchTargetType ==  MarchTargetType.SCOUT_ARMY_COLLECT then
        oneData.soldierNum = ""

    else
        oneData.soldierNum =  Localization:GetString("310160",string.GetFormattedSeperatorNum(data:GetSoliderNum()))
    end
    oneData.ownerFormationUuid = ownerFormationUuid
    oneData.type = DataCenter.RadarAlarmDataManager:GetWarningType(data)
    oneData.status = data:GetMarchStatus()

    oneData.isAlliance = false
    return oneData
end

function UIAllianceWarPersonalListView:GetBlackKnightData(data)
    local oneData = {}
    oneData.monsterId = data.monsterId
    local round = DataCenter.MonsterTemplateManager:GetTableValue(oneData.monsterId, "round")
    local nameStr = DataCenter.MonsterTemplateManager:GetTableValue(oneData.monsterId, "name")
    oneData.round = round
    oneData.leftName = Localization:GetString(GameDialogDefine.TURN_WITH, round) .. " " .. Localization:GetString(nameStr)
    oneData.serverId = data.serverId
    oneData.attackUid = data.ownerUid
    oneData.attackIcon = data.pic
    oneData.ownerIconVer = data.picVer
    oneData.rightPointId = data.targetPos
    local marchTargetType = data:GetMarchTargetType()
    if marchTargetType == MarchTargetType.RALLY_FOR_BUILDING or marchTargetType == MarchTargetType.ATTACK_BUILDING or marchTargetType == MarchTargetType.ATTACK_CITY or marchTargetType == MarchTargetType.DIRECT_ATTACK_CITY
            or marchTargetType == MarchTargetType.SCOUT_BUILDING or marchTargetType == MarchTargetType.ASSISTANCE_CITY or marchTargetType == MarchTargetType.ASSISTANCE_BUILD or marchTargetType == MarchTargetType.SCOUT_CITY then
        local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(data.targetUuid);
        if buildingData ~= nil then
            oneData.rightName = Localization:GetString(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), buildingData.itemId + buildingData.level,"name"))
        end
    elseif marchTargetType == MarchTargetType.ATTACK_ARMY or marchTargetType == MarchTargetType.ATTACK_ARMY_COLLECT or marchTargetType == MarchTargetType.SCOUT_TROOP then
        oneData.rightName = Localization:GetString("110020")
    elseif marchTargetType == MarchTargetType.ATTACK_DESERT then
        oneData.rightName = Localization:GetString("110371")
    end
    oneData.uuid = data.uuid
    oneData.endTime = data.endTime
    if marchTargetType ==  MarchTargetType.SCOUT_BUILDING or  marchTargetType ==  MarchTargetType.SCOUT_CITY  or  marchTargetType ==  MarchTargetType.SCOUT_ARMY_COLLECT then
        oneData.soldierNum = ""
    else
        oneData.soldierNum =  Localization:GetString("310160",string.GetFormattedSeperatorNum(data:GetSoliderNum()))
    end
    oneData.ownerFormationUuid = 0
    oneData.type = DataCenter.RadarAlarmDataManager:GetWarningType(data)
    oneData.status = data:GetMarchStatus()
    oneData.isAlliance = false
    return oneData
end

function UIAllianceWarPersonalListView:BlackKnightWarningSignal()
    for k,v in pairs(self.cells) do
        v:RefreshData()
    end
end

return UIAllianceWarPersonalListView
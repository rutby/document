---
--- 联盟个人情报拆出来的单独界面
--- Created by shimin.
--- DateTime: 2023/3/3 17:14
---

local UIAllianceWarPersonalListCtrl = BaseClass("UIAllianceWarPersonalListCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function UIAllianceWarPersonalListCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceWarPersonalList)
end

local AllianceWarItemShow =
{
    leftName ="",
    rightName ="",
    leftPointId = 0,
    rightPointId=0,
    leftDistance =0,
    isAttack =false,
    cancel = false,
    join =false,
    inTeam =false,
    inMarch = false,
    currentSoldiers =0,
    maxSoldiers =0,
    waitTime =0,
    createTime =0,
    marchTime =0,
    targetUuid = 0,
}

local OneData = DataClass("OneData", AllianceWarItemShow)

function UIAllianceWarPersonalListCtrl:GetWarItemData(uuid)
    local oneData = OneData.New()
    local data = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(uuid)
    if data~=nil then
        oneData.leftName ="[".. data.attackAllianceAbbr.."]"..data.attackName
        if data.targetAllianceAbbr ~= "" then
            oneData.rightName = "[".. data.targetAllianceAbbr.."]"..data.targetName
        else
            oneData.rightName = data.targetName
        end
        oneData.serverId = data.server
        oneData.leftPointId = data.attackPointId
        oneData.rightPointId = data.targetPointId
        oneData.currentSoldiers= data.currentSoldiers
        oneData.maxSoldiers =  data.maxSoldiers
        oneData.waitTime = data.waitTime
        oneData.marchTime = data.marchTime
        oneData.createTime = data.createTime
        oneData.type = data.type
        oneData.targetUid = data.targetUid
        oneData.targetIcon = data.targetIcon
        oneData.targetIconVer = data.targetIconVer
        oneData.targetHeadBg = data.leaderMarch:GetHeadBgImg()
        oneData.assemblyMarchMax = data.assemblyMarchMax
        oneData.canJoinNum = 1
        oneData.attackUid = data.attackUid
        oneData.attackIcon = data.leaderMarch.ownerIcon
        oneData.ownerIconVer = data.leaderMarch.ownerIconVer
        oneData.ownerHeadBg = data:GetHeadBgImg()
        oneData.targetUuid = data.targetUuid
        oneData.leaderMarchUuid = data.leaderMarch.uuid
        --计算参与人数，leaderMarch必有一个
        if next(data.memberList) then
            for i, v in pairs(data.memberList) do
                oneData.canJoinNum = oneData.canJoinNum + 1
            end
            oneData.canJoinNum = oneData.canJoinNum
        end

        --根据类型判断
        if oneData.type == AllianceTeamType.ATTACK_BOSS then
            local level = DataCenter.MonsterTemplateManager:GetTableValue(oneData.targetUid, "level")
            local name = DataCenter.MonsterTemplateManager:GetTableValue(oneData.targetUid, "name")
            oneData.rightName = Localization:GetString("300665", level)..Localization:GetString(name)
        elseif oneData.type == AllianceTeamType.ATTACK_AL_CITY then
            local name = data.targetName
            if name==nil or name=="" then
                name = GetTableData(TableName.WorldCity, data.targetContentId, 'name')
                name = Localization:GetString(name)
            end
            local lv = GetTableData(TableName.WorldCity, data.targetContentId, 'level')
            oneData.rightName = Localization:GetString("310161", name, lv)
        end

        local curTime = UITimeManager:GetInstance():GetServerTime()
        oneData.inMarch = (curTime>data.marchTime and curTime>data.waitTime)

        local selfAllianceId = LuaEntry.Player.allianceId
        local selfUid = LuaEntry.Player.uid
        oneData.isAttack = (selfAllianceId ~= data.attackAllianceId)   --true为自己或盟友或联盟城被打
        oneData.cancel = (selfUid == data.attackUid)                   --true为自己发起的集结
        oneData.isSelfAttack = (selfUid == data.targetUid)             --true为自己被打
        oneData.rightDistance = 0
        oneData.leftDistance = 0

        if oneData.isSelfAttack then
            --自己被打
            local enemyPos = SceneUtils.IndexToTilePos(oneData.leftPointId,ForceChangeScene.World)
            oneData.rightDistance = math.ceil(SceneUtils.TileDistance(enemyPos, SceneUtils.IndexToTilePos(LuaEntry.Player:GetMainWorldPos(),ForceChangeScene.World)))
        elseif not oneData.isSelfAttack and data.targetAllianceId == selfAllianceId then
            --盟友被打
            --到盟友距离
            local allyPos = SceneUtils.IndexToTilePos(oneData.rightPointId,ForceChangeScene.World)
            oneData.leftDistance =math.ceil(SceneUtils.TileDistance(allyPos, SceneUtils.IndexToTilePos(LuaEntry.Player:GetMainWorldPos(),ForceChangeScene.World)))
            --到敌人距离
            local enemyPos = SceneUtils.IndexToTilePos(oneData.leftPointId,ForceChangeScene.World)
            oneData.rightDistance = math.ceil(SceneUtils.TileDistance(enemyPos, SceneUtils.IndexToTilePos(LuaEntry.Player:GetMainWorldPos(),ForceChangeScene.World)))
        elseif oneData.cancel then
            --我发起的集结
            --到敌人距离
            local enemyPos = SceneUtils.IndexToTilePos(oneData.rightPointId,ForceChangeScene.World)
            oneData.rightDistance = math.ceil(SceneUtils.TileDistance(enemyPos, SceneUtils.IndexToTilePos(LuaEntry.Player:GetMainWorldPos(),ForceChangeScene.World)))
        elseif not oneData.cancel and not oneData.isAttack then
            --盟友发起的集结
            --到盟友距离
            local allyPos = SceneUtils.IndexToTilePos(oneData.leftPointId,ForceChangeScene.World)
            oneData.leftDistance =math.ceil(SceneUtils.TileDistance(allyPos, SceneUtils.IndexToTilePos(LuaEntry.Player:GetMainWorldPos(),ForceChangeScene.World)))
            --到敌人距离
            local enemyPos = SceneUtils.IndexToTilePos(oneData.rightPointId,ForceChangeScene.World)
            oneData.rightDistance = math.ceil(SceneUtils.TileDistance(enemyPos, SceneUtils.IndexToTilePos(LuaEntry.Player:GetMainWorldPos(),ForceChangeScene.World)))
        end

        local canJoin =false
        local inTeam =false
        if oneData.cancel ==false and oneData.isAttack==false then
            local count = table.count(data.memberList)
            if count< data.assemblyMarchMax then
                canJoin =true
                table.walk(data.memberList,function (k,v)
                    if v.ownerUid == selfUid then
                        inTeam =true
                        canJoin=false
                    end
                end)
            end
        end
        oneData.waitMemberTime = data.waitMemberTime
        oneData.teamUuid = data.leaderMarch.teamUuid
        oneData.join = canJoin
        oneData.inTeam = inTeam
        oneData.uuid = uuid
        oneData.isAlliance = true
        oneData.marchendTime = data.leaderMarch.endTime     --部队抵达目标结束时间
    end
    return oneData
end

function UIAllianceWarPersonalListCtrl:OnClickPosBtn(pos,isV3,marchUuid,serverId,worldId)
    if pos~=0 then
        self:CloseSelf()
        EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
        if isV3 then
            GoToUtil.GotoWorldPos(pos, CS.SceneManager.World.InitZoom,LookAtFocusTime,function()
                if marchUuid then
                    CS.SceneManager.World.marchUuid = marchUuid
                    DataCenter.WorldMarchDataManager:TrackMarch(marchUuid)
                    WorldMarchTileUIManager:GetInstance():ShowTroop(marchUuid)
                end
            end,serverId,worldId)
        else
            GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(pos,ForceChangeScene.World), CS.SceneManager.World.InitZoom,LookAtFocusTime,nil,serverId,worldId)
        end
    end
end

--获取总兵力信息(集结)
function UIAllianceWarPersonalListCtrl:GetAllSoldiersInfo(uuid)
    local info = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(uuid)
    local SoldiersInfo = { }
    local typeNum = {}
    local num = 0
    if info ~= nil then
        if next(info.memberList)then
            local data = info.memberList
            table.walk(data, function(k,v)
                table.walk(v.armyInfos.soldiers, function(i,n)
                    if SoldiersInfo[n.armsId] == nil then
                        SoldiersInfo[n.armsId] = {}
                        SoldiersInfo[n.armsId].num = n.total - n.lost
                        SoldiersInfo[n.armsId].type = n.type
                    else
                        SoldiersInfo[n.armsId].num = SoldiersInfo[n.armsId].num + (n.total - n.lost)
                    end
                end)
            end)
        end
        if next(info.leaderMarch) then
            local data = info.leaderMarch
            if data.armyInfo ~= nil then
                local soldiers = data.armyInfo.soldiers
                table.walk(soldiers, function(k,v)
                    if SoldiersInfo[v.armsId] == nil then
                        SoldiersInfo[v.armsId] ={}
                        SoldiersInfo[v.armsId].num = v.total - v.lost
                        SoldiersInfo[v.armsId].type = v.type
                    else
                        SoldiersInfo[v.armsId].num = SoldiersInfo[v.armsId].num + (v.total - v.lost)
                    end
                end)
            end
        end
    end
    if next(SoldiersInfo) then
        table.walk(SoldiersInfo, function(k,v)
            if typeNum[v.type] == nil then
                typeNum[v.type] = v.num
                num = num + v.num
            else
                typeNum[v.type] = typeNum[v.type] + v.num
                num = num + typeNum[v.type]
            end
        end)
    end
    return typeNum
end

function UIAllianceWarPersonalListCtrl:OnLeftPlayerInfoClick(userUid)
    if userUid ~= nil and userUid ~= "" then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIOtherPlayerInfo, userUid)
    end
end


function UIAllianceWarPersonalListCtrl:GetPlayerItemData(marchUuid, teamUuid)
    local oneData = {}
    local info = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(teamUuid)
    local selfUid = LuaEntry.Player.uid
    if info~=nil then
        if info.memberList[marchUuid]~=nil then
            local data = info.memberList[marchUuid]
            oneData.ownerName = "[".. info.attackAllianceAbbr.."]".. data.ownerName
            oneData.status = data.status
            oneData.endTime = data.endTime
            oneData.startTime =data.startTime
            oneData.leader = false
            oneData.cancel = (data.ownerUid == selfUid or info.attackUid == selfUid)
            oneData.ownerUid = data.ownerUid
            oneData.teamUuid = data.teamUuid
            oneData.attackUid = info.attackUid
            oneData.ownerIcon = data.ownerIcon
            oneData.ownerIconVer = data.ownerIconVer
            oneData.headBg = data:GetHeadBgImg()
        elseif info.leaderMarch~=nil and info.leaderMarch.uuid == marchUuid then
            local data  = info.leaderMarch
            oneData.ownerName = "[".. info.attackAllianceAbbr.."]".. data.ownerName
            oneData.status = data.status
            oneData.endTime = data.endTime
            oneData.startTime =data.startTime
            oneData.leader = true
            oneData.cancel = data.ownerUid == selfUid
            oneData.ownerUid = data.ownerUid
            oneData.teamUuid = data.teamUuid
            oneData.attackUid = info.attackUid
            oneData.ownerIcon = data.ownerIcon
            oneData.ownerIconVer = data.ownerIconVer
            oneData.headBg = data:GetHeadBgImg()
        end

    end
    return oneData
end

--获取玩家出兵信息
function UIAllianceWarPersonalListCtrl:GetPlayerSoldierData(marchUuid, teamUuid)
    local info = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(teamUuid)
    local showList = {}
    if info ~= nil then
        --所参与人员
        if next(info.memberList) and info.memberList[marchUuid] then
            local data = info.memberList[marchUuid].armyInfos
            local heros = data.heros
            showList.heros = {}
            for i = 1, #heros do
                showList.heros[i] = {}
                showList.heros[i].heroId = heros[i].heroId
                showList.heros[i].quality = heros[i].heroQuality
                showList.heros[i].lv = heros[i].heroLevel
                showList.heros[i].skillInfos = heros[i].skillInfos
                showList.heros[i].rankLv = heros[i].rankLv
                showList.heros[i].stage  = heros[i].stage
                showList.heros[i].camp = HeroUtils.GetCamp(heros[i])
            end
            local soldiers = data.soldiers
            showList.soldiers = {}
            for i = 1, #soldiers do
                showList.soldiers[i] = {}
                showList.soldiers[i].armsId = soldiers[i].armsId
                showList.soldiers[i].type = soldiers[i].type
                showList.soldiers[i].data = DataCenter.ArmyTemplateManager:GetArmyTemplate(soldiers[i].armsId)
                showList.soldiers[i].count = soldiers[i].total - soldiers[i].lost
            end
        elseif next(info.leaderMarch) and info.leaderMarch.uuid == marchUuid then
            --队长信息
            local data = info.leaderMarch
            if data.armyInfo ~= nil then
                local heros = data.armyInfo.heros
                showList.heros = {}
                for i = 1, #heros do
                    showList.heros[i] = {}
                    showList.heros[i].heroId = heros[i].heroId
                    showList.heros[i].quality = heros[i].heroQuality
                    showList.heros[i].lv = heros[i].heroLevel
                    showList.heros[i].skillInfos = heros[i].skillInfos
                    showList.heros[i].rankLv = heros[i].rankLv
                    showList.heros[i].stage  = heros[i].stage
                    showList.heros[i].camp = HeroUtils.GetCamp(heros[i])
                end
                local soldiers = data.armyInfo.soldiers
                showList.soldiers = {}
                for i = 1, #soldiers do
                    showList.soldiers[i] = {}
                    showList.soldiers[i].armsId = soldiers[i].armsId
                    showList.soldiers[i].type = soldiers[i].type
                    showList.soldiers[i].data = DataCenter.ArmyTemplateManager:GetArmyTemplate(soldiers[i].armsId)
                    showList.soldiers[i].count = soldiers[i].total - soldiers[i].lost
                end
            end
        end
    end
    return showList
end


return UIAllianceWarPersonalListCtrl

---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/8/6 11:20
---
local UISearchCtrl = BaseClass("UISearchCtrl", UIBaseCtrl)
local Setting = CS.GameEntry.Setting

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UISearch,{ anim = true, UIMainAnim = UIMainAnimType.AllShow})
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Background)
end

local function GetCurChangeByTotal(self,curNum,maxNum,isAdd)
    local changeNum = 0
    if isAdd  then
        if curNum<maxNum then
            changeNum = curNum+1
        else
            changeNum = curNum
        end
    else
        if curNum>0 then
            changeNum = curNum-1
        else
            changeNum = curNum
        end
    end
    return changeNum
end

local function InitData(self)
    self.maxArr = {30,10,10,10,10,10}--最大显示
    self.curCnt ={}
end

local function GetMaxNumBySearchType(self,type)
    local count = 1
    if type==UISearchType.Monster then
        --count = DataCenter.MonsterManager:GetCanFindMonsterMaxLevel()
        count = DataCenter.MonsterManager:GetCurCanAttackMaxLevel()
    elseif type == UISearchType.Boss then
        count = DataCenter.MonsterManager:GetCurCanAttackBossMaxLevel()
    elseif type == UISearchType.Wood then
        count = DataCenter.ResourceManager:GetResourceCanSearchLevelByType(ResourceType.Plank)
    elseif type == UISearchType.Food then
        count = DataCenter.ResourceManager:GetResourceCanSearchLevelByType(ResourceType.Food)
    elseif type == UISearchType.Electricity then
        count = DataCenter.ResourceManager:GetResourceCanSearchLevelByType(ResourceType.Electricity)
    elseif type == UISearchType.Metal then
        count = DataCenter.ResourceManager:GetResourceCanSearchLevelByType(ResourceType.Steel)
    elseif type == UISearchType.Money then
        count = DataCenter.ResourceManager:GetResourceCanSearchLevelByType(ResourceType.Money)
    else
        if self.maxArr[type]~=nil and self.maxArr[type]~=0 then
            count = self.maxArr[type]
        end
    end
    return count
end
local function OnSearchClick(self,type)
    local pos = LuaEntry.Player:GetMainWorldPos()
    local level = self:GetCurNumBySearchType(type)
    if type==UISearchType.Monster then
        local pointId = pos
        SFSNetwork.SendMessage(MsgDefines.FindMonster,pointId,level,false)
    elseif  type==UISearchType.Boss then
        SFSNetwork.SendMessage(MsgDefines.FindMonsterBoss,level)
    elseif type == UISearchType.Food then
        SFSNetwork.SendMessage(MsgDefines.FindResourcePoint,ResourceType.Food,level)
    elseif type == UISearchType.Wood then
        SFSNetwork.SendMessage(MsgDefines.FindResourcePoint,ResourceType.Plank,level)
    elseif type == UISearchType.Electricity then
        SFSNetwork.SendMessage(MsgDefines.FindResourcePoint,ResourceType.Electricity,level)
    elseif type == UISearchType.Metal then
        SFSNetwork.SendMessage(MsgDefines.FindResourcePoint,ResourceType.Steel,level)
    elseif type == UISearchType.Money then
        SFSNetwork.SendMessage(MsgDefines.FindResourcePoint,ResourceType.Money,level)
    end
end
local function OnSearchEnd(self,pointId,uuid)
    local worldPosition = SceneUtils.TileIndexToWorld(pointId,ForceChangeScene.World)
    WorldArrowManager:GetInstance():ShowArrowEffect(uuid,worldPosition,ArrowType.Monster)
    GoToUtil.GotoWorldPos(worldPosition, CS.SceneManager.World.InitZoom)
    self:CloseSelf()
end

local function SetCurNumBySearchType(self,type,num)
    self.curCnt[type] = num
    self:SetSearchLevel(type)
end

local function GetCurNumBySearchType(self,type)
    local ret = 1
    if self.curCnt[type]~=nil then
        ret = self.curCnt[type]
    else
        ret = self:GetSearchLevel(type)
    end
    
    if ret > self:GetMaxNumBySearchType(type) then
        ret = self:GetMaxNumBySearchType(type)
    end
    if ret == 0 then
        ret = 1
    end
    return ret
end


local function SetSearchLevel(self,type)
    Setting:SetInt(LuaEntry.Player.uid.. SettingKeys.SEARCH_MONSTER_LEVEL .. type, self:GetCurNumBySearchType(type))
end

local function GetSearchLevel(self, type)
    return Setting:GetInt(LuaEntry.Player.uid.. SettingKeys.SEARCH_MONSTER_LEVEL .. type, 1)
end

local function GetCurrentState(self)
    local showData = {}
    showData.serverId = LuaEntry.Player:GetCurServerId()
    --local carTilePos = CS.SceneManager.World.CurTilePosClamped
    --local lastGotoX, lastGotoY = self:GetLastRecordXAndY()
    local pos = CS.SceneManager.World.CurTarget
    local tile = SceneUtils.WorldToTileIndex(pos)
    local v2 = SceneUtils.IndexToTilePos(tile)
    --if lastGotoX ~= nil and lastGotoY ~= nil and lastGotoX >= 0 and lastGotoY > 0 then
    --    showData.x = lastGotoX
    --    showData.y = lastGotoY
    --else
        showData.x = v2.x
        showData.y = v2.y
    --end
    return showData
end

local function SetCurBookMarkType(self, tempType)
    self.curBookMarkType = tempType
end

local function CheckCanGo(self, server, x, y)
    local canJump = false
    if server ~= nil and x ~= nil and y ~= nil then
        --if server == LuaEntry.Player:GetSelfServerId() then
            if x >= 0 and y >= 0 and x <= CS.SceneManager.World.TileCount.x - 1 and y <= CS.SceneManager.World.TileCount.y - 1 then
                local data = CS.UnityEngine.Vector2Int(x, y)
                if CS.SceneManager.World:IsInMap(data) then
                    canJump = true
                end
            end
        --end
    end
    return canJump
end

local function OnJumpClick(self, server, x, y)
    local v2 = {}
    v2.x = x
    v2.y = y
    GoToUtil.GotoWorldPos(SceneUtils.TileToWorld(v2),CS.SceneManager.World.InitZoom,nil,nil,server)
    --GoToUtil.GotoPos(SceneUtils.TileToWorld(v2), CS.SceneManager.World.InitZoom)
    --DataCenter.WorldFavoDataManager:SetLastGotoPos(tostring(server) .. ";" .. tostring(x) .. ";" .. tostring(y))
    self:CloseSelf()
end

local function GetMarkListByTab(self,tab)
    local showList ={}
    local dataList ={}
    if tab==-1 then
        dataList = DataCenter.WorldFavoDataManager:GetAllBookList()
    else
        dataList = DataCenter.WorldFavoDataManager:GetBookListByType(tab)
    end
    if dataList~=nil then
        table.walksort(dataList,function (leftKey,rightKey)
            return dataList[leftKey].createTime < dataList[rightKey].createTime
        end,function(k,v)
            table.insert(showList,v)
        end)
    end
    return showList
end

local function DelBookMark(self,selectItem)
    if not self.curBookMarkType then
        self:CloseSelf()
        return
    end
    if self.curBookMarkType ~= MarkType.Alliance_Attack then
        SFSNetwork.SendMessage(MsgDefines.WorldFavoDel,selectItem.pos,selectItem.type,selectItem.server)
    else
        if self.curBookMarkType and self.curBookMarkType == MarkType.Alliance_Attack then
            if not LuaEntry.Player:IsInAlliance() then
                UIUtil.ShowTipsId(390820) 
                return
            elseif not DataCenter.AllianceBaseDataManager:IsR4orR5() then
                UIUtil.ShowTipsId(390822) 
                return
            end
        end
        DataCenter.WorldFavoDataManager:TryDelAllianceMask(selectItem.type)
    end
end

local function ShareBookMark(self,selectItem)
    if self.curBookMarkType and self.curBookMarkType == MarkType.Alliance_Attack then
        if not LuaEntry.Player:IsInAlliance() then
            UIUtil.ShowTipsId(390820) 
            return
        end
    end
    
    local share_param = {}
    share_param.sid = selectItem.server
    share_param.pos = (selectItem.pos - selectItem.pos % 10) / 10
    share_param.uname = selectItem.name
    GoToUtil.GotoOpenView(UIWindowNames.UIPositionShare, {anim = true}, share_param)
end

local function OnClickPosBtn(self,selectItem)
    if self.curBookMarkType and self.curBookMarkType == MarkType.Alliance_Attack then
        if not LuaEntry.Player:IsInAlliance() then
            UIUtil.ShowTipsId(390820) 
            return
        end
    end
    local point = (selectItem.pos - selectItem.pos % 10) / 10
    local worldId = LuaEntry.Player:GetCurWorldId()
    GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(point), CS.SceneManager.World.InitZoom,LookAtFocusTime,function()
    end, selectItem.server,worldId)
    self:CloseSelf()
end

local function GetLastRecordXAndY(self)
    local x = Setting:GetInt(LuaEntry.Player.uid.. SettingKeys.GOTO_POSITION_X, -1)
    local y = Setting:GetInt(LuaEntry.Player.uid.. SettingKeys.GOTO_POSITION_Y, -1)
    return x, y
end

local function SaveLastInputXAndY(self, serverId, x, y)
    if self:CheckCanGo(serverId, x, y) == true then
        Setting:SetInt(LuaEntry.Player.uid.. SettingKeys.GOTO_POSITION_X, x)
        Setting:SetInt(LuaEntry.Player.uid.. SettingKeys.GOTO_POSITION_Y, y)
    end
end

UISearchCtrl.CloseSelf =CloseSelf
UISearchCtrl.Close =Close
UISearchCtrl.GetCurChangeByTotal = GetCurChangeByTotal
UISearchCtrl.InitData = InitData
UISearchCtrl.GetMaxNumBySearchType = GetMaxNumBySearchType
UISearchCtrl.SetCurNumBySearchType = SetCurNumBySearchType
UISearchCtrl.GetCurNumBySearchType = GetCurNumBySearchType
UISearchCtrl.OnSearchEnd =OnSearchEnd
UISearchCtrl.OnSearchClick = OnSearchClick
UISearchCtrl.SetSearchLevel = SetSearchLevel
UISearchCtrl.GetSearchLevel = GetSearchLevel
UISearchCtrl.GetCurrentState = GetCurrentState
UISearchCtrl.CheckCanGo = CheckCanGo
UISearchCtrl.OnJumpClick = OnJumpClick
UISearchCtrl.GetMarkListByTab = GetMarkListByTab
UISearchCtrl.DelBookMark = DelBookMark
UISearchCtrl.ShareBookMark = ShareBookMark
UISearchCtrl.OnClickPosBtn = OnClickPosBtn
UISearchCtrl.SetCurBookMarkType = SetCurBookMarkType
UISearchCtrl.GetLastRecordXAndY = GetLastRecordXAndY
UISearchCtrl.SaveLastInputXAndY = SaveLastInputXAndY

return UISearchCtrl
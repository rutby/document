---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/10/26 18:16
---
local UIBookMarkPositionCollectCtrl = BaseClass("UIBookMarkPositionCollectCtrl", UIBaseCtrl)
local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBookMarkPositionCollect)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function GetCurrentState(self)
    local showData = {}
    showData.x =0
    showData.y =0
    local str= DataCenter.WorldFavoDataManager:GetLastGotoPos()
    if str~=nil and str~="" then
        local strArr = string.split(str,";")
        if #strArr>=2 then
            showData.x = tonumber(strArr[1])
            showData.y = tonumber(strArr[2])
        end
    else
        local carTilePos = CS.SceneManager.World.CurTilePosClamped
        showData.x =carTilePos.x
        showData.y =carTilePos.y
    end
	
    showData.serverId = LuaEntry.Player:GetSelfServerId()
    
    return showData
end

local function CheckCanGo(self,server,x,y)
    local canJump = false
    if server~=nil and x~=nil and y~=nil then
        if server== LuaEntry.Player:GetSelfServerId() then
            if x>=0 and y>=0 and x<=CS.SceneManager.World.TileCount.x - 1 and y<=CS.SceneManager.World.TileCount.y - 1 then
                local data = CS.UnityEngine.Vector2Int(x, y)
                if CS.SceneManager.World:IsInMap(data) then
                    canJump = true
                end
            end
        end
    end
    return canJump
end

local function OnJumpClick(self,server,x,y)
    local data = CS.UnityEngine.Vector2Int(x,y)
    CS.GotoUtils.GotoWorldToPointId(data,server)
    DataCenter.WorldFavoDataManager:SetLastGotoPos(tostring(x)..";"..tostring(y))
    self:CloseSelf()
end

local function OnBookMarkClick(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBookMark,{anim = true})
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBookMarkPositionCollect,{anim = true})
end


UIBookMarkPositionCollectCtrl.CloseSelf =CloseSelf
UIBookMarkPositionCollectCtrl.Close =Close
UIBookMarkPositionCollectCtrl.GetCurrentState = GetCurrentState
UIBookMarkPositionCollectCtrl.CheckCanGo = CheckCanGo
UIBookMarkPositionCollectCtrl.OnJumpClick = OnJumpClick
UIBookMarkPositionCollectCtrl.OnBookMarkClick =OnBookMarkClick
return UIBookMarkPositionCollectCtrl
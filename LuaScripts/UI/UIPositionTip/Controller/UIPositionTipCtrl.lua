---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Still4.
--- DateTime: 2021/6/29 16:09
---
local UIPositionTipCtrl = BaseClass("UIPositionTipCtrl", UIBaseCtrl)
local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPositionTip)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function GetCurrentState(self)
    local showData = {}
    showData.serverId = LuaEntry.Player:GetCurServerId()
    local pos = CS.SceneManager.World.CurTarget
    local tile = SceneUtils.WorldToTileIndex(pos)
    local v2 = SceneUtils.IndexToTilePos(tile)
    showData.x = v2.x
    showData.y = v2.y
    return showData
end

local function CheckCanGo(self, server, x, y)
    local canJump = false
    if server ~= nil and x ~= nil and y ~= nil then
        if x >= 0 and y >= 0 and x <= CS.SceneManager.World.TileCount.x - 1 and y <= CS.SceneManager.World.TileCount.y - 1 then
            local data = CS.UnityEngine.Vector2Int(x, y)
            if CS.SceneManager.World:IsInMap(data) then
                canJump = true
            end
        end
    end
    return canJump
end

local function OnJumpClick(self, server, x, y)
    local v2 = {}
    v2.x = x
    v2.y = y
    GoToUtil.GotoWorldPos(SceneUtils.TileToWorld(v2),CS.SceneManager.World.InitZoom,nil,nil,server)
    self:CloseSelf()
end

UIPositionTipCtrl.CloseSelf = CloseSelf
UIPositionTipCtrl.Close = Close
UIPositionTipCtrl.GetCurrentState = GetCurrentState
UIPositionTipCtrl.CheckCanGo = CheckCanGo
UIPositionTipCtrl.OnJumpClick = OnJumpClick
return UIPositionTipCtrl
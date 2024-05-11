---
--- Created by zzl.
--- DateTime: 
--- 搜索附近敌人
local FindEnemyPointMessage = BaseClass("FindEnemyPointMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self,type)
    base.OnCreate(self)
    self.sfsObj:PutInt("type",type)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    if t["pointId"] ~= 0 then
        local worldPointPos = SceneUtils.TileIndexToWorld(t["pointId"],ForceChangeScene.World)
        GoToUtil.CloseAllWindows()
        GoToUtil.GotoWorldPos(worldPointPos, CS.SceneManager.World.InitZoom,LookAtFocusTime,function()
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},t["uuid"],t["pointId"],t["uid"],WorldPointUIType.City,0,BuildingTypes.FUN_BUILD_MAIN,t["type"])
        end)
        return
    end
    UIUtil.ShowTipsId(170392)
end

FindEnemyPointMessage.OnCreate = OnCreate
FindEnemyPointMessage.HandleMessage = HandleMessage

return FindEnemyPointMessage
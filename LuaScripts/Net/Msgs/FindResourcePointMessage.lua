---
--- Created by zzl.
--- DateTime:
--- 搜索附近矿
local FindResourcePointMessage = BaseClass("FindResourcePointMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self,resType,level,param,onlyFull)
    base.OnCreate(self)
    self.sfsObj:PutInt("type", resType)
    self.sfsObj:PutInt("level", level)
    if onlyFull then
        self.sfsObj:PutBool("onlyFull", onlyFull)
    end
    if param then
        self.sfsObj:PutUtfString("param", param)
    end
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    if t["errorCode"] ~= nil then
        UIUtil.ShowTipsId(170475)
    elseif t["pointId"] and t["pointId"] ~= 0 then
        local worldPointPos = SceneUtils.TileIndexToWorld(t["pointId"],ForceChangeScene.World)
        GoToUtil.GotoWorldPos(worldPointPos,nil,nil, function()
            local uiType = WorldPointUIType.CollectPoint
            if DataCenter.GuideManager:InGuide() then
                return
            end
            local collectInfo = DataCenter.WorldPointManager:GetResourcePointInfoByIndex(t["pointId"])
            if collectInfo then
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldPoint,{anim = true,playEffect = false,UIMainAnim = UIMainAnimType.LeftRightBottomHide},0,t["pointId"],"",uiType,0,0,1)
            else
                WorldArrowManager:GetInstance():ShowArrowEffect(0,worldPointPos,ArrowType.CollectMoney)
            end
        end)
        return
    end
    UIUtil.ShowTipsId(129108)
end

FindResourcePointMessage.OnCreate = OnCreate
FindResourcePointMessage.HandleMessage = HandleMessage

return FindResourcePointMessage
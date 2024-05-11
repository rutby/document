





---
--- Pve小队阵型
---

local Const = require("Scene.LWBattle.Const")


---@class Scene.LWBattle.Formation
local Formation = BaseClass("Formation")

---@param squad Scene.LWBattle.BarrageBattle.Squad
function Formation:__init(squad)
    self.squad = squad---@type Scene.LWBattle.BarrageBattle.Squad
    self.memberCount=nil
    self.pos = nil
end

function Formation:__delete()
    self.squad = nil
    self.pos = nil
end

--加载阵型配置
function Formation:Init()
    self.memberCount=#self.squad.members
    self.pos={
        [1]=Vector3.New(-2.3,0,2.5),
        [2]=Vector3.New(2.3,0,2.5),
        [3]=Vector3.New(-3.3,0,-1.5),
        [4]=Vector3.New(0,0,-1.5),
        [5]=Vector3.New(3.3,0,-1.5),
    }
    self.weaponPos = Vector3.New(0,0,-6)
end

---通过索引获取队员相对小队中心的坐标
---@param index number
function Formation:GetOffsetByIndex(index)
    --return Vector3.New(-0.5*(self.memberCount+1)+index,0,0)
    return self.pos[index]
end

function Formation:GetWeaponOffset()
    return self.weaponPos
end

return Formation
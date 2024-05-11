---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1022.
--- DateTime: 2023/1/12 18:08
---
local RectangleRange = BaseClass("RectangleRange")
local SU_Util = require("Scene.PVEBattleLevel.Utils.SU_Util")

local function PolarToCartesian(angle,length)
    return Vector3.New(Mathf.Cos(angle * Mathf.Deg2Rad), 0, Mathf.Sin(angle * Mathf.Deg2Rad)) * length
end

--旋转后的坐标点
local function RotationPoint(originPoint,targetPosition,angle,arc)
    angle = (angle - 90) % 360
    angle = 360 - angle
    angle = angle - arc / 2
    local radius = Vector3.Distance(originPoint,targetPosition)
    return Vector3.Add(originPoint,PolarToCartesian(angle,radius))
end


function RectangleRange:__init(originPoint,width,height,eulerAngleY)
    self.originPoint = originPoint
    self.width = width
    self.height = height
    self.eulerAngleY = eulerAngleY
    self.minPoint = {x = originPoint.x - width/2,z = originPoint.z}  --左下点
    self.maxPoint = {x = originPoint.x + width/2, z = originPoint.z + height}   --右上点
end

function RectangleRange:ContainPoint(pos)
    local angle = SU_Util.GetAngle(self.originPoint,pos)
    angle = angle - self.eulerAngleY % 360
    --Logger.LogError(string.format("angle = %s",angle))
    local point = RotationPoint(self.originPoint,pos,0,angle * 2)
    --Logger.LogError(string.format("point.x = %s,point.z = %s,minPoint.x = %s,minPoint.z = %s,maxPoint.x = %s,maxPoint.z = %s",point.x,point.z,self.minPoint.x,self.minPoint.z,self.maxPoint.x,self.maxPoint.z))
    return point.x >= self.minPoint.x and point.x <= self.maxPoint.x and point.z >= self.minPoint.z and point.z <= self.maxPoint.z 
end

return RectangleRange
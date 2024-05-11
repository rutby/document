---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2021/12/6 17:02
---

local FlyController = BaseClass("FlyController");
local ResourceManager = CS.GameEntry.Resource
local IconPath = "Assets/_Art/Effect/prefab/ui/Common/FlyGoods.prefab";
local IconTextPath = "Assets/_Art/Effect/prefab/ui/Common/FlyGoodsText.prefab";
local CustomPath = "Assets/_Art/Effect/prefab/ui/Common/FlyCustom.prefab";

local TimeDelta = 0.09
local MinRange = -100.0
local MaxRange = 100.0

local SegmentCount = 20

local function __init(self)
    self.timer = nil
    self.timer_action = function(temp)
        self:TimeCallBack()
    end
    self.checkRemoveList = {}
end

local function __delete(self)
    self:ClearAllReq()
    self:DeleteTimer()
end

local function Startup(self)
    self.checkRemoveList = {}
end

local function TimeCallBack(self)
    if self.checkRemoveList[1] ~= nil then
        local count = #self.checkRemoveList
        local data = nil
        for i = count, 1, -1 do
            data = self.checkRemoveList[i]
            data.time = data.time - 1
            if data.time <= 0 then
                if data.request ~= nil then
                    data.request:Destroy()
                end
                table.remove(self.checkRemoveList, i)
            end
        end
        if self.checkRemoveList[1] == nil then
            self:DeleteTimer()
        end
    else
        self:DeleteTimer()
    end
end

local function DeleteTimer(self)
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

local function AddTimer(self)
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false,false,false)
        self.timer:Start()
    end
end

local function AddToCheckList(self,request,time)
    local oneData = {}
    oneData.request = request
    oneData.time = time+1
    table.insert(self.checkRemoveList,oneData)
    self:AddTimer()
end

local function DoFlyCustom(icon, content, num, srcPos, destPos, width, height, callback, model, minRange, maxRange, imgScale)
    TimerManager:GetInstance():DelayInvoke(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Furniture_Trail)
    end,1)
    local modelPath = model or CustomPath
    for i = 1, num do
        TimerManager:GetInstance():DelayInvoke(function()
            local request = ResourceManager:InstantiateAsync(modelPath)
            request:completed('+', function()
                if request.isError then
                    return
                end
                local tf = request.gameObject.transform
                tf:SetParent(CS.GameEntry.UIContainer)
                tf:Set_position(srcPos.x, srcPos.y, srcPos.z)
                tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                
                local image = tf:GetComponentInChildren(typeof(CS.UnityEngine.UI.Image))
                if image ~= nil then
                    if not string.IsNullOrEmpty(icon) then
                        image.gameObject:SetActive(true)
                        image:LoadSprite(icon, nil, function()
                            if imgScale ~= nil then
                                image.transform:Set_localScale(imgScale, imgScale, imgScale)
                                image:SetNativeSize()
                            else
                                image.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                                image:GetComponent(typeof(CS.UnityEngine.RectTransform)):Set_sizeDelta(width or 80, height or 80)
                            end
                        end)
                    else
                        image.gameObject:SetActive(false)
                    end
                end
                
                local text = tf:GetComponentInChildren(typeof(CS.TextMeshProUGUIEx))
                if text ~= nil then
                    if not string.IsNullOrEmpty(content) then
                        text.gameObject:SetActive(true)
                        text.text = content
                    else
                        text.gameObject:SetActive(false)
                    end
                end
                
                local fly = tf:GetComponent(typeof(CS.UIGoodsFly))
                local pos = CS.UnityEngine.Vector3(destPos.x, destPos.y, 0)
                local min = minRange == nil and MinRange or minRange
                local max = maxRange == nil and MaxRange or maxRange
                DataCenter.FlyController:AddToCheckList(request,fly.moveTime)
                fly:DoAnimForLua(min, max, 999, "", "", pos, function()
                    request:Destroy()
                    if callback ~= nil then
                        callback()
                    end
                end)
            end)
        end, (i - 1) * TimeDelta)
    end
end

local function DoFly(rewardType, num, icon, srcPos, destPos, width, height, callback, useTextFormat,moveTime)

    TimerManager:GetInstance():DelayInvoke(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Furniture_Trail)
    end,1)
    -- 经验球只飞一个，num代表文本为"+{num}"
    local count = (rewardType == RewardType.EXP or useTextFormat == true) and 1 or num
    for i = 1, count, 1 do
        TimerManager:GetInstance():DelayInvoke(function()
            local path

            if useTextFormat == true then
                path = IconTextPath
            else
                path = IconPath
            end
            local request = ResourceManager:InstantiateAsync(path)
            request:completed('+', function()
                if request.isError then
                    return
                end
                
                local tf = request.gameObject.transform
                tf:SetParent(CS.GameEntry.UIContainer)
                tf:Set_position(srcPos.x, srcPos.y, srcPos.z)
                local scaleRatio = 1
                if useTextFormat == true then
                    scaleRatio = 1.5
                end
                tf:Set_localScale(ResetScale.x * scaleRatio, ResetScale.y * scaleRatio, ResetScale.z * scaleRatio)

                local rtf = tf:Find("Image"):GetComponent(typeof(CS.UnityEngine.RectTransform))
                rtf:Set_sizeDelta(width or 80, height or 80)
                
                local fly = tf:GetComponent(typeof(CS.UIGoodsFly))
                local pos
                if destPos.x == 0 and destPos.y == 0 then
                    pos = UIUtil.GetFlyTargetPosByRewardType(rewardType)
                else
                    pos = destPos
                end
                if moveTime then
                    fly.moveTime = moveTime
                end
                DataCenter.FlyController:AddToCheckList(request,fly.moveTime)
                
                fly:DoAnimForLua(MinRange, MaxRange, rewardType, icon, num, pos, function()
                    request:Destroy()
                    FlyController.InternalCallback(rewardType)
                    if callback ~= nil then
                        callback()
                    end
                end)
            end)
        end, (i - 1) * TimeDelta)
    end
end

local function InternalCallback(rewardType)
    if rewardType == RewardType.EXP then
        SoundUtil.PlayEffect(SoundAssets.Effect_Exp_FarmSystem)
    end
end

local function Bezier2Path(startPos, controlPos, endPos)
    local paths = CS.System.Array.CreateInstance(typeof(CS.UnityEngine.Vector3), SegmentCount)
    for i = 1, SegmentCount do
        local t = i / SegmentCount
        local pixel = DataCenter.FlyController.CalculateCubicBezierPointFor2C(t, startPos, controlPos, endPos)
        paths[i - 1] = pixel
    end
    return paths
end

local function Bezier2PathNonAlloc(paths, startPos, controlPos, endPos)
    for i = 1, SegmentCount do
        local t = i / SegmentCount
        local pixel = DataCenter.FlyController.CalculateCubicBezierPointFor2C(t, startPos, controlPos, endPos)
        paths[i - 1] = pixel
    end
end

local function CalculateCubicBezierPointFor2C(t, p0, p1, p2)
    local u = 1 - t
    local tt = t * t
    local uu = u * u
    local p = uu * p0
    p = p + 2 * u * t * p1
    p = p + tt * p2
    return p
end

function FlyController:ClearAllReq()
    if self.checkRemoveList[1] ~= nil then
        for k, v in ipairs(self.checkRemoveList) do
            if v.request ~= nil then
                v.request:Destroy()
            end
        end
    end
    self.checkRemoveList = {}
end

FlyController.__init = __init
FlyController.__delete = __delete

FlyController.Startup = Startup
FlyController.DoFly = DoFly
FlyController.DoFlyCustom = DoFlyCustom

FlyController.InternalCallback = InternalCallback
FlyController.AddToCheckList = AddToCheckList
FlyController.AddTimer = AddTimer
FlyController.DeleteTimer = DeleteTimer
FlyController.TimeCallBack = TimeCallBack

FlyController.Bezier2Path = Bezier2Path
FlyController.Bezier2PathNonAlloc = Bezier2PathNonAlloc
FlyController.CalculateCubicBezierPointFor2C = CalculateCubicBezierPointFor2C

return FlyController
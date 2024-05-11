--- Created by shimin.
--- DateTime: 2021/3/11 26:23
--- 飞资源特效
--开始点为世界坐标 结束点为屏幕坐标
local FlyResourceEffect = BaseClass("FlyResourceEffect")

local icon_path = "Image"
local lizi_path = "shouji_lizi_UI"
--创建
local function OnCreate(self,go)
    if go ~= nil then
        self.request = go
        self.gameObject = go.gameObject
        self.transform = go.gameObject.transform
    end
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
end

local function ComponentDefine(self)
    self.icon_img = self.transform:Find(icon_path):GetComponent(typeof(CS.UnityEngine.UI.Image))
    self.lizi = self.transform:Find(lizi_path).gameObject
end

local function ComponentDestroy(self)
    self.icon_img = nil
end


local function DataDefine(self)
    self.param = nil
    self.__update_handle = function() self:Update() end
    UpdateManager:GetInstance():AddUpdate(self.__update_handle)
    self.isDoAnim = false
    self.curTime = 0
    self.endPos = nil
    self.showLizi = false
    self.startPos = 0
end

local function DataDestroy(self)
    self.param = nil
    UpdateManager:GetInstance():RemoveUpdate(self.__update_handle)
    self.__update_handle = nil
    self.isDoAnim = nil 
    self.curTime = nil
    self.endPos = nil
    self.showLizi = nil
    self.startPos= nil
end



local function ReInit(self,param)
    self.param = param
    self:ShowPanel()
end

local function ShowPanel(self)
    self.icon_img:LoadSprite(self.param.icon)
    self.showLizi =false
    --self.lizi:SetActive(false)
    self.gameObject.transform.position = self.param.startPos
    self.gameObject.transform.localScale = Vector3.New(1.8,1.8,1.8)
    self.curTime = 0
    self.startPos = self.param.startPos
    self.endPos = self.param.endPos
    local normalize = Vector3.Normalize(Vector3.New(self.endPos.x-self.startPos.x,self.endPos.y-self.startPos.y,self.endPos.z-self.startPos.z))
    if self.param.staticMoveNum~=nil then
        self.lizi.transform.localPosition = Vector3.New(-29,self.lizi.transform.localPosition.y,self.lizi.transform.localPosition.z)
        local x = 500*normalize.x
        local deltaY = 100*normalize.y
        local deltaX = 100*normalize.x
        
        if self.param.staticMoveNum>2 then
            self.startPos = Vector3.New(self.param.startPos.x, self.param.startPos.y,self.param.startPos.z)
            self.halfCenterPos = Vector3.New(self.startPos.x+(deltaX/2), self.startPos.y,self.startPos.z)
            self.centerPos =  Vector3.New(self.halfCenterPos.x, self.halfCenterPos.y,self.startPos.z)
        elseif self.param.staticMoveNum>1 then
            self.startPos = Vector3.New(self.param.startPos.x, self.param.startPos.y,self.param.startPos.z)
            self.halfCenterPos = Vector3.New(self.startPos.x-deltaX, self.startPos.y-(deltaY/2),self.startPos.z)
            local y = -350*normalize.y
            self.centerPos =  Vector3.New(self.halfCenterPos.x+x, self.halfCenterPos.y+y,self.startPos.z)
        else
            self.startPos = Vector3.New(self.param.startPos.x, self.param.startPos.y,self.param.startPos.z)
            self.halfCenterPos = Vector3.New(self.startPos.x-deltaX, self.startPos.y+(deltaY/2),self.startPos.z)
            local y = 750*normalize.y
            self.centerPos =  Vector3.New(self.halfCenterPos.x+x, self.halfCenterPos.y+y,self.startPos.z)
        end
    else
        self.lizi.transform.localPosition = Vector3.New(7,self.lizi.transform.localPosition.y,self.lizi.transform.localPosition.z)
        local temp = self.param.distance/960
        if self.param.showTwoBezier~=nil and  self.param.showTwoBezier then
            local y = 410 *normalize.y*temp
            local x = 200 * normalize.x
            self.halfCenterPos =Vector3.New(self.startPos.x+((self.endPos.x-self.startPos.x)*0.6), self.startPos.y+((self.endPos.y-self.startPos.y)*0.6),self.startPos.z)
            self.halfCenterMidPos = Vector3.New(self.startPos.x+((self.endPos.x-self.startPos.x)*0.3), self.startPos.y+((self.endPos.y-self.startPos.y)*0.3)-(y/2),self.startPos.z)
            self.centerPos =  Vector3.New(self.halfCenterPos.x+x, self.halfCenterPos.y+y,self.startPos.z)
        else
            local deltaY = math.random(15,30)*normalize.y
            local deltaX = math.random(15,30)*normalize.x
            self.halfCenterPos =Vector3.New(self.startPos.x-deltaX, self.startPos.y-deltaY,self.startPos.z)
            local y = -230 *normalize.y *temp
            local x = 200 * normalize.x
            self.centerPos =  Vector3.New(self.halfCenterPos.x+x, self.halfCenterPos.y+y,self.startPos.z)
        end
        
        --self.halfCenterPos = Vector3.New(self.startPos.x-deltaX, self.startPos.y+(deltaY*2),self.startPos.z)
        --local curTime = math.floor(UITimeManager:GetInstance():GetServerTime())
        --local y = 450*normalize.y
        --if math.fmod(curTime,2) ~= 0 then
        
        
    end
    
    self.isDoAnim = true
end

local function Update(self)
    if self.isDoAnim then
        self.curTime = self.curTime + Time.deltaTime
        if self.curTime < self.param.stopTime then
            if self.param.showTwoBezier~=nil and  self.param.showTwoBezier then
                local scale = 1.8-(0.6*(self.curTime/self.param.stopTime))
                self.gameObject.transform.localScale = Vector3.New(scale,scale,scale)
                self.gameObject.transform.position = self:GetBezierPoint(self.startPos,self.halfCenterPos,self.halfCenterMidPos,self.curTime/self.param.stopTime)
            else
                if self.param.staticMoveNum~=nil then
                    local tempTime = self.param.stopTime-0.08
                    if self.curTime<=tempTime then
                        self.gameObject.transform.position = Vector3.Lerp(self.startPos,self.halfCenterPos,(self.curTime/tempTime))
                    --else
                    --    self.gameObject.transform.position = Vector3.Lerp(self.startPos,self.halfCenterPos,(self.curTime/self.param.stopTime))
                    end
                else
                    self.gameObject.transform.position = Vector3.Lerp(self.startPos,self.halfCenterPos,self.curTime/self.param.stopTime)
                end
                local scale = 1.8-(0.2*(self.curTime/self.param.stopTime))
                self.gameObject.transform.localScale = Vector3.New(scale,scale,scale)
            end
        elseif self.curTime > self.param.stopTime then
            local tempTime = self.curTime-self.param.stopTime
            if tempTime > self.param.time then
                self.gameObject.transform.position = self:GetBezierPoint(self.halfCenterPos,self.endPos,self.centerPos,tempTime/self.param.time)
                --self.gameObject.transform.position = self.param.startPos
                --self.curTime =0
                self.isDoAnim = false
                if self.param.staticMoveNum~=nil then
                    EventManager:GetInstance():Broadcast(EventId.ShowResourceUpdate,self.param.id)
                end
                self.gameObject:SetActive(false)
                DataCenter.FlyResourceEffectManager:RemoveOneEffect(self.param)
            else
                if self.showLizi==false then
                    self.showLizi =true
                    --self.lizi:SetActive(true)
                end
                local scale = 1.6-(0.8*(tempTime/self.param.time))
                if self.param.showTwoBezier~=nil and  self.param.showTwoBezier then
                    scale = 1.2-(0.4*(tempTime/self.param.time))
                end
                self.gameObject.transform.localScale = Vector3.New(scale,scale,scale)
                self.gameObject.transform.position = self:GetBezierPoint(self.halfCenterPos,self.endPos,self.centerPos,tempTime/self.param.time)
            end
        end
    end
end

local function GetBezierPoint(self,startPos,endPos,centerPos,t)
    
    local a = (1-t)*(1-t)*startPos.x + 2*t*(1-t)*centerPos.x + t*t* endPos.x
    local b = (1-t)*(1-t)*startPos.y + 2*t*(1-t)*centerPos.y + t*t* endPos.y
    local c = (1-t)*(1-t)*startPos.z + 2*t*(1-t)*centerPos.y + t*t* endPos.z
    return Vector3.New(a,b,c)
end



FlyResourceEffect.OnCreate = OnCreate
FlyResourceEffect.OnDestroy = OnDestroy
FlyResourceEffect.ComponentDefine = ComponentDefine
FlyResourceEffect.ComponentDestroy = ComponentDestroy
FlyResourceEffect.DataDefine = DataDefine
FlyResourceEffect.DataDestroy = DataDestroy
FlyResourceEffect.ReInit = ReInit
FlyResourceEffect.ShowPanel = ShowPanel
FlyResourceEffect.Update = Update
FlyResourceEffect.GetBezierPoint =GetBezierPoint
return FlyResourceEffect
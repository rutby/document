--- Created by shimin.
--- DateTime: 2021/7/19 19:19
--- 时间条

local SceneBuildTime = BaseClass("SceneBuildTime")

local time_text_path = "PosGo/Bg/TimeText"
local slider_path = "PosGo/Bg/Slider"
local icon_path = "PosGo/Bg/Icon"
local pos_go_path = "PosGo"

local SliderLength = Vector2.New(1.9, 0.15)

--创建
function SceneBuildTime:OnCreate(go)
    if go ~= nil then
        self.request = go
        self.gameObject = go.gameObject
        self.transform = go.gameObject.transform
    end

    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
function SceneBuildTime:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
end

function SceneBuildTime:ComponentDefine()
    self.time_text = self.transform:Find(time_text_path):GetComponent(typeof(CS.SuperTextMesh))
    self.slider = self.transform:Find(slider_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
    self.icon = self.transform:Find(icon_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
    self.pos_go = self.transform:Find(pos_go_path)
end

function SceneBuildTime:ComponentDestroy()
end


function SceneBuildTime:DataDefine()
    self.param = {}
    self.lastTime = 0
    self.sliderInterVal = 0
    self.curPosition = nil
    self.pos = nil
    self.timeText = nil
    self.precessSize = Vector2.New(SliderLength.x,SliderLength.y)
    self.curSize = Vector2.New(SliderLength.x, SliderLength.y)
    self.showIndex = 1
    self.showListType = {}
    self.waitChangeAlpha = 0
    self.iconName = nil
end

function SceneBuildTime:DataDestroy()
end

function SceneBuildTime:ReInit(paramList)
    self.param = paramList[1]
    self:RefreshActive(true)
    self.curSize = Vector2.New(SliderLength.x, SliderLength.y)
    self.lastTime = 0
    self.time_text:SetColorAlpha(1)
    self.waitChangeAlpha = 0
    self:ShowPanel()
end

function SceneBuildTime:ShowPanel()
    self.iconName = nil
    self.showListType = {}
    self.showIndex = 1
    table.insert(self.showListType, UIBuildTimeTextShowType.Time)
    if self.param.desName ~= nil and self.param.desName ~= "" then
        table.insert(self.showListType, UIBuildTimeTextShowType.Des)
    end
    if self.param.iconName ~= nil then
        self:SetIconSprite(self.param.iconName)
        if self.param.iconScale == nil then
            self.icon.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        else
            self.icon.transform.localScale = self.param.iconScale
        end
    end
    if self.param.position ~= nil then
        self:UpdatePosition(self.param.position)
    end
    if self.param.endTime ~= nil and self.param.startTime ~= nil then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local changeTime = self.param.endTime - curTime
        local maxTime = self.param.endTime - self.param.startTime
        self:RefreshSliderInterVal()
        local tempValue = 1 - changeTime / maxTime
        self:RefreshSlider(tempValue)
        local tempTimeSec = math.ceil(changeTime / 1000)
        if tempTimeSec ~= self.lastTime then
            self.lastTime = tempTimeSec
            self:ShowText()
        end
    end
end

--刷新间隔
function SceneBuildTime:RefreshSliderInterVal()
    if self.param.endTime ~= nil and self.param.startTime ~= nil then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local changeTime = self.param.endTime - curTime
        local temp = changeTime / (SliderLength.x * 2)
        temp = math.modf(temp / 10)
        temp = temp - temp % 5
        self.sliderInterVal = temp * 10
    end
end

--刷新进度条
function SceneBuildTime:RefreshSlider(value)
    if value >= 0 and value <= 1 then
		local newSize_x = self.precessSize.x * value
		if not float_equal(newSize_x, self.curSize.x) then
        	self.curSize.x = newSize_x
        	self.slider:Set_size(self.curSize.x, self.curSize.y)
		end
    end
end


--更新时间条位置
function SceneBuildTime:UpdatePosition(pos)
    if self.pos == nil or self.pos.x ~= pos.x or self.pos.z ~= pos.z  then
        self.pos = pos
        self.transform.position = self.pos + TimePositionDelta
    end
end

function SceneBuildTime:RefreshTime(value)
    if self.lastTime ~= value then
        self.lastTime = value
        self:ShowText()
    end
end

function SceneBuildTime:ChangeShowTime() 
    self.showIndex = self.showIndex + 1
    if table.count(self.showListType) < self.showIndex then
        self.showIndex = 1
    end
end

function SceneBuildTime:ShowText()
    if self.showListType[self.showIndex] == UIBuildTimeTextShowType.Time then
        local tempTimeValue = UITimeManager:GetInstance():MilliSecondToFmtString(self.lastTime * 1000)
        self.time_text.text = tempTimeValue
    elseif self.showListType[self.showIndex] == UIBuildTimeTextShowType.Des then
        self.time_text.text = self.param.desName
    end
end

function SceneBuildTime:RefreshUpdate(isAddAlpha,alphaValue)
    if self.showListType[2] ~= nil then
        if self.isAddAlpha ~= isAddAlpha then
            self.isAddAlpha = isAddAlpha
            if self.isAddAlpha then
                self:ChangeShowTime()
                self:ShowText()
            end
        end
        self.waitChangeAlpha = self.waitChangeAlpha + 1
        if self.waitChangeAlpha > WaitChangeAlphaTime then
            self.waitChangeAlpha = 0
            self.time_text:SetColorAlpha(alphaValue)
        end
    end
end
function SceneBuildTime:SetIconSprite(iconName)
    if self.iconName ~= iconName then
        self.iconName = iconName
        self.icon:LoadSprite(iconName)
    end
end

function SceneBuildTime:GetGuideObj() 
    return self.gameObject
end

function SceneBuildTime:RefreshActive(isActive)
    self.pos_go.gameObject:SetActive(isActive)
end

function SceneBuildTime:CheckIfTimeTipExist(paramList)
    if paramList and #paramList > 0 then
        local tempParam = paramList[1]
        if self.param.model == tempParam.model then
            return true
        end
    end
    return false
end

return SceneBuildTime
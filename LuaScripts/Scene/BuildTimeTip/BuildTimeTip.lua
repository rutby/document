--- Created by shimin.
--- DateTime: 2021/7/19 19:19
--- 时间条

local BuildTimeTip = BaseClass("BuildTimeTip")

local time_text_path = "GameObject/PosGo/TimeText"
local bg_path = "GameObject/PosGo/Bg"
local slider_path = "GameObject/PosGo/Bg/Slider"
local add_speed_btn_path = "GameObject/PosGo/AddSpeedBtn"
--local cost_txt_path = "GameObject/PosGo/AddSpeedBtn/costTxt"
--local confirm_txt_path = "GameObject/PosGo/AddSpeedBtn/confirmTxt"
local icon_bg_path = "GameObject/PosGo/IconBg"
local icon_path = "GameObject/PosGo/IconBg/Icon"
local pos_go_path = "GameObject/PosGo"

local SliderLength2 = Vector2.New(2.59,0.63)
local SliderLength1 = Vector2.New(2.59,0.63)

local IconBgResetScale = Vector3.New(1,1,1)

local BgSpeedPosition = Vector3.New(-0.71,0.499,0)
local BgNoSpeedPosition = Vector3.New(-0.22,0.499,0)

local TimeSpeedPosition = Vector3.New(-0.71,0.4,0)
local TimeNoSpeedPosition = Vector3.New(-0.22,0.4,0)

local FarmBgScale = Vector3.New(1.5,1.5,1.5)
local NormalBgScale = Vector3.New(1.0,1.0,1.0)

local BgFarmPosition = Vector3.New(-1.0,0.499,0)
local BgNormalPosition = Vector3.New(-0.55,0.499,0)

local TimeFarmPosition = Vector3.New(-1.0,0.339,0)
local TimeNormalPosition = Vector3.New(-0.55,0.339,0)

local WaitChangeAlphaTime = 5

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
    self.time_text = self.transform:Find(time_text_path):GetComponent(typeof(CS.SuperTextMesh))
    self.slider = self.transform:Find(slider_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
    self.icon_bg = self.transform:Find(icon_bg_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
    self.icon = self.transform:Find(icon_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
    self.bg = self.transform:Find(bg_path)
    self.add_speed_btn = self.transform:Find(add_speed_btn_path):GetComponent(typeof(CS.UIEventTrigger))
    self.add_speed_btn.onPointerClick = function()
        self:OnAddSpeedClick()
    end
    --self.cost_txt = self.transform:Find(cost_txt_path):GetComponent(typeof(CS.SuperTextMesh))
    --self.confirm_txt = self.transform:Find(confirm_txt_path):GetComponent(typeof(CS.SuperTextMesh))
    self.pos_go = self.transform:Find(pos_go_path)
end

local function ComponentDestroy(self)
    if self.gameObject ~= nil then
        self.add_speed_btn.onPointerClick = nil
        self.add_speed_btn =nil
        --self.cost_txt = nil
        --self.confirm_txt = nil
        self.time_text = nil
        self.slider = nil
        self.icon_bg = nil
        self.icon = nil
        self.bg = nil
        self.pos_go = nil
    end
end


local function DataDefine(self)
    self.param = nil
    self.lastTime = 0
    self.sliderInterVal = 0
    self.curPosition = nil
    self.index = nil
    self.timeText = nil
    self.sliderSpriteSize = nil
    self.desText = nil
    self.costNum = 0
    self.precessSize = Vector2.New(SliderLength1.x,SliderLength1.y)
    self.curSize = nil
    self.showIndex = 1
    self.showListType = {}
    self.waitChangeAlpha = 0
    self.iconName = nil
end

local function DataDestroy(self)
    self.param = nil
    self.lastTime = nil
    self.sliderInterVal = nil
    self.sliderSize = nil
    self.curPosition = nil
    self.index = nil
    self.timeText = nil
    self.sliderSpriteSize = nil
    self.desText = nil
    self.request = nil
    self.precessSize = Vector2.New(SliderLength1.x,SliderLength1.y)
    self.curSize = nil
    self.isShowTime = nil
    self.showIndex = nil
    self.showListType = nil
    self.waitChangeAlpha = nil
    self.iconName = nil
end

local function ReInit(self, paramList)
    local param = paramList[1]
    self:RefreshActive(true)
    self.param = param
    self.curSize = Vector2.New(SliderLength2.x,SliderLength2.y)
    self.lastTime = 0
    self.firstConfirm = false
    self.sendMessage =false
    self.time_text:SetColorAlpha(1)
    self.waitChangeAlpha = 0
    self:ShowPanel()
end

local function ShowPanel(self)
    self.iconName = nil
    self.showListType = {}
    self.showIndex = 1
    table.insert(self.showListType, UIBuildTimeTextShowType.Time)
    if self.param.desName ~= nil and self.param.desName ~= "" then
        table.insert(self.showListType, UIBuildTimeTextShowType.Des)
    end
    if self.param.showGold ~= nil and self.param.showGold == true then
        self.add_speed_btn.gameObject:SetActive(true)
        if self.param.tiles == BuildTilesSize.One then
            self.bg.transform.localScale = FarmBgScale / 2
            self.bg.transform.localPosition = BgSpeedPosition
            self.time_text.transform.localPosition = TimeSpeedPosition
        else
            self.bg.transform.localScale = FarmBgScale
            self.bg.transform.localPosition = BgFarmPosition
            self.time_text.transform.localPosition = TimeFarmPosition
        end
    else
        self.add_speed_btn.gameObject:SetActive(false)
        if self.param.tiles == BuildTilesSize.One then
            self.bg.transform.localScale = NormalBgScale / 2
            self.bg.transform.localPosition = BgNoSpeedPosition
            self.time_text.transform.localPosition = TimeNoSpeedPosition
        else
            self.bg.transform.localScale = NormalBgScale
            self.bg.transform.localPosition = BgNormalPosition
            self.time_text.transform.localPosition = TimeNormalPosition
        end
    end

    if self.param.iconBg == nil then
        self.icon_bg.gameObject:SetActive(false)
    else
        self.icon_bg:LoadSprite(self.param.iconBg)
        Logger.Log("time icon", self.param.iconBg)
        if self.param.iconBgScale == nil then
            self.icon_bg.transform.localScale = IconBgResetScale
        else
            if self.param.tiles == BuildTilesSize.One then
                self.icon_bg.transform.localScale = (self.param.iconBgScale / 2)
            else
                self.icon_bg.transform.localScale = self.param.iconBgScale
            end
        end
        self.icon_bg.gameObject:SetActive(true)
    end

    if self.param.iconName == nil then
        self.icon.gameObject:SetActive(false)
    else
        self:SetIconSprite(self.param.iconName)
        if self.param.iconScale == nil then
            self.icon.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        else
            self.icon.transform.localScale = self.param.iconScale
        end
        self.icon.gameObject:SetActive(true)
    end
    --self.confirm_txt.text = Localization:GetString(GameDialogDefine.AGAIN_CONFIRM)
    --self.confirm_txt.gameObject:SetActive(self.firstConfirm)
    if self.param.pos ~= nil then
        self:UpdatePosition(self.param.pos)
    end
    if self.param.endTime ~= nil and self.param.startTime ~= nil then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local changeTime = self.param.endTime - curTime
        --if self.param.showGold~=nil and self.param.showGold == true then
        --    self:CheckGoldNum(changeTime)
        --end
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
local function RefreshSliderInterVal(self)
    if self.param.endTime ~= nil and self.param.startTime ~= nil then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local changeTime = self.param.endTime - curTime
        local temp = changeTime / (SliderLength2.x * 2)
        temp = math.modf(temp / 10)
        temp = temp - temp % 5
        self.sliderInterVal = temp * 10
    end
end

--刷新进度条
local function RefreshSlider(self,value)
    if value >= 0 and value <= 1 then
		local newSize_x = self.precessSize.x * value
		if not float_equal(newSize_x, self.curSize.x) then
        	self.curSize.x = newSize_x
        	self.slider:Set_size(self.curSize.x, self.curSize.y)
            --self.slider.size = self.curSize
		end
    end
end


--更新时间条位置
local function UpdatePosition(self,index)
    if self.index ~= index then
        self.index = index
        if self.param.tiles == BuildTilesSize.One then
            self.precessSize.x = SliderLength1.x
            self.precessSize.y = SliderLength1.y
        elseif self.param.tiles == BuildTilesSize.Two then
            self.precessSize.x = SliderLength2.x
            self.precessSize.y = SliderLength2.y
        elseif self.param.tiles == BuildTilesSize.Three then
            self.precessSize.x = SliderLength2.x
            self.precessSize.y = SliderLength2.y
        else
            self.precessSize.x = SliderLength2.x
            self.precessSize.y = SliderLength2.y
        end
        local worldPos = BuildingUtils.GetBuildModelDownVec(index, self.param.tiles)
        self.transform:Set_position(worldPos.x, worldPos.y, worldPos.z)
    end
end

local function RefreshTime(self,value)
    if self.lastTime ~= value then
        self.lastTime = value
        self:ShowText()
    end
end

local function OnAddSpeedClick(self)
    if self.param.queueUuid ~=nil then
        local guideParam = {}
        guideParam.buildTimeType = self.param.buildTimeType
        DataCenter.GuideManager:SetCompleteNeedParam(guideParam)
        DataCenter.GuideManager:CheckGuideComplete()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UISpeedUpConfirm, self.param.endTime, self.param.iconName, MsgDefines.QueueCcdMNew, self.param.queueUuid, self.param.speedItem)
    end
end

--local function CheckGoldNum(self,curTime)
--    local remainSec = curTime/1000
--    local num = CommonUtil.GetTimeDiamondCost(remainSec)
--    if num~= self.costNum then
--        self.costNum = num
--        self.cost_txt.text = self.costNum
--    end
--end

local function ChangeShowTime(self) 
    self.showIndex = self.showIndex + 1
    if table.count(self.showListType) < self.showIndex then
        self.showIndex = 1
    end
end

local function ShowText(self)
    if self.showListType[self.showIndex] == UIBuildTimeTextShowType.Time then
        local tempTimeValue = UITimeManager:GetInstance():MilliSecondToFmtString(self.lastTime * 1000)
        if self.lastTime <= 0  then
            self:SetIconSprite(string.format(LoadPath.UIBuildBubble,BuildBubbleIconName.NoGetResource))
        end
        self.time_text.text = tempTimeValue
    elseif self.showListType[self.showIndex] == UIBuildTimeTextShowType.Des then
        self.time_text.text = self.param.desName
    end
end

local function RefreshUpdate(self,isAddAlpha,alphaValue)
    if table.count(self.showListType) > 1 then
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
local function SetIconSprite(self,iconName)
    if self.iconName ~= iconName then
        self.iconName = iconName
        self.icon:LoadSprite(iconName)
    end
end

local function GetGuideObj(self) 
    return self.add_speed_btn.gameObject
end

local function RefreshActive(self,isActive)
    self.pos_go.gameObject:SetActive(isActive)
end

local function CheckIfTimeTipExist(self, paramList)
    if paramList and #paramList > 0 then
        local tempParam = paramList[1]
        if self.param.model == tempParam.model then
            return true
        end
    end
    return false
end


BuildTimeTip.OnCreate = OnCreate
BuildTimeTip.OnDestroy = OnDestroy
BuildTimeTip.ComponentDefine = ComponentDefine
BuildTimeTip.ComponentDestroy = ComponentDestroy
BuildTimeTip.DataDefine = DataDefine
BuildTimeTip.DataDestroy = DataDestroy
BuildTimeTip.ReInit = ReInit
BuildTimeTip.ShowPanel = ShowPanel
BuildTimeTip.RefreshSlider = RefreshSlider
BuildTimeTip.UpdatePosition = UpdatePosition
BuildTimeTip.RefreshSliderInterVal = RefreshSliderInterVal
BuildTimeTip.RefreshTime = RefreshTime
BuildTimeTip.OnAddSpeedClick = OnAddSpeedClick
--BuildTimeTip.CheckGoldNum = CheckGoldNum
BuildTimeTip.ShowText = ShowText
BuildTimeTip.ChangeShowTime = ChangeShowTime
BuildTimeTip.RefreshUpdate = RefreshUpdate
BuildTimeTip.SetIconSprite = SetIconSprite
BuildTimeTip.GetGuideObj = GetGuideObj
BuildTimeTip.RefreshActive = RefreshActive
BuildTimeTip.CheckIfTimeTipExist = CheckIfTimeTipExist

return BuildTimeTip
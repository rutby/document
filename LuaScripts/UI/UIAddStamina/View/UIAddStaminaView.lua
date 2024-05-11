---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/2/17 11:26
---
local UIAddStaminaView = BaseClass("UIAddStaminaView",UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local title_path = "UICommonMidPopUpTitle/bg_mid/titleText"
local des_path = "ImgBg/desTxt"
local return_btn_path = "UICommonMidPopUpTitle/panel"
local close_btn_path = "UICommonMidPopUpTitle/bg_mid/CloseBtn"
local gray_img_path = "Gray"
local use_txt_path = "ImgBg/BuyBtn/BuyText"
local use_btn_path ="ImgBg/BuyBtn"
local slider_path = "ImgBg/Slider"
local slider_txt_path = "ImgBg/sliderText"
local cd_txt_path = "ImgBg/BuyBtn/cdText"
local tip_txt_path = "ImgBg/tipText"
local function OnCreate(self)
    base.OnCreate(self)
    self.bUuid = self:GetUserData()
    self.title = self:AddComponent(UITextMeshProUGUIEx,title_path)
    self.title:SetLocalText(141083)
    self.slider = self:AddComponent(UISlider, slider_path)
    self.slider_txt = self:AddComponent(UIText, slider_txt_path)
    self.use_txt = self:AddComponent(UIText,use_txt_path)
    self.cd_txt = self:AddComponent(UIText,cd_txt_path)
    self.des = self:AddComponent(UIText,des_path)
    self.tip_txt = self:AddComponent(UIText,tip_txt_path)
    self.btn_image = self:AddComponent(UIImage, use_btn_path)
    self.use_btn = self:AddComponent(UIButton, use_btn_path)
    self.use_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnRepairClick()
    end)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.return_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    local gray_img = self:AddComponent(UIImage, gray_img_path)
    self.gray = gray_img:GetMaterial()
    self.timer_action = function()
        self:UpdateTime()
    end
    self.maxHp = 0
    self.info = CS.SceneManager.World:GetPointInfoByUuid(self.bUuid)
    self.cdEndTime = 0
    self.isInCD = false
    self.isRecover = false
    self.recoverSpeed = 0
    self.recoverCost = 0
end

local function UpdateTime(self)
    if self.isRecover then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        if self.info~=nil then
            local deltaTime = curTime / 1000 - self.info.lastHpTime
            local realBlood = math.min(deltaTime * self.recoverSpeed + self.info.curHp, self.maxHp)
            local deltaBlood = self.maxHp - realBlood
            if deltaBlood>0 then
                local percent = math.min((1-(deltaBlood/self.maxHp)),1)
                self.slider:SetValue(percent)
                self.slider_txt:SetText(string.GetFormattedSeperatorNum(math.floor(realBlood)).."/"..string.GetFormattedSeperatorNum(math.floor(self.maxHp)))
                self.isRecover = true
            else
                deltaBlood = 0
                self.isRecover = false
                self.slider:SetValue(1)
                self.slider_txt:SetText(string.GetFormattedSeperatorNum(math.floor(self.maxHp)).."/"..string.GetFormattedSeperatorNum(math.floor(self.maxHp)))
            end
        end
    end
    if self.isInCD then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local deltaTime = self.cdEndTime - curTime
        if deltaTime >0 then
            self.cd_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
        else
			self.isInCD =false
            self.cd_txt:SetActive(false)
            self.use_txt:SetActive(true)
            self.btn_image:SetMaterial(nil)
        end
    end
    if self.isInCD==false and self.isRecover == false then
        self:DeleteTimer()
    end
end

local function OnDestroy(self)
    self:DeleteTimer()
    self.title = nil
    self.des = nil
    self.use_txt = nil
    self.use_btn = nil
    self.close_btn = nil
    self.return_btn = nil

    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
    self:InitButtonState()
end

local function OnDisable(self)
    self:DeleteTimer()
    base.OnDisable(self)
end

local function InitButtonState(self)
    if self.info==nil then
        return
    end
    local cdDeltaTime = LuaEntry.DataConfig:TryGetNum("building_attack", "k4")
    local recoverSpeed = LuaEntry.DataConfig:TryGetNum("building_attack", "k2")
    self.recoverSpeed = recoverSpeed
    local recoverCost =  LuaEntry.DataConfig:TryGetNum("building_attack", "k3")
    self.recoverCost = recoverCost
    local recoverNum = LuaEntry.DataConfig:TryGetNum("building_attack", "k6")
    self.des:SetText(Localization:GetString("141082",string.GetFormattedSeperatorNum(math.floor(recoverCost)),string.GetFormattedSeperatorNum(math.floor(recoverNum))))
    self.use_txt:SetText(string.GetFormattedSeperatorNum(math.floor(recoverCost)))
    self.tip_txt:SetText(Localization:GetString("121214",(recoverSpeed*60)))
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.info.uuid)
    if buildData~=nil then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.info.itemId,self.info.level)
        if buildLevelTemplate~=nil then
            self.maxHp = buildLevelTemplate:GetMaxHp()
            if self.maxHp > self.info.curHp then
                local deltaTime = curTime / 1000 - self.info.lastHpTime
                local realBlood = math.min(deltaTime * recoverSpeed + self.info.curHp, self.maxHp)
                local deltaBlood = self.maxHp - realBlood
                if deltaBlood>0 then
                    local percent = math.min((1-(deltaBlood/self.maxHp)),1)
                    self.slider:SetValue(percent)
                    self.slider_txt:SetText(string.GetFormattedSeperatorNum(math.floor(realBlood)).."/"..string.GetFormattedSeperatorNum(math.floor(self.maxHp)))
                    self.isRecover = true
                else
                    deltaBlood = 0
                    self.isRecover = false
                    self.slider:SetValue(1)
                    self.slider_txt:SetText(string.GetFormattedSeperatorNum(math.floor(self.maxHp)).."/"..string.GetFormattedSeperatorNum(math.floor(self.maxHp)))
                end
            else
                self.isRecover = false
                self.slider:SetValue(1)
                self.slider_txt:SetText(string.GetFormattedSeperatorNum(math.floor(self.maxHp)).."/"..string.GetFormattedSeperatorNum(math.floor(self.maxHp)))
            end
        end
        local endTime = buildData.lastCashCdTime + (cdDeltaTime*1000)
        if endTime>curTime then
            self.isInCD = true
            self.cdEndTime = endTime
            self.cd_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(endTime-curTime))
            self.btn_image:SetMaterial(self.gray)
        else
            self.isInCD = false
            self.btn_image:SetMaterial(nil)
        end
        self.cd_txt:SetActive(self.isInCD)
        self.use_txt:SetActive(self.isInCD==false)
    end
    if self.isInCD==true or self.isRecover == true then
        self:AddTimer()
        self:UpdateTime()
    end
end


local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.ShowIsOnFire, self.OnCheckStamina)

end
local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.ShowIsOnFire,self.OnCheckStamina)
end

local function OnCheckStamina(self,data)
    local uuid = tonumber(data)
    if self.bUuid == uuid then
        self.maxHp = 0
        self.info = CS.SceneManager.World:GetPointInfoByUuid(self.bUuid)
        self.cdEndTime = 0
        self.isInCD = false
        self.isRecover = false
        self.recoverSpeed = 0
        self:InitButtonState()
    end
end  
local function AddTimer(self)
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action , self, false,false,false)
    end
    self.timer:Start()
end

local function DeleteTimer(self)
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

local function OnRepairClick(self)
    if  self.isInCD ==false then
        local gold = LuaEntry.Resource:GetCntByResType(ResourceType.Money)
        if gold < self.recoverCost then
            UIUtil.ShowTipsId(120450)
            return
        end
        SFSNetwork.SendMessage(MsgDefines.UserRecoverBuildingStamina,self.bUuid)
        self.ctrl:CloseSelf()
    end
end
UIAddStaminaView.OnCreate = OnCreate
UIAddStaminaView.OnDestroy = OnDestroy
UIAddStaminaView.InitButtonState = InitButtonState
UIAddStaminaView.OnEnable = OnEnable
UIAddStaminaView.OnDisable = OnDisable
UIAddStaminaView.UpdateTime = UpdateTime
UIAddStaminaView.AddTimer =AddTimer
UIAddStaminaView.DeleteTimer = DeleteTimer
UIAddStaminaView.OnRepairClick =OnRepairClick
UIAddStaminaView.OnAddListener = OnAddListener
UIAddStaminaView.OnRemoveListener =OnRemoveListener
UIAddStaminaView.OnCheckStamina = OnCheckStamina
return UIAddStaminaView
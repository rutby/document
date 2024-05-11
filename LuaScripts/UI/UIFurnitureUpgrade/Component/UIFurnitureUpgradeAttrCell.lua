--- Created by shimin.
--- DateTime: 2023/11/7 19:11
--- 升级界面家具升级家具属性cell
local UIFurnitureUpgradeAttrCell = BaseClass("UIPveBuffCell", UIBaseContainer)
local base = UIBaseContainer
local UIHeroTipsView = require "UI.UIHeroTips.View.UIHeroTipsView"

local this_path = ""
local des_text_path = "des_text"
local layout_go_path = "layout_go"
local cur_text_path = "layout_go/cur_text"
local add_text_path = "layout_go/add_text"
local icon_path = "layout_go/icon_go/icon"
local special_go_path = "layout_go/special_go"
local slider_path = "slider"
local slider_text_path = "slider/slider_text"

local SliderLength = 555
local SliderNumChangeTime = 1000--1秒一变

function UIFurnitureUpgradeAttrCell:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIFurnitureUpgradeAttrCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIFurnitureUpgradeAttrCell:ComponentDefine()
    self.icon_btn = self:AddComponent(UIButton, this_path)
    self.icon_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnIconBtnClick()
    end)
    self.icon = self:AddComponent(UIImage, icon_path)
    self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
    self.layout_go = self:AddComponent(UIBaseContainer, layout_go_path)
    self.cur_text = self:AddComponent(UITextMeshProUGUIEx, cur_text_path)
    self.add_text = self:AddComponent(UITextMeshProUGUIEx, add_text_path)
    self.special_go = self:AddComponent(UIBaseContainer, special_go_path)
    self.slider = self:AddComponent(UISlider, slider_path)
    self.slider_text = self:AddComponent(UITextMeshProUGUIEx, slider_text_path)
end

function UIFurnitureUpgradeAttrCell:ComponentDestroy()
end

function UIFurnitureUpgradeAttrCell:DataDefine()
    self.param = {}
    self.startTime = 0
    self.endTime = 0
    self.lastTime = 0
    self.lastCurTime = 0
end

function UIFurnitureUpgradeAttrCell:DataDestroy()
    self.param = {}
    self.startTime = 0
    self.endTime = 0
    self.lastTime = 0
    self.lastCurTime = 0
end

function UIFurnitureUpgradeAttrCell:OnEnable()
    base.OnEnable(self)
end

function UIFurnitureUpgradeAttrCell:OnDisable()
    base.OnDisable(self)
end

function UIFurnitureUpgradeAttrCell:OnAddListener()
    base.OnAddListener(self)
end

function UIFurnitureUpgradeAttrCell:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIFurnitureUpgradeAttrCell:ReInit(param)
    self.param = param
    self:Refresh()
end


function UIFurnitureUpgradeAttrCell:Refresh()
    if self.param.visible then
        self:SetActive(true)
        self.icon:LoadSprite(self.param.icon)
        self.des_text:SetText(self.param.name)
        if self.param.special ~= nil then
            self.cur_text:SetActive(true)
            self.cur_text:SetText(self.param.curValue)
            self.add_text:SetActive(false)
            self.special_go:SetActive(true)
        else
            self.special_go:SetActive(false)
            if self.param.curValue == "" then
                self.cur_text:SetActive(false)
            else
                self.cur_text:SetActive(true)
                self.cur_text:SetText(self.param.curValue)
            end
  
            if self.param.addValue == "" then
                self.add_text:SetActive(false)
            else
                self.add_text:SetActive(true)
                self.add_text:SetText(self.param.addValue)
            end
        end
        self:RefreshTime()
    else
        self:SetActive(false)
    end
end

function UIFurnitureUpgradeAttrCell:OnIconBtnClick()
    if self.param.special ~= nil then
        if self.param.special == FurnitureSpecialType.Dining then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIRestaurantChooseFood, NormalBlurPanelAnim)
        end
    else
        local param = {}
        param.title = self.param.clickName
        param.content = self.param.clickDes
        param.dir = UIHeroTipsView.Direction.ABOVE
        param.defWidth = 300
        param.pivot = 0.5
        param.position = self.icon.transform.position + Vector3.New(0, 20, 0)
        param.bindObject = self.gameObject
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTips, { anim = false }, param)
    end
end

function UIFurnitureUpgradeAttrCell:Update()
    if self.endTime ~= 0 then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local changeTime = self.endTime - curTime
        local maxTime = self.endTime - self.startTime
        local pro = (curTime - self.startTime) / maxTime
        if pro >= 1 then
            self.slider:SetActive(false)
            self.endTime = 0
        else
            if TimeBarUtil.CheckIsNeedChangeBar(changeTime, self.endTime - self.lastCurTime, maxTime, SliderLength) then
                self.lastCurTime = curTime
                self.slider:SetValue(pro)
            end

            if curTime >= self.lastTime then
                self.lastTime = curTime + SliderNumChangeTime
                self.slider_text:SetText(math.floor(pro * 100) .. "%")
            end
        end
    end
end

function UIFurnitureUpgradeAttrCell:RefreshTime()
    if self.param.fUuid ~= nil then
        local productParam = DataCenter.FurnitureProductManager:GetFurnitureProductByUuid(self.param.fUuid)
        if productParam ~= nil and productParam.endTime > 0 then
            if productParam.stopTime ~= 0 and productParam.stopTime < productParam.endTime then
                local pro = (productParam.stopTime - productParam.startTime) / (productParam.endTime - productParam.startTime)
                self.slider:SetValue(pro)
                self.slider_text:SetText(math.floor(pro * 100) .. "%")
                self.endTime = 0
                self.startTime = 0
                self.lastTime = 0
                self.lastCurTime = 0
                self.slider:SetActive(true)
            else
                self.endTime = productParam.endTime
                self.startTime = productParam.startTime
                self.lastTime = 0
                self.lastCurTime = 0
                self.slider:SetActive(true)
            end
        else
            self.startTime = 0
            self.endTime = 0
            self.slider:SetActive(false)
        end
    else
        self.startTime = 0
        self.endTime = 0
        self.slider:SetActive(false)
    end
end


return UIFurnitureUpgradeAttrCell
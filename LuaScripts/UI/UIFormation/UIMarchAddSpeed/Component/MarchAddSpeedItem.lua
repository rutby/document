---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/3/14 10:48
---
local MarchAddSpeedItem = BaseClass("MarchAddSpeedItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local icon_path = "UICommonItem/clickBtn/ItemIcon"
local extra_text_path = "UICommonItem/clickBtn/FlagGo/FlagText"
local extra_path = "UICommonItem/clickBtn/FlagGo"
local item_quality_path = "UICommonItem/clickBtn/ImgQuality"
local num_txt_path = "UICommonItem/clickBtn/NumText"
local name_text_path = "NameText"
local layout_path = "layout"
local slider_obj_path = "sliderObj"
local slider_path = "sliderObj/Slider"
local slider_des_path = "sliderObj/sliderDes"
local slider_num_path = "sliderObj/totalNum"
local des_text_path = "layout/DesText"
local own_text_path = "layout/OwnText"
local use_btn_path = "UseBtn"
local use_btn_name_path = "UseBtn/UseBtnName"

-- 创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
local function OnDestroy(self)
    self:DeleteTimer()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

-- 显示
local function OnEnable(self)
    base.OnEnable(self)
end

-- 隐藏
local function OnDisable(self)
    base.OnDisable(self)
end


--控件的定义
local function ComponentDefine(self)
    self.icon = self:AddComponent(UIImage, icon_path)
    self.extra_text = self:AddComponent(UITextMeshProUGUIEx, extra_text_path)
    self.extra = self:AddComponent(UITextMeshProUGUIEx, extra_path)
    self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
    self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
    self.own_text = self:AddComponent(UITextMeshProUGUIEx, own_text_path)
    self.use_btn = self:AddComponent(UIButton, use_btn_path)
    self.use_btn_name = self:AddComponent(UITextMeshProUGUIEx, use_btn_name_path)
    self.item_quality_img = self:AddComponent(UIImage, item_quality_path)
    self.num_txt = self:AddComponent(UITextMeshProUGUIEx,num_txt_path)
    self.use_btn:SetOnClick(function()
        self:OnUseBtnClick()
    end)
    self.layout = self:AddComponent(UIBaseContainer, layout_path)
    self.slider_obj = self:AddComponent(UIBaseContainer,slider_obj_path)
    self.slider = self:AddComponent(UISlider, slider_path)
    self.slider_des = self:AddComponent(UITextMeshProUGUIEx, slider_des_path)
    self.total_num = self:AddComponent(UITextMeshProUGUIEx, slider_num_path)
    
    self.timer_action = function(temp)
        self:RefreshTime()
    end
end

--控件的销毁
local function ComponentDestroy(self)
    self.icon = nil
    self.extra_text = nil
    self.extra = nil
    self.name_text = nil
    self.des_text = nil
    self.own_text = nil
    self.num_txt = nil
    self.use_btn = nil
    self.use_btn_name = nil
    self.item_quality_img = nil
end

--变量的定义
local function DataDefine(self)
    self.param = {}
    self.callUse = nil
end

--变量的销毁
local function DataDestroy(self)
    self.param = nil
end

-- 全部刷新
local function SetItemShow(self,param)
    self.itemId = 0
    self.useType = param.type
    if self.useType == "Free" then
        self.layout:SetActive(true)
        self.slider_obj:SetActive(false)
        self.param = param.data
        self.use_btn:LoadSprite(string.format(LoadPath.CommonNewPath,"Common_btn_green101"))
        self.itemId = self.param.itemId
        local template = DataCenter.ItemTemplateManager:GetItemTemplate(self.itemId)
        if template ~= nil then
            if template.para ~= nil and template.para ~= "" then
                local para = tonumber(template.para)
                if para > 0 then
                    self.extra:SetActive(true)
                    self.extra_text:SetText(string.GetFormattedStr(para))
                else
                    self.extra:SetActive(false)
                end
            end
            self.icon:LoadSprite(string.format(LoadPath.ItemPath,template.icon))
            self.name_text:SetText(DataCenter.ItemTemplateManager:GetName(template.id))
            self.des_text:SetText(DataCenter.ItemTemplateManager:GetDes(template.id))
            self.item_quality_img:LoadSprite(DataCenter.ItemTemplateManager:GetToolBgByColor(template.color))
            self.own_text:SetActive(false)
            --self.own_text:SetText(Localization:GetString("100100")..param.info.data.count)
            self.num_txt:SetActive(true)
            self.num_txt:SetText(self.param.count)
            self.use_btn:SetActive(true)
            self.use_btn_name:SetLocalText(110046)
        end
    elseif self.useType == "Build" then
        self.layout:SetActive(false)
        self.slider_obj:SetActive(true)
        self.extra:SetActive(false)
        self.icon:LoadSprite(string.format(LoadPath.ItemPath, "icon_nitrogen"))
        self.item_quality_img:LoadSprite(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.GREEN))
        self.name_text:SetLocalText(143677)
        local needNum = LuaEntry.DataConfig:TryGetNum("march_nitrogen", "k1")
        local k2 = LuaEntry.DataConfig:TryGetNum("march_nitrogen", "k2")
        local addRate = k2-1
        self.slider_des:SetText(Localization:GetString("143681",needNum,string.GetFormattedPercentStr(addRate)))
        self.use_btn:SetActive(true)
        self.use_btn_name:SetLocalText(110046)
        self:AddTimer()
        self:RefreshTime()
        
    end
    
end

local function OnUseBtnClick(self)
    if self.view.isSendMsg == true then
        return
    end
    if self.useType == "Free" then
        if self.itemId == 0 then
            UIUtil.ShowTipsId(104216)
        elseif self.itemId~=nil and self.itemId~=0 then
            local good = DataCenter.ItemData:GetItemById(self.itemId)
            local num = good and good.count or 0
            if num<=0 then
                UIUtil.ShowTipsId(320821)
            else
                local canUse = false
                local marchData = self.view.ctrl:GetMarchData(self.view.marchUuid)
                if marchData~=nil then
                    if marchData.status == MarchStatus.CHASING or marchData.status == MarchStatus.MOVING or marchData.status == MarchStatus.BACK_HOME then
                        canUse = true
                    end
                end
                if canUse ==false then
                    UIUtil.ShowTipsId(320824)
                else
                    if good==nil then
                        UIUtil.ShowTipsId(320824)
                    end
                    local uuid = self.view.marchUuid
                    local goodsUuid = good.uuid
                    SFSNetwork.SendMessage(MsgDefines.ItemUse, { uuid = goodsUuid, num = 1, useItemFromType = 0, marchUuid = uuid })
                    self.view:SetIsOnMsgSend()
                end
            end
        end
    elseif self.useType == "Build" then
        local canUse = false
        local marchData = self.view.ctrl:GetMarchData(self.view.marchUuid)
        if marchData~=nil then
            if marchData.status == MarchStatus.CHASING or marchData.status == MarchStatus.MOVING or marchData.status == MarchStatus.BACK_HOME then
                canUse = true
            end
        end
        if canUse ==false then
            UIUtil.ShowTipsId(320824)
        else
            local curNum = LuaEntry.Player:GetCurNitrogen()
            local needNum = LuaEntry.DataConfig:TryGetNum("march_nitrogen", "k1")
            if curNum<needNum then
                UIUtil.ShowTipsId(143680)
            else
                local uuid = self.view.marchUuid
                SFSNetwork.SendMessage(MsgDefines.SpeedUpMarchNitrogen,uuid)
                self.view:SetIsOnMsgSend()
            end
        end
        
        
    end
    
end

local function RefreshOwnCount(self,count)
    self.param.count = count
    --self.own_text:SetText(Localization:GetString("100100")..count)
    self.num_txt:SetText(count)
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

local function RefreshTime(self)
    if self.useType == "Build" then
        local curNum = LuaEntry.Player:GetCurNitrogen()
        local maxNum = LuaEntry.Player:GetMaxNitrogen()
        local percent = math.min((curNum/math.max(1,maxNum)),1)
        self.slider:SetValue(percent)
        self.total_num:SetText(string.GetFormattedSeperatorNum(math.floor(curNum)).."/"..string.GetFormattedSeperatorNum(math.floor(maxNum)))
    end
end
MarchAddSpeedItem.OnCreate = OnCreate
MarchAddSpeedItem.OnDestroy = OnDestroy
MarchAddSpeedItem.OnEnable = OnEnable
MarchAddSpeedItem.OnDisable = OnDisable
MarchAddSpeedItem.ComponentDefine = ComponentDefine
MarchAddSpeedItem.ComponentDestroy = ComponentDestroy
MarchAddSpeedItem.DataDefine = DataDefine
MarchAddSpeedItem.DataDestroy = DataDestroy
MarchAddSpeedItem.SetItemShow = SetItemShow
MarchAddSpeedItem.OnUseBtnClick = OnUseBtnClick
MarchAddSpeedItem.RefreshOwnCount = RefreshOwnCount
MarchAddSpeedItem.AddTimer = AddTimer
MarchAddSpeedItem.DeleteTimer = DeleteTimer
MarchAddSpeedItem.RefreshTime = RefreshTime
return MarchAddSpeedItem
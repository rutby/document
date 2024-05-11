local StaminaItem = BaseClass("StaminaItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local icon_path = "UICommonItem/clickBtn/ItemIcon"
local extra_text_path = "UICommonItem/clickBtn/FlagGo/FlagText"
local extra_path = "UICommonItem/clickBtn/FlagGo"
local item_quality_path = "UICommonItem/clickBtn/ImgQuality"
local num_txt_path = "UICommonItem/clickBtn/NumText"
local name_text_path = "NameText"
local des_text_path = "layout/DesText"
local own_text_path = "layout/OwnText"

local buy_btn_path = "BuyBtn"
local buy_btn_name_path = "BuyBtn/BuyBtnLabel/BuyBtnName"
local buy_btn_count_path = "BuyBtn/BuyBtnLabel/BuyBtnValue"
local buy_btn_icon_path = "BuyBtn/BuyBtnLabel/BuyBtnValue/SpendIcon"
local use_btn_path = "UseBtn"
local use_btn_name_path = "UseBtn/UseBtnName"
local use_btn_lock_path = "UseBtn/Img_lock"
local more_btn_go_path = "MoreBtnGo"
local buy_tips_path = "BuyBtn/PercentBg"
local buy_tipsTxt_path = "BuyBtn/PercentBg/Percent"

-- 创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
local function OnDestroy(self)
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
    self.buy_btn = self:AddComponent(UIButton, buy_btn_path)
    self.buy_btn_name = self:AddComponent(UITextMeshProUGUIEx, buy_btn_name_path)
    self.buy_btn_count = self:AddComponent(UITextMeshProUGUIEx, buy_btn_count_path)
    self.buy_btn_icon = self:AddComponent(UIImage, buy_btn_icon_path)
    self.use_btn = self:AddComponent(UIButton, use_btn_path)
    self.use_btn_name = self:AddComponent(UITextMeshProUGUIEx, use_btn_name_path)
    self.use_btn_lock = self:AddComponent(UIImage,use_btn_lock_path)
    self.more_btn_go = self:AddComponent(UIBaseContainer, more_btn_go_path)
    self.item_quality_img = self:AddComponent(UIImage, item_quality_path)
    self.num_txt = self:AddComponent(UITextMeshProUGUIEx,num_txt_path)
    self.buy_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnBuyBtnClick()
    end)

    self.use_btn:SetOnClick(function()
        self:OnUseBtnClick()
    end)
    
    self.buy_tips = self:AddComponent(UIBaseContainer,buy_tips_path)
    self.buy_tipsTxt = self:AddComponent(UITextMeshProUGUIEx,buy_tipsTxt_path)
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
    self.buy_btn = nil
    self.buy_btn_name = nil
    self.buy_btn_count = nil
    self.buy_btn_icon = nil
    self.use_btn = nil
    self.use_btn_name = nil
    self.use_btn_lock = nil
    self.more_btn_go = nil
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
local function ReInit(self,param)
    self.buy_tips:SetActive(false)
    self.itemId = 0
    self.isLock = true
    self.param = param
    self.costGoldNum = 0
    self.recoverNum  = 0
    if self.param.info.type == "Gold" then
        self.extra:SetActive(false)
        self.name_text:SetText(Localization:GetString("104217"))
        self.buy_btn_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold))
        self.icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.FORMATION_STAMINA))
        self.item_quality_img:LoadSprite(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE))
        self:RefreshGoldData()
    else
        self.use_btn:LoadSprite(string.format(LoadPath.CommonNewPath,"Common_btn_green101"))
        self.use_btn_lock:SetActive(false)
        self.itemId = self.param.info.data.itemId
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
            self.num_txt:SetText(param.info.data.count)
            self.buy_btn:SetActive(false)
            self.use_btn:SetActive(true)
            self.use_btn_name:SetLocalText(110046)
        end
    end
end

local function RefreshGoldData(self)
    if self.param.info.type == "Gold" then
        self.isLock = true
        self.costGoldNum = 0
        self.recoverNum  = 0
        local goldStr = LuaEntry.DataConfig:TryGetStr("role_stamina", "k1")
        local strArr = string.split(goldStr,"|")
        local useCount = LuaEntry.Player:GetCurStaminaGoldNum()

        if #strArr>0 then
            local index = math.min(useCount+1,(#strArr))
            local str = strArr[index ]
            local arr = string.split(str,";")
            if #arr>=2 then
                self.isLock = false
                self.costGoldNum = tonumber(arr[1])
                self.recoverNum  = tonumber(arr[2])
            end
            self.buy_tips:SetActive(index == 1)
            self.buy_tipsTxt:SetLocalText(320556)
        end
        self.des_text:SetText(Localization:GetString("104218",self.recoverNum))

        if self.isLock then
            self.buy_btn:SetActive(false)
            self.use_btn:SetActive(true)
            self.use_btn_name:SetText("")
            self.use_btn_lock:SetActive(true)
            self.use_btn:LoadSprite(string.format(LoadPath.CommonNewPath,"Common_btn_yellow101"))
        else
            self.use_btn_lock:SetActive(false)
            self.own_text:SetActive(false)
            self.num_txt:SetActive(false)
            self.buy_btn:SetActive(true)
            self.use_btn:SetActive(false)
            self.buy_btn_name:SetLocalText(110001)
            self.buy_btn_count:SetText(string.GetFormattedSeperatorNum(self.costGoldNum))
            CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.buy_btn.rectTransform)
            self:RefreshColor(LuaEntry.Player.gold)
        end
    end
end
local function OnBuyBtnClick(self)
    if self.isLock == true then
        UIUtil.ShowTipsId(104216)
    else
        if self.param.callBack ~= nil then
            local isBuy = true
            self.param.callBack(self.param.index,nil,isBuy,self.costGoldNum)
        end
    end
    
end

local function OnUseBtnClick(self)
    if self.itemId == 0 and self.isLock == true then
        UIUtil.ShowTipsId(104216)
    elseif self.itemId~=nil and self.itemId~=0 then
        if self.param.callBack ~= nil and self.itemId~=nil and self.itemId~=0 then
            local isBuy = false
            self.param.callBack(self.param.index,self.itemId,isBuy)
        end
    end
end

local function RefreshOwnCount(self,count)
    self.param.count = count
    --self.own_text:SetText(Localization:GetString("100100")..count)
    self.num_txt:SetText(count)
end

local function RefreshColor(self,gold)
    if self.param.info.type == "Gold" then
        if gold < self.costGoldNum then
            self.buy_btn_count:SetColor(RedColor)
        else
            self.buy_btn_count:SetColor(WhiteColor)
        end
    end
end

local function GetMoreBtnParent(self)
    return self.more_btn_go.transform
end



StaminaItem.OnCreate = OnCreate
StaminaItem.OnDestroy = OnDestroy
StaminaItem.OnEnable = OnEnable
StaminaItem.OnDisable = OnDisable
StaminaItem.ComponentDefine = ComponentDefine
StaminaItem.ComponentDestroy = ComponentDestroy
StaminaItem.DataDefine = DataDefine
StaminaItem.DataDestroy = DataDestroy
StaminaItem.ReInit = ReInit
StaminaItem.OnBuyBtnClick = OnBuyBtnClick
StaminaItem.OnUseBtnClick = OnUseBtnClick
StaminaItem.RefreshOwnCount = RefreshOwnCount
StaminaItem.RefreshColor = RefreshColor
StaminaItem.GetMoreBtnParent = GetMoreBtnParent
StaminaItem.RefreshGoldData= RefreshGoldData

return StaminaItem
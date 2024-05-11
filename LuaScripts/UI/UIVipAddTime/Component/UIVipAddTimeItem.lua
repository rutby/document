---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 4/2/2024 上午10:06
---
local UIVipAddTimeItem = BaseClass("UIVipAddTimeItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local icon_path = "UICommonItemSize/clickBtn/ItemIcon"
local extra_text_path = "UICommonItemSize/clickBtn/FlagGo/FlagText"
local extra_path = "UICommonItemSize/clickBtn/FlagGo"
local item_quality_path = "UICommonItemSize/clickBtn/ImgQuality"
local name_text_path = "name_text"
local des_text_path = "layout/des_text"

local buy_btn_path = "buy_btn"
local buy_btn_name_path = "buy_btn/BuyBtnLabel/btnText"
local buy_btn_count_path = "buy_btn/BuyBtnLabel/iconText"
local goto_btn_path = "gotoBtn"
local goto_txt_path = "gotoBtn/gotoBtnText"

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
    self.use_btn = self:AddComponent(UIButton, buy_btn_path)
    self.use_btn_name = self:AddComponent(UITextMeshProUGUIEx, buy_btn_name_path)
    self.use_btn_name:SetLocalText(110001)
    self.use_btn_count = self:AddComponent(UITextMeshProUGUIEx, buy_btn_count_path)
    self.item_quality_img = self:AddComponent(UIImage, item_quality_path)
    self.use_btn:SetOnClick(function()
        self:OnUseBtnClick()
    end)
    self.goto_btn = self:AddComponent(UIButton,goto_btn_path)
    self.goto_btn:SetOnClick(function()
        self:OnGotoClick()
    end)
    self.goto_txt = self:AddComponent(UITextMeshProUGUIEx,goto_txt_path)
end

--控件的销毁
local function ComponentDestroy(self)
    self.icon = nil
    self.extra_text = nil
    self.extra = nil
    self.name_text = nil
    self.des_text = nil
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
function UIVipAddTimeItem:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.UpdateGold, self.RefreshColor)
end

function UIVipAddTimeItem:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.UpdateGold, self.RefreshColor)
end

-- 全部刷新
local function SetItemShow(self,param)
    self.itemId = 0
    self.useType = param.type
    self.needNum = 0
    self.uuid = 0
    if self.useType == "Buy" then
        self.param = param.data
        --self.use_btn:LoadSprite(string.format(LoadPath.CommonNewPath,"Common_btn_green101"))
        self.itemId = self.param.id
        local template = DataCenter.ItemTemplateManager:GetItemTemplate(self.itemId)
        if template ~= nil then
            if template.para1 ~= nil and template.para1 ~= "" then
                local para1 = template.para1
                local temp = string.split(para1,';')
                if temp ~= nil and #temp > 1 then
                    self.extra_text:SetText(temp[1]..temp[2])
                    self.extra:SetActive(true)
                else
                    self.extra:SetActive(false)
                    self.extra_text:SetText("")
                end
            elseif template.para ~= nil and template.para ~= "" then
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
            self.item_quality_img:LoadSprite(DataCenter.ItemTemplateManager:GetToolBgByColor(template.color))
            local good = DataCenter.ItemData:GetItemById(self.itemId)
            local count = 0
            if good ~= nil then
                count = good.count
                self.uuid = good.uuid
            end
            if count~=nil and count>0 then
                self.use_btn:SetActive(false)
                self.goto_btn:SetActive(true)
                self.goto_txt:SetLocalText(110046)
                self.des_text:SetLocalText(GameDialogDefine.OWN,count)
            else
                self.use_btn:SetActive(true)
                self.goto_btn:SetActive(false)
                self.des_text:SetText(DataCenter.ItemTemplateManager:GetDes(template.id))
                self.needNum = toInt(template.price)
                self.use_btn_count:SetText(string.GetFormattedSeperatorNum(self.needNum))
                self:RefreshColor()
            end
            
        end
    elseif self.useType == "MonthCard" then
        self.extra:SetActive(false)
        self.use_btn:SetActive(false)
        self.goto_btn:SetActive(true)
        self.goto_txt:SetLocalText(110003)
        self.icon:LoadSprite(string.format(LoadPath.ItemPath, "alliance_vip_libao"))
        self.item_quality_img:LoadSprite(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE))
        self.name_text:SetText(Localization:GetString("321400"))
        self.des_text:SetText(Localization:GetString("321403"))
    end

end

local function OnUseBtnClick(self)
    if self.view.isSendMsg == true then
        return
    end
    if self.useType == "Buy" then
        if self.uuid~=0 then
            SFSNetwork.SendMessage(MsgDefines.ItemUse, { uuid = self.uuid,num = 1  })
            self.view:SetIsOnMsgSend()
        else
            if self.itemId == 0 then
                UIUtil.ShowTipsId(104216)
            elseif self.itemId~=nil and self.itemId~=0 then
                if LuaEntry.Player.gold >= self.needNum then
                    UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.BuyUseDialog,Localization:GetString(GameDialogDefine.SPEND_SOMETHING_BUY_SOMETHING,
                            string.GetFormattedSeperatorNum(self.needNum),Localization:GetString(GameDialogDefine.DIAMOND),
                            DataCenter.ItemTemplateManager:GetName(self.itemId)), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
                        self:ConfirmBuy()

                    end)
                else
                    GoToUtil.GotoPayTips()
                end
            end
        end    
        
    end
end

local function OnGotoClick(self)
    if self.useType == "Buy" then
        if self.uuid~=0 then
            SFSNetwork.SendMessage(MsgDefines.ItemUse, { uuid = self.uuid,num = 1  })
            self.view:SetIsOnMsgSend()
        end
        return
    end
    self.view.ctrl:CloseSelf()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackage, { anim = true }, { welfareTagType = WelfareTagType.MonthCard })
end



function UIVipAddTimeItem:RefreshColor()
    local gold = LuaEntry.Player.gold
    if self.useType == "Buy" then
        if gold < self.needNum then
            self.use_btn_count:SetColor(RedColor)
        else
            self.use_btn_count:SetColor(WhiteColor)
        end
    end
end

local function ConfirmBuy(self)
    SFSNetwork.SendMessage(MsgDefines.ItemBuyAndUse, { itemId = tostring(self.itemId),num = 1 })
    self.view:SetIsOnMsgSend()
end

UIVipAddTimeItem.OnCreate = OnCreate
UIVipAddTimeItem.OnDestroy = OnDestroy
UIVipAddTimeItem.OnEnable = OnEnable
UIVipAddTimeItem.OnDisable = OnDisable
UIVipAddTimeItem.ComponentDefine = ComponentDefine
UIVipAddTimeItem.ComponentDestroy = ComponentDestroy
UIVipAddTimeItem.DataDefine = DataDefine
UIVipAddTimeItem.DataDestroy = DataDestroy
UIVipAddTimeItem.SetItemShow = SetItemShow
UIVipAddTimeItem.OnUseBtnClick = OnUseBtnClick
UIVipAddTimeItem.OnGotoClick = OnGotoClick
UIVipAddTimeItem.ConfirmBuy =ConfirmBuy
return UIVipAddTimeItem
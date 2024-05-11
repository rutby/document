---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl.
--- DateTime: 
---
local UIMasteryChangeView = BaseClass("UIMasteryChangeView",UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local title_path = "UICommonMiniPopUpTitle/Bg_mid/titleText"
local return_btn_path = "UICommonMiniPopUpTitle/panel"
local close_btn_path = "UICommonMiniPopUpTitle/Bg_mid/CloseBtn"
local desc_txt_path = "ImgBg/Txt_Desc"
local use_txt_path = "ImgBg/Btn_Use/UseItem/Txt_Use"
local itemNum_txt_path = "ImgBg/Btn_Use/UseItem/Txt_ItemNum"
local item_img_path = "ImgBg/Btn_Use/UseItem/Txt_ItemNum/Img_Item"
local use_btn_path ="ImgBg/Btn_Use"
local cancel_btn_path = "ImgBg/Btn_Cancel"
local cancel_txt_path = "ImgBg/Btn_Cancel/Txt_Cancel"
local own_txt_path = "ImgBg/Txt_Own"

function UIMasteryChangeView:OnCreate()
    base.OnCreate(self)
	
    self.title = self:AddComponent(UITextMeshProUGUIEx,title_path)
    self.title:SetLocalText(390306)

    self.desc_txt = self:AddComponent(UIText,desc_txt_path)
	
    self.use_btn = self:AddComponent(UIButton, use_btn_path)
    self.use_btn:SetOnClick(function()  
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
       self:OnUseClick()
    end)
	self.use_txt = self:AddComponent(UIText,use_txt_path)
	self.use_txt:SetLocalText(110006)
    self.itemNum_txt = self:AddComponent(UIText,itemNum_txt_path)
    self.itemNum_txt:SetLocalText(391038,1)
    self.item_img = self:AddComponent(UIImage,item_img_path)
    
    self.cancel_btn = self:AddComponent(UIButton, cancel_btn_path)
    self.cancel_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.cancel_txt = self:AddComponent(UIText,cancel_txt_path)
    self.cancel_txt:SetLocalText(110106)
    
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()  
        self.ctrl:CloseSelf()
    end)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.return_btn:SetOnClick(function()  
        self.ctrl:CloseSelf()
    end)
	
    self.own_txt = self:AddComponent(UIText,own_txt_path)
end

function UIMasteryChangeView:OnDestroy()
    self.title = nil
    self.warn = nil
	
    self.use_btn = nil
    self.input = nil
    self.close_btn = nil
    self.return_btn = nil
    self.inputValue = nil

    self.first_use_txt_shadow = nil
	
    self.diamondNum = nil
    
    base.OnDestroy(self)
end

function UIMasteryChangeView:OnEnable()
    base.OnEnable(self)
	self.itemId,self.count = self:GetUserData()
    self:InitView()
end

function UIMasteryChangeView:OnDisable()
    base.OnDisable(self)
end

function UIMasteryChangeView:InitView()
    self.desc_txt:SetLocalText(111037)

    local template = DataCenter.ItemTemplateManager:GetItemTemplate(self.itemId)
    if template then
        self.item_img:LoadSprite(string.format(LoadPath.ItemPath,template.icon))
    end
    self.own_txt:SetText(Localization:GetString("130128",self.count))
end

function UIMasteryChangeView:OnUseClick()
    local index = DataCenter.MasteryManager:GetTempPlanIndex()
    local item = DataCenter.ItemData:GetItemById(self.itemId)
    if item then
        SFSNetwork.SendMessage(MsgDefines.ItemUse, { uuid = item.uuid,num = 1,useResetItemType = 1,targetPage = index})
    end
    self.ctrl:CloseSelf()
end


return UIMasteryChangeView
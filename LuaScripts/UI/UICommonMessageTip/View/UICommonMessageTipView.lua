---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/11/9 14:46
---
local UICommonMessageTipView = BaseClass("UICommonMessageTipView",UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray

local title_path = "UICommonMiniPopUpTitle/Bg_mid/titleText"
local return_btn_path = "UICommonMiniPopUpTitle/panel"
local close_btn_path = "UICommonMiniPopUpTitle/Bg_mid/CloseBtn"
local tips_txt_path = "UICommonMiniPopUpTitle/DesName"
local btn_1_path = "UICommonMiniPopUpTitle/BtnGo/LeftBtn"
local btn_1_txt_path = "UICommonMiniPopUpTitle/BtnGo/LeftBtn/LeftBtnName"
local btn_2_path = "UICommonMiniPopUpTitle/BtnGo/RightBtn"
local btn_2_txt_path = "UICommonMiniPopUpTitle/BtnGo/RightBtn/RightBtnName"

local function OnCreate(self)
    base.OnCreate(self)
    self.title = self:AddComponent(UITextMeshProUGUIEx,title_path)
    self.tips_txt = self:AddComponent(UITextMeshProUGUIEx,tips_txt_path)
    self.btn_1 = self:AddComponent(UIButton, btn_1_path)
    self.btn_1_txt = self:AddComponent(UITextMeshProUGUIEx,btn_1_txt_path)
    self.btn_2 = self:AddComponent(UIButton, btn_2_path)
    self.btn_2_txt = self:AddComponent(UITextMeshProUGUIEx,btn_2_txt_path)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
end

local function OnDestroy(self)
    self.titleText =nil
    self.tipText = nil
    self.text1 =nil
    self.text2 =nil
    self.action1 = nil
    self.closeAction = nil
    self.action2 =nil
    self.title = nil
    self.tips_txt = nil
    self.btn_1 = nil
    self.btn_1_txt = nil
    self.btn_2 = nil
    self.btn_2_txt = nil
    self.close_btn = nil
    self.return_btn = nil
    self.closeIsShow = nil
    self.isChangeImg = nil
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
    self:RefreshData()
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function SetData(self,tipText,btnNum,text1,text2,action1,action2,closeAction,titleText,isChangeImg,noPlayCloseEffect,enableBtn1,enableBtn2,ClickBgDisable)
    self.titleText =titleText
    self.btnNum = btnNum
    self.tipText = tipText
    self.text1 =text1
    self.text2 =text2
    self.action1 = action1
    self.closeAction = closeAction
    self.action2 =action2
    self.OnCloseClick = false
    self.isChangeImg = isChangeImg
    self.noPlayCloseEffect = noPlayCloseEffect
    self.ClickBgDisable = ClickBgDisable
    if enableBtn1 ~= nil then
        self.enableBtn1 = enableBtn1
    else
        self.enableBtn1 = true
    end
    if enableBtn2 ~= nil then
        self.enableBtn2 = enableBtn2
    else
        self.enableBtn2 = true
    end
end

local function RefreshData(self)
    --if self.isChangeImg then
    --    self.btn_1:LoadSprite(string.format(LoadPath.CommonNewPath,"Common_btn_red101"))
    --    self.btn_2:LoadSprite(string.format(LoadPath.CommonNewPath,"Common_btn_yellow101"))
    --else
    --    self.btn_1:LoadSprite(string.format(LoadPath.CommonNewPath,"Common_btn_yellow101"))
    --    self.btn_2:LoadSprite(string.format(LoadPath.CommonNewPath,"Common_btn_green101"))
    --end
    if self.titleText~=nil and self.titleText~="" then
        self.title:SetLocalText(self.titleText) 
    else
        self.title:SetLocalText(100378) 
    end
    if self.tipText~=nil and self.tipText~="" then
        self.tips_txt:SetText(self.tipText)
    else
        self.tips_txt:SetText("")
    end

    if self.btnNum~=nil then
        self.btn_1:SetActive(self.btnNum>0)
        self.btn_2:SetActive(self.btnNum>1)
        if self.btnNum > 2  then
            self.btnNum = 2
        end
        --self.btn_1.rectTransform.sizeDelta = Vector2.New(BtnWidth[self.btnNum],self.btn_1.rectTransform.sizeDelta.y)
    else
        self.btn_1:SetActive(false)
        self.btn_2:SetActive(false)
    end
    if self.btn_1:GetActive() then
        if self.action1 then
            --if self.isFromCSharp~=nil and self.isFromCSharp then
            --    self.btn_1:SetOnClick(function ()
            --        self.ctrl:CloseSelf()
            --        CallCSharp:OnBtnCallBack(self.action1)
            --    end)
            --else
                self.btn_1:SetOnClick(function ()
                    self:OnCloseInTimer()
                    self.action1()
                end)
            --end
            
        else
            self.btn_1:SetOnClick(function ()
                self.ctrl:CloseSelf()
            end)
        end
        if self.text1~=nil and self.text1~="" then
            self.btn_1_txt:SetLocalText(self.text1) 
        else
            self.btn_1_txt:SetLocalText(GameDialogDefine.CONFIRM) 
        end
    end
    if self.btn_2:GetActive() then
        if self.action2 then
            --if self.isFromCSharp~=nil and self.isFromCSharp then
            --    self.btn_2:SetOnClick(function ()
            --        self.ctrl:CloseSelf()
            --        CallCSharp:OnBtnCallBack(self.action2)
            --    end)
            --else
                self.btn_2:SetOnClick(function ()
                    self:OnCloseInTimer()
                    self.action2()
                end)
            --end
        else
            self.btn_2:SetOnClick(function ()
                self.ctrl:CloseSelf()
            end)
        end
        if self.text2~=nil and self.text2~="" then
            self.btn_2_txt:SetLocalText(self.text2) 
        else
            self.btn_2_txt:SetLocalText(GameDialogDefine.CANCEL) 
        end
    end

    if self.closeAction then
        --if self.isFromCSharp~=nil and self.isFromCSharp then
        --    self.close_btn:SetOnClick(function ()
        --        self.ctrl:CloseSelf()
        --        CallCSharp:OnBtnCallBack(self.closeAction)
        --    end)
        --    self.return_btn:SetOnClick(function ()
        --        self.ctrl:CloseSelf()
        --        CallCSharp:OnBtnCallBack(self.closeAction)
        --    end)
        --else
            self.close_btn:SetOnClick(function ()
                self:OnCloseInTimer()
                self.closeAction()
            end)
            self.return_btn:SetOnClick(function ()
                if self.ClickBgDisable == true then
                    return
                end
                self:OnCloseInTimer()
                self.closeAction()
            end)
        --end
    else
        self.close_btn:SetOnClick(function()  
            self.ctrl:CloseSelf()
        end)
        self.return_btn:SetOnClick(function()
            if self.ClickBgDisable == true then
                return
            end
            self.ctrl:CloseSelf()
        end)
    end
    
    UIGray.SetGray(self.btn_1.transform, not self.enableBtn1, self.enableBtn1)
    UIGray.SetGray(self.btn_2.transform, not self.enableBtn2, self.enableBtn2)
end


local function OnCloseInTimer(self)
    self.OnCloseClick =true
    local closeTimer = TimerManager:GetInstance():GetTimer(0.1, function()
        if self.OnCloseClick and self.ctrl then
            self.ctrl:CloseSelf(self.noPlayCloseEffect)
        end
    end, nil, true, false, false)

    closeTimer:Start()
end

UICommonMessageTipView.OnCreate = OnCreate
UICommonMessageTipView.OnDestroy = OnDestroy
UICommonMessageTipView.OnEnable = OnEnable
UICommonMessageTipView.OnDisable = OnDisable
UICommonMessageTipView.SetData = SetData
UICommonMessageTipView.RefreshData =RefreshData
UICommonMessageTipView.OnCloseInTimer =OnCloseInTimer
return UICommonMessageTipView
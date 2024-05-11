---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mac.
--- DateTime: 8/31/21 3:14 PM
---
local UIChatItemOperatorView = BaseClass("UIChatItemOperatorView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local _cp_btnBg = "butBg"
local _cp_root = "root"
local root_img = "root/root_img"
local btnReport_path = "root/btnReport"
local txtReportBtn_path = "root/btnReport/txtReport"
local _cp_btnTranslate = "root/btnTranslate"
local _cp_txtTranslate = "root/btnTranslate/txtTranslate"
local _cp_btnCopy = "root/btnCopy"
local _cp_txtCopy = "root/btnCopy/txtCopy"
local _cp_btnUp = "root/support"
local _cp_btnDown = "root/opposition"

local PosX = 375
local PosY = -70
function UIChatItemOperatorView:ComponentDefine()
    self._root = self:AddComponent(UIBaseContainer, _cp_root)
    self.root_img = self:AddComponent(UIBaseContainer, root_img)
    self._btnBg = self:AddComponent(UIButton, _cp_btnBg)
    self._btnBg:SetOnClick(BindCallback(self, self.OnClickBg))
    
    self._btnTranslate = self:AddComponent(UIButton, _cp_btnTranslate)
    self._btnTranslate:SetOnClick(BindCallback(self, self.OnClickBtnTranslate))
    
    self.btnReportN = self:AddComponent(UIButton, btnReport_path)
    self.btnReportN:SetOnClick(function()
        self:OnClickReportBtn()
    end)
    self.txtReportBtnN = self:AddComponent(UIText, txtReportBtn_path)
    self.txtReportBtnN:SetLocalText(208251)
    
    self._txtTranslate = self:AddComponent(UIText, _cp_txtTranslate)
    self._txtTranslate:SetLocalText(290042)

    self._btnCopy = self:AddComponent(UIButton, _cp_btnCopy)
    self._btnCopy:SetOnClick(BindCallback(self, self.OnClickBtnCopy))

    self._txtCopy = self:AddComponent(UIText, _cp_txtCopy)
    self._txtCopy:SetLocalText(121069)
    
    self._btnUp = self:AddComponent(UIButton, _cp_btnUp)
    self._btnUp:SetOnClick(BindCallback(self, self.OnUp))
    self._btnDown = self:AddComponent(UIButton, _cp_btnDown)
    self._btnDown:SetOnClick(BindCallback(self, self.OnDown))
end
function UIChatItemOperatorView:OnDestroy()
    base.OnDestroy(self)
end

function UIChatItemOperatorView:OnClickBg()
    self.ctrl:CloseSelf()
end

function UIChatItemOperatorView:DialogDefine()
    
    
end

function UIChatItemOperatorView:DelayInvoke(callback, delayTime)
    local param = {}
    param.timer = TimerManager:GetInstance():GetTimer(delayTime, function()
        if param.timer ~= nil then
            param.timer:Stop()
            param.timer = nil
        end
        param = nil
        callback()
    end , self, true,false,false)
    param.timer:Start()
end

function UIChatItemOperatorView:DataDefine()
    local userData = self:GetUserData()
    self._chatData = userData["chatdata"]
    self._targetPos = userData["targetPos"]
    self._userInfo = userData["userinfo"]
    self._chatItem = userData["chatItem"]
    self.lossyScaleX = self.transform.lossyScale.x
    if self.lossyScaleX <= 0 then
        self.lossyScaleX = 1
    end
    self.lossyScaleY = self.transform.lossyScale.y
    if self.lossyScaleY <= 0 then
        self.lossyScaleY = 1
    end
end


function UIChatItemOperatorView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:DialogDefine()
    self:SetPosition()
    
    local overLv = LuaEntry.DataConfig:TryGetNum("report_base","k1")
    local lvFit = DataCenter.BuildManager.MainLv > overLv
    self.btnReportN:SetActive(lvFit)
    
    --self:DelayInvoke(function ()
    --    
    --end, 0);
end

function UIChatItemOperatorView:OnClickBtnTranslate()
    self._chatItem:OnTranslationBtn()
    self.ctrl:CloseSelf()
end

function UIChatItemOperatorView:SetPosition()
    self._root.transform.position = Vector3.New(PosX * self.lossyScaleX, self._targetPos.position.y + PosY * self.lossyScaleY, 0)
    self.root_img.transform.position = self._targetPos.position + Vector2.New(0, PosY * self.lossyScaleY)
end

function UIChatItemOperatorView:OnClickBtnCopy()
    local msg = self._chatData:getMessageWithExtra(false)
    CommonUtil.CopyTextToClipboard(msg)
    UIUtil.ShowTipsId(128031)
    self.ctrl:CloseSelf()
end
function UIChatItemOperatorView:OnDown()
    self._chatItem:OnDown()
    self.ctrl:CloseSelf()
end

function UIChatItemOperatorView:OnUp()
    self._chatItem:OnUp()
    self.ctrl:CloseSelf()
end

function UIChatItemOperatorView:OnClickReportBtn()
    local reported = ChatManager2:GetInstance():CheckIfReported(self._chatData)
    if reported then
        UIUtil.ShowTipsId(280064)
        return
    end

    if ChatManager2:GetInstance():CheckReportTime() then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatReport, {anim = true, isBlur=true}, self._chatData)
        self.ctrl:CloseSelf()
    else
        UIUtil.ShowTipsId(208250)
    end
end

return UIChatItemOperatorView
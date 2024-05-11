---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mac.
--- DateTime: 6/24/21 11:07 AM
---
local UIChatSearchPersonView = BaseClass("UIChatSearchPersonView",UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization


--[[
附属类
]]
local UIChatSearchPersonCom = require "UI.UIChatSearchPerson.Component.UIChatSearchPersonCom"
local UIChatSearchAddAllianceMember = require "UI.UIChatSearchPerson.Component.UIChatSearchAddAllianceMember"


local _cp_txtTitle = "ImgBg/TxtTitle"
local _cp_btnClose = "ImgBg/CloseBtn"
local _cp_toggle_1 = "ImgBg/Tab/Toggle1"
local _cp_toggle_2 = "ImgBg/Tab/Toggle2"
local _cp_searchObj = "objSearch"
local _cp_alliance = "AllianceMember"
local _cp_warnTips = "warnTips"



--[[
绑定组件
]]
function UIChatSearchPersonView:ComponentDefine()
    self._txtTitle = self:AddComponent(UIText, _cp_txtTitle)
    self._btnClose = self:AddComponent(UIButton, _cp_btnClose)
    self._btnClose:SetOnClick(function ()
        self.view.ctrl:CloseSelf()
    end)

    self._txtwarnTips = self:AddComponent(UIText, _cp_warnTips)
    
    self._searchObj = self:AddComponent(UIChatSearchPersonCom, _cp_searchObj)
    self._allianceObj = self:AddComponent(UIChatSearchAddAllianceMember, _cp_alliance)
    
    --toggle1 联盟
    self._toggle1 = self:AddComponent(UIToggle, _cp_toggle_1)
    self._toggle1:SetIsOn(false)
    self:ShowAllianceView(false)
    self._toggle1:SetOnValueChanged(BindCallback(self, self.ShowAllianceView))
    
    -- toggle2 搜索
    self._toggle2 = self:AddComponent(UIToggle, _cp_toggle_2)
    self._toggle2:SetIsOn(true)
    self:ShowSearchView(true)
    self._toggle2:SetOnValueChanged(BindCallback(self, self.ShowSearchView))
end


-- 展示联盟成员界面
function UIChatSearchPersonView:ShowAllianceView( isOn )
    self._toggle1.transform:Find("Choose").gameObject:SetActive(isOn)
    self._searchObj:SetActive(not isOn)
    self._txtTitle:SetLocalText(290037) 
    if (isOn) then
        if (not ChatInterface.isInAlliance()) then
            self._allianceObj:SetActive(false)
            self._txtwarnTips:SetActive(true)
            self._txtwarnTips:SetLocalText(GameDialogDefine.NO_JOIN_ALLIANCE) 
        else
            self._allianceObj:SetActive(true)
            self._allianceObj:ReInit(true)
            self._txtwarnTips:SetActive(false)
        end
    else
        self._allianceObj:SetActive(false)
    end
end

function UIChatSearchPersonView:ShowSearchView( isOn )
    self._txtwarnTips:SetActive(false)
    self._toggle2.transform:Find("Choose").gameObject:SetActive(isOn)
    self._searchObj:SetActive(isOn)
    self._allianceObj:SetActive(not isOn)
    self._txtTitle:SetLocalText(280173) 
    if (isOn) then
        self._searchObj:ReInit(true)
    end
end

--[[
初始化,构造函数
]]
function UIChatSearchPersonView:DataDefine()
    self._isLeft = false
    self._isAnim = false
end

function UIChatSearchPersonView:OnAddListener()
    base.OnAddListener(self)
    --self:AddUIListener(ChatInterface.getEventEnum().LF_ChatCellSelect, self.ChatCellSelect)
end

function UIChatSearchPersonView:OnRemoveListener()
    --self:RemoveUIListener(ChatInterface.getEventEnum().LF_ChatCellSelect, self.ChatCellSelect)


    base.OnRemoveListener(self)
end


function UIChatSearchPersonView:OnCreate()
    base.OnCreate(self)
    -- 保存roomId,如果有roomId表示邀请进房间,如果没有表示创建房间
    self.view.ctrl.chatRoomdId = self:GetUserData()
    -- 注册绑定
    self:ComponentDefine()
    self:DataDefine()
end



return UIChatSearchPersonView


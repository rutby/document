---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mac.
--- DateTime: 6/18/21 10:46 AM
---
--[[
    这部分为普通的聊天信息,因为prefab对应拆成了两个,两者在子节点的路径上不同,所以这部分也对应的拆成两个,这两个left/right脚本只做绑定,业务层需要写在ChatItem部分
]]
local ChatItem = require("UI.UIChatNew.Component.ChatItem.ChatItem")
local ChatUserName = require "UI.UIChatNew.Component.ChatItem.ChatUserName"
local ChatItemLeft_Normal = BaseClass("ChatItemLeft_Normal", ChatItem)
local base = ChatItem
local Localization = CS.GameEntry.Localization

local _cp_anchorTransform = "ChatAnchor";
local _cp_chatShareNode = "ChatAnchor/ChatShareNode"
local _cp_bgImg = "ChatAnchor/Background";
local _cp_chatNormalBg = "ChatAnchor/Background/NormalBg";
local _cp_dlgText = "ChatAnchor/Background/DialogText";
local _cp_dividingLine = "ChatAnchor/Background/DialogText/Image";
local _cp_traText = "ChatAnchor/Background/TranslateText";
local _cp_translation = "ChatAnchor/Translation";

local _cp_chatUserName = "ChatNameLayout"

local _cp_chatShareTitle = "ChatAnchor/ChatShareNode/Image/ShareTitle"
local _cp_chatShareMsg = "ChatAnchor/ChatShareNode/ShareIconNode/ShareMsg/ShareMsg"
local _cp_chatShareMsgNode = "ChatAnchor/ChatShareNode/ShareIconNode/ShareMsg"
local click_obj_path = "ChatAnchor/Background/clickObj"
local up_btn_path = "ChatAnchor/Background/clickObj/good"
local down_btn_path = "ChatAnchor/Background/clickObj/bad"
local up_img_path = "ChatAnchor/Background/clickObj/good/goodIcon"
local up_num_path = "ChatAnchor/Background/clickObj/good/goodNum"
local down_img_path = "ChatAnchor/Background/clickObj/bad/badIcon"
local down_num_path = "ChatAnchor/Background/clickObj/bad/badNum"
local special_frame_path = "ChatAnchor/Background/specialFrame"

function ChatItemLeft_Normal:ComponentDefine()
    base.ComponentDefine(self)
    self._rectTransform = self.rectTransform
    self._anchorTransform = self.transform:Find(_cp_anchorTransform):GetComponent(typeof(CS.UnityEngine.RectTransform))
    self._chatShareNode = self:AddComponent(UIButton, _cp_chatShareNode)
    
    self._chatShareTitle = self:AddComponent(UITextMeshProUGUIEx, _cp_chatShareTitle)
    self._chatShareMsg = self:AddComponent(UITextMeshProUGUIEx, _cp_chatShareMsg)
    self._chatShareMsgNode = self:AddComponent(UIBaseContainer, _cp_chatShareMsgNode)
    
    self._bgImg = self:AddComponent(UIImage, _cp_bgImg)
    self._chatNormalBg = self:AddComponent(UIImage, _cp_chatNormalBg)
    self._special_frame = self:AddComponent(UIImage, special_frame_path)
    self._dlgText = self:AddComponent(UIText, _cp_dlgText)
    self._dividingLine = self:AddComponent(UIImage, _cp_dividingLine)
    self._traText = self:AddComponent(UIText, _cp_traText)
    self._translation = self.transform:Find(_cp_translation).transform
    
    self._chatUserName = self:AddComponent(ChatUserName, _cp_chatUserName)
    self._bgBtnLongPress = self:AddComponent(UIButton_LongPress, _cp_bgImg)
    self.upObj = self:AddComponent(UIBaseContainer, click_obj_path)
    self.upNode = self:AddComponent(UIButton, up_btn_path)
    self.upNode:SetOnClick(BindCallback(self, self.OnUp))
    self.up_anim = self:AddComponent(UIAnimator, up_img_path)
    self.down_anim = self:AddComponent(UIAnimator, down_img_path)
    self.downNode = self:AddComponent(UIButton, down_btn_path)
    self.downNode:SetOnClick(BindCallback(self, self.OnDown))
    self.up_num = self:AddComponent(UITextMeshProUGUIEx, up_num_path)
    self.down_num = self:AddComponent(UITextMeshProUGUIEx, down_num_path)
end

function ChatItemLeft_Normal:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
    self:AddBtnClick()
end


return ChatItemLeft_Normal
---
--- Created by shimin
--- DateTime: 2023/3/16 18:10
--- 王座奖励界面

local UIThronePresidentRewardView = BaseClass("UIThronePresidentRewardView", UIBaseView)
local base = UIBaseView
local RewardItem = require "UI.UIWorldPoint.Component.WorldPointRewardItem"
local Localization = CS.GameEntry.Localization

local RewardType =
{
    President = 1,--总统奖励
    Core = 2,--核心奖励
    Cream = 3,--精英奖励
    Common = 4,--成员奖励
}

local close_btn_path = "safeArea/Back"
local title_txt_path = "safeArea/Title"
local player_head_btn_path = "content/Image/flag/UIPlayerHead"
local player_head_icon_path = "content/Image/flag/UIPlayerHead/HeadIcon"
local no_player_head_icon_path = "content/Image/flag/UIPlayerHead/Image"
local president_text_path = "content/Image/president_text"
local president_time_text_path = "content/Image/president_text (1)"
local president_name_path = "content/Image/president_name"
local reward_title_text_path = "content/right/rewardTitle"
local reward_info_btn_path = "content/right/rewardTitle/infoBtn"
local toggle_path = "content/right/Toggle_tittle_group/Toggle%s"
local condition_des_text_path = "content/right/taskObj/bg/Text_task"
local condition_title_text_path = "content/right/taskObj/Tasktitle"
local condition_go_path = "content/right/taskObj"
local btn_path = "content/right/BtnYellow03"
local btn_text_path = "content/right/BtnYellow03/GoBtnName"
local packet_name_text_path = "content/right/GameObject/stampObj/Text_stamp_Title"
local packet_img_path = "content/right/GameObject/stampObj/stampImg"
local reward_name_text_path = "content/right/GameObject/rewardObj/title/titleText"
local diamond_name_text_path = "content/right/GameObject/rewardObj/title/Text_num/Text_reward"
local diamond_num_text_path = "content/right/GameObject/rewardObj/title/Text_num"
local scroll_view_path = "content/right/GameObject/rewardObj/ScrollView"
local reward_text_path = "content/right/content_description0"

function UIThronePresidentRewardView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

function UIThronePresidentRewardView:ComponentDefine()
    self._close_btn = self:AddComponent(UIButton, close_btn_path)
    self._close_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self._title_txt = self:AddComponent(UIText, title_txt_path)
    self.player_head_btn = self:AddComponent(UIButton, player_head_btn_path)
    self.player_head_icon = self:AddComponent(UIPlayerHead, player_head_icon_path)
    self.player_head_btn:SetOnClick(function()
        self:OnClickPlayerHead()
    end)
    self.president_text = self:AddComponent(UIText, president_text_path)
    self.president_name = self:AddComponent(UIText, president_name_path)
    self.reward_title_text = self:AddComponent(UIText, reward_title_text_path)
    self.reward_info_btn = self:AddComponent(UIButton, reward_info_btn_path)
    self.reward_info_btn:SetOnClick(function()
        self:OnClickInfoBtn()
    end)
    self.toggle = {}
    for k,v in pairs(RewardType) do
        local toggle = self:AddComponent(UIToggle, string.format(toggle_path, v))
        if toggle ~= nil then
            toggle:SetOnValueChanged(function(tf)
                if tf then
                    self:ToggleControlBorS(v)
                end
            end)
            toggle.text1 = toggle:AddComponent(UIText,"text1")
            toggle.text2 = toggle:AddComponent(UIText,"text2")
            toggle.redDot = toggle:AddComponent(UIBaseContainer,"Img_RedPoint")
            self.toggle[v] = toggle
        end
    end
    self.condition_des_text= self:AddComponent(UIText, condition_des_text_path)
    self.condition_title_text = self:AddComponent(UIText, condition_title_text_path)
    self.btn_text = self:AddComponent(UIText, btn_text_path)
    self.btn = self:AddComponent(UIButton, btn_path)
    self.btn:SetOnClick(function()
        self:OnClickBtn()
    end)
    self.packet_name_text = self:AddComponent(UIText, packet_name_text_path)
    self.packet_img = self:AddComponent(UIImage, packet_img_path)
    self.reward_name_text = self:AddComponent(UIText, reward_name_text_path)
    self.diamond_name_text = self:AddComponent(UIText, diamond_name_text_path)
    self.diamond_num_text = self:AddComponent(UITextMeshProUGUIEx, diamond_num_text_path)
    self.president_time_text = self:AddComponent(UIText, president_time_text_path)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCellMoveIn(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnCellMoveOut(itemObj, index)
    end)
    self.condition_go = self:AddComponent(UIBaseContainer, condition_go_path)
    self.no_player_head_icon = self:AddComponent(UIImage, no_player_head_icon_path)
    self.reward_text = self:AddComponent(UIText, reward_text_path)
end

function UIThronePresidentRewardView:ComponentDestroy()
end

function UIThronePresidentRewardView:DataDefine()
    self.tabType = RewardType.President
end

function UIThronePresidentRewardView:DataDestroy()
    self.tabType = RewardType.President
end

function UIThronePresidentRewardView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIThronePresidentRewardView:OnEnable()
    base.OnEnable(self)
end

function UIThronePresidentRewardView:OnDisable()
    base.OnDisable(self)
end

function UIThronePresidentRewardView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.GovernmentPresentRefresh, self.GovernmentPresentRefreshSignal)
    self:AddUIListener(EventId.GovernmentPresidentRefresh, self.GovernmentPresidentRefreshSignal)
end

function UIThronePresidentRewardView:OnRemoveListener()
    self:RemoveUIListener(EventId.GovernmentPresentRefresh, self.GovernmentPresentRefreshSignal)
    self:RemoveUIListener(EventId.GovernmentPresidentRefresh, self.GovernmentPresidentRefreshSignal)
    base.OnRemoveListener(self)
 
end

function UIThronePresidentRewardView:ReInit()
    DataCenter.GovernmentManager:GetKingdomPresentInfo(LuaEntry.Player:GetSrcServerId())
    self._title_txt:SetLocalText(GameDialogDefine.THRONE_REWARD)
    self.president_text:SetLocalText(GameDialogDefine.CUR_PRESIDENT)
    self.reward_title_text:SetLocalText(GameDialogDefine.REWARD_SEND_BY_PRESIDENT)
    self.condition_title_text:SetLocalText(GameDialogDefine.GET_NEED_CONDITION)
    self.reward_name_text:SetLocalText(GameDialogDefine.CAN_GET_REWARD_LIST)
    self.diamond_name_text:SetLocalText(GameDialogDefine.WORTH, "")
    for k,v in pairs(self.toggle) do
        if k == RewardType.President then
            v.text1:SetLocalText(GameDialogDefine.PRESIDENT_REWARD)
        elseif k == RewardType.Core then
            v.text1:SetLocalText(GameDialogDefine.CORE_REWARD)
        elseif k == RewardType.Cream then
            v.text1:SetLocalText(GameDialogDefine.CREAM_REWARD)
        elseif k == RewardType.Common then
            v.text1:SetLocalText(GameDialogDefine.COMMON_REWARD)
        end

        self:SetToggleTabSelect(k, false)
    end
    self:Refresh()

    self.tabType = RewardType.President
    if self.toggle[self.tabType] ~= nil then
        self.toggle[self.tabType]:SetIsOn(true)
    end
    self:SetToggleTabSelect(self.tabType, true)
    self:ToggleControlBorS(self.tabType)
    self:RefreshPlayer()
end

function UIThronePresidentRewardView:RefreshPlayer()
    local curPresident = DataCenter.GovernmentManager:GetCurPresident()
    if curPresident == nil then
        self.president_text:SetLocalText(GameDialogDefine.PLANT_NO_PRESIDENT)
        self.president_name:SetLocalText(GameDialogDefine.CUR_NO_KINGS)
        self.president_time_text:SetActive(false)
        self.no_player_head_icon:LoadSprite(DataCenter.GovernmentManager:GetPresidentBg(false))
        self.player_head_icon:SetActive(false)
    else
        self.president_text:SetLocalText(GameDialogDefine.CUR_PRESIDENT)
        self.president_time_text:SetActive(true)
        self.president_time_text:SetLocalText(GameDialogDefine.GET_POSITION_BY_SOMETIME, UITimeManager:GetInstance():TimeStampToTimeForServer(curPresident.beKingTime))
        local presidentName = ""
        if string.IsNullOrEmpty(curPresident.allianceAbbr) then
            presidentName = curPresident.name
        else
            presidentName = "[" .. curPresident.allianceAbbr .. "]" .. curPresident.name
        end
        self.president_name:SetText(presidentName)
        self.player_head_icon:SetActive(true)
        self.player_head_icon:SetData(curPresident.uid, curPresident.pic, curPresident.picVer)
        self.no_player_head_icon:LoadSprite(DataCenter.GovernmentManager:GetPresidentBg(true))
    end
 
end

function UIThronePresidentRewardView:ToggleControlBorS(tabType)
    if self.tabType ~= tabType then
        self:SetToggleTabSelect(self.tabType, false)
    end
    self.tabType = tabType
    self:SetToggleTabSelect(self.tabType, true)
    self:RefreshRight()
end

function UIThronePresidentRewardView:SetToggleTabSelect(tabType, isSelect)
    if self.toggle[tabType] ~= nil then
        if isSelect then
            self.toggle[tabType].text1:SetColor(Color.New(200/255,96/255,20/255,1))
            self.toggle[tabType].text2:SetColor(Color.New(200/255,96/255,20/255,1))
        else
            self.toggle[tabType].text1:SetColor(Color.New(182/255,137/255,112/255,1))
            self.toggle[tabType].text2:SetColor(Color.New(182/255,137/255,112/255,1))
        end
    end
end

function UIThronePresidentRewardView:RefreshRight()
    local isMyPresident = DataCenter.GovernmentManager:IsSelfPresident()
    if self.tabType == RewardType.President then
        if isMyPresident then
            self.condition_go:SetActive(false)
            if DataCenter.GovernmentManager:IsGetReward(LuaEntry.Player.uid) then
                self.btn:SetActive(false)
                self.reward_text:SetActive(true)
                self.reward_text:SetLocalText(GameDialogDefine.HAS_GET)
            else
                self.reward_text:SetActive(false)
                self.btn:SetActive(true)
                self.btn_text:SetLocalText(GameDialogDefine.GET_REWARD)
            end
        else
            self.btn:SetActive(false)
            self.reward_text:SetActive(false)
            self.condition_go:SetActive(true)
            self.condition_des_text:SetLocalText(GameDialogDefine.PRESIDENT_GIFT_GET_DES)
        end
    else
        if isMyPresident then
            self.condition_go:SetActive(false)
            if DataCenter.GovernmentManager:IsSendFinishByRewardType(self.tabType) then
                self.btn:SetActive(false)
                self.reward_text:SetActive(true)
                self.reward_text:SetLocalText(GameDialogDefine.SEND_FINISH)
            else
                self.reward_text:SetActive(false)
                self.btn:SetActive(true)
                self.btn_text:SetLocalText(GameDialogDefine.SEND)
            end
        else
            self.btn:SetActive(false)
            self.reward_text:SetActive(false)
            self.condition_go:SetActive(true)
            self.condition_des_text:SetLocalText(GameDialogDefine.PRESIDENT_GIFT_SEND_DES)
        end
    end
  
    local present = DataCenter.GovernmentManager:GetPresentByRewardType(self.tabType)
    if present ~= nil then
        local template = DataCenter.WonderGiftTemplateManager:GetTemplate(present.presentId)
        if template ~= nil then
            self.packet_img:LoadSprite(string.format(LoadPath.UIAllianceGift, template.icon))
            self.packet_name_text:SetText(Localization:GetString(template.name) 
                    .. Localization:GetString(GameDialogDefine.LEFT_NUM_WITH, template.num - present.useCount)) 
            self.diamond_num_text:SetText(string.GetFormattedSeperatorNum(template.worth))
        end
    end
    self:ShowCells()
end

function UIThronePresidentRewardView:OnClickInfoBtn()
    --打开嘉奖记录页面
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIThroneSendList)
end

function UIThronePresidentRewardView:OnClickPlayerHead()
    local curPresident = DataCenter.GovernmentManager:GetCurPresident()
    if curPresident ~= nil and curPresident.uid ~= LuaEntry.Player.uid then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIOtherPlayerInfo,{ anim = true, hideTop = true}, curPresident.uid)
    end
end

function UIThronePresidentRewardView:ShowCells()
    self:ClearScroll()
    self:GetDataList()
    local count = table.count(self.list)
    if count > 0 then
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    end
end

function UIThronePresidentRewardView:ClearScroll()
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(RewardItem)--清循环列表gameObject
end

function UIThronePresidentRewardView:OnCellMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scroll_view:AddComponent(RewardItem, itemObj)
    item:RefreshData(self.list[index])
end

function UIThronePresidentRewardView:OnCellMoveOut(itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, RewardItem)
end

function UIThronePresidentRewardView:GetDataList()
    self.list = {}
    local present = DataCenter.GovernmentManager:GetPresentByRewardType(self.tabType)
    if present ~= nil then
        self.list = DataCenter.RewardManager:GetShowRewardList(present.reward)
    end
end

--点击发奖（只有国王可以点击）
function UIThronePresidentRewardView:OnClickBtn()
    local present = DataCenter.GovernmentManager:GetPresentByRewardType(self.tabType)
    if present ~= nil then
        if self.tabType == RewardType.President then
            local myUid = LuaEntry.Player.uid
            if not DataCenter.GovernmentManager:IsGetReward(myUid) then
                DataCenter.GovernmentManager:KingSendPresent({myUid}, present.presentId)
                UIUtil.ShowTipsId(GameDialogDefine.GET_REWARD_SUCCESS)
            end
        else
            --打开发奖界面
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIThroneRewardSelectMember, { anim = true }, self.tabType)
        end
    end
end

function UIThronePresidentRewardView:GovernmentPresentRefreshSignal()
    self:Refresh()
    self:RefreshRight()
end

function UIThronePresidentRewardView:Refresh()
    local isMyPresident = DataCenter.GovernmentManager:IsSelfPresident()
    for k,v in pairs(self.toggle) do
        local num = 0
        local useCount = 0
        local present = DataCenter.GovernmentManager:GetPresentByRewardType(k)
        if present ~= nil then
            local template = DataCenter.WonderGiftTemplateManager:GetTemplate(present.presentId)
            if template ~= nil then
                num = template.num
            end
            useCount = present.useCount
        end

        v.text2:SetText( Localization:GetString(GameDialogDefine.REWARD_NUM_WITH) .. " " .. num)
        if isMyPresident and num > useCount then
            v.redDot:SetActive(true)
        else
            v.redDot:SetActive(false)
        end
    end
end


function UIThronePresidentRewardView:GovernmentPresidentRefreshSignal()
    self:RefreshRight()
end

return UIThronePresidentRewardView
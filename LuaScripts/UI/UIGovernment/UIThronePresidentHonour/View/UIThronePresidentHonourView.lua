--- Created by shimin
--- DateTime: 2023/3/21 16:28
--- 王座国王历史记录界面

local UIThronePresidentHonourView = BaseClass("UIThronePresidentHonourView", UIBaseView)
local base = UIBaseView
local UIThronePresidentHonourCell = require "UI.UIGovernment.UIThronePresidentHonour.Component.UIThronePresidentHonourCell"

local close_btn_path = "safeArea/Back"
local title_txt_path = "safeArea/Title"
local player_head_btn_path = "content/UIPresidentItem/Image/HasPresident/UIPlayerHead"
local player_head_icon_path = "content/UIPresidentItem/Image/HasPresident/UIPlayerHead/HeadIcon"
local no_player_head_icon_path = "content/UIPresidentItem/Image/HasPresident/UIPlayerHead/Image"
local president_text_path = "content/UIPresidentItem/Image/HasPresident/PresidentStateText"
local president_name_path = "content/UIPresidentItem/Image/HasPresident/NameText"
local president_time_text_path = "content/UIPresidentItem/Image/HasPresident/InauguralTimeText"
local scroll_view_path = "content/right/ScrollView"
local scroll_title_text_path = "content/right/rewardTitle"
local show_alliance_name_text_path = "content/right/select/allianceName"
local show_rank_text_path = "content/right/select/power"
local show_country_text_path = "content/right/select/people"
local show_time_text_path = "content/right/select/language"
local show_go_path = "content/right/select"
local empty_text_path = "content/right/emptyDes"

function UIThronePresidentHonourView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

function UIThronePresidentHonourView:ComponentDefine()
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
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCellMoveIn(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnCellMoveOut(itemObj, index)
    end)
    self.scroll_title_text = self:AddComponent(UIText, scroll_title_text_path)
    self.show_alliance_name_text = self:AddComponent(UIText, show_alliance_name_text_path)
    self.show_rank_text = self:AddComponent(UIText, show_rank_text_path)
    self.show_country_text = self:AddComponent(UIText, show_country_text_path)
    self.show_time_text = self:AddComponent(UIText, show_time_text_path)
    self.show_go = self:AddComponent(UIBaseContainer, show_go_path)
    self.empty_text = self:AddComponent(UIText, empty_text_path)
    self.president_time_text = self:AddComponent(UIText, president_time_text_path)
    self.no_player_head_icon = self:AddComponent(UIImage, no_player_head_icon_path)
end

function UIThronePresidentHonourView:ComponentDestroy()
end

function UIThronePresidentHonourView:DataDefine()
    self.count = 0
    self.list = {}
end

function UIThronePresidentHonourView:DataDestroy()
    self.count = 0
    self.list = {}
end

function UIThronePresidentHonourView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIThronePresidentHonourView:OnEnable()
    base.OnEnable(self)
end

function UIThronePresidentHonourView:OnDisable()
    base.OnDisable(self)
end

function UIThronePresidentHonourView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.GovernmentHistoryRecordRefresh, self.GovernmentHistoryRecordRefreshSignal)
end

function UIThronePresidentHonourView:OnRemoveListener()
    self:RemoveUIListener(EventId.GovernmentHistoryRecordRefresh, self.GovernmentHistoryRecordRefreshSignal)
    base.OnRemoveListener(self)
end

function UIThronePresidentHonourView:ReInit()
    --每次打开界面发送第一页
    DataCenter.GovernmentManager:GetKingHistory(LuaEntry.Player:GetSrcServerId(), 1)
    self._title_txt:SetLocalText(GameDialogDefine.HALL_ALL_GLORY)
    self.president_text:SetLocalText(GameDialogDefine.CUR_PRESIDENT)
    self.scroll_title_text:SetLocalText(GameDialogDefine.PRESIDENT_HISTORY)
    self.show_alliance_name_text:SetLocalText(GameDialogDefine.PLAYER)
    self.show_country_text:SetLocalText(GameDialogDefine.COUNTRY_AND_AREA)
    self.show_time_text:SetLocalText(GameDialogDefine.GET_POSITION_TIME)
    self.show_rank_text:SetLocalText(GameDialogDefine.POSITION_TIME)
    self.empty_text:SetLocalText(GameDialogDefine.PLANT_NO_PRESIDENT)
    self:ShowCells()
    self:RefreshPlayer()
end

function UIThronePresidentHonourView:ShowCells()
    self:ClearScroll()
    self:GetDataList()
    local count = table.count(self.list)
    if count > 0 then
        self.show_go:SetActive(true)
        self.empty_text:SetActive(false)
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    else
        self.show_go:SetActive(false)
        self.empty_text:SetActive(true)
    end
end

function UIThronePresidentHonourView:ClearScroll()
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(UIThronePresidentHonourCell)--清循环列表gameObject
end

function UIThronePresidentHonourView:OnCellMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scroll_view:AddComponent(UIThronePresidentHonourCell, itemObj)
    local param = self.list[index]
    item:ReInit(param)
    if self.count == index and param.round ~= 1 then
        local record = DataCenter.GovernmentManager:GetKingsHistoryRecord()
        if record ~= nil then
            DataCenter.GovernmentManager:GetKingHistory(LuaEntry.Player:GetSrcServerId(), record:GetNeedPage())
        end
    end
end

function UIThronePresidentHonourView:OnCellMoveOut(itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UIThronePresidentHonourCell)
end

function UIThronePresidentHonourView:GetDataList()
    self.list = {}
    local record = DataCenter.GovernmentManager:GetKingsHistoryRecord()
    if record ~= nil then
        self.list = record:GetShowList()
    end
    self.count = #self.list
end

function UIThronePresidentHonourView:GovernmentHistoryRecordRefreshSignal()
    self:ShowCells()
end

function UIThronePresidentHonourView:OnClickPlayerHead()
    local curPresident = DataCenter.GovernmentManager:GetCurPresident()
    if curPresident ~= nil and curPresident.uid ~= LuaEntry.Player.uid then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIOtherPlayerInfo,{ anim = true, hideTop = true}, curPresident.uid)
    end
end

function UIThronePresidentHonourView:RefreshPlayer()
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

return UIThronePresidentHonourView
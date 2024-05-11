---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/4/22 18:56
---
local UIPuzzleMonsterListView = BaseClass("UIPuzzleMonsterListView",UIBaseView)
local UIPuzzleMonsterTroopCell = require "UI.UIPuzzleMonster.UIPuzzleMonsterList.Component.UIPuzzleMonsterTroopCell"
local base = UIBaseView

local txt_title_path ="UICommonPopUpTitle/bg_mid/titleText"
local close_btn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local return_btn_path = "UICommonPopUpTitle/panel"
local scroll_path = "ImgBg/ScrollView"
local empty_txt_path = "ImgBg/TxtEmpty"


function UIPuzzleMonsterListView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

function UIPuzzleMonsterListView:ComponentDefine()
    self.txt_title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)

    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.return_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)

    self.ScrollView = self:AddComponent(UIScrollView, scroll_path)
    self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
        self:OnItemMoveIn(itemObj, index)
    end)
    self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
        self:OnItemMoveOut(itemObj, index)
    end)
    self.empty_txt = self:AddComponent(UIText, empty_txt_path)
end

function UIPuzzleMonsterListView:ComponentDestroy()
end

function UIPuzzleMonsterListView:DataDefine()
    self.showDatalist ={}

end

function UIPuzzleMonsterListView:DataDestroy()
end

function UIPuzzleMonsterListView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIPuzzleMonsterListView:OnEnable()
    base.OnEnable(self)
end

function UIPuzzleMonsterListView:OnDisable()
    base.OnDisable(self)
end

function UIPuzzleMonsterListView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.OnPuzzleMonsterDataRefresh, self.RefreshList)
end

function UIPuzzleMonsterListView:OnRemoveListener()
    self:RemoveUIListener(EventId.OnPuzzleMonsterDataRefresh, self.RefreshList)
    base.OnRemoveListener(self)
end

function UIPuzzleMonsterListView:ReInit()
    self.puzzleType = self:GetUserData()
    self.txt_title:SetLocalText(302172)
    if self.puzzleType == PuzzleMonsterType.Activity then
        DataCenter.ActivityPuzzleDataManager:SendGetPuzzleBossMarch()
        self.empty_txt:SetLocalText(372251)
    else
        DataCenter.RadarBossManager:SendGetRadarBossMarch()
        self.empty_txt:SetLocalText(GameDialogDefine.CALL_RADAR_BOSS_NEED_FINISH_RADAR)
    end
    self:RefreshList()
end

function UIPuzzleMonsterListView:RefreshList()
    self:ClearScroll()
    self.showDatalist = self.ctrl:GetMarchInfoList(self.puzzleType)
    local count = #self.showDatalist
    if count > 0 then
        self.ScrollView:SetTotalCount(count)
        self.ScrollView:RefillCells()
        self.empty_txt:SetActive(false)
    else
        self.empty_txt:SetActive(true)
    end
end


function UIPuzzleMonsterListView:ClearScroll()
    self.ScrollView:ClearCells()
    self.ScrollView:RemoveComponents(UIPuzzleMonsterTroopCell)
    self.showDatalist = {}
end

function UIPuzzleMonsterListView:OnItemMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local cellItem = self.ScrollView:AddComponent(UIPuzzleMonsterTroopCell, itemObj)
    cellItem:SetItemShow(self.showDatalist[index])
end

function UIPuzzleMonsterListView:OnItemMoveOut(itemObj, index)
    self.ScrollView:RemoveComponent(itemObj.name, UIPuzzleMonsterTroopCell)
end

return UIPuzzleMonsterListView
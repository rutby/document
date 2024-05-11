--- 查看死亡士兵记录界面
--- Created by shimin.
--- DateTime: 2023/1/31 18:46
---
local UIDeadArmyRecordView = BaseClass("UIDeadArmyRecordView", UIBaseView)
local base = UIBaseView
local UIDeadArmyRecordCell = require "UI.UIDeadArmyRecord.Component.UIDeadArmyRecordCell"

local title_text_path = "UICommonMidPopUpTitle/bg_mid/titleText"
local return_btn_path = "UICommonMidPopUpTitle/panel"
local close_btn_path = "UICommonMidPopUpTitle/bg_mid/CloseBtn"
local des_text_path = "DesText"
local tile_text_1_path = "Common_bg_name_bg/TitleText1"
local tile_text_2_path = "Common_bg_name_bg/TitleText2"
local scroll_view_path = "ScrollView"

local OneRowCount = 3 --一行最多显示5个士兵图标
local ShowDeadReasonList = {ArmyDeadType.Fight, ArmyDeadType.Hospital}

--创建
function UIDeadArmyRecordView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
function UIDeadArmyRecordView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIDeadArmyRecordView:ComponentDefine()
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.return_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
    self.tile_text_1 = self:AddComponent(UITextMeshProUGUIEx, tile_text_1_path)
    self.tile_text_2 = self:AddComponent(UITextMeshProUGUIEx, tile_text_2_path)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCreateCell(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnDeleteCell(itemObj, index)
    end)
end

function UIDeadArmyRecordView:ComponentDestroy()
end

function UIDeadArmyRecordView:DataDefine()
    self.list = {}
end

function UIDeadArmyRecordView:DataDestroy()
    self.list = {}
end
function UIDeadArmyRecordView:OnEnable()
    base.OnEnable(self)
end

function UIDeadArmyRecordView:OnDisable()
    base.OnDisable(self)
end

function UIDeadArmyRecordView:ReInit()
    self.title_text:SetLocalText(GameDialogDefine.RECENT_DEAD)
    self.tile_text_1:SetLocalText(GameDialogDefine.TIME)
    self.tile_text_2:SetLocalText(GameDialogDefine.DEAD_UNIT)
    self.des_text:SetLocalText(GameDialogDefine.DEAD_UNIT_DESC)
    self:ShowCells()
end

function UIDeadArmyRecordView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.RefreshDeadArmyRecord, self.RefreshDeadArmyRecordSignal)
end

function UIDeadArmyRecordView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.RefreshDeadArmyRecord, self.RefreshDeadArmyRecordSignal)
end


function UIDeadArmyRecordView:RefreshDeadArmyRecordSignal()
    self:ShowCells()
end
function UIDeadArmyRecordView:ShowCells()
    self:ClearScroll()
    self:GetDataList()
    local count = table.count(self.list)
    if count > 0 then
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    end
    DataCenter.DeadArmyRecordManager:SetReadRecordTime()
end

function UIDeadArmyRecordView:ClearScroll()
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(UIDeadArmyRecordCell)--清循环列表gameObject
end

function UIDeadArmyRecordView:OnCreateCell(itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scroll_view:AddComponent(UIDeadArmyRecordCell, itemObj)
    item:ReInit(self.list[index])
end

function UIDeadArmyRecordView:OnDeleteCell(itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UIDeadArmyRecordCell)
end

function UIDeadArmyRecordView:GetDataList()
    local recordData = DataCenter.DeadArmyRecordManager:GetDeadArmyRecord()
    self.list = {}
    local curCount = 0
    local curListIndex = 0
    local arrCount = 0
    for k, v in ipairs(recordData) do
        local paramList = {}
        curListIndex = 1
        paramList[curListIndex] = {}
        paramList[curListIndex].leftName = UITimeManager:GetInstance():TimeStampToTimeForLocal(v.time)
        paramList[curListIndex].list = {}
        for k2, v2 in ipairs(ShowDeadReasonList) do
            local list = v:GetDeadDataByDeadType(v2)
            if list ~= nil then
                arrCount = #list
                curCount = 0
                paramList[curListIndex].deadType = v2
                --这里有点绕,如果有数据就把前一个线隐藏
                if curListIndex ~= 1 then
                    paramList[curListIndex - 1].showLine = false
                end
                for k1, v1 in ipairs(list) do
                    curCount = curCount + 1
                    local param = {}
                    param.armyId = v1.armyId
                    param.count = v1.count
                    table.insert(paramList[curListIndex].list, param)
                    if k1 == arrCount then
                        paramList[curListIndex].showLine = true
                        table.insert(self.list, paramList[curListIndex])
                        curListIndex = curListIndex + 1
                        paramList[curListIndex] = {}
                        paramList[curListIndex].leftName = ""
                        paramList[curListIndex].list = {}
                        paramList[curListIndex].showLine = false
                    elseif curCount >= OneRowCount then
                        curCount = 0
                        table.insert(self.list, paramList[curListIndex])
                        curListIndex = curListIndex + 1
                        paramList[curListIndex] = {}
                        paramList[curListIndex].leftName = ""
                        paramList[curListIndex].list = {}
                        paramList[curListIndex].showLine = false
                    end
                end
            end
        end
    end
end



return UIDeadArmyRecordView
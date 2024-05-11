---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl
--- DateTime:
--- 
local UIActMonsterTowerTaskView = BaseClass("UIActMonsterTowerTaskView", UIBaseView)
local base = UIBaseView

local UIActMTTaskCell = require "UI.UIActMonsterTowerTask.Component.UIActMTTaskCell"

local title_path = "UICommonPopUpTitle/bg_mid/titleText"
local scroll_view_path = "ImgBg/ScrollView"
local closeBtn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local maskBtn_path = "UICommonPopUpTitle/panel"

local function OnCreate(self)
    base.OnCreate(self)
    self.actId = self:GetUserData()
    self:ComponentDefine()
    self:DataDefine()
end

local function OnDestroy(self)
    self:SetCellDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
    self:ReInit()
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ComponentDefine(self)
    self.title = self:AddComponent(UITextMeshProUGUIEx,title_path)
    self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
    self.closeBtnN:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.maskBtnN = self:AddComponent(UIButton, maskBtn_path)
    self.maskBtnN:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCreateCell(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnDeleteCell(itemObj, index)
    end)
end

local function ComponentDestroy(self)
    --self.testN = nil
    self.goalN = nil
    self.tip1N = nil
    self.tip2N = nil
    self.tip3N = nil
    self.tip4N = nil
    self.joinBtnN = nil
    self.joinBtnTxtN = nil
    self.createBtnN = nil
    self.createBtnTxtN = nil
    self.closeBtnN = nil
end

local function DataDefine(self)

end

local function DataDestroy(self)

end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.ActMonTowerGetTask, self.OnRefresh)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.ActMonTowerGetTask, self.OnRefresh)
end

local function ReInit(self)
    self.title:SetLocalText(372414)
    SFSNetwork.SendMessage(MsgDefines.GetChallengeActTaskInfo,self.actId)
end

local function OnRefresh(self)
    self.actData = DataCenter.ActMonsterTowerData:GetInfoByActId(self.actId)
    self.list = self.actData:GetTask()
    local actListData = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(self.actId))
    self.str = string.split(actListData.para1,"|")
    self.scroll_view:SetTotalCount(#self.list)
    self.scroll_view:RefillCells()
end

local function OnCreateCell(self, itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scroll_view:AddComponent(UIActMTTaskCell, itemObj)
    item:ShowRewards(self.list[index],self.str[index],self.actData.finishDifficulty)
end

local function OnDeleteCell(self, itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UIActMTTaskCell)
end

local function SetCellDestroy(self)
    self.scroll_view:ClearCells()
    self.scroll_view:RemoveComponents(UIActMTTaskCell)
end

UIActMonsterTowerTaskView.OnCreate = OnCreate
UIActMonsterTowerTaskView.OnDestroy = OnDestroy
UIActMonsterTowerTaskView.ComponentDefine = ComponentDefine
UIActMonsterTowerTaskView.DataDefine = DataDefine
UIActMonsterTowerTaskView.DataDestroy = DataDestroy
UIActMonsterTowerTaskView.OnAddListener = OnAddListener
UIActMonsterTowerTaskView.OnRemoveListener = OnRemoveListener
UIActMonsterTowerTaskView.OnRefresh = OnRefresh
UIActMonsterTowerTaskView.ReInit = ReInit
UIActMonsterTowerTaskView.SetCellDestroy = SetCellDestroy
UIActMonsterTowerTaskView.OnEnable = OnEnable
UIActMonsterTowerTaskView.OnDisable = OnDisable
UIActMonsterTowerTaskView.ComponentDestroy = ComponentDestroy
UIActMonsterTowerTaskView.OnCreateCell = OnCreateCell
UIActMonsterTowerTaskView.OnDeleteCell = OnDeleteCell
return UIActMonsterTowerTaskView
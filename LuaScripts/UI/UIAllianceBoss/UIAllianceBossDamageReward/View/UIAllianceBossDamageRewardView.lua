local UIAllianceBossDamageReward = BaseClass("UIAllianceBossDamageReward", UIBaseView)
local base = UIBaseView
local UIAllianceBossDamageRewardViewCell = require "UI.UIAllianceBoss.UIAllianceBossDamageReward.Component.UIAllianceBossDamageRewardViewCell"
local UIPveActStageTip = require "UI.UIActivityCenterTable.Component.UIActivityDonateSoldier.DonateSoldierStageTip"

-- path define start

local panel_path = "UICommonPopUpTitle/panel"
local title_text_path = "UICommonPopUpTitle/bg_mid/titleText"
local common_btn_close_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local name_des_path = "ImgBg/nameDes"
local scroll_view_path = "ImgBg/ScrollView"
local u_i_pve_act_stage_tip_path = "UIPveActStageTip"
local root_path = "UIPveActStageTip/Root"
local bg_path = "UIPveActStageTip/Root/Bg"


--path define end

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
end

local function OnDestroy(self)
    base.OnDestroy(self)
    self:ComponentDestroy()
end

local function OnEnable(self)
    base.OnEnable(self)
    self:ShowCells()
end

local function OnDisable(self)
    base.OnDisable(self)

end

local function ComponentDefine(self)
    
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
    self.title_text:SetLocalText(373004) -- 标题
    self.common_btn_close = self:AddComponent(UIButton, common_btn_close_path)
    self.common_btn_close:SetOnClick(function() 
        self.ctrl:CloseSelf()
    end)

    self.panel = self:AddComponent(UIButton, panel_path)
    self.panel:SetOnClick(function() 
        self.ctrl:CloseSelf()
    end)
    
    self.name_des = self:AddComponent(UITextMeshProUGUIEx, name_des_path)
    self.name_des:SetLocalText(373006) -- 奖励说明

    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:CellMoveIn(itemObj, index)
    end)

    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:CellMoveOut(itemObj, index)
    end)

    self.u_i_pve_act_stage_tip = self:AddComponent(UIPveActStageTip, u_i_pve_act_stage_tip_path)
    self.root = self:AddComponent(UIBaseContainer, root_path)
    self.bg = self:AddComponent(UIBaseContainer, bg_path)
    
    self.dataList = {}
end

local function ComponentDestroy(self)

    self.title_text = nil
    self.common_btn_close = nil
    self.name_des = nil
    self.scroll_view = nil
    self.dataList = nil
    self.panel = nil
    self.u_i_pve_act_stage_tip = nil
    self.root = nil
    self.bg = nil
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.ShowAllianceBossRewardBoxByPosAndItemid, self.OnShowRewardTip)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.ShowAllianceBossRewardBoxByPosAndItemid, self.OnShowRewardTip)
    base.OnRemoveListener(self)
end

-- scrollview 相关

local function CellMoveIn(self, itemObj, index)
    local cellName = tostring(index)
    itemObj.name = cellName
    local cell = self.scroll_view:AddComponent(UIAllianceBossDamageRewardViewCell, itemObj)
    local cellData = self.dataList[index]
    cell:SetData(cellData,index)
end

local function CellMoveOut(self, itemObj, index)
    local cellName = tostring(index)
    self.scroll_view:RemoveComponent(cellName, UIAllianceBossDamageRewardViewCell)
end

local function ClearScroll(self)
    self.scroll_view:ClearCells()
    self.scroll_view:RemoveComponents(UIAllianceBossDamageRewardViewCell)
end

local function ShowCells(self)
    self:ClearScroll()
    self.dataList = DataCenter.AllianceBossManager:GetDamageRewardCellsData()
    if self.dataList == nil then
        return
    end
    self.stage = 0
    local currDamage = DataCenter.AllianceBossManager:GetCurrBossSelfDamage()
    local moveIndex = 0
    if currDamage then
        for i = 1 ,table.count(self.dataList) do
            if currDamage < self.dataList[i].damage then
                self.stage = i - 1
                if i > 3 then
                    moveIndex = i - 2
                end
                break
            end
        end
        if self.stage == 0 then
            if currDamage >= self.dataList[#self.dataList].damage then
                self.stage = #self.dataList
                moveIndex = #self.dataList - 2
            end
        end
    end
    local cellCount = #self.dataList
    self.scroll_view:SetTotalCount(cellCount)
    if cellCount > 0 then
        self.scroll_view:RefillCells(moveIndex ~= 0 and moveIndex or nil)
    end
end

-- scrollview 结束

local function OnShowRewardTip(self, data)
    if data.reward ~= nil then
        local rewards = DataCenter.RewardManager:ReturnRewardParamForView(data.reward)
        self.u_i_pve_act_stage_tip:SetActive(true)
        self.u_i_pve_act_stage_tip:SetData(rewards)
        self.u_i_pve_act_stage_tip:Show()
        self.root.transform.localPosition = self.u_i_pve_act_stage_tip.transform:InverseTransformPoint(data.pos)
    end
end

UIAllianceBossDamageReward.OnCreate = OnCreate
UIAllianceBossDamageReward.OnDestroy = OnDestroy
UIAllianceBossDamageReward.OnEnable = OnEnable
UIAllianceBossDamageReward.OnDisable = OnDisable
UIAllianceBossDamageReward.ComponentDefine = ComponentDefine
UIAllianceBossDamageReward.ComponentDestroy = ComponentDestroy
UIAllianceBossDamageReward.CellMoveIn = CellMoveIn
UIAllianceBossDamageReward.CellMoveOut = CellMoveOut
UIAllianceBossDamageReward.ClearScroll = ClearScroll
UIAllianceBossDamageReward.ShowCells = ShowCells
UIAllianceBossDamageReward.OnAddListener = OnAddListener
UIAllianceBossDamageReward.OnRemoveListener = OnRemoveListener
UIAllianceBossDamageReward.OnShowRewardTip = OnShowRewardTip

return UIAllianceBossDamageReward
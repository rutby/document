local UIAllianceBossDonateResourceCell = BaseClass("UIAllianceBossDonateRankPanelCell", UIBaseContainer)
local base = UIBaseContainer
local UICommonItem = require "UI.UICommonItem.UICommonItem"

-- path define start

local u_i_common_res_item_path = "UICommonItem"
-- local item_name_label_path = "MainItemNode/ItemNameLabel"
local can_donate_label_path = "BtnNode/CanDonateLabel"
local exp_label_path = "BtnNode/ExpLabel"
local complete_reward_res_item_path = "CompleteRewardNode/CompleteRewardResItem"
-- local MaxText_path = "CompleteRewardNode/CompleteRewardResItem3/MaxText"
-- local single_donate_reward_label_path = "DonateRewardNode/SingleDonateRewardLabel"
local reward_scroll_content_path = "DonateRewardNode/RewardScroll/Viewport/RewardScrollContent"
local donate_btn_path = "BtnNode/DonateBtn"
local goto_btn_path = "BtnNode/GotoBtn"
local finished_btn_path = "BtnNode/FinishedBtn"
local donate_btn_name_path = "BtnNode/DonateBtn/DonateBtnName"
local goto_btn_name_path = "BtnNode/GotoBtn/GotoBtnName"
local finish_btn_name_path = "BtnNode/FinishedBtn/FinishBtnName"
local itemNum_txt_path = "UICommonItem/clickBtn/NumText"



-- path define end

local scrollCellWidth = 75
local scrollViewWidth = 240

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

end

local function OnDisable(self)
    base.OnDisable(self)

end

local function ComponentDefine(self)

    self.u_i_common_res_item = self:AddComponent(UICommonItem, u_i_common_res_item_path)
    -- self.item_name_label = self:AddComponent(UITextMeshProUGUIEx, item_name_label_path)
    self.can_donate_label = self:AddComponent(UITextMeshProUGUIEx, can_donate_label_path)
    self.complete_reward_res_item = {}
    for i = 1 ,3 do
        self.complete_reward_res_item[i] = self:AddComponent(UICommonItem, complete_reward_res_item_path..i)
    end
  
    -- self.MaxText = self:AddComponent(UITextMeshProUGUIEx, MaxText_path)
    -- self.MaxText:SetLocalText(450128)
    -- self.single_donate_reward_label = self:AddComponent(UITextMeshProUGUIEx, single_donate_reward_label_path)
    self.reward_scroll_content = self:AddComponent(UIBaseContainer, reward_scroll_content_path)
    self.donate_btn = self:AddComponent(UIButton, donate_btn_path)
    
    self.exp_label = self:AddComponent(UITextMeshProUGUIEx,exp_label_path)

    self.donate_btn_name = self:AddComponent(UITextMeshProUGUIEx, donate_btn_name_path)
    self.donate_btn_name:SetLocalText(390448)
    self.goto_btn_name = self:AddComponent(UITextMeshProUGUIEx, goto_btn_name_path)
    self.goto_btn_name:SetLocalText(130067)
    self.finish_btn_name = self:AddComponent(UITextMeshProUGUIEx, finish_btn_name_path)
    self.finish_btn_name:SetLocalText(390448)

    self.donate_btn:SetOnClick(function()
        self:OnDonateBtnClick()
    end)
    self.goto_btn = self:AddComponent(UIButton, goto_btn_path)
    self.goto_btn:SetOnClick(function()
        self:OnGotoBtnClick()
    end)
    self.finished_btn = self:AddComponent(UIButton, finished_btn_path)
    CS.UIGray.SetGray(self.finished_btn.transform, true, true)
    self.finished_btn:SetOnClick(function()
        self:OnReachLimitBtnClick()
    end)
    self.cellData = {}
    self.cells = {}
    
    self._itemNum_txt = self:AddComponent(UITextMeshProUGUIEx,itemNum_txt_path)
end

local function ComponentDestroy(self)
    self.u_i_common_res_item = nil
    -- self.item_name_label = nil
    self.can_donate_label = nil
    -- self.donate_reward_label = nil
    -- self.single_donate_reward_label = nil
    self.reward_scroll_content = nil
    self.donate_btn = nil
    self.goto_btn = nil
    self.finished_btn = nil
    self.donate_btn_name = nil
    self.goto_btn_name = nil
    self.finish_btn_name = nil


end

local function OnAddListener(self)

end

local function OnRemoveListener(self)

end

local function SetData(self, data)
    self.cellData = data
    self.can_donate_label:SetLocalText(373012, tostring(self.cellData.donateLimit - self.cellData.donateNum) .. "/" .. tostring(self.cellData.donateLimit))--当前可捐献次数：{}
    self.exp_label:SetLocalText(373042,data.exp)
    self:SetCurrentItemInfo()
    self:SetCompleteReward()
    self:CreateRewardListCell()
    self:OnChangeBtnState()
end

local function SetCurrentItemInfo(self)
    local para = {}
    para.rewardType = RewardType.GOODS
    para.itemId = tostring(self.cellData.itemId)

    local num = 0
    local template = DataCenter.ItemTemplateManager:GetItemTemplate(para.itemId)
    if template ~= nil then
       -- self.des_text:SetText(DataCenter.ItemTemplateManager:GetDes(template.id))
        --self.item_quality_img:LoadSprite(DataCenter.ItemTemplateManager:GetToolBgByColor(template.color))
        local text = DataCenter.ItemTemplateManager:GetName(template.id)
        -- self.item_name_label:SetLocalText(text)
        local costItem = DataCenter.ItemData:GetItemById(template.id)
        num = costItem and costItem.count or 0
    end
    self.u_i_common_res_item:ReInit(para)
    self.u_i_common_res_item:SetItemCountActive(true)
    self._itemNum_txt:SetText(num)
end 

-- 创建捐献完毕可获得的cell
local function SetCompleteReward(self)
    local reward = self.cellData.finalReward
    if reward and #reward > 0 then
        for i = 1 ,table.count(reward) do
            local para = {}
            para.rewardType = reward[i].type
            para.itemId = reward[i].value.id
            para.count = reward[i].value.num
            self.complete_reward_res_item[i]:ReInit(para)
        end
    end
end

-- 创建每次捐献可获得的奖励cell
local function CreateRewardListCell(self)
    self.reward_scroll_content:RemoveComponents(UICommonItem)
    local reward = self.cellData.donateReward
    if reward == nil then
        return
    end
    self.donateReward = nil
    local rewardSize = #reward
    if reward ~= nil then
        for k,v in ipairs(reward) do
            self.cells[k] = self:GameObjectInstantiateAsync(UIAssets.UICommonItemSize, function(request)
                if request.isError then
                    return
                end
                if self.reward_scroll_content ~= nil then
                    local go = request.gameObject
                    go.gameObject:SetActive(true)
                    go.transform:SetParent(self.reward_scroll_content.transform)
                    -- go.transform:Set_localScale(0.5, 0.5, 0.5)
                    local nameStr = tostring(NameCount)
                    go.name = nameStr
                    NameCount = NameCount + 1
                    local cell = self.reward_scroll_content:AddComponent(UICommonItem, nameStr)
                    local para = {}
                    para.rewardType = v.type
                    if type(v.value) == 'number' then
                        para.count = v.value
                    else
                        para.itemId = v.value.id
                        para.count = v.value.num
                    end

                    cell:ReInit(para)
                    self.donateReward = cell
                    if rewardSize == k then
                        --最后一个cell 加载完要刷新layout宽度 然后把content的位置设置到最前面
                        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.reward_scroll_content.transform)
                        local fullWidth = scrollCellWidth * rewardSize
                        if fullWidth > scrollViewWidth then
                            local moveDelta = fullWidth - scrollViewWidth
                            self.reward_scroll_content.transform.position.x = -moveDelta / 2
                        end
                    end
                end
            end)
        end
    end
    
end

local function SetAllNeedCellDestroy(self)
    if self.cells then
        for k,v in pairs(self.cells) do
            if v ~= nil then
                self:GameObjectDestroy(v)
            end
        end
    end

    self.cells = {}
end

-- 切换按钮状态
local function OnChangeBtnState(self)
    if self.cellData.donateNum < self.cellData.donateLimit then
        local itemData = DataCenter.ItemData:GetItemById(self.cellData.itemId)
        if itemData ==nil then
            self.donate_btn:SetActive(false)
            self.goto_btn:SetActive(true)
            self.finished_btn:SetActive(false)
            return
        end
        local curNum = itemData and itemData.count or 0
        if curNum > 0 then
            --有道具 显示捐献按钮
            self.donate_btn:SetActive(true)
            self.goto_btn:SetActive(false)
            self.finished_btn:SetActive(false)
        else
            self.donate_btn:SetActive(false)
            self.goto_btn:SetActive(true)
            self.finished_btn:SetActive(false)
        end
    else
        self.donate_btn:SetActive(false)
        self.goto_btn:SetActive(false)
        self.finished_btn:SetActive(true)
    end
end

-- 点击捐献按钮
local function OnDonateBtnClick(self)
    local state = self.view:GetDonateState()
    if not state then
        return
    end
    if self.donateReward then
        local pic = self.donateReward:GetIconPath()
        local rewardType = RewardType.ALLIANCE_BOSS_DONATE
        local flyPos = self.view.common_btn_close.transform.position
        UIUtil.DoFly(rewardType, 3, pic, self.donateReward:GetPosition(), flyPos, 73, 73)
    end
    self.view:UpdateDonateState(false)
    DataCenter.AllianceBossManager:OnSendAllianceBossDonateMessage(self.cellData.itemId, 1)
end

-- 点击获取途径（goto）按钮
local function OnGotoBtnClick(self)
    local itemId = self.cellData.itemId
    local lackTab = {}
    local param = {}
    param.type = ResLackType.Item--RewardType.GOODS
    param.id = tonumber(itemId)
    param.targetNum = 1
    table.insert(lackTab, param)
    GoToResLack.GoToItemResLackList(lackTab)
end

-- 点击已达上限按钮
local function OnReachLimitBtnClick(self)
    UIUtil.ShowTipsId(373020)
end

UIAllianceBossDonateResourceCell.OnCreate = OnCreate
UIAllianceBossDonateResourceCell.OnDestroy = OnDestroy
UIAllianceBossDonateResourceCell.OnEnable = OnEnable
UIAllianceBossDonateResourceCell.OnDisable = OnDisable
UIAllianceBossDonateResourceCell.ComponentDefine = ComponentDefine
UIAllianceBossDonateResourceCell.ComponentDestroy = ComponentDestroy
UIAllianceBossDonateResourceCell.OnAddListener = OnAddListener
UIAllianceBossDonateResourceCell.OnRemoveListener = OnRemoveListener
UIAllianceBossDonateResourceCell.SetData = SetData
UIAllianceBossDonateResourceCell.SetCurrentItemInfo = SetCurrentItemInfo
UIAllianceBossDonateResourceCell.SetCompleteReward = SetCompleteReward
UIAllianceBossDonateResourceCell.CreateRewardListCell = CreateRewardListCell
UIAllianceBossDonateResourceCell.SetAllNeedCellDestroy = SetAllNeedCellDestroy
UIAllianceBossDonateResourceCell.OnChangeBtnState = OnChangeBtnState
UIAllianceBossDonateResourceCell.OnDonateBtnClick = OnDonateBtnClick
UIAllianceBossDonateResourceCell.OnGotoBtnClick = OnGotoBtnClick
UIAllianceBossDonateResourceCell.OnReachLimitBtnClick = OnReachLimitBtnClick


return UIAllianceBossDonateResourceCell
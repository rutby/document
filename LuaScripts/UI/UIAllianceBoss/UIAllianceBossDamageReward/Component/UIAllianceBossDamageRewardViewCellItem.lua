local UIAllianceBossDamageRewardViewCellItem = BaseClass("UIAllianceBossDamageRewardViewCellItem", UIBaseContainer)
local base = UIBaseContainer

-- path define

local click_node_path = "ClickNode"
local num_text_path = "NumText"

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
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ComponentDefine(self)
    self.click_node = self:AddComponent(UIButton, click_node_path)
    self.num_text = self:AddComponent(UITextMeshProUGUIEx, num_text_path)
    self.click_node:SetOnClick(function()
        self:ShowGoodsTip()
    end)
end

local function ComponentDestroy(self)
    self.click_node = nil
    self.num_text = nil
end

local function SetData(self, data)
    self.cellData = data
    self.num_text:SetText("")
    self:UpdateItem()
end

-- 刷新道具图标（宝箱）
local function UpdateItem(self)
end

-- 点击宝箱弹出道具说明（实际上显示的是配置里面的另一套reward）
local function ShowGoodsTip(self)
    local broadCastData = {}
    broadCastData.pos = self.transform.position
    broadCastData.reward = self.cellData.reward
    EventManager:GetInstance():Broadcast(EventId.ShowAllianceBossRewardBoxByPosAndItemid, broadCastData)
end

UIAllianceBossDamageRewardViewCellItem.OnCreate = OnCreate
UIAllianceBossDamageRewardViewCellItem.OnDestroy = OnDestroy
UIAllianceBossDamageRewardViewCellItem.OnEnable = OnEnable
UIAllianceBossDamageRewardViewCellItem.OnDisable = OnDisable
UIAllianceBossDamageRewardViewCellItem.ComponentDefine = ComponentDefine
UIAllianceBossDamageRewardViewCellItem.ComponentDestroy = ComponentDestroy
UIAllianceBossDamageRewardViewCellItem.SetData = SetData
UIAllianceBossDamageRewardViewCellItem.UpdateItem = UpdateItem
UIAllianceBossDamageRewardViewCellItem.ShowGoodsTip = ShowGoodsTip

return UIAllianceBossDamageRewardViewCellItem
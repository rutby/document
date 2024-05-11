--- Created by shimin
--- DateTime: 2023/3/21 12:07
--- 王座嘉奖记录界面cell

local UIThroneSendListCell = BaseClass("UIThroneSendListCell", UIBaseContainer)
local base = UIBaseContainer

local des_text_path = "txtContent"

function UIThroneSendListCell:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIThroneSendListCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIThroneSendListCell:OnEnable()
    base.OnEnable(self)
end

function UIThroneSendListCell:OnDisable()
    base.OnDisable(self)
end

function UIThroneSendListCell:ComponentDefine()
    self.des_text = self:AddComponent(UIText, des_text_path)
end

function UIThroneSendListCell:ComponentDestroy()

end

function UIThroneSendListCell:DataDefine()
    self.param = {}
end

function UIThroneSendListCell:DataDestroy()
    self.param = {}
end

function UIThroneSendListCell:OnAddListener()
    base.OnAddListener(self)
end

function UIThroneSendListCell:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIThroneSendListCell:ReInit(param)
    self.param = param
    local record = DataCenter.GovernmentManager:GetRewardRecord()
    if record ~= nil then
        self.des_text:SetLocalText(GameDialogDefine.PRESIDENT_SOMEONE_REWARD_SOMEONE_SOMETHING, 
                record:GetPresidentName(), self.param:GetPlayerName(), self.param:GetPacketName())
    end
end

return UIThroneSendListCell
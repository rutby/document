---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2021/9/7 12:22
---
local PickGarbageView = BaseClass("PickGarbageView", UIBaseContainer)
local base = UIBaseContainer
local MailRewardItemChange = require "UI.UIMailNew.UIMailMainPanel.Component.MailRewardItemChange"

local _cp_txtMainTitle = "UIMailItemTitle/txtMainTitle"
local _cp_txtSubTitle = "UIMailItemTitle/txtSubTitle"
local _cp_txtTime = "Reward/Info/timeText"
local _cp_txtDesc = "Reward/Info/txtDesc"
local _cp_posText_path = "Reward/Info/posText"
local _cp_objReward = "Reward/objRewardNode"
--local _cp_rewardBg_path = "Reward/Reward_Bg"



function PickGarbageView:OnCreate()
    base.OnCreate(self)
    self._txtMainTitle = self:AddComponent(UITextMeshProUGUIEx, _cp_txtMainTitle)
    self._txtSubTitle = self:AddComponent(UITextMeshProUGUIEx, _cp_txtSubTitle)
    self._txtTime = self:AddComponent(UITextMeshProUGUIEx, _cp_txtTime)
    self._txtDesc = self:AddComponent(UITextMeshProUGUIEx, _cp_txtDesc)
    self._objReward = self:AddComponent(UIBaseContainer, _cp_objReward)
    self._posText = self:AddComponent(UITextMeshProUGUIEx, _cp_posText_path)
    self.reqList = {}
end

function PickGarbageView:OnDisable()
    self:ReleaseAllRewardItem()
    base.OnDisable(self)
end

function PickGarbageView:setData( maildata )
    self._mailData = maildata
    -- 设置数据
    local _strTitle = MailShowHelper.GetMainTitle(maildata)
    self._txtMainTitle:SetText(_strTitle)
    local _strSubTitle = MailShowHelper.GetMailSubTitle(maildata)
    self._txtSubTitle:SetText(_strSubTitle)
    local _strTime = MailShowHelper.GetAbstractCreateTime(maildata)
    self._txtTime:SetText(_strTime)
    local _strContents = self:GetEventDescription(maildata)
    self._txtDesc:SetText(_strContents)
    -- 创建奖励
    self._objReward:SetActive(true)
    self:ReleaseAllRewardItem()
    self:ShowReward(maildata)
end

function PickGarbageView:ShowRewardItem(rewardData)
    local req = self:GameObjectInstantiateAsync(UIAssets.UICommonItemChange114, function(request)
        if request.isError then
            return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self._objReward.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        NameCount = NameCount + 1
        local nameStr = tostring(NameCount)
        go.name = nameStr
        local cell = self._objReward:AddComponent(MailRewardItemChange, nameStr)
        cell:RefreshData(rewardData)
    end)
    table.insert(self.reqList, req)
end

function PickGarbageView:ShowReward(maildata)
    local pay = maildata:GetMailPay()
    local reward = maildata:GetMailReward()
    local totalCnt = 0
    -- 检测钻石
    if pay ~= nil then
        local goldCnt = pay["gold"] or 0
        if goldCnt > 0 then
            totalCnt = totalCnt + 1
            self:ShowRewardItem({["rewardType"] = RewardType.GOLD, ["itemId"] = "gold", ["count"] = goldCnt})
        end
    end
    -- 检测道具
    if reward ~= nil and reward["rewardInfo"] ~= nil then
        local rewardList = self:GetRewardItemList(reward["rewardInfo"])
        for _, param in pairs(rewardList) do
            totalCnt = totalCnt + 1
            self:ShowRewardItem(param)
        end
    end
    return totalCnt
end

function PickGarbageView:GetRewardItemList( tabReward )
    local tabItemReward = {}
    -- 老邮件历史处理，保留到21.10.01
    if type(tabReward) ~= "table" then
        return tabItemReward
    end
    
    for _, iteminfo in pairs(tabReward) do
        local tmp = {}
        tmp["rewardType"] = iteminfo["type"]
        tmp["itemId"] = iteminfo["id"]
        tmp["count"] = iteminfo["num"]
        table.insert(tabItemReward, tmp)
    end
    return tabItemReward
end

function PickGarbageView:GetEventDescription(maildata)
    local mailExt =  maildata:GetMailExt();
    if mailExt ~= nil then
        return mailExt:GetDescription()
    end
    return ""
end

function PickGarbageView:ReleaseAllRewardItem()
    for k, v in ipairs(self.reqList) do
        v:Destroy()
    end
    self.reqList = {}
end

return PickGarbageView
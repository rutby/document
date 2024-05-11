---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/3/9 15:58
---

local MailPlayerResResult = BaseClass("MailPlayerResResult",UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local MailRewardItem = require "UI.UIMailNew.UIMailMainPanel.Component.MailRewardItem"

local _cp_txtRewardTitle = "ResourceTitle"
local _cp_ObjRewardNode = "List"
local _cp_txtPlunder = "Plunder"
local _cp_btnPlunder = "PlunderBtn"
local _cp_txtDesc = "Empty/Txt"
local _cp_txtBg = "Empty"

function MailPlayerResResult:DataDefine()
    self._totalItemCnt = 0
    self.battleResult = FightResult.DEFAULT
    self.reqList = {}
end

function MailPlayerResResult:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self._txtRewardTitle = self:AddComponent(UITextMeshProUGUIEx, _cp_txtRewardTitle)
    self._objRewardNode = self:AddComponent(UIBaseContainer, _cp_ObjRewardNode)
    self._txtBg = self:AddComponent(UIBaseContainer, _cp_txtBg)
    self._txtPlunder = self:AddComponent(UITextMeshProUGUIEx, _cp_txtPlunder)
    self._btnPlunder = self:AddComponent(UIButton, _cp_btnPlunder)
    self._btnPlunder:SetOnClick(function()
        self:OnPlunderClick()
    end)
    self._txtDesc = self:AddComponent(UITextMeshProUGUIEx, _cp_txtDesc)
end

function MailPlayerResResult:OnEnable()
    base.OnEnable(self)
end

function MailPlayerResResult:OnDisable()
    self:ReleaseAllRewardItem()
    base.OnDisable(self)
end

function MailPlayerResResult:ReleaseAllRewardItem()
    for k, v in ipairs(self.reqList) do
        v:Destroy()
    end
    self.reqList = {}
end
function MailPlayerResResult:GetResCount()
    return self._totalItemCnt
end

--[[
    在这个地方,如果自己输了,直接显示输了就完了
    如果自己赢了,则需要做出对应的处理
        如果对方是monster这种,左侧显示奖励
        如果对方不是Monster,则右侧需要显示lost
]]
function MailPlayerResResult:SetData(leftFightData,rightFightData,bigRoundIndex, maildata,leftUuid,rightUuid,resultDesc)
    self._mailInfo = maildata
    self.leftFightData = leftFightData
    self.rightFightData = rightFightData
    self._targetBattleType = rightFightData.battleType
    self.leftUuid = leftUuid
    self.rightUuid = rightUuid
    self.selfMarchUuid = 0
    self._totalItemCnt = 0
    self:ReleaseAllRewardItem()
    --if self.leftFightData.unitData~=nil then
    --    self.selfMarchUuid = self.leftFightData.unitData:GetArmyUuidByUid(LuaEntry.Player.uid)
    --else
    --    self.selfMarchUuid = self.leftFightData.selfInMemberUuid
    --end
    -- 检测输赢
    local roundBattle = self._mailInfo:GetMailExt():GetFightReportByRoundIndex(bigRoundIndex)
    if (roundBattle== nil) then
        return
    end
    self.battleResult = roundBattle:GetBattleResult()
    if self.battleResult == FightResult.SELF_WIN then
        self._txtRewardTitle:SetLocalText(310140)
    elseif self.battleResult == FightResult.OTHER_WIN then
        self._txtRewardTitle:SetLocalText(311137)
    else
        self._txtRewardTitle:SetText("")
    end
    self._targetBattleType = roundBattle:GetTargetBattleType()
    self._txtPlunder:SetText("")
    self._btnPlunder:SetActive(false)
    local plunderResRate = roundBattle:GetPlunderResRate(leftUuid)
    if plunderResRate ~= nil and plunderResRate>0 then
        self._txtPlunder:SetLocalText(300132, plunderResRate)
        -- self._btnPlunder:SetActive(true)
    end
    self:ShowNormalMode(roundBattle,self.leftUuid)
    self:ShowResReward( roundBattle:GetResRewardItemArr(self.leftUuid) )
    if self._totalItemCnt<=0 then
        self:ShowLostMode(self._mailInfo,self.rightUuid)
    end
    self._txtBg:SetActive(resultDesc ~= "")
    self._txtDesc:SetText(resultDesc)
end

--function MailPlayerResResult:IsMonsterMode()
--    if (self._targetBattleType == BattleType.Monster or self._targetBattleType == BattleType.Boss) then
--        return true
--    end
--    return false
--end

--function MailPlayerResResult:ShowMonsterMode( roundBattle,selfMarchUuid)
--    self:ShowReward( roundBattle:GetRewardItemArr(selfMarchUuid) )
--    self:ShowResReward( roundBattle:GetResRewardItemArr(selfMarchUuid) )
--end

function MailPlayerResResult:ShowNormalMode(roundBattle,leftUuid)
    local fightRes = roundBattle:GetFightResItemArr(leftUuid)
    if (table.count(fightRes) > 0) then
        self:ShowResRewardByType(fightRes)
    end
end

function MailPlayerResResult:ShowLostMode(maildata,rightUuid)
    local fightRes = maildata:GetMailExt():GetResLostListByTargetUuid(rightUuid)
    self._txtPlunder:SetText("")
    self._btnPlunder:SetActive(false)
    if (table.count(fightRes) > 0) then
        self:ShowResRewardByType(fightRes)
    end
    local fightResItem = maildata:GetMailExt():GetResItemLostListByTargetUuid(rightUuid)
    if (table.count(fightResItem) > 0) then
        self:ShowResReward(fightResItem)
    end
end

function MailPlayerResResult:ShowResRewardByType( resArray )
    for resType, cnt in pairs(resArray) do
        local itemInfo = {["resourceType"] = resType, ["itemId"] = resType, ["count"] = cnt}
        self._totalItemCnt = self._totalItemCnt + 1
        self:AddItemNode(itemInfo)
    end
end

function MailPlayerResResult:ShowResReward( resArray )
    -- deleted
end

function MailPlayerResResult:ShowReward( itemArray )
    for itemId, cnt in pairs(itemArray) do
        local itemInfo = {["rewardType"] = RewardType.GOODS, ["itemId"] = itemId, ["count"] = cnt}
        self._totalItemCnt = self._totalItemCnt + 1
        self:AddItemNode(itemInfo)
    end
end

function MailPlayerResResult:AddItemNode( itemInfo )
    local req = self:GameObjectInstantiateAsync(UIAssets.UICommonItemSize, function(request)
        if request.isError then
            return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self._objRewardNode.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        NameCount = NameCount + 1
        local nameStr = tostring(NameCount)
        go.name = nameStr
        local cell = self._objRewardNode:AddComponent(MailRewardItem, nameStr)
        cell:RefreshData(itemInfo, true)
    end)
    table.insert(self.reqList, req)
end

function MailPlayerResResult:OnPlunderClick()
    local param = {}
    param.type = "desc"
    param.title = ""
    param.desc = Localization:GetString("300144")
    param.alignObject = self._btnPlunder
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

return MailPlayerResResult
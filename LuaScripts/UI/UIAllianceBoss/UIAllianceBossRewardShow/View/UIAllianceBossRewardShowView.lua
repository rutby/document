local UIAllianceBossRewardShow = BaseClass("UIAllianceBossRewardShow", UIBaseView)
local base = UIBaseView
local AllianceBossReward = require "UI.UIAllianceBoss.UIAllianceBossRewardShow.Component.AllianceBossReward"
-- path define start

local title_text_path = "UICommonMidPopUpTitle/bg_mid/titleText"
local close_btn_path = "UICommonMidPopUpTitle/bg_mid/CloseBtn"
local grid_layout_path = "HeroTrialRewardCell/rewardBg/Rewards"
local panel_path = "UICommonMidPopUpTitle/panel"
local des1_path = "des1"
local des2_path = "HeroTrialRewardCell/rewardBg/TitleBg/des2"

--path define end

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:CreateShowGoods()
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
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
    self.title_text:SetLocalText(373004)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.grid_layout = self:AddComponent(UIBaseContainer, grid_layout_path)

    self.panel = self:AddComponent(UIButton, panel_path)
    self.panel:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)

    self.des1 = self:AddComponent(UITextMeshProUGUIEx, des1_path)
    self.des1:SetLocalText(110468) --描述1
    self.des2 = self:AddComponent(UITextMeshProUGUIEx, des2_path)
    self.des2:SetLocalText(373004) --描述

    self.cells = {}
end


local function ComponentDestroy(self)
    for k,v in ipairs(self.cells) do
        if v then
            self:GameObjectDestroy(v)
        end
    end
end

-- 创建展示itemcell 用多个reward合成一个reward然后展示出来
local function CreateShowGoods(self)
    -- 获取当前boss伤害对应的奖励
    local curDamageList = DataCenter.AllianceBossManager:GetDamageRewardCellsData()
    local curDamage = DataCenter.AllianceBossManager:GetCurrBossSelfDamage()

    local reachLevel = 1
    local multiple = 1
    for k,v in ipairs(curDamageList) do
        if v.damage > curDamage then
            break
        end
        reachLevel = k
        multiple = v.itemNum
    end
    local rewardObj = {}
    for i = 1 ,table.count(curDamageList) do
        if i <= reachLevel then
            rewardObj[i] = DataCenter.RewardManager:ReturnRewardParamForView(curDamageList[i].reward)
        end
    end
    local reward = self.ctrl:MergeRewardGoodsAsOne(rewardObj)
    -- local mergedReward = self.ctrl:MergeRewardGoodsAsOne() --不用合并 但是得要把倍数乘上
    local smallIconPath = self:GetIconPathByBossLevel(false)
    local txt = self:GetUserData()
    for k,v in pairs(reward) do
        self.cells[k] = self:GameObjectInstantiateAsync(UIAssets.AllianceBossRewardPrefabPath, function(request)
            if request.isError then
                return
            end
            local go = request.gameObject
            go.gameObject:SetActive(true)
            go.transform:SetParent(self.grid_layout.transform)
            -- go.transform:Set_localScale(0.8, 0.8, 0.8)
            local nameStr = tostring(NameCount)
            go.name = nameStr
            NameCount = NameCount + 1
            local cell = self.grid_layout:AddComponent(AllianceBossReward, nameStr)
            cell:ReInit(v)
            cell:LoadBossInfo(smallIconPath,txt)
        end)
    end
end

local function GetIconPathByBossLevel(self, big)
    local activityData = DataCenter.AllianceBossManager:GetActivityData(self.activityId)
    if activityData == nil then
        return
    end
    local levelVec = string.split(activityData.para2, "|")
    local bossInfo = DataCenter.AllianceBossManager:GetBossInfo()
    if bossInfo == nil then
        return
    end
    local index = 1
    for k,v in ipairs(levelVec) do
        if bossInfo.lv >= toInt(v) then
            index = k
        else
            break
        end
    end

    local nameText = "Assets/Main/Sprites/UI/UIAllianceBoss/activity_alianceboss_"
    if big then
        nameText = nameText .. "da_"
    else
        nameText = nameText .. "xiao_"
    end

    nameText = nameText .. tostring(index)
    return nameText
end

UIAllianceBossRewardShow.OnCreate = OnCreate
UIAllianceBossRewardShow.OnDestroy = OnDestroy
UIAllianceBossRewardShow.OnEnable = OnEnable
UIAllianceBossRewardShow.OnDisable = OnDisable
UIAllianceBossRewardShow.ComponentDefine = ComponentDefine
UIAllianceBossRewardShow.ComponentDestroy = ComponentDestroy
UIAllianceBossRewardShow.CreateShowGoods = CreateShowGoods
UIAllianceBossRewardShow.GetIconPathByBossLevel = GetIconPathByBossLevel


return UIAllianceBossRewardShow
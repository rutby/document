
local UICountBattleMapStageInfoTip = BaseClass("UICountBattleMapStageInfoTip",UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local RewardItem = require "UI.UIWorldPoint.Component.WorldPointRewardItem"

local compBook =
{
    { path="Bg/Name",               name="txtName",             type=UIText },
    { path="Bg/Desc",               name="txtDesc",             type=UIText },
    { path="Bg/Reward",             name="txtReward",           type=UIText },
    { path="Bg/RewardItems",        name="rootRewards",         type=UIBaseContainer },
    { path="Bg/EnterBtn",           name="btnEnter",            type=UIButton },
    { path="Bg/EnterBtn/Text",      name="txtEnter",            type=UIText },
    { path="Arrow",                 name="arrow",               type=nil },
    { path="Bg",                    name="bg",                  type=nil },
}

local styleLayouts = 
{
    [1] = { arrowPos=Vector3(0, 95.5, 0), arrowRot=Vector3(0, 0, 0), bgPos=Vector3(0, 90, 0), fadeOffset=Vector2(0, 50) },  -- top
    [2] = { arrowPos=Vector3(-44.6, 55, 0), arrowRot=Vector3(0, 0, 90), bgPos=Vector3(-275, -123, 0), fadeOffset=Vector2(-50, 0) },  -- left
    [3] = { arrowPos=Vector3(44.6, 55, 0), arrowRot=Vector3(0, 0, -90), bgPos=Vector3(275, -123, 0), fadeOffset=Vector2(50, 0) },  -- right
    [4] = { arrowPos=Vector3(0, -71, 0), arrowRot=Vector3(0, 0, 180), bgPos=Vector3(0, -411, 0), fadeOffset=Vector2(0, -50) },  -- bottom
}

local function OnCreate(self)
    base.OnCreate(self)
    self:DefineCompsByBook(compBook)
    self.txtEnter:SetText(Localization:GetString(450102))
    self.txtReward:SetText(Localization:GetString(2000072))
    self.canvasGroup = self.gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
end

local function OnDestroy(self)
    self:ClearCompsByBook(compBook)
    base.OnDestroy(self)

    if self.fadeTween then
        self.fadeTween:Kill()
    end
    self.fadeTween = nil
    if self.moveTween then
        self.moveTween:Kill()
    end
    self.moveTween = nil

    if self.rewardItems then
        for _, rewardItem in ipairs(self.rewardItems) do
            if rewardItem then
                rewardItem:Destroy()
            end
        end
    end
    self.rewardItems = nil
    self.canvasGroup = nil
    self.onClickEnter = nil
end

local function __FadeIn(self, srcPos, dstPos)
    if self.fadeTween then
        self.fadeTween:Kill()
    end
    if self.moveTween then
        self.moveTween:Kill()
    end

    self:SetActive(true)
    self.canvasGroup.alpha = 0
    self.fadeTween = self.canvasGroup:DOFade(1, 0.25)

    self.transform.position = srcPos
    self.transform:DOMove(dstPos, 0.25):SetEase(CS.DG.Tweening.Ease.OutQuad)
end

local function __FadeOut(self, srcPos, dstPos)
    if self.fadeTween then
        self.fadeTween:Kill()
    end
    if self.moveTween then
        self.moveTween:Kill()
    end

    self.canvasGroup.alpha = 1
    self.fadeTween = self.canvasGroup:DOFade(0, 0.25):OnComplete(function()
        self:SetActive(false)
    end)

    self.transform.position = srcPos
    self.transform:DOMove(dstPos, 0.25):SetEase(CS.DG.Tweening.Ease.InQuad)
end

local function Refresh(self, stageId, position, style)
    local nameKey = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.LW_Count_Stage), stageId, "name")
    local descKey = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.LW_Count_Stage), stageId, "desc")
    local order = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.LW_Count_Stage), stageId, "order")
    self.txtName:SetText(string.gsub(Localization:GetString(tostring(nameKey)), "{0}", tostring(order)))
    self.txtDesc:SetText(Localization:GetString(tostring(descKey)))

    local isNext = DataCenter.LWCountStageManager.nextStageId == stageId
    self.btnEnter:SetActive(isNext)
    self.btnEnter:SetOnClick(function()
        if self.onClickEnter then
            self.onClickEnter(stageId)
        end
    end)

    local rewardDatas = {}
    local rewardStrArr = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.LW_Count_Stage), stageId, "reward_show")
    for _, rewardStr in ipairs(rewardStrArr) do
        local rewardData = DataCenter.RewardManager:ParseOneRewardStr(rewardStr)
        if rewardData then
            table.insert(rewardDatas, rewardData)
        end
    end

    self.rootRewards:RemoveComponents(RewardItem)
    if self.rewardItems then
        for _, rewardItem in ipairs(self.rewardItems) do
            if rewardItem then
                rewardItem:Destroy()
            end
        end
    end

    self.rewardItems = {}
    for i = 1, #rewardDatas do
        local handle = CS.GameEntry.Resource:InstantiateAsync("Assets/Main/Prefabs/UI/Monopoly/RewardItemBig.prefab")
        handle:completed('+', function(handle)
            local go = handle.gameObject;
            local trans = go.transform
            trans:SetParent(self.rootRewards.transform)
            trans:Set_localScale(1, 1, 1)
            go.name = "rewardItem_"..i
            local cell = self.rootRewards:AddComponent(RewardItem, go.name)
            cell:RefreshData(rewardDatas[i])
        end)
        self.rewardItems[i] = handle
    end

    local layout = styleLayouts[style]
    self.arrow.transform.localPosition = layout.arrowPos
    self.arrow.transform.localEulerAngles = layout.arrowRot
    self.bg.transform.localPosition = layout.bgPos
    
    self.fadePosition = position + layout.fadeOffset
    self.anchorPosition = position
    __FadeIn(self, self.fadePosition, self.anchorPosition)
end

local function Hide(self)
    __FadeOut(self, self.anchorPosition, self.fadePosition)
end

local function OnClickEnter(self)
end

UICountBattleMapStageInfoTip.OnCreate = OnCreate
UICountBattleMapStageInfoTip.OnDestroy = OnDestroy
UICountBattleMapStageInfoTip.Refresh = Refresh
UICountBattleMapStageInfoTip.Hide = Hide
UICountBattleMapStageInfoTip.OnClick = OnClickEnter

return UICountBattleMapStageInfoTip
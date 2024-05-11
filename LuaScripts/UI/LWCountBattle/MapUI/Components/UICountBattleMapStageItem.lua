
local UICountBattleMapStageItem = BaseClass("UICountBattleMapStageItem",UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local compBook =
{
    { path="Icon",                  name="iconNode",       type=nil },
    { path="Icon/Next",             name="imgNext",        type=UIImage},
    { path="Icon/Lock",             name="imgLock",        type=UIImage},
    { path="Icon/Pass",             name="imgPass",        type=UIImage},
    { path="NameText",              name="txtName",        type=UIText},
    { path="Click",                 name="btnClick",       type=UIButton },
}

local function OnCreate(self)
    base.OnCreate(self)
    self:DefineCompsByBook(compBook)
    self.btnClick:SetOnClick(function ()
        self:OnClick()
    end)
    self.canvasGroup = self.gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
end

local function OnDestroy(self)
    self:ClearCompsByBook(compBook)
    base.OnDestroy(self)
    if self.fadeTween then
        self.fadeTween:Kill()
    end
    self.fadeTween = nil
    if self.dropTween then
        self.dropTween:Kill()
    end
    self.dropTween = nil
    
    self.canvasGroup = nil
    self.onClick = nil
end

local function __FadeIn(self, drop)
    if self.fadeTween then
        self.fadeTween:Kill()
    end
    self.canvasGroup.alpha = 0
    self.fadeTween = self.canvasGroup:DOFade(1, 0.5)

    if self.dropTween then
        self.dropTween:Kill()
    end
    if drop then
        self.iconNode.transform.anchoredPosition = Vector2.New(0, 50)
        self.dropTween = self.iconNode.transform:DOAnchorPosY(0, 0.25):SetDelay(0.25):SetEase(CS.DG.Tweening.Ease.InQuad)
    end
end

local function Refresh(self, stageId)
    local order = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.LW_Count_Stage), stageId, "order")
    self.txtName:SetText(tostring(order))
    local isNext = DataCenter.LWCountStageManager.nextStageId == stageId
    local isPassed = DataCenter.LWCountStageManager.doneStageIds[stageId] == true
    self.imgPass:SetActive(isPassed)
    self.imgNext:SetActive(isNext)
    self.imgLock:SetActive(not isNext and not isPassed)
    __FadeIn(self, isNext)
end

local function OnClick(self)
    if self.onClick then
        self.onClick()
    end
end

local function SetOnClick(self, onClick)
    self.onClick = onClick
end

UICountBattleMapStageItem.OnCreate = OnCreate
UICountBattleMapStageItem.OnDestroy = OnDestroy
UICountBattleMapStageItem.Refresh = Refresh
UICountBattleMapStageItem.OnClick = OnClick
UICountBattleMapStageItem.SetOnClick = SetOnClick

return UICountBattleMapStageItem
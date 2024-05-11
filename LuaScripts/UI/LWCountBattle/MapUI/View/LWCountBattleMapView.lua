local base = UIBaseView--Variable
local LWCountBattleMapView = BaseClass("LWCountBattleMapView", base)--Variable
local Localization = CS.GameEntry.Localization
local UICountBattleMapStageItem = require "UI.LWCountBattle.MapUI.Components.UICountBattleMapStageItem"
local UICountBattleMapStageInfoTip = require "UI.LWCountBattle.MapUI.Components.UICountBattleMapStageInfoTip"

local compBook = 
{
    { path="Bg",                                    name="imgBg",                   type=UIRawImage },
    { path="Title",                                 name="txtTitle",                type=UIText },
    { path="StageItems/StageItem1",                 name="itemStage1",              type=UICountBattleMapStageItem },
    { path="StageItems/StageItem2",                 name="itemStage2",              type=UICountBattleMapStageItem },
    { path="StageItems/StageItem3",                 name="itemStage3",              type=UICountBattleMapStageItem },
    { path="StageItems/StageItem4",                 name="itemStage4",              type=UICountBattleMapStageItem },
    { path="StageItems/StageItem5",                 name="itemStage5",              type=UICountBattleMapStageItem },
    { path="StageItems/StageItem6",                 name="itemStage6",              type=UICountBattleMapStageItem },
    { path="StageItems/StageItem7",                 name="itemStage7",              type=UICountBattleMapStageItem },
    { path="StageItems/StageItem8",                 name="itemStage8",              type=UICountBattleMapStageItem },
    { path="CloseBtn",                              name="btnClose",                type=UIButton},
    { path="NextBtn",                               name="btnNext",                 type=UIButton},
    { path="PreviousBtn",                           name="btnPrev",                 type=UIButton},
    { path="TipMask",                               name="btnTipMask",              type=UIButton},
    { path="StageInfoTip",                          name="tipStageInfo",            type=UICountBattleMapStageInfoTip},
}

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    --self:Refresh(DataCenter.LWCountStageManager.chapterCfg)
    --local params = self:GetUserData()
    --if params and params.autoShowTip then
    --    self.timer = TimerManager:GetInstance():DelayInvoke(function()
    --        self:TryAutoShowTipForNextStage()
    --    end, 0.5)
    --end
end

local function OnDestroy(self)
    if self.timer then
        self.timer:Stop()
        self.timer = nil
    end
    self:ComponentDestroy()
    base.OnDestroy(self)
    self.chapterCfg = nil
end

local function ComponentDefine(self)
    self:DefineCompsByBook(compBook)

    self.btnClose:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)

    self.btnNext:SetOnClick(function()
        self:OnClickNextChapter()
    end)

    self.btnPrev:SetOnClick(function()
        self:OnClickPrevChapter()
    end)

    self.btnTipMask:SetOnClick(function()
        self:OnClickTipMask()
    end)

    self.btnTipMask:SetActive(false)
    self.tipStageInfo:SetActive(false)

    self.tipStageInfo.onClickEnter = function(stageId)
        self:OnClickEnterStage(stageId)
    end
end

local function ComponentDestroy(self)
    self:ClearCompsByBook(compBook)
end

local function ReInit(self,params)
    self:Refresh(DataCenter.LWCountStageManager.chapterCfg)
    if params and params.autoShowTip then
        self.timer = TimerManager:GetInstance():DelayInvoke(function()
            self:TryAutoShowTipForNextStage()
        end, 0.5)
    end
end

local function OnClickNextChapter(self)
    local index = table.indexof(DataCenter.LWCountStageManager.chapterCfgs, self.chapterCfg) + 1
    local nextChapterCfg = DataCenter.LWCountStageManager.chapterCfgs[index]
    if nextChapterCfg then
        self:Refresh(DataCenter.LWCountStageManager.chapterCfgs[index])
    else
        UIUtil.ShowTipsId(302109)
    end
end

local function OnClickPrevChapter(self)
    local index = table.indexof(DataCenter.LWCountStageManager.chapterCfgs, self.chapterCfg) - 1
    self:Refresh(DataCenter.LWCountStageManager.chapterCfgs[index])
end

local function OnClickTipMask(self)
    self.tipStageInfo:Hide()
    self.btnTipMask:SetActive(false)
end

local function OnClickStageItem(self, stageItem, stageId, tipStyle)
    local isNext = DataCenter.LWCountStageManager.nextStageId == stageId
    if isNext then
        self:OnClickEnterStage(stageId)
    else
        self.btnTipMask:SetActive(true)
        self.tipStageInfo:Refresh(stageId, stageItem.transform.position, tipStyle)
    end
end

local function Refresh(self, chapterCfg)
    if not chapterCfg then return end

    if self.timer then
        self.timer:Stop()
        self.timer = nil
    end

    if self.btnTipMask.activeSelf then
        self.tipStageInfo:Hide()
        self.btnTipMask:SetActive(false)
    end

    self.chapterCfg = chapterCfg

    local bgImgPath = LocalController:instance():getValue("lw_count_stage_chapter", chapterCfg.id, "bgImg")
    local bgImgTex = CS.GameEntry.Resource:LoadAsset(bgImgPath, typeof(CS.UnityEngine.Texture2D))
    if not IsNull(bgImgTex) then
        self.imgBg:SetTexture(bgImgTex.asset)
    end

    local titleKey = LocalController:instance():getValue("lw_count_stage_chapter", chapterCfg.id, "title")
    self.txtTitle:SetText(Localization:GetString(titleKey))

    local index = table.indexof(DataCenter.LWCountStageManager.chapterCfgs, chapterCfg)
    self.btnPrev.gameObject:SetActive(index > 1)
    -- self.btnNext.gameObject:SetActive(index < #DataCenter.LWCountStageManager.chapterCfgs)

    for i = 1, 8 do
        local stageItem = self["itemStage"..i]
        local stageId = chapterCfg.stageIds[i]
        if stageId then
            stageItem:SetActive(true)
            stageItem:Refresh(stageId)
            stageItem:SetOnClick(function()
                self:OnClickStageItem(stageItem, stageId, chapterCfg.nodeTipStyleArr[i])
            end)
            stageItem.transform.localPosition = chapterCfg.nodePosArr[i]
        else
            stageItem:SetActive(false)
        end
    end
end

local function TryAutoShowTipForNextStage(self)
    -- if not self.chapterCfg then return end

    -- for i = 1, 8 do
    --     local stageItem = self["itemStage"..i]
    --     local stageId = self.chapterCfg.stageIds[i]
    --     if stageId then
    --         local isNext = DataCenter.LWCountStageManager.nextStageId == stageId
    --         if isNext then
    --             self:OnClickStageItem(stageItem, stageId, self.chapterCfg.nodeTipStyleArr[i])
    --             break
    --         end
    --     end
    -- end
end

local function OnClickEnterStage(self, stageId)
    local satistify = true
    local buildingConditions = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.LW_Count_Stage), stageId, "building_condition")
    for _, buildingCondition in ipairs(buildingConditions) do
        local buildingId = math.floor(buildingCondition / 1000) * 1000
        local buildingLv = buildingCondition % 1000
        local maxLvBuilding = DataCenter.BuildManager:GetMaxLvBuildDataByBuildId(buildingId)
        if not maxLvBuilding or maxLvBuilding.level < buildingLv then
            satistify = false
            local tipMsg = Localization:GetString(800371)
            local buildingNameKey = LocalController:instance():getValue(LuaEntry.Player:GetABTestTableName(TableName.Building), buildingId, "name")
            tipMsg = string.gsub(tipMsg, "{0}", Localization:GetString(buildingNameKey))
            tipMsg = string.gsub(tipMsg, "{1}", tostring(buildingLv))
            -- UIUtil.ShowTips(tipMsg)
            UIUtil.ShowMessage(tipMsg, 2, 801037, 393010, function()
                if self.ctrl then
                    self.ctrl:CloseSelf()
                end
                GoToUtil.GotoCityByBuildId(buildingId, WorldTileBtnType.City_Upgrade)
            end)
            break
        end
    end

    if satistify then
        local param = {}
        param.type = PVEType.Count
        param.levelId = tonumber(stageId)
        DataCenter.LWBattleManager:Enter(param)
        DataCenter.LWCountStageManager.autoOpenMapUIWhenBackToCity = true
    end
end

LWCountBattleMapView.OnCreate = OnCreate
LWCountBattleMapView.OnDestroy = OnDestroy
LWCountBattleMapView.ComponentDefine = ComponentDefine
LWCountBattleMapView.ComponentDestroy = ComponentDestroy
LWCountBattleMapView.OnClickNextChapter = OnClickNextChapter
LWCountBattleMapView.OnClickPrevChapter = OnClickPrevChapter
LWCountBattleMapView.OnClickTipMask = OnClickTipMask
LWCountBattleMapView.OnClickStageItem = OnClickStageItem
LWCountBattleMapView.OnClickEnterStage = OnClickEnterStage
LWCountBattleMapView.Refresh = Refresh
LWCountBattleMapView.TryAutoShowTipForNextStage = TryAutoShowTipForNextStage
LWCountBattleMapView.ReInit = ReInit

return LWCountBattleMapView
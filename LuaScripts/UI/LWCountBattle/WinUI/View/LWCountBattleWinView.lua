local LWCountBattleWinView = BaseClass("LWCountBattleWinView",UIBaseView)
local base = UIBaseView
local Time = Time
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
--local UICommonResItem = require "UI.UICommonResItem.UICommonResItem"
local UIHeroCellSmall = require "UI.UIHero2.Common.UIHeroCellSmall"
local LayoutLayer = 'Layout/'

function LWCountBattleWinView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:RefreshView()
end

function LWCountBattleWinView:OnDestroy()
    if self.scoreTween then
        self.scoreTween:Kill()
    end
    if self.showRewardAnimCo then 
        self.showRewardAnimCo = nil
    end
    if self.reqs ~= nil then
        for _, v in pairs(self.reqs) do
            v:Destroy()
        end
        self.reqs = nil
    end
    base.OnDestroy(self)
end

function LWCountBattleWinView:ComponentDefine()
    self.bg = self:AddComponent(UIImage,'Image')
    self.bg:SetAlpha(0)

    self.layout = self:AddComponent(UIBaseContainer, LayoutLayer)
    self.layout:SetActive(false)
    self.backBtn = self:AddComponent(UIButton, LayoutLayer.."BackBtn")
    self.backBtn:SetOnClick(function()
        self:OnBackBtnClick()
    end)

    self.levelText = self:AddComponent(UIText,LayoutLayer.."LevelText")
    -- self.timeText = self:AddComponent(UIText,LayoutLayer.."TimeText")
    -- self.killNumText = self:AddComponent(UIText,LayoutLayer.."KillNumText")

    -- score
    self.scoreEntry = self:AddComponent(UIBaseContainer,LayoutLayer.."ScoreEntry")
    self.scoreText = self:AddComponent(UIText,LayoutLayer.."ScoreEntry/txt_score")

    -- rank
    self.rankEntry = self:AddComponent(UIBaseContainer,LayoutLayer.."RankEntry")
    self.rankText1 = self:AddComponent(UIText,LayoutLayer.."RankEntry/txt_rank1")
    self.rankText2 = self:AddComponent(UIText,LayoutLayer.."RankEntry/txt_rank2")
    self.rankText3 = self:AddComponent(UIText,LayoutLayer.."RankEntry/txt_rank3")

    -- reward
    self.rewardContent = self.transform:Find(LayoutLayer.."RewardBg").gameObject
    self.rewardTitle1 = self:AddComponent(UIText,LayoutLayer.."RewardBg/RewardTitle1")
    self.rewardGrid1 = self:AddComponent(UIBaseContainer,LayoutLayer.."RewardBg/RewardGrid1")
    -- reward hero
    self.HeroRewardContent = self.transform:Find(LayoutLayer.."HeroRewardBg").gameObject
    self.HeroRewardTitle1 = self:AddComponent(UIText,LayoutLayer.."HeroRewardBg/RewardTitle2")
    self.HeroRewardGrid1 = self:AddComponent(UIBaseContainer,LayoutLayer.."HeroRewardBg/RewardGrid2")
    -- reward worker
    self.WorkerRewardContent = self.transform:Find(LayoutLayer.."WorkerRewardBg").gameObject
    self.WorkerRewardTitle1 = self:AddComponent(UIText,LayoutLayer.."WorkerRewardBg/RewardTitle3")
    self.WorkerRewardGrid1 = self:AddComponent(UIBaseContainer,LayoutLayer.."WorkerRewardBg/RewardGrid3")

    -- self.nextBtnText = self:AddComponent(UIText,"NextBtn/NextBtnText")
    self.backBtnText = self:AddComponent(UIText,LayoutLayer.."BackBtn/BackBtnText")
    
    self.victoryText = self:AddComponent(UIText,LayoutLayer.."Title/VictoryGo/VictoryText")

    local param = self:GetUserData()
    local stageId = param.stageId

    self.levelText:SetText(Localization:GetString(GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Count_Stage), stageId,'name'),GetTableData(TableName.LW_Count_Stage, stageId,'order')))
    --self.nextBtnText:SetText(Localization:GetString("171002"))

    if not CommonUtil.IsArabic() then
        self.rankText1:SetText(Localization:GetString("800827"))
        self.rankText3:SetText(Localization:GetString("800828"))
    else
        self.rankText1:SetText(Localization:GetString("800828"))
        self.rankText3:SetText(Localization:GetString("800827"))
    end


    --新手引导ID会提前进入下一个state 这里判断第二关
    local backBtnName =  800306
    self.backBtnText:SetText(Localization:GetString(backBtnName))
    self.victoryText:SetText(Localization:GetString("311105"));

    self.rewardTitle1:SetText(Localization:GetString("800305"))
    self.HeroRewardTitle1:SetLocalText(800324)--(Localization:GetString("800305"))
    self.WorkerRewardTitle1:SetLocalText(800325)--(Localization:GetString("800305"))

    self.showSeq = {
        self.levelText,
        -- self.killNumText,
        -- self.timeText,
        self.scoreEntry,
        self.rankEntry,
        self.rewardContent,
        self.HeroRewardContent,
        self.WorkerRewardContent,
        self.backBtn
    }
    for _, c in ipairs(self.showSeq) do
        c:SetActive(false)
        c.transform:Set_localScale(0,0,0)
    end

    --if DataCenter.ParkourManager.reward and  DataCenter.ParkourManager.rewardStageId == stageId then
    --    self:OnGetReward(DataCenter.ParkourManager.reward)
    --end
    --self:ShowRewardAnim()
end

function LWCountBattleWinView:DataDefine()
    self.flyRewardList = {}
    self.heroId = nil
end


function LWCountBattleWinView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.CountBattleReward, self.OnGetReward)
    self:AddUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)

end

function LWCountBattleWinView:OnRemoveListener()
    self:RemoveUIListener(EventId.CountBattleReward, self.OnGetReward)
    self:RemoveUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)

    base.OnRemoveListener(self)
end

function LWCountBattleWinView:OnKeyCodeEscape()
    TimerManager:GetInstance():DelayFrameInvoke(function()
        self:OnBackBtnClick()
    end, 1)
end

function LWCountBattleWinView:ComponentDestroy()
    self.back_btn = nil
end

function LWCountBattleWinView:RefreshView()
    DataCenter.LWSoundManager:PlaySound(10024)
    local param = self:GetUserData()
    -- local time = param.time
    -- local kill = param.kill
    -- self.killNumText:SetText( Localization:GetString("800303") .. kill)
    -- self.timeText:SetText( Localization:GetString("800304")..UITimeManager:GetInstance():SecondToFmtStringWithoutHour(time))

    if self.scoreTween then
        self.scoreTween:Kill()
    end
    self.tempScore = 0
    self.scoreText:SetText("X 0")
    self.scoreTween = CS.DG.Tweening.DOTween.To(function()
        return self.tempScore
    end, function(value)
        self.tempScore = value
        self.scoreText:SetText("X "..math.floor(value))
    end, param.score, 1):SetEase(CS.DG.Tweening.Ease.OutQuad):SetDelay(3):OnComplete(function()
        self.scoreText:SetText("X "..param.score)
    end)
    self.rankText2:SetText(string.format(" %s ",param.rank))
end

function LWCountBattleWinView:OnBackBtnClick()
    local cfg = {}
    for i,v in ipairs(self.flyRewardList) do cfg[i] = {v[1].position, v[2]} end
    EventManager:GetInstance():Broadcast(EventId.UIMainFlyReward,cfg)
    self.ctrl:CloseSelf()
    DataCenter.LWBattleManager:Exit(nil, "win")
end


function LWCountBattleWinView:OnGetReward(param)
    param = DataCenter.RewardManager:ReturnRewardParamForMessage(param) or {}
    if self.reqs ~= nil then
        for _, v in pairs(self.reqs) do
            v:Destroy()
        end
    end
    -- 预处理显示数据
    self.rewardCells = {}
    self.workersCells = {}
    self.herosCells = {}
    
    local s = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), self:GetUserData().stageId, 'visitor_event')

    if tonumber(s) then
        table.insert(param,{rewardType = RewardType.WORKER})
    elseif type(s) == 'string' then
        local spl = string.split(s,'|')
        for _, v in ipairs(spl) do
            if tonumber(v) then
                table.insert(param,{rewardType = RewardType.WORKER})
            end
        end
    end

    -- 展示动画
    --self.reqs = {}
    --self.flyRewardList = {}

    --local index = 0
    --for _, v in pairs(param) do
    --    local req = nil
    --    local p = v
    --    if p.rewardType == RewardType.HERO then
    --        req = Resource:InstantiateAsync(UIAssets.UIHeroCellSmall)
    --    else
    --        req = Resource:InstantiateAsync(UIAssets.UICommonResItem)
    --    end
    --
    --    index = index + 1
    --    local name = index
    --    req:completed('+', function(req)
    --        local go = req.gameObject
    --        go.name = name
    --        if p.rewardType == RewardType.HERO then
    --            go.transform:SetParent(self.HeroRewardGrid1.transform)
    --            table.insert(self.herosCells,go)
    --            self.heroId = p.heroUuid
    --        elseif p.rewardType == RewardType.WORKER then
    --            go.transform:SetParent(self.WorkerRewardGrid1.transform)
    --            table.insert(self.workersCells,go)
    --        else
    --            go.transform:SetParent(self.rewardGrid1.transform)
    --            table.insert(self.rewardCells,go)
    --        end
    --        go.transform:Set_localScale(0, 0, 0)
    --        local cell = nil
    --        if p.rewardType == RewardType.HERO then  -- 估计以后得统一api
    --            cell = self:AddComponent(UIHeroCellSmall,go)
    --            cell:SetData(p.heroUuid)
    --        else
    --            cell = self:AddComponent(UICommonResItem,go)
    --            cell:ReInit(p)
    --        end
    --        cell.gameObject:SetActive(false)
    --        table.insert(self.flyRewardList,{go.transform,p})
    --    end)
    --    table.insert(self.reqs,req)
    --end

    DataCenter.ParkourManager.reward = nil
    DataCenter.ParkourManager.rewardStageId = nil
end


function LWCountBattleWinView:ShowRewardAnim()
    local delay = 0.1
    local scaledelay = 0.2
    local finalScale = 1
    local finalScale2 = 1
    self.showRewardAnimCo = coroutine.start(function ()
        coroutine.waitforseconds(1.5)
        self.layout:SetActive(true)
        if self.bg.unity_image then
            self.bg.unity_image:DOFade(224/255,0.3)
        end
        coroutine.waitforseconds(1)
        for i = 1, #self.showSeq-4 do
            coroutine.waitforseconds(delay)
            self.showSeq[i]:SetActive(true)
            if not IsNull(self.showSeq[i].transform) then
                self.showSeq[i].transform:DOScale(finalScale,scaledelay):SetEase(CS.DG.Tweening.Ease.OutBack)
            end
        end
        coroutine.waitforseconds(delay)
        for i, cells in ipairs({self.rewardCells,self.herosCells,self.workersCells}) do
            if #cells>0 then 
                -- coroutine.start(
                --     function ()
                self.showSeq[#self.showSeq-(4-i)]:SetActive(true)
                self.showSeq[#self.showSeq-(4-i)].transform:DOScale(finalScale,scaledelay):SetEase(CS.DG.Tweening.Ease.OutBack)
                for i = 1, #cells do
                    coroutine.waitforseconds(delay)
                    cells[i]:SetActive(true)

                    cells[i].transform:DOScale(finalScale2,scaledelay):SetEase(CS.DG.Tweening.Ease.OutBack)
                end
                --     end
                -- )
            end
            coroutine.waitforseconds(delay)
        end
         if self.heroId then
             --UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel,{anim=false}, self.heroId,{self.heroId},nil,true)
             if DataCenter.HeroDataManager:NeedShowNewHeroWindow(self.heroId) then
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroExhibitPanel,{anim=false}, self.heroId,{self.heroId},nil,true)
             end
         end
        self.showSeq[#self.showSeq]:SetActive(true)

    end )

end


return LWCountBattleWinView

local ZombieBattleSpeedUp = BaseClass("ZombieBattleSpeedUp", UIBaseContainer)
local base = UIBaseContainer

local INITIAL_CD = 1            -- 加速按钮初始CD
local INTERVAL_CD = 0.5         -- 加速按钮间隔CD
local SPEED_UP_BUFF_ID = 11     -- 加速buff id
local CLICK_PERCENT = 20        -- 点击充能加速按钮的百分比
local ORB_TRAGET = Vector2(726, 306)

local compBook =
{
    -- gasoline button
    { path="Btn",                       name="btnGas",                type=UIButton },
    { path="Btn/Border",                name="imgBtnBorder",          type=UIImage },
    { path="Btn/cd",                    name="imgBtnCD",              type=UIImage },
    { path="Btn/ImgGas",                name="imgGasNormal",          type=UIImage },
    { path="Btn/ImgGasGrey",            name="imgGasGrey",            type=UIImage },
    { path="Btn/ImgGasFever",           name="imgGasFever",           type=UIImage },
    { path="Btn/NumTxt",                name="txtGas",                type=UIText },
    { path="Btn/Ready_Down",            name="readyDown",             type=UIBaseContainer },
    { path="Btn/Ready_Up",              name="readyUp",               type=UIBaseContainer },
    { path="Btn/Fever_Down",            name="feverDown",             type=UIBaseContainer },
    { path="Btn/Fever_Up",              name="feverUp",               type=UIBaseContainer },
    { path="Btn/Cast_Down",             name="castDown",              type=UIBaseContainer },
    { path="Btn/Cast_Up",               name="castUp",                type=UIBaseContainer },

    { path="Btn/Fever_Down/Eff_ui_jiasu_fire_da_xia",   name="vfxFireB",        type=UIBaseContainer },
    { path="Btn/Fever_Up/Eff_ui_jiasu_fire_xiao",       name="vfxFireS",        type=UIBaseContainer },
    { path="Btn/Fever_Up/Eff_ui_jiasu_fire_da_shang",   name="vfxFireL",        type=UIBaseContainer },
    
    -- acceleration tip
    { path="Tip",                               name="tipRoot",               type=UIBaseContainer },
    { path="Tip/labels/txtLabel",               name="lblSpeedUp",            type=UIText },
    { path="Tip/labels/percent",                name="parSpeedUp",            type=UIBaseContainer },
    { path="Tip/labels/percent/txtPercent",     name="txtSpeedUp",            type=UIText },
    { path="Tip/Eff_ui_jiasu_wenben_chuxian",   name="vfxTip",                type=UIBaseContainer },
    
    -- duration timer
    { path="Bar",                       name="barRoot",               type=UIBaseContainer },
    { path="Bar/mask",                  name="barInner",              type=UIImage },
    { path="Bar/timer/Text",            name="txtTimer",              type=UIText },
    { path="Bar/Eff_ui_jiasu_jindutiao_shifang",   name="vfxBar",     type=UIBaseContainer },

    { path="vfxOrb",                    name="vfxOrb",                type=nil },
    { path="Btn/vfxCharge",             name="vfxCharge",             type=nil },
}

function ZombieBattleSpeedUp:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:AddListener()

    self.cdDuration = INITIAL_CD
    self.cdTimer = INITIAL_CD
    self.gasNum = self.maxGasNum
    self.buff = nil
    self.feverCount = 0
    self.displayFeverNum = 0

    self.clickChargeOrbs = {}
    self.clickChargeRate = 0
    
    self:UpdateGasBtn()
end

function ZombieBattleSpeedUp:OnDestroy()
    if self.anchorTween then
        self.anchorTween:Kill()
        self.anchorTween = nil
    end
    if self.scaleTween then
        self.scaleTween:Kill()
        self.scaleTween = nil
    end
    if self.numTween then
        self.numTween:Kill()
        self.numTween = nil
    end

    for _, orb in ipairs(self.clickChargeOrbs) do
        if not IsNull(orb) then
            CS.UnityEngine.GameObject.Destroy(orb)
        end
    end
    self.clickChargeOrbs = nil

    self:RemoveListener()
    self:ComponentDestroy()
    base.OnDestroy(self)
    self.buff = nil
end

function ZombieBattleSpeedUp:ComponentDefine()
    self:DefineCompsByBook(compBook)

    self.funcTurnOn = DataCenter.ZombieBattleManager.pveTemplate.stageMeta.is_speedup > 0
    self.maxGasNum = math.floor(LuaEntry.Effect:GetGameEffect(EffectDefine.LW_PVE_SPEED_UP_GAS_NUM))
    -- printError(LuaEntry.Effect:GetGameEffect(EffectDefine.LW_PVE_SPEED_UP_GAS_NUM))
    -- printError(LuaEntry.Effect:GetGameEffect(EffectDefine.LW_MONOPOLY_FUNCTION_OPEN))

    self.btnGas:SetActive(self.funcTurnOn)
    self.barRoot:SetActive(false)
    self.tipRoot:SetAnchoredPositionXY(600, 445)

    self.btnGas:SetOnClick(function()
        self:OnClickBtn()
    end)

    self.vfxTip:SetActive(false)
    self.castDown:SetActive(false)
    self.castUp:SetActive(false)

    self.lblSpeedUp:SetText(CS.GameEntry.Localization:GetString("100159"))

    self.vfxOrb:SetActive(false)
    self.vfxCharge:SetActive(false)
end

function ZombieBattleSpeedUp:ComponentDestroy()
    self:ClearCompsByBook(compBook)
end

function ZombieBattleSpeedUp:AddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.PVEBuffAdded, self.OnBuffAdded)
    self:AddUIListener(EventId.PVEBuffRemoved, self.OnBuffRemoved)
    -- self:AddUIListener(EventId.SCREEN_TOUCH_CLICK, self.OnScreenTouchClick)  -- 废弃BTest
end

function ZombieBattleSpeedUp:RemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.PVEBuffAdded, self.OnBuffAdded)
    self:RemoveUIListener(EventId.PVEBuffRemoved, self.OnBuffRemoved)
    -- self:RemoveUIListener(EventId.SCREEN_TOUCH_CLICK, self.OnScreenTouchClick)
end

function ZombieBattleSpeedUp:OnUpdate(dt)
    if self.cdDuration > 0 and self.cdTimer > 0 then
        self.cdTimer = self.cdTimer - dt
        if self.cdTimer <= 0 then
            self.cdDuration = 0
            self.cdTimer = 0
        end
    end

    self:UpdateGasBtn()
end

function ZombieBattleSpeedUp:CanUseSpeedUp()
    local battleMgr = DataCenter.ZombieBattleManager
    if self.gasNum <= 0 then
        return false, 800805
    end
    if self.cdTimer > 0 then
        return false, nil
    end
    if battleMgr.gameOver then
        return false, 800807
    end
    if battleMgr.gamePause then
        return false, 800807
    end
    if not battleMgr.squad or not battleMgr.squad.destination then
        return false, 800806
    end
    return true
end

function ZombieBattleSpeedUp:OnClickBtn()
    local canUse, tipsId = self:CanUseSpeedUp()
    local battleMgr = DataCenter.ZombieBattleManager
    if not canUse then
        if tipsId then
            -- 废弃BTest
            -- if LuaEntry.Player.abTest ~= ABTestType.A and tipsId == 800805 then
            --     self:AddSingleGasCharge()
            -- else
                UIUtil.ShowTipsId(tipsId)
            -- end
        end
        return
    end

    self.gasNum = self.gasNum - 1
    self.cdDuration = INTERVAL_CD
    self.cdTimer = INTERVAL_CD

    local heros = battleMgr.squad.members
    for _, hero in pairs(heros) do
        if hero then
            hero.buffManager:AddBuff(SPEED_UP_BUFF_ID)
        end
    end

    self.castDown:SetActive(false)
    self.castDown:SetActive(true)
    self.castUp:SetActive(false)
    self.castUp:SetActive(true)
end

function ZombieBattleSpeedUp:SetVisible(visible)
    if not IsNull(self.gameObject) then
        self.gameObject:SetActive(visible)
    end
end

function ZombieBattleSpeedUp:UpdateGasBtn()
    self.imgGasGrey:SetActive(self.gasNum <= 0)
    self.imgGasNormal:SetActive(self.gasNum > 0 and self.feverCount == 0)
    self.imgGasFever:SetActive(self.feverCount > 0)

    local cd_progress = self.cdDuration > 0 and (self.cdTimer / self.cdDuration) or 0

    self.imgBtnBorder:SetFillAmount(1 - cd_progress)
    self.imgBtnCD:SetFillAmount(cd_progress)

    self.imgBtnBorder:SetActive(self.gasNum > 0)
    self.txtGas:SetText(self.gasNum.."/"..self.maxGasNum)

    -- 废弃BTest
    -- if LuaEntry.Player.abTest ~= ABTestType.A and self.gasNum <= 0 then
    --     self.txtGas:SetText(self.clickChargeRate.."%")
    -- end

    if self.feverCount > 0 then
        -- self.tipRoot:SetActive(true)
        self.barRoot:SetActive(true)
        self.txtSpeedUp:SetText(self.displayFeverNum .. "%")

        local feverProgress = 1
        local feverTimer = 0
        if self.buff and self.buff.duration and self.buff.meta and self.buff.meta.buff_time then
            feverProgress = self.buff.duration / self.buff.meta.buff_time
            feverTimer = self.buff.duration
        end
        self.barInner:SetFillAmount(feverProgress)
        self.txtTimer:SetText(string.format("%.2fs", feverTimer))
        self.vfxBar:SetAnchoredPositionXY(Mathf.Lerp(38, -285, feverProgress), 0)

        self.feverDown:SetActive(true)
        self.feverUp:SetActive(true)
        self.readyDown:SetActive(false)
        self.readyUp:SetActive(false)

        self.vfxFireS:SetActive(self.feverCount <= 1)
        self.vfxFireL:SetActive(self.feverCount > 1)
        self.vfxFireB:SetActive(self.feverCount > 1)
    else
        -- self.tipRoot:SetActive(false)
        self.barRoot:SetActive(false)

        self.feverDown:SetActive(false)
        self.feverUp:SetActive(false)
        self.readyDown:SetActive(self:CanUseSpeedUp())
        self.readyUp:SetActive(self:CanUseSpeedUp())
    end
end

function ZombieBattleSpeedUp:OnBuffAdded(buff)
    if not buff or not buff.property or not buff.duration or not buff.meta or not buff.meta.buff_time then return end

    local battleMgr = DataCenter.ZombieBattleManager
    local heros = battleMgr.squad.members
    -- 加速只看第一个英雄的buff，忽略其他人
    if not heros or #heros <= 0 or heros[1].guid ~= buff.unit.guid then
        return
    end

    for k,v in pairs(buff.property) do
        if k == 80000 then
            self.feverCount = self.feverCount + 1
            if not self.buff or (buff.duration and self.buff.duration and buff.duration > self.buff.duration) then
                self.buff = buff
            end
            if self.feverCount == 1 then
                if self.anchorTween then
                    self.anchorTween:Kill()
                end
                self.tipRoot:SetAnchoredPositionXY(600, 445)
                self.anchorTween = self.tipRoot.transform:DOAnchorPosX(0, 0.5)
            end
            if self.scaleTween then
                self.scaleTween:Kill()
            end
            if self.numTween then
                self.numTween:Kill()
            end
            self.parSpeedUp.transform.localScale = Vector3.one
            self.displayFeverNum = (self.feverCount - 1) * 100
            self.scaleTween = self.parSpeedUp.transform:DOScale(Vector3.one * 1.5, 0.25):SetLoops(2, CS.DG.Tweening.LoopType.Yoyo)
            self.numTween = CS.DG.Tweening.DOTween.To(
                function() return self.displayFeverNum end,
                function(value) self.displayFeverNum = math.floor(value) end,
                self.feverCount * 100, 0.5)
            self.vfxTip:SetActive(false)
            self.vfxTip:SetActive(true)
            break
        end
    end
end

function ZombieBattleSpeedUp:OnBuffRemoved(buff)
    if not buff or not buff.property or not buff.duration or not buff.meta or not buff.meta.buff_time then return end
    local battleMgr = DataCenter.ZombieBattleManager
    if not battleMgr.squad then return end
    local heros = battleMgr.squad.members
    -- 加速只看第一个英雄的buff，忽略其他人
    if not heros or #heros <= 0 or heros[1].guid ~= buff.unit.guid then
        return
    end

    local isSpeedUp = false
    for k,v in pairs(buff.property) do
        if k == 80000 then
            isSpeedUp = true
            break
        end
    end
    if not isSpeedUp then return end

    self.feverCount = self.feverCount - 1

    if self.feverCount == 0 then
        if self.anchorTween then
            self.anchorTween:Kill()
        end
        self.tipRoot:SetAnchoredPositionXY(0, 445)
        self.anchorTween = self.tipRoot.transform:DOAnchorPosX(600, 0.5)
    end

    if self.scaleTween then
        self.scaleTween:Kill()
    end
    if self.numTween then
        self.numTween:Kill()
    end
    self.parSpeedUp.transform.localScale = Vector3.one
    self.displayFeverNum = (self.feverCount + 1) * 100
    self.scaleTween = self.parSpeedUp.transform:DOScale(Vector3.one * 0.8, 0.25):SetLoops(2, CS.DG.Tweening.LoopType.Yoyo)
    self.numTween = CS.DG.Tweening.DOTween.To(
            function() return self.displayFeverNum end,
            function(value) self.displayFeverNum = math.floor(value) end,
            self.feverCount * 100, 0.5)

    if self.buff == buff then
        self.buff = nil
    end
end

function ZombieBattleSpeedUp:OnScreenTouchClick(touchInfo)
    if LuaEntry.Player.abTest == ABTestType.A then return end
    if self.gasNum > 0 then return end
    local flyingRate = #self.clickChargeOrbs * CLICK_PERCENT
    local needRate = 100 - self.clickChargeRate - flyingRate
    if needRate < CLICK_PERCENT then return end
    local newOrb = CS.UnityEngine.GameObject.Instantiate(self.vfxOrb, self.vfxOrb.transform.parent)
    newOrb:SetActive(true)
    local scale = math.min((Screen.width / 810), (Screen.height / 1440))
    local localPoint = touchInfo.pointerPos / scale

    newOrb.transform.anchoredPosition = localPoint
    newOrb.transform:DOAnchorPos(ORB_TRAGET, 0.5):SetEase(CS.DG.Tweening.Ease.InQuad):OnComplete(function()
        self:AddSingleGasCharge()
        table.removebyvalue(self.clickChargeOrbs, newOrb)
        CS.UnityEngine.GameObject.Destroy(newOrb)
    end)
    table.insert(self.clickChargeOrbs, newOrb)
end

function ZombieBattleSpeedUp:AddSingleGasCharge()
    self.clickChargeRate = self.clickChargeRate + CLICK_PERCENT
    if self.clickChargeRate >= 100 then
        self.clickChargeRate = 0
        self.gasNum = self.gasNum + 1
    end
    self:UpdateGasBtn()
    self.vfxCharge:SetActive(false)
    self.vfxCharge:SetActive(true)
end

return ZombieBattleSpeedUp

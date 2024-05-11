--- Created by shimin.
--- DateTime: 2022/10/18 20:55
--- 建造属性详情

local UIShowDetail = BaseClass("UIShowDetail", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIDesCell = require "UI.UIBuildCreate.Component.UIDesCell"

local this_path = ""
local close_btn_path = "CloseBtn"

-- 创建
function UIShowDetail:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
function UIShowDetail:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

-- 显示
function UIShowDetail:OnEnable()
    base.OnEnable(self)
end

-- 隐藏
function UIShowDetail:OnDisable()
    base.OnDisable(self)
end


--控件的定义
function UIShowDetail:ComponentDefine()
    self.root_anim = self:AddComponent(UIAnimator, this_path)
    self.root_anim:SetActive(false)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        self:OnCloseBtnClick()
    end)
end

--控件的销毁
function UIShowDetail:ComponentDestroy()
    self.root_anim = nil
    self.close_btn = nil
end

--变量的定义
function UIShowDetail:DataDefine()
    self.param = {}
    self.isShow = false
    self.closeTimer = nil
    self.modelReq = {}
    self.loadCount = 0
end

--变量的销毁
function UIShowDetail: DataDestroy()
    self:RemoveCloseTimer()
    self.param = nil
    self.closeTimer = nil
    self.isShow = nil
    self.modelReq = nil
    self.loadCount = nil
end

function UIShowDetail:OnShow(param)
    self.param = param
    self.close_btn.transform.position = self.param.position
    self.close_btn.transform:Set_sizeDelta(self.param.sizeX,self.param.sizeY)
    if not self.isShow then
        self.isShow = true
        self.root_anim:SetActive(true)
        self.root_anim:Play("CommonPopup_movein",0,0)
        self:ShowCells()
    end
end

function UIShowDetail:OnCloseBtnClick()
    if self.isShow then
        self.isShow = false
        local ret,time = self.root_anim:PlayAnimationReturnTime("CommonPopup_moveout")
        if ret then
            if self.closeTimer == nil then
                self.closeTimer = TimerManager:GetInstance():GetTimer(time, function()
                    self:RemoveCloseTimer()
                    if not self.isShow then
                        self.root_anim:SetActive(false)
                    end
                end , self, true,false,false)
                self.closeTimer:Start()
            end
        end
    end
end

function UIShowDetail:RemoveCloseTimer()
    if self.closeTimer ~= nil then
        self.closeTimer:Stop()
        self.closeTimer = nil
    end
end

function UIShowDetail:ShowCells()
    self:InitList()
    self:DeleteReq()
    self.loadCount = table.count(self.list)
    for k,v in ipairs(self.list) do
        self.modelReq[k] = self:GameObjectInstantiateAsync(UIAssets.UIShowDetailCell, function(request)
            if request.isError then
                return
            end
            local go = request.gameObject
            go:SetActive(true)
            go.transform:SetParent(self.transform)
            go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            go.transform:SetAsLastSibling()
            local nameStr = tostring(NameCount)
            go.name = nameStr
            NameCount = NameCount + 1
            local model = self:AddComponent(UIDesCell, nameStr)
            model:ReInit(v)
            self.loadCount = self.loadCount - 1
            if self.loadCount <= 0 then
                CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
            end
        end)
    end
end

function UIShowDetail:DeleteReq()
    if self.modelReq ~= nil then
        for k,v in ipairs(self.modelReq) do
            v:Destroy()
        end
        self.modelReq = {}
    end
end

function UIShowDetail:InitList()
    self.list = {}
    local curNums = self.param.buildCurLevelTemplate.local_num
    if self.param.buildNextLevelTemplate ~= nil then
        local nextNums = self.param.buildNextLevelTemplate.local_num
        local maxCount = #nextNums
        local diaCount = table.count(self.param.buildTemplate.effect_local)
        if maxCount > diaCount then
            maxCount = diaCount
        end
        if maxCount > 0 then
            for i = 1,maxCount, 1 do
                local showParam = self.param.buildTemplate:GetShowLocalEffect(i)
                if showParam ~= nil then
                    local param = {}
                    param.name = Localization:GetString(showParam[1])
                    local needAdd = true
                    if showParam[2] == EffectLocalType.Dialog then
                        local val = DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(nextNums[i], showParam[2])
                        if val ==nil or val == "" then
                            needAdd = false
                        end
                        param.addValue = val
                    else
                        param.curValue = DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(tonumber(curNums[i]) or 0, showParam[2])
                        param.addValue = DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(tonumber(nextNums[i]) or 0, showParam[2])
                    end
                    if needAdd then
                        table.insert(self.list, param)
                    end
                end
            end
        end
        local showPower = LuaEntry.DataConfig:TryGetNum("show_power", "k1")
        if showPower <= DataCenter.BuildManager.MainLv then
            local param = {}
            param.name = Localization:GetString(GameDialogDefine.POWER)
            if self.param.buildNextLevelTemplate ~= nil then
                param.curValue = self.param.buildCurLevelTemplate.power
                param.addValue = self.param.buildNextLevelTemplate.power
            else
                param.addValue = self.param.buildCurLevelTemplate.power
            end
            table.insert(self.list, param)
        end
    end
end

return UIShowDetail
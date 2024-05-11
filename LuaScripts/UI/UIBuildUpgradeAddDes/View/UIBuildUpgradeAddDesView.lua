---
--- 升级后弹出属性界面
--- Created by shimin.
--- DateTime: 2021/6/18 16:34
---
local UIBuildUpgradeAddDesCell = require "UI.UIBuildUpgradeAddDes.Component.UIBuildUpgradeAddDesCell"
local UIBuildUpgradeAddDesView = BaseClass("UIBuildUpgradeAddDesView",UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local title_path ="Content/TitleText"
local content_path = "Content"

local AutoCloseTime = 2.0

--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.content = self:AddComponent(UIBaseContainer, content_path)
    self.title = self:AddComponent(UIText, title_path)
end

local function ComponentDestroy(self)
    self.content = nil
    self.title = nil
end


local function DataDefine(self)
    self.selectTimer = nil
    self.curBuildLevelTemplate = nil
    self.lastBuildLevelTemplate = nil
end

local function DataDestroy(self)
    if self.selectTimer ~= nil then
        self.selectTimer:Stop()
        self.selectTimer = nil
    end
    self.curBuildLevelTemplate = nil
    self.lastBuildLevelTemplate = nil
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ReInit(self)
    local tempId = tonumber(self:GetUserData())
    local buildId = DataCenter.BuildManager:GetBuildId(tempId)
    local level = DataCenter.BuildManager:GetBuildLevel(tempId)
    self.title:SetLocalText(GameDialogDefine.UPGRADE_LA) 
    self.curBuildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId,level)
    if level > 1 then
        self.lastBuildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId,level - 1)
    end
    self.buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
    self:ShowDesCells()
    self.selectTimer = TimerManager:GetInstance():GetTimer(AutoCloseTime, function()
        if self.selectTimer ~= nil then
            self.selectTimer:Stop()
            self.selectTimer = nil
        end
        self.ctrl:CloseSelf()
    end , self, true,false,false)
    self.selectTimer:Start()
end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function ShowDesCells(self)
    if self.buildTemplate ~= nil and self.curBuildLevelTemplate ~= nil then
        local curNums = self.curBuildLevelTemplate.local_num
        local lastNums = {}
        if self.lastBuildLevelTemplate == nil then
            for k,v in ipairs(curNums) do
                table.insert(lastNums,0)
            end
        else
            lastNums = self.lastBuildLevelTemplate.local_num
        end
      
        local maxCount = #curNums
        local diaCount = table.count(self.buildTemplate.effect_local)
        if maxCount > diaCount then
            maxCount = diaCount
        end
        for i = 1, maxCount, 1 do
            local showParam = self.buildTemplate:GetShowLocalEffect(i)
            if showParam ~= nil then
                if curNums[i] ~= lastNums[i] then
                    local param = UIBuildUpgradeAddDesCell.Param.New()
                    if showParam[2] == EffectLocalType.Dialog then
                        param.leftDes = DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(curNums[i], showParam[2])
                        param.rightDes = ""
                    else
                        local curNumber = tonumber(curNums[i])
                        local lastNumber = tonumber(lastNums[i])
                        if curNumber > lastNumber then
                            local x = math.modf(curNumber - lastNumber)
                            local tempValue = "+" .. DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(x, showParam[2])
                            param.rightDes = tempValue
                            param.leftDes = Localization:GetString(showParam[1]) .. ": " 
                                    .. DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(curNumber, showParam[2])
                        else
                            local x = math.modf(lastNumber - curNumber)
                            local tempValue = "-" .. DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(x, showParam[2])
                            param.rightDes = tempValue
                            param.leftDes = Localization:GetString(showParam[1]) .. ": "
                                    .. DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(curNumber, showParam[2])
                        end
                    end
                    self:AddOneDesCells(param)
                end
            end
        end
    end
end

local function AddOneDesCells(self,param)
    self:GameObjectInstantiateAsync(UIAssets.UIBuildUpgradeAddDesCell, function(request)
        if request.isError then
            return
        end
        local go = request.gameObject
        go:SetActive(true)
        go.transform:SetParent(self.content.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.transform:SetAsLastSibling()
        local nameStr = tostring(NameCount)
        NameCount = NameCount + 1
        go.name = nameStr
        local temp = self.content:AddComponent(UIBuildUpgradeAddDesCell, nameStr)
        temp:ReInit(param)
    end)
end

UIBuildUpgradeAddDesView.OnCreate= OnCreate
UIBuildUpgradeAddDesView.OnDestroy = OnDestroy
UIBuildUpgradeAddDesView.OnEnable = OnEnable
UIBuildUpgradeAddDesView.OnDisable = OnDisable
UIBuildUpgradeAddDesView.OnAddListener = OnAddListener
UIBuildUpgradeAddDesView.OnRemoveListener = OnRemoveListener
UIBuildUpgradeAddDesView.ComponentDefine = ComponentDefine
UIBuildUpgradeAddDesView.ComponentDestroy = ComponentDestroy
UIBuildUpgradeAddDesView.DataDefine = DataDefine
UIBuildUpgradeAddDesView.DataDestroy = DataDestroy
UIBuildUpgradeAddDesView.ReInit = ReInit
UIBuildUpgradeAddDesView.ShowDesCells = ShowDesCells
UIBuildUpgradeAddDesView.AddOneDesCells = AddOneDesCells

return UIBuildUpgradeAddDesView
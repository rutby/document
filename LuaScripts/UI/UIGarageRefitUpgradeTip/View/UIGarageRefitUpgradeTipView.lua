--- Created by shimin.
--- DateTime: 2024/1/22 21:11
--- 运兵车升级属性提示界面

local UIGarageRefitUpgradeTipView = BaseClass("UIGarageRefitUpgradeTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGarageRefitItem = require "UI.UIGarageRefit.Component.UIGarageRefitItem"
local UIGarageRefitUpgradeTipCell = require "UI.UIGarageRefitUpgradeTip.Component.UIGarageRefitUpgradeTipCell"

local return_btn_path = "panel"
local title_text_path = "Bg/title_text"
local des_text_path = "Bg/des_text"
local item_path = "Bg/UIGarageRefitItem"
local attr_go_path = "Bg/attr_go"

local CloseTime = 3

--创建
function UIGarageRefitUpgradeTipView:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
    self:ReInit()
end

-- 销毁
function UIGarageRefitUpgradeTipView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIGarageRefitUpgradeTipView:ComponentDefine()
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.return_btn:SetOnClick(function()
        self:OnCloseBtnClick()
    end)
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
    self.item = self:AddComponent(UIGarageRefitItem, item_path)
    self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
    self.attr_go = self:AddComponent(UIBaseContainer, attr_go_path)
end

function UIGarageRefitUpgradeTipView:ComponentDestroy()
end

function UIGarageRefitUpgradeTipView:DataDefine()
    self.param = {}
    self.list = {}
    self.needCells = {}
    self.close_timer_callback = function()
        self:OnCloseTimerCallBack()
    end
end

function UIGarageRefitUpgradeTipView:DataDestroy()
    self:DeleteCloseTimer()
end

function UIGarageRefitUpgradeTipView:OnEnable()
    base.OnEnable(self)
end

function UIGarageRefitUpgradeTipView:OnDisable()
    base.OnDisable(self)
end

function UIGarageRefitUpgradeTipView:OnAddListener()
    base.OnAddListener(self)
end


function UIGarageRefitUpgradeTipView:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIGarageRefitUpgradeTipView:ReInit()
    self.param = self:GetUserData()
    self.title_text:SetLocalText(GameDialogDefine.MORE_STRONG_ACCESSORY)
    self.des_text:SetLocalText(GameDialogDefine.CLICK_EVER_TO_CLOSE)
    self:Refresh()
end

function UIGarageRefitUpgradeTipView:Refresh()
    self:ShowCells()
    self:AddCloseTimer()
end

function UIGarageRefitUpgradeTipView:ShowCells()
    self:GetDataList()
    local count = #self.list
    for k,v in ipairs(self.list) do
        if self.needCells[k] == nil then
            self.needCells[k] = v 
            v.visible = true
            v.req = self:GameObjectInstantiateAsync(UIAssets.UIGarageRefitUpgradeTipCell, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject
                go:SetActive(true)
                go.transform:SetParent(self.attr_go.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                go.transform:SetAsLastSibling()
                local nameStr = tostring(NameCount)
                go.name = nameStr
                NameCount = NameCount + 1
                local model = self.attr_go:AddComponent(UIGarageRefitUpgradeTipCell, nameStr)
                model:ReInit(self.needCells[k])
                self.needCells[k].model = model
            end)
        else
            v.req = self.needCells[k].req
            v.model = self.needCells[k].model
            self.needCells[k] = v
            v.visible = true
            if v.model ~= nil then
                v.model:ReInit(v)
            end
        end
    end
    local cellCount = #self.needCells
    if cellCount > count then
        for i = count + 1, cellCount, 1 do
            local cell = self.needCells[i]
            if cell ~= nil then
                cell.visible = false
                if cell.model ~= nil then
                    cell.model:Refresh()
                end
            end
        end
    end
end

function UIGarageRefitUpgradeTipView:GetDataList()
    self.list = {}
    local curType = table.remove(self.param.typeList, 1)
    local rightLevel = 0
    if self.param.refitData.parts[curType] ~= nil then
        rightLevel = self.param.refitData.parts[curType].level
    end
    local leftLevel = rightLevel - 1

    local leftPartTemplate = DataCenter.GarageRefitManager:GetPartTemplate(curType, leftLevel)
    local rightPartTemplate = DataCenter.GarageRefitManager:GetPartTemplate(curType, rightLevel)
    self.item:SetTemplate(rightPartTemplate)

    local effects = rightPartTemplate:getValue("effect")
    local effectVas = rightPartTemplate:getValue("effect_num")
    local lEffectVas = {}
    if leftPartTemplate~=nil then
        lEffectVas = leftPartTemplate:getValue("effect_num")
    end
    local count = #effects
    for i = 1, count, 1 do
        local leftValue = lEffectVas[i] or 0
        if effectVas[i] ~= leftValue then
            local line = LocalController:instance():getLine(TableName.EffectNumDesc, tostring(effects[i]))
            if line ~= nil then
                local desc = Localization:GetString(line.des)
                local descType = tonumber(line.type)
                local leftVal = "+" .. string.GetFormattedSeperatorNum(leftValue)
                local rightVal = "+" .. string.GetFormattedSeperatorNum(effectVas[i])

                if descType == 1 then
                    leftVal = leftVal .. "%"
                    rightVal = rightVal .. "%"
                elseif descType == 2 then
                    leftVal = leftVal .. "‰"
                    rightVal = rightVal .. "‰"
                end

                local param = {}
                param.desc = desc
                param.leftDes = leftVal
                param.rightDes = rightVal
                table.insert(self.list, param)
            end
        end
    end
end

function UIGarageRefitUpgradeTipView:OnCloseBtnClick()
    if self.param.typeList[1] ~= nil then
        self:Refresh()
    else
        self.ctrl:CloseSelf()
    end
end

function UIGarageRefitUpgradeTipView:DeleteCloseTimer()
    if self.closeTimer ~= nil then
        self.closeTimer:Stop()
        self.closeTimer = nil
    end
end

function UIGarageRefitUpgradeTipView:AddCloseTimer()
    self:DeleteCloseTimer()
    self.closeTimer = TimerManager:GetInstance():GetTimer(CloseTime, self.close_timer_callback, self, true, false, false)
    self.closeTimer:Start()
end

function UIGarageRefitUpgradeTipView:OnCloseTimerCallBack()
    self:DeleteCloseTimer()
    self:OnCloseBtnClick()
end


return UIGarageRefitUpgradeTipView
---
--- 黑屏UI界面
--- Created by shimin.
--- DateTime: 2021/10/20 17:43
---
local UIShowBlackView = BaseClass("UIShowBlackView",UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIShowBlackCell = require "UI.UIShowBlack.Component.UIShowBlackCell"

local next_btn_path = "BlackImg"
local des_content_path = "DesContent"

local BtnCanClickTime = 1

--创建
function UIShowBlackView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
function UIShowBlackView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()      
    base.OnDestroy(self)
end

function UIShowBlackView:ComponentDefine()
    self.next_btn = self:AddComponent(UIButton, next_btn_path)
    self.des_content = self:AddComponent(UIBaseContainer, des_content_path)
    self.next_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnNextBtnClick()
    end)
end

function UIShowBlackView:ComponentDestroy()
end


function UIShowBlackView:DataDefine()
    self.timer = nil
    self.timer_action = function(temp)
        self:TimeCallBack()
    end
    self.template = nil
    self.useIndex = 1
    self.freeCells = {}
    self.cells = {}
    self.time = {}
    self.btnTimer = nil
    self.timer_btn_action = function(temp)
        self:TimeBtnCallBack()
    end
end

function UIShowBlackView:DataDestroy()
    self:DeleteTimer()
    self:DeleteBtnTimer()
    self.timer = nil
    self.timer_action = nil
    self.template = nil
    self.useIndex = nil
    self.freeCells = nil
    self.cells = nil
    self.time = nil
    self.btnTimer = nil
    self.timer_btn_action = nil
end

function UIShowBlackView:OnEnable()
    base.OnEnable(self)
end

function UIShowBlackView:OnDisable()
    base.OnDisable(self)
end

function UIShowBlackView:ReInit()
    self:Refresh()
end

function UIShowBlackView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.RefreshGuide, self.RefreshGuideSignal)
    self:AddUIListener(EventId.RefreshGuideAnim, self.RefreshGuideAnimSignal)
end

function UIShowBlackView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.RefreshGuide, self.RefreshGuideSignal)
    self:RemoveUIListener(EventId.RefreshGuideAnim, self.RefreshGuideAnimSignal)
end

function UIShowBlackView:DeleteTimer()
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

function UIShowBlackView:AddTimer(time)
    self:DeleteTimer()
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(time, self.timer_action , self, true,false,false)
    end
    self.timer:Start()
end

function UIShowBlackView:TimeCallBack()
    self:DeleteTimer()
    if self.cells[self.useIndex] ~= nil then
        self.cells[self.useIndex]:DoShowAnim()
    end
    self.useIndex = self.useIndex + 1
    local time = self.time[self.useIndex]
    if time == nil then
        if self.template.type == GuideType.ShowBlackUI then
            DataCenter.GuideManager:DoNext()
        end
    else
        self:AddTimer(time)
    end
end

function UIShowBlackView:Refresh()
    self.next_btn:SetInteractable(false)
    self:AddBtnTimer()
    self.template = DataCenter.GuideManager:GetCurTemplate()
    if self.template ~= nil and self.template.type == GuideType.ShowBlackUI then
        self:DeleteTimer()
        self:LoadCells()
    end
end

function UIShowBlackView:RefreshGuideSignal()
    self.template = DataCenter.GuideManager:GetCurTemplate()
    if self.template ~= nil and self.template.type == GuideType.ShowBlackUI then
        
    else
        self.ctrl:CloseSelf()
    end
end

function UIShowBlackView:RefreshGuideAnimSignal()
    self:Refresh()
end

function UIShowBlackView:OnNextBtnClick()
    self:TimeCallBack()
end

function UIShowBlackView:LoadCells()
    self.time = {}
    self.useIndex = 1
    for k,v in pairs(self.cells) do
        v:SetActive(false)
        table.insert(self.freeCells,v)
    end
    self.cells = {}
    if self.template.para1 ~= nil then
        local spl = string.split(self.template.para1,";")
        for k,v in ipairs(spl) do
            local spl1 = string.split(v,",")
            if #spl1 > 1 then
                local param = {}
                param.index = k
                param.des = Localization:GetString(spl1[1])
                table.insert(self.time,tonumber(spl1[2]) / 1000)
                self:LoadOneCell(param)
            end
        end
    end
    if self.template.para2 ~= nil then
        table.insert(self.time,tonumber(self.template.para2) / 1000)
    end
end

function UIShowBlackView:LoadOneCell(param)
    if #self.freeCells > 0 then
        local temp = table.remove(self.freeCells)
        if temp ~= nil then
            temp:SetActive(true)
            temp:ReInit(param)
            temp.transform:SetAsLastSibling()
            self.cells[param.index] = temp
            if param.index == 1 then
                self:StartShowTime()
            end
        end
    else
        self:GameObjectInstantiateAsync(UIAssets.UIShowBlackCell, function(request)
            if request.isError then
                return
            end
            local go = request.gameObject
            go:SetActive(true)
            go.transform:SetParent(self.des_content.transform)
            go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            go.transform:SetAsLastSibling()
            local nameStr = tostring(param.index)
            go.name = nameStr
            local temp = self.des_content:AddComponent(UIShowBlackCell, nameStr)
            temp:ReInit(param)
            self.cells[param.index] = temp
            if param.index == 1 then
                self:StartShowTime()
            end
        end)
    end
end

function UIShowBlackView:DeleteBtnTimer()
    if self.btnTimer ~= nil then
        self.btnTimer:Stop()
        self.btnTimer = nil
    end
end

function UIShowBlackView:AddBtnTimer()
    self:DeleteBtnTimer()
    if self.btnTimer == nil then
        self.btnTimer = TimerManager:GetInstance():GetTimer(BtnCanClickTime, self.timer_btn_action , self, true,false,false)
    end
    self.btnTimer:Start()
end

function UIShowBlackView:TimeBtnCallBack()
    self:DeleteBtnTimer()
    self.next_btn:SetInteractable(true)
end

function UIShowBlackView:StartShowTime()
    local time = self.time[self.useIndex]
    if time ~= nil then
        if time == 0 then
            self:TimeCallBack()
        else
            self:AddTimer(time)
        end
    end
end

return UIShowBlackView
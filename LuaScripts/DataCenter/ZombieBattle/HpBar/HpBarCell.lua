---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by w.
--- DateTime: 2022/12/19 13:47
---
local HpBarCell = BaseClass("HpBarCell");
local Resource = CS.GameEntry.Resource
local UnityRectTransform = typeof(CS.UnityEngine.RectTransform)
local Const = require("Scene.LWBattle.Const")
local UnityText = typeof(CS.UnityEngine.UI.Text)

local greenBarPath = "Assets/Main/Prefabs/LWBattle/HpBarGreen.prefab"
local redBarPath = "Assets/Main/Prefabs/LWBattle/HpBarRed.prefab"

local content = "Content"
local hp_fg = "Content/fg"
local hp_text = "Content/text"
local shield_fg_path = "Content/fg/shieldFg"
local shield_bg_path = "Content/shieldBg"

local _Root_Canvas = nil

function HpBarCell:__init(style,transform,height)
    self.target = transform
    self.camera = CS.UnityEngine.Camera.main
    self.style = style
    self.height = height
    if height < 0 then
        self.height = 1
    end
    self.myWorldPos = Vector3.zero
    
    self.offsetX = 0
end

function HpBarCell:__delete()
    self:Destroy()
end

function HpBarCell:Destroy()
    if(self.req) then
        self.req:Destroy()
        self.req = nil
    end
    self.target = nil
    self.gameObject = nil
    self.transform = nil

    if self.shieldFgGo then
        self.shieldFgGo:SetActive(false)
    end
    if self.shieldBgGo then
        self.shieldBgGo:SetActive(false)
    end
    self.shieldFgVisible = false
    self.shieldBgVisible = false
    
    self.shieldFgGo = nil
    self.shieldBgGo = nil
end

function HpBarCell.GetRootContainer()
    if IsNull(_Root_Canvas) then
        _Root_Canvas = CS.UnityEngine.GameObject("HpBarsContainer"):AddComponent(typeof(CS.UnityEngine.Canvas))
        _Root_Canvas.gameObject.layer = CS.UnityEngine.LayerMask.NameToLayer("UI")
        local CanvasNormal = UIManager:GetInstance():GetLayer(UILayer["Scene"]["Name"]).gameObject
        _Root_Canvas.transform:SetParent(CanvasNormal.transform)
        _Root_Canvas.transform:Set_localScale(1, 1, 1)
        _Root_Canvas.transform.anchorMin = Vector2.zero
        _Root_Canvas.transform.anchorMax = Vector2.one
        _Root_Canvas.transform.offsetMin = Vector2.zero
        _Root_Canvas.transform.offsetMax = Vector2.zero
    end
    return _Root_Canvas.transform
end

function HpBarCell:LoadAndSetHp(curHp, maxHp)
    self.req = Resource:InstantiateAsync(self:GetBarAsset())
    self.req:completed('+', function(req)
        local go = req.gameObject
        go.transform:SetParent(self.GetRootContainer())
        self.gameObject = go
        self.transform = go.transform
        self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        self.transform.position = Vector3.New(-9999,-9999,0)
        self:InitComponent()
        self:SetHp(curHp, maxHp)
    end)
end


function HpBarCell:Load()
    self.req = Resource:InstantiateAsync(self:GetBarAsset())
    self.req:completed('+', function(req)
        local go = req.gameObject
        local CanvasNormal = UIManager:GetInstance():GetLayer(UILayer["Scene"]["Name"]).gameObject
        go.transform:SetParent(CanvasNormal.transform)
        self.gameObject = go
        self.transform = go.transform
        self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        self:InitComponent()
    end)
end

function HpBarCell:SetOffsetX(offsetX)
    self.offsetX = offsetX

    if self.content then
        self.content:Set_localPosition(self.offsetX, 0, 0)
    end
end

function HpBarCell:InitComponent()
    self.content = self.transform:Find(content):GetComponent(UnityRectTransform)
    if self.content then
        self.content:Set_localPosition(self.offsetX, 0, 0)
    end
    self.fg = self.transform:Find(hp_fg):GetComponent(UnityRectTransform)
    local txtObj = self.transform:Find(hp_text)
    if txtObj then
        self.text = txtObj:GetComponent(UnityText)
    end
    self.shieldFg = self.transform:Find(shield_fg_path):GetComponent(UnityRectTransform)
    self.shieldBg = self.transform:Find(shield_bg_path):GetComponent(UnityRectTransform)
    self.shieldFgGo = self.shieldFg.gameObject
    self.shieldBgGo = self.shieldBg.gameObject
    self.shieldFgGo:SetActive(false)
    self.shieldBgGo:SetActive(false)
    self.shieldFgVisible = false
    self.shieldBgVisible = false
    self:SetHp(1, 1)
end

function HpBarCell:SetHp(curHp, maxHp, curShieldValue)
    local percent = curHp / maxHp
    if self.fg then
        self.fg:Set_sizeDelta(percent * self:GetMaxValue(), 14)
    end

    if curShieldValue and curShieldValue > 0 then
        --有护盾
        
        --血条后接护盾
        local hpRemain = maxHp - curHp
        hpRemain = math.min(hpRemain, curShieldValue)

        if hpRemain > 0 then
            if not self.shieldFgVisible then
                self.shieldFgVisible = true
                if self.shieldFgGo then
                    self.shieldFgGo:SetActive(true)
                end
            end

            if self.shieldFg then
                local hpRemainP = hpRemain / maxHp
                self.shieldFg:Set_sizeDelta(hpRemainP * self:GetMaxValue(), 14)
            end
        else
            if self.shieldFgVisible then
                self.shieldFgVisible = false
                if self.shieldFgGo then
                    self.shieldFgGo:SetActive(false)
                end
            end
        end
        
        local remain = curShieldValue - hpRemain
        if remain > 0 then
            if not self.shieldBgVisible then
                self.shieldBgVisible = true
                if self.shieldBgGo then
                    self.shieldBgGo:SetActive(true)
                end
            end

            if self.shieldBg then
                local remainP = remain / maxHp
                remainP = math.min(remainP, 1.0)
                self.shieldBg:Set_sizeDelta(remainP * self:GetMaxValue(), 14)
            end
        else
            if self.shieldBgVisible then
                self.shieldBgVisible = false
                if self.shieldBgGo then
                    self.shieldBgGo:SetActive(false)
                end
            end
        end

    else
        if self.shieldBgVisible then
            self.shieldBgVisible = false
            if self.shieldBgGo then
                self.shieldBgGo:SetActive(false)
            end
        end

        if self.shieldFgVisible then
            self.shieldFgVisible = false
            if self.shieldFgGo then
                self.shieldFgGo:SetActive(false)
            end
        end
    end
end

function HpBarCell:SetHpText(text)
    --if self.text then
    --    self.text = text
    --end
end

function HpBarCell:GetMaxValue()
    if self.style == Const.HPBarStyle.Self then
        return 100
    end
    if self.style == Const.HPBarStyle.Enemy then
        return 100
    end
end

function HpBarCell:GetBarAsset()
    if self.style == Const.HPBarStyle.Self then
        return greenBarPath
    end
    if self.style == Const.HPBarStyle.Enemy then
        return redBarPath
    end
end

function HpBarCell:Update()
    if self.transform then
        self:UpdatePos()
    end
end

function HpBarCell:UpdatePos()
    -- 获取对应位置在屏幕上的坐标位置
    self.myWorldPos.x, self.myWorldPos.y, self.myWorldPos.z = self.target:Get_position()
    self.myWorldPos.y = self.myWorldPos.y + self.height
    self.transform.position = CS.CSUtils.WorldPositionToUISpacePosition(self.myWorldPos)
end

function HpBarCell:SetActive(bool)
    if self.gameObject then
        self.gameObject:SetActive(bool)
    end
end

function HpBarCell:ReplaceTarget(transform)
    self.target = transform
end

return HpBarCell
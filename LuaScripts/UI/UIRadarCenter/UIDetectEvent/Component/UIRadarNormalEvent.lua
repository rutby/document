---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/9/27 16:11
---

local UIRadarNormalEvent = BaseClass("UIRadarNormalEvent", UIBaseContainer)
local base = UIBaseContainer

local info_btn_path = "NormalInfoBtn"
local title_text_path = "NormalEventTitle"
local num_text_path = "NormalEventNumText"

local function OnCreate(self)
    base.OnCreate(self)

    self:DataDefine()
    self:ComponentDefine()
end

local function ComponentDefine(self)
    self.infoBtn = self:AddComponent(UIButton, info_btn_path)
    self.infoBtn:SetOnClick(function ()
        self:OnInfoClick()
    end)
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
    self.title_text:SetLocalText(140085, "")
    self.num_text = self:AddComponent(UITextMeshProUGUIEx, num_text_path)
end

local function DataDefine(self)

end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()

    base.OnDestroy(self)
end

local function SetData(self, curNum, totalNum)
    self.curNum = curNum
    self.totalNum = totalNum
    self:RefreshView()
end

local function RefreshView(self)
    self.num_text:SetText(tostring(self.curNum).."/"..tostring(self.totalNum))
end

local function ComponentDestroy(self)

end

local function DataDestroy(self)

end

local function OnInfoClick(self)
    self.view:ShowNormalInfo()
end

UIRadarNormalEvent.OnCreate = OnCreate
UIRadarNormalEvent.OnDestroy = OnDestroy
UIRadarNormalEvent.ComponentDefine = ComponentDefine
UIRadarNormalEvent.ComponentDestroy = ComponentDestroy
UIRadarNormalEvent.DataDefine = DataDefine
UIRadarNormalEvent.DataDestroy = DataDestroy
UIRadarNormalEvent.OnInfoClick = OnInfoClick
UIRadarNormalEvent.SetData = SetData
UIRadarNormalEvent.RefreshView = RefreshView

return UIRadarNormalEvent
---
--- 
--- Created by 
--- DateTime: 
---
local UIEdenGroupCell = BaseClass("UIEdenGroupCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local AllianceFlagItem = require "UI.UIAlliance.UIAllianceFlag.Component.AllianceFlagItem"
function UIEdenGroupCell:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIEdenGroupCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIEdenGroupCell:OnEnable()
    base.OnEnable(self)
end

function UIEdenGroupCell:OnDisable()
    base.OnDisable(self)
end

function UIEdenGroupCell:ComponentDefine()
    self.alliance_flag = self:AddComponent(AllianceFlagItem, "allianceFlag/AllianceFlag")
    self._name_txt = self:AddComponent(UIText, "Txt_Name")
    self._member_txt = self:AddComponent(UIText, "Txt_Member")
    self._power_txt = self:AddComponent(UIText, "Txt_Power")
    self.first_flag = self:AddComponent(UIBaseContainer,"firstImg")
    self.second_flag = self:AddComponent(UIBaseContainer,"secondImg")
    self.third_flag = self:AddComponent(UIBaseContainer,"thirdImg")
    self.rankNum = self:AddComponent(UIText,"numTxt")
    
    self._btn = self:AddComponent(UIButton,"")
    self._btn:SetOnClick(function()
        self:OnClickAlliance()
    end)
end

function UIEdenGroupCell:ComponentDestroy()

end

function UIEdenGroupCell:DataDefine()
    
end

function UIEdenGroupCell:DataDestroy()
    
end

function UIEdenGroupCell:SetData(param,index)
    self.alliance_flag:SetData(param.icon)
    self.param = param
    if param.allianceId == "" then
        self._name_txt:SetLocalText(302611)
        self._member_txt:SetText("")
        self._power_txt:SetText("")
    else
        local name = Localization:GetString("311026",param.abbr,param.allianceName)
        if param.allianceId == LuaEntry.Player.allianceId then
            self._name_txt:SetText("<color=#27c68c>"..Localization:GetString(372761,param.serverId,name).."</color>")
        else
            self._name_txt:SetLocalText(372761,param.serverId,name)
        end
        self._member_txt:SetText(param.curMember)
        self._power_txt:SetText(string.GetFormattedSeperatorNum(param.power))
    end
    self.first_flag:SetActive(index == 1)
    self.second_flag:SetActive(index == 2)
    self.third_flag:SetActive(index == 3)
    self.rankNum:SetActive(index > 3)
    self.rankNum:SetText(index)
end

function UIEdenGroupCell:OnClickAlliance()
    if self.param.allianceId == LuaEntry.Player.allianceId then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceMainTable,{ anim = true})
    else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceDetail,{ anim = true, isBlur = true}, self.param.allianceName, self.param.allianceId)
    end
end

return UIEdenGroupCell
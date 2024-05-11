local Arena3V3ChooseSquadPopup = BaseClass("Arena3V3ChooseSquadPopup", UIBaseContainer)
local base = UIBaseContainer

local Localization = CS.GameEntry.Localization

local compBook = 
{
    { path="btnClose",                         name="btnClose",                 type=UIButton },
    -- { path="imgBg/top/txtH1",                  name="txtH1",                    type=UIText },
    { path="imgBg/top/btnInfo",                name="btnInfo",                  type=UIButton },

    { path="imgBg/item1",                      name="item1",                    type=UIButton },
    { path="imgBg/item1/uncheck1",             name="uncheck1",                 type=UIImage },
    { path="imgBg/item1/txtItem1",             name="txtItem1",                 type=UIText },
    { path="imgBg/item1/check1",               name="check1",                   type=UIBaseContainer },
    
    { path="imgBg/item2",                      name="item2",                    type=UIButton },
    { path="imgBg/item2/uncheck2",             name="uncheck2",                 type=UIImage },
    { path="imgBg/item2/txtItem2",             name="txtItem2",                 type=UIText },
    { path="imgBg/item2/check2",               name="check2",                   type=UIBaseContainer },
    
    { path="imgBg/item3",                      name="item3",                    type=UIButton },
    { path="imgBg/item3/uncheck3",             name="uncheck3",                 type=UIImage },
    { path="imgBg/item3/txtItem3",             name="txtItem3",                 type=UIText },
    { path="imgBg/item3/check3",               name="check3",                   type=UIBaseContainer },
    
    { path="imgBg/item4",                      name="item4",                    type=UIButton },
    { path="imgBg/item4/uncheck4",             name="uncheck4",                 type=UIImage },
    { path="imgBg/item4/txtItem4",             name="txtItem4",                 type=UIText },
    { path="imgBg/item4/check4",               name="check4",                   type=UIBaseContainer },

    { path="imgBg/item1/uncheck1/Using1",      name="Using1",                   type=UIBaseContainer },
    { path="imgBg/item1/uncheck1/Using1/UsingIcon1",      name="UsingIcon1",                   type=UIImage },
    { path="imgBg/item1/uncheck1/Using1/UsingText1",      name="UsingText1",                   type=UIText },
    { path="imgBg/item2/uncheck2/Using2",      name="Using2",                   type=UIBaseContainer },
    { path="imgBg/item2/uncheck2/Using2/UsingIcon2",      name="UsingIcon2",                   type=UIImage },
    { path="imgBg/item2/uncheck2/Using2/UsingText2",      name="UsingText2",                   type=UIText },
    { path="imgBg/item3/uncheck3/Using3",      name="Using3",                   type=UIBaseContainer },
    { path="imgBg/item3/uncheck3/Using3/UsingIcon3",      name="UsingIcon3",                   type=UIImage },
    { path="imgBg/item3/uncheck3/Using3/UsingText3",      name="UsingText3",                   type=UIText },
    { path="imgBg/item4/uncheck4/Using4",      name="Using4",                   type=UIBaseContainer },
    { path="imgBg/item4/uncheck4/Using4/UsingIcon4",      name="UsingIcon4",                   type=UIImage },
    { path="imgBg/item4/uncheck4/Using4/UsingText4",      name="UsingText4",                   type=UIText },

    { path="imgBg",                            name="imgBg",                    type=UIBaseContainer},
}

-- 创建
function Arena3V3ChooseSquadPopup:OnCreate(isDef)
    base.OnCreate(self)
    self:ComponentDefine()
    self.isDef = isDef
    if not isDef then
        self.isDef = true
    end
end

-- 销毁
function Arena3V3ChooseSquadPopup:OnDestroy()
    self:ComponentDestroy()
    base.OnDestroy(self)
end

function Arena3V3ChooseSquadPopup:GetTeamByIndex(index)
    if self.isDef then
        return DataCenter.LW3V3Manager:GetSelfDefTeamByIndex(index)
    else
        return DataCenter.LW3V3Manager:GetAtkTeamByIndex(index)
    end
end

function Arena3V3ChooseSquadPopup:GetSquadIndexUsingBuff(index)
    if self.isDef then
        return DataCenter.LW3V3Manager:GetDefTeamIndexUsingBuff(index)
    else
        return DataCenter.LW3V3Manager:GetTeamIndexUsingBuff(index)
    end
end

function Arena3V3ChooseSquadPopup:SetSquadUsingBuff(index,buffIndex)
    if self.isDef then
        return DataCenter.LW3V3Manager:SetDefTeamUsingBuff(index,buffIndex)
    else
        return DataCenter.LW3V3Manager:SetTeamUsingBuff(index,buffIndex)
    end
end

function Arena3V3ChooseSquadPopup:ComponentDefine()
    self:DefineCompsByBook(compBook)

    -- self.txtH1:SetText(Localization:GetString("801113"))
    for i = 1, 4 do
        self["txtItem"..i]:SetText(string.gsub(Localization:GetString("801114"), "{0}", i))
        self["item"..i]:SetOnClick(function ()

            local squadInfo = self:GetTeamByIndex(self.squadIndex)
            local buffIndex = squadInfo.localSquadNo
            if buffIndex == i then
                return
            end

            -- 空闲
            local usingSquadIndex = self:GetSquadIndexUsingBuff(i)
            if usingSquadIndex then
                UIUtil.ShowMessage(Localization:GetString(500262, buffIndex,usingSquadIndex), 1, "110006", nil, function()
                    self:SetSquadUsingBuff(self.squadIndex,i)
                    self:SetSquadUsingBuff(usingSquadIndex,buffIndex)
                    self:RefreshShow()
                end, nil, nil)
            else
                self:SetSquadUsingBuff(self.squadIndex,i)
                self:RefreshShow()
            end
        end)
    end

    self.btnClose:SetOnClick(function ()
        self:SetActive(false)
    end)
    self.btnInfo:SetOnClick(function ()
        UIUtil.ShowTipsId(801115)
    end)
end

function Arena3V3ChooseSquadPopup:ComponentDestroy()
    self:ClearCompsByBook(compBook)
end

function Arena3V3ChooseSquadPopup:RefreshShow()
    if not self.squadIndex then
        return
    end
    local squadInfo = self:GetTeamByIndex(self.squadIndex)
    local buffIndex = squadInfo.localSquadNo

    for i = 1, 4 do
        self["check"..i]:SetActive(buffIndex == i)
        self["uncheck"..i]:SetActive(buffIndex ~= i)
        if buffIndex ~= i then
            local usingSquadIndex = self:GetSquadIndexUsingBuff(i)
            if usingSquadIndex then
                self["Using"..i]:SetActive(true)
                self["UsingText"..i]:SetText(usingSquadIndex)
            else
                self["Using"..i]:SetActive(false)
            end
        end
    end

    self:SetActive(true)
end

function Arena3V3ChooseSquadPopup:SetPosition(x,y)
    if self.imgBg then
        self.imgBg:SetPositionXYZ(x,y,0)
    end
end

function Arena3V3ChooseSquadPopup:Popup(squadIndex)
    local b1 = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.LW_BUILD_PARKINGLOT)[1]
    local b2 = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.LW_BUILD_PARKINGLOT_TWO)[1]
    local b3 = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.LW_BUILD_PARKINGLOT_THREE)[1]
    local b4 = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.LW_BUILD_PARKINGLOT_FOUR)[1]

    self.item1:SetActive(b1 and b1.level > 0)
    self.item2:SetActive(b2 and b2.level > 0)
    self.item3:SetActive(b3 and b3.level > 0)
    self.item4:SetActive(b4 and b4.level > 0)

    self.squadIndex = squadIndex
    self:RefreshShow()
end

function Arena3V3ChooseSquadPopup:SetIsDef(isDef)
    self.isDef = isDef
end

return Arena3V3ChooseSquadPopup
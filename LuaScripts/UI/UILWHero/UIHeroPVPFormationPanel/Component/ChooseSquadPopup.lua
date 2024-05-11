local ChooseSquadPopup = BaseClass("ChooseSquadPopup", UIBaseContainer)
local base = UIBaseContainer

local Localization = CS.GameEntry.Localization

local compBook = 
{
    { path="btnClose",                         name="btnClose",                 type=UIButton },
    { path="imgBg/top/txtH1",                  name="txtH1",                    type=UIText },
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

    { path="imgBg",                            name="imgBg",                    type=UIBaseContainer},
}

-- 创建
function ChooseSquadPopup:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
end

-- 销毁
function ChooseSquadPopup:OnDestroy()
    self:ComponentDestroy()
    base.OnDestroy(self)
end

function ChooseSquadPopup:ComponentDefine()
    self:DefineCompsByBook(compBook)

    self.txtH1:SetText(Localization:GetString("801113"))
    for i = 1, 4 do
        self["txtItem"..i]:SetText(string.gsub(Localization:GetString("801114"), "{0}", i))
        self["item"..i]:SetOnClick(function ()
            for j = 1, 4 do
                self["check"..j]:SetActive(i == j)
                self["uncheck"..j]:SetActive(i ~= j)
            end
            if self.callback then
                self.callback(i)
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

function ChooseSquadPopup:ComponentDestroy()
    self:ClearCompsByBook(compBook)
end

function ChooseSquadPopup:SetPosition(x,y)
    if self.imgBg then
        self.imgBg:SetPositionXYZ(x,y,0)
    end
end

function ChooseSquadPopup:Popup(currIdx, callback)
    self.callback = callback
    local b1 = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.LW_BUILD_PARKINGLOT)[1]
    local b2 = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.LW_BUILD_PARKINGLOT_TWO)[1]
    local b3 = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.LW_BUILD_PARKINGLOT_THREE)[1]
    local b4 = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.LW_BUILD_PARKINGLOT_FOUR)[1]

    self.item1:SetActive(b1 and b1.level > 0)
    self.item2:SetActive(b2 and b2.level > 0)
    self.item3:SetActive(b3 and b3.level > 0)
    self.item4:SetActive(b4 and b4.level > 0)

    for i = 1, 4 do
        self["check"..i]:SetActive(currIdx == i)
        self["uncheck"..i]:SetActive(currIdx ~= i)
    end

    self:SetActive(true)
end

return ChooseSquadPopup
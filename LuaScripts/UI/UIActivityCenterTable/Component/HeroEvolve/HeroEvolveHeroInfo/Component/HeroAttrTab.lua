---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2023/3/25 14:46
---

local HeroAttrTab = BaseClass("HeroAttrTab", UIBaseContainer)
local base = UIBaseContainer
local title_text_path = "attrTitle"
local attack_text_path = "attackText"
local def_text_path = "defText"
local camp_text_path = "campText"
local triangle1_path = "heroAttr1/triangle1"
local line1_path = "heroAttr1/line1"

local triangle2_path = "heroAttr2/triangle2"
local line2_path = "heroAttr2/line2"
local hero_desc_path = "heroDesc"
local to_hero_desc_path = "toHeroDesc"
local TriangleImage = typeof(CS.TriangleImage)
local LineRender = typeof(CS.UILineRenderer)

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
end

local function ComponentDefine(self)
    self.title_text = self:AddComponent(UIText, title_text_path)
    self.title_text:SetLocalText(361095)

    self.attack_text = self:AddComponent(UIText, attack_text_path)
    self.def_text = self:AddComponent(UIText, def_text_path)
    self.camp_text = self:AddComponent(UIText, camp_text_path)
    self.triangle_image1 = self.transform:Find(triangle1_path):GetComponent(TriangleImage)
    self.triangle_line1 = self.transform:Find(line1_path):GetComponent(LineRender)

    self.triangle_image2 = self.transform:Find(triangle2_path):GetComponent(TriangleImage)
    self.triangle_line2 = self.transform:Find(line2_path):GetComponent(LineRender)

    self.attack_text:SetLocalText(150101)
    self.def_text:SetLocalText(150102)
    self.camp_text:SetLocalText(150132)

    self.hero_desc = self:AddComponent(UIText, hero_desc_path)
    self.to_hero_desc = self:AddComponent(UIText, to_hero_desc_path)
end

local function ComponentDestroy(self)

end

local function OnDestroy(self)
    self:ComponentDestroy()
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function SetData(self)
    self.data = HeroEvolveController:GetInstance():GetHeroAttrTabInfo()
    self:RefreshView()
end

local function RefreshView(self)
    self.hero_desc:SetText(self.data.heroDesc)
    self.to_hero_desc:SetText(self.data.toHeroDesc)
    self:DrawTriangles()
end

local function DrawTriangles(self)
    if self.triangle_image1 == nil then
        return
    end
    self.triangle_image1.p1 = self.data.attr1Pts[1]
    self.triangle_image1.p2 = self.data.attr1Pts[2]
    self.triangle_image1.p3 = self.data.attr1Pts[3]

    self.triangle_line1.Points[0] = self.data.attr1Pts[1]
    self.triangle_line1.Points[1] = self.data.attr1Pts[2]
    self.triangle_line1.Points[2] = self.data.attr1Pts[3]
    self.triangle_line1.Points[3] = self.data.attr1Pts[1]

    self.triangle_image2.p1 = self.data.attr2Pts[1]
    self.triangle_image2.p2 = self.data.attr2Pts[2]
    self.triangle_image2.p3 = self.data.attr2Pts[3]

    self.triangle_line2.Points[0] = self.data.attr2Pts[1]
    self.triangle_line2.Points[1] = self.data.attr2Pts[2]
    self.triangle_line2.Points[2] = self.data.attr2Pts[3]
    self.triangle_line2.Points[3] = self.data.attr2Pts[1]
end

HeroAttrTab.OnCreate = OnCreate
HeroAttrTab.OnDestroy = OnDestroy
HeroAttrTab.OnEnable = OnEnable
HeroAttrTab.OnDisable = OnDisable
HeroAttrTab.ComponentDefine =ComponentDefine
HeroAttrTab.ComponentDestroy =ComponentDestroy
HeroAttrTab.OnAddListener =OnAddListener
HeroAttrTab.OnRemoveListener =OnRemoveListener
HeroAttrTab.SetData = SetData
HeroAttrTab.RefreshView = RefreshView
HeroAttrTab.DrawTriangles = DrawTriangles

return HeroAttrTab
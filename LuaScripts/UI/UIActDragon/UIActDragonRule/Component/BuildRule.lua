---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl
--- DateTime: 
---
local BuildRule = BaseClass("BuildRule", UIBaseContainer)
local base = UIBaseContainer

function BuildRule:OnCreate() 
    base.OnCreate(self)
    self:ComponentDefine()
    self:ReInit()
end

function BuildRule:ComponentDefine()
    self.scroll_view = self:AddComponent(UIScrollPage, "ScrollView")
    self.content = self:AddComponent(UIBaseContainer, "ScrollView/View/Content")

    self._title1_txt = self:AddComponent(UIText,"ScrollView/View/Content/Cell1/Txt_Title1")
    self._title2_txt = self:AddComponent(UIText,"ScrollView/View/Content/Cell2/Txt_Title2")
    self._title3_txt = self:AddComponent(UIText,"ScrollView/View/Content/Cell3/Txt_Title3")
    self._title4_txt = self:AddComponent(UIText,"ScrollView/View/Content/Cell4/Txt_Title4")
    self._title5_txt = self:AddComponent(UIText,"ScrollView/View/Content/Cell5/Txt_Title5")
    
    self._desc1_txt  = self:AddComponent(UIText,"ScrollView/View/Content/Cell1/ScrollView/Viewport/Content/Txt_Desc1")
    self._desc2_txt = self:AddComponent(UIText,"ScrollView/View/Content/Cell2/ScrollView/Viewport/Content/Txt_Desc2")
    self._desc3_txt = self:AddComponent(UIText,"ScrollView/View/Content/Cell3/ScrollView/Viewport/Content/Txt_Desc3")
    self._desc4_txt = self:AddComponent(UIText,"ScrollView/View/Content/Cell4/ScrollView/Viewport/Content/Txt_Desc4")
    self._desc5_txt = self:AddComponent(UIText,"ScrollView/View/Content/Cell5/ScrollView/Viewport/Content/Txt_Desc5")

    self.pointArea = {}
    for i = 1, 5 do
        local progress_img =  "PointArea/progress_img"..i
        local select_img =  "PointArea/progress_img"..i.."/select_img"..i
        self.pointArea[i] = {
            progress = self:AddComponent(UIImage,progress_img),
            select = self:AddComponent(UIImage,select_img),
        }
    end

    self.pointArea[1].select:SetActive(true)
    self.pointArea[2].select:SetActive(false)
    self.pointArea[3].select:SetActive(false)
    self.pointArea[4].select:SetActive(false)
    self.pointArea[5].select:SetActive(false)
    self.lastIndex = 1
end

function BuildRule:OnEnable()
    base.OnEnable(self)
    --默认
    self.pointArea[1].select:SetActive(true)
    self.pointArea[2].select:SetActive(false)
    self.pointArea[3].select:SetActive(false)
    self.pointArea[4].select:SetActive(false)
    self.pointArea[5].select:SetActive(false)
    self.lastIndex = 1
end
function BuildRule:OnDestroy()
    base.OnDestroy(self)
end

function BuildRule:ReInit()
    local OnUpdateScroll = BindCallback(self, self.OnUpdateScroll)
    self.scroll_view:Refresh(OnUpdateScroll)
    self._title1_txt:SetLocalText(376012)
    self._title2_txt:SetLocalText(376000)
    self._title3_txt:SetLocalText(376003)
    self._title4_txt:SetLocalText(376002)
    self._title5_txt:SetLocalText(376153)
    self._desc1_txt:SetLocalText(376033)
    self._desc2_txt:SetLocalText(376034)
    self._desc3_txt:SetLocalText(376036)
    self._desc4_txt:SetLocalText(376035)
    self._desc5_txt:SetLocalText(376154)
end

function BuildRule:OnUpdateScroll(index)
    local tempIndex = index + 1
    tempIndex = math.max(1, tempIndex)
    tempIndex = math.min(tempIndex, 5)
    self.pointArea[self.lastIndex].select:SetActive(false)
    self.pointArea[tempIndex].select:SetActive(true)
    self.lastIndex = tempIndex
end

function BuildRule:SetData()
    self.content:SetAnchoredPosition(Vector2.New(0,0))
end


return BuildRule
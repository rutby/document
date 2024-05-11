---
--- 伊甸园分组
--- Created by .
--- DateTime: 
---

local UIGloryEdenGroupView = BaseClass("UIGloryEdenGroupView", UIBaseView)
local base = UIBaseView
local UIEdenGroupCell = require "UI.UIGlory.UIGloryEdenGroup.Component.UIEdenGroupCell"
function UIGloryEdenGroupView:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
    self:ReInit()
end

function UIGloryEdenGroupView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIGloryEdenGroupView:OnEnable()
    base.OnEnable(self)
end

function UIGloryEdenGroupView:OnDisable()
    base.OnDisable(self)
end

function UIGloryEdenGroupView:ComponentDefine()
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, "UICommonPopUpTitle/bg_mid/titleText")
    
    self.return_btn = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
    self.return_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGloryEdenGroup)
    end)
    self.close_btn = self:AddComponent(UIButton, "UICommonPopUpTitle/bg_mid/CloseBtn")
    self.close_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGloryEdenGroup)
    end)
    --
    self.toggle1 = self:AddComponent(UIToggle,"ImgBg/Tab/Toggle1")
    self._toggle1_txt = self:AddComponent(UIText,"ImgBg/Tab/Toggle1/unselectName1")
    self._toggle1_choose_rect = self:AddComponent(UIBaseContainer,"ImgBg/Tab/Toggle1/Choose1")
    self._toggle1_choose_txt = self:AddComponent(UIText,"ImgBg/Tab/Toggle1/Choose1/selectName1")
    self.toggle1:SetOnValueChanged(function(tf)
        if tf then
            self:OnClickBtn(1)
        end
    end)
    self.toggle2 = self:AddComponent(UIToggle,"ImgBg/Tab/Toggle2")
    self._toggle2_txt = self:AddComponent(UIText,"ImgBg/Tab/Toggle2/unselectName2")
    self._toggle2_choose_rect = self:AddComponent(UIBaseContainer,"ImgBg/Tab/Toggle2/Choose2")
    self._toggle2_choose_txt = self:AddComponent(UIText,"ImgBg/Tab/Toggle2/Choose2/selectName2")
    self.toggle2:SetOnValueChanged(function(tf)
        if tf then
            self:OnClickBtn(2)
        end
    end)
    
    self._allianceName_txt = self:AddComponent(UIText,"ImgBg/select/Txt_AllianceName")
    self._allianceMember_txt = self:AddComponent(UIText,"ImgBg/select/Txt_AllianceMember")
    self._alliancePower_txt = self:AddComponent(UIText,"ImgBg/select/Txt_AlliancePower")

    self.scroll_view = self:AddComponent(UIScrollView, "ImgBg/ScrollView")
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnItemMoveIn(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnItemMoveOut(itemObj, index)
    end)

    self._selfCamp1_rect = self:AddComponent(UIBaseContainer,"ImgBg/Tab/Toggle1/Rect_SelfCamp1")
    self._selfCamp2_rect = self:AddComponent(UIBaseContainer,"ImgBg/Tab/Toggle2/Rect_SelfCamp2")
end

function UIGloryEdenGroupView:ComponentDestroy()
    self:ClearScroll()
end

function UIGloryEdenGroupView:DataDefine()

end

function UIGloryEdenGroupView:DataDestroy()
 
end

function UIGloryEdenGroupView:ReInit()
    
    self:ReInitDialog()
    
    self.dataInfo = DataCenter.GloryManager:GetEdenGroupInfo()
    if self.dataInfo ~= nil then
        --默认显示
        self:OnClickBtn(1)
    else
        self.scroll_view:SetActive(false)
    end

    local selfCamp = DataCenter.RobotWarsManager:GetSelfCamp()
    if selfCamp and selfCamp ~= -1 then
        self._selfCamp1_rect:SetActive(selfCamp == 1)
        self._selfCamp2_rect:SetActive(selfCamp == 2)
    end
end

function UIGloryEdenGroupView:OnClickBtn(type)
    self.infoType = nil
    self._toggle1_choose_rect:SetActive(type == 1)
    self._toggle2_choose_rect:SetActive(type == 2)
    if type == 1 then
        self.toggle1:SetIsOn(true)
        self.toggle2:SetIsOn(false)
        if self.dataInfo[1] and table.count(self.dataInfo[1]) > 0 then    --北方
           self.infoType = self.dataInfo[1]
        end
    elseif type == 2 then
        self.toggle1:SetIsOn(false)
        self.toggle2:SetIsOn(true)
        if self.dataInfo[2] and table.count(self.dataInfo[2]) > 0 then    --南方
            self.infoType = self.dataInfo[2]
        end
    end
    self:RefreshCell()
end


function UIGloryEdenGroupView:ReInitDialog()
    self.title_text:SetLocalText(111062)
    self._toggle1_txt:SetLocalText(111064)
    self._toggle1_choose_txt:SetLocalText(111064)
    self._toggle2_txt:SetLocalText(111063)
    self._toggle2_choose_txt:SetLocalText(111063)
    self._allianceName_txt:SetLocalText(390288)
    self._allianceMember_txt:SetLocalText(390098)
    self._alliancePower_txt:SetLocalText(110528)
end

function UIGloryEdenGroupView:RefreshCell()
    if self.infoType then
        self.scroll_view:SetActive(true)
        self.scroll_view:SetTotalCount(#self.infoType)
        local jumpIndex = nil
        for i = 1, table.count(self.infoType) do
            if self.infoType[i].allianceId == LuaEntry.Player.allianceId then
                jumpIndex = i
                break
            end
        end
        if jumpIndex then
            if jumpIndex < 6 then
                jumpIndex = 1
            elseif table.count(self.infoType) - jumpIndex < 6 then
                jumpIndex = table.count(self.infoType) - jumpIndex
            end
        end
        self.scroll_view:RefillCells(jumpIndex)
    else
        self.scroll_view:SetActive(false)
    end
end

function UIGloryEdenGroupView:OnItemMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local cellItem = self.scroll_view:AddComponent(UIEdenGroupCell, itemObj)
    cellItem:SetData(self.infoType[index],index)
end

function UIGloryEdenGroupView:OnItemMoveOut( itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UIEdenGroupCell)
end


function UIGloryEdenGroupView:ClearScroll()
    self.scroll_view:ClearCells()
    self.scroll_view:RemoveComponents(UIEdenGroupCell)
end

return UIGloryEdenGroupView
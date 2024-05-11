local UIScratchSelectHeroItem_path = "Assets/Main/Prefab_Dir/UI/UIScratchSelectHero/UIScratchSelectHeroItem.prefab"
local UIScratchSelectHeroItem = require "UI.UIScratchSelectHero.Comp.UIScratchSelectHeroItem"
local UIScratchSelectHeroView = BaseClass("UIScratchSelectHeroView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
--创建
function UIScratchSelectHeroView:OnCreate()
    base.OnCreate(self)
    self.heroIds, self.activityId = self:GetUserData()
    self:ComponentDefine()
    self:ReInit()
end

-- 销毁
function UIScratchSelectHeroView:OnDestroy()
    self:ClearScroll()
    self:ComponentDestroy()
    base.OnDestroy(self)
end

function UIScratchSelectHeroView:ComponentDefine()
    self._return_panel = self:AddComponent(UIButton, "UICommonMidPopUpTitle/panel")
    self._return_panel:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.close_btn = self:AddComponent(UIButton, "UICommonMidPopUpTitle/bg_mid/CloseBtn")
    self.close_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.txt_title = self:AddComponent(UIText, "UICommonMidPopUpTitle/bg_mid/titleText")
    self.txt_title:SetLocalText(321120)

    self._content_rect = self:AddComponent(UIBaseContainer, "Rect_ScrollView/Viewport/Content")

    self._use_btn = self:AddComponent(UIButton,"Btn_Use")
    self._use_txt = self:AddComponent(UIText,"Btn_Use/Txt_Use")
    self._use_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:UseItem()
    end)

    self.cell_select = self:AddComponent(UIBaseContainer, "SelectGo")
    self.cell_select:SetActive(false)
end

function UIScratchSelectHeroView:ComponentDestroy()
    self._return_panel = nil
    self.close_btn     = nil
    self.txt_title     = nil
    self._content_rect = nil
    self._use_btn      = nil
    self._use_txt      = nil
    self.cell_select.transform:SetParent(self.transform)
    self.cell_select:SetActive(false)
    self.cell_select = nil
end

function UIScratchSelectHeroView:OnEnable()
    base.OnEnable(self)
end

function UIScratchSelectHeroView:OnDisable()
    base.OnDisable(self)
end


function UIScratchSelectHeroView:OnAddListener()
    base.OnAddListener(self)
end

function UIScratchSelectHeroView:OnRemoveListener()
    base.OnRemoveListener(self)
end


function UIScratchSelectHeroView:ReInit()
    UIGray.SetGray(self._use_btn.transform, true)
    self._use_txt:SetLocalText(110108)
    --self._use_txt:SetLocalText(110046)
    self:ClearScroll()
    self.modelHero = {}
    for i = 1, #self.heroIds do
        self.modelHero[self.heroIds[i]] = self:GameObjectInstantiateAsync(UIScratchSelectHeroItem_path, function(request)
            if request.isError then
                return
            end
            local go = request.gameObject;
            go.gameObject:SetActive(true)
            go.transform:SetParent(self._content_rect.transform)
            go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            go.name = self.heroIds[i]
            local cell = self._content_rect:AddComponent(UIScratchSelectHeroItem,go.name)
            local param = {}
            param.quality = GetTableData(HeroUtils.GetHeroXmlName(),self.heroIds[i], "init_quality_level")
            param.heroId = self.heroIds[i]
            local heroName = GetTableData(HeroUtils.GetHeroXmlName(), self.heroIds[i], "name")
            param.name = string.format("<color='%s'>%s</color>",HeroUtils.GetQualityColorStr(param.quality),Localization:GetString(heroName))
            param.callback = function(trans,heroId) self:HeroCallBack(trans,heroId) end
            param.count = self.count
            param.index = i
            cell:RefreshData(param)
        end)
    end

end

function UIScratchSelectHeroView:HeroCallBack(trans, selectIndex)
    self.cell_select.transform:SetParent(trans)
    self.cell_select.transform:Set_localPosition(0,21,0)
    self.cell_select.transform:Set_localScale(0.8, 0.8, 0.8)
    self.cell_select:SetActive(true)
    self.selectIndex = selectIndex
    UIGray.SetGray(self._use_btn.transform, false,true)
end

function UIScratchSelectHeroView:ClearScroll()
    self._content_rect:RemoveComponents(UIScratchSelectHeroItem)
    if self.modelHero~=nil then
        for k,v in pairs(self.modelHero) do
            if v ~= nil then
                self:GameObjectDestroy(v)
            end
        end
    end
end

function UIScratchSelectHeroView:UseItem()
    SFSNetwork.SendMessage(MsgDefines.GetScratchOffGameSwitchHero, self.activityId, self.selectIndex)
    self.ctrl:CloseSelf()
end

return UIScratchSelectHeroView
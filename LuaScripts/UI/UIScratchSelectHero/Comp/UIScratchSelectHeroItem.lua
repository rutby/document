
local UIScratchSelectHeroItem = BaseClass("UIScratchSelectHeroItem", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCell = require "UI.UIHero2.Common.UIHeroCellSmall"
-- 创建
function UIScratchSelectHeroItem:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
function UIScratchSelectHeroItem:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

-- 显示
function UIScratchSelectHeroItem:OnEnable()
    base.OnEnable(self)
end

-- 隐藏
function UIScratchSelectHeroItem:OnDisable()
    base.OnDisable(self)
end

--控件的定义
function UIScratchSelectHeroItem:ComponentDefine()
    self.hero = self:AddComponent(UIHeroCell,"UIHeroCellSmall")
    self.select_btn =self:AddComponent(UIButton,"UIHeroCellSmall")
    self.select_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnBtnClick()
    end)
    self._num_txt = self:AddComponent(UIText,"Txt_Num")
end

--控件的销毁
function UIScratchSelectHeroItem:ComponentDestroy()
    self.hero = nil
    self._num_txt = nil
end

--变量的定义
function UIScratchSelectHeroItem:DataDefine()
    self.param = {}
end

--变量的销毁
function UIScratchSelectHeroItem:DataDestroy()
    self.param = nil
end

-- 全部刷新
function UIScratchSelectHeroItem:RefreshData(param)
    self.param = param
    self.hero:InitWithConfigId(self.param.heroId,self.param.quality,"1")
    self._num_txt:SetText(self.param.name)
end

function UIScratchSelectHeroItem:OnBtnClick()
    if self.param.callback ~= nil then
        self.param.callback(self.transform,tonumber(self.param.index))
    end
end

return UIScratchSelectHeroItem
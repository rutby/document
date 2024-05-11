---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zhangliheng.
--- DateTime: 6/22/21 6:44 PM
---


local UIHeroInfoEquip = BaseClass("UIHeroInfoEquip", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

-- 创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    base.OnDestroy(self)
end

-- 显示
local function OnEnable(self)
    base.OnEnable(self)
end

-- 隐藏
local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

--控件的定义
local function ComponentDefine(self)
end

--控件的销毁
local function ComponentDestroy(self)
end

-- 全部刷新
local function InitData(self, heroUuid)
end


UIHeroInfoEquip.OnCreate = OnCreate
UIHeroInfoEquip.OnDestroy = OnDestroy
UIHeroInfoEquip.OnEnable = OnEnable
UIHeroInfoEquip.OnDisable = OnDisable
UIHeroInfoEquip.ComponentDefine = ComponentDefine
UIHeroInfoEquip.ComponentDestroy = ComponentDestroy
UIHeroInfoEquip.OnAddListener = OnAddListener
UIHeroInfoEquip.OnRemoveListener = OnRemoveListener

UIHeroInfoEquip.InitData = InitData
return UIHeroInfoEquip
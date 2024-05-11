--- 引导出现鸵鸟全屏暗角
--- Created by shimin.
--- DateTime: 2022/1/14 00:01
---
local UIGuideUnlockMaskView = BaseClass("UIGuideUnlockMaskView",UIBaseView)
local base = UIBaseView

--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
 
end

local function ComponentDestroy(self)
  
end


local function DataDefine(self)
  
end

local function DataDestroy(self)

end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ReInit(self)
   
end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

UIGuideUnlockMaskView.OnCreate= OnCreate
UIGuideUnlockMaskView.OnDestroy = OnDestroy
UIGuideUnlockMaskView.OnEnable = OnEnable
UIGuideUnlockMaskView.OnDisable = OnDisable
UIGuideUnlockMaskView.OnAddListener = OnAddListener
UIGuideUnlockMaskView.OnRemoveListener = OnRemoveListener
UIGuideUnlockMaskView.ComponentDefine = ComponentDefine
UIGuideUnlockMaskView.ComponentDestroy = ComponentDestroy
UIGuideUnlockMaskView.DataDefine = DataDefine
UIGuideUnlockMaskView.DataDestroy = DataDestroy
UIGuideUnlockMaskView.ReInit = ReInit

return UIGuideUnlockMaskView
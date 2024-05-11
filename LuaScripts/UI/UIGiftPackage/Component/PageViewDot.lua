--[[
    礼包
--]]

local PageViewDot = BaseClass("PageViewDot", UIBaseContainer)
local base = UIBaseContainer


local function OnCreate(self, ...)
	-- body
	base.OnCreate(self)
    self:OnSpawn(...)
end

-- 组件被复用时回调该函数，执行组件的刷新
local function OnSpawn(self, ...)
        
end

local function MyCallback(self, image)

end

-- 组件添加了按钮组，则按钮被点击时回调该函数
local function OnClick(self, toggle_btn, real_index, check)
	
end



-- 销毁
local function OnDestroy(self)
	self.num_text = nil
    self.image_icon = nil

	base.OnDestroy(self)
end


PageViewDot.OnCreate = OnCreate
PageViewDot.OnDestroy = OnDestroy
PageViewDot.OnSpawn = OnSpawn
PageViewDot.OnClick = OnClick
PageViewDot.MyCallback = MyCallback

return PageViewDot
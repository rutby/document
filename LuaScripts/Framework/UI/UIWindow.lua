--[[
-- added by wsh @ 2017-11-30
-- UIWindow数据，用以表示一个窗口
-- 注意：
-- 1、窗口名字必须和预设名字一致
--]]

local UIWindow = {
	-- 窗口名字
	Name = "Background",
	-- Layer层级
	Layer = UILayer.Normal,
	-- Ctrl实例
	Ctrl = UIBaseCtrl,
	-- View实例
	View = UIBaseView,
	-- 预设路径
	PrefabPath = "",
	-- 界面状态
	State = 0,
	-- 打开参数
	OpenOptions = {},

	CloseTimer = nil,
	InstanceRequest = nil,
}
	
return DataClass("UIWindow", UIWindow)
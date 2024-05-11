local UIWorldTileTopBtn = BaseClass("UIWorldTileTopBtn", UIBaseContainer)
local base = UIBaseContainer

local Param = DataClass("Param", ParamData)
local ParamData =  {
	topBtnType,
	index,
	name,
	buildId,
}

local this_path = ""

-- 创建
local function OnCreate(self)
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
end

-- 销毁
local function OnDestroy(self)
	self:ComponentDestroy()
	self:DataDestroy()
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


--控件的定义
local function ComponentDefine(self)
	self.btn = self:AddComponent(UIButton, this_path)
	self.btnImage = self:AddComponent(UIImage, this_path)
	self.btn:SetOnClick(function()
		self:OnBtnClick()
	end)
end

--控件的销毁
local function ComponentDestroy(self)
	self.btn = nil
	self.btnImage = nil
end

--变量的定义
local function DataDefine(self)
	self.param = nil
end

--变量的销毁
local function DataDestroy(self)
	self.param = nil
end

-- 全部刷新
local function ReInit(self,param)
	self.param = param
	local iconPath = UIWorldTileTopBtnImage[param.topBtnType]
	if param.topBtnType == UIWorldTileTopBtnType.Book and DataCenter.AllianceBaseDataManager:IsR4orR5() then
		iconPath = "Assets/Main/Sprites/UI/UISearch/UISearch_btn_leaderMark"
	end
	self.btnImage:LoadSprite(iconPath)
end

local function OnBtnClick(self)
	--local oname = DataCenter.BookMarkManager:GetBookMarkNameId(self.param.index)
	local oname = self.param.name
	local serverId = self.param.server
	if self.param.topBtnType == UIWorldTileTopBtnType.Share then
		--CS.UIPreAdd.OpenSharePosition(self.param.index)
		local share_param = {}
		share_param.sid = serverId
		share_param.worldId = LuaEntry.Player:GetCurWorldId()
		share_param.pos = self.param.index
		share_param.oname = oname
		--share_param.uname = uname
		--share_param.abbr = abbr
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, share_param)
	elseif self.param.topBtnType == UIWorldTileTopBtnType.Book then
		local share_param = {}
		share_param.sid = serverId
		share_param.worldId = LuaEntry.Player:GetCurWorldId()
		local tile = BuildTilesSize.One
		local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.param.buildId)
		if buildTemplate ~= nil then
			tile = buildTemplate.tiles
		end
		local worldPos = SceneUtils.TileIndexToWorld(self.param.index)--nil
		--if tile == BuildTilesSize.One then
		--	worldPos = SceneUtils.TileIndexToWorld(self.param.index)
		--elseif tile == BuildTilesSize.Two then
		--	worldPos = SceneUtils.TileIndexToWorld(self.param.index)
		--elseif tile == BuildTilesSize.Three then
		--	worldPos = SceneUtils.TileIndexToWorld(self.param.index)
		--else
		--	worldPos = SceneUtils.TileIndexToWorld(self.param.index)
		--end
		--local realPoint = SceneUtils.WorldToTileIndex(worldPos)
		--share_param.pos = realPoint
		share_param.pos = self.param.index * 10 + buildTemplate.tiles
		--share_param.pos = self.param.index
		--share_param.tile = buildTemplate.tiles
		share_param.oname = oname
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionAdd, { anim = true }, share_param)
	end
	self.view.ctrl:CloseSelf()
end

UIWorldTileTopBtn.OnCreate = OnCreate
UIWorldTileTopBtn.OnDestroy = OnDestroy
UIWorldTileTopBtn.Param = Param
UIWorldTileTopBtn.OnEnable = OnEnable
UIWorldTileTopBtn.OnDisable = OnDisable
UIWorldTileTopBtn.ComponentDefine = ComponentDefine
UIWorldTileTopBtn.ComponentDestroy = ComponentDestroy
UIWorldTileTopBtn.DataDefine = DataDefine
UIWorldTileTopBtn.DataDestroy = DataDestroy
UIWorldTileTopBtn.ReInit = ReInit
UIWorldTileTopBtn.OnBtnClick = OnBtnClick

return UIWorldTileTopBtn
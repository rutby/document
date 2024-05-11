local UIAllianceHeroCell = BaseClass("UIAllianceHeroCell", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCellSmall = require "UI.UIHero2.Common.UIHeroCellSmall"

local hero_cell_path = "UIHeroCellSmall"

-- 创建
function UIAllianceHeroCell:OnCreate()
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
end

-- 销毁
function UIAllianceHeroCell:OnDestroy()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

-- 显示
function UIAllianceHeroCell:OnEnable()
	base.OnEnable(self)
end

-- 隐藏
function UIAllianceHeroCell:OnDisable()
	base.OnDisable(self)
end


--控件的定义
function UIAllianceHeroCell:ComponentDefine()
	self.hero_cell= self:AddComponent(UIHeroCellSmall, hero_cell_path)
end

--控件的销毁
function UIAllianceHeroCell:ComponentDestroy()

end

--变量的定义
function UIAllianceHeroCell:DataDefine()
	self.param = {}
end

--变量的销毁
function UIAllianceHeroCell:DataDestroy()
	self.param = {}
end

-- 全部刷新
function UIAllianceHeroCell:ReInit(param)
	self.param = param
	if self.param ~= nil then
		local curMilitaryRankId = HeroUtils.GetRankIdByLvAndStage(self.param.heroId, self.param.rankLv, self.param.stage)
		if self.param.camp == nil then
			self.hero_cell:InitWithConfigId(self.param.heroId,self.param.quality,self.param.lv,nil,self.param.skillInfos, curMilitaryRankId, nil, nil, HeroUtils.GetCamp(self.param))
		else
			self.hero_cell:InitWithConfigId(self.param.heroId,self.param.quality,self.param.lv,nil,self.param.skillInfos, curMilitaryRankId, nil, nil, self.param.camp)
		end
	end
end

function UIAllianceHeroCell:SetLevelBgActive(active)
	self.hero_cell:SetLevelBgActive(active)
end

return UIAllianceHeroCell
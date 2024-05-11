---------------------------------------------------------------------
-- 这里主要是处理阵型消息
-- 里面保存了英雄及敌人的位置

---@class PveLineup
local PveLineup = BaseClass("PveLineup")
local Const = require "Scene.BattlePveModule.Const"
local ResourceManager = CS.GameEntry.Resource

-- 目前只有一个阵型排布，以后可能有多个
local _prefabPath = "Assets/Main/Prefabs/PVE/PVELineup.prefab"
local _enemynames = {"pve_js/enemy01", "pve_js/enemy02", "pve_js/enemy03", "pve_js/enemy04", "pve_js/enemy05"}
local _mynames = {"pve_js/our01", "pve_js/our02", "pve_js/our03", "pve_js/our04", "pve_js/our05"}
local _reverseenemynames = {"pve_js/enemy05", "pve_js/enemy04", "pve_js/enemy03", "pve_js/enemy02", "pve_js/enemy01"}
local _reversemynames = {"pve_js/our05", "pve_js/our04", "pve_js/our03", "pve_js/our02", "pve_js/our01"}
local Zero = Vector3.zero


function PveLineup:__init()
	self.enemyPos = {}
	self.enemyPosObj = {}
	self.myPos = {}
	self.myPosObj = {}
	
	self.heroSignIcon = {}
	self.enemySignIcon = {}

	self.m_goMaterBlock = CS.UnityEngine.MaterialPropertyBlock()
	self.heroSignPropertyId = CS.UnityEngine.Shader.PropertyToID("_Color")
	self.timelineReq = nil
end

function PveLineup:__delete()
	self:RemoveTimeLine()
	self.enemyPos = nil
	self.enemyPosObj = nil
	self.myPos = nil
	self.myPosObj = nil
	self.heroSignIcon = nil
end

function PveLineup:__initPostions(isReverse)
	
	--clearTable(self.enemyPos)
	--clearTable(self.myPos)
	local enemy = _enemynames
	local my = _mynames
	if isReverse~=nil and isReverse == true then
		enemy = _reverseenemynames
		my = _reversemynames
	end
	self.enemyPos = {}
	self.myPos = {}
	
	self.heroSignIcon = {}
	
	for k,v in ipairs(enemy) do
		local t = self.m_gameObject.transform:Find(v)
		local pos = Vector3.New(t.transform:Get_position())
		self.enemyPos[k] = pos
		self.enemyPosObj[k] = t
		
		self.enemySignIcon[k] = {
			iconQuality = t:Find("VFX_Quality").gameObject,
			iconQualitySprite = t:Find("VFX_Quality/Sprite"):GetComponent(typeof(CS.UnityEngine.Renderer)),
			--render1 = t:Find("VFX_Quality"):GetComponent(typeof(CS.UnityEngine.Renderer)),
			--render2 = t:Find("VFX_Quality/V_plane"):GetComponent(typeof(CS.UnityEngine.Renderer))
		}
		self.enemySignIcon[k].iconQuality:SetActive(false)
	end

	local myPosCount = #my
	local entranceType = DataCenter.BattleLevel:GetEntranceType()
	if entranceType == PveEntrance.MineCave then
		local mineIndex, formationUuid = DataCenter.MineCaveManager:GetBattleParam()
		local formationInfo = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(formationUuid)
		myPosCount = MarchUtil.GetMaxHeroValueByFormationIndex(formationInfo.index)
	elseif entranceType == PveEntrance.ArenaSetting or entranceType == PveEntrance.ArenaBattle then
		myPosCount = MarchUtil.GetMaxHeroValueByFormationIndex(1)
	end
	
	for k,v in ipairs(my) do
		local t = self.m_gameObject.transform:Find(v)
		if k <= myPosCount then
			t.gameObject:SetActive(true)
		else
			t.gameObject:SetActive(false)
		end
		local pos = Vector3.New(t.transform:Get_position())
		self.myPos[k] = pos
		self.myPosObj[k] = t

		self.heroSignIcon[k] = {
			iconAdd = t:Find("VFX_Add").gameObject,
			iconQuality = t:Find("VFX_Quality").gameObject,
			iconQualitySprite = t:Find("VFX_Quality/Sprite"):GetComponent(typeof(CS.UnityEngine.Renderer)),
			--render1 = t:Find("VFX_Quality"):GetComponent(typeof(CS.UnityEngine.Renderer)),
			--render2 = t:Find("VFX_Quality/V_plane"):GetComponent(typeof(CS.UnityEngine.Renderer)),
			iconLock = t:Find("VFX_Lock").gameObject,
			isLock =true
		}
		self.heroSignIcon[k].iconQuality:SetActive(false)

		local heroMaxCount = DataCenter.BattleLevel:GetMaxHeroCount()
		if k <= heroMaxCount then
			self.heroSignIcon[k].isLock = false
			self.heroSignIcon[k].iconAdd:SetActive(true)
		end

		if self.heroSignIcon[k].isLock then
			self.heroSignIcon[k].iconAdd:SetActive(false)
			self.heroSignIcon[k].iconLock:SetActive(true)
		else
			self.heroSignIcon[k].iconAdd:SetActive(true)
			self.heroSignIcon[k].iconLock:SetActive(false)
		end
	end

	EventManager:GetInstance():Broadcast(EventId.PVE_Lineup_Init_End)
end

function PveLineup:HideAllStandEffect()
	for _, v in pairs(self.enemySignIcon) do
		v.iconQuality:SetActive(false)
	end
	for _, v in pairs(self.heroSignIcon) do
		v.iconQuality:SetActive(false)
		v.iconLock:SetActive(false)
	end
end

function PveLineup:HideAllStandAddAndLock()
	for _, v in pairs(self.heroSignIcon) do
		v.iconAdd:SetActive(false)
		v.iconLock:SetActive(false)
	end
end

-- 在指定位置初始化阵型;位置及阵型id
function PveLineup:Init(pos, lineup_type,rotation)
	self.m_req = ResourceManager:InstantiateAsync(_prefabPath)
	self.m_req:completed('+', function(req)
		local _go = req.gameObject
		if (_go == nil) then
			return
		end
		self.m_gameObject = _go
		self.m_gameObject.transform:SetParent(DataCenter.BattleLevel:GetSceneRoot())
		self.m_gameObject.transform.position = pos
		self.m_gameObject.transform.localRotation = Quaternion.Euler(0, rotation, 0)
		if rotation>180 then
			self:__initPostions(true)
		else
			self:__initPostions(false)
		end

		local entranceType = DataCenter.BattleLevel:GetEntranceType()
		if entranceType ~= PveEntrance.MineCave and entranceType ~= PveEntrance.ArenaSetting then
			EventManager:GetInstance():Broadcast(EventId.PVE_Lineup_LoadOK)
		elseif entranceType == PveEntrance.MineCave and DataCenter.MineCaveManager:CheckIfNeedPreloadEnemy() then
			EventManager:GetInstance():Broadcast(EventId.PVE_Lineup_LoadOK)
		end
	end)
end

function PveLineup:Destroy()
	self:RemoveTimeLine()
	if self.m_req ~= nil then
		self.m_req:Destroy()
		self.m_req = nil
	end
end

function PveLineup:IsLoadOK()
	return self.m_req ~= nil and self.m_req.isDone
end
function PveLineup:SetActive(value)
	if self.m_gameObject ~= nil then
		self.m_gameObject:SetActive(value)
	end
end
function PveLineup:GetMyPosPosition(index)
	if index >= 1 and index <= #self.myPos then
		return self.myPos[index]
	end
	
	return Zero
end

function PveLineup:GetEnemyPosPosition(index)
	if index >= 1 and index <= #self.enemyPos then
		return self.enemyPos[index]
	end
	
	return Zero
end

function PveLineup:GetStandObj( campType, index )	
	local posObj = nil
	if (campType == Const.CampType.Player) then
		posObj = self.myPosObj
	else
		posObj = self.enemyPosObj
	end
	if (index < 1 or index > table.count(posObj)) then
		return nil
	end
	return posObj[index]
end

local function GetIntensity(intensity)
	return Mathf.Pow(2,intensity)
end

local SignColors =
{
	[0] = {['Center'] = Vector4.New(0,  0,   0,    0) * GetIntensity(1),   		 ['Border'] = Vector4.New(127/255,  127/255,  127/255,1)  * GetIntensity(1)},
	--橙
	[1] = {['Center'] = Vector4.New(191/255,  26/255,   0,    1) * GetIntensity(1.38),   		 ['Border'] = Vector4.New(191/255,  100/255,  81/255,1)  * GetIntensity(1)},
	--{['Center'] = Vector4.New(191/255,  26/255,   0,    1) * GetIntensity(1.38),    		 ['Border'] = Vector4.New(191/255,  100/255,  81/255,1)  * GetIntensity(1)},
	--紫      
	[2] = {['Center'] = Vector4.New(191/255,  27/255, 170/255,1) * GetIntensity(1.8),            ['Border'] = Vector4.New(191/255,   81/255, 175/255,1)  * GetIntensity(1)},
	--{['Center'] = Vector4.New(191/255,  27/255, 170/255,1) * GetIntensity(1.8),            ['Border'] = Vector4.New(191/255,   81/255, 175/255,1)  * GetIntensity(1)},
	--蓝
	[3] = {['Center'] = Vector4.New(28/255,   78/255, 191/255,1) * GetIntensity(0.882),          ['Border'] = Vector4.New(70/255 ,  101/255, 191/255,1)  * GetIntensity(1.416)},
	
	[4] = {['Center'] = Vector4.New(97/255,   191/255, 51/255,1) * GetIntensity(0.5983),          ['Border'] = Vector4.New(97/255,   191/255, 51/255,1)  * GetIntensity(1.416)},
	--{['Center'] = Vector4.New(28/255,   78/255, 191/255,1) * GetIntensity(0.882),          ['Border'] = Vector4.New(70/255,   101/255, 191/255,1)  * GetIntensity(1.416)},
	
	--
	----红
	--{['Center'] = Vector4.New(191/255,  8/255,    0,    1) * GetIntensity(1.38),  	     ['Border'] = Vector4.New(191/255,   89/255,  81/255,1)  * GetIntensity(1)},
	--{['Center'] = Vector4.New(191/255,  8/255,    0,    1) * GetIntensity(1.38),   		 ['Border'] = Vector4.New(191/255,   89/255,  81/255,1)  * GetIntensity(1)},
	----金
	--{['Center'] = Vector4.New(191/255,  55/255,   0,    1) * GetIntensity(1.35),   		 ['Border'] = Vector4.New(191/255,   55/255,   0,    1)  * GetIntensity(1.35)},
	--{['Center'] = Vector4.New(191/255,  55/255,   0,    1) * GetIntensity(1.35),   		 ['Border'] = Vector4.New(191/255,   55/255,   0,    1)  * GetIntensity(1.35)},
	--彩
	[5] = {['Center'] = Vector4.New(191/255,  55/255,   0,    1) * GetIntensity(1.35),   		 ['Border'] = Vector4.New(191/255,   55/255,   0,    1)  * GetIntensity(1.35)},
	--{['Center'] = Vector4.New(191/255,  55/255,   0,    1) * GetIntensity(1.35),    		 ['Border'] = Vector4.New(191/255,   55/255,   0,    1)  * GetIntensity(1.35)},
}
PveLineup.SignColors = SignColors

function PveLineup:SetHeroSignIcon(index, rarity)
	if rarity ~= nil then
		--local vector1 = SignColors[rarity]['Center']
		--vector1.w = 1
		--local vector2 = SignColors[rarity]['Border']
		--vector2.w = 1
		self.heroSignIcon[index].iconAdd:SetActive(false)
		self.heroSignIcon[index].iconLock:SetActive(false)
		self.heroSignIcon[index].iconQuality:SetActive(true)
		self.heroSignIcon[index].iconQualitySprite:LoadSprite(string.format(LoadPath.UIPve, "pve_img_rarity_" .. rarity))
		--self.m_goMaterBlock:SetVector(self.heroSignPropertyId, vector1)
		--self.heroSignIcon[index].render1:SetPropertyBlock(self.m_goMaterBlock)
		--self.m_goMaterBlock:SetVector(self.heroSignPropertyId, vector2)
		--self.heroSignIcon[index].render2:SetPropertyBlock(self.m_goMaterBlock)
	else
		self.heroSignIcon[index].iconQuality:SetActive(false)
		if self.heroSignIcon[index].isLock then
			self.heroSignIcon[index].iconAdd:SetActive(false)
			self.heroSignIcon[index].iconLock:SetActive(true)
		else
			self.heroSignIcon[index].iconAdd:SetActive(true)
			self.heroSignIcon[index].iconLock:SetActive(false)
		end
	end
end

function PveLineup:RefreshHeroSigns()
	local heroes = PveActorMgr:GetInstance():GetHeros()
	local len = table.count(self.heroSignIcon)
	for index = 1, len do
		local rarity = nil
		if heroes[index] ~= nil then
			local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroes[index].uuid)
			if heroData ~= nil then
				rarity = heroData.rarity
			end
		end
		
		self:SetHeroSignIcon(index,rarity)
	end
end

function PveLineup:HidehHeroSigns()
	--local heroes = PveActorMgr:GetInstance():GetHeros()
	--local len = table.count(self.heroSignIcon)
	--for index = 1, len do
	--	if heroes[index] == nil then
	--		self.heroSignIcon[index].iconAdd:SetActive(false)
	--	end
	--end
	--self:HideAllStandEffect()
	self:HideAllStandAddAndLock()
end

function PveLineup:RefreshEnemySigns(rarities)
	local len = table.count(self.enemySignIcon)
	for index = 1, len do
		local rarity = rarities[index]
		if rarity ~= nil then
			self.enemySignIcon[index].iconQuality:SetActive(true)
			self.enemySignIcon[index].iconQualitySprite:LoadSprite(string.format(LoadPath.UIPve, "pve_img_rarity_" .. rarity))
		else
			self.enemySignIcon[index].iconQuality:SetActive(false)
		end

		--if rarity ~= nil then
		--	local vector1 = SignColors[rarity]['Center']
		--	vector1.w = 1
		--	local vector2 = SignColors[rarity]['Border']
		--	vector2.w = 1
		--
		--	self.m_goMaterBlock:SetVector(self.heroSignPropertyId, vector1)
		--	self.enemySignIcon[index].render1:SetPropertyBlock(self.m_goMaterBlock)
		--	self.m_goMaterBlock:SetVector(self.heroSignPropertyId, vector2)
		--	self.enemySignIcon[index].render2:SetPropertyBlock(self.m_goMaterBlock)
		--end
	end
end


function PveLineup:ShowSelfAttackTimeLine(isOther)
	if self.m_gameObject == nil then
		return
	end
	if self.timelineReq ==nil then
		local model = "Assets/_Art/Effect/prefab/PVE/VFX_pve_skill_timeline.prefab"
		if isOther then
			model = "Assets/_Art/Effect/prefab/PVE/VFX_pve_skill_timeline_guai.prefab"
		end
		self.timelineReq = ResourceManager:InstantiateAsync(model)
		self.timelineReq:completed('+', function()
			if self.timelineReq.isError then
				self.timelineReq = nil
				return
			end
			self.timelineReq.gameObject:SetActive(true)
			self.timelineReq.gameObject.transform:SetParent(self.m_gameObject.transform)
			self.timelineReq.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
			self.timelineReq.gameObject.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, 3)
			local director = self.timelineReq.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.Playables.PlayableDirector))
			if director~=nil then
				local root = director.playableGraph:GetRootPlayable(0)
				if root~=nil then
					if root.SetSpeed~=nil then
						root:SetSpeed(1.0 * PveActorMgr:GetInstance():GetSpeedOffset())
					end
				end
			end
		end)
	end
end

function PveLineup:RemoveTimeLine()
	if self.timelineReq~=nil then
		self.timelineReq:Destroy()
		self.timelineReq = nil
	end
end

return PveLineup
